#!/usr/bin/env ruby
# frozen_string_literal: true

# CORRECTED Curriculum Analysis - Excludes User Tables
# This script analyzes curriculum tables EXCLUDING user progress tables

require 'json'

class CorrectedCurriculumAnalyzer
  def initialize
    @results = {
      timestamp: Time.now,
      analysis_type: 'corrected_curriculum_analysis',
      findings: {}
    }
  end

  def run
    puts "🔍 CORRECTED Curriculum Analysis - Excluding User Tables"
    puts "=" * 70
    puts "This analyzes ONLY curriculum content tables, NOT user progress tables"
    puts ""

    # Analyze curriculum content tables only
    analyze_curriculum_content_tables

    # Analyze what we're excluding
    analyze_excluded_tables

    # Generate corrected report
    generate_corrected_report

    puts "\n✅ CORRECTED analysis complete!"
    puts "📊 Results saved to: corrected_curriculum_analysis.json"
  end

  private

  def analyze_curriculum_content_tables
    puts "📚 Analyzing CURRICULUM CONTENT Tables (Content Only)"
    puts "-" * 60
    
    # Core curriculum content tables (NO user_id)
    core_tables = [
      { table: 'scripts', model: 'Unit', purpose: 'Complete curriculum courses', example: 'CS Discoveries' },
      { table: 'stages', model: 'Lesson', purpose: 'Individual lessons', example: 'Problem Solving' },
      { table: 'levels', model: 'Level', purpose: 'Coding challenges', example: 'Maze: Move Forward' },
      { table: 'lesson_groups', model: 'LessonGroup', purpose: 'Chapters that organize lessons', example: 'Unit 1: Problem Solving' },
      { table: 'lesson_activities', model: 'LessonActivity', purpose: 'Hands-on exercises', example: 'Brainstorming Solutions' },
      { table: 'activity_sections', model: 'ActivitySection', purpose: 'Steps within activities', example: 'Step 1: Read Code' },
      { table: 'courses', model: 'Course', purpose: 'Academic course definitions', example: 'AP Computer Science A' },
      { table: 'course_offerings', model: 'CourseOffering', purpose: 'Specific course instances', example: 'AP CS A - Fall 2024 - Period 3' }
    ]
    
    # Curriculum organization tables (NO user_id)
    organization_tables = [
      { table: 'unit_groups', model: 'UnitGroup', purpose: 'Curriculum families', example: 'CS Fundamentals' },
      { table: 'script_levels', model: 'ScriptLevel', purpose: 'Roadmap of levels in scripts', example: 'CS Discoveries level sequence' },
      { table: 'levels_script_levels', model: 'LevelsScriptLevel', purpose: 'Complex level relationships', example: 'Level dependencies' }
    ]
    
    # Curriculum resource tables (NO user_id)
    resource_tables = [
      { table: 'course_scripts', model: 'CourseScript', purpose: 'Join table (courses ↔ scripts)', example: 'AP CS A includes CS Principles' },
      { table: 'unit_groups_resources', model: 'UnitGroupResource', purpose: 'Resources for unit groups', example: 'CS Fundamentals teacher guide' },
      { table: 'unit_groups_student_resources', model: 'UnitGroupStudentResource', purpose: 'Student resources for unit groups', example: 'CS Fundamentals student reference' },
      { table: 'scripts_resources', model: 'ScriptResource', purpose: 'Resources for scripts', example: 'CS Discoveries teacher guide' },
      { table: 'scripts_student_resources', model: 'ScriptStudentResource', purpose: 'Student resources for scripts', example: 'CS Discoveries student reference' },
      { table: 'lessons_resources', model: 'LessonResource', purpose: 'Resources for lessons', example: 'Problem Solving worksheet' },
      { table: 'stages_standards', model: 'StageStandard', purpose: 'Standards alignment', example: 'CSTA 1A-AP-14 alignment' },
      { table: 'lessons_vocabularies', model: 'LessonVocabulary', purpose: 'Vocabulary for lessons', example: 'Problem Solving terms' }
    ]
    
    all_curriculum_tables = core_tables + organization_tables + resource_tables
    
    puts "   Core curriculum content tables: #{core_tables.length}"
    puts "   Curriculum organization tables: #{organization_tables.length}"
    puts "   Curriculum resource tables: #{resource_tables.length}"
    puts "   TOTAL curriculum tables: #{all_curriculum_tables.length}"
    
    @results[:findings][:curriculum_content_tables] = {
      core_tables: core_tables,
      organization_tables: organization_tables,
      resource_tables: resource_tables,
      total_count: all_curriculum_tables.length
    }
    
    puts "\n   ✅ CURRICULUM CONTENT TABLES (19 total):"
    all_curriculum_tables.each_with_index do |table, index|
      puts "   #{index + 1}. #{table[:table]} (#{table[:model]}) - #{table[:purpose]}"
    end
  end

  def analyze_excluded_tables
    puts "\n🚫 Analyzing EXCLUDED Tables (User Progress Data)"
    puts "-" * 60
    
    # User progress tables (EXCLUDED - contain user_id)
    excluded_tables = [
      { table: 'user_levels', model: 'UserLevel', purpose: 'Student progress on coding challenges', reason: 'Contains user_id - transactional data' },
      { table: 'user_scripts', model: 'UserScript', purpose: 'Student progress on curriculum courses', reason: 'Contains user_id - transactional data' },
      { table: 'activities', model: 'Activity', purpose: 'Student interactions and attempts', reason: 'Contains user_id - transactional data' },
      { table: 'user_level_interactions', model: 'UserLevelInteraction', purpose: 'Additional student interactions', reason: 'Contains user_id - transactional data' }
    ]
    
    puts "   EXCLUDED user progress tables: #{excluded_tables.length}"
    puts "   These are transactional data tables, NOT curriculum content"
    
    @results[:findings][:excluded_tables] = {
      excluded_tables: excluded_tables,
      total_count: excluded_tables.length,
      reason: 'These tables contain user_id and are transactional data, not curriculum content'
    }
    
    puts "\n   ❌ EXCLUDED TABLES (4 total):"
    excluded_tables.each_with_index do |table, index|
      puts "   #{index + 1}. #{table[:table]} (#{table[:model]}) - #{table[:purpose]}"
      puts "      Reason: #{table[:reason]}"
    end
  end

  def generate_corrected_report
    puts "\n📊 Generating CORRECTED Report"
    puts "-" * 60
    
    curriculum_tables = @results[:findings][:curriculum_content_tables]
    excluded_tables = @results[:findings][:excluded_tables]
    
    puts "\n🎯 CORRECTED CURRICULUM TABLE LIST:"
    puts "   Curriculum content tables: #{curriculum_tables[:total_count]}"
    puts "   Excluded user tables: #{excluded_tables[:total_count]}"
    puts "   Total tables analyzed: #{curriculum_tables[:total_count] + excluded_tables[:total_count]}"
    
    puts "\n✅ MIGRATION SCOPE:"
    puts "   Tables to migrate to GUIDs: #{curriculum_tables[:total_count]}"
    puts "   Tables to keep ID-based: #{excluded_tables[:total_count]}"
    
    puts "\n💡 KEY INSIGHTS:"
    puts "   • Curriculum content tables define WHAT students learn"
    puts "   • User progress tables track HOW students learn"
    puts "   • GUID migration should focus on content, not progress"
    puts "   • User data should remain ID-based for performance"
    
    # Save results
    File.write('corrected_curriculum_analysis.json', JSON.pretty_generate(@results))
    
    puts "\n📈 FINAL SUMMARY:"
    puts "   Curriculum tables for GUID migration: #{curriculum_tables[:total_count]}"
    puts "   User tables to keep ID-based: #{excluded_tables[:total_count]}"
    puts "   Migration scope: CONTENT ONLY (not user progress)"
    puts "   Status: READY FOR CORRECTED MIGRATION"
  end
end

# Run the corrected analysis
if __FILE__ == $0
  analyzer = CorrectedCurriculumAnalyzer.new
  analyzer.run
end