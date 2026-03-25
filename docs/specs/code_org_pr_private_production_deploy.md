# Code.org Repository PR

**Title:** `Add Private Production Deploy Workflow for Security Fixes`

**Description:**
```markdown
## Overview
Implements a private production deploy workflow to address security vulnerability exposure window. This allows security fixes to be developed, tested, and deployed privately before public disclosure.

## Problem
Currently, security fixes are immediately visible in our public repository when committed, creating a vulnerability window where attackers can see and potentially exploit fixes before they're deployed to production.

## Solution
- **Private Production Repository**: `code-dot-org-production` (to be created)
- **Automated Sync**: Lambda function syncs public `production` → private `production` on every push
- **AMI Builder Integration**: Modified to watch private repo instead of public repo
- **Manual Back-Sync**: Interactive tool to cherry-pick private changes back to public repo

## Changes Made

### GitHub Actions Workflow
- **File**: `.github/workflows/private-production-sync.yml`
- **Purpose**: Triggers Lambda function when production branch is pushed
- **Security**: Passes GitHub webhook signature and API key for authentication

### CI Build Modifications
- **File**: `aws/ci_build`
- **Phase 1**: Added monitoring logic to verify private repo matches public repo
- **Phase 2**: Will switch to watch private repo instead of public repo

### Documentation
- **File**: `docs/specs/20250115_143000_private_production_deploy_workflow.md`
- **Purpose**: Complete specification of the private production deploy workflow

## Implementation Plan
1. **Phase 1**: Set up sync mechanism and monitor for several weeks
2. **Phase 2**: Switch AMI Builder to watch private repo
3. **Phase 3**: Test full security fix workflow

## Security Features
- GitHub webhook signature verification
- API key authentication
- Repository and branch verification
- No automatic back-sync (manual process only)

## Related Infrastructure PR
This PR works in conjunction with infrastructure changes in the infrastructure repository.

## Testing
- [ ] Phase 1 monitoring works correctly
- [ ] GitHub Actions triggers Lambda successfully
- [ ] CI Build verification logic functions properly
```