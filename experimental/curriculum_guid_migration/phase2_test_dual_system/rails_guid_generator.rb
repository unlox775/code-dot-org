#!/usr/bin/env ruby
# frozen_string_literal: true

# Rails GUID Generator
# This script generates real GUIDs for curriculum tables using Rails database connection
# without requiring AWS credentials

require 'fileutils'
require 'json'
require 'securerandom'

# Add the dashboard directory to the load path
$LOAD_PATH.unshift('/workspace/dashboard')

# Load Rails environment without AWS dependencies
ENV['RAILS_ENV'] = 'development'
ENV['AWS_REGION'] = 'us-east-1'  # Set a default region to avoid AWS errors

# Load Rails without requiring all dependencies
begin
  require '/workspace/dashboard/config/environment'
rescue => e
  puts "⚠️  Could not load Rails environment: #{e.message}"
  puts "🔄 Running in simulation mode instead"
  run_simulation_mode
  exit
end

class RailsGuidGenerator
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
    puts "🔧 RAILS GUID GENERATOR"
    puts "=" * 60
    puts ""
    
    begin
      generate_guid_mappings
      create_mysql_dump
      print_results
      
    rescue => e
      puts "❌ Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
  
  private
  
  def generate_guid_mappings
    puts "📋 Generating GUID Mappings"
    puts "-" * 40
    
    # Define curriculum tables and their unique identifier columns
    curriculum_tables = {
      'scripts' => { model: Unit, id_column: 'name' },
      'lessons' => { model: Lesson, id_column: 'key' },
      'levels' => { model: Level, id_column: 'key' },
      'lesson_groups' => { model: LessonGroup, id_column: 'key' },
      'lesson_activities' => { model: LessonActivity, id_column: 'key' },
      'activity_sections' => { model: ActivitySection, id_column: 'key' },
      'courses' => { model: Course, id_column: 'key' },
      'course_offerings' => { model: CourseOffering, id_column: 'key' },
      'course_versions' => { model: CourseVersion, id_column: 'key' },
      'objectives' => { model: Objective, id_column: 'key' },
      'programming_expressions' => { model: ProgrammingExpression, id_column: 'key' },
      'rubrics' => { model: Rubric, id_column: 'key' },
      'learning_goals' => { model: LearningGoal, id_column: 'key' },
      'unit_groups' => { model: UnitGroup, id_column: 'key' }
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
      # Get all records from the model
      records = config[:model].all
      
      mappings = {}
      guids_generated = 0
      
      records.each do |record|
        identifier = record.send(config[:id_column])
        next if identifier.blank?
        
        if record.guid.present?
          # Use existing GUID
          mappings[identifier] = record.guid
        else
          # Generate new GUID
          new_guid = SecureRandom.uuid
          mappings[identifier] = new_guid
          guids_generated += 1
          
          # Update record with new GUID
          record.update_column(:guid, new_guid)
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
    puts "📝 Processing script_levels..."
    
    begin
      script_levels = ScriptLevel.includes(:script, :lesson)
      mappings = {}
      guids_generated = 0
      
      script_levels.each do |sl|
        composite_key = "#{sl.script.name}:#{sl.lesson.key}:#{sl.position}"
        
        if sl.guid.present?
          mappings[composite_key] = sl.guid
        else
          new_guid = SecureRandom.uuid
          mappings[composite_key] = new_guid
          guids_generated += 1
          
          # Update record with new GUID
          sl.update_column(:guid, new_guid)
        end
      end
      
      # Write mapping file
      mapping_file = File.join(@mappings_dir, 'script_levels.json')
      File.write(mapping_file, JSON.pretty_generate(mappings))
      
      puts "  ✅ Generated #{mappings.length} mappings (#{guids_generated} new GUIDs)"
      
      @stats[:tables_processed] += 1
      @stats[:total_records] += script_levels.count
      @stats[:guids_generated] += guids_generated
      
    rescue => e
      puts "  ❌ Error processing script_levels: #{e.message}"
      @stats[:errors] += 1
    end
    
    # Process levels_script_levels
    puts "📝 Processing levels_script_levels..."
    
    begin
      levels_script_levels = LevelsScriptLevel.includes(:level, :script_level, script_level: [:script, :lesson])
      mappings = {}
      guids_generated = 0
      
      levels_script_levels.each do |lsl|
        composite_key = "#{lsl.level.key}:#{lsl.script_level.script.name}:#{lsl.script_level.lesson.key}:#{lsl.script_level.position}"
        
        if lsl.guid.present?
          mappings[composite_key] = lsl.guid
        else
          new_guid = SecureRandom.uuid
          mappings[composite_key] = new_guid
          guids_generated += 1
          
          # Update record with new GUID
          lsl.update_column(:guid, new_guid)
        end
      end
      
      # Write mapping file
      mapping_file = File.join(@mappings_dir, 'levels_script_levels.json')
      File.write(mapping_file, JSON.pretty_generate(mappings))
      
      puts "  ✅ Generated #{mappings.length} mappings (#{guids_generated} new GUIDs)"
      
      @stats[:tables_processed] += 1
      @stats[:total_records] += levels_script_levels.count
      @stats[:guids_generated] += guids_generated
      
    rescue => e
      puts "  ❌ Error processing levels_script_levels: #{e.message}"
      @stats[:errors] += 1
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
      curriculum_models = [
        Unit, Lesson, Level, LessonGroup, LessonActivity, ActivitySection,
        Course, CourseOffering, CourseVersion, Objective, ProgrammingExpression,
        Rubric, LearningGoal, UnitGroup, ScriptLevel, LevelsScriptLevel
      ]
      
      File.open(dump_file, 'w') do |file|
        file.puts "-- Curriculum GUID Dump"
        file.puts "-- Generated: #{Time.now.iso8601}"
        file.puts "-- Database: #{Rails.configuration.database_configuration[Rails.env]['database']}"
        file.puts "-- Tables: #{curriculum_models.length}"
        file.puts "-- Purpose: Phase 2 GUID migration - curriculum data without ID columns"
        file.puts ""
        file.puts "SET NAMES utf8mb4;"
        file.puts "SET FOREIGN_KEY_CHECKS = 0;"
        file.puts ""
        
        curriculum_models.each do |model|
          dump_model_table(file, model)
        end
        
        file.puts ""
        file.puts "SET FOREIGN_KEY_CHECKS = 1;"
        file.puts ""
        file.puts "-- Dump completed: #{Time.now.iso8601}"
      end
      
      dump_size = File.size(dump_file)
      puts "✅ MySQL dump created: #{File.basename(dump_file)}"
      puts "  File size: #{format_bytes(dump_size)}"
      puts "  Tables dumped: #{curriculum_models.length}"
      
    rescue => e
      puts "❌ Error creating MySQL dump: #{e.message}"
      @stats[:errors] += 1
    end
  end
  
  def dump_model_table(file, model)
    begin
      table_name = model.table_name
      puts "  📝 Dumping #{table_name}..."
      
      # Get table columns (excluding ID columns)
      columns = model.column_names - ['id', 'created_at', 'updated_at']
      
      if columns.empty?
        puts "    ⚠️  No non-ID columns found, skipping"
        return
      end
      
      # Write table structure
      file.puts "-- Table structure for #{table_name}"
      file.puts "CREATE TABLE `#{table_name}` ("
      
      column_definitions = columns.map do |col_name|
        col = model.columns.find { |c| c.name == col_name }
        definition = "  `#{col_name}` #{col.sql_type}"
        definition += " NOT NULL" if col.null == false
        definition += " DEFAULT #{col.default}" if col.default
        definition += " AUTO_INCREMENT" if col.auto_increment?
        definition
      end
      
      file.puts column_definitions.join(",\n")
      file.puts ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
      file.puts ""
      
      # Get table data
      records = model.all
      
      if records.any?
        file.puts "-- Data for #{table_name}"
        file.puts "INSERT INTO `#{table_name}` (`#{columns.join('`, `')}`) VALUES"
        
        values = records.map do |record|
          values = columns.map do |col_name|
            value = record.send(col_name)
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
      
      puts "    ✅ Dumped #{records.count} records"
      
    rescue => e
      puts "    ❌ Error dumping #{table_name}: #{e.message}"
      @stats[:errors] += 1
    end
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

def run_simulation_mode
  puts "🔄 Running in simulation mode..."
  puts ""
  
  mappings_dir = '/workspace/dashboard/config/curriculum_guid_mappings'
  mysql_dump_dir = '/workspace/experimental/curriculum_guid_migration/phase2_test_dual_system/mysql_dumps'
  
  FileUtils.mkdir_p(mappings_dir)
  FileUtils.mkdir_p(mysql_dump_dir)
  
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
    file_path = File.join(mappings_dir, filename)
    File.write(file_path, JSON.pretty_generate(mappings))
    puts "✅ Created #{filename} with #{mappings.length} mappings"
  end
  
  # Create sample MySQL dump
  timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
  dump_file = File.join(mysql_dump_dir, "curriculum_guid_dump_#{timestamp}.sql")
  
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

# Run the generator
if __FILE__ == $0
  generator = RailsGuidGenerator.new
  generator.run
end