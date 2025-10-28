# Platform Logging Overview

This document inventories logging across the Code.org platform. It covers what emits logs, where logs go (S3, CloudWatch, syslog), log formats, and how to view them per environment (production, staging, adhoc). Relative links include file+line anchors for traceability.

## Sources that emit logs

- Web/CDN
  - **CloudFront access logs**: CloudFront writes access logs to S3 using per-app prefixes. We enable [distribution logging](../aws/cloudformation/cloud_formation_stack.yml.erb#L414-L419) and set prefixes for each app (see [S3 prefix configuration](../lib/cdo/aws/cloudfront.rb#L41-L53)). Those raw objects land under `cloudfront/<env>-<app>-cdn/` in `cdo-logs`. An S3 event then invokes a small [partition lambda](../aws/cloudformation/s3PartitionCloudFrontLog.js) that moves each object into a partitioned path `cloudfront/<env>-<app>-cdn/year=YYYY/month=MM/day=DD/hour=HH/…` and deletes the original, so that Athena can efficiently scan them using the [Glue/Athena table](../aws/cloudformation/data.yml.erb#L504-L563).
  - **WAF logs (CloudFront WebACL)**: delivered to dedicated S3 bucket `aws-waf-logs-cdo`, modeled in Glue ([definition](../aws/cloudformation/data.yml.erb#L662-L715)).

- Load Balancers
  - **ALB access logs**: enabled to `cdo-logs` with a stack-specific prefix ([attributes](../aws/cloudformation/cloud_formation_stack.yml.erb#L300-L305)). Glue/Athena schema for ELB/ALB logs is provided for querying in Athena ([schema](../aws/cloudformation/data.yml.erb#L350-L420)).

- Application servers (EC2)
  - **Nginx access/error logs**: `/var/log/nginx/access.log`, `/var/log/nginx/error.log` ([nginx config](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)).
  - **Rails (Dashboard) logs**: lograge to CEE format in prod/staging; standard in adhoc ([production](../dashboard/config/environments/production.rb#L71-L72), [staging](../dashboard/config/environments/staging.rb#L69-L70), [adhoc](../dashboard/config/environments/adhoc.rb#L34)).
  - **Browser events forwarded to CloudWatch Logs** via API endpoint: The controller batches browser logs and writes them to a per-environment log group ([controller](../dashboard/app/controllers/browser_events_controller.rb#L4-L13) · [put logs](../dashboard/app/controllers/browser_events_controller.rb#L21-L27) · [guard](../dashboard/app/controllers/browser_events_controller.rb#L54-L57)); the log group/stream are provisioned in infra ([log group](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - **Syslog**: rsyslog writes to a fixed-size `/var/log/syslog` (rotated) ([recipe](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)).
  - **Upload of app logs to S3** hourly: a cron-driven sync pushes `dashboard/log` and `pegasus/log` to S3 ([uploader](../bin/upload-logs-to-s3#L4-L12)); see overview ([doc](./logging.md)).

- Database
  - **Aurora MySQL log exports to CloudWatch Logs**: general, audit, error, slowquery ([exports](../aws/cloudformation/components/database.yml.erb#L334-L339)).
  - **RDS Enhanced Monitoring to CloudWatch Logs**: metric filters create metrics from OS logs ([filters](../aws/cloudformation/data.yml.erb#L235-L275)).
  - MySQL local test cookbooks also log to files for integration tests ([paths](../cookbooks/cdo-mysql/test/cookbooks/test-mysql/templates/default/mysqld.erb#L3-L8)).

- Lambdas and supporting infra
  - CloudFormation Lambdas log to CloudWatch Logs; many use `console.log` (e.g., [Slack notifier](../aws/cloudformation/slackCloudWatchEvent.js), [CloudFront partitioner](../aws/cloudformation/s3PartitionCloudFrontLog.js), [Honeybadger notify](../aws/cloudformation/honeybadgerNotify.js)).
  - Marketing Router Lambda uses structured JSON logging and has CloudWatch permissions ([definition](../aws/cloudformation/cloud_formation_stack.yml.erb#L438-L447) · [policy](../aws/cloudformation/cloud_formation_stack.yml.erb#L459-L476)).

- Security/administration
  - **CloudTrail** to S3 with a Glue/Athena table for query ([table](../aws/cloudformation/data.yml.erb#L452-L503)).
  - **Admin audit log group** `/admin/auditlogs` ([log group](../aws/cloudformation/data.yml.erb#L620-L661)).

## Destinations

- **S3 `cdo-logs` bucket**
  - App instance logs uploaded hourly under `hosts/<hostname>/<app>` ([details](./logging.md#L25-L31)).
  - ALB access logs under `AWSLogs/<accountId>/elasticloadbalancing/<region>/` ([paths](../aws/cloudformation/data.yml.erb#L397) · [L419](../aws/cloudformation/data.yml.erb#L419)).
  - CloudFront access logs under `<env>-<app>-cdn/` and then partitioned for Athena ([prefixes](../lib/cdo/aws/cloudfront.rb#L41-L62) · [table](../aws/cloudformation/data.yml.erb#L523-L555)).
- **CloudWatch Logs**
  - Browser events per-environment log group `<env>-browser-events` ([infra](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - RDS Enhanced Monitoring: `RDSOSMetrics` and metric filters ([filters](../aws/cloudformation/data.yml.erb#L235-L275)).
  - Lambda logs for various helper functions.
  - Admin audit logs `/admin/auditlogs` ([log group](../aws/cloudformation/data.yml.erb#L620-L661)).
- **EC2 instance filesystem**
  - `/var/log/syslog` (rotated fixed size) via rsyslog ([recipe](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)).
  - `/var/log/nginx/access.log` and `/var/log/nginx/error.log` ([nginx config](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)).
  - Rails app logs in `dashboard/log` and `pegasus/log` uploaded hourly ([overview](./logging.md#L9) · [sync](./logging.md#L25-L31)).

## Log formats

- **CloudFront access logs**: Standard TSV; Athena schema shows the columns ([schema](../aws/cloudformation/data.yml.erb#L524-L553)).
- **ALB access logs**: Standard ELB/ALB CSV; schema shows the columns ([schema](../aws/cloudformation/data.yml.erb#L372-L396)).
- **Browser events**: JSON lines written to CloudWatch Logs ([writer](../dashboard/app/controllers/browser_events_controller.rb#L21-L27) · [context](../dashboard/app/controllers/browser_events_controller.rb#L72-L81)).
- **Rails (lograge CEE)** in prod/staging, standard logs in adhoc (`dashboard/config/environments/*`).
- **Syslog**: standard syslog format.
- **Nginx**: default access/error formats unless overridden.

## Environments and paths

- **Production**
  - CloudFront prefixes: `production-pegasus-cdn`, `production-dashboard-cdn`, `production-hourofcode-cdn` ([prefixes](../lib/cdo/aws/cloudfront.rb#L41-L63)).
  - ALB access logs: `s3://cdo-logs/AWSLogs/<account>/elasticloadbalancing/<region>/...`.
  - Browser events: log group `production-browser-events` ([infra](../aws/cloudformation/components/logging.yml.erb#L1-L13)).
  - Admin audit logs: `/admin/auditlogs`.
- **Staging/Test/Levelbuilder**
  - CloudFront prefixes follow `<env>-<app>-cdn`.
  - Browser events: `<env>-browser-events`.
  - ALB logs under environment-specific stack prefix.
- **Adhoc**
  - Browser events group uses stack name prefix ([adhoc variant](../aws/cloudformation/components/logging.yml.erb#L5-L13)).
  - Logs uploaded under `hosts/<adhoc-hostname>/<app>`.

## How to view logs

- **CloudFront access logs**
  - S3: `s3://cdo-logs/cloudfront/<env>-<app>-cdn/` (partitioned to year/month/day/hour).
  - Athena: table `cloudfront_logs` in Glue DB ([table](../aws/cloudformation/data.yml.erb#L504-L563)).
- **ALB access logs**
  - S3: `s3://cdo-logs/production-codeorg/AWSLogs/<account>/elasticloadbalancing/<region>/...`.
  - Athena: table `elb_logs_us_east_1` in Glue DB `elb_logs` ([table](../aws/cloudformation/data.yml.erb#L350-L420)).
- **Browser events**
  - CloudWatch Logs: log group `<env>-browser-events`, stream `<env>` ([infra](../aws/cloudformation/components/logging.yml.erb#L1-L13)); emitted by the app ([writer](../dashboard/app/controllers/browser_events_controller.rb#L21-L27)).
- **Nginx and application logs**
  - On instance: `/var/log/nginx/*`, app logs under `dashboard/log` and `pegasus/log`.
  - S3: hourly sync to `s3://cdo-logs/hosts/<hostname>/<app>` ([sync](../bin/upload-logs-to-s3#L4-L12)).
- **Database logs**
  - CloudWatch Logs groups for general/audit/error/slowquery (exported by Aurora) ([exports](../aws/cloudformation/components/database.yml.erb#L334-L339)).
  - Enhanced monitoring metrics in CloudWatch (`RDSOSMetrics`) ([filters](../aws/cloudformation/data.yml.erb#L235-L275)).
- **CloudTrail**
  - S3: `s3://<LogsBucket>/AWSLogs/<account>/CloudTrail/`.
  - Athena: `cloudtrail` table ([table](../aws/cloudformation/data.yml.erb#L436-L503)).
- **WAF**
  - S3: `s3://aws-waf-logs-cdo/AWSLogs/<account>/WAFLogs/cloudfront/code-dot-org/`.
  - Athena: `waf_logs_code_dot_org` table in `waf_logs_db` ([table](../aws/cloudformation/data.yml.erb#L662-L715)).

## Typical Studio request: what logs are emitted and where to view

For an average `studio.code.org` request (e.g., signed-in user viewing a level):

- CloudFront request/response logged to S3 under `cloudfront/production-dashboard-cdn/` and queryable via Athena.
- ALB request/response logged to S3 `AWSLogs/<account>/elasticloadbalancing/us-east-1/` and queryable via Athena.
- Nginx access log on instance (`/var/log/nginx/access.log`), later synced to S3 under `hosts/<hostname>/dashboard`.
- Rails request log (lograge CEE) in `dashboard/log/production.log`, synced hourly to S3.
- Browser events (if client reports) go to CloudWatch Logs group `production-browser-events`.
- Database slow queries/errors surfaced in Aurora CloudWatch Logs if applicable.

Steps to view:
- Use Athena saved tables to query CloudFront and ALB access patterns by time and path.
- Check CloudWatch Logs group `production-browser-events` for frontend errors/metrics related to the session.
- If needed, pull latest app logs from `s3://cdo-logs/hosts/<hostname>/dashboard` for deeper Rails or Nginx details.

## Notes and gaps

- External repos `java-builder` and `ai-proxy` could not be cloned anonymously from GitHub; add their logging details once access is provided.
- Some older docs exist in [docs/logging.md](./logging.md) about hourly S3 upload and rotation.
