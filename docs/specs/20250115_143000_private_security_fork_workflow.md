# Private Production Deploy Workflow Specification

**Date**: January 15, 2025  
**Author**: AI Assistant  
**Status**: Draft  
**Related**: BC-88 Local File Read vulnerability, P1 security fixes

## Problem Statement

Code.org faces a critical security challenge: their public repository exposes every security fix as soon as it's committed, creating a window of vulnerability between when a fix is developed and when it's deployed to production. This is particularly problematic given:

1. **AI-powered vulnerability scanners** are continuously monitoring public repositories
2. **Recent P1 vulnerabilities** (like BC-88 Local File Read) demonstrate the risk
3. **Public transparency** is valued but creates security exposure
4. **Current workflow** requires public commits before production deployment


## Current Architecture Analysis

### Current Deployment Process
**Current Flow**: `staging` → `production` (public) → AMI Builder → Production Deployment

1. **Code Push**: Changes pushed to `production` branch on public repo
2. **AMI Builder**: [`aws/ci_build`](../../aws/ci_build) polls for changes every minute
3. **Build Process**: Runs `infra:ci` rake task to build AMI
4. **Deployment**: AMI deployed to production servers (`production-console`, `production-daemon`)

### Review of Key Components
- **AMI Builder**: [`aws/ci_build`](../../aws/ci_build) - Polls public `production` branch every minute
- **AMI Manager**: [`aws/cloudformation/ami-manager.js`](../../aws/cloudformation/ami-manager.js) - Lambda for AMI creation
- **Build Process**: `lib/rake/ci.rake` and `lib/rake/build.rake` - CI testing and build
- **Production Servers**: `production-console`, `production-daemon` - Target deployment servers

## Proposed Solution: Private Production Deploy

### Architecture Design

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Public Repo   │    │  Private Production │  │   Production    │
│  (code-dot-org) │    │      Deploy       │    │   Deployment    │
│                 │    │ (code-dot-org-   │    │                 │
│ staging branch  │───▶│  production)     │───▶│   AWS/Cloud     │
│ production      │    │                  │    │                 │
│                 │    │ security fixes   │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Implementation Plan

### Phase 1: Set Up and Monitor (Verification Phase)
**Goal**: Set up private repo sync but don't use it yet - just monitor and verify

1. **Create Private Fork**: `code-dot-org-production` repository
2. **Set Up Auto-Sync**: Lambda function that syncs public `production` → private `production` on every push
3. **Add Verification**: AMI Builder sleeps 5 minutes, then verifies private change matches public change
4. **Monitor for Weeks**: Verify sync is working correctly before switching
5. **Security Verification**: Ensure private repo access is properly restricted

**Current Flow**: `staging` → `production` (public) → AMI Builder → Production
**Phase 1 Flow**: `staging` → `production` (public) → **Sync Lambda** → `production` (private) → **AMI Builder (monitor only)** → Production

### Phase 2: Switch to Private Deploy
**Goal**: Actually switch AMI Builder to watch private repo instead of public

1. **Switch AMI Builder**: Point [`aws/ci_build`](../../aws/ci_build) to watch private repo
2. **Add Reverse Check**: Verify private and public repos are in sync, alert if different
3. **Test Normal Flow**: Verify normal deployments work identically
4. **Add Daily Warning**: Slack notification about uncommitted private changes

**New Flow**: `staging` → `production` (public) → **Sync Lambda** → `production` (private) → AMI Builder → Production

### Phase 3: Test Security Workflow
**Goal**: Test complete security fix workflow

1. **Test Security Fix**: Push security fix directly to private `production` branch
2. **Verify Deployment**: Ensure AMI Builder picks up and deploys the change
3. **Test Back-Sync**: Manual back-sync after verification period
4. **Create Security Scripts**: Tools for easier security fix management
5. **Team Training**: Train security team on new procedures

## Code Changes Required

### 1. Private Production Deploy CloudFormation Stack
**File**: [`infrastructure/aws/private-production-deploy-stack.yml`](../../infrastructure/aws/private-production-deploy-stack.yml)

**Purpose**: Complete infrastructure setup for private production deploy
**Includes**: 
- AWS Lambda sync function (syncs public → private on every push)
- Daily warning Lambda (Slack alerts about uncommitted changes)
- IAM roles and Secrets Manager for GitHub access
- CloudWatch Events for scheduling

The sync Lambda handles:
```javascript
// 1. Verify webhook signature
// 2. Fetch latest from public production  
// 3. Check for merge conflicts
// 4. Merge to private production
// 5. Notify on success/failure
```

### 2. Modified AMI Builder Configuration
**File**: [`aws/ci_build`](../../aws/ci_build)

**Phase 1 Changes**: Add verification logic
```ruby
# Phase 1: Monitor mode - verify private matches public
if ENV['PRIVATE_DEPLOY_MONITOR'] == 'true'
  sleep(300) # Wait 5 minutes for sync
  verify_private_matches_public()
end

# Phase 2: Switch to private repo
REPO_URL = 'https://github.com/code-dot-org/code-dot-org-production.git'
```

### 3. Daily Warning Job
**File**: [`infrastructure/aws/private-production-deploy-stack.yml`](../../infrastructure/aws/private-production-deploy-stack.yml) (part of stack)

**Purpose**: Daily warning about uncommitted private changes
**Schedule**: CloudWatch Events (daily at 2 AM)
**Notification**: Slack alert to infrastructure channel
**Reason**: No automatic back-sync to allow verification period

### 4. Manual Back-Sync Script
**File**: [`infrastructure/scripts/private_production_sync.rb`](../../infrastructure/scripts/private_production_sync.rb)

**Purpose**: Human-initiated back-sync from private to public
- `sync_to_public()` - Manual sync to public repo
- `create_security_branch()` - Create isolated security fix branches
- `merge_security_fix()` - Merge security fixes to production


## Access Control & Security

### Repository Access Levels
- **Infrastructure Team**: Full admin access to private production repo
- **Engineering Managers**: Full admin access to private production repo
- **All Engineers**: Read access to private production repo (can review PRs, look at code)
- **AMI Builder**: Read-only access via GitHub app/token (TBD - separate from current `deploy-code-org` bot)
- **Sync Lambda**: Write access via GitHub app/token (TBD - separate from current `deploy-code-org` bot)

### GitHub Access Setup (TBD)
We need to figure out the exact GitHub access mechanism. Current `deploy-code-org` bot is used everywhere and has broad access, so we want separate access for this.

**Proposal**: Create new GitHub app or access tokens under a dedicated admin user:
- **Read Bot**: For AMI Builder to pull from private repo
- **Write Bot**: For Sync Lambda to push to private repo
- **Admin User**: GitHub admin user to create these tokens/apps

### AWS Security Architecture
- **GitHub Tokens**: Stored in AWS Secrets Manager (not GitHub Actions)
- **IAM Roles**: Least privilege access for Lambda functions
- **Encryption**: All secrets encrypted at rest and in transit
- **No Automatic Back-Sync**: Prevents premature exposure of security fixes

### Security Procedures
- **P1 Issues**: Direct push to private `production`, immediate deployment
- **P2 Issues**: Security branch workflow, deployment within 24 hours  
- **P3 Issues**: Normal workflow, next scheduled deployment

## Design Trade-offs Considered

#### Option 1: Private Production Deploy (Selected)
**Pros:**
- Maintains public repo transparency
- Allows private security development
- Proven pattern used by other projects
- Minimal disruption to current workflow

**Cons:**
- Additional repository to maintain
- Sync complexity between repos
- Requires access control management

#### Option 2: Private Repository with Public Mirror
**Pros:**
- Single source of truth
- Simpler access control

**Cons:**
- Loses public development transparency
- Major workflow disruption
- Community engagement impact

#### Option 3: Delayed Public Disclosure
**Pros:**
- Simpler implementation
- No additional infrastructure

**Cons:**
- Still exposes fixes during development
- Doesn't solve the core problem
- Limited security benefit

**Decision**: Option 1 (Private Production Deploy) provides the best balance of security and transparency.

## Benefits

### Security Benefits
- **Reduced Exposure Window**: Security fixes deployed before public disclosure
- **Controlled Disclosure**: Coordinated public disclosure process
- **Private Testing**: Security fixes tested in private environment
- **Incident Response**: Faster response to security incidents

### Operational Benefits
- **Maintained Open Source**: Public repo remains open and transparent
- **Flexible Workflow**: Can handle both normal and security development
- **Audit Trail**: Complete audit trail of all changes
- **Team Collaboration**: Security team can work privately when needed