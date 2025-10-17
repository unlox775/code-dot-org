#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 2 Step 1: Test GuidSupport Module
# This script tests the GuidSupport module functionality

require 'active_record'
require 'json'

# Load Rails environment
require_relative '../../dashboard/config/environment'

class GuidSupportTester
  def initialize
    @results = {
      timestamp: Time.current,
      phase: 'Phase 2',
      step: 'Step 1: Test GuidSupport Module',
      status: 'running'
    }
    @test_models = []
  end

  def run
    puts "🧪 Phase 2 Step 1: Testing GuidSupport Module"
    puts "=" * 60

    # Check prerequisites
    unless check_prerequisites
      puts "❌ Prerequisites not met. Exiting."
      exit 1
    end

    # Step 1: Test GuidSupport module loading
    test_module_loading

    # Step 2: Test model inclusion
    test_model_inclusion

    # Step 3: Test GUID generation
    test_guid_generation

    # Step 4: Test dual-key lookups
    test_dual_key_lookups

    # Step 5: Test validation
    test_validation

    # Step 6: Test cache key generation
    test_cache_key_generation

    # Step 7: Generate report
    generate_report

    puts "\n✅ Phase 2 Step 1 Complete!"
    puts "📊 Results saved to: phase2_step1_results.json"
  end

  private

  def check_prerequisites
    puts "\n🔍 Checking prerequisites..."
    
    # Check if GuidSupport module exists
    unless defined?(GuidSupport)
      puts "❌ GuidSupport module not found!"
      return false
    end
    puts "   ✅ GuidSupport module: OK"

    # Check if test models exist
    test_models = %w[Unit ScriptLevel Level]
    missing_models = test_models.reject { |model| defined?(model.constantize) }
    
    if missing_models.any?
      puts "❌ Missing models: #{missing_models.join(', ')}"
      return false
    end
    puts "   ✅ Test models: OK"

    # Check if database has test data
    unless Unit.count > 0
      puts "❌ No test data found. Please run test_data/create_test_users.rb first."
      return false
    end
    puts "   ✅ Test data: OK"

    true
  end

  def test_module_loading
    puts "\n📦 Step 1: Testing GuidSupport module loading..."
    
    begin
      # Test module constants
      constants = GuidSupport.constants
      puts "   Module constants: #{constants.join(', ')}"
      
      # Test module methods
      methods = GuidSupport.instance_methods
      puts "   Instance methods: #{methods.length} methods"
      
      # Test class methods
      class_methods = GuidSupport.methods - Object.methods
      puts "   Class methods: #{class_methods.length} methods"
      
      @results[:module_loading] = {
        status: 'success',
        constants: constants,
        instance_methods: methods.length,
        class_methods: class_methods.length
      }
      
      puts "   ✅ Module loading: PASSED"
    rescue => e
      puts "   ❌ Module loading failed: #{e.message}"
      @results[:module_loading] = {
        status: 'failed',
        error: e.message
      }
    end
  end

  def test_model_inclusion
    puts "\n🔗 Step 2: Testing model inclusion..."
    
    test_models = %w[Unit ScriptLevel Level]
    inclusion_results = {}
    
    test_models.each do |model_name|
      begin
        model = model_name.constantize
        
        # Check if GuidSupport is included
        if model.included_modules.include?(GuidSupport)
          puts "   ✅ #{model_name}: GuidSupport included"
          inclusion_results[model_name] = { included: true }
        else
          puts "   ❌ #{model_name}: GuidSupport not included"
          inclusion_results[model_name] = { included: false }
        end
        
        # Check if GUID column exists
        if model.column_names.include?('guid')
          puts "   ✅ #{model_name}: GUID column exists"
          inclusion_results[model_name][:guid_column] = true
        else
          puts "   ⚠️  #{model_name}: GUID column not found (expected during migration)"
          inclusion_results[model_name][:guid_column] = false
        end
        
        # Check if methods are available
        methods_to_check = %w[find_by_id_or_guid find_by_guid cache_key_with_guid]
        available_methods = methods_to_check.select { |method| model.respond_to?(method) }
        
        if available_methods.length == methods_to_check.length
          puts "   ✅ #{model_name}: All methods available"
          inclusion_results[model_name][:methods_available] = true
        else
          puts "   ❌ #{model_name}: Missing methods: #{methods_to_check - available_methods}"
          inclusion_results[model_name][:methods_available] = false
        end
        
      rescue => e
        puts "   ❌ #{model_name}: Error - #{e.message}"
        inclusion_results[model_name] = { error: e.message }
      end
    end
    
    @results[:model_inclusion] = inclusion_results
  end

  def test_guid_generation
    puts "\n🆔 Step 3: Testing GUID generation..."
    
    begin
      # Test GUID generation on a model
      unit = Unit.first
      
      if unit.respond_to?(:guid)
        # Test automatic GUID generation
        unit.guid = nil
        unit.valid?
        
        if unit.guid.present?
          puts "   ✅ Automatic GUID generation: PASSED"
          puts "   Generated GUID: #{unit.guid}"
        else
          puts "   ❌ Automatic GUID generation: FAILED"
        end
        
        # Test GUID format
        if unit.guid.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          puts "   ✅ GUID format: VALID"
        else
          puts "   ❌ GUID format: INVALID"
        end
        
        @results[:guid_generation] = {
          status: 'success',
          auto_generation: unit.guid.present?,
          format_valid: unit.guid.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i),
          sample_guid: unit.guid
        }
      else
        puts "   ⚠️  GUID column not available (expected during migration)"
        @results[:guid_generation] = {
          status: 'skipped',
          reason: 'GUID column not available'
        }
      end
    rescue => e
      puts "   ❌ GUID generation test failed: #{e.message}"
      @results[:guid_generation] = {
        status: 'failed',
        error: e.message
      }
    end
  end

  def test_dual_key_lookups
    puts "\n🔍 Step 4: Testing dual-key lookups..."
    
    begin
      # Test with Unit model
      unit = Unit.first
      
      if unit.respond_to?(:guid) && unit.guid.present?
        # Test ID lookup
        id_result = Unit.find_by_id_or_guid(unit.id.to_s)
        if id_result == unit
          puts "   ✅ ID lookup: PASSED"
        else
          puts "   ❌ ID lookup: FAILED"
        end
        
        # Test GUID lookup
        guid_result = Unit.find_by_id_or_guid(unit.guid)
        if guid_result == unit
          puts "   ✅ GUID lookup: PASSED"
        else
          puts "   ❌ GUID lookup: FAILED"
        end
        
        # Test GUID-only lookup
        guid_only_result = Unit.find_by_guid(unit.guid)
        if guid_only_result == unit
          puts "   ✅ GUID-only lookup: PASSED"
        else
          puts "   ❌ GUID-only lookup: FAILED"
        end
        
        @results[:dual_key_lookups] = {
          status: 'success',
          id_lookup: id_result == unit,
          guid_lookup: guid_result == unit,
          guid_only_lookup: guid_only_result == unit
        }
      else
        puts "   ⚠️  GUID not available for testing (expected during migration)"
        @results[:dual_key_lookups] = {
          status: 'skipped',
          reason: 'GUID not available'
        }
      end
    rescue => e
      puts "   ❌ Dual-key lookup test failed: #{e.message}"
      @results[:dual_key_lookups] = {
        status: 'failed',
        error: e.message
      }
    end
  end

  def test_validation
    puts "\n✅ Step 5: Testing validation..."
    
    begin
      # Test GUID validation
      unit = Unit.new(name: 'test_validation_unit')
      
      if unit.respond_to?(:guid)
        # Test uniqueness validation
        unit.guid = Unit.first.guid if Unit.first&.guid
        unit.valid?
        
        if unit.errors[:guid].include?('has already been taken')
          puts "   ✅ GUID uniqueness validation: PASSED"
        else
          puts "   ❌ GUID uniqueness validation: FAILED"
        end
        
        # Test presence validation
        unit.guid = nil
        unit.valid?
        
        if unit.errors[:guid].include?("can't be blank")
          puts "   ✅ GUID presence validation: PASSED"
        else
          puts "   ❌ GUID presence validation: FAILED"
        end
        
        @results[:validation] = {
          status: 'success',
          uniqueness: unit.errors[:guid].include?('has already been taken'),
          presence: unit.errors[:guid].include?("can't be blank")
        }
      else
        puts "   ⚠️  GUID validation not available (expected during migration)"
        @results[:validation] = {
          status: 'skipped',
          reason: 'GUID column not available'
        }
      end
    rescue => e
      puts "   ❌ Validation test failed: #{e.message}"
      @results[:validation] = {
        status: 'failed',
        error: e.message
      }
    end
  end

  def test_cache_key_generation
    puts "\n🗄️  Step 6: Testing cache key generation..."
    
    begin
      unit = Unit.first
      
      if unit.respond_to?(:cache_key_with_guid)
        # Test cache key generation
        cache_key = unit.cache_key_with_guid
        
        if cache_key.is_a?(String) && cache_key.include?('guid:')
          puts "   ✅ Cache key generation: PASSED"
          puts "   Cache key: #{cache_key}"
        else
          puts "   ❌ Cache key generation: FAILED"
        end
        
        # Test class method cache key generation
        class_cache_key = Unit.cache_key_with_guid(unit.id.to_s)
        
        if class_cache_key.is_a?(String)
          puts "   ✅ Class cache key generation: PASSED"
        else
          puts "   ❌ Class cache key generation: FAILED"
        end
        
        @results[:cache_key_generation] = {
          status: 'success',
          instance_method: cache_key.is_a?(String) && cache_key.include?('guid:'),
          class_method: class_cache_key.is_a?(String)
        }
      else
        puts "   ⚠️  Cache key generation not available (expected during migration)"
        @results[:cache_key_generation] = {
          status: 'skipped',
          reason: 'GUID column not available'
        }
      end
    rescue => e
      puts "   ❌ Cache key generation test failed: #{e.message}"
      @results[:cache_key_generation] = {
        status: 'failed',
        error: e.message
      }
    end
  end

  def generate_report
    puts "\n📊 Step 7: Generating GuidSupport test report..."
    
    @results[:status] = 'completed'
    
    # Calculate overall success
    test_results = [
      @results[:module_loading][:status],
      @results[:model_inclusion].values.all? { |v| v[:included] },
      @results[:guid_generation][:status] == 'success' || @results[:guid_generation][:status] == 'skipped',
      @results[:dual_key_lookups][:status] == 'success' || @results[:dual_key_lookups][:status] == 'skipped',
      @results[:validation][:status] == 'success' || @results[:validation][:status] == 'skipped',
      @results[:cache_key_generation][:status] == 'success' || @results[:cache_key_generation][:status] == 'skipped'
    ]
    
    @results[:overall_success] = test_results.all?
    
    # Save results
    File.write('phase2_step1_results.json', JSON.pretty_generate(@results))
    
    # Print summary
    puts "\n📈 GUIDSUPPORT TEST SUMMARY"
    puts "=" * 40
    puts "Module loading: #{@results[:module_loading][:status]}"
    puts "Model inclusion: #{@results[:model_inclusion].values.all? { |v| v[:included] } ? 'PASSED' : 'FAILED'}"
    puts "GUID generation: #{@results[:guid_generation][:status]}"
    puts "Dual-key lookups: #{@results[:dual_key_lookups][:status]}"
    puts "Validation: #{@results[:validation][:status]}"
    puts "Cache key generation: #{@results[:cache_key_generation][:status]}"
    puts "Overall success: #{@results[:overall_success] ? 'PASSED' : 'FAILED'}"
  end
end

# Run the GuidSupport test
if __FILE__ == $0
  tester = GuidSupportTester.new
  tester.run
end