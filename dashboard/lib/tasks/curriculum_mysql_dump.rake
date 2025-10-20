# frozen_string_literal: true

# Curriculum MySQL Dump Task
# This task creates a MySQL dump of all curriculum tables excluding ID columns
# Run with: bundle exec rake curriculum:mysql_dump

namespace :curriculum do
  desc "Create MySQL dump of curriculum tables (excluding ID columns)"
  task mysql_dump: :environment do
    puts "🗄️  Creating Curriculum MySQL Dump"
    puts "=" * 60
    puts ""
    
    dumper = CurriculumMysqlDumper.new
    dumper.create_dump
    
    puts ""
    puts "✅ MySQL dump created successfully!"
    puts "📁 Dump file: #{dumper.dump_file}"
  end
end

class CurriculumMysqlDumper
  def initialize
    @dump_dir = Rails.root.join('experimental', 'curriculum_guid_migration', 'phase2_test_dual_system', 'mysql_dumps')
    @timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    @dump_file = @dump_dir.join("curriculum_guid_dump_#{@timestamp}.sql")
    
    # Create dump directory
    FileUtils.mkdir_p(@dump_dir)
    
    # Define curriculum tables
    @curriculum_tables = [
      'scripts', 'lessons', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
      'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
      'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels',
      'course_scripts', 'unit_groups_resources', 'unit_groups_student_resources',
      'script_resources', 'script_student_resources', 'lesson_resources', 'lesson_standards',
      'lesson_vocabularies', 'lesson_programming_expressions', 'learning_goal_evidence_levels',
      'lesson_opportunity_standards'
    ]
    
    @stats = {
      tables_processed: 0,
      total_records: 0,
      dump_size: 0,
      errors: 0
    }
  end
  
  attr_reader :dump_file, :stats
  
  def create_dump
    puts "📊 Processing #{@curriculum_tables.length} curriculum tables..."
    puts ""
    
    # Open dump file for writing
    File.open(@dump_file, 'w') do |file|
      write_dump_header(file)
      
      @curriculum_tables.each do |table|
        process_table(file, table)
      end
      
      write_dump_footer(file)
    end
    
    # Get final file size
    @stats[:dump_size] = File.size(@dump_file)
    
    print_dump_summary
  end
  
  private
  
  def write_dump_header(file)
    file.puts "-- Curriculum GUID Dump"
    file.puts "-- Generated: #{Time.current.iso8601}"
    file.puts "-- Database: #{Rails.configuration.database_configuration[Rails.env]['database']}"
    file.puts "-- Tables: #{@curriculum_tables.length}"
    file.puts "-- Purpose: Phase 2 GUID migration - curriculum data without ID columns"
    file.puts ""
    file.puts "SET NAMES utf8mb4;"
    file.puts "SET FOREIGN_KEY_CHECKS = 0;"
    file.puts ""
  end
  
  def write_dump_footer(file)
    file.puts ""
    file.puts "SET FOREIGN_KEY_CHECKS = 1;"
    file.puts ""
    file.puts "-- Dump completed: #{Time.current.iso8601}"
    file.puts "-- Total tables processed: #{@stats[:tables_processed]}"
    file.puts "-- Total records: #{@stats[:total_records]}"
  end
  
  def process_table(file, table_name)
    puts "📝 Processing table: #{table_name}"
    
    begin
      # Check if table exists
      unless table_exists?(table_name)
        puts "  ⚠️  Table #{table_name} does not exist, skipping"
        return
      end
      
      # Get table structure (excluding ID columns)
      structure_sql = get_table_structure(table_name)
      if structure_sql
        file.puts "-- Table structure for #{table_name}"
        file.puts structure_sql
        file.puts ""
      end
      
      # Get table data (excluding ID columns)
      data_sql = get_table_data(table_name)
      if data_sql
        file.puts "-- Data for #{table_name}"
        file.puts data_sql
        file.puts ""
      end
      
      @stats[:tables_processed] += 1
      puts "  ✅ Processed #{table_name}"
      
    rescue => e
      puts "  ❌ Error processing #{table_name}: #{e.message}"
      @stats[:errors] += 1
    end
  end
  
  def table_exists?(table_name)
    ActiveRecord::Base.connection.table_exists?(table_name)
  end
  
  def get_table_structure(table_name)
    # Get table structure without ID columns
    columns = ActiveRecord::Base.connection.columns(table_name)
    
    # Filter out ID columns
    non_id_columns = columns.reject { |col| col.name == 'id' }
    
    return nil if non_id_columns.empty?
    
    # Build CREATE TABLE statement
    create_sql = "CREATE TABLE `#{table_name}` (\n"
    
    column_definitions = non_id_columns.map do |col|
      definition = "  `#{col.name}` #{col.sql_type}"
      definition += " NOT NULL" if col.null == false
      definition += " DEFAULT #{col.default}" if col.default
      definition += " AUTO_INCREMENT" if col.auto_increment?
      definition
    end
    
    create_sql += column_definitions.join(",\n")
    create_sql += "\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    
    create_sql
  end
  
  def get_table_data(table_name)
    # Get table data without ID columns
    columns = ActiveRecord::Base.connection.columns(table_name)
    non_id_columns = columns.reject { |col| col.name == 'id' }
    
    return nil if non_id_columns.empty?
    
    # Get column names for INSERT statement
    column_names = non_id_columns.map(&:name)
    
    # Get all records
    records = ActiveRecord::Base.connection.select_all("SELECT #{column_names.join(', ')} FROM #{table_name}")
    
    return nil if records.empty?
    
    # Build INSERT statements
    insert_sql = "INSERT INTO `#{table_name}` (`#{column_names.join('`, `')}`) VALUES\n"
    
    values = records.map do |record|
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
    
    insert_sql += values.join(",\n")
    insert_sql += ";"
    
    # Update record count
    @stats[:total_records] += records.length
    
    insert_sql
  end
  
  def print_dump_summary
    puts ""
    puts "📊 DUMP SUMMARY"
    puts "=" * 60
    puts "Dump file: #{@dump_file}"
    puts "File size: #{format_bytes(@stats[:dump_size])}"
    puts "Tables processed: #{@stats[:tables_processed]}"
    puts "Total records: #{@stats[:total_records]}"
    puts "Errors: #{@stats[:errors]}"
    puts ""
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