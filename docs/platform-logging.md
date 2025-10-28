# Platform Logging Overview

This document inventories logging across the Code.org platform. It explains, in plain English, what emits logs during common operations, where those logs go (S3, CloudWatch, syslog), how they’re formatted, and how to view them across environments. Inline links point to the exact code and templates that configure each behavior.

## Sources that emit logs

- Web/CDN
  - **CloudFront access logs and WAF decisions**: Every request hits CloudFront first. CloudFront records request/response metadata to S3 using per‑app prefixes, enabled via [distribution logging](../aws/cloudformation/cloud_formation_stack.yml.erb#L414-L419) with per‑environment prefixes set in [S3 prefix configuration](../lib/cdo/aws/cloudfront.rb#L41-L53). Requests blocked or allowed by the CloudFront WebACL are also captured in WAF logs written to a dedicated bucket and modeled for Athena ([WAF logs table](../aws/cloudformation/data.yml.erb#L662-L715)). To optimize analytics, an S3 event triggers a small [partition lambda](../aws/cloudformation/s3PartitionCloudFrontLog.js) that moves each raw CloudFront log object from the initial drop path into `year=/month=/day=/hour=` partitions and deletes the original, matching the [Glue/Athena table](../aws/cloudformation/data.yml.erb#L504-L563) so queries scan only the needed partitions.

- Load Balancers
  - **ALB access logs**: After CloudFront, requests that reach the Application Load Balancer are logged with full request/target/latency details. Logging is enabled directly on the ALB via [access log attributes](../aws/cloudformation/cloud_formation_stack.yml.erb#L300-L305), and those CSV logs are written to S3 under the standard `AWSLogs/<account>/<region>/elasticloadbalancing/` prefixes. We define an Athena schema so you can query ALB traffic efficiently ([ELB/ALB schema](../aws/cloudformation/data.yml.erb#L350-L420)).

- Application servers (EC2)
  - **NGINX reverse proxy**: On each frontend EC2 instance, NGINX terminates connections from the ALB and proxies to Puma. It writes request and error lines to `/var/log/nginx/access.log` and `/var/log/nginx/error.log` ([nginx config](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)).
  - **Puma app servers (Dashboard and Pegasus)**: We run two separate Puma applications behind NGINX. Rails logs are condensed via Lograge in production and staging and standard in adhoc ([production](../dashboard/config/environments/production.rb#L71-L72), [staging](../dashboard/config/environments/staging.rb#L69-L70), [adhoc](../dashboard/config/environments/adhoc.rb#L34)). Those Rails logs are written under each app’s `log/` directory and then synced to S3 hourly by our uploader.
  - **Browser events**: Client‑side code can POST structured events that the server batches and writes to a per‑environment CloudWatch Logs group ([controller entrypoint](../dashboard/app/controllers/browser_events_controller.rb#L4-L13) and [publisher](../dashboard/app/controllers/browser_events_controller.rb#L21-L27)). The log group and stream are provisioned per environment ([log group/stream](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - **Cron jobs and background tasks**: Many scheduled tasks load the main Rails stack and therefore log exactly like the web app (same formatter and destinations). In addition, an hourly job syncs local app logs to S3 so operational history is preserved ([hourly uploader](../bin/upload-logs-to-s3#L4-L12); overview in [log upload doc](./logging.md)).
  - **Syslog on instances**: System‑level events are written to a fixed‑size `/var/log/syslog` managed by rsyslog to provide a rolling buffer of OS‑level diagnostics ([rsyslog recipe](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)).

- Database
  - **Aurora MySQL logs**: The cluster exports general, audit, error, and slow query logs to CloudWatch Logs for centralized visibility ([log exports](../aws/cloudformation/components/database.yml.erb#L334-L339)). We also create metric filters for RDS Enhanced Monitoring so OS metrics become first‑class CloudWatch metrics ([enhanced monitoring filters](../aws/cloudformation/data.yml.erb#L235-L275)). For local test coverage, the MySQL cookbooks demonstrate file‑based logging ([example paths](../cookbooks/cdo-mysql/test/cookbooks/test-mysql/templates/default/mysqld.erb#L3-L8)).

- Lambdas and supporting infra
  - **Infrastructure Lambdas**: Supporting Lambdas (e.g., CloudFront log partitioner, Slack notifiers, Honeybadger hooks) write runtime output to CloudWatch Logs like standard AWS Lambdas (see examples: [Slack notifier](../aws/cloudformation/slackCloudWatchEvent.js), [CloudFront partitioner](../aws/cloudformation/s3PartitionCloudFrontLog.js), [Honeybadger notify](../aws/cloudformation/honeybadgerNotify.js)). The marketing router Lambda uses JSON logging and has explicit CloudWatch permissions ([definition](../aws/cloudformation/cloud_formation_stack.yml.erb#L438-L447) and [policy](../aws/cloudformation/cloud_formation_stack.yml.erb#L459-L476)).

- Security/administration
  - **CloudTrail** records AWS API activity and delivers JSON logs to S3; we expose them in Athena via a table definition ([CloudTrail table](../aws/cloudformation/data.yml.erb#L452-L503)). Administrative audit trails also live in a dedicated log group ([admin audit logs](../aws/cloudformation/data.yml.erb#L620-L661)).

## Destinations

- **S3 `cdo-logs` bucket**
  - App instance logs are synced hourly under `hosts/<hostname>/<app>` ([upload details](./logging.md#L25-L31)).
  - ALB access logs land under the standard AWS pathing and are queryable in Athena ([ALB/ELB schema](../aws/cloudformation/data.yml.erb#L350-L420)).
  - CloudFront access logs arrive under `<env>-<app>-cdn/`, then the partition Lambda rewrites them into date/hour partitions for Athena ([prefixes](../lib/cdo/aws/cloudfront.rb#L41-L62); [partitioned table](../aws/cloudformation/data.yml.erb#L504-L563)).

- **CloudWatch Logs**
  - Browser events are grouped by environment in `<env>-browser-events` ([log group/stream](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - Aurora exports (general/audit/error/slowquery) appear in dedicated log groups ([exports](../aws/cloudformation/components/database.yml.erb#L334-L339)).
  - Enhanced monitoring metrics originate from the `RDSOSMetrics` log stream with metric filters ([filters](../aws/cloudformation/data.yml.erb#L235-L275)).
  - Infrastructure Lambdas log execution output by default.
  - Administrative audit logs live under `/admin/auditlogs` ([log group](../aws/cloudformation/data.yml.erb#L620-L661)).

- **EC2 instance filesystem**
  - NGINX writes to `/var/log/nginx/access.log` and `/var/log/nginx/error.log` ([nginx config](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)).
  - Rails application logs live under each app’s `log/` directory and are synced hourly to S3 ([uploader](../bin/upload-logs-to-s3#L4-L12)).
  - System‑level events are buffered in `/var/log/syslog` ([rsyslog recipe](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)).

## Log formats

- **CloudFront access logs**: Tab‑separated values with the canonical CloudFront fields ([Athena schema](../aws/cloudformation/data.yml.erb#L524-L553)).
- **ALB access logs**: CSV with request/target/latency fields ([Athena schema](../aws/cloudformation/data.yml.erb#L372-L396)).
- **Browser events**: JSON lines published by the server to CloudWatch Logs ([publisher](../dashboard/app/controllers/browser_events_controller.rb#L21-L27) and [decorator](../dashboard/app/controllers/browser_events_controller.rb#L72-L81)).
- **Rails**: Lograge CEE in prod/staging, standard logs in adhoc (see environment configs above).
- **Syslog/NGINX**: Traditional syslog and nginx formats unless overridden.

## Environments and paths

- **Production**
  - CloudFront prefixes: `production-pegasus-cdn`, `production-dashboard-cdn`, `production-hourofcode-cdn` ([prefixes](../lib/cdo/aws/cloudfront.rb#L41-L63)).
  - ALB access logs: `s3://cdo-logs/AWSLogs/<account>/elasticloadbalancing/<region>/...`.
  - Browser events: `production-browser-events` ([log group](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - Admin audit logs: `/admin/auditlogs`.
- **Staging/Test/Levelbuilder** follow the same patterns with `<env>` prefixes.
- **Adhoc** uses a stack‑name‑prefixed browser events group and uploads logs per adhoc hostname ([adhoc variant](../aws/cloudformation/components/logging.yml.erb#L5-L13)).

## How to view logs

- **CloudFront access logs**: Browse S3 `cloudfront/<env>-<app>-cdn/` (partitioned), or query via Athena using the `cloudfront_logs` table ([table](../aws/cloudformation/data.yml.erb#L504-L563)).
- **ALB access logs**: Browse S3 `AWSLogs/<account>/elasticloadbalancing/<region>/...`, or query via Athena using `elb_logs_us_east_1` in the `elb_logs` DB ([table](../aws/cloudformation/data.yml.erb#L350-L420)).
- **Browser events**: Open the `<env>-browser-events` log group in CloudWatch Logs ([log group](../aws/cloudformation/components/logging.yml.erb#L1-L13)); entries are JSON.
- **NGINX/Rails app logs**: Check instance files for immediate debugging; for historical view, inspect S3 under `hosts/<hostname>/<app>` ([uploader](../bin/upload-logs-to-s3#L4-L12)).
- **Database logs**: View Aurora export log groups in CloudWatch; RDSOSMetrics‑derived metrics appear in CloudWatch Metrics ([exports](../aws/cloudformation/components/database.yml.erb#L334-L339); [filters](../aws/cloudformation/data.yml.erb#L235-L275)).
- **CloudTrail/WAF**: Query via Athena tables for audit and security analysis ([CloudTrail](../aws/cloudformation/data.yml.erb#L452-L503); [WAF](../aws/cloudformation/data.yml.erb#L662-L715)).

## Typical Studio request: what logs are emitted and where to view

When a signed‑in user views a level at `studio.code.org`:

- CloudFront logs the request/response; if the WebACL blocks it, the WAF log records the decision.
- ALB logs the request and target response.
- On the instance, NGINX writes an access line and proxies to the appropriate Puma app; Rails (via Lograge in prod/staging) records a condensed application line. Cron‑triggered tasks that run during the same window write through the same Rails logger, so their events appear alongside web requests.
- Browser‑side events (if enabled) are batched and written to the `<env>-browser-events` CloudWatch log group.
- Aurora emits slow/error/general/audit entries to CloudWatch Logs as relevant.
- Hourly, instance app logs are synced to S3 for long‑term retention.

Read across the sections above to locate each artifact and the linked infrastructure/app code that configures it.

## Notes and gaps

- External repos (e.g., Java Builder, AI Proxy) are not included here due to access limits. If added, they will follow the same CloudFront/ALB/CloudWatch/S3 patterns and typically log to CloudWatch Logs and/or S3 with service‑specific prefixes.
- Historical doc on hourly S3 upload/rotation: [docs/logging.md](./logging.md).
