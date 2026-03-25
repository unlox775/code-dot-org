## CloudFront-generated Request Correlation ID (X-Request-Id)

- **Status**: Draft
- **Owners**: Platform/Infra
- **Goal**: Generate a unique request correlation ID at the CDN edge for every viewer request and pass it downstream as a header so it can be included in all logs (CDN, origin, app) for end-to-end correlation.

### Summary
- Create a unique `X-Request-Id` as early as possible at CloudFront.
- Inject it on the origin-bound request so all downstream layers receive it without impacting cache keys.
- Leverage existing Rails/pegasus behavior to adopt and emit `X-Request-Id` in app logs and responses.
- Optionally surface it back to clients in the response for client-side correlation.

### Why CloudFront Lambda@Edge (origin-request) vs CloudFront Functions
- We must avoid adding the header to the cache key. With our current legacy `ForwardedValues.Headers` model in `lib/cdo/aws/cloudfront.rb`, whitelisting a header both forwards it and includes it in the cache key, which would explode the cache.
- A Lambda@Edge on the `origin-request` event modifies the request after cache key evaluation, forwarding the header to origin without affecting caching.
- CloudFront Functions cannot run on `origin-request` and forwarding a newly-added header from `viewer-request` would require whitelisting (cache fragmentation). Therefore, Lambda@Edge is the correct mechanism here.

### High-level design
- Add a small Node.js Lambda@Edge function attached to all cache behaviors at the `origin-request` event:
  - If `X-Request-Id` already exists on the viewer request, preserve it.
  - Otherwise generate a RFC 4122 UUID v4 and set `X-Request-Id`.
- Do not add `X-Request-Id` to the whitelisted headers in `ForwardedValues.Headers`.
- Keep existing `Accept-Language` CloudFront Function and optional `marketing_router` Lambda@Edge as-is.
- App servers (Rails `ActionDispatch::RequestId`, pegasus) will adopt incoming `X-Request-Id` and emit it in logs and responses automatically. If any service does not, we can add minimal middleware there.

### Lambda@Edge function (origin-request)
```javascript
'use strict';

const { randomUUID } = require('crypto');

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  const incoming = headers['x-request-id'] && headers['x-request-id'][0] && headers['x-request-id'][0].value;
  const requestId = incoming && incoming.trim() ? incoming : randomUUID();

  headers['x-request-id'] = [{ key: 'X-Request-Id', value: requestId }];

  return callback(null, request);
};
```
- Event: `origin-request`
- Runtime: Node.js 18+ (match what Lambda@Edge supports in our account; we currently use Node 22 for `marketing_router`, adjust if needed)
- Memory/timeout: 128MB / 1s

### CloudFormation/IaC changes
- Files to touch:
  - `aws/cloudformation/cloud_formation_stack.yml.erb`
  - `lib/cdo/aws/cloudfront.rb`
  - New code under `aws/cloudformation/lambdas/request-id-injector/index.js`

- Add a packaged Lambda similar to `MarketingRouterLambda`:
  - Function, Version, Alias, and Role with principals `lambda` and `edgelambda` (same role pattern as marketing router).
  - Example skeleton (YAML-ERB shape, kept concise for clarity):
```yaml
RequestIdInjectorLambda:
  Type: AWS::Lambda::Function
  Properties:
    Description: 'Lambda@Edge to inject X-Request-Id on origin-request'
    FunctionName: !Sub "${AWS::StackName}-request-id-injector"
    Code: ./lambdas/request-id-injector
    Handler: index.handler
    Runtime: nodejs18.x
    Role: !GetAtt RequestIdInjectorLambdaRole.Arn
    MemorySize: 128
    Timeout: 1

RequestIdInjectorVersion:
  Type: AWS::Lambda::Version
  Properties:
    FunctionName: !Ref RequestIdInjectorLambda
    Description: 'Versioned for Lambda@Edge association'

RequestIdInjectorAlias:
  Type: AWS::Lambda::Alias
  Properties:
    FunctionName: !Ref RequestIdInjectorLambda
    FunctionVersion: !GetAtt RequestIdInjectorVersion.Version
    Name: LIVE

RequestIdInjectorLambdaRole:
  Type: AWS::IAM::Role
  Properties:
    # Reuse the same policy structure used by MarketingRouterLambdaRole
    # Principals: lambda.amazonaws.com and edgelambda.amazonaws.com
    # Basic execution/logging permissions
    # PermissionsBoundary: !ImportValue IAM-DevPermissions
```

- Attach to all cache behaviors as an additional `LambdaFunctionAssociation` in `lib/cdo/aws/cloudfront.rb`:
  - Extend `function_associations` with a `request_id_injector` mapping:
```ruby
function_associations = {
  accept_language: { EventType: 'viewer-request', FunctionARN: {'Fn::Sub': 'arn:aws:cloudfront::${AWS::AccountId}:function/AcceptLanguage'} },
  marketing_router: { EventType: 'origin-request', LambdaFunctionARN: {Ref: 'MarketingRouterVersion'} },
  request_id_injector: { EventType: 'origin-request', LambdaFunctionARN: {Ref: 'RequestIdInjectorVersion'} }
}
```
  - Include it in `LambdaFunctionAssociations` unconditionally (and keep `marketing_router` conditional):
```ruby
LambdaFunctionAssociations: [
  function_associations[:request_id_injector],
  * (behavior_config[:include_marketing_router_lambda] ? [function_associations[:marketing_router]] : [])
]
```
  - Do not add `X-Request-Id` to `ForwardedValues.Headers`.

### Logging and observability
- **App logs**: Rails `ActionDispatch::RequestId` respects incoming `X-Request-Id` and will propagate it to logs and responses; pegasus can be configured similarly if not already.
- **CloudFront real-time logs**: Our config already includes `cs-headers`, `cs-header-names`. `X-Request-Id` will appear there when present from the viewer; for server-side generated IDs (this design) it appears only on the origin-bound request and not necessarily in viewer header fields. For end-to-end correlation, rely primarily on origin and app logs.
- **Optional**: Add a viewer-response Lambda@Edge that adds the `X-Request-Id` to responses so clients can surface it in their logs/telemetry. This is not required for server-side correlation and can be deferred.

### Rollout plan
- Deploy to an adhoc/test stack:
  - Confirm `curl -I https://<host>/health_check` includes `X-Request-Id` in the response (via Rails echoing it) and application logs show the same value.
  - Confirm that when a client sends an `X-Request-Id`, our Lambda preserves it end-to-end.
- Roll out to staging, then production. Lambda@Edge replication across edge locations typically completes within minutes; expect distribution update propagation time (~5–20 minutes).

### Risk and impact
- **Cache safety**: Safe — header is injected on `origin-request`, post cache-key decision.
- **Latency**: Negligible — trivial Lambda@Edge work, sub-millisecond to a few milliseconds.
- **Cost**: Minimal Lambda@Edge invocations on origin requests.
- **Blast radius**: Low — change is additive and preserves client-provided IDs.

### Alternatives considered
- **CloudFront Functions (viewer-request)**: Would require whitelisting the header to reach origin, which adds it to the cache key with our current config — not acceptable.
- **Origin Request Policy header forwarding**: Same cache-key issue with legacy `ForwardedValues.Headers` in current distribution configuration.
- **AWS X-Ray (`X-Amzn-Trace-Id`)**: Heavier lift across multiple services; valuable but out of scope for this immediate need.

### Effort estimate
- Infra code + function + distribution updates + tests: ~1–2 engineering days.
- Rollout/validation: ~0.5 day.

### Validation checklist
- Generate new ID when absent; preserve when present.
- Confirm origin receives `X-Request-Id` (app server logs).
- Confirm app logs include the ID and responses echo it.
- Confirm CloudFront caching behavior unchanged (hit ratios unaffected).
- Confirm no header appears in cache key/config.

### Next steps
1) Implement Lambda@Edge function under `aws/cloudformation/lambdas/request-id-injector/`.
2) Add CFN resources (Function, Version, Alias, Role) in `aws/cloudformation/cloud_formation_stack.yml.erb` patterned after `MarketingRouterLambda`.
3) Update `lib/cdo/aws/cloudfront.rb` to associate the new Lambda@Edge on `origin-request` for all cache behaviors.
4) Deploy to adhoc, validate, then roll out.
