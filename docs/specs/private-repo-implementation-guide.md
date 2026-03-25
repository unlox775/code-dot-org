# Private Repository Implementation Guide

> **⚠️ AI Generated Implementation Guide**  
> This is a technical implementation guide for setting up the private repository deployment pattern.

## Quick Start

### 1. Create Private Repository

```bash
# Create private fork of public repository
gh repo create code-dot-org-production --private --source=code-dot-org

# Clone the private repository
git clone https://github.com/code-dot-org/code-dot-org-production.git
cd code-dot-org-production

# Add public repository as upstream
git remote add upstream https://github.com/code-dot-org/code-dot-org.git
```

### 2. Set Up Automated Sync

Create a GitHub Action workflow (`.github/workflows/sync-from-public.yml`):

```yaml
name: Sync from Public Repository

on:
  schedule:
    - cron: '*/5 * * * *'  # Every 5 minutes
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Private Repository
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.PRIVATE_REPO_TOKEN }}
          repository: code-dot-org/code-dot-org-production
          fetch-depth: 0

      - name: Configure Git
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"

      - name: Add Public Repository as Upstream
        run: |
          git remote add upstream https://github.com/code-dot-org/code-dot-org.git
          git fetch upstream

      - name: Sync Staging Branch
        run: |
          git checkout staging
          git merge upstream/staging
          git push origin staging

      - name: Sync Production Branch
        run: |
          git checkout production
          git merge upstream/production
          git push origin production

      - name: Handle Merge Conflicts
        if: failure()
        run: |
          echo "Merge conflict detected. Manual intervention required."
          # Send notification to security team
```

### 3. Update CI Build Script

Modify `aws/ci_build` to use private repository:

```ruby
# Add this to the top of ci_build
PRIVATE_REPO_URL = 'https://github.com/code-dot-org/code-dot-org-production.git'

def setup_private_repo
  return if File.directory?('.git')
  
  # Clone private repository if not already present
  system("git clone #{PRIVATE_REPO_URL} .")
end

# Modify the build function
def build
  setup_private_repo
  Dir.chdir(deploy_dir) do
    # Rest of existing build logic
  end
end
```

### 4. Create Security Branch Workflow

Create `.github/workflows/security-deployment.yml`:

```yaml
name: Security Deployment

on:
  push:
    branches: [security]
  workflow_dispatch:

jobs:
  security-deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/security'
    steps:
      - name: Checkout Security Branch
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.SECURITY_TEAM_TOKEN }}
          ref: security

      - name: Deploy Security Fix
        run: |
          # Deploy security fix to production
          ./bin/deploy-security-fix.sh

      - name: Notify Security Team
        run: |
          # Send notification to security team
          curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Security deployment completed"}' \
            ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Detailed Implementation

### Repository Configuration

#### 1. Branch Protection Rules

Set up branch protection for the private repository:

```bash
# Protect production branch
gh api repos/code-dot-org/code-dot-org-production/branches/production/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2}' \
  --field restrictions='{"users":["security-team"],"teams":["security"]}'
```

#### 2. Access Control

Create teams and set permissions:

```bash
# Create security team
gh api orgs/code-dot-org/teams --method POST \
  --field name="security-team" \
  --field description="Security team with access to private repository"

# Add members to security team
gh api teams/SECURITY_TEAM_ID/members --method PUT \
  --field username="security-member-1"

# Set repository permissions
gh api repos/code-dot-org/code-dot-org-production/collaborators/SECURITY_TEAM \
  --method PUT \
  --field permission="admin"
```

### Sync System Implementation

#### 1. Advanced Sync Script

Create `scripts/advanced-sync.sh`:

```bash
#!/bin/bash
set -e

# Configuration
PUBLIC_REPO="code-dot-org/code-dot-org"
PRIVATE_REPO="code-dot-org/code-dot-org-production"
BRANCHES=("staging" "production")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

# Function to sync a branch
sync_branch() {
    local branch=$1
    log "Syncing branch: $branch"
    
    # Fetch latest changes
    git fetch upstream
    
    # Checkout branch
    git checkout $branch
    
    # Merge changes
    if git merge upstream/$branch; then
        log "Successfully merged $branch"
        git push origin $branch
    else
        error "Merge conflict in $branch"
        # Send notification
        curl -X POST -H 'Content-type: application/json' \
          --data "{\"text\":\"Merge conflict in $branch branch\"}" \
          $SLACK_WEBHOOK_URL
        return 1
    fi
}

# Main sync process
main() {
    log "Starting sync process"
    
    # Add upstream remote if not exists
    if ! git remote | grep -q upstream; then
        git remote add upstream https://github.com/$PUBLIC_REPO.git
    fi
    
    # Fetch all changes
    git fetch upstream
    git fetch origin
    
    # Sync each branch
    for branch in "${BRANCHES[@]}"; do
        sync_branch $branch
    done
    
    log "Sync process completed"
}

# Run main function
main "$@"
```

#### 2. Conflict Resolution

Create `scripts/resolve-conflicts.sh`:

```bash
#!/bin/bash
# Conflict resolution script

resolve_conflicts() {
    local branch=$1
    
    log "Resolving conflicts in $branch"
    
    # Check for conflicts
    if git status | grep -q "both modified"; then
        warn "Conflicts detected in $branch"
        
        # Try automatic resolution
        git checkout --ours .
        git add .
        
        if git commit -m "Resolve merge conflicts automatically"; then
            log "Conflicts resolved automatically"
            git push origin $branch
        else
            error "Automatic conflict resolution failed"
            # Notify security team
            notify_security_team "Manual conflict resolution required in $branch"
        fi
    fi
}

notify_security_team() {
    local message=$1
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$message\"}" \
      $SLACK_WEBHOOK_URL
}
```

### Deployment Pipeline Updates

#### 1. Update CI Build Script

Modify `aws/ci_build` to work with private repository:

```ruby
# Add private repository configuration
PRIVATE_REPO_CONFIG = {
  url: 'https://github.com/code-dot-org/code-dot-org-production.git',
  token: ENV['PRIVATE_REPO_TOKEN'],
  branch: 'production'
}

def setup_private_repo
  return if File.directory?('.git')
  
  # Clone private repository
  repo_url = "https://#{PRIVATE_REPO_CONFIG[:token]}@github.com/code-dot-org/code-dot-org-production.git"
  system("git clone #{repo_url} .")
  
  # Set up git configuration
  system("git config user.name 'CI Build'")
  system("git config user.email 'ci@code.org'")
end

def sync_from_private
  Dir.chdir(deploy_dir) do
    # Fetch latest changes from private repository
    system("git fetch origin")
    system("git checkout #{PRIVATE_REPO_CONFIG[:branch]}")
    system("git pull origin #{PRIVATE_REPO_CONFIG[:branch]}")
  end
end

# Modify main build function
def build
  setup_private_repo
  sync_from_private
  
  Dir.chdir(deploy_dir) do
    # Rest of existing build logic
    return 0 unless RakeUtils.git_updates_available? || File.file?(STARTED) || !CDO.daemon
    
    # ... existing build logic ...
  end
end
```

#### 2. Update GitHub Actions

Modify existing workflows to use private repository:

```yaml
# Update .github/workflows/ci_pipeline.yml
name: CI Pipeline

on:
  push:
    branches: [production]
    repository: code-dot-org/code-dot-org-production

env:
  REPOSITORY: code-dot-org/code-dot-org-production
  # ... existing environment variables ...

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Private Repository
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.PRIVATE_REPO_TOKEN }}
          repository: code-dot-org/code-dot-org-production
          ref: production
```

### Security Implementation

#### 1. Security Branch Workflow

Create `.github/workflows/security-deployment.yml`:

```yaml
name: Security Deployment

on:
  push:
    branches: [security]
  workflow_dispatch:
    inputs:
      security_level:
        description: 'Security Level'
        required: true
        default: 'high'
        type: choice
        options:
          - low
          - medium
          - high
          - critical

jobs:
  security-deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/security'
    environment: security-production
    steps:
      - name: Checkout Security Branch
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.SECURITY_TEAM_TOKEN }}
          ref: security

      - name: Validate Security Fix
        run: |
          # Run security validation
          ./scripts/validate-security-fix.sh

      - name: Deploy Security Fix
        run: |
          # Deploy based on security level
          case "${{ github.event.inputs.security_level }}" in
            "critical")
              ./scripts/deploy-critical-security.sh
              ;;
            "high")
              ./scripts/deploy-high-security.sh
              ;;
            *)
              ./scripts/deploy-standard-security.sh
              ;;
          esac

      - name: Notify Security Team
        run: |
          ./scripts/notify-security-team.sh "${{ github.event.inputs.security_level }}"
```

#### 2. Security Validation Script

Create `scripts/validate-security-fix.sh`:

```bash
#!/bin/bash
# Security fix validation script

validate_security_fix() {
    local security_level=$1
    
    log "Validating security fix (level: $security_level)"
    
    # Check for security team approval
    if ! check_security_approval; then
        error "Security fix not approved by security team"
        exit 1
    fi
    
    # Run security tests
    if ! run_security_tests; then
        error "Security tests failed"
        exit 1
    fi
    
    # Validate fix doesn't break existing functionality
    if ! run_regression_tests; then
        error "Regression tests failed"
        exit 1
    fi
    
    log "Security fix validation passed"
}

check_security_approval() {
    # Check if security team has approved the fix
    # This would integrate with your approval system
    return 0
}

run_security_tests() {
    # Run security-specific tests
    # This would run your security test suite
    return 0
}

run_regression_tests() {
    # Run regression tests to ensure fix doesn't break functionality
    # This would run your regression test suite
    return 0
}
```

### Monitoring and Alerting

#### 1. Sync Monitoring

Create `scripts/monitor-sync.sh`:

```bash
#!/bin/bash
# Sync monitoring script

monitor_sync() {
    local last_sync=$(git log -1 --format=%ct)
    local current_time=$(date +%s)
    local time_diff=$((current_time - last_sync))
    
    # Alert if sync is more than 1 hour old
    if [ $time_diff -gt 3600 ]; then
        error "Sync is $((time_diff / 60)) minutes old"
        notify_sync_delay $time_diff
    fi
}

notify_sync_delay() {
    local delay=$1
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"Sync delay: $((delay / 60)) minutes\"}" \
      $SLACK_WEBHOOK_URL
}
```

#### 2. Deployment Monitoring

Create `scripts/monitor-deployment.sh`:

```bash
#!/bin/bash
# Deployment monitoring script

monitor_deployment() {
    local deployment_status=$1
    
    case $deployment_status in
        "success")
            log "Deployment successful"
            notify_deployment_success
            ;;
        "failure")
            error "Deployment failed"
            notify_deployment_failure
            ;;
        "timeout")
            error "Deployment timed out"
            notify_deployment_timeout
            ;;
    esac
}

notify_deployment_success() {
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"✅ Deployment successful"}' \
      $SLACK_WEBHOOK_URL
}

notify_deployment_failure() {
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"❌ Deployment failed"}' \
      $SLACK_WEBHOOK_URL
}
```

## Testing the Implementation

### 1. Test Sync Process

```bash
# Test sync with a test repository
./scripts/advanced-sync.sh --test-mode

# Verify sync worked
git log --oneline -10
```

### 2. Test Security Deployment

```bash
# Create test security branch
git checkout -b security-test
echo "Test security fix" > test-fix.txt
git add test-fix.txt
git commit -m "Test security fix"
git push origin security-test

# Test security deployment workflow
gh workflow run security-deployment.yml -f security_level=high
```

### 3. Test Rollback

```bash
# Test rollback procedure
./scripts/rollback-deployment.sh --test-mode

# Verify rollback worked
git log --oneline -5
```

## Troubleshooting

### Common Issues

1. **Sync Failures**
   - Check network connectivity
   - Verify authentication tokens
   - Check for merge conflicts

2. **Deployment Failures**
   - Check deployment logs
   - Verify environment variables
   - Check resource availability

3. **Access Control Issues**
   - Verify team permissions
   - Check repository settings
   - Verify token permissions

### Debug Commands

```bash
# Check sync status
git status
git log --oneline -10

# Check deployment status
./scripts/check-deployment-status.sh

# Check access permissions
gh api repos/code-dot-org/code-dot-org-production/collaborators
```

## Maintenance

### Regular Tasks

1. **Weekly**
   - Review sync logs
   - Check access permissions
   - Update documentation

2. **Monthly**
   - Rotate authentication tokens
   - Review security team access
   - Update monitoring alerts

3. **Quarterly**
   - Review and update procedures
   - Conduct security audit
   - Update training materials

## Conclusion

This implementation guide provides a comprehensive approach to setting up the private repository deployment pattern. The key is to start with a simple implementation and gradually add more sophisticated features as needed.

Remember to:
- Test thoroughly in a non-production environment
- Document all changes and procedures
- Train your team on the new processes
- Monitor the system closely after deployment