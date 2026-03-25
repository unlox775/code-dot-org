# Infrastructure Repository PR

**Title:** `Add Private Production Deploy AWS Infrastructure`

**Description:**
```markdown
## Overview
Adds AWS infrastructure to support the private production deploy workflow for Code.org security fixes. This includes Lambda functions, API Gateway, and CloudFormation templates.

## Purpose
Enables private development and deployment of security fixes before public disclosure, addressing the vulnerability window created by our public repository.

## Infrastructure Components

### CloudFormation Stack
- **File**: `aws/private-production-deploy/cloudformation.yml`
- **Components**:
  - API Gateway for GitHub webhook endpoint
  - Lambda function for syncing public → private repo
  - IAM roles with least privilege access
  - Secrets Manager for GitHub tokens and webhook secrets
  - CloudWatch Events for daily warning about uncommitted changes

### Lambda Functions
- **File**: `aws/private-production-deploy/lambda/index.js`
- **Purpose**: Syncs public production commits to private production repo
- **Security**: GitHub webhook signature verification, API key authentication
- **Features**: Repository verification, branch verification, conflict handling

### Manual Back-Sync Script
- **File**: `scripts/private_production_sync.py`
- **Purpose**: Interactive tool to cherry-pick private changes back to public repo
- **Features**: 
  - Interactive commit selection
  - Conflict testing on both production and staging
  - Automatic PR creation using `gh` CLI
  - Safety checks and rollback on conflicts

## Security Architecture
- **Webhook Verification**: HMAC-SHA1 signature verification (same pattern as marketing site)
- **API Key Authentication**: Stored in GitHub secrets
- **Repository Verification**: Only accepts from `code-dot-org/code-dot-org`
- **Branch Verification**: Only processes `production` branch pushes

## Usage Examples

### Interactive Back-Sync
```bash
# Select commits interactively
./private_production_sync.py

# Specify specific commit hashes
./private_production_sync.py --commits abc123,def456

# Sync to specific branch only
./private_production_sync.py --production
```

### API Endpoint
```bash
# GitHub Actions will call this endpoint
POST https://api-gateway-url/prod/sync
Authorization: Bearer <api-key>
X-Hub-Signature: sha1=<signature>
X-GitHub-Event: push
```

## Deployment
1. Deploy CloudFormation stack
2. Configure GitHub secrets:
   - `PRIVATE_PRODUCTION_API_KEY`
   - `PRIVATE_PRODUCTION_WEBHOOK_SECRET`
   - `PRIVATE_PRODUCTION_LAMBDA_URL`
3. Create `code-dot-org-production` private repository
4. Set up GitHub app/tokens for Lambda access

## Related Code.org PR
This infrastructure works in conjunction with changes in the main Code.org repository.

## Monitoring
- Daily CloudWatch Events trigger warning about uncommitted private changes
- Lambda logs all sync operations
- API Gateway logs all webhook calls
```