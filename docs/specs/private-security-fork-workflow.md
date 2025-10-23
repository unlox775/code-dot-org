# Private Security Fork Workflow Specification

## Overview

This document outlines the design and implementation of a private security fork workflow for Code.org's public repository. The goal is to enable private security fixes to be deployed to production before they become public, while maintaining the benefits of open source development.

## Problem Statement

Code.org faces a critical security challenge: their public repository exposes every security fix as soon as it's committed, creating a window of vulnerability between when a fix is developed and when it's deployed to production. This is particularly problematic given:

1. **AI-powered vulnerability scanners** are continuously monitoring public repositories
2. **Recent P1 vulnerabilities** (like BC-88 Local File Read) demonstrate the risk
3. **Public transparency** is valued but creates security exposure
4. **Current workflow** requires public commits before production deployment

## Current Deployment Process

### Branch Structure
- **`staging`** - Integration branch for testing
- **`production`** - Production deployment branch
- **Feature branches** - Individual development work

### Current Workflow
1. Developers work on feature branches
2. Pull requests are created against `staging`
3. After review and testing, changes are merged to `staging`
4. `staging` is merged to `production` for deployment
5. Production deployment is triggered automatically

### Key Components
- **CI/CD**: Custom rake tasks in `lib/rake/ci.rake` and `lib/rake/build.rake`
- **Deployment**: Ruby scripts in `bin/deploy-*` files
- **Build Process**: Multi-stage build for apps, dashboard, pegasus, and i18n
- **Testing**: Comprehensive test suite with UI tests, unit tests, and integration tests

## Proposed Solution: Private Security Fork

### Architecture Overview

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

### Repository Structure

#### Public Repository (`code-dot-org`)
- **`staging`** - Public integration branch
- **`production`** - Public production branch (mirrored from private)
- **Feature branches** - Public development work
- **Security branches** - Public security fixes (after disclosure)

#### Private Security Fork (`code-dot-org-production`)
- **`production`** - Private production branch (source of truth for deployment)
- **`security-*`** - Private security fix branches
- **`staging`** - Mirror of public staging (for testing)

### Workflow Design

#### Normal Development Flow
1. **Public Development**: All normal development happens in public repo
2. **Auto-Sync**: Private fork automatically syncs from public `staging` → `production`
3. **Deployment**: Production deployment triggers from private `production` branch
4. **Public Sync**: Private `production` changes are pushed back to public `production`

#### Security Fix Flow
1. **Private Branch**: Security fix is developed in private fork (`security-*` branch)
2. **Private Review**: Security team reviews in private fork
3. **Private Testing**: Security fix is tested in private staging environment
4. **Private Deployment**: Security fix is merged to private `production` and deployed
5. **Public Disclosure**: After deployment, security fix is merged to public repo
6. **Public Sync**: Public `production` is updated to match private `production`

### Technical Implementation

#### 1. Repository Setup
```bash
# Create private fork
git clone https://github.com/code-dot-org/code-dot-org.git code-dot-org-production
cd code-dot-org-production
git remote add upstream https://github.com/code-dot-org/code-dot-org.git
git remote set-url origin https://github.com/code-dot-org/code-dot-org-production.git
```

#### 2. Automated Sync Script
```ruby
# lib/scripts/sync_security_fork.rb
class SecurityForkSyncer
  def sync_from_public
    # Pull latest from public staging
    system('git fetch upstream staging')
    system('git checkout production')
    system('git merge upstream/staging --no-edit')
    system('git push origin production')
  end
  
  def sync_to_public
    # Push private production to public
    system('git push upstream production')
  end
end
```

#### 3. CI/CD Modifications
- **Public Repo**: Normal CI/CD continues as before
- **Private Repo**: Additional CI/CD for security fixes
- **Deployment**: Modified to deploy from private fork

#### 4. Access Control
- **Private Fork Access**: Limited to security team and senior engineers
- **Security Branches**: Only accessible to security team
- **Public Sync**: Automated with approval gates

### Security Considerations

#### Access Management
- **Principle of Least Privilege**: Minimal access to private fork
- **Audit Logging**: All private fork activities logged
- **Two-Factor Authentication**: Required for all private fork access
- **Regular Access Reviews**: Quarterly access review process

#### Information Security
- **Encrypted Communication**: All security discussions in encrypted channels
- **Secure Development**: Security fixes developed in isolated environments
- **Vulnerability Tracking**: Private issue tracking for security fixes
- **Disclosure Timeline**: Coordinated disclosure process

### Implementation Plan

#### Phase 1: Infrastructure Setup (Week 1-2)
1. Create private security fork repository
2. Set up automated sync scripts
3. Configure access controls and permissions
4. Test sync process with non-security changes

#### Phase 2: CI/CD Integration (Week 3-4)
1. Modify deployment scripts to use private fork
2. Set up private fork CI/CD pipeline
3. Create security fix workflow documentation
4. Train security team on new process

#### Phase 3: Security Process (Week 5-6)
1. Implement security fix workflow
2. Create incident response procedures
3. Set up monitoring and alerting
4. Conduct security team training

#### Phase 4: Testing and Validation (Week 7-8)
1. Test complete workflow with simulated security fix
2. Validate deployment process
3. Test public disclosure process
4. Create runbooks and documentation

### Monitoring and Maintenance

#### Automated Monitoring
- **Sync Status**: Monitor sync between public and private repos
- **Deployment Status**: Monitor deployment from private fork
- **Access Logs**: Monitor access to private fork
- **Security Alerts**: Monitor for security-related changes

#### Regular Maintenance
- **Weekly Sync Review**: Ensure sync is working correctly
- **Monthly Access Review**: Review and update access permissions
- **Quarterly Process Review**: Review and improve security workflow
- **Annual Security Audit**: Comprehensive security review

### Benefits

#### Security Benefits
- **Reduced Exposure Window**: Security fixes deployed before public disclosure
- **Controlled Disclosure**: Coordinated public disclosure process
- **Private Testing**: Security fixes tested in private environment
- **Incident Response**: Faster response to security incidents

#### Operational Benefits
- **Maintained Open Source**: Public repo remains open and transparent
- **Flexible Workflow**: Can handle both normal and security development
- **Audit Trail**: Complete audit trail of all changes
- **Team Collaboration**: Security team can work privately when needed

#### Business Benefits
- **Risk Mitigation**: Reduced risk of exploitation during fix development
- **Compliance**: Better compliance with security requirements
- **Reputation**: Maintained security posture and reputation
- **Innovation**: Continued open source innovation and collaboration

### Risks and Mitigations

#### Technical Risks
- **Sync Failures**: Automated monitoring and manual fallback procedures
- **Deployment Issues**: Comprehensive testing and rollback procedures
- **Access Control**: Regular access reviews and audit logging
- **Data Loss**: Regular backups and version control

#### Operational Risks
- **Process Complexity**: Comprehensive documentation and training
- **Team Confusion**: Clear communication and role definitions
- **Maintenance Overhead**: Automated monitoring and maintenance
- **Single Point of Failure**: Redundant systems and procedures

### Success Metrics

#### Security Metrics
- **Time to Deploy**: Security fixes deployed within 24 hours
- **Exposure Window**: Zero public exposure before deployment
- **Incident Response**: Security incidents handled within SLA
- **Vulnerability Management**: All vulnerabilities tracked and managed

#### Operational Metrics
- **Sync Reliability**: 99.9% sync success rate
- **Deployment Success**: 99.5% deployment success rate
- **Team Adoption**: 100% security team adoption
- **Process Compliance**: 100% process compliance

### Conclusion

The private security fork workflow provides a robust solution to Code.org's security challenges while maintaining the benefits of open source development. The implementation plan balances security needs with operational efficiency, and the monitoring and maintenance procedures ensure long-term success.

This approach has been successfully used by other large open source projects and provides a proven pattern for handling security fixes in public repositories. The phased implementation approach minimizes risk while ensuring a smooth transition to the new workflow.