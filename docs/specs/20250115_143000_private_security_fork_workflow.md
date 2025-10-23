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
- **Branches**: `staging` → `production` (public)
- **CI/CD**: Custom rake tasks in `lib/rake/ci.rake` and `lib/rake/build.rake`
- **Deployment**: Ruby scripts in `bin/deploy-*` files
- **Build Process**: Multi-stage build for apps, dashboard, pegasus, and i18n

### Key Components Identified
- `deployment.rb` - Main deployment configuration
- `lib/rake/ci.rake` - CI testing and validation
- `lib/rake/build.rake` - Build process for all components
- `bin/deploy-adhoc` - Adhoc deployment script
- `bin/deploy-config` - Configuration deployment script

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

### Phase 1: Repository Setup
1. Create private fork `code-dot-org-production`
2. Set up automated sync from public `staging` → private `production`
3. Configure access controls (security team only)
4. Test sync process

### Phase 2: CI/CD Integration
1. Modify deployment scripts to support private fork
2. Create security deployment workflow
3. Update build processes
4. Test deployment pipeline

### Phase 3: Security Workflow
1. Create security fix procedures
2. Implement emergency deployment process
3. Set up monitoring and alerting
4. Train security team

## Code Changes Required

### 1. Security Fork Sync Script
**File**: [`lib/scripts/security_fork_sync.rb`](../../lib/scripts/security_fork_sync.rb)

Core sync functionality with CLI interface:
- `sync_from_public_staging()` - Pulls public staging into private production
- `sync_to_public_production()` - Pushes private production to public
- `create_security_branch()` - Creates isolated security fix branches
- `merge_security_fix()` - Merges security fixes to production

### 2. Modified Deployment Script
**File**: [`bin/deploy-config`](../../bin/deploy-config)

Added `SECURITY_FORK_DEPLOY` environment variable support:
```ruby
# Sets REPO_URL based on deployment type
ENV['REPO_URL'] = ENV['SECURITY_FORK_DEPLOY'] == 'true' ? 
  'private-repo-url' : 'public-repo-url'
```

### 3. Security Deployment Script
**File**: [`bin/deploy-security`](../../bin/deploy-security)

Dedicated security deployment script with validation:
- Verifies private fork repository
- Ensures production branch
- Sets security deployment flags

### 4. Rake Tasks
**File**: [`lib/rake/deploy.rake`](../../lib/rake/deploy.rake)

New rake tasks for security fork operations:
- `deploy:security` - Deploy from private fork
- `deploy:sync_security_fork` - Sync from public
- `deploy:sync_public_from_security` - Sync to public
- `deploy:create_security_branch` - Create security branch
- `deploy:merge_security_fix` - Merge security fix

### 5. GitHub Actions Workflow
**File**: [`.github/workflows/security-fork-sync.yml`](../../.github/workflows/security-fork-sync.yml)

Automated sync workflow:
- Runs every 6 hours
- Manual trigger with sync direction
- Uses `SECURITY_FORK_TOKEN` for authentication

## Security Workflow

### Normal Development Flow
1. **Public Development**: All normal development happens in public repo
2. **Auto-Sync**: Private fork automatically syncs from public `staging` → `production`
3. **Deployment**: Production deployment triggers from private `production` branch
4. **Public Sync**: Private `production` changes are pushed back to public `production`

### Security Fix Flow
1. **Private Branch**: Security fix is developed in private fork (`security-*` branch)
2. **Private Review**: Security team reviews in private fork
3. **Private Testing**: Security fix is tested in private staging environment
4. **Private Deployment**: Security fix is merged to private `production` and deployed
5. **Public Disclosure**: After deployment, security fix is merged to public repo
6. **Public Sync**: Public `production` is updated to match private `production`

## Access Control

### Repository Access Levels
- **Security Team Leads**: Full admin access to private fork
- **Senior Engineers**: Write access for security fix development
- **DevOps Team**: Write access for deployment purposes
- **All Others**: Read-only access

### Security Procedures
- **P1 Issues**: 4-hour response time, immediate deployment
- **P2 Issues**: 24-hour response time, deployment within 48 hours
- **P3 Issues**: 72-hour response time, next scheduled deployment

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