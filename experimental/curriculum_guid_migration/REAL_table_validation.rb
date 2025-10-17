#!/usr/bin/env ruby
# frozen_string_literal: true

# REAL Table Validation - Based on Actual Code Analysis
# This script validates our curriculum table assumptions by looking at ACTUAL code

require 'active_record'
require 'json'

# Load Rails environment
require_relative '../dashboard/config/environment'

class RealTableValidator
  def initialize
    @results = {
      timestamp: Time.current,
      validation_method: 'real_code_analysis',
      findings: {}
    }
  end

  def run
    puts "🔍 REAL Table Validation - Based on Actual Code Analysis"
    puts "=" * 70
    puts "This validates our assumptions by looking at ACTUAL seeding code"
    puts ""

    # Method 1: Analyze ScriptSeed service (the main seeding code)
    analyze_script_seed_service

    # Method 2: Analyze actual model files
    analyze_model_files

    # Method 3: Analyze database schema
    analyze_database_schema

    # Method 4: Cross-reference with our assumptions
    cross_reference_assumptions

    # Generate honest report
    generate_honest_report

    puts "\n✅ REAL validation complete!"
    puts "📊 Results saved to: real_table_validation.json"
  end

  private

  def analyze_script_seed_service
    puts "📋 Method 1: Analyzing ScriptSeed Service (Main Seeding Code)"
    puts "-" * 50
    
    # Read the actual ScriptSeed service
    script_seed_file = '../dashboard/lib/services/script_seed.rb'
    content = File.read(script_seed_file)
    
    # Extract table names from actual database operations
    tables_from_seeding = []
    
    # Look for model names in database operations
    content.scan(/(\w+)\.(import!|where|find|create|update|delete)/) do |match|
      model_name = match[0]
      # Convert model name to table name
      table_name = model_name.underscore.pluralize
      tables_from_seeding << table_name
    end
    
    # Also look for explicit table references
    content.scan(/where\('(\w+)\./).each do |match|
      tables_from_seeding << match[0]
    end
    
    tables_from_seeding.uniq!
    
    puts "   Tables found in ScriptSeed service: #{tables_from_seeding.length}"
    puts "   Tables: #{tables_from_seeding.join(', ')}"
    
    @results[:findings][:script_seed_tables] = tables_from_seeding
  end

  def analyze_model_files
    puts "\n🏗️  Method 2: Analyzing Actual Model Files"
    puts "-" * 50
    
    # Get all model files
    model_files = Dir.glob('../dashboard/app/models/**/*.rb')
    curriculum_models = []
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Look for curriculum-related associations
      if content.match?(/(belongs_to|has_many|has_one).*script|level|lesson|course|stage|unit/i)
        model_name = File.basename(file, '.rb').classify
        table_name = model_name.underscore.pluralize
        curriculum_models << table_name
      end
    end
    
    curriculum_models.uniq!
    
    puts "   Curriculum-related models found: #{curriculum_models.length}"
    puts "   Models: #{curriculum_models.join(', ')}"
    
    @results[:findings][:curriculum_models] = curriculum_models
  end

  def analyze_database_schema
    puts "\n🗄️  Method 3: Analyzing Database Schema"
    puts "-" * 50
    
    # Get all tables from database
    all_tables = ActiveRecord::Base.connection.tables.sort
    
    # Look for tables with curriculum-related foreign keys
    curriculum_fk_tables = []
    
    all_tables.each do |table|
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
          curriculum_fk_tables << table
        end
      rescue => e
        puts "   Warning: Could not analyze table #{table}: #{e.message}"
      end
    end
    
    puts "   Tables with curriculum foreign keys: #{curriculum_fk_tables.length}"
    puts "   Tables: #{curriculum_fk_tables.join(', ')}"
    
    @results[:findings][:curriculum_fk_tables] = curriculum_fk_tables
  end

  def cross_reference_assumptions
    puts "\n🔍 Method 4: Cross-Referencing with Our Assumptions"
    puts "-" * 50
    
    # Our original assumptions
    our_assumptions = [
      'scripts', 'levels', 'stages', 'lesson_groups', 'courses', 'unit_groups',
      'course_offerings', 'activities', 'script_levels', 'lesson_activities',
      'course_scripts', 'stage_scripts', 'unit_group_courses', 'activity_scripts',
      'user_levels', 'user_scripts', 'user_lessons', 'user_courses', 'user_stages',
      'user_units', 'user_activities', 'user_script_levels', 'user_lesson_activities',
      'user_course_scripts', 'user_stage_scripts', 'user_unit_groups',
      'user_course_offerings', 'user_activity_scripts', 'user_script_activities',
      'user_lesson_script_levels', 'user_course_script_levels'
    ]
    
    # Get all tables from our analysis
    all_found_tables = (
      @results[:findings][:script_seed_tables] +
      @results[:findings][:curriculum_models] +
      @results[:findings][:curriculum_fk_tables]
    ).uniq
    
    # Compare
    confirmed_tables = our_assumptions & all_found_tables
    missing_tables = our_assumptions - all_found_tables
    extra_tables = all_found_tables - our_assumptions
    
    puts "   Our assumptions: #{our_assumptions.length} tables"
    puts "   Confirmed by analysis: #{confirmed_tables.length} tables"
    puts "   Missing from analysis: #{missing_tables.length} tables"
    puts "   Extra tables found: #{extra_tables.length} tables"
    
    if confirmed_tables.any?
      puts "\n   ✅ CONFIRMED TABLES:"
      confirmed_tables.each { |table| puts "     - #{table}" }
    end
    
    if missing_tables.any?
      puts "\n   ❌ MISSING TABLES (in our assumptions but not found in code):"
      missing_tables.each { |table| puts "     - #{table}" }
    end
    
    if extra_tables.any?
      puts "\n   ⚠️  EXTRA TABLES (found in code but not in our assumptions):"
      extra_tables.each { |table| puts "     - #{table}" }
    end
    
    @results[:findings][:comparison] = {
      our_assumptions: our_assumptions,
      confirmed_tables: confirmed_tables,
      missing_tables: missing_tables,
      extra_tables: extra_tables,
      confidence_score: (confirmed_tables.length.to_f / our_assumptions.length * 100).round(2)
    }
  end

  def generate_honest_report
    puts "\n📊 Generating HONEST Report"
    puts "-" * 50
    
    comparison = @results[:findings][:comparison]
    
    puts "\n🎯 HONEST ASSESSMENT:"
    puts "   Confidence in our assumptions: #{comparison[:confidence_score]}%"
    
    if comparison[:confidence_score] >= 80
      puts "   ✅ HIGH CONFIDENCE: Our assumptions are mostly correct"
    elsif comparison[:confidence_score] >= 60
      puts "   ⚠️  MEDIUM CONFIDENCE: Some assumptions may be wrong"
    else
      puts "   ❌ LOW CONFIDENCE: Many assumptions are likely wrong"
    end
    
    puts "\n💡 RECOMMENDATIONS:"
    
    if comparison[:missing_tables].any?
      puts "   • Review missing tables: #{comparison[:missing_tables].join(', ')}"
      puts "     These may not actually be curriculum tables"
    end
    
    if comparison[:extra_tables].any?
      puts "   • Consider adding extra tables: #{comparison[:extra_tables].join(', ')}"
      puts "     These appear to be curriculum-related based on actual code"
    end
    
    if comparison[:confidence_score] < 80
      puts "   • Our original assumptions need significant revision"
      puts "   • Focus on tables confirmed by actual code analysis"
    end
    
    # Save results
    File.write('real_table_validation.json', JSON.pretty_generate(@results))
    
    puts "\n📈 FINAL SUMMARY:"
    puts "   Total tables in our assumptions: #{comparison[:our_assumptions].length}"
    puts "   Tables confirmed by code: #{comparison[:confirmed_tables].length}"
    puts "   Tables missing from code: #{comparison[:missing_tables].length}"
    puts "   Extra tables found in code: #{comparison[:extra_tables].length}"
    puts "   Overall confidence: #{comparison[:confidence_score]}%"
  end
end

# Run the real validation
if __FILE__ == $0
  validator = RealTableValidator.new
  validator.run
end