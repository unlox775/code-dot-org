# Security Fork Implementation Guide

## Quick Start Implementation

This guide provides step-by-step instructions for implementing the private security fork workflow for Code.org.

## Prerequisites

- GitHub organization admin access
- AWS deployment access
- Access to current CI/CD systems
- Security team coordination

## Phase 1: Repository Setup

### Step 1: Create Private Security Fork

```bash
# 1. Create the private repository
# Go to GitHub and create a new private repository: code-dot-org-production

# 2. Clone and set up the private fork
git clone https://github.com/code-dot-org/code-dot-org.git code-dot-org-production
cd code-dot-org-production

# 3. Add remotes
git remote add upstream https://github.com/code-dot-org/code-dot-org.git
git remote set-url origin https://github.com/code-dot-org/code-dot-org-production.git

# 4. Initial sync
git checkout production
git push origin production
```

### Step 2: Set Up Access Controls

```bash
# Create security team in GitHub
# Add team members:
# - Security team leads
# - Senior engineers (minimal access)
# - DevOps team (deployment access)

# Set repository permissions:
# - Admin: Security team leads
# - Write: Senior engineers, DevOps
# - Read: All other team members
```

### Step 3: Create Sync Scripts

Create `/workspace/lib/scripts/security_fork_sync.rb`:

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

### Step 4: Set Up Automated Sync

Create `/workspace/lib/scripts/setup_security_fork_sync.rb`:

```ruby
#!/usr/bin/env ruby
require_relative '../../deployment'
require 'cdo/chat_client'

class SecurityForkSyncSetup
  def setup_github_actions
    # Create GitHub Actions workflow for automated sync
    workflow_content = <<~YAML
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
    YAML

    File.write('.github/workflows/security-fork-sync.yml', workflow_content)
    ChatClient.log "GitHub Actions workflow created"
  end

  def setup_webhooks
    # Set up webhooks for real-time sync
    webhook_config = {
      url: 'https://api.github.com/repos/code-dot-org/code-dot-org-production/hooks',
      events: ['push'],
      config: {
        url: 'https://your-webhook-endpoint.com/security-fork-sync',
        content_type: 'json',
        secret: ENV['WEBHOOK_SECRET']
      }
    }
    
    ChatClient.log "Webhook configuration: #{webhook_config.to_json}"
  end
end

if __FILE__ == $0
  setup = SecurityForkSyncSetup.new
  setup.setup_github_actions
  setup.setup_webhooks
end
```

## Phase 2: CI/CD Integration

### Step 1: Modify Deployment Scripts

Update `/workspace/bin/deploy-config`:

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

### Step 2: Create Security Deployment Script

Create `/workspace/bin/deploy-security`:

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

### Step 3: Update Rake Tasks

Add to `/workspace/lib/rake/deploy.rake`:

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

## Phase 3: Security Workflow

### Step 1: Create Security Fix Template

Create `/workspace/docs/security-fix-template.md`:

```markdown
# Security Fix Template

## Issue Information
- **JIRA Ticket**: BC-XXX
- **Severity**: P1/P2/P3
- **Affected Components**: 
- **Discovery Date**: 
- **Target Deployment**: 

## Technical Details
- **Root Cause**: 
- **Fix Description**: 
- **Files Modified**: 
- **Testing Required**: 

## Deployment Plan
- [ ] Create security branch
- [ ] Implement fix
- [ ] Internal testing
- [ ] Security review
- [ ] Deploy to production
- [ ] Public disclosure
- [ ] Merge to public repo

## Rollback Plan
- **Rollback Trigger**: 
- **Rollback Steps**: 
- **Verification**: 

## Communication Plan
- **Internal Notification**: 
- **External Disclosure**: 
- **Timeline**: 
```

### Step 2: Create Security Workflow Script

Create `/workspace/lib/scripts/security_workflow.rb`:

```ruby
#!/usr/bin/env ruby
require_relative '../../deployment'
require 'cdo/chat_client'
require 'cdo/rake_utils'

class SecurityWorkflow
  def initialize(ticket_id, severity)
    @ticket_id = ticket_id
    @severity = severity
    @branch_name = "security-#{ticket_id.downcase}"
  end

  def start_security_fix
    ChatClient.log "Starting security fix workflow for #{@ticket_id}"
    
    # Create security branch
    RakeUtils.system "git checkout -b #{@branch_name}"
    RakeUtils.system "git push origin #{@branch_name}"
    
    # Create tracking file
    tracking_file = "security-fixes/#{@ticket_id}.md"
    FileUtils.mkdir_p(File.dirname(tracking_file))
    
    template_content = File.read('docs/security-fix-template.md')
    File.write(tracking_file, template_content)
    
    ChatClient.log "Security branch created: #{@branch_name}"
    ChatClient.log "Tracking file created: #{tracking_file}"
  end

  def deploy_security_fix
    ChatClient.log "Deploying security fix #{@ticket_id}"
    
    # Merge to production
    RakeUtils.system 'git checkout production'
    RakeUtils.system "git merge #{@branch_name} --no-edit"
    RakeUtils.system 'git push origin production'
    
    # Deploy
    RakeUtils.rake('deploy:security')
    
    ChatClient.log "Security fix deployed successfully"
  end

  def public_disclosure
    ChatClient.log "Starting public disclosure for #{@ticket_id}"
    
    # Sync to public repo
    RakeUtils.system 'git push upstream production'
    
    # Create public PR
    pr_url = create_public_pr
    
    ChatClient.log "Public disclosure initiated: #{pr_url}"
  end

  private

  def create_public_pr
    # This would integrate with GitHub API to create a PR
    # For now, return a placeholder
    "https://github.com/code-dot-org/code-dot-org/pull/XXXX"
  end
end

# CLI interface
if __FILE__ == $0
  ticket_id = ARGV[0]
  severity = ARGV[1] || 'P1'
  
  workflow = SecurityWorkflow.new(ticket_id, severity)
  
  case ARGV[2]
  when 'start'
    workflow.start_security_fix
  when 'deploy'
    workflow.deploy_security_fix
  when 'disclose'
    workflow.public_disclosure
  else
    puts "Usage: #{$0} <ticket_id> [severity] [start|deploy|disclose]"
  end
end
```

## Phase 4: Testing and Validation

### Step 1: Test Sync Process

```bash
# Test sync from public to private
cd /path/to/private-fork
ruby lib/scripts/security_fork_sync.rb sync-from-public

# Test sync from private to public
ruby lib/scripts/security_fork_sync.rb sync-to-public
```

### Step 2: Test Security Workflow

```bash
# Test security fix workflow
ruby lib/scripts/security_workflow.rb BC-TEST P1 start
# Make some test changes
ruby lib/scripts/security_workflow.rb BC-TEST P1 deploy
ruby lib/scripts/security_workflow.rb BC-TEST P1 disclose
```

### Step 3: Test Deployment

```bash
# Test security deployment
./bin/deploy-security
```

## Phase 5: Documentation and Training

### Step 1: Create Runbooks

Create `/workspace/docs/runbooks/security-fork-operations.md`:

```markdown
# Security Fork Operations Runbook

## Daily Operations

### Morning Checklist
- [ ] Check sync status between public and private repos
- [ ] Verify deployment status
- [ ] Review access logs
- [ ] Check for security alerts

### Sync Issues
1. Check GitHub Actions status
2. Verify network connectivity
3. Check repository permissions
4. Manual sync if needed

### Deployment Issues
1. Check deployment logs
2. Verify environment status
3. Check for configuration issues
4. Rollback if necessary

## Emergency Procedures

### Security Incident Response
1. Activate security team
2. Create security branch
3. Implement fix
4. Deploy to production
5. Monitor for issues
6. Public disclosure

### Sync Failure Recovery
1. Identify sync failure cause
2. Manual sync if possible
3. Escalate if needed
4. Document incident
```

### Step 2: Create Training Materials

Create `/workspace/docs/training/security-fork-training.md`:

```markdown
# Security Fork Training Guide

## Overview
This guide provides training for team members who will work with the security fork.

## Key Concepts
- Private vs Public repositories
- Sync process
- Security workflow
- Access controls
- Emergency procedures

## Hands-on Exercises
1. Create a security branch
2. Make a test change
3. Deploy the change
4. Sync to public repo

## Best Practices
- Always use security branches for fixes
- Test thoroughly before deployment
- Document all changes
- Follow security procedures
```

## Monitoring and Maintenance

### Step 1: Set Up Monitoring

Create `/workspace/lib/scripts/security_fork_monitor.rb`:

```ruby
#!/usr/bin/env ruby
require_relative '../../deployment'
require 'cdo/chat_client'

class SecurityForkMonitor
  def check_sync_status
    # Check if sync is working
    last_sync = `git log -1 --format=%ct`.to_i
    current_time = Time.now.to_i
    time_diff = current_time - last_sync
    
    if time_diff > 3600 # 1 hour
      ChatClient.log "WARNING: Sync is #{time_diff} seconds behind", color: 'yellow'
    else
      ChatClient.log "Sync status: OK"
    end
  end

  def check_deployment_status
    # Check deployment status
    # This would integrate with your deployment monitoring
    ChatClient.log "Deployment status check completed"
  end

  def check_access_logs
    # Check for suspicious access patterns
    # This would integrate with your logging system
    ChatClient.log "Access logs check completed"
  end
end

if __FILE__ == $0
  monitor = SecurityForkMonitor.new
  monitor.check_sync_status
  monitor.check_deployment_status
  monitor.check_access_logs
end
```

### Step 2: Set Up Alerts

Create `/workspace/lib/scripts/setup_security_alerts.rb`:

```ruby
#!/usr/bin/env ruby
require_relative '../../deployment'
require 'cdo/chat_client'

class SecurityAlertSetup
  def setup_github_alerts
    # Set up GitHub repository alerts
    alerts = {
      'sync_failure' => {
        'condition' => 'sync_failed',
        'action' => 'notify_security_team'
      },
      'unauthorized_access' => {
        'condition' => 'unusual_access_pattern',
        'action' => 'immediate_alert'
      },
      'deployment_failure' => {
        'condition' => 'deployment_failed',
        'action' => 'notify_devops_team'
      }
    }
    
    ChatClient.log "Security alerts configured: #{alerts.to_json}"
  end
end

if __FILE__ == $0
  setup = SecurityAlertSetup.new
  setup.setup_github_alerts
end
```

## Conclusion

This implementation guide provides a comprehensive approach to setting up the private security fork workflow. The phased approach ensures minimal disruption while providing robust security capabilities.

Key success factors:
1. **Thorough Testing**: Test all components before production use
2. **Team Training**: Ensure all team members understand the new workflow
3. **Monitoring**: Set up comprehensive monitoring and alerting
4. **Documentation**: Maintain up-to-date documentation and runbooks
5. **Regular Review**: Regularly review and improve the process

The security fork workflow will significantly improve Code.org's ability to handle security fixes while maintaining their open source values and community engagement.