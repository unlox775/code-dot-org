require_relative '../../deployment'
require 'cdo/chat_client'
require 'cdo/rake_utils'

namespace :deploy do
  desc 'Deploy from private production repo'
  task :private_production do
    ENV['PRIVATE_PRODUCTION_DEPLOY'] = 'true'
    Rake::Task['deploy:production'].invoke
  end

  desc 'Sync private production from public'
  task :sync_private_production do
    require 'lib/scripts/private_production_sync'
    syncer = PrivateProductionSyncer.new
    syncer.sync_from_public_staging
  end

  desc 'Sync public from private production'
  task :sync_public_from_private do
    require 'lib/scripts/private_production_sync'
    syncer = PrivateProductionSyncer.new
    syncer.sync_to_public_production
  end

  desc 'Create security branch'
  task :create_security_branch, [:branch_name] do |t, args|
    require 'lib/scripts/private_production_sync'
    syncer = PrivateProductionSyncer.new
    syncer.create_security_branch(args[:branch_name])
  end

  desc 'Merge security fix'
  task :merge_security_fix, [:branch_name] do |t, args|
    require 'lib/scripts/private_production_sync'
    syncer = PrivateProductionSyncer.new
    syncer.merge_security_fix(args[:branch_name])
  end
end