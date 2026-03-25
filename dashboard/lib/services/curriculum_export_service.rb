# Service: CurriculumExportService
# Exports curriculum data from production to S3 for synchronization
# Replaces the current seeding process with GUID-based data export

module Services
  class CurriculumExportService
    include Curriculum::SharedCourseConstants

    # S3 configuration
    S3_BUCKET = ENV['CURRICULUM_MASTER_BUCKET'] || 'code-dot-org-curriculum-master'
    S3_PREFIX = 'curriculum-data'
    
    # Export configuration
    EXPORT_BATCH_SIZE = 1000
    COMPRESSION_ENABLED = true
    
    # Curriculum tables to export (in dependency order)
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

    # User progress tables to export (for data integrity)
    USER_PROGRESS_TABLES = [
      'user_levels',
      'user_scripts'
    ].freeze

    class << self
      # Export all curriculum data to S3
      def export_all
        Rails.logger.info "Starting curriculum export to S3..."
        
        export_metadata = {
          exported_at: Time.current.iso8601,
          environment: Rails.env,
          version: Rails.application.config.version,
          tables: {}
        }

        # Export curriculum tables
        CURRICULUM_TABLES.each do |table_name|
          export_metadata[:tables][table_name] = export_table(table_name)
        end

        # Export user progress tables (for data integrity validation)
        USER_PROGRESS_TABLES.each do |table_name|
          export_metadata[:tables][table_name] = export_table(table_name)
        end

        # Save metadata
        save_metadata(export_metadata)

        Rails.logger.info "Curriculum export completed successfully"
        export_metadata
      end

      # Export a specific table
      def export_table(table_name)
        Rails.logger.info "Exporting table: #{table_name}"
        
        start_time = Time.current
        record_count = 0
        
        # Get table data in batches
        table_data = []
        ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}").each_slice(EXPORT_BATCH_SIZE) do |batch|
          table_data.concat(batch)
          record_count += batch.size
        end

        # Compress data if enabled
        if COMPRESSION_ENABLED
          compressed_data = compress_data(table_data)
          file_key = "#{S3_PREFIX}/#{table_name}.json.gz"
        else
          file_key = "#{S3_PREFIX}/#{table_name}.json"
        end

        # Upload to S3
        upload_to_s3(file_key, table_data, compressed: COMPRESSION_ENABLED)

        duration = Time.current - start_time
        Rails.logger.info "Exported #{record_count} records from #{table_name} in #{duration.round(2)}s"

        {
          record_count: record_count,
          file_key: file_key,
          duration: duration,
          compressed: COMPRESSION_ENABLED,
          size_bytes: compressed_data&.bytesize || table_data.to_json.bytesize
        }
      end

      # Export specific curriculum by GUIDs
      def export_by_guids(script_guids: [], level_guids: [], lesson_guids: [])
        Rails.logger.info "Starting selective curriculum export by GUIDs..."
        
        export_metadata = {
          exported_at: Time.current.iso8601,
          environment: Rails.env,
          version: Rails.application.config.version,
          selection: {
            script_guids: script_guids,
            level_guids: level_guids,
            lesson_guids: lesson_guids
          },
          tables: {}
        }

        # Export selected scripts and their dependencies
        if script_guids.any?
          export_script_dependencies(script_guids, export_metadata)
        end

        # Export selected levels and their dependencies
        if level_guids.any?
          export_level_dependencies(level_guids, export_metadata)
        end

        # Export selected lessons and their dependencies
        if lesson_guids.any?
          export_lesson_dependencies(lesson_guids, export_metadata)
        end

        # Save metadata
        save_metadata(export_metadata)

        Rails.logger.info "Selective curriculum export completed successfully"
        export_metadata
      end

      # Get export status
      def export_status
        s3_client = Aws::S3::Client.new
        metadata_key = "#{S3_PREFIX}/metadata.json"
        
        begin
          response = s3_client.get_object(bucket: S3_BUCKET, key: metadata_key)
          JSON.parse(response.body.read)
        rescue Aws::S3::Errors::NoSuchKey
          { status: 'not_found', message: 'No export found' }
        rescue => e
          { status: 'error', message: e.message }
        end
      end

      # List available exports
      def list_exports
        s3_client = Aws::S3::Client.new
        
        begin
          response = s3_client.list_objects_v2(
            bucket: S3_BUCKET,
            prefix: S3_PREFIX
          )
          
          exports = response.contents.map do |object|
            {
              key: object.key,
              last_modified: object.last_modified,
              size: object.size,
              is_metadata: object.key.include?('metadata.json')
            }
          end
          
          { status: 'success', exports: exports }
        rescue => e
          { status: 'error', message: e.message }
        end
      end

      private

      # Export script dependencies
      def export_script_dependencies(script_guids, export_metadata)
        Rails.logger.info "Exporting script dependencies for #{script_guids.size} scripts"
        
        # Get all related GUIDs
        related_guids = find_script_dependencies(script_guids)
        
        # Export each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          filtered_data = filter_table_by_guids(table_name, related_guids)
          next if filtered_data.empty?
          
          export_metadata[:tables][table_name] = export_filtered_table(table_name, filtered_data)
        end
      end

      # Export level dependencies
      def export_level_dependencies(level_guids, export_metadata)
        Rails.logger.info "Exporting level dependencies for #{level_guids.size} levels"
        
        # Get all related GUIDs
        related_guids = find_level_dependencies(level_guids)
        
        # Export each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          filtered_data = filter_table_by_guids(table_name, related_guids)
          next if filtered_data.empty?
          
          export_metadata[:tables][table_name] = export_filtered_table(table_name, filtered_data)
        end
      end

      # Export lesson dependencies
      def export_lesson_dependencies(lesson_guids, export_metadata)
        Rails.logger.info "Exporting lesson dependencies for #{lesson_guids.size} lessons"
        
        # Get all related GUIDs
        related_guids = find_lesson_dependencies(lesson_guids)
        
        # Export each table with filtered data
        CURRICULUM_TABLES.each do |table_name|
          filtered_data = filter_table_by_guids(table_name, related_guids)
          next if filtered_data.empty?
          
          export_metadata[:tables][table_name] = export_filtered_table(table_name, filtered_data)
        end
      end

      # Find all dependencies for a set of script GUIDs
      def find_script_dependencies(script_guids)
        related_guids = { scripts: script_guids }
        
        # Find related lesson groups
        lesson_group_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT guid FROM lesson_groups WHERE script_guid IN (#{script_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:lesson_groups] = lesson_group_guids
        
        # Find related lessons (stages)
        lesson_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT guid FROM stages WHERE script_guid IN (#{script_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:lessons] = lesson_guids
        
        # Find related script levels
        script_level_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT guid FROM script_levels WHERE script_guid IN (#{script_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:script_levels] = script_level_guids
        
        # Find related levels
        level_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT l.guid FROM levels l 
           JOIN levels_script_levels lsl ON l.guid = lsl.level_guid 
           WHERE lsl.script_level_guid IN (#{script_level_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:levels] = level_guids
        
        # Continue finding all related GUIDs...
        find_all_related_guids(related_guids)
      end

      # Find all dependencies for a set of level GUIDs
      def find_level_dependencies(level_guids)
        related_guids = { levels: level_guids }
        
        # Find related script levels
        script_level_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT guid FROM levels_script_levels WHERE level_guid IN (#{level_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:script_levels] = script_level_guids
        
        # Find related scripts
        script_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT s.guid FROM scripts s 
           JOIN script_levels sl ON s.guid = sl.script_guid 
           WHERE sl.guid IN (#{script_level_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:scripts] = script_guids
        
        # Continue finding all related GUIDs...
        find_all_related_guids(related_guids)
      end

      # Find all dependencies for a set of lesson GUIDs
      def find_lesson_dependencies(lesson_guids)
        related_guids = { lessons: lesson_guids }
        
        # Find related scripts
        script_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT s.guid FROM scripts s 
           JOIN stages st ON s.guid = st.script_guid 
           WHERE st.guid IN (#{lesson_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:scripts] = script_guids
        
        # Find related script levels
        script_level_guids = ActiveRecord::Base.connection.select_values(
          "SELECT DISTINCT guid FROM script_levels WHERE lesson_guid IN (#{lesson_guids.map { |g| "'#{g}'" }.join(',')})"
        )
        related_guids[:script_levels] = script_level_guids
        
        # Continue finding all related GUIDs...
        find_all_related_guids(related_guids)
      end

      # Recursively find all related GUIDs
      def find_all_related_guids(related_guids)
        # This would be implemented to find all related GUIDs across all tables
        # For now, return the basic structure
        related_guids
      end

      # Filter table data by related GUIDs
      def filter_table_by_guids(table_name, related_guids)
        return [] unless related_guids.any? { |_, guids| guids.any? }
        
        # Build WHERE clause based on table structure
        where_conditions = []
        
        case table_name
        when 'scripts'
          where_conditions << "guid IN (#{related_guids[:scripts]&.map { |g| "'#{g}'" }&.join(',')})" if related_guids[:scripts]&.any?
        when 'levels'
          where_conditions << "guid IN (#{related_guids[:levels]&.map { |g| "'#{g}'" }&.join(',')})" if related_guids[:levels]&.any?
        when 'stages'
          where_conditions << "guid IN (#{related_guids[:lessons]&.map { |g| "'#{g}'" }&.join(',')})" if related_guids[:lessons]&.any?
        when 'script_levels'
          where_conditions << "guid IN (#{related_guids[:script_levels]&.map { |g| "'#{g}'" }&.join(',')})" if related_guids[:script_levels]&.any?
        # Add more cases as needed
        end
        
        return [] if where_conditions.empty?
        
        where_clause = where_conditions.join(' OR ')
        ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name} WHERE #{where_clause}")
      end

      # Export filtered table data
      def export_filtered_table(table_name, data)
        Rails.logger.info "Exporting filtered table: #{table_name} (#{data.size} records)"
        
        start_time = Time.current
        
        # Compress data if enabled
        if COMPRESSION_ENABLED
          compressed_data = compress_data(data)
          file_key = "#{S3_PREFIX}/#{table_name}_filtered.json.gz"
        else
          file_key = "#{S3_PREFIX}/#{table_name}_filtered.json"
        end

        # Upload to S3
        upload_to_s3(file_key, data, compressed: COMPRESSION_ENABLED)

        duration = Time.current - start_time
        
        {
          record_count: data.size,
          file_key: file_key,
          duration: duration,
          compressed: COMPRESSION_ENABLED,
          size_bytes: compressed_data&.bytesize || data.to_json.bytesize
        }
      end

      # Compress data using gzip
      def compress_data(data)
        json_data = data.to_json
        gz = Zlib::GzipWriter.new(StringIO.new)
        gz.write(json_data)
        gz.close
        gz.string
      end

      # Upload data to S3
      def upload_to_s3(file_key, data, compressed: false)
        s3_client = Aws::S3::Client.new
        
        content = compressed ? data : data.to_json
        content_type = compressed ? 'application/gzip' : 'application/json'
        
        s3_client.put_object(
          bucket: S3_BUCKET,
          key: file_key,
          body: content,
          content_type: content_type,
          metadata: {
            'exported_at' => Time.current.iso8601,
            'environment' => Rails.env,
            'compressed' => compressed.to_s
          }
        )
      end

      # Save export metadata
      def save_metadata(metadata)
        s3_client = Aws::S3::Client.new
        metadata_key = "#{S3_PREFIX}/metadata.json"
        
        s3_client.put_object(
          bucket: S3_BUCKET,
          key: metadata_key,
          body: metadata.to_json,
          content_type: 'application/json'
        )
      end
    end
  end
end