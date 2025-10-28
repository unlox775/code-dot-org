# Platform Logging Overview

This document inventories logging across the Code.org platform. It covers what emits logs, where logs go (S3, CloudWatch, syslog), log formats, and how to view them per environment (production, staging, adhoc). Relative links include file+line anchors for traceability.

## Sources that emit logs

- Web/CDN
  - **CloudFront access logs**: configured to `cdo-logs` with per-app prefixes
    - cloudfront config and S3 bucket/prefix
      - [lib/cdo/aws/cloudfront.rb](../lib/cdo/aws/cloudfront.rb#L41-L53) for pegasus/dashboard prefixes
      - [aws/cloudformation/cloud_formation_stack.yml.erb](../aws/cloudformation/cloud_formation_stack.yml.erb#L414-L419) adds distribution config
    - real-time log config and delivery to S3 via Lambda partitioner
      - [aws/cloudformation/standalone/access_logs/access_logs.yml](../aws/cloudformation/standalone/access_logs/access_logs.yml) (CloudFront real-time log config)
      - [aws/cloudformation/s3PartitionCloudFrontLog.js](../aws/cloudformation/s3PartitionCloudFrontLog.js) Lambda to partition logs
  - **WAF logs (CloudFront WebACL)**: delivered to dedicated S3 bucket `aws-waf-logs-cdo`, modeled in Glue
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L662-L715)

- Load Balancers
  - **ALB access logs**: enabled to `cdo-logs` with stack-specific prefix
    - [aws/cloudformation/cloud_formation_stack.yml.erb](../aws/cloudformation/cloud_formation_stack.yml.erb#L300-L305)
  - Glue/Athena schema for ELB/ALB logs (query in Athena)
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L350-L420)

- Application servers (EC2)
  - **Nginx access/error logs**: `/var/log/nginx/access.log`, `/var/log/nginx/error.log`
    - [cookbooks/cdo-nginx/templates/default/nginx.conf.erb](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)
  - **Rails (Dashboard) logs**: lograge to CEE format in prod/staging; standard in adhoc
    - [dashboard/config/environments/production.rb](../dashboard/config/environments/production.rb#L71-L72)
    - [dashboard/config/environments/staging.rb](../dashboard/config/environments/staging.rb#L69-L70)
    - [dashboard/config/environments/adhoc.rb](../dashboard/config/environments/adhoc.rb#L34)
  - **Browser events forwarded to CloudWatch Logs** via API endpoint
    - Controller pushing to CloudWatch Logs
      - [dashboard/app/controllers/browser_events_controller.rb](../dashboard/app/controllers/browser_events_controller.rb#L4-L13) · [L21-L27](../dashboard/app/controllers/browser_events_controller.rb#L21-L27) · [L54-L57](../dashboard/app/controllers/browser_events_controller.rb#L54-L57)
    - Log group/stream provisioned per env/adhoc
      - [aws/cloudformation/components/logging.yml.erb](../aws/cloudformation/components/logging.yml.erb#L1-L13)
  - **Syslog**: rsyslog writes to fixed-size `/var/log/syslog` (rotated)
    - [cookbooks/cdo-syslog/recipes/default.rb](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)
  - **Upload of app logs to S3** hourly
    - [bin/upload-logs-to-s3](../bin/upload-logs-to-s3#L4-L12)
    - [docs/logging.md](./logging.md) describes cron + rotation behavior

- Database
  - **Aurora MySQL log exports to CloudWatch Logs**: general, audit, error, slowquery
    - [aws/cloudformation/components/database.yml.erb](../aws/cloudformation/components/database.yml.erb#L334-L339)
  - **RDS Enhanced Monitoring to CloudWatch Logs** metric filters
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L235-L275)
  - MySQL local test cookbooks also log to files (general, error) for integration tests
    - [cookbooks/cdo-mysql/test/cookbooks/test-mysql/templates/default/mysqld.erb](../cookbooks/cdo-mysql/test/cookbooks/test-mysql/templates/default/mysqld.erb#L3-L8)

- Lambdas and supporting infra
  - CloudFormation Lambdas log to CloudWatch Logs; many use `console.log`
    - Examples: [aws/cloudformation/slackCloudWatchEvent.js](../aws/cloudformation/slackCloudWatchEvent.js), [.../s3PartitionCloudFrontLog.js](../aws/cloudformation/s3PartitionCloudFrontLog.js), [.../honeybadgerNotify.js](../aws/cloudformation/honeybadgerNotify.js)
  - Marketing Router Lambda uses structured JSON logging and has CloudWatch permissions
    - [aws/cloudformation/cloud_formation_stack.yml.erb](../aws/cloudformation/cloud_formation_stack.yml.erb#L438-L447) · [L459-L476](../aws/cloudformation/cloud_formation_stack.yml.erb#L459-L476)

- Security/administration
  - **CloudTrail** to S3 and Glue/Athena table
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L452-L503)
  - **Admin audit log group** `/admin/auditlogs`
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L620-L661)

## Destinations

- **S3 `cdo-logs` bucket**
  - App instance logs uploaded hourly under `hosts/<hostname>/<app>`
    - [docs/logging.md](./logging.md#L25-L31)
  - ALB access logs under `AWSLogs/<accountId>/elasticloadbalancing/<region>/`
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L397) · [L419](../aws/cloudformation/data.yml.erb#L419)
  - CloudFront access logs under `<env>-<app>-cdn/` and partitioned
    - [lib/cdo/aws/cloudfront.rb](../lib/cdo/aws/cloudfront.rb#L41-L62)
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L523-L555)
- **CloudWatch Logs**
  - Browser events per-environment log group `<env>-browser-events`
    - [aws/cloudformation/components/logging.yml.erb](../aws/cloudformation/components/logging.yml.erb#L1-L13)
  - RDS Enhanced Monitoring: `RDSOSMetrics` and metric filters
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L235-L275)
  - Lambda logs for various helper functions
  - Admin audit logs `/admin/auditlogs`
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L620-L661)
- **EC2 instance filesystem**
  - `/var/log/syslog` (rotated fixed size) via rsyslog
    - [cookbooks/cdo-syslog/recipes/default.rb](../cookbooks/cdo-syslog/recipes/default.rb#L16-L35)
  - `/var/log/nginx/access.log` and `/var/log/nginx/error.log`
    - [cookbooks/cdo-nginx/templates/default/nginx.conf.erb](../cookbooks/cdo-nginx/templates/default/nginx.conf.erb#L19-L20)
  - Rails app logs in `dashboard/log` and `pegasus/log` uploaded hourly
    - [docs/logging.md](./logging.md#L9) · [L25-L31](./logging.md#L25-L31)

## Log formats

- **CloudFront access logs**: Standard CloudFront TSV log fields
  - Athena schema definition shows columns
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L524-L553)
- **ALB access logs**: Standard ELB/ALB CSV
  - Athena schema definition shows columns
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L372-L396)
- **Browser events**: JSON lines written to CloudWatch Logs
  - [dashboard/app/controllers/browser_events_controller.rb](../dashboard/app/controllers/browser_events_controller.rb#L21-L27) · [L72-L81](../dashboard/app/controllers/browser_events_controller.rb#L72-L81)
- **Rails (lograge CEE)** in prod/staging, standard logs in adhoc
  - `dashboard/config/environments/*`
- **Syslog**: standard syslog format
- **Nginx**: default access/error formats unless overridden

## Environments and paths

- **Production**
  - CloudFront prefixes: `production-pegasus-cdn`, `production-dashboard-cdn`, `production-hourofcode-cdn`
    - [lib/cdo/aws/cloudfront.rb](../lib/cdo/aws/cloudfront.rb#L41-L63)
  - ALB access logs: `s3://cdo-logs/AWSLogs/<account>/elasticloadbalancing/<region>/...`
  - Browser events: log group `production-browser-events`
    - [aws/cloudformation/components/logging.yml.erb](../aws/cloudformation/components/logging.yml.erb#L1-L13)
  - Admin audit logs: `/admin/auditlogs`
- **Staging/Test/Levelbuilder**
  - CloudFront prefixes follow `<env>-<app>-cdn`
  - Browser events: `<env>-browser-events`
  - ALB logs under environment-specific stack prefix
- **Adhoc**
  - Browser events group uses stack name prefix
    - [aws/cloudformation/components/logging.yml.erb](../aws/cloudformation/components/logging.yml.erb#L5-L13)
  - Logs uploaded under `hosts/<adhoc-hostname>/<app>`

## How to view logs

- **CloudFront access logs**
  - S3: `s3://cdo-logs/cloudfront/<env>-<app>-cdn/` (partitioned to year/month/day/hour)
  - Athena: Table `cloudfront_logs` in Glue DB; query via Athena Console
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L504-L563)
- **ALB access logs**
  - S3: `s3://cdo-logs/production-codeorg/AWSLogs/<account>/elasticloadbalancing/<region>/...`
  - Athena: Table `elb_logs_us_east_1` in Glue DB `elb_logs`
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L350-L420)
- **Browser events**
  - CloudWatch Logs: log group `<env>-browser-events`, stream `<env>`
    - [aws/cloudformation/components/logging.yml.erb](../aws/cloudformation/components/logging.yml.erb#L1-L13)
    - Emitted by `BrowserEventsController`
      - [dashboard/app/controllers/browser_events_controller.rb](../dashboard/app/controllers/browser_events_controller.rb#L21-L27)
- **Nginx and application logs**
  - On instance: `/var/log/nginx/*`, app logs under `dashboard/log` and `pegasus/log`
  - S3: hourly sync to `s3://cdo-logs/hosts/<hostname>/<app>`
    - [bin/upload-logs-to-s3](../bin/upload-logs-to-s3#L4-L12)
- **Database logs**
  - CloudWatch Logs groups for general/audit/error/slowquery (exported by Aurora)
    - [aws/cloudformation/components/database.yml.erb](../aws/cloudformation/components/database.yml.erb#L334-L339)
  - Enhanced monitoring metrics in CloudWatch (RDSOSMetrics)
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L235-L275)
- **CloudTrail**
  - S3: `s3://<LogsBucket>/AWSLogs/<account>/CloudTrail/`
  - Athena: `cloudtrail` table
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L436-L503)
- **WAF**
  - S3: `s3://aws-waf-logs-cdo/AWSLogs/<account>/WAFLogs/cloudfront/code-dot-org/`
  - Athena: `waf_logs_code_dot_org` table in `waf_logs_db`
    - [aws/cloudformation/data.yml.erb](../aws/cloudformation/data.yml.erb#L662-L715)

## Typical Studio request: what logs are emitted and where to view

For an average `studio.code.org` request (e.g., signed-in user viewing a level):

- CloudFront request/response logged to S3 under `cloudfront/production-dashboard-cdn/` and queryable via Athena
- ALB request/response logged to S3 `AWSLogs/<account>/elasticloadbalancing/us-east-1/` and queryable via Athena
- Nginx access log on instance (`/var/log/nginx/access.log`), later synced to S3 under `hosts/<hostname>/dashboard`
- Rails request log (lograge CEE) in `dashboard/log/production.log`, synced hourly to S3
- Browser events (if client reports) go to CloudWatch Logs group `production-browser-events`
- Database slow queries/errors surfaced in Aurora CloudWatch Logs if applicable

Steps to view:
- Use Athena saved tables to query CloudFront and ALB access patterns by time and path.
- Check CloudWatch Logs group `production-browser-events` for frontend errors/metrics related to the session.
- If needed, pull latest app logs from `s3://cdo-logs/hosts/<hostname>/dashboard` for deeper Rails or Nginx details.

## Notes and gaps

- External repos `java-builder` and `ai-proxy` could not be cloned anonymously from GitHub; add their logging details once access is provided.
- Some older docs exist in [docs/logging.md](./logging.md) about hourly S3 upload and rotation.
