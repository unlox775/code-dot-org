#!/usr/bin/env ruby
# frozen_string_literal: true

# Master Test Runner for Curriculum GUID Migration
# This script runs all tests in sequence and generates a comprehensive report

require 'json'
require 'fileutils'
require 'time'

class MasterTestRunner
  def initialize
    @results = {
      timestamp: Time.current,
      overall_status: 'running',
      phases: {},
      summary: {}
    }
    @test_dir = File.dirname(__FILE__)
  end

  def run
    puts "🚀 Curriculum GUID Migration - Master Test Runner"
    puts "=" * 60
    puts "Starting comprehensive testing of all phases and steps..."
    puts ""

    # Phase 0: Prerequisites
    run_prerequisites

    # Phase 1: Database Schema Migration
    run_phase1_tests

    # Phase 2: Application Code Updates
    run_phase2_tests

    # Phase 3: Seeding Process Replacement
    run_phase3_tests

    # Phase 4: Level Builder Integration
    run_phase4_tests

    # Generate final report
    generate_final_report

    puts "\n🎉 All tests completed!"
    puts "📊 Final report saved to: master_test_results.json"
  end

  private

  def run_prerequisites
    puts "🔧 Phase 0: Running Prerequisites"
    puts "-" * 40

    # Check Ruby version
    ruby_version = `ruby --version`.strip
    puts "   Ruby version: #{ruby_version}"

    # Check Rails environment
    begin
      require_relative '../dashboard/config/environment'
      puts "   Rails environment: #{Rails.env}"
      puts "   Rails version: #{Rails.version}"
    rescue => e
      puts "   ❌ Rails environment failed: #{e.message}"
      @results[:prerequisites] = { status: 'failed', error: e.message }
      return
    end

    # Check database connection
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "   Database connection: OK"
    rescue => e
      puts "   ❌ Database connection failed: #{e.message}"
      @results[:prerequisites] = { status: 'failed', error: e.message }
      return
    end

    # Check if test data exists
    if Unit.count > 0
      puts "   Test data: Available (#{Unit.count} units)"
    else
      puts "   ⚠️  No test data found. Creating test data..."
      create_test_data
    end

    @results[:prerequisites] = { status: 'passed' }
    puts "   ✅ Prerequisites: PASSED"
  end

  def create_test_data
    puts "   Creating test data..."
    begin
      system("cd #{@test_dir} && ruby test_data/create_test_users.rb")
      puts "   ✅ Test data created successfully"
    rescue => e
      puts "   ❌ Test data creation failed: #{e.message}"
    end
  end

  def run_phase1_tests
    puts "\n📊 Phase 1: Database Schema Migration Tests"
    puts "-" * 40

    phase1_dir = File.join(@test_dir, 'phase1_database_schema')
    
    # Test 1.1: Verify curriculum table identification
    puts "   Running 1.1: Table identification verification..."
    run_test("#{phase1_dir}/verify_curriculum_tables.rb", 'phase1_step1')

    # Test 1.2: Test migration execution
    puts "   Running 1.2: Migration execution test..."
    run_test("#{phase1_dir}/test_migration_execution.rb", 'phase1_step2')

    # Test 1.3: Validate data integrity
    puts "   Running 1.3: Data integrity validation..."
    run_test("#{phase1_dir}/validate_data_integrity.rb", 'phase1_step3')

    @results[:phases][:phase1] = {
      status: 'completed',
      tests_run: 3,
      results: load_test_results('phase1')
    }
  end

  def run_phase2_tests
    puts "\n🧪 Phase 2: Application Code Updates Tests"
    puts "-" * 40

    phase2_dir = File.join(@test_dir, 'phase2_application_code')
    
    # Test 2.1: Test GuidSupport module
    puts "   Running 2.1: GuidSupport module test..."
    run_test("#{phase2_dir}/test_guid_support.rb", 'phase2_step1')

    # Test 2.2: Test dual-key lookups
    puts "   Running 2.2: Dual-key lookup test..."
    run_test("#{phase2_dir}/test_dual_key_lookups.rb", 'phase2_step2')

    # Test 2.3: Test model updates
    puts "   Running 2.3: Model update test..."
    run_test("#{phase2_dir}/test_model_updates.rb", 'phase2_step3')

    @results[:phases][:phase2] = {
      status: 'completed',
      tests_run: 3,
      results: load_test_results('phase2')
    }
  end

  def run_phase3_tests
    puts "\n🔄 Phase 3: Seeding Process Replacement Tests"
    puts "-" * 40

    phase3_dir = File.join(@test_dir, 'phase3_seeding_replacement')
    
    # Test 3.1: Test export service
    puts "   Running 3.1: Export service test..."
    run_test("#{phase3_dir}/test_export_service.rb", 'phase3_step1')

    # Test 3.2: Test import service
    puts "   Running 3.2: Import service test..."
    run_test("#{phase3_dir}/test_import_service.rb", 'phase3_step2')

    # Test 3.3: Test S3 integration
    puts "   Running 3.3: S3 integration test..."
    run_test("#{phase3_dir}/test_s3_integration.rb", 'phase3_step3')

    @results[:phases][:phase3] = {
      status: 'completed',
      tests_run: 3,
      results: load_test_results('phase3')
    }
  end

  def run_phase4_tests
    puts "\n🏗️  Phase 4: Level Builder Integration Tests"
    puts "-" * 40

    phase4_dir = File.join(@test_dir, 'phase4_level_builder')
    
    # Test 4.1: Test GUID generation
    puts "   Running 4.1: GUID generation test..."
    run_test("#{phase4_dir}/test_guid_generation.rb", 'phase4_step1')

    # Test 4.2: Test level file updates
    puts "   Running 4.2: Level file update test..."
    run_test("#{phase4_dir}/test_level_file_updates.rb", 'phase4_step2')

    @results[:phases][:phase4] = {
      status: 'completed',
      tests_run: 2,
      results: load_test_results('phase4')
    }
  end

  def run_test(script_path, test_name)
    begin
      if File.exist?(script_path)
        puts "     Running #{script_path}..."
        result = system("cd #{File.dirname(script_path)} && ruby #{File.basename(script_path)}")
        
        if result
          puts "     ✅ #{test_name}: PASSED"
          return { status: 'passed', test_name: test_name }
        else
          puts "     ❌ #{test_name}: FAILED"
          return { status: 'failed', test_name: test_name }
        end
      else
        puts "     ⚠️  #{test_name}: Script not found (#{script_path})"
        return { status: 'skipped', test_name: test_name, reason: 'Script not found' }
      end
    rescue => e
      puts "     ❌ #{test_name}: ERROR - #{e.message}"
      return { status: 'error', test_name: test_name, error: e.message }
    end
  end

  def load_test_results(phase)
    results = {}
    
    # Look for result files
    result_files = Dir.glob("#{@test_dir}/#{phase}*/*_results.json")
    
    result_files.each do |file|
      begin
        content = File.read(file)
        data = JSON.parse(content)
        results[File.basename(file, '.json')] = data
      rescue => e
        puts "     Warning: Could not load results from #{file}: #{e.message}"
      end
    end
    
    results
  end

  def generate_final_report
    puts "\n📊 Generating Final Test Report"
    puts "-" * 40

    # Calculate overall statistics
    total_tests = 0
    passed_tests = 0
    failed_tests = 0
    skipped_tests = 0

    @results[:phases].each do |phase_name, phase_data|
      if phase_data[:results]
        phase_data[:results].each do |test_name, test_data|
          total_tests += 1
          case test_data['status'] || test_data[:status]
          when 'completed', 'passed', 'success'
            passed_tests += 1
          when 'failed', 'error'
            failed_tests += 1
          when 'skipped'
            skipped_tests += 1
          end
        end
      end
    end

    @results[:summary] = {
      total_tests: total_tests,
      passed_tests: passed_tests,
      failed_tests: failed_tests,
      skipped_tests: skipped_tests,
      success_rate: total_tests > 0 ? (passed_tests.to_f / total_tests * 100).round(2) : 0,
      overall_status: failed_tests > 0 ? 'failed' : 'passed'
    }

    @results[:overall_status] = @results[:summary][:overall_status]

    # Save results
    File.write('master_test_results.json', JSON.pretty_generate(@results))

    # Print final summary
    puts "\n📈 MASTER TEST RESULTS SUMMARY"
    puts "=" * 50
    puts "Total tests run: #{@results[:summary][:total_tests]}"
    puts "Passed: #{@results[:summary][:passed_tests]}"
    puts "Failed: #{@results[:summary][:failed_tests]}"
    puts "Skipped: #{@results[:summary][:skipped_tests]}"
    puts "Success rate: #{@results[:summary][:success_rate]}%"
    puts "Overall status: #{@results[:summary][:overall_status].upcase}"

    puts "\n📋 PHASE BREAKDOWN:"
    @results[:phases].each do |phase_name, phase_data|
      puts "   #{phase_name.upcase}: #{phase_data[:status]} (#{phase_data[:tests_run]} tests)"
    end

    if @results[:summary][:overall_status] == 'passed'
      puts "\n🎉 All tests passed! The curriculum GUID migration is ready to proceed."
    else
      puts "\n⚠️  Some tests failed. Please review the results and fix issues before proceeding."
    end
  end
end

# Run the master test runner
if __FILE__ == $0
  runner = MasterTestRunner.new
  runner.run
end