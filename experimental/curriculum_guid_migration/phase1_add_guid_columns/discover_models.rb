#!/usr/bin/env ruby
# frozen_string_literal: true

# SIMPLE Code Analysis - No Rails Required
# This script analyzes the actual code files to find curriculum tables

require 'json'

class SimpleCodeAnalyzer
  def initialize
    @results = {
      timestamp: Time.now,
      validation_method: 'simple_code_analysis',
      findings: {}
    }
  end

  def run
    puts "🔍 SIMPLE Code Analysis - No Rails Required"
    puts "=" * 60
    puts "This analyzes actual code files to find curriculum tables"
    puts ""

    # Method 1: Analyze ScriptSeed service
    analyze_script_seed_service

    # Method 2: Analyze model files
    analyze_model_files

    # Method 3: Analyze seeding rake tasks
    analyze_seeding_tasks

    # Method 4: Cross-reference with our assumptions
    cross_reference_assumptions

    # Generate honest report
    generate_honest_report

    puts "\n✅ SIMPLE analysis complete!"
    puts "📊 Results saved to: simple_code_analysis.json"
  end

  private

  def analyze_script_seed_service
    puts "📋 Method 1: Analyzing ScriptSeed Service"
    puts "-" * 40
    
    script_seed_file = '/workspace/dashboard/lib/services/script_seed.rb'
    
    unless File.exist?(script_seed_file)
      puts "   ❌ ScriptSeed file not found: #{script_seed_file}"
      return
    end
    
    content = File.read(script_seed_file)
    
    # Extract model names from database operations
    models_from_seeding = []
    
    # Look for model names in database operations
    content.scan(/(\w+)\.(import!|where|find|create|update|delete)/) do |match|
      model_name = match[0]
      # Skip common non-model words
      next if %w[File FileUtils JSON ActiveRecord Base].include?(model_name)
      models_from_seeding << model_name
    end
    
    # Also look for explicit table references in where clauses
    content.scan(/where\('(\w+)\./).each do |match|
      models_from_seeding << match[0]
    end
    
    models_from_seeding.uniq!
    
    puts "   Models found in ScriptSeed service: #{models_from_seeding.length}"
    puts "   Models: #{models_from_seeding.join(', ')}"
    
    @results[:findings][:script_seed_models] = models_from_seeding
  end

  def analyze_model_files
    puts "\n🏗️  Method 2: Analyzing Model Files"
    puts "-" * 40
    
    model_files = Dir.glob('/workspace/dashboard/app/models/**/*.rb')
    curriculum_models = []
    
    model_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      next unless content.include?('ActiveRecord::Base')
      
      # Look for curriculum-related associations
      if content.match?(/(belongs_to|has_many|has_one).*script|level|lesson|course|stage|unit/i)
        model_name = File.basename(file, '.rb').split('_').map(&:capitalize).join
        curriculum_models << model_name
      end
    end
    
    curriculum_models.uniq!
    
    puts "   Curriculum-related models found: #{curriculum_models.length}"
    puts "   Models: #{curriculum_models.join(', ')}"
    
    @results[:findings][:curriculum_models] = curriculum_models
  end

  def analyze_seeding_tasks
    puts "\n🌱 Method 3: Analyzing Seeding Tasks"
    puts "-" * 40
    
    seeding_files = Dir.glob('/workspace/dashboard/lib/tasks/**/*seed*.rb')
    models_from_tasks = []
    
    seeding_files.each do |file|
      next unless File.file?(file)
      
      content = File.read(file)
      
      # Look for model names in seeding tasks
      content.scan(/(\w+)\.(seed|setup|create|find|where)/) do |match|
        model_name = match[0]
        # Skip common non-model words
        next if %w[File FileUtils JSON ActiveRecord Base].include?(model_name)
        models_from_tasks << model_name
      end
    end
    
    models_from_tasks.uniq!
    
    puts "   Models found in seeding tasks: #{models_from_tasks.length}"
    puts "   Models: #{models_from_tasks.join(', ')}"
    
    @results[:findings][:seeding_task_models] = models_from_tasks
  end

  def cross_reference_assumptions
    puts "\n🔍 Method 4: Cross-Referencing with Our Assumptions"
    puts "-" * 40
    
    # Our original assumptions (converted to model names)
    our_assumptions = [
      'Script', 'Level', 'Stage', 'LessonGroup', 'Course', 'UnitGroup',
      'CourseOffering', 'Activity', 'ScriptLevel', 'LessonActivity',
      'CourseScript', 'StageScript', 'UnitGroupCourse', 'ActivityScript',
      'UserLevel', 'UserScript', 'UserLesson', 'UserCourse', 'UserStage',
      'UserUnit', 'UserActivity', 'UserScriptLevel', 'UserLessonActivity',
      'UserCourseScript', 'UserStageScript', 'UserUnitGroup',
      'UserCourseOffering', 'UserActivityScript', 'UserScriptActivity',
      'UserLessonScriptLevel', 'UserCourseScriptLevel'
    ]
    
    # Get all models from our analysis
    all_found_models = (
      (@results[:findings][:script_seed_models] || []) +
      (@results[:findings][:curriculum_models] || []) +
      (@results[:findings][:seeding_task_models] || [])
    ).uniq
    
    # Compare
    confirmed_models = our_assumptions & all_found_models
    missing_models = our_assumptions - all_found_models
    extra_models = all_found_models - our_assumptions
    
    puts "   Our assumptions: #{our_assumptions.length} models"
    puts "   Confirmed by analysis: #{confirmed_models.length} models"
    puts "   Missing from analysis: #{missing_models.length} models"
    puts "   Extra models found: #{extra_models.length} models"
    
    if confirmed_models.any?
      puts "\n   ✅ CONFIRMED MODELS:"
      confirmed_models.each { |model| puts "     - #{model}" }
    end
    
    if missing_models.any?
      puts "\n   ❌ MISSING MODELS (in our assumptions but not found in code):"
      missing_models.each { |model| puts "     - #{model}" }
    end
    
    if extra_models.any?
      puts "\n   ⚠️  EXTRA MODELS (found in code but not in our assumptions):"
      extra_models.each { |model| puts "     - #{model}" }
    end
    
    @results[:findings][:comparison] = {
      our_assumptions: our_assumptions,
      confirmed_models: confirmed_models,
      missing_models: missing_models,
      extra_models: extra_models,
      confidence_score: (confirmed_models.length.to_f / our_assumptions.length * 100).round(2)
    }
  end

  def generate_honest_report
    puts "\n📊 Generating HONEST Report"
    puts "-" * 40
    
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
    
    if comparison[:missing_models].any?
      puts "   • Review missing models: #{comparison[:missing_models].join(', ')}"
      puts "     These may not actually be curriculum models"
    end
    
    if comparison[:extra_models].any?
      puts "   • Consider adding extra models: #{comparison[:extra_models].join(', ')}"
      puts "     These appear to be curriculum-related based on actual code"
    end
    
    if comparison[:confidence_score] < 80
      puts "   • Our original assumptions need significant revision"
      puts "   • Focus on models confirmed by actual code analysis"
    end
    
    # Save results
    File.write('simple_code_analysis.json', JSON.pretty_generate(@results))
    
    puts "\n📈 FINAL SUMMARY:"
    puts "   Total models in our assumptions: #{comparison[:our_assumptions].length}"
    puts "   Models confirmed by code: #{comparison[:confirmed_models].length}"
    puts "   Models missing from code: #{comparison[:missing_models].length}"
    puts "   Extra models found in code: #{comparison[:extra_models].length}"
    puts "   Overall confidence: #{comparison[:confidence_score]}%"
  end
end

# Run the simple analysis
if __FILE__ == $0
  analyzer = SimpleCodeAnalyzer.new
  analyzer.run
end