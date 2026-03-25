# Migration: Create GUID validation script
# This migration creates a validation script to ensure ID/GUID consistency

class CreateGuidValidationScript < ActiveRecord::Migration[7.0]
  def up
    # Create validation script file
    create_validation_script
    
    puts "✅ GUID validation script created at: lib/tasks/validate_guid_consistency.rake"
  end
  
  def down
    # Remove validation script file
    remove_validation_script
    
    puts "✅ GUID validation script removed"
  end
  
  private
  
  def create_validation_script
    script_content = <<~RUBY
      # frozen_string_literal: true
      
      # GUID Consistency Validation Script
      # This script validates that ID and GUID relationships are consistent
      # Run with: bundle exec rake validate_guid_consistency
      
      namespace :curriculum do
        desc "Validate GUID consistency across all curriculum tables"
        task validate_guid_consistency: :environment do
          puts "🔍 Validating GUID consistency across curriculum tables..."
          puts "=" * 60
          
          validator = GuidConsistencyValidator.new
          validator.run
        end
      end
      
      class GuidConsistencyValidator
        def initialize
          @errors = []
          @warnings = []
          @total_checks = 0
          @passed_checks = 0
        end
        
        def run
          puts "📊 Validating 27 curriculum tables..."
          puts ""
          
          # Validate all curriculum tables have GUIDs
          validate_curriculum_tables_have_guids
          
          # Validate GUID uniqueness
          validate_guid_uniqueness
          
          # Validate ID/GUID consistency in foreign key relationships
          validate_foreign_key_consistency
          
          # Print results
          print_results
        end
        
        private
        
        def validate_curriculum_tables_have_guids
          puts "1. Validating curriculum tables have GUIDs..."
          
          curriculum_tables = [
            'scripts', 'stages', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
            'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
            'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels',
            'course_scripts', 'unit_groups_resources', 'unit_groups_student_resources',
            'scripts_resources', 'scripts_student_resources', 'lessons_resources',
            'stages_standards', 'lessons_vocabularies', 'lessons_programming_expressions',
            'learning_goal_evidence_levels', 'lessons_opportunity_standards'
          ]
          
          curriculum_tables.each do |table|
            check_table_has_guid_column(table)
          end
        end
        
        def check_table_has_guid_column(table)
          @total_checks += 1
          
          unless table_exists?(table)
            @warnings << "Table #{table} does not exist"
            return
          end
          
          unless column_exists?(table, 'guid')
            @errors << "Table #{table} missing 'guid' column"
            return
          end
          
          # Check for empty GUIDs
          empty_guids = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM #{table} WHERE guid = '' OR guid IS NULL"
          )
          
          if empty_guids > 0
            @errors << "Table #{table} has #{empty_guids} records with empty GUIDs"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ #{table} - GUID column present and populated"
        end
        
        def validate_guid_uniqueness
          puts "\n2. Validating GUID uniqueness..."
          
          curriculum_tables = [
            'scripts', 'stages', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
            'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
            'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels',
            'course_scripts', 'unit_groups_resources', 'unit_groups_student_resources',
            'scripts_resources', 'scripts_student_resources', 'lessons_resources',
            'stages_standards', 'lessons_vocabularies', 'lessons_programming_expressions',
            'learning_goal_evidence_levels', 'lessons_opportunity_standards'
          ]
          
          curriculum_tables.each do |table|
            check_guid_uniqueness(table)
          end
        end
        
        def check_guid_uniqueness(table)
          @total_checks += 1
          
          unless table_exists?(table)
            @warnings << "Table #{table} does not exist"
            return
          end
          
          # Check for duplicate GUIDs
          duplicate_guids = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) - COUNT(DISTINCT guid) FROM #{table}"
          )
          
          if duplicate_guids > 0
            @errors << "Table #{table} has #{duplicate_guids} duplicate GUIDs"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ #{table} - GUIDs are unique"
        end
        
        def validate_foreign_key_consistency
          puts "\n3. Validating foreign key consistency..."
          
          # Validate script_levels relationships
          validate_script_levels_consistency
          
          # Validate course_scripts relationships
          validate_course_scripts_consistency
          
          # Validate resource relationships
          validate_resource_relationships_consistency
          
          # Validate standards relationships
          validate_standards_relationships_consistency
        end
        
        def validate_script_levels_consistency
          @total_checks += 1
          
          # Check script_guid consistency
          inconsistent_scripts = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM script_levels sl 
             JOIN scripts s ON sl.script_id = s.id 
             WHERE sl.script_guid != s.guid"
          )
          
          if inconsistent_scripts > 0
            @errors << "script_levels has #{inconsistent_scripts} records with inconsistent script_guid"
            return
          end
          
          # Check lesson_guid consistency
          inconsistent_lessons = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM script_levels sl 
             JOIN stages st ON sl.stage_id = st.id 
             WHERE sl.lesson_guid != st.guid"
          )
          
          if inconsistent_lessons > 0
            @errors << "script_levels has #{inconsistent_lessons} records with inconsistent lesson_guid"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ script_levels - Foreign key consistency verified"
        end
        
        def validate_course_scripts_consistency
          @total_checks += 1
          
          # Check course_guid consistency
          inconsistent_courses = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM course_scripts cs 
             JOIN courses c ON cs.course_id = c.id 
             WHERE cs.course_guid != c.guid"
          )
          
          if inconsistent_courses > 0
            @errors << "course_scripts has #{inconsistent_courses} records with inconsistent course_guid"
            return
          end
          
          # Check script_guid consistency
          inconsistent_scripts = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM course_scripts cs 
             JOIN scripts s ON cs.script_id = s.id 
             WHERE cs.script_guid != s.guid"
          )
          
          if inconsistent_scripts > 0
            @errors << "course_scripts has #{inconsistent_scripts} records with inconsistent script_guid"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ course_scripts - Foreign key consistency verified"
        end
        
        def validate_resource_relationships_consistency
          @total_checks += 1
          
          # Check scripts_resources consistency
          inconsistent_resources = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM scripts_resources sr 
             JOIN scripts s ON sr.script_id = s.id 
             WHERE sr.script_guid != s.guid"
          )
          
          if inconsistent_resources > 0
            @errors << "scripts_resources has #{inconsistent_resources} records with inconsistent script_guid"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ Resource relationships - Foreign key consistency verified"
        end
        
        def validate_standards_relationships_consistency
          @total_checks += 1
          
          # Check stages_standards consistency
          inconsistent_standards = ActiveRecord::Base.connection.select_value(
            "SELECT COUNT(*) FROM stages_standards ss 
             JOIN stages st ON ss.stage_id = st.id 
             WHERE ss.lesson_guid != st.guid"
          )
          
          if inconsistent_standards > 0
            @errors << "stages_standards has #{inconsistent_standards} records with inconsistent lesson_guid"
            return
          end
          
          @passed_checks += 1
          puts "  ✅ Standards relationships - Foreign key consistency verified"
        end
        
        def print_results
          puts "\n📈 VALIDATION RESULTS"
          puts "=" * 60
          puts "Total checks: #{@total_checks}"
          puts "Passed checks: #{@passed_checks}"
          puts "Failed checks: #{@total_checks - @passed_checks}"
          puts "Warnings: #{@warnings.length}"
          
          if @warnings.any?
            puts "\n⚠️  WARNINGS:"
            @warnings.each { |warning| puts "  - #{warning}" }
          end
          
          if @errors.any?
            puts "\n❌ ERRORS:"
            @errors.each { |error| puts "  - #{error}" }
            puts "\n❌ VALIDATION FAILED - Fix errors before proceeding"
            exit 1
          else
            puts "\n✅ VALIDATION PASSED - All GUID relationships are consistent"
          end
        end
        
        def table_exists?(table)
          ActiveRecord::Base.connection.table_exists?(table)
        end
        
        def column_exists?(table, column)
          ActiveRecord::Base.connection.column_exists?(table, column)
        end
      end
    RUBY
    
    # Write the script to the tasks directory
    FileUtils.mkdir_p(Rails.root.join('lib', 'tasks'))
    File.write(Rails.root.join('lib', 'tasks', 'validate_guid_consistency.rake'), script_content)
  end
  
  def remove_validation_script
    script_path = Rails.root.join('lib', 'tasks', 'validate_guid_consistency.rake')
    File.delete(script_path) if File.exist?(script_path)
  end
end