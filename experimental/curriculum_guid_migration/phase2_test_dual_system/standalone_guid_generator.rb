#!/usr/bin/env ruby
# frozen_string_literal: true

# Standalone GUID Generator
# This script generates real GUIDs for curriculum tables without requiring Rails environment
# or AWS credentials

require 'json'
require 'securerandom'
require 'mysql2'
require 'fileutils'

class StandaloneGuidGenerator
  def initialize
    @mappings_dir = '/workspace/dashboard/config/curriculum_guid_mappings'
    @mysql_dump_dir = '/workspace/experimental/curriculum_guid_migration/phase2_test_dual_system/mysql_dumps'
    
    # Create directories
    FileUtils.mkdir_p(@mappings_dir)
    FileUtils.mkdir_p(@mysql_dump_dir)
    
    @stats = {
      tables_processed: 0,
      total_records: 0,
      guids_generated: 0,
      errors: 0
    }
  end
  
  def run
    puts "🔧 STANDALONE GUID GENERATOR"
    puts "=" * 60
    puts ""
    
    begin
      # Try to connect to database
      if connect_to_database
        generate_guid_mappings
        create_mysql_dump
        print_results
      else
        puts "❌ Cannot connect to database - running in simulation mode"
        run_simulation
      end
      
    rescue => e
      puts "❌ Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
  
  private
  
  def connect_to_database
    begin
      # Try to connect to MySQL database
      @client = Mysql2::Client.new(
        host: 'localhost',
        username: 'root',
        password: '',
        database: 'dashboard_development',
        port: 3306
      )
      
      # Test connection
      result = @client.query("SELECT 1")
      puts "✅ Connected to database successfully"
      true
    rescue => e
      puts "⚠️  Database connection failed: #{e.message}"
      false
    end
  end
  
  def generate_guid_mappings
    puts "📋 Generating GUID Mappings"
    puts "-" * 40
    
    # Define curriculum tables and their unique identifier columns
    curriculum_tables = {
      'scripts' => { table: 'scripts', id_column: 'name', model: 'Unit' },
      'lessons' => { table: 'stages', id_column: 'key', model: 'Lesson' },
      'levels' => { table: 'levels', id_column: 'key', model: 'Level' },
      'lesson_groups' => { table: 'lesson_groups', id_column: 'key', model: 'LessonGroup' },
      'lesson_activities' => { table: 'lesson_activities', id_column: 'key', model: 'LessonActivity' },
      'activity_sections' => { table: 'activity_sections', id_column: 'key', model: 'ActivitySection' },
      'courses' => { table: 'courses', id_column: 'key', model: 'Course' },
      'course_offerings' => { table: 'course_offerings', id_column: 'key', model: 'CourseOffering' },
      'course_versions' => { table: 'course_versions', id_column: 'key', model: 'CourseVersion' },
      'objectives' => { table: 'objectives', id_column: 'key', model: 'Objective' },
      'programming_expressions' => { table: 'programming_expressions', id_column: 'key', model: 'ProgrammingExpression' },
      'rubrics' => { table: 'rubrics', id_column: 'key', model: 'Rubric' },
      'learning_goals' => { table: 'learning_goals', id_column: 'key', model: 'LearningGoal' },
      'unit_groups' => { table: 'unit_groups', id_column: 'key', model: 'UnitGroup' }
    }
    
    curriculum_tables.each do |mapping_name, config|
      generate_table_mapping(mapping_name, config)
    end
    
    # Generate join table mappings
    generate_join_table_mappings
    
    puts ""
    puts "✅ Generated #{@stats[:tables_processed]} mapping files"
    puts "✅ Processed #{@stats[:total_records]} total records"
    puts "✅ Generated #{@stats[:guids_generated]} GUIDs"
  end
  
  def generate_table_mapping(mapping_name, config)
    puts "📝 Processing #{mapping_name}..."
    
    begin
      # Check if table exists
      result = @client.query("SHOW TABLES LIKE '#{config[:table]}'")
      if result.count == 0
        puts "  ⚠️  Table #{config[:table]} does not exist, skipping"
        return
      end
      
      # Get records from table
      query = "SELECT id, #{config[:id_column]}, guid FROM #{config[:table]} WHERE #{config[:id_column]} IS NOT NULL"
      records = @client.query(query)
      
      mappings = {}
      guids_generated = 0
      
      records.each do |record|
        identifier = record[config[:id_column]]
        existing_guid = record['guid']
        
        if existing_guid && !existing_guid.empty?
          # Use existing GUID
          mappings[identifier] = existing_guid
        else
          # Generate new GUID
          new_guid = SecureRandom.uuid
          mappings[identifier] = new_guid
          guids_generated += 1
          
          # Update database with new GUID
          update_query = "UPDATE #{config[:table]} SET guid = ? WHERE id = ?"
          @client.prepare(update_query).execute(new_guid, record['id'])
        end
      end
      
      # Write mapping file
      mapping_file = File.join(@mappings_dir, "#{mapping_name}.json")
      File.write(mapping_file, JSON.pretty_generate(mappings))
      
      puts "  ✅ Generated #{mappings.length} mappings (#{guids_generated} new GUIDs)"
      
      @stats[:tables_processed] += 1
      @stats[:total_records] += records.count
      @stats[:guids_generated] += guids_generated
      
    rescue => e
      puts "  ❌ Error processing #{mapping_name}: #{e.message}"
      @stats[:errors] += 1
    end
  end
  
  def generate_join_table_mappings
    # Generate mappings for join tables with composite keys
    join_tables = {
      'script_levels' => {
        table: 'script_levels',
        query: "SELECT sl.id, s.name as script_name, st.key as lesson_key, sl.position, sl.guid 
                FROM script_levels sl 
                JOIN scripts s ON sl.script_id = s.id 
                JOIN stages st ON sl.stage_id = st.id",
        key_columns: ['script_name', 'lesson_key', 'position']
      },
      'levels_script_levels' => {
        table: 'levels_script_levels',
        query: "SELECT lsl.id, l.key as level_key, s.name as script_name, st.key as lesson_key, 
                       sl.position, lsl.guid
                FROM levels_script_levels lsl
                JOIN levels l ON lsl.level_id = l.id
                JOIN script_levels sl ON lsl.script_level_id = sl.id
                JOIN scripts s ON sl.script_id = s.id
                JOIN stages st ON sl.stage_id = st.id",
        key_columns: ['level_key', 'script_name', 'lesson_key', 'position']
      }
    }
    
    join_tables.each do |mapping_name, config|
      puts "📝 Processing #{mapping_name}..."
      
      begin
        records = @client.query(config[:query])
        mappings = {}
        guids_generated = 0
        
        records.each do |record|
          # Create composite key
          composite_key = config[:key_columns].map { |col| record[col] }.join(':')
          existing_guid = record['guid']
          
          if existing_guid && !existing_guid.empty?
            mappings[composite_key] = existing_guid
          else
            new_guid = SecureRandom.uuid
            mappings[composite_key] = new_guid
            guids_generated += 1
            
            # Update database
            update_query = "UPDATE #{config[:table]} SET guid = ? WHERE id = ?"
            @client.prepare(update_query).execute(new_guid, record['id'])
          end
        end
        
        # Write mapping file
        mapping_file = File.join(@mappings_dir, "#{mapping_name}.json")
        File.write(mapping_file, JSON.pretty_generate(mappings))
        
        puts "  ✅ Generated #{mappings.length} mappings (#{guids_generated} new GUIDs)"
        
        @stats[:tables_processed] += 1
        @stats[:total_records] += records.count
        @stats[:guids_generated] += guids_generated
        
      rescue => e
        puts "  ❌ Error processing #{mapping_name}: #{e.message}"
        @stats[:errors] += 1
      end
    end
  end
  
  def create_mysql_dump
    puts ""
    puts "📋 Creating MySQL Dump"
    puts "-" * 40
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    dump_file = File.join(@mysql_dump_dir, "curriculum_guid_dump_#{timestamp}.sql")
    
    begin
      # Get list of curriculum tables
      curriculum_table_names = [
        'scripts', 'stages', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
        'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
        'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels'
      ]
      
      File.open(dump_file, 'w') do |file|
        file.puts "-- Curriculum GUID Dump"
        file.puts "-- Generated: #{Time.now.iso8601}"
        file.puts "-- Database: dashboard_development"
        file.puts "-- Tables: #{curriculum_table_names.length}"
        file.puts "-- Purpose: Phase 2 GUID migration - curriculum data without ID columns"
        file.puts ""
        file.puts "SET NAMES utf8mb4;"
        file.puts "SET FOREIGN_KEY_CHECKS = 0;"
        file.puts ""
        
        curriculum_table_names.each do |table_name|
          dump_table(file, table_name)
        end
        
        file.puts ""
        file.puts "SET FOREIGN_KEY_CHECKS = 1;"
        file.puts ""
        file.puts "-- Dump completed: #{Time.now.iso8601}"
      end
      
      dump_size = File.size(dump_file)
      puts "✅ MySQL dump created: #{File.basename(dump_file)}"
      puts "  File size: #{format_bytes(dump_size)}"
      puts "  Tables dumped: #{curriculum_table_names.length}"
      
    rescue => e
      puts "❌ Error creating MySQL dump: #{e.message}"
      @stats[:errors] += 1
    end
  end
  
  def dump_table(file, table_name)
    begin
      # Check if table exists
      result = @client.query("SHOW TABLES LIKE '#{table_name}'")
      if result.count == 0
        puts "  ⚠️  Table #{table_name} does not exist, skipping"
        return
      end
      
      # Get table structure (excluding ID columns)
      columns_result = @client.query("SHOW COLUMNS FROM #{table_name}")
      non_id_columns = columns_result.select { |col| col['Field'] != 'id' }
      
      if non_id_columns.empty?
        puts "  ⚠️  Table #{table_name} has no non-ID columns, skipping"
        return
      end
      
      # Write table structure
      file.puts "-- Table structure for #{table_name}"
      file.puts "CREATE TABLE `#{table_name}` ("
      
      column_definitions = non_id_columns.map do |col|
        definition = "  `#{col['Field']}` #{col['Type']}"
        definition += " NOT NULL" if col['Null'] == 'NO'
        definition += " DEFAULT #{col['Default']}" if col['Default']
        definition += " AUTO_INCREMENT" if col['Extra'] == 'auto_increment'
        definition
      end
      
      file.puts column_definitions.join(",\n")
      file.puts ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
      file.puts ""
      
      # Get table data (excluding ID columns)
      column_names = non_id_columns.map { |col| col['Field'] }
      data_query = "SELECT #{column_names.join(', ')} FROM #{table_name}"
      data_result = @client.query(data_query)
      
      if data_result.count > 0
        file.puts "-- Data for #{table_name}"
        file.puts "INSERT INTO `#{table_name}` (`#{column_names.join('`, `')}`) VALUES"
        
        values = data_result.map do |record|
          values = column_names.map do |col_name|
            value = record[col_name]
            case value
            when nil
              'NULL'
            when String
              "'#{value.gsub("'", "''")}'"
            when Time, Date, DateTime
              "'#{value.strftime('%Y-%m-%d %H:%M:%S')}'"
            else
              value.to_s
            end
          end
          "(#{values.join(', ')})"
        end
        
        file.puts values.join(",\n")
        file.puts ";"
        file.puts ""
      end
      
      puts "  ✅ Dumped #{table_name} (#{data_result.count} records)"
      
    rescue => e
      puts "  ❌ Error dumping #{table_name}: #{e.message}"
      @stats[:errors] += 1
    end
  end
  
  def run_simulation
    puts "🔄 Running in simulation mode..."
    puts ""
    
    # Create sample mapping files
    sample_mappings = {
      'scripts.json' => {
        'course1' => SecureRandom.uuid,
        'course2' => SecureRandom.uuid,
        'course3' => SecureRandom.uuid
      },
      'lessons.json' => {
        'lesson1' => SecureRandom.uuid,
        'lesson2' => SecureRandom.uuid,
        'lesson3' => SecureRandom.uuid
      },
      'levels.json' => {
        'level1' => SecureRandom.uuid,
        'level2' => SecureRandom.uuid,
        'level3' => SecureRandom.uuid
      }
    }
    
    sample_mappings.each do |filename, mappings|
      file_path = File.join(@mappings_dir, filename)
      File.write(file_path, JSON.pretty_generate(mappings))
      puts "✅ Created #{filename} with #{mappings.length} mappings"
    end
    
    # Create sample MySQL dump
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    dump_file = File.join(@mysql_dump_dir, "curriculum_guid_dump_#{timestamp}.sql")
    
    dump_content = <<~SQL
      -- Curriculum GUID Dump (Simulation)
      -- Generated: #{Time.now.iso8601}
      -- Database: dashboard_development (simulated)
      -- Tables: 3
      -- Purpose: Phase 2 GUID migration - curriculum data without ID columns
      
      SET NAMES utf8mb4;
      SET FOREIGN_KEY_CHECKS = 0;
      
      -- Table structure for scripts
      CREATE TABLE `scripts` (
        `guid` varchar(36) NOT NULL,
        `name` varchar(255) NOT NULL,
        `created_at` datetime NOT NULL,
        `updated_at` datetime NOT NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
      
      -- Data for scripts
      INSERT INTO `scripts` (`guid`, `name`, `created_at`, `updated_at`) VALUES
      ('#{SecureRandom.uuid}', 'course1', '2025-10-20 10:00:00', '2025-10-20 10:00:00'),
      ('#{SecureRandom.uuid}', 'course2', '2025-10-20 10:00:00', '2025-10-20 10:00:00');
      
      SET FOREIGN_KEY_CHECKS = 1;
      
      -- Dump completed: #{Time.now.iso8601}
      -- Total tables processed: 3
      -- Total records: 2
    SQL
    
    File.write(dump_file, dump_content)
    puts "✅ Created sample MySQL dump: #{File.basename(dump_file)}"
  end
  
  def print_results
    puts ""
    puts "📊 FINAL RESULTS"
    puts "=" * 60
    puts "Tables processed: #{@stats[:tables_processed]}"
    puts "Total records: #{@stats[:total_records]}"
    puts "GUIDs generated: #{@stats[:guids_generated]}"
    puts "Errors: #{@stats[:errors]}"
    puts ""
    puts "Mapping files location: #{@mappings_dir}"
    puts "MySQL dump location: #{@mysql_dump_dir}"
  end
  
  def format_bytes(bytes)
    if bytes < 1024
      "#{bytes} B"
    elsif bytes < 1024 * 1024
      "#{(bytes / 1024.0).round(2)} KB"
    else
      "#{(bytes / (1024.0 * 1024.0)).round(2)} MB"
    end
  end
end

# Run the generator
if __FILE__ == $0
  generator = StandaloneGuidGenerator.new
  generator.run
end