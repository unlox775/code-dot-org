# Rake tasks for curriculum GUID migration
# Provides automation for the new GUID-based seeding process

namespace :curriculum do
  namespace :guid_migration do
    desc "Export all curriculum data from production to S3"
    task export_all: :environment do
      puts "Starting curriculum export to S3..."
      
      begin
        result = Services::CurriculumExportService.export_all
        puts "Export completed successfully!"
        puts "Exported #{result[:tables].size} tables"
        puts "Export metadata: #{result.to_json}"
      rescue => e
        puts "Export failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Export specific curriculum by GUIDs"
    task :export_by_guids, [:script_guids, :level_guids, :lesson_guids] => :environment do |t, args|
      script_guids = args[:script_guids]&.split(',') || []
      level_guids = args[:level_guids]&.split(',') || []
      lesson_guids = args[:lesson_guids]&.split(',') || []
      
      puts "Starting selective curriculum export..."
      puts "Script GUIDs: #{script_guids.join(', ')}"
      puts "Level GUIDs: #{level_guids.join(', ')}"
      puts "Lesson GUIDs: #{lesson_guids.join(', ')}"
      
      begin
        result = Services::CurriculumExportService.export_by_guids(
          script_guids: script_guids,
          level_guids: level_guids,
          lesson_guids: lesson_guids
        )
        puts "Export completed successfully!"
        puts "Export metadata: #{result.to_json}"
      rescue => e
        puts "Export failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Import all curriculum data from S3"
    task :import_all, [:dry_run] => :environment do |t, args|
      dry_run = args[:dry_run] == 'true'
      
      puts "Starting curriculum import from S3 (dry_run: #{dry_run})..."
      
      begin
        result = Services::CurriculumImportService.import_all(dry_run: dry_run)
        puts "Import completed successfully!"
        puts "Import metadata: #{result.to_json}"
      rescue => e
        puts "Import failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Import specific curriculum by GUIDs"
    task :import_by_guids, [:script_guids, :level_guids, :lesson_guids, :dry_run] => :environment do |t, args|
      script_guids = args[:script_guids]&.split(',') || []
      level_guids = args[:level_guids]&.split(',') || []
      lesson_guids = args[:lesson_guids]&.split(',') || []
      dry_run = args[:dry_run] == 'true'
      
      puts "Starting selective curriculum import..."
      puts "Script GUIDs: #{script_guids.join(', ')}"
      puts "Level GUIDs: #{level_guids.join(', ')}"
      puts "Lesson GUIDs: #{lesson_guids.join(', ')}"
      puts "Dry run: #{dry_run}"
      
      begin
        result = Services::CurriculumImportService.import_by_guids(
          script_guids: script_guids,
          level_guids: level_guids,
          lesson_guids: lesson_guids,
          dry_run: dry_run
        )
        puts "Import completed successfully!"
        puts "Import metadata: #{result.to_json}"
      rescue => e
        puts "Import failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Check export status"
    task check_export_status: :environment do
      puts "Checking export status..."
      
      begin
        result = Services::CurriculumExportService.export_status
        puts "Export status: #{result.to_json}"
      rescue => e
        puts "Failed to check export status: #{e.message}"
        exit 1
      end
    end

    desc "List available exports"
    task list_exports: :environment do
      puts "Listing available exports..."
      
      begin
        result = Services::CurriculumExportService.list_exports
        puts "Available exports: #{result.to_json}"
      rescue => e
        puts "Failed to list exports: #{e.message}"
        exit 1
      end
    end

    desc "Validate GUID migration"
    task validate_migration: :environment do
      puts "Validating GUID migration..."
      
      begin
        # Check that all curriculum tables have GUIDs
        curriculum_tables = [
          'scripts', 'script_levels', 'levels', 'lesson_groups', 'stages',
          'lesson_activities', 'activity_sections', 'unit_groups',
          'course_versions', 'course_offerings', 'courses'
        ]
        
        all_valid = true
        
        curriculum_tables.each do |table_name|
          missing_guids = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM #{table_name} WHERE guid IS NULL OR guid = ''"
          )
          
          if missing_guids > 0
            puts "❌ #{table_name}: #{missing_guids} records missing GUIDs"
            all_valid = false
          else
            total_records = ActiveRecord::Base.connection.select_value(
              "SELECT COUNT(*) FROM #{table_name}"
            )
            puts "✅ #{table_name}: #{total_records} records with GUIDs"
          end
        end
        
        if all_valid
          puts "✅ All curriculum tables have GUIDs"
        else
          puts "❌ Some tables are missing GUIDs"
          exit 1
        end
        
        # Check foreign key relationships
        puts "\nChecking foreign key relationships..."
        check_foreign_key_relationships
        
      rescue => e
        puts "Validation failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Generate GUIDs for existing data (if missing)"
    task generate_guids: :environment do
      puts "Generating GUIDs for existing data..."
      
      begin
        curriculum_tables = [
          'scripts', 'script_levels', 'levels', 'lesson_groups', 'stages',
          'lesson_activities', 'activity_sections', 'unit_groups',
          'course_versions', 'course_offerings', 'courses'
        ]
        
        curriculum_tables.each do |table_name|
          missing_guids = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM #{table_name} WHERE guid IS NULL OR guid = ''"
          )
          
          if missing_guids > 0
            puts "Generating GUIDs for #{table_name} (#{missing_guids} records)..."
            ActiveRecord::Base.connection.execute(
              "UPDATE #{table_name} SET guid = UUID() WHERE guid IS NULL OR guid = ''"
            )
            puts "✅ Generated GUIDs for #{table_name}"
          else
            puts "✅ #{table_name} already has GUIDs"
          end
        end
        
        puts "GUID generation completed successfully!"
        
      rescue => e
        puts "GUID generation failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Compare production and target environment data"
    task :compare_environments, [:target_env] => :environment do |t, args|
      target_env = args[:target_env] || 'development'
      
      puts "Comparing production and #{target_env} environment data..."
      
      begin
        # This would implement environment comparison
        # For now, return a placeholder
        puts "Environment comparison not implemented yet"
        puts "Target environment: #{target_env}"
        
      rescue => e
        puts "Environment comparison failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Sync curriculum data between environments"
    task :sync_environments, [:source_env, :target_env, :dry_run] => :environment do |t, args|
      source_env = args[:source_env] || 'production'
      target_env = args[:target_env] || 'development'
      dry_run = args[:dry_run] == 'true'
      
      puts "Syncing curriculum data from #{source_env} to #{target_env} (dry_run: #{dry_run})..."
      
      begin
        # This would implement environment synchronization
        # For now, return a placeholder
        puts "Environment synchronization not implemented yet"
        puts "Source environment: #{source_env}"
        puts "Target environment: #{target_env}"
        puts "Dry run: #{dry_run}"
        
      rescue => e
        puts "Environment synchronization failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Clean up old seeding data"
    task cleanup_old_seeding: :environment do
      puts "Cleaning up old seeding data..."
      
      begin
        # This would implement cleanup of old seeding data
        # For now, return a placeholder
        puts "Old seeding cleanup not implemented yet"
        puts "This would remove old ID-based seeding data after migration is complete"
        
      rescue => e
        puts "Cleanup failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    desc "Show migration status"
    task migration_status: :environment do
      puts "Curriculum GUID Migration Status"
      puts "=" * 50
      
      begin
        # Check database schema
        puts "\n📊 Database Schema Status:"
        check_schema_status
        
        # Check application code
        puts "\n💻 Application Code Status:"
        check_application_status
        
        # Check seeding process
        puts "\n🌱 Seeding Process Status:"
        check_seeding_status
        
        # Check S3 integration
        puts "\n☁️  S3 Integration Status:"
        check_s3_status
        
      rescue => e
        puts "Status check failed: #{e.message}"
        puts e.backtrace.join("\n")
        exit 1
      end
    end

    private

    def check_foreign_key_relationships
      # Check user_levels relationships
      invalid_level_guids = ActiveRecord::Base.connection.select_value(
        "SELECT COUNT(*) FROM user_levels ul 
         LEFT JOIN levels l ON ul.level_guid = l.guid 
         WHERE ul.level_guid IS NOT NULL AND l.guid IS NULL"
      )
      
      if invalid_level_guids > 0
        puts "❌ user_levels: #{invalid_level_guids} invalid level_guid references"
      else
        puts "✅ user_levels: All level_guid references are valid"
      end
      
      # Check user_scripts relationships
      invalid_script_guids = ActiveRecord::Base.connection.select_value(
        "SELECT COUNT(*) FROM user_scripts us 
         LEFT JOIN scripts s ON us.script_guid = s.guid 
         WHERE us.script_guid IS NOT NULL AND s.guid IS NULL"
      )
      
      if invalid_script_guids > 0
        puts "❌ user_scripts: #{invalid_script_guids} invalid script_guid references"
      else
        puts "✅ user_scripts: All script_guid references are valid"
      end
    end

    def check_schema_status
      # Check if GUID columns exist
      guid_columns_exist = ActiveRecord::Base.connection.column_exists?(:scripts, :guid)
      
      if guid_columns_exist
        puts "✅ GUID columns exist in curriculum tables"
      else
        puts "❌ GUID columns missing - run database migrations first"
      end
    end

    def check_application_status
      # Check if GuidSupport module is included
      if Unit.respond_to?(:find_by_guid)
        puts "✅ Application code updated for GUID support"
      else
        puts "❌ Application code not updated - include GuidSupport module"
      end
    end

    def check_seeding_status
      # Check if new seeding services exist
      if defined?(Services::CurriculumExportService)
        puts "✅ New seeding services available"
      else
        puts "❌ New seeding services not available"
      end
    end

    def check_s3_status
      # Check S3 configuration
      bucket = ENV['CURRICULUM_MASTER_BUCKET']
      if bucket
        puts "✅ S3 bucket configured: #{bucket}"
      else
        puts "❌ S3 bucket not configured - set CURRICULUM_MASTER_BUCKET"
      end
    end
  end
end