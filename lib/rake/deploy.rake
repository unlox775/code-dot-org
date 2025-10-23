require_relative '../../deployment'
require 'cdo/chat_client'
require 'cdo/rake_utils'

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

  desc 'Create security branch'
  task :create_security_branch, [:branch_name] do |t, args|
    require 'lib/scripts/security_fork_sync'
    syncer = SecurityForkSyncer.new
    syncer.create_security_branch(args[:branch_name])
  end

  desc 'Merge security fix'
  task :merge_security_fix, [:branch_name] do |t, args|
    require 'lib/scripts/security_fork_sync'
    syncer = SecurityForkSyncer.new
    syncer.merge_security_fix(args[:branch_name])
  end
end