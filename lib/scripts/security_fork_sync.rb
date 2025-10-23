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