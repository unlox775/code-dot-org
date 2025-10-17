#!/usr/bin/env ruby
# frozen_string_literal: true

# Validate Table Identification Assumptions
# This script validates our assumptions about which tables are curriculum-related

require 'active_record'
require 'json'

# Load Rails environment
require_relative '../dashboard/config/environment'

class TableAssumptionValidator
  def initialize
    @results = {
      timestamp: Time.current,
      assumptions: {},
      validation_results: {},
      final_recommendations: []
    }
  end

  def run
    puts "🔍 Validating Table Identification Assumptions"
    puts "=" * 60

    # Get all tables
    all_tables = ActiveRecord::Base.connection.tables.sort
    puts "Total tables in database: #{all_tables.length}"

    # Our original assumptions
    original_assumptions = [
      'scripts', 'levels', 'stages', 'lesson_groups', 'courses', 'unit_groups',
      'course_offerings', 'activities', 'script_levels', 'lesson_activities',
      'course_scripts', 'stage_scripts', 'unit_group_courses', 'activity_scripts',
      'user_levels', 'user_scripts', 'user_lessons', 'user_courses', 'user_stages',
      'user_units', 'user_activities', 'user_script_levels', 'user_lesson_activities',
      'user_course_scripts', 'user_stage_scripts', 'user_unit_groups',
      'user_course_offerings', 'user_activity_scripts', 'user_script_activities',
      'user_lesson_script_levels', 'user_course_script_levels'
    ]

    puts "\n📋 Original Assumptions:"
    puts "   #{original_assumptions.length} tables assumed to be curriculum-related"

    # Validate each assumption
    validate_assumptions(original_assumptions, all_tables)

    # Find additional curriculum tables
    find_additional_tables(all_tables, original_assumptions)

    # Generate recommendations
    generate_recommendations

    # Save results
    File.write('table_assumption_validation.json', JSON.pretty_generate(@results))

    puts "\n✅ Table assumption validation complete!"
    puts "📊 Results saved to: table_assumption_validation.json"
  end

  private

  def validate_assumptions(assumptions, all_tables)
    puts "\n🔍 Validating Original Assumptions:"
    
    assumptions.each do |table|
      exists = all_tables.include?(table)
      has_data = exists ? table_has_data?(table) : false
      has_curriculum_columns = exists ? has_curriculum_columns?(table) : false
      
      @results[:assumptions][table] = {
        exists: exists,
        has_data: has_data,
        has_curriculum_columns: has_curriculum_columns,
        confidence: calculate_confidence(exists, has_data, has_curriculum_columns)
      }
      
      status = if exists && has_data && has_curriculum_columns
                 "✅ HIGH"
               elsif exists && (has_data || has_curriculum_columns)
                 "⚠️  MEDIUM"
               elsif exists
                 "❌ LOW"
               else
                 "❌ NOT FOUND"
               end
      
      puts "   #{table}: #{status}"
    end
  end

  def table_has_data?(table)
    begin
      count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first[0]
      count > 0
    rescue
      false
    end
  end

  def has_curriculum_columns?(table)
    begin
      columns = ActiveRecord::Base.connection.columns(table)
      column_names = columns.map(&:name)
      
      curriculum_keywords = %w[script level lesson course stage unit group offering activity]
      column_names.any? { |col| curriculum_keywords.any? { |keyword| col.include?(keyword) } }
    rescue
      false
    end
  end

  def calculate_confidence(exists, has_data, has_curriculum_columns)
    if exists && has_data && has_curriculum_columns
      0.9
    elsif exists && (has_data || has_curriculum_columns)
      0.6
    elsif exists
      0.3
    else
      0.0
    end
  end

  def find_additional_tables(all_tables, original_assumptions)
    puts "\n🔍 Finding Additional Curriculum Tables:"
    
    additional_tables = []
    
    all_tables.each do |table|
      next if original_assumptions.include?(table)
      
      # Check if table has curriculum-related columns
      if has_curriculum_columns?(table)
        has_data = table_has_data?(table)
        confidence = has_data ? 0.8 : 0.5
        
        additional_tables << {
          table: table,
          has_data: has_data,
          confidence: confidence
        }
        
        status = has_data ? "✅ HIGH" : "⚠️  MEDIUM"
        puts "   #{table}: #{status} (not in original assumptions)"
      end
    end
    
    @results[:additional_tables] = additional_tables
    puts "   Found #{additional_tables.length} additional curriculum tables"
  end

  def generate_recommendations
    puts "\n💡 Generating Recommendations:"
    
    # Analyze results
    high_confidence = @results[:assumptions].select { |_, data| data[:confidence] >= 0.8 }
    medium_confidence = @results[:assumptions].select { |_, data| data[:confidence] >= 0.6 && data[:confidence] < 0.8 }
    low_confidence = @results[:assumptions].select { |_, data| data[:confidence] < 0.6 }
    
    recommendations = []
    
    if high_confidence.length > 0
      recommendations << "High confidence tables (#{high_confidence.length}): #{high_confidence.keys.join(', ')}"
    end
    
    if medium_confidence.length > 0
      recommendations << "Medium confidence tables (#{medium_confidence.length}): #{medium_confidence.keys.join(', ')}"
    end
    
    if low_confidence.length > 0
      recommendations << "Low confidence tables (#{low_confidence.length}): #{low_confidence.keys.join(', ')}"
    end
    
    if @results[:additional_tables].length > 0
      recommendations << "Additional tables found: #{@results[:additional_tables].map { |t| t[:table] }.join(', ')}"
    end
    
    # Final recommendations
    total_curriculum_tables = high_confidence.length + @results[:additional_tables].length
    recommendations << "Total curriculum tables identified: #{total_curriculum_tables}"
    
    if total_curriculum_tables < 20
      recommendations << "Consider if all curriculum tables have been identified"
    elsif total_curriculum_tables > 50
      recommendations << "Large number of tables identified. Review for non-curriculum tables"
    end
    
    @results[:final_recommendations] = recommendations
    
    recommendations.each do |rec|
      puts "   • #{rec}"
    end
  end
end

# Run the table assumption validator
if __FILE__ == $0
  validator = TableAssumptionValidator.new
  validator.run
end