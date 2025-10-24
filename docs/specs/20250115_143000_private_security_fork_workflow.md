# Private Security Fork Workflow Specification

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

### Key Components Identified
- **AMI Builder**: [`aws/ci_build`](../../aws/ci_build) - Polls public `production` branch every minute
- **AMI Manager**: [`aws/cloudformation/ami-manager.js`](../../aws/cloudformation/ami-manager.js) - Lambda for AMI creation
- **Build Process**: `lib/rake/ci.rake` and `lib/rake/build.rake` - CI testing and build
- **Production Servers**: `production-console`, `production-daemon` - Target deployment servers

## Proposed Solution: Private Security Fork

### Architecture Design

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Public Repo   │    │  Private Security │    │   Production    │
│  (code-dot-org) │    │      Fork         │    │   Deployment    │
│                 │    │ (code-dot-org-   │    │                 │
│ staging branch  │───▶│  production)     │───▶│   AWS/Cloud     │
│ production      │    │                  │    │                 │
│                 │    │ security fixes   │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Design Trade-offs Considered

#### Option 1: Private Security Fork (Selected)
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

**Decision**: Option 1 (Private Security Fork) provides the best balance of security and transparency.

## Implementation Plan

### Phase 1: Switch to Private Fork (New Normal)
**Goal**: Everything works exactly the same, but AMI Builder watches private repo instead of public

1. **Create Private Fork**: `code-dot-org-production` repository
2. **Set Up Auto-Sync**: Lambda function that syncs public `production` → private `production` on every push
3. **Switch AMI Builder**: Point [`aws/ci_build`](../../aws/ci_build) to watch private repo instead of public
4. **Test Normal Flow**: Verify normal deployments work identically

**Current Flow**: `staging` → `production` (public) → AMI Builder → Production
**New Flow**: `staging` → `production` (public) → **Sync Lambda** → `production` (private) → AMI Builder → Production

### Phase 2: Test Security Workflow
**Goal**: Test ability to push security fixes directly to private repo

1. **Test Minor Fix**: Push small change directly to private `production` branch
2. **Verify Deployment**: Ensure AMI Builder picks up and deploys the change
3. **Add Back-Sync**: Daily job to sync private changes back to public repo
4. **Create Security Scripts**: Tools for easier security fix management

### Phase 3: Security Fix Procedures
**Goal**: Full security fix workflow with private development

1. **Security Branch Workflow**: Create and merge security branches in private repo
2. **Emergency Procedures**: Rapid deployment process for P1 issues
3. **Public Disclosure**: Coordinated disclosure after deployment
4. **Team Training**: Train security team on new procedures

## Code Changes Required

### 1. AWS Lambda Sync Function
**File**: [`aws/cloudformation/lambdas/security-fork-sync/index.js`](../../aws/cloudformation/lambdas/security-fork-sync/index.js)

**Purpose**: Syncs public `production` → private `production` on every push
**Security**: Uses AWS Secrets Manager for GitHub token (not GitHub Actions)
**Trigger**: GitHub webhook on `production` branch push

```javascript
// Pseudocode: Fetch from public, merge to private, handle conflicts
exports.handler = async (event) => {
  // 1. Verify webhook signature
  // 2. Fetch latest from public production
  // 3. Check for merge conflicts
  // 4. Merge to private production
  // 5. Notify on success/failure
}
```

### 2. Modified AMI Builder Configuration
**File**: [`aws/ci_build`](../../aws/ci_build)

**Change**: Point to private repository instead of public
```ruby
# Current: Watches public repo
# New: Watch private repo with read-only access
REPO_URL = 'https://github.com/code-dot-org/code-dot-org-production.git'
```

### 3. Back-Sync Daily Job
**File**: [`aws/cloudformation/lambdas/back-sync/index.js`](../../aws/cloudformation/lambdas/back-sync/index.js)

**Purpose**: Daily job to sync private changes back to public repo
**Schedule**: CloudWatch Events (daily at 2 AM)
**Notification**: Slack alert if changes need manual review

### 4. Security Fix Scripts
**File**: [`lib/scripts/security_fork_sync.rb`](../../lib/scripts/security_fork_sync.rb)

**Purpose**: CLI tools for security team to manage private repo
- `create_security_branch()` - Create isolated security fix branches
- `merge_security_fix()` - Merge security fixes to production
- `sync_to_public()` - Manual sync to public repo

### 5. CloudFormation Stack
**File**: [`aws/cloudformation/security-fork-stack.yml`](../../aws/cloudformation/security-fork-stack.yml)

**Purpose**: Infrastructure for sync Lambda and back-sync job
**Includes**: IAM roles, Secrets Manager, CloudWatch Events, Lambda functions

## Security Workflow

### Normal Development Flow (Phase 1)
1. **Public Development**: All normal development happens in public repo
2. **Auto-Sync**: Lambda syncs public `production` → private `production` on every push
3. **AMI Builder**: Watches private `production` branch (instead of public)
4. **Deployment**: Normal deployment process continues unchanged

### Security Fix Flow (Phase 3)
1. **Private Branch**: Security fix developed in private fork (`security-*` branch)
2. **Private Review**: Security team reviews in private fork
3. **Private Testing**: Security fix tested in private staging environment
4. **Private Deployment**: Security fix merged to private `production` and deployed
5. **Back-Sync**: Daily job syncs private changes back to public repo
6. **Public Disclosure**: Coordinated disclosure after deployment

### Emergency P1 Fix Flow
1. **Direct Push**: Security fix pushed directly to private `production` branch
2. **Immediate Deployment**: AMI Builder picks up change and deploys
3. **Back-Sync**: Changes synced to public repo within 24 hours
4. **Public Disclosure**: Coordinated disclosure after deployment

## Access Control & Security

### Repository Access Levels
- **Security Team Leads**: Full admin access to private fork
- **Senior Engineers**: Write access for security fix development  
- **AMI Builder**: Read-only access to private fork (via AWS IAM)
- **Sync Lambda**: Write access to private fork (via AWS Secrets Manager)
- **All Others**: No access to private fork

### AWS Security Architecture
- **GitHub Token**: Stored in AWS Secrets Manager (not GitHub Actions)
- **IAM Roles**: Least privilege access for Lambda functions
- **VPC**: Sync Lambda runs in private VPC
- **Encryption**: All secrets encrypted at rest and in transit

### Security Procedures
- **P1 Issues**: Direct push to private `production`, immediate deployment
- **P2 Issues**: Security branch workflow, deployment within 24 hours
- **P3 Issues**: Normal workflow, next scheduled deployment

## Monitoring and Maintenance

### Automated Monitoring
- **Sync Status**: Monitor sync between public and private repos
- **Deployment Status**: Monitor deployment success and performance
- **Access Logs**: Monitor access to private fork
- **Security Alerts**: Monitor for security-related changes

### Regular Maintenance
- **Weekly Sync Review**: Ensure sync is working correctly
- **Monthly Access Review**: Review and update access permissions
- **Quarterly Process Review**: Review and improve security workflow
- **Annual Security Audit**: Comprehensive security review

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

## Risks and Mitigations

### Technical Risks
- **Sync Failures**: Automated monitoring and manual fallback procedures
- **Deployment Issues**: Comprehensive testing and rollback procedures
- **Access Control**: Regular access reviews and audit logging
- **Data Loss**: Regular backups and version control

### Operational Risks
- **Process Complexity**: Comprehensive documentation and training
- **Team Confusion**: Clear communication and role definitions
- **Maintenance Overhead**: Automated monitoring and maintenance
- **Single Point of Failure**: Redundant systems and procedures

## Implementation Timeline

- **Week 1-2**: Repository setup and sync configuration
- **Week 3-4**: CI/CD integration and deployment modifications
- **Week 5-6**: Security workflow implementation and testing
- **Week 7-8**: Training, documentation, and production deployment

## Success Metrics

- **Time to Deploy**: Security fixes deployed within 24 hours
- **Exposure Window**: Zero public exposure before deployment
- **Sync Reliability**: 99.9% sync success rate
- **Deployment Success**: 99.5% deployment success rate

## Conclusion

The private security fork workflow provides a robust solution to Code.org's security challenges while maintaining the benefits of open source development. The implementation plan balances security needs with operational efficiency, and the monitoring and maintenance procedures ensure long-term success.

This approach has been successfully used by other large open source projects and provides a proven pattern for handling security fixes in public repositories. The phased implementation approach minimizes risk while ensuring a smooth transition to the new workflow.