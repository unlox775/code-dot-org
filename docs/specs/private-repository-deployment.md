# Private Repository Deployment Strategy

> **⚠️ AI Generated Spec**  
> This is an AI-generated specification document. Please verify all information and adapt to your specific infrastructure needs.

## Overview

This document outlines a strategy for implementing a private repository deployment pattern that allows Code.org to handle sensitive security fixes and deployments without exposing them to the public repository first. This follows established patterns used by major open source projects that need to maintain security while remaining open.

## Problem Statement

As a public open source project, Code.org faces challenges when handling:
- **Security vulnerabilities** that need immediate fixes without public disclosure
- **Sensitive configuration** that cannot be exposed in public repositories
- **Emergency deployments** that require rapid, controlled rollout
- **Compliance requirements** that mandate private handling of certain changes

## Solution Architecture

### Repository Structure

```
code-dot-org (public)           code-dot-org-production (private)
├── staging branch              ├── staging branch (auto-synced)
├── production branch           ├── production branch (auto-synced)
└── feature branches            └── security branch (private-only)
```

### Key Components

1. **Private Production Repository** (`code-dot-org-production`)
   - Private fork of the public repository
   - Contains all public code plus private security fixes
   - Limited access (security team + senior engineers only)

2. **Automated Sync System**
   - Monitors public repository for changes
   - Automatically merges public changes to private repository
   - Handles conflict resolution and merge conflicts

3. **Security Branch**
   - Private-only branch for sensitive fixes
   - Never synced back to public repository
   - Used for emergency security patches

4. **Deployment Pipeline**
   - Deploys from private repository production branch
   - Maintains same CI/CD processes
   - Enhanced security and access controls

## Current Deployment Analysis

### Existing CI/CD Pipeline

Based on analysis of the current codebase, Code.org uses:

1. **CI Build System** (`aws/ci_build`)
   - Polling-based continuous deployment
   - Monitors for upstream commits on current branch
   - Triggers `infra:ci` Rake task for builds
   - Handles staging and production deployments

2. **GitHub Actions Workflows**
   - Multiple workflows for different components
   - CI pipeline with infrastructure reviewer checks
   - Docker-based testing and deployment
   - Integration with AWS services

3. **Branch Strategy**
   - `staging` branch for testing
   - `production` branch for live deployments
   - Feature branches for development

### Required Changes

To implement the private repository pattern, the following changes are needed:

1. **Repository Setup**
   - Create `code-dot-org-production` private repository
   - Set up automated sync from public to private
   - Configure branch protection and access controls

2. **CI/CD Modifications**
   - Update deployment scripts to use private repository
   - Modify `ci_build` script to pull from private repository
   - Update GitHub Actions to work with private repository

3. **Access Control**
   - Implement role-based access to private repository
   - Create security team access controls
   - Set up audit logging for private changes

## Implementation Plan

### Phase 1: Repository Setup

1. **Create Private Repository**
   ```bash
   # Create private fork
   gh repo create code-dot-org-production --private --source=code-dot-org
   
   # Set up remote tracking
   git remote add private-production https://github.com/code-dot-org/code-dot-org-production.git
   ```

2. **Configure Branch Protection**
   - Protect `production` branch with required reviews
   - Set up branch protection rules
   - Configure status checks

3. **Set Up Access Controls**
   - Create security team with limited access
   - Configure repository permissions
   - Set up audit logging

### Phase 2: Automated Sync System

1. **Create Sync Script** (`scripts/sync-to-private.sh`)
   ```bash
   #!/bin/bash
   # Sync public repository changes to private repository
   
   # Fetch latest changes from public repository
   git fetch origin
   
   # Merge staging branch
   git checkout staging
   git merge origin/staging
   git push private-production staging
   
   # Merge production branch
   git checkout production
   git merge origin/production
   git push private-production production
   ```

2. **Set Up GitHub Actions for Sync**
   - Create workflow to sync on public repository changes
   - Handle merge conflicts automatically
   - Notify on sync failures

3. **Configure Webhooks**
   - Set up webhooks from public to private repository
   - Trigger sync on push events
   - Handle rate limiting and retries

### Phase 3: Deployment Pipeline Updates

1. **Update CI Build Script**
   - Modify `aws/ci_build` to use private repository
   - Update git remote configurations
   - Handle authentication for private repository

2. **Update GitHub Actions**
   - Modify workflows to use private repository
   - Update secrets and environment variables
   - Configure private repository access

3. **Update Deployment Scripts**
   - Modify deployment scripts to pull from private repository
   - Update monitoring and logging
   - Handle private repository authentication

### Phase 4: Security Branch Implementation

1. **Create Security Branch**
   - Create `security` branch in private repository
   - Set up branch protection rules
   - Configure access controls

2. **Implement Security Workflow**
   - Create process for security fixes
   - Set up review process for security changes
   - Configure emergency deployment procedures

3. **Set Up Monitoring**
   - Monitor security branch for changes
   - Set up alerts for security deployments
   - Configure audit logging

## Security Considerations

### Access Control

1. **Repository Access**
   - Security team: Full access to private repository
   - Senior engineers: Limited access to production branch
   - Regular engineers: No access to private repository

2. **Branch Protection**
   - Require reviews for all changes
   - Require status checks to pass
   - Restrict force pushes
   - Require up-to-date branches

3. **Audit Logging**
   - Log all access to private repository
   - Monitor for unauthorized changes
   - Set up alerts for suspicious activity

### Data Protection

1. **Secrets Management**
   - Store sensitive secrets in private repository
   - Use encrypted secrets storage
   - Rotate secrets regularly

2. **Configuration Management**
   - Store sensitive configuration in private repository
   - Use environment-specific configurations
   - Implement configuration validation

## Monitoring and Alerting

### Sync Monitoring

1. **Sync Status**
   - Monitor sync success/failure
   - Alert on sync failures
   - Track sync latency

2. **Conflict Resolution**
   - Monitor for merge conflicts
   - Alert on unresolved conflicts
   - Track conflict resolution time

### Deployment Monitoring

1. **Deployment Status**
   - Monitor deployment success/failure
   - Alert on deployment failures
   - Track deployment metrics

2. **Security Monitoring**
   - Monitor security branch changes
   - Alert on security deployments
   - Track security fix metrics

## Rollback Procedures

### Emergency Rollback

1. **Immediate Rollback**
   - Revert to previous known good state
   - Disable automatic deployments
   - Notify security team

2. **Investigation**
   - Investigate root cause
   - Document findings
   - Implement fixes

3. **Recovery**
   - Deploy fixes
   - Re-enable automatic deployments
   - Monitor for stability

## Testing Strategy

### Sync Testing

1. **Automated Testing**
   - Test sync process with test repositories
   - Validate merge conflict resolution
   - Test rollback procedures

2. **Integration Testing**
   - Test with real repository data
   - Validate deployment pipeline
   - Test security workflows

### Security Testing

1. **Access Control Testing**
   - Test repository access controls
   - Validate branch protection rules
   - Test audit logging

2. **Deployment Testing**
   - Test security deployments
   - Validate emergency procedures
   - Test rollback procedures

## Maintenance and Operations

### Regular Maintenance

1. **Sync Monitoring**
   - Monitor sync performance
   - Optimize sync processes
   - Update sync scripts

2. **Security Updates**
   - Update access controls
   - Rotate secrets
   - Update security procedures

### Documentation

1. **Operational Runbooks**
   - Create runbooks for common procedures
   - Document emergency procedures
   - Update troubleshooting guides

2. **Training**
   - Train security team on new procedures
   - Update developer documentation
   - Create security awareness training

## Success Metrics

### Technical Metrics

1. **Sync Performance**
   - Sync success rate: >99%
   - Sync latency: <5 minutes
   - Conflict resolution time: <1 hour

2. **Deployment Performance**
   - Deployment success rate: >99%
   - Deployment time: <30 minutes
   - Rollback time: <15 minutes

### Security Metrics

1. **Access Control**
   - Zero unauthorized access attempts
   - 100% audit log coverage
   - <24 hour access review cycle

2. **Security Response**
   - Security fix deployment time: <4 hours
   - Emergency response time: <1 hour
   - Security incident resolution: <24 hours

## Risk Assessment

### High Risk

1. **Sync Failures**
   - Risk: Private repository falls behind public
   - Mitigation: Automated monitoring and alerting
   - Impact: Deployment delays

2. **Access Control Failures**
   - Risk: Unauthorized access to private repository
   - Mitigation: Strong access controls and monitoring
   - Impact: Security breach

### Medium Risk

1. **Merge Conflicts**
   - Risk: Manual intervention required
   - Mitigation: Automated conflict resolution
   - Impact: Deployment delays

2. **Deployment Failures**
   - Risk: Production outages
   - Mitigation: Comprehensive testing and rollback procedures
   - Impact: Service disruption

### Low Risk

1. **Performance Impact**
   - Risk: Slower sync and deployment
   - Mitigation: Performance optimization
   - Impact: Minor delays

## Conclusion

The private repository deployment pattern provides Code.org with the ability to handle sensitive security fixes and deployments while maintaining the benefits of open source development. This implementation plan provides a comprehensive approach to implementing this pattern while maintaining security, reliability, and operational excellence.

## Next Steps

1. **Review and Approve** this specification
2. **Create Private Repository** and set up initial configuration
3. **Implement Sync System** and test with non-production data
4. **Update Deployment Pipeline** and test thoroughly
5. **Deploy to Production** with monitoring and rollback procedures

## References

- [GitHub Private Repository Best Practices](https://docs.github.com/en/repositories/creating-and-managing-repositories/managing-a-repositorys-visibility)
- [Open Source Security Practices](https://opensource.guide/security/)
- [CI/CD Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)