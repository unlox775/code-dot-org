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

### 1. New Security Fork Sync Script

Create `lib/scripts/security_fork_sync.rb`:

```ruby
#!/usr/bin/env ruby
require_relative '../../deployment'
require 'cdo/chat_client'
require 'cdo/rake_utils'

class SecurityForkSyncer
  def initialize
    @private_repo = 'code-dot-org-production'
    @public_repo = 'code-dot-org'
  end

  def sync_from_public_staging
    ChatClient.log "Syncing from public staging to private production..."
    
    # Fetch latest from public
    RakeUtils.system 'git fetch upstream staging'
    
    # Switch to production branch
    RakeUtils.system 'git checkout production'
    
    # Merge staging into production
    RakeUtils.system 'git merge upstream/staging --no-edit'
    
    # Push to private repo
    RakeUtils.system 'git push origin production'
    
    ChatClient.log "Sync completed successfully"
  end

  def sync_to_public_production
    ChatClient.log "Syncing private production to public..."
    
    # Push private production to public
    RakeUtils.system 'git push upstream production'
    
    ChatClient.log "Public sync completed successfully"
  end

  def create_security_branch(branch_name)
    ChatClient.log "Creating security branch: #{branch_name}"
    
    # Create and checkout security branch
    RakeUtils.system "git checkout -b security-#{branch_name}"
    
    # Push to private repo
    RakeUtils.system "git push origin security-#{branch_name}"
    
    ChatClient.log "Security branch created: security-#{branch_name}"
  end

  def merge_security_fix(branch_name)
    ChatClient.log "Merging security fix: #{branch_name}"
    
    # Switch to production
    RakeUtils.system 'git checkout production'
    
    # Merge security branch
    RakeUtils.system "git merge security-#{branch_name} --no-edit"
    
    # Push to private repo
    RakeUtils.system 'git push origin production'
    
    ChatClient.log "Security fix merged to production"
  end
end

# CLI interface
if __FILE__ == $0
  syncer = SecurityForkSyncer.new
  
  case ARGV[0]
  when 'sync-from-public'
    syncer.sync_from_public_staging
  when 'sync-to-public'
    syncer.sync_to_public_production
  when 'create-security-branch'
    syncer.create_security_branch(ARGV[1])
  when 'merge-security-fix'
    syncer.merge_security_fix(ARGV[1])
  else
    puts "Usage: #{$0} [sync-from-public|sync-to-public|create-security-branch|merge-security-fix]"
  end
end
```

### 2. Modified Deployment Script

Update `bin/deploy-config`:

```ruby
#!/usr/bin/env ruby
#
# Modified to support security fork deployment
#
require_relative '../deployment'

def main
  # Check if we're deploying from security fork
  if ENV['SECURITY_FORK_DEPLOY'] == 'true'
    puts "Deploying from security fork..."
    # Use private repository for deployment
    ENV['REPO_URL'] = 'https://github.com/code-dot-org/code-dot-org-production.git'
  else
    puts "Deploying from public repository..."
    # Use public repository for deployment
    ENV['REPO_URL'] = 'https://github.com/code-dot-org/code-dot-org.git'
  end

  puts JSON.pretty_generate(CDO.to_h)
end

main
```

### 3. New Security Deployment Script

Create `bin/deploy-security`:

```ruby
#!/usr/bin/env ruby
# Deploy security fix from private fork

ENV['RAILS_ENV'] = 'production'
ENV['SECURITY_FORK_DEPLOY'] = 'true'
require_relative '../deployment'
require 'cdo/rake_utils'

def main
  puts "Starting security deployment from private fork..."
  
  # Verify we're on the private repository
  unless `git remote get-url origin`.include?('code-dot-org-production')
    puts "ERROR: Not on private security fork repository"
    exit 1
  end

  # Verify we're on production branch
  unless `git branch --show-current`.strip == 'production'
    puts "ERROR: Not on production branch"
    exit 1
  end

  # Run deployment
  RakeUtils.rake('deploy:production')
  
  puts "Security deployment completed"
end

main
```

### 4. Updated Rake Tasks

Add to `lib/rake/deploy.rake`:

```ruby
namespace :deploy do
  desc 'Deploy from security fork'
  task :security do
    ENV['SECURITY_FORK_DEPLOY'] = 'true'
    Rake::Task['deploy:production'].invoke
  end

  desc 'Sync security fork from public'
  task :sync_security_fork do
    require 'lib/scripts/security_fork_sync'
    syncer = SecurityForkSyncer.new
    syncer.sync_from_public_staging
  end

  desc 'Sync public from security fork'
  task :sync_public_from_security do
    require 'lib/scripts/security_fork_sync'
    syncer = SecurityForkSyncer.new
    syncer.sync_to_public_production
  end
end
```

### 5. GitHub Actions Workflow

Create `.github/workflows/security-fork-sync.yml`:

```yaml
name: Sync Security Fork
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
  workflow_dispatch:
    inputs:
      sync_direction:
        description: 'Sync direction'
        required: true
        default: 'from-public'
        type: choice
        options:
          - from-public
          - to-public

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          token: ${{ secrets.SECURITY_FORK_TOKEN }}
          fetch-depth: 0

      - name: Configure Git
        run: |
          git config --global user.name "Security Fork Bot"
          git config --global user.email "security-fork@code.org"

      - name: Add upstream remote
        run: |
          git remote add upstream https://github.com/code-dot-org/code-dot-org.git

      - name: Sync from public
        if: github.event.inputs.sync_direction == 'from-public' || github.event_name == 'schedule'
        run: |
          ruby lib/scripts/security_fork_sync.rb sync-from-public

      - name: Sync to public
        if: github.event.inputs.sync_direction == 'to-public'
        run: |
          ruby lib/scripts/security_fork_sync.rb sync-to-public
```

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