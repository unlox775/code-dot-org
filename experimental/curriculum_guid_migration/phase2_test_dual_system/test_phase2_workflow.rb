#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 2 Test Script
# This script tests the complete Phase 2 workflow: export -> import -> validation

require 'fileutils'
require 'json'

class Phase2WorkflowTester
  def initialize
    @test_directory = '/workspace/experimental/curriculum_guid_migration/phase2_test_dual_system'
    @export_directory = '/workspace/tmp/curriculum_guid_export'
    @test_results = {
      export_test: nil,
      import_test: nil,
      validation_test: nil,
      overall_success: false
    }
  end
  
  def run_all_tests
    puts "🧪 Phase 2 Workflow Testing"
    puts "=" * 60
    puts ""
    
    # Test 1: Export system
    test_export_system
    
    # Test 2: Import system
    test_import_system
    
    # Test 3: Validation
    test_validation
    
    # Print results
    print_test_results
  end
  
  private
  
  def test_export_system
    puts "📤 Testing Export System..."
    puts "  Running: bundle exec rake curriculum:export_guids"
    
    # Run the export task
    export_result = system("cd /workspace && bundle exec rake curriculum:export_guids")
    
    if export_result
      # Check if export files were created
      export_files = Dir.glob(File.join(@export_directory, '*', '*.json'))
      
      if export_files.any?
        latest_export = Dir.glob(File.join(@export_directory, '*')).max_by { |f| File.mtime(f) }
        @test_results[:export_test] = {
          success: true,
          export_directory: latest_export,
          files_created: export_files.length,
          message: "Export completed successfully"
        }
        puts "  ✅ Export test passed - #{export_files.length} files created"
      else
        @test_results[:export_test] = {
          success: false,
          message: "No export files found"
        }
        puts "  ❌ Export test failed - no files created"
      end
    else
      @test_results[:export_test] = {
        success: false,
        message: "Export command failed"
      }
      puts "  ❌ Export test failed - command failed"
    end
    
    puts ""
  end
  
  def test_import_system
    puts "📥 Testing Import System..."
    
    # Find the latest export directory
    latest_export = Dir.glob(File.join(@export_directory, '*')).max_by { |f| File.mtime(f) }
    
    if latest_export.nil?
      @test_results[:import_test] = {
        success: false,
        message: "No export directory found for import test"
      }
      puts "  ❌ Import test failed - no export directory found"
      return
    end
    
    puts "  Using export directory: #{latest_export}"
    puts "  Running: bundle exec rake curriculum:import_guids[#{latest_export}]"
    
    # Run the import task
    import_result = system("cd /workspace && bundle exec rake curriculum:import_guids[#{latest_export}]")
    
    if import_result
      @test_results[:import_test] = {
        success: true,
        import_directory: latest_export,
        message: "Import completed successfully"
      }
      puts "  ✅ Import test passed"
    else
      @test_results[:import_test] = {
        success: false,
        message: "Import command failed"
      }
      puts "  ❌ Import test failed - command failed"
    end
    
    puts ""
  end
  
  def test_validation
    puts "🔍 Testing Validation..."
    
    # Test 1: Check that all curriculum tables have GUIDs
    puts "  Checking GUID presence in curriculum tables..."
    
    curriculum_tables = [
      'scripts', 'stages', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
      'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
      'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels',
      'course_scripts', 'unit_groups_resources', 'unit_groups_student_resources',
      'scripts_resources', 'scripts_student_resources', 'lessons_resources',
      'stages_standards', 'lessons_vocabularies', 'lessons_programming_expressions',
      'learning_goal_evidence_levels', 'lessons_opportunity_standards'
    ]
    
    guid_validation_results = {}
    
    curriculum_tables.each do |table|
      begin
        # Check if table has GUID column
        result = `cd /workspace && bundle exec rails runner "puts ActiveRecord::Base.connection.column_exists?('#{table}', 'guid')"`
        has_guid_column = result.strip == 'true'
        
        if has_guid_column
          # Check if GUIDs are populated
          count_result = `cd /workspace && bundle exec rails runner "puts ActiveRecord::Base.connection.select_value('SELECT COUNT(*) FROM #{table} WHERE guid IS NOT NULL AND guid != \\'\\'')"`
          guid_count = count_result.strip.to_i
          
          total_result = `cd /workspace && bundle exec rails runner "puts ActiveRecord::Base.connection.select_value('SELECT COUNT(*) FROM #{table}')"`
          total_count = total_result.strip.to_i
          
          guid_validation_results[table] = {
            has_guid_column: true,
            guid_count: guid_count,
            total_count: total_count,
            all_have_guids: guid_count == total_count
          }
        else
          guid_validation_results[table] = {
            has_guid_column: false,
            error: "No GUID column found"
          }
        end
      rescue => e
        guid_validation_results[table] = {
          error: e.message
        }
      end
    end
    
    # Test 2: Check mapping tables
    puts "  Checking GUID mapping tables..."
    
    mapping_tables = [
      'script_guid_mappings', 'lesson_guid_mappings', 'level_guid_mappings',
      'lesson_group_guid_mappings', 'lesson_activity_guid_mappings', 'activity_section_guid_mappings',
      'course_guid_mappings', 'course_offering_guid_mappings', 'course_version_guid_mappings',
      'objective_guid_mappings', 'programming_expression_guid_mappings', 'rubric_guid_mappings',
      'learning_goal_guid_mappings', 'unit_group_guid_mappings', 'script_level_guid_mappings',
      'levels_script_level_guid_mappings', 'course_script_guid_mappings', 'unit_group_resource_guid_mappings',
      'unit_group_student_resource_guid_mappings', 'script_resource_guid_mappings',
      'script_student_resource_guid_mappings', 'lesson_resource_guid_mappings',
      'lesson_standard_guid_mappings', 'lesson_vocabulary_guid_mappings',
      'lesson_programming_expression_guid_mappings', 'learning_goal_evidence_level_guid_mappings',
      'lesson_opportunity_standard_guid_mappings'
    ]
    
    mapping_validation_results = {}
    
    mapping_tables.each do |table|
      begin
        exists_result = `cd /workspace && bundle exec rails runner "puts ActiveRecord::Base.connection.table_exists?('#{table}')"`
        table_exists = exists_result.strip == 'true'
        
        if table_exists
          count_result = `cd /workspace && bundle exec rails runner "puts ActiveRecord::Base.connection.select_value('SELECT COUNT(*) FROM #{table}')"`
          mapping_count = count_result.strip.to_i
          
          mapping_validation_results[table] = {
            exists: true,
            mapping_count: mapping_count
          }
        else
          mapping_validation_results[table] = {
            exists: false,
            error: "Table does not exist"
          }
        end
      rescue => e
        mapping_validation_results[table] = {
          error: e.message
        }
      end
    end
    
    # Evaluate validation results
    all_guids_present = guid_validation_results.all? { |_, result| result[:all_have_guids] == true }
    all_mappings_present = mapping_validation_results.all? { |_, result| result[:exists] == true }
    
    @test_results[:validation_test] = {
      success: all_guids_present && all_mappings_present,
      guid_validation: guid_validation_results,
      mapping_validation: mapping_validation_results,
      all_guids_present: all_guids_present,
      all_mappings_present: all_mappings_present,
      message: all_guids_present && all_mappings_present ? "All validations passed" : "Some validations failed"
    }
    
    if all_guids_present && all_mappings_present
      puts "  ✅ Validation test passed - all GUIDs and mappings present"
    else
      puts "  ❌ Validation test failed - some issues found"
    end
    
    puts ""
  end
  
  def print_test_results
    puts "📊 TEST RESULTS SUMMARY"
    puts "=" * 60
    
    # Export test results
    if @test_results[:export_test][:success]
      puts "✅ Export System: PASSED"
      puts "   Files created: #{@test_results[:export_test][:files_created]}"
      puts "   Directory: #{@test_results[:export_test][:export_directory]}"
    else
      puts "❌ Export System: FAILED"
      puts "   Error: #{@test_results[:export_test][:message]}"
    end
    
    puts ""
    
    # Import test results
    if @test_results[:import_test][:success]
      puts "✅ Import System: PASSED"
      puts "   Import directory: #{@test_results[:import_test][:import_directory]}"
    else
      puts "❌ Import System: FAILED"
      puts "   Error: #{@test_results[:import_test][:message]}"
    end
    
    puts ""
    
    # Validation test results
    if @test_results[:validation_test][:success]
      puts "✅ Validation: PASSED"
      puts "   All GUIDs present: #{@test_results[:validation_test][:all_guids_present]}"
      puts "   All mappings present: #{@test_results[:validation_test][:all_mappings_present]}"
    else
      puts "❌ Validation: FAILED"
      puts "   All GUIDs present: #{@test_results[:validation_test][:all_guids_present]}"
      puts "   All mappings present: #{@test_results[:validation_test][:all_mappings_present]}"
    end
    
    puts ""
    
    # Overall result
    @test_results[:overall_success] = @test_results[:export_test][:success] && 
                                     @test_results[:import_test][:success] && 
                                     @test_results[:validation_test][:success]
    
    if @test_results[:overall_success]
      puts "🎉 PHASE 2 WORKFLOW: ALL TESTS PASSED"
      puts "   Phase 2 implementation is working correctly!"
    else
      puts "❌ PHASE 2 WORKFLOW: SOME TESTS FAILED"
      puts "   Check individual test results above for details"
    end
    
    # Save results to file
    save_test_results
  end
  
  def save_test_results
    results_file = File.join(@test_directory, "test_results_#{Time.current.strftime('%Y%m%d_%H%M%S')}.json")
    File.write(results_file, JSON.pretty_generate(@test_results))
    puts ""
    puts "📁 Test results saved to: #{results_file}"
  end
end

# Run the tests
if __FILE__ == $0
  tester = Phase2WorkflowTester.new
  tester.run_all_tests
end