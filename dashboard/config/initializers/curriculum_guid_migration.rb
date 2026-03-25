# Configuration for curriculum GUID migration
# Sets up S3 integration and other migration settings

Rails.application.configure do
  # S3 Configuration for curriculum master data
  config.curriculum_master_bucket = ENV['CURRICULUM_MASTER_BUCKET'] || 'code-dot-org-curriculum-master'
  config.curriculum_s3_prefix = 'curriculum-data'
  
  # Migration settings
  config.guid_migration_enabled = ENV['GUID_MIGRATION_ENABLED'] == 'true'
  config.guid_migration_dry_run = ENV['GUID_MIGRATION_DRY_RUN'] == 'true'
  
  # Export/Import settings
  config.curriculum_export_batch_size = (ENV['CURRICULUM_EXPORT_BATCH_SIZE'] || 1000).to_i
  config.curriculum_import_batch_size = (ENV['CURRICULUM_IMPORT_BATCH_SIZE'] || 1000).to_i
  config.curriculum_compression_enabled = ENV['CURRICULUM_COMPRESSION_ENABLED'] != 'false'
  
  # Performance settings
  config.curriculum_cache_enabled = ENV['CURRICULUM_CACHE_ENABLED'] != 'false'
  config.curriculum_cache_ttl = (ENV['CURRICULUM_CACHE_TTL'] || 3600).to_i
  
  # Validation settings
  config.curriculum_validation_enabled = ENV['CURRICULUM_VALIDATION_ENABLED'] != 'false'
  config.curriculum_validation_batch_size = (ENV['CURRICULUM_VALIDATION_BATCH_SIZE'] || 100).to_i
end

# AWS S3 Configuration
if Rails.env.production? || Rails.env.staging?
  Aws.config.update({
    region: ENV['AWS_REGION'] || 'us-east-1',
    credentials: Aws::Credentials.new(
      ENV['AWS_ACCESS_KEY_ID'],
      ENV['AWS_SECRET_ACCESS_KEY']
    )
  })
end

# Logging configuration for migration
Rails.application.config.after_initialize do
  if Rails.logger.respond_to?(:formatter)
    Rails.logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
    end
  end
end

# Migration status tracking
class CurriculumGuidMigrationStatus
  include Singleton
  
  attr_accessor :phase, :status, :started_at, :completed_at, :errors
  
  def initialize
    @phase = 'not_started'
    @status = 'pending'
    @started_at = nil
    @completed_at = nil
    @errors = []
  end
  
  def start_phase(phase_name)
    @phase = phase_name
    @status = 'in_progress'
    @started_at = Time.current
    @errors = []
  end
  
  def complete_phase
    @status = 'completed'
    @completed_at = Time.current
  end
  
  def add_error(error)
    @errors << {
      message: error.message,
      backtrace: error.backtrace,
      timestamp: Time.current
    }
  end
  
  def to_hash
    {
      phase: @phase,
      status: @status,
      started_at: @started_at,
      completed_at: @completed_at,
      errors: @errors,
      duration: @completed_at ? (@completed_at - @started_at) : nil
    }
  end
end

# Add migration status to Rails console
if defined?(Rails::Console)
  puts "Curriculum GUID Migration Status: #{CurriculumGuidMigrationStatus.instance.to_hash}"
end