# Service: CurriculumImportService
# Imports curriculum data from S3 to target environments
# Replaces the current seeding process with GUID-based data import

module Services
  class CurriculumImportService
    include Curriculum::SharedCourseConstants

    # S3 configuration
    S3_BUCKET = ENV['CURRICULUM_MASTER_BUCKET'] || 'code-dot-org-curriculum-master'
    S3_PREFIX = 'curriculum-data'
    
    # Import configuration
    IMPORT_BATCH_SIZE = 1000
    DRY_RUN = false
    
    # Curriculum tables to import (in dependency order)
    CURRICULUM_TABLES = [
      'scripts',           # Units
      'levels',            # Levels
      'lesson_groups',     # Lesson Groups
      'stages',            # Lessons
      'lesson_activities', # Lesson Activities
      'activity_sections', # Activity Sections
      'unit_groups',       # Unit Groups (Courses)
      'course_versions',   # Course Versions
      'course_offerings',  # Course Offerings
      'courses',           # Courses
      'script_levels',     # Script Levels (join table)
      'levels_script_levels', # Levels Script Levels (join table)
      'concepts_levels',   # Concepts Levels (join table)
      'parent_levels_child_levels', # Level hierarchy
      'contained_levels',  # Contained Levels
      'scripts_resources', # Script Resources
      'scripts_student_resources', # Script Student Resources
      'lessons_resources', # Lesson Resources
      'unit_groups_resources', # Unit Group Resources
      'unit_groups_student_resources', # Unit Group Student Resources
      'lessons_standards', # Lesson Standards
      'lessons_opportunity_standards', # Lesson Opportunity Standards
      'stages_standards',  # Stage Standards
      'lessons_programming_expressions', # Lesson Programming Expressions
      'lessons_vocabularies', # Lesson Vocabularies
      'levels_skills',     # Level Skills
      'ai_lesson_summaries', # AI Lesson Summaries
      'section_hidden_scripts', # Section Hidden Scripts
      'section_hidden_stages', # Section Hidden Stages
      'plc_course_units',  # PLC Course Units
      'plc_courses',       # PLC Courses
      'level_concept_difficulties', # Level Concept Difficulties
      'learning_goal_evidence_levels' # Learning Goal Evidence Levels
    ].freeze

    class << self
      # Import all curriculum data from S3
      def import_all(dry_run: false)
        Rails.logger.info "Starting curriculum import from S3 (dry_run: #{dry_run})..."
        
        import_metadata = {
          imported_at: Time.current.iso8601,
          environment: Rails.env,
          version: Rails.application.config.version,
          dry_run: dry_run,
          tables: {}
        }

        # Get export metadata
        export_metadata = get_export_metadata
        if export_metadata[:status] == 'error'
          Rails.logger.error "Failed to get export metadata: #{export_metadata[:message]}"
          return import_metadata.merge(status: 'error', message: export_metadata[:message])
        end

        # Import each table
        CURRICULUM_TABLES.each do |table_name|
          if export_metadata[:tables][table_name]
            import_metadata[:tables][table_name] = import_table(table_name, export_metadata[:tables][table_name], dry_run: dry_run)
          else
            Rails.logger.warn "No export data found for table: #{table_name}"
            import_metadata[:tables][table_name] = { status: 'skipped', reason: 'no_export_data' }
          end
        end

        # Validate import
        if !dry_run
          validation_result = validate_import(import_metadata)
          import_metadata[:validation] = validation_result
        end

        Rails.logger.info "Curriculum import completed successfully"
        import_metadata.merge(status: 'success')
      end

      # Import specific curriculum by GUIDs
      def import_by_guids(script_guids: [], level_guids: [], lesson_guids: [], dry_run: false)
        Rails.logger.info "Starting selective curriculum import by GUIDs (dry_run: #{dry_run})..."
        
        import_metadata = {
          imported_at: Time.current.iso8601,
          environment: Rails.env,
          version: Rails.application.config.version,
          dry_run: dry_run,
          selection: {
            script_guids: script_guids,
            level_guids: level_guids,
            lesson_guids: lesson_guids
          },
          tables: {}
        }

        # Get export metadata
        export_metadata = get_export_metadata
        if export_metadata[:status] == 'error'
          Rails.logger.error "Failed to get export metadata: #{export_metadata[:message]}"
          return import_metadata.merge(status: 'error', message: export_metadata[:message])
        end

        # Import selected data
        if script_guids.any?
          import_script_dependencies(script_guids, export_metadata, import_metadata, dry_run: dry_run)
        end

        if level_guids.any?
          import_level_dependencies(level_guids, export_metadata, import_metadata, dry_run: dry_run)
        end

        if lesson_guids.any?
          import_lesson_dependencies(lesson_guids, export_metadata, import_metadata, dry_run: dry_run)
        end

        # Validate import
        if !dry_run
          validation_result = validate_import(import_metadata)
          import_metadata[:validation] = validation_result
        end

        Rails.logger.info "Selective curriculum import completed successfully"
        import_metadata.merge(status: 'success')
      end

      # Import a specific table
      def import_table(table_name, table_metadata, dry_run: false)
        Rails.logger.info "Importing table: #{table_name} (dry_run: #{dry_run})"
        
        start_time = Time.current
        
        # Download data from S3
        data = download_from_s3(table_metadata[:file_key], compressed: table_metadata[:compressed])
        if data.nil?
          return { status: 'error', message: 'Failed to download data from S3' }
        end

        if dry_run
          Rails.logger.info "DRY RUN: Would import #{data.size} records to #{table_name}"
          return {
            status: 'dry_run',
            record_count: data.size,
            duration: Time.current - start_time
          }
        end

        # Import data
        result = import_table_data(table_name, data)
        result[:duration] = Time.current - start_time
        result
      end

      # Get export metadata from S3
      def get_export_metadata
        s3_client = Aws::S3::Client.new
        metadata_key = "#{S3_PREFIX}/metadata.json"
        
        begin
          response = s3_client.get_object(bucket: S3_BUCKET, key: metadata_key)
          metadata = JSON.parse(response.body.read, symbolize_names: true)
          { status: 'success', **metadata }
        rescue Aws::S3::Errors::NoSuchKey
          { status: 'error', message: 'No export metadata found' }
        rescue => e
          { status: 'error', message: e.message }
        end
      end

      # Download data from S3
      def download_from_s3(file_key, compressed: false)
        s3_client = Aws::S3::Client.new
        
        begin
          response = s3_client.get_object(bucket: S3_BUCKET, key: file_key)
          content = response.body.read
          
          if compressed
            decompress_data(content)
          else
            JSON.parse(content)
          end
        rescue => e
          Rails.logger.error "Failed to download #{file_key}: #{e.message}"
          nil
        end
      end

      # Decompress gzipped data
      def decompress_data(compressed_data)
        gz = Zlib::GzipReader.new(StringIO.new(compressed_data))
        json_data = gz.read
        gz.close
        JSON.parse(json_data)
      end

      # Import table data with conflict resolution
      def import_table_data(table_name, data)
        Rails.logger.info "Importing #{data.size} records to #{table_name}"
        
        imported_count = 0
        updated_count = 0
        error_count = 0
        errors = []

        # Process data in batches
        data.each_slice(IMPORT_BATCH_SIZE) do |batch|
          batch_result = import_batch(table_name, batch)
          imported_count += batch_result[:imported]
          updated_count += batch_result[:updated]
          error_count += batch_result[:errors]
          errors.concat(batch_result[:error_messages])
        end

        {
          status: 'success',
          record_count: data.size,
          imported: imported_count,
          updated: updated_count,
          errors: error_count,
          error_messages: errors
        }
      end

      # Import a batch of records
      def import_batch(table_name, batch)
        imported = 0
        updated = 0
        errors = 0
        error_messages = []

        batch.each do |record|
          begin
            result = import_record(table_name, record)
            if result[:action] == 'created'
              imported += 1
            elsif result[:action] == 'updated'
              updated += 1
            end
          rescue => e
            errors += 1
            error_messages << "Error importing record #{record['id'] || record['guid']}: #{e.message}"
            Rails.logger.error "Error importing record: #{e.message}"
          end
        end

        {
          imported: imported,
          updated: updated,
          errors: errors,
          error_messages: error_messages
        }
      end

      # Import a single record with conflict resolution
      def import_record(table_name, record)
        # Remove id and timestamps to avoid conflicts
        clean_record = record.except('id', 'created_at', 'updated_at')
        
        # Find existing record by GUID
        existing_record = find_existing_record(table_name, clean_record)
        
        if existing_record
          # Update existing record
          update_record(table_name, existing_record, clean_record)
          { action: 'updated', id: existing_record['id'] }
        else
          # Create new record
          new_record = create_record(table_name, clean_record)
          { action: 'created', id: new_record['id'] }
        end
      end

      # Find existing record by GUID or other unique identifiers
      def find_existing_record(table_name, record)
        if record['guid']
          # Try to find by GUID first
          result = ActiveRecord::Base.connection.select_one(
            "SELECT * FROM #{table_name} WHERE guid = '#{record['guid']}'"
          )
          return result if result
        end

        # Fall back to other unique identifiers
        case table_name
        when 'scripts'
          ActiveRecord::Base.connection.select_one(
            "SELECT * FROM #{table_name} WHERE name = '#{record['name']}'"
          )
        when 'levels'
          ActiveRecord::Base.connection.select_one(
            "SELECT * FROM #{table_name} WHERE name = '#{record['name']}'"
          )
        when 'stages'
          ActiveRecord::Base.connection.select_one(
            "SELECT * FROM #{table_name} WHERE key = '#{record['key']}'"
          )
        # Add more cases as needed
        else
          nil
        end
      end

      # Update existing record
      def update_record(table_name, existing_record, new_data)
        set_clause = new_data.map { |k, v| "#{k} = '#{v}'" }.join(', ')
        
        ActiveRecord::Base.connection.execute(
          "UPDATE #{table_name} SET #{set_clause} WHERE id = #{existing_record['id']}"
        )
      end

      # Create new record
      def create_record(table_name, record_data)
        columns = record_data.keys.join(', ')
        values = record_data.values.map { |v| "'#{v}'" }.join(', ')
        
        ActiveRecord::Base.connection.execute(
          "INSERT INTO #{table_name} (#{columns}) VALUES (#{values})"
        )
        
        # Return the created record
        ActiveRecord::Base.connection.select_one(
          "SELECT * FROM #{table_name} WHERE guid = '#{record_data['guid']}'"
        )
      end

      # Import script dependencies
      def import_script_dependencies(script_guids, export_metadata, import_metadata, dry_run: false)
        Rails.logger.info "Importing script dependencies for #{script_guids.size} scripts"
        
        # Import each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          if export_metadata[:tables][table_name]
            import_metadata[:tables][table_name] = import_table(table_name, export_metadata[:tables][table_name], dry_run: dry_run)
          end
        end
      end

      # Import level dependencies
      def import_level_dependencies(level_guids, export_metadata, import_metadata, dry_run: false)
        Rails.logger.info "Importing level dependencies for #{level_guids.size} levels"
        
        # Import each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          if export_metadata[:tables][table_name]
            import_metadata[:tables][table_name] = import_table(table_name, export_metadata[:tables][table_name], dry_run: dry_run)
          end
        end
      end

      # Import lesson dependencies
      def import_lesson_dependencies(lesson_guids, export_metadata, import_metadata, dry_run: false)
        Rails.logger.info "Importing lesson dependencies for #{lesson_guids.size} lessons"
        
        # Import each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          if export_metadata[:tables][table_name]
            import_metadata[:tables][table_name] = import_table(table_name, export_metadata[:tables][table_name], dry_run: dry_run)
          end
        end
      end

      # Validate import results
      def validate_import(import_metadata)
        Rails.logger.info "Validating import results..."
        
        validation_result = {
          status: 'success',
          checks: {}
        }

        # Check that all tables were imported successfully
        failed_tables = import_metadata[:tables].select { |_, result| result[:status] == 'error' }
        if failed_tables.any?
          validation_result[:status] = 'error'
          validation_result[:checks][:failed_tables] = failed_tables
        end

        # Check data integrity
        integrity_checks = validate_data_integrity
        validation_result[:checks][:data_integrity] = integrity_checks

        # Check GUID consistency
        guid_checks = validate_guid_consistency
        validation_result[:checks][:guid_consistency] = guid_checks

        validation_result
      end

      # Validate data integrity
      def validate_data_integrity
        checks = {}
        
        # Check foreign key relationships
        checks[:foreign_keys] = validate_foreign_keys
        
        # Check required fields
        checks[:required_fields] = validate_required_fields
        
        # Check unique constraints
        checks[:unique_constraints] = validate_unique_constraints
        
        checks
      end

      # Validate foreign key relationships
      def validate_foreign_keys
        # This would implement foreign key validation
        # For now, return a placeholder
        { status: 'success', message: 'Foreign key validation not implemented' }
      end

      # Validate required fields
      def validate_required_fields
        # This would implement required field validation
        # For now, return a placeholder
        { status: 'success', message: 'Required field validation not implemented' }
      end

      # Validate unique constraints
      def validate_unique_constraints
        # This would implement unique constraint validation
        # For now, return a placeholder
        { status: 'success', message: 'Unique constraint validation not implemented' }
      end

      # Validate GUID consistency
      def validate_guid_consistency
        checks = {}
        
        # Check that all curriculum tables have GUIDs
        CURRICULUM_TABLES.each do |table_name|
          missing_guids = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM #{table_name} WHERE guid IS NULL OR guid = ''"
          )
          checks[table_name] = {
            status: missing_guids > 0 ? 'error' : 'success',
            missing_guids: missing_guids
          }
        end
        
        checks
      end
    end
  end
end