#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 1 Step 2: Test Migration Execution
# This script tests that database migrations can be executed successfully

require 'active_record'
require 'json'
require 'fileutils'

# Load Rails environment
require_relative '../../dashboard/config/environment'

class MigrationExecutionTester
  def initialize
    @results = {
      timestamp: Time.current,
      phase: 'Phase 1',
      step: 'Step 2: Test Migration Execution',
      status: 'running'
    }
    @migration_files = []
    @schema_before = {}
    @schema_after = {}
  end

  def run
    puts "🔧 Phase 1 Step 2: Testing Migration Execution"
    puts "=" * 60

    # Check prerequisites
    unless check_prerequisites
      puts "❌ Prerequisites not met. Exiting."
      exit 1
    end

    # Step 1: Identify migration files
    identify_migration_files

    # Step 2: Capture schema before migration
    capture_schema_before

    # Step 3: Execute migrations
    execute_migrations

    # Step 4: Capture schema after migration
    capture_schema_after

    # Step 5: Verify migration results
    verify_migration_results

    # Step 6: Generate report
    generate_report

    puts "\n✅ Phase 1 Step 2 Complete!"
    puts "📊 Results saved to: phase1_step2_results.json"
  end

  private

  def check_prerequisites
    puts "\n🔍 Checking prerequisites..."
    
    # Check if we're in a safe environment
    unless Rails.env.development? || Rails.env.test?
      puts "❌ Not in a safe environment for running migrations!"
      return false
    end

    # Check if database is accessible
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "   ✅ Database connection: OK"
    rescue => e
      puts "   ❌ Database connection failed: #{e.message}"
      return false
    end

    # Check if migration files exist
    migration_dir = '../../../dashboard/db/migrate'
    unless Dir.exist?(migration_dir)
      puts "   ❌ Migration directory not found: #{migration_dir}"
      return false
    end

    puts "   ✅ Prerequisites: OK"
    true
  end

  def identify_migration_files
    puts "\n📋 Step 1: Identifying migration files..."
    
    migration_dir = '../../../dashboard/db/migrate'
    @migration_files = Dir.glob("#{migration_dir}/*.rb").sort
    
    puts "   Found #{@migration_files.length} migration files"
    
    # Filter for our GUID migration files
    guid_migrations = @migration_files.select do |file|
      File.basename(file).include?('guid') || 
      File.basename(file).include?('curriculum')
    end
    
    puts "   Found #{guid_migrations.length} GUID-related migration files"
    
    @results[:migration_files] = {
      total: @migration_files.length,
      guid_related: guid_migrations.length,
      files: @migration_files.map { |f| File.basename(f) }
    }
  end

  def capture_schema_before
    puts "\n📸 Step 2: Capturing schema before migration..."
    
    @schema_before = {
      tables: ActiveRecord::Base.connection.tables.sort,
      columns: {},
      indexes: {},
      foreign_keys: {}
    }
    
    # Capture column information for each table
    @schema_before[:tables].each do |table|
      begin
        columns = ActiveRecord::Base.connection.columns(table)
        @schema_before[:columns][table] = columns.map do |col|
          {
            name: col.name,
            type: col.type,
            null: col.null,
            default: col.default,
            limit: col.limit
          }
        end
        
        # Capture indexes
        indexes = ActiveRecord::Base.connection.indexes(table)
        @schema_before[:indexes][table] = indexes.map do |idx|
          {
            name: idx.name,
            columns: idx.columns,
            unique: idx.unique
          }
        end
        
        # Capture foreign keys
        foreign_keys = ActiveRecord::Base.connection.foreign_keys(table)
        @schema_before[:foreign_keys][table] = foreign_keys.map do |fk|
          {
            name: fk.name,
            column: fk.column,
            to_table: fk.to_table,
            primary_key: fk.primary_key
          }
        end
      rescue => e
        puts "   Warning: Could not capture schema for table #{table}: #{e.message}"
      end
    end
    
    puts "   Captured schema for #{@schema_before[:tables].length} tables"
  end

  def execute_migrations
    puts "\n🚀 Step 3: Executing migrations..."
    
    # Check current migration status
    current_version = ActiveRecord::Migrator.current_version
    puts "   Current migration version: #{current_version}"
    
    # Run migrations
    begin
      puts "   Running migrations..."
      ActiveRecord::Migrator.migrate('db/migrate')
      
      new_version = ActiveRecord::Migrator.current_version
      puts "   New migration version: #{new_version}"
      
      @results[:migration_execution] = {
        status: 'success',
        previous_version: current_version,
        new_version: new_version,
        error: nil
      }
    rescue => e
      puts "   ❌ Migration failed: #{e.message}"
      @results[:migration_execution] = {
        status: 'failed',
        previous_version: current_version,
        new_version: current_version,
        error: e.message
      }
      return
    end
  end

  def capture_schema_after
    puts "\n📸 Step 4: Capturing schema after migration..."
    
    @schema_after = {
      tables: ActiveRecord::Base.connection.tables.sort,
      columns: {},
      indexes: {},
      foreign_keys: {}
    }
    
    # Capture column information for each table
    @schema_after[:tables].each do |table|
      begin
        columns = ActiveRecord::Base.connection.columns(table)
        @schema_after[:columns][table] = columns.map do |col|
          {
            name: col.name,
            type: col.type,
            null: col.null,
            default: col.default,
            limit: col.limit
          }
        end
        
        # Capture indexes
        indexes = ActiveRecord::Base.connection.indexes(table)
        @schema_after[:indexes][table] = indexes.map do |idx|
          {
            name: idx.name,
            columns: idx.columns,
            unique: idx.unique
          }
        end
        
        # Capture foreign keys
        foreign_keys = ActiveRecord::Base.connection.foreign_keys(table)
        @schema_after[:foreign_keys][table] = foreign_keys.map do |fk|
          {
            name: fk.name,
            column: fk.column,
            to_table: fk.to_table,
            primary_key: fk.primary_key
          }
        end
      rescue => e
        puts "   Warning: Could not capture schema for table #{table}: #{e.message}"
      end
    end
    
    puts "   Captured schema for #{@schema_after[:tables].length} tables"
  end

  def verify_migration_results
    puts "\n🔍 Step 5: Verifying migration results..."
    
    # Compare schemas
    schema_changes = compare_schemas
    
    # Verify GUID columns were added
    guid_columns_added = verify_guid_columns
    
    # Verify foreign key columns were added
    fk_columns_added = verify_foreign_key_columns
    
    # Verify indexes were added
    indexes_added = verify_indexes
    
    @results[:verification] = {
      schema_changes: schema_changes,
      guid_columns_added: guid_columns_added,
      fk_columns_added: fk_columns_added,
      indexes_added: indexes_added,
      success: guid_columns_added && fk_columns_added && indexes_added
    }
  end

  def compare_schemas
    changes = {
      tables_added: @schema_after[:tables] - @schema_before[:tables],
      tables_removed: @schema_before[:tables] - @schema_after[:tables],
      columns_added: {},
      columns_removed: {},
      indexes_added: {},
      indexes_removed: {},
      foreign_keys_added: {},
      foreign_keys_removed: {}
    }
    
    # Compare columns
    @schema_after[:tables].each do |table|
      if @schema_before[:tables].include?(table)
        before_cols = @schema_before[:columns][table] || []
        after_cols = @schema_after[:columns][table] || []
        
        before_names = before_cols.map { |c| c[:name] }
        after_names = after_cols.map { |c| c[:name] }
        
        changes[:columns_added][table] = after_names - before_names
        changes[:columns_removed][table] = before_names - after_names
      end
    end
    
    # Compare indexes
    @schema_after[:tables].each do |table|
      if @schema_before[:tables].include?(table)
        before_idxs = @schema_before[:indexes][table] || []
        after_idxs = @schema_after[:indexes][table] || []
        
        before_names = before_idxs.map { |i| i[:name] }
        after_names = after_idxs.map { |i| i[:name] }
        
        changes[:indexes_added][table] = after_names - before_names
        changes[:indexes_removed][table] = before_names - after_names
      end
    end
    
    changes
  end

  def verify_guid_columns
    puts "   Verifying GUID columns were added..."
    
    expected_guid_tables = %w[
      scripts levels stages lesson_groups courses unit_groups
      course_offerings activities script_levels
    ]
    
    guid_columns_found = {}
    
    expected_guid_tables.each do |table|
      if @schema_after[:tables].include?(table)
        columns = @schema_after[:columns][table] || []
        guid_column = columns.find { |c| c[:name] == 'guid' }
        
        if guid_column
          guid_columns_found[table] = {
            found: true,
            type: guid_column[:type],
            null: guid_column[:null],
            default: guid_column[:default]
          }
          puts "     ✅ #{table}: GUID column found"
        else
          guid_columns_found[table] = { found: false }
          puts "     ❌ #{table}: GUID column not found"
        end
      else
        guid_columns_found[table] = { found: false, error: 'Table not found' }
        puts "     ⚠️  #{table}: Table not found"
      end
    end
    
    all_found = guid_columns_found.values.all? { |v| v[:found] }
    puts "   GUID columns verification: #{all_found ? 'PASSED' : 'FAILED'}"
    
    guid_columns_found
  end

  def verify_foreign_key_columns
    puts "   Verifying foreign key columns were added..."
    
    expected_fk_tables = %w[
      user_levels user_scripts user_lessons user_courses
      script_levels lesson_activities course_scripts
    ]
    
    fk_columns_found = {}
    
    expected_fk_tables.each do |table|
      if @schema_after[:tables].include?(table)
        columns = @schema_after[:columns][table] || []
        fk_columns = columns.select { |c| c[:name].end_with?('_guid') }
        
        if fk_columns.any?
          fk_columns_found[table] = {
            found: true,
            columns: fk_columns.map { |c| c[:name] }
          }
          puts "     ✅ #{table}: #{fk_columns.length} GUID FK columns found"
        else
          fk_columns_found[table] = { found: false }
          puts "     ❌ #{table}: No GUID FK columns found"
        end
      else
        fk_columns_found[table] = { found: false, error: 'Table not found' }
        puts "     ⚠️  #{table}: Table not found"
      end
    end
    
    all_found = fk_columns_found.values.all? { |v| v[:found] }
    puts "   Foreign key columns verification: #{all_found ? 'PASSED' : 'FAILED'}"
    
    fk_columns_found
  end

  def verify_indexes
    puts "   Verifying indexes were added..."
    
    expected_indexes = %w[
      idx_scripts_guid idx_levels_guid idx_stages_guid
      idx_user_levels_level_guid idx_user_scripts_script_guid
    ]
    
    indexes_found = {}
    
    expected_indexes.each do |index_name|
      found_in_tables = []
      
      @schema_after[:tables].each do |table|
        indexes = @schema_after[:indexes][table] || []
        if indexes.any? { |idx| idx[:name] == index_name }
          found_in_tables << table
        end
      end
      
      if found_in_tables.any?
        indexes_found[index_name] = { found: true, tables: found_in_tables }
        puts "     ✅ #{index_name}: Found in #{found_in_tables.join(', ')}"
      else
        indexes_found[index_name] = { found: false }
        puts "     ❌ #{index_name}: Not found"
      end
    end
    
    all_found = indexes_found.values.all? { |v| v[:found] }
    puts "   Indexes verification: #{all_found ? 'PASSED' : 'FAILED'}"
    
    indexes_found
  end

  def generate_report
    puts "\n📊 Step 6: Generating migration execution report..."
    
    @results[:status] = 'completed'
    @results[:schema_before] = @schema_before
    @results[:schema_after] = @schema_after
    
    # Save results
    File.write('phase1_step2_results.json', JSON.pretty_generate(@results))
    
    # Print summary
    puts "\n📈 MIGRATION EXECUTION SUMMARY"
    puts "=" * 40
    puts "Migration status: #{@results[:migration_execution][:status]}"
    puts "GUID columns added: #{@results[:verification][:guid_columns_added].values.count { |v| v[:found] }}"
    puts "FK columns added: #{@results[:verification][:fk_columns_added].values.count { |v| v[:found] }}"
    puts "Indexes added: #{@results[:verification][:indexes_added].values.count { |v| v[:found] }}"
    puts "Overall success: #{@results[:verification][:success] ? 'PASSED' : 'FAILED'}"
    
    if @results[:migration_execution][:error]
      puts "\n❌ ERROR: #{@results[:migration_execution][:error]}"
    end
  end
end

# Run the migration execution test
if __FILE__ == $0
  tester = MigrationExecutionTester.new
  tester.run
end