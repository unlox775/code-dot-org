#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 1 Step 1: Verify Curriculum Table Identification
# This script verifies that we correctly identified all curriculum-related tables

require 'active_record'
require 'json'
require 'csv'

# Load Rails environment
require_relative '../../../dashboard/config/environment'

class CurriculumTableVerifier
  def initialize
    @results = {
      timestamp: Time.current,
      phase: 'Phase 1',
      step: 'Step 1: Verify Curriculum Table Identification',
      status: 'running'
    }
    @curriculum_tables = []
    @all_tables = []
  end

  def run
    puts "🔍 Phase 1 Step 1: Verifying Curriculum Table Identification"
    puts "=" * 60

    # Step 1: Get all tables from database
    get_all_tables

    # Step 2: Identify curriculum tables using multiple methods
    identify_curriculum_tables

    # Step 3: Verify our identification against multiple sources
    verify_identification

    # Step 4: Generate report
    generate_report

    puts "\n✅ Phase 1 Step 1 Complete!"
    puts "📊 Results saved to: phase1_step1_results.json"
  end

  private

  def get_all_tables
    puts "\n📋 Step 1: Getting all database tables..."
    
    @all_tables = ActiveRecord::Base.connection.tables.sort
    puts "   Found #{@all_tables.length} total tables"
    
    @results[:total_tables] = @all_tables.length
    @results[:all_tables] = @all_tables
  end

  def identify_curriculum_tables
    puts "\n🎯 Step 2: Identifying curriculum tables using multiple methods..."
    
    # Method 1: Schema analysis (our original method)
    schema_tables = identify_by_schema_analysis
    puts "   Schema analysis: #{schema_tables.length} tables"
    
    # Method 2: Model analysis
    model_tables = identify_by_model_analysis
    puts "   Model analysis: #{model_tables.length} tables"
    
    # Method 3: Foreign key analysis
    fk_tables = identify_by_foreign_key_analysis
    puts "   Foreign key analysis: #{fk_tables.length} tables"
    
    # Method 4: Seeding analysis
    seeding_tables = identify_by_seeding_analysis
    puts "   Seeding analysis: #{seeding_tables.length} tables"
    
    # Combine all methods
    @curriculum_tables = (schema_tables + model_tables + fk_tables + seeding_tables).uniq.sort
    puts "   Combined: #{@curriculum_tables.length} unique curriculum tables"
    
    @results[:identification_methods] = {
      schema_analysis: schema_tables,
      model_analysis: model_tables,
      foreign_key_analysis: fk_tables,
      seeding_analysis: seeding_tables,
      combined: @curriculum_tables
    }
  end

  def identify_by_schema_analysis
    # Our original method: look for curriculum-related table names
    curriculum_keywords = %w[
      script level lesson course stage unit group offering activity
      user_level user_script user_lesson user_course user_stage
      script_level lesson_activity course_script stage_script
      unit_group course_offering activity_script
    ]
    
    @all_tables.select do |table|
      curriculum_keywords.any? { |keyword| table.include?(keyword) }
    end
  end

  def identify_by_model_analysis
    # Look for ActiveRecord models that reference curriculum
    curriculum_models = []
    
    # Get all model files
    model_files = Dir.glob('../../../dashboard/app/models/**/*.rb')
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Look for curriculum-related associations
      if content.match?(/(belongs_to|has_many|has_one).*script|level|lesson|course|stage|unit/i)
        model_name = File.basename(file, '.rb').classify
        table_name = model_name.underscore.pluralize
        
        if @all_tables.include?(table_name)
          curriculum_models << table_name
        end
      end
    end
    
    curriculum_models.uniq
  end

  def identify_by_foreign_key_analysis
    # Look for tables with foreign keys to curriculum tables
    curriculum_tables = []
    
    @all_tables.each do |table|
      begin
        columns = ActiveRecord::Base.connection.columns(table)
        
        # Look for foreign key columns
        fk_columns = columns.select do |col|
          col.name.end_with?('_id') && 
          (col.name.include?('script') || 
           col.name.include?('level') || 
           col.name.include?('lesson') || 
           col.name.include?('course') || 
           col.name.include?('stage') || 
           col.name.include?('unit'))
        end
        
        if fk_columns.any?
          curriculum_tables << table
        end
      rescue => e
        puts "   Warning: Could not analyze table #{table}: #{e.message}"
      end
    end
    
    curriculum_tables
  end

  def identify_by_seeding_analysis
    # Look for tables referenced in seeding files
    seeding_tables = []
    
    # Check seeding files
    seeding_files = Dir.glob('../../../dashboard/db/fixtures/**/*.rb') +
                   Dir.glob('../../../dashboard/lib/tasks/**/*seed*.rb')
    
    seeding_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      
      # Look for table references
      table_matches = content.scan(/(\w+)\s*\.(create|find|where|update|delete)/)
      table_matches.each do |match|
        table_name = match[0].underscore.pluralize
        if @all_tables.include?(table_name)
          seeding_tables << table_name
        end
      end
    end
    
    seeding_tables.uniq
  end

  def verify_identification
    puts "\n🔍 Step 3: Verifying identification against multiple sources..."
    
    # Verify against schema.rb
    schema_tables = verify_against_schema_rb
    puts "   Schema.rb verification: #{schema_tables.length} tables"
    
    # Verify against migration files
    migration_tables = verify_against_migrations
    puts "   Migration verification: #{migration_tables.length} tables"
    
    # Verify against model files
    model_tables = verify_against_models
    puts "   Model verification: #{model_tables.length} tables"
    
    @results[:verification] = {
      schema_rb: schema_tables,
      migrations: migration_tables,
      models: model_tables,
      accuracy: calculate_accuracy
    }
  end

  def verify_against_schema_rb
    schema_file = '../../../dashboard/db/schema.rb'
    return [] unless File.exist?(schema_file)
    
    content = File.read(schema_file)
    tables = []
    
    # Look for create_table statements
    content.scan(/create_table\s+["'](\w+)["']/) do |match|
      table_name = match[0]
      if @all_tables.include?(table_name)
        tables << table_name
      end
    end
    
    tables
  end

  def verify_against_migrations
    migration_files = Dir.glob('../../../dashboard/db/migrate/*.rb')
    tables = []
    
    migration_files.each do |file|
      content = File.read(file)
      
      # Look for table references
      content.scan(/(\w+)\s*\.(create_table|add_column|remove_column|add_index)/) do |match|
        table_name = match[0]
        if @all_tables.include?(table_name)
          tables << table_name
        end
      end
    end
    
    tables.uniq
  end

  def verify_against_models
    model_files = Dir.glob('../../../dashboard/app/models/**/*.rb')
    tables = []
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Extract model name and convert to table name
      model_name = File.basename(file, '.rb').classify
      table_name = model_name.underscore.pluralize
      
      if @all_tables.include?(table_name)
        tables << table_name
      end
    end
    
    tables.uniq
  end

  def calculate_accuracy
    # Calculate accuracy based on verification sources
    total_verification_tables = (@results[:verification][:schema_rb] + 
                                @results[:verification][:migrations] + 
                                @results[:verification][:models]).uniq.length
    
    if total_verification_tables > 0
      overlap = @curriculum_tables & (@results[:verification][:schema_rb] + 
                                    @results[:verification][:migrations] + 
                                    @results[:verification][:models]).uniq
      (overlap.length.to_f / total_verification_tables * 100).round(2)
    else
      0
    end
  end

  def generate_report
    puts "\n📊 Step 4: Generating verification report..."
    
    @results[:status] = 'completed'
    @results[:curriculum_tables] = @curriculum_tables
    @results[:summary] = {
      total_tables: @all_tables.length,
      curriculum_tables: @curriculum_tables.length,
      accuracy: @results[:verification][:accuracy],
      confidence: calculate_confidence
    }
    
    # Save results
    File.write('phase1_step1_results.json', JSON.pretty_generate(@results))
    
    # Print summary
    puts "\n📈 VERIFICATION SUMMARY"
    puts "=" * 40
    puts "Total tables in database: #{@all_tables.length}"
    puts "Identified curriculum tables: #{@curriculum_tables.length}"
    puts "Verification accuracy: #{@results[:verification][:accuracy]}%"
    puts "Confidence level: #{@results[:summary][:confidence]}"
    
    puts "\n🎯 CURRICULUM TABLES IDENTIFIED:"
    @curriculum_tables.each_with_index do |table, index|
      puts "  #{index + 1}. #{table}"
    end
    
    puts "\n📋 VERIFICATION SOURCES:"
    puts "  Schema.rb: #{@results[:verification][:schema_rb].length} tables"
    puts "  Migrations: #{@results[:verification][:migrations].length} tables"
    puts "  Models: #{@results[:verification][:models].length} tables"
  end

  def calculate_confidence
    accuracy = @results[:verification][:accuracy]
    
    case accuracy
    when 90..100
      'High'
    when 70..89
      'Medium'
    when 50..69
      'Low'
    else
      'Very Low'
    end
  end
end

# Run the verification
if __FILE__ == $0
  verifier = CurriculumTableVerifier.new
  verifier.run
end