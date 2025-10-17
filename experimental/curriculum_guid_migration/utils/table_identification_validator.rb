#!/usr/bin/env ruby
# frozen_string_literal: true

# Table Identification Validator
# This script validates our assumptions about curriculum table identification

require 'active_record'
require 'json'
require 'csv'

# Load Rails environment
require_relative '../../dashboard/config/environment'

class TableIdentificationValidator
  def initialize
    @results = {
      timestamp: Time.current,
      validation_methods: {},
      final_curriculum_tables: [],
      confidence_score: 0
    }
  end

  def run
    puts "🔍 Validating Curriculum Table Identification"
    puts "=" * 60

    # Method 1: Schema analysis
    schema_tables = analyze_schema

    # Method 2: Model analysis
    model_tables = analyze_models

    # Method 3: Foreign key analysis
    fk_tables = analyze_foreign_keys

    # Method 4: Seeding analysis
    seeding_tables = analyze_seeding

    # Method 5: Migration analysis
    migration_tables = analyze_migrations

    # Method 6: Association analysis
    association_tables = analyze_associations

    # Combine results
    combine_results(schema_tables, model_tables, fk_tables, seeding_tables, migration_tables, association_tables)

    # Generate report
    generate_report

    puts "\n✅ Table identification validation complete!"
    puts "📊 Results saved to: table_identification_validation.json"
  end

  private

  def analyze_schema
    puts "\n📋 Method 1: Schema Analysis"
    
    all_tables = ActiveRecord::Base.connection.tables.sort
    curriculum_keywords = %w[
      script level lesson course stage unit group offering activity
      user_level user_script user_lesson user_course user_stage
      script_level lesson_activity course_script stage_script
      unit_group course_offering activity_script
    ]
    
    schema_tables = all_tables.select do |table|
      curriculum_keywords.any? { |keyword| table.include?(keyword) }
    end
    
    puts "   Found #{schema_tables.length} tables with curriculum keywords"
    puts "   Tables: #{schema_tables.join(', ')}"
    
    @results[:validation_methods][:schema_analysis] = {
      method: 'keyword_matching',
      keywords: curriculum_keywords,
      tables_found: schema_tables,
      count: schema_tables.length,
      confidence: 0.7
    }
    
    schema_tables
  end

  def analyze_models
    puts "\n🏗️  Method 2: Model Analysis"
    
    model_files = Dir.glob('../../dashboard/app/models/**/*.rb')
    model_tables = []
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Extract model name
      model_name = File.basename(file, '.rb').classify
      table_name = model_name.underscore.pluralize
      
      # Check if it's a curriculum-related model
      if content.match?(/(belongs_to|has_many|has_one).*script|level|lesson|course|stage|unit/i) ||
         content.include?('curriculum') ||
         content.include?('seeding')
        model_tables << table_name
      end
    end
    
    model_tables.uniq!
    puts "   Found #{model_tables.length} curriculum-related models"
    puts "   Models: #{model_tables.join(', ')}"
    
    @results[:validation_methods][:model_analysis] = {
      method: 'model_file_analysis',
      model_files_analyzed: model_files.length,
      tables_found: model_tables,
      count: model_tables.length,
      confidence: 0.8
    }
    
    model_tables
  end

  def analyze_foreign_keys
    puts "\n🔗 Method 3: Foreign Key Analysis"
    
    all_tables = ActiveRecord::Base.connection.tables.sort
    fk_tables = []
    
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
          fk_tables << table
        end
      rescue => e
        puts "   Warning: Could not analyze table #{table}: #{e.message}"
      end
    end
    
    puts "   Found #{fk_tables.length} tables with curriculum foreign keys"
    puts "   Tables: #{fk_tables.join(', ')}"
    
    @results[:validation_methods][:foreign_key_analysis] = {
      method: 'foreign_key_column_analysis',
      tables_found: fk_tables,
      count: fk_tables.length,
      confidence: 0.9
    }
    
    fk_tables
  end

  def analyze_seeding
    puts "\n🌱 Method 4: Seeding Analysis"
    
    seeding_files = Dir.glob('../../dashboard/db/fixtures/**/*.rb') +
                   Dir.glob('../../dashboard/lib/tasks/**/*seed*.rb') +
                   Dir.glob('../../dashboard/lib/tasks/**/*curriculum*.rb')
    
    seeding_tables = []
    
    seeding_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      
      # Look for table references
      table_matches = content.scan(/(\w+)\s*\.(create|find|where|update|delete|insert)/)
      table_matches.each do |match|
        table_name = match[0].underscore.pluralize
        seeding_tables << table_name
      end
    end
    
    seeding_tables.uniq!
    puts "   Found #{seeding_tables.length} tables referenced in seeding files"
    puts "   Tables: #{seeding_tables.join(', ')}"
    
    @results[:validation_methods][:seeding_analysis] = {
      method: 'seeding_file_analysis',
      seeding_files_analyzed: seeding_files.length,
      tables_found: seeding_tables,
      count: seeding_tables.length,
      confidence: 0.85
    }
    
    seeding_tables
  end

  def analyze_migrations
    puts "\n🔄 Method 5: Migration Analysis"
    
    migration_files = Dir.glob('../../dashboard/db/migrate/*.rb')
    migration_tables = []
    
    migration_files.each do |file|
      content = File.read(file)
      
      # Look for table references
      content.scan(/(\w+)\s*\.(create_table|add_column|remove_column|add_index|add_foreign_key)/) do |match|
        table_name = match[0]
        migration_tables << table_name
      end
    end
    
    migration_tables.uniq!
    puts "   Found #{migration_tables.length} tables referenced in migrations"
    puts "   Tables: #{migration_tables.join(', ')}"
    
    @results[:validation_methods][:migration_analysis] = {
      method: 'migration_file_analysis',
      migration_files_analyzed: migration_files.length,
      tables_found: migration_tables,
      count: migration_tables.length,
      confidence: 0.75
    }
    
    migration_tables
  end

  def analyze_associations
    puts "\n🔗 Method 6: Association Analysis"
    
    model_files = Dir.glob('../../dashboard/app/models/**/*.rb')
    association_tables = []
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Look for curriculum-related associations
      if content.match?(/(belongs_to|has_many|has_one).*script|level|lesson|course|stage|unit/i)
        model_name = File.basename(file, '.rb').classify
        table_name = model_name.underscore.pluralize
        association_tables << table_name
      end
    end
    
    association_tables.uniq!
    puts "   Found #{association_tables.length} tables with curriculum associations"
    puts "   Tables: #{association_tables.join(', ')}"
    
    @results[:validation_methods][:association_analysis] = {
      method: 'association_analysis',
      model_files_analyzed: model_files.length,
      tables_found: association_tables,
      count: association_tables.length,
      confidence: 0.8
    }
    
    association_tables
  end

  def combine_results(*table_sets)
    puts "\n🔀 Combining Results from All Methods"
    
    all_tables = table_sets.flatten.uniq
    table_scores = {}
    
    # Calculate confidence score for each table
    all_tables.each do |table|
      score = 0
      table_sets.each do |table_set|
        if table_set.include?(table)
          score += 1
        end
      end
      table_scores[table] = score
    end
    
    # Sort by confidence score
    sorted_tables = table_scores.sort_by { |_, score| -score }
    
    # Determine final curriculum tables (appears in 3+ methods)
    @results[:final_curriculum_tables] = sorted_tables.select { |_, score| score >= 3 }.map(&:first)
    
    # Calculate overall confidence
    @results[:confidence_score] = (@results[:final_curriculum_tables].length.to_f / all_tables.length * 100).round(2)
    
    puts "   Total unique tables found: #{all_tables.length}"
    puts "   High confidence tables (3+ methods): #{@results[:final_curriculum_tables].length}"
    puts "   Overall confidence: #{@results[:confidence_score]}%"
    
    puts "\n📊 TABLE CONFIDENCE SCORES:"
    sorted_tables.each do |table, score|
      confidence_level = case score
                        when 5..6 then "Very High"
                        when 3..4 then "High"
                        when 2..2 then "Medium"
                        else "Low"
                        end
      puts "   #{table}: #{score}/6 (#{confidence_level})"
    end
  end

  def generate_report
    puts "\n📊 Generating Table Identification Validation Report"
    
    @results[:summary] = {
      total_methods: @results[:validation_methods].length,
      total_tables_found: @results[:validation_methods].values.map { |v| v[:count] }.sum,
      final_curriculum_tables: @results[:final_curriculum_tables].length,
      confidence_score: @results[:confidence_score],
      recommendations: generate_recommendations
    }
    
    # Save results
    File.write('table_identification_validation.json', JSON.pretty_generate(@results))
    
    # Print final summary
    puts "\n📈 TABLE IDENTIFICATION VALIDATION SUMMARY"
    puts "=" * 50
    puts "Total methods used: #{@results[:summary][:total_methods]}"
    puts "Total tables found: #{@results[:summary][:total_tables_found]}"
    puts "Final curriculum tables: #{@results[:summary][:final_curriculum_tables]}"
    puts "Confidence score: #{@results[:summary][:confidence_score]}%"
    
    puts "\n🎯 FINAL CURRICULUM TABLES:"
    @results[:final_curriculum_tables].each_with_index do |table, index|
      puts "   #{index + 1}. #{table}"
    end
    
    puts "\n💡 RECOMMENDATIONS:"
    @results[:summary][:recommendations].each do |recommendation|
      puts "   • #{recommendation}"
    end
  end

  def generate_recommendations
    recommendations = []
    
    if @results[:confidence_score] >= 80
      recommendations << "High confidence in table identification. Proceed with migration."
    elsif @results[:confidence_score] >= 60
      recommendations << "Medium confidence. Review low-confidence tables before migration."
    else
      recommendations << "Low confidence. Manual review required before migration."
    end
    
    if @results[:final_curriculum_tables].length < 20
      recommendations << "Consider if all curriculum tables have been identified."
    end
    
    if @results[:final_curriculum_tables].length > 50
      recommendations << "Large number of tables identified. Consider if some are not curriculum-related."
    end
    
    recommendations
  end
end

# Run the table identification validator
if __FILE__ == $0
  validator = TableIdentificationValidator.new
  validator.run
end