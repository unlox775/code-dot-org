# Seeding Process Replacement Plan - Curriculum GUID Migration

**Created:** 2025-10-16 18:34:36  
**Parent Plan:** [Master Plan](./20251016_183436_curriculum_guid_migration_plan.md)  
**Status:** Planning Phase  

## Overview

This document outlines the replacement of the current complex seeding process with a simple, fast data synchronization system using GUIDs. The new system will eliminate the 30+ minute seeding process and enable direct data synchronization between environments.

## Current Seeding Process Analysis

### Current Seeding Workflow
1. **Production Data Export**: Complex scripts export curriculum data from production
2. **Data Transformation**: ID mapping and data transformation for target environment
3. **Seeding Execution**: 30+ minute seeding process that creates/updates records
4. **Validation**: Verification that all data was seeded correctly
5. **Cleanup**: Removal of outdated or conflicting data

### Current Seeding Scripts
```ruby
# Current seeding process (simplified)
class ScriptSeed
  def self.seed_from_json_file(unit_name)
    filepath = Unit.script_json_filepath(unit_name)
    json_data = JSON.parse(File.read(filepath))
    seed_from_hash(json_data)
  end
  
  def self.seed_from_hash(json_data)
    # Complex ID mapping and record creation/updating
    script_data = json_data['scripts'].first
    script = Unit.find_or_initialize_by(name: script_data['name'])
    script.assign_attributes(script_data.except('id'))
    script.save!
    
    # Process all related objects with ID mapping
    # ... complex seeding logic
  end
end
```

### Current Problems
- **Time Intensive**: 30+ minutes per environment
- **Error Prone**: Complex ID mapping and data transformation
- **Maintenance Heavy**: Requires constant updates for new curriculum features
- **Production Dependent**: Must pull data from production for all environments
- **Inconsistent**: Different environments may have slightly different data

## New Synchronization System

### Synchronization Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Production    │    │   S3 Bucket      │    │   Target Env    │
│   (Source)      │───▶│   (Data Store)   │───▶│   (Destination) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
        │                        │                        │
        │                        │                        │
        ▼                        ▼                        ▼
   Export Data              Store JSON              Import Data
   (5 minutes)             (1 minute)              (5 minutes)
```

### Synchronization Process
1. **Data Export**: Export complete curriculum tables from production
2. **Data Storage**: Store exported data in S3 bucket
3. **Data Import**: Import data directly into target environment
4. **Validation**: Verify data integrity and completeness

## Implementation Plan

### Phase 1: Data Export System

#### 1.1 Export Service
```ruby
# New export service for curriculum data
module Services
  module CurriculumExport
    def self.export_all_curriculum_data
      {
        scripts: export_scripts,
        script_levels: export_script_levels,
        levels: export_levels,
        lesson_groups: export_lesson_groups,
        lessons: export_lessons,
        lesson_activities: export_lesson_activities,
        activity_sections: export_activity_sections,
        unit_groups: export_unit_groups,
        course_versions: export_course_versions,
        course_offerings: export_course_offerings,
        # Include all related data
        levels_script_levels: export_levels_script_levels,
        scripts_resources: export_scripts_resources,
        # ... all other curriculum-related tables
      }
    end
    
    def self.export_scripts
      Script.includes(:lesson_groups, :script_levels, :levels).map do |script|
        script.as_json(include: :all).merge(
          'id' => script.guid,  # Use GUID as primary identifier
          'created_at' => script.created_at.iso8601,
          'updated_at' => script.updated_at.iso8601
        )
      end
    end
    
    def self.export_script_levels
      ScriptLevel.includes(:script, :lesson, :levels).map do |sl|
        sl.as_json(include: :all).merge(
          'id' => sl.guid,
          'script_id' => sl.script.guid,  # Use GUID for foreign keys
          'stage_id' => sl.lesson.guid,
          'created_at' => sl.created_at.iso8601,
          'updated_at' => sl.updated_at.iso8601
        )
      end
    end
    
    # ... similar methods for all curriculum tables
  end
end
```

#### 1.2 Export Command
```ruby
# Rake task for exporting curriculum data
namespace :curriculum do
  desc "Export all curriculum data to S3"
  task export: :environment do
    puts "Starting curriculum data export..."
    
    start_time = Time.current
    export_data = Services::CurriculumExport.export_all_curriculum_data
    
    # Upload to S3
    s3_key = "curriculum-data/#{Date.current.strftime('%Y%m%d')}/curriculum-#{Time.current.strftime('%H%M%S')}.json"
    Services::S3.upload(s3_key, export_data.to_json)
    
    duration = Time.current - start_time
    puts "Export completed in #{duration.round(2)} seconds"
    puts "Data uploaded to S3: #{s3_key}"
  end
end
```

### Phase 2: Data Import System

#### 2.1 Import Service
```ruby
# New import service for curriculum data
module Services
  module CurriculumImport
    def self.import_from_s3(s3_key)
      puts "Starting curriculum data import from S3: #{s3_key}"
      
      start_time = Time.current
      json_data = Services::S3.download(s3_key)
      import_data = JSON.parse(json_data)
      
      # Import in dependency order
      import_course_offerings(import_data['course_offerings'])
      import_unit_groups(import_data['unit_groups'])
      import_course_versions(import_data['course_versions'])
      import_scripts(import_data['scripts'])
      import_levels(import_data['levels'])
      import_lesson_groups(import_data['lesson_groups'])
      import_lessons(import_data['lessons'])
      import_lesson_activities(import_data['lesson_activities'])
      import_activity_sections(import_data['activity_sections'])
      import_script_levels(import_data['script_levels'])
      import_join_tables(import_data)
      
      duration = Time.current - start_time
      puts "Import completed in #{duration.round(2)} seconds"
    end
    
    def self.import_scripts(scripts_data)
      puts "Importing #{scripts_data.length} scripts..."
      
      scripts_data.each do |script_data|
        script = Script.find_or_initialize_by(guid: script_data['id'])
        script.assign_attributes(script_data.except('id', 'created_at', 'updated_at'))
        script.save!
      end
    end
    
    def self.import_script_levels(script_levels_data)
      puts "Importing #{script_levels_data.length} script levels..."
      
      script_levels_data.each do |sl_data|
        script_level = ScriptLevel.find_or_initialize_by(guid: sl_data['id'])
        script_level.assign_attributes(sl_data.except('id', 'created_at', 'updated_at'))
        script_level.save!
      end
    end
    
    # ... similar methods for all curriculum tables
  end
end
```

#### 2.2 Import Command
```ruby
# Rake task for importing curriculum data
namespace :curriculum do
  desc "Import curriculum data from S3"
  task :import, [:s3_key] => :environment do |task, args|
    s3_key = args[:s3_key] || latest_curriculum_data_key
    Services::CurriculumImport.import_from_s3(s3_key)
  end
  
  desc "Import latest curriculum data from S3"
  task import_latest: :environment do
    latest_key = latest_curriculum_data_key
    Services::CurriculumImport.import_from_s3(latest_key)
  end
  
  private
  
  def latest_curriculum_data_key
    # Find the latest curriculum data file in S3
    Services::S3.list_objects('curriculum-data/').max_by { |obj| obj.last_modified }
  end
end
```

### Phase 3: Synchronization Orchestration

#### 3.1 Synchronization Service
```ruby
# Orchestration service for complete synchronization
module Services
  module CurriculumSynchronization
    def self.sync_from_production
      puts "Starting curriculum synchronization from production..."
      
      # Step 1: Export from production
      puts "Step 1: Exporting data from production..."
      export_key = export_production_data
      
      # Step 2: Import to current environment
      puts "Step 2: Importing data to current environment..."
      import_from_s3(export_key)
      
      # Step 3: Validate synchronization
      puts "Step 3: Validating synchronization..."
      validate_synchronization
      
      puts "Curriculum synchronization completed successfully!"
    end
    
    def self.export_production_data
      # This would be called on production environment
      Services::CurriculumExport.export_all_curriculum_data
    end
    
    def self.validate_synchronization
      # Validate that all data was imported correctly
      expected_counts = get_expected_counts
      actual_counts = get_actual_counts
      
      expected_counts.each do |table, expected_count|
        actual_count = actual_counts[table]
        if actual_count != expected_count
          raise "Synchronization validation failed: #{table} expected #{expected_count}, got #{actual_count}"
        end
      end
      
      puts "Synchronization validation passed!"
    end
    
    private
    
    def self.get_expected_counts
      # Get expected record counts from production
      # This would be stored in the export data
    end
    
    def self.get_actual_counts
      {
        scripts: Script.count,
        script_levels: ScriptLevel.count,
        levels: Level.count,
        # ... all curriculum tables
      }
    end
  end
end
```

#### 3.2 Deployment Integration
```ruby
# Integration with deployment process
namespace :deploy do
  desc "Deploy with curriculum synchronization"
  task with_curriculum_sync: :environment do
    puts "Starting deployment with curriculum synchronization..."
    
    # Step 1: Deploy application code
    puts "Step 1: Deploying application code..."
    Rake::Task['deploy:code'].invoke
    
    # Step 2: Run database migrations
    puts "Step 2: Running database migrations..."
    Rake::Task['db:migrate'].invoke
    
    # Step 3: Synchronize curriculum data
    puts "Step 3: Synchronizing curriculum data..."
    Services::CurriculumSynchronization.sync_from_production
    
    # Step 4: Restart application
    puts "Step 4: Restarting application..."
    Rake::Task['deploy:restart'].invoke
    
    puts "Deployment with curriculum synchronization completed!"
  end
end
```

### Phase 4: Level Builder Integration

#### 4.1 Level Builder Export
```ruby
# Update level builder to export GUIDs
class Unit < ApplicationRecord
  def write_script_json
    return unless Rails.application.config.levelbuilder_mode
    
    filepath = Unit.script_json_filepath(name)
    json_data = serialize_seeding_json_with_guids
    File.write(filepath, json_data)
  end
  
  private
  
  def serialize_seeding_json_with_guids
    # Serialize with GUIDs instead of IDs
    {
      scripts: [as_json(include: :all).merge('id' => guid)],
      script_levels: script_levels.map { |sl| sl.as_json.merge('id' => sl.guid) },
      levels: levels.map { |l| l.as_json.merge('id' => l.guid) },
      # ... all related objects with GUIDs
    }.to_json
  end
end
```

#### 4.2 Level Builder Import
```ruby
# Update level builder to import GUIDs
module Services
  module LevelBuilderImport
    def self.import_from_level_files
      puts "Importing curriculum data from level files..."
      
      # Find all .script_json files
      script_files = Dir.glob("#{Unit.unit_json_directory}/*.script_json")
      
      script_files.each do |file_path|
        unit_name = File.basename(file_path, '.script_json')
        import_unit_from_file(unit_name, file_path)
      end
    end
    
    def self.import_unit_from_file(unit_name, file_path)
      json_data = JSON.parse(File.read(file_path))
      
      # Import using GUID-based seeding
      Services::CurriculumImport.import_from_hash(json_data)
    end
  end
end
```

## Performance Improvements

### Current vs New Process
| Metric | Current Seeding | New Synchronization |
|--------|----------------|-------------------|
| **Time** | 30+ minutes | 5-10 minutes |
| **Complexity** | High (ID mapping) | Low (direct import) |
| **Error Rate** | High | Low |
| **Maintenance** | High | Low |
| **Reliability** | Medium | High |

### Optimization Strategies
1. **Bulk Operations**: Use bulk insert/update operations
2. **Parallel Processing**: Import multiple tables in parallel
3. **Incremental Updates**: Only sync changed data
4. **Compression**: Compress data during transfer
5. **Caching**: Cache frequently accessed data

## Validation and Testing

### Data Integrity Validation
```ruby
# Validation service for curriculum data
module Services
  module CurriculumValidation
    def self.validate_data_integrity
      puts "Validating curriculum data integrity..."
      
      # Check foreign key relationships
      validate_foreign_keys
      
      # Check data completeness
      validate_data_completeness
      
      # Check data consistency
      validate_data_consistency
      
      puts "Data integrity validation passed!"
    end
    
    def self.validate_foreign_keys
      # Validate all foreign key relationships
      ScriptLevel.find_each do |sl|
        unless Script.exists?(guid: sl.script_guid)
          raise "ScriptLevel #{sl.guid} references non-existent Script #{sl.script_guid}"
        end
        unless Lesson.exists?(guid: sl.lesson_guid)
          raise "ScriptLevel #{sl.guid} references non-existent Lesson #{sl.lesson_guid}"
        end
      end
    end
    
    def self.validate_data_completeness
      # Ensure all required data is present
      required_tables = %w[scripts script_levels levels lesson_groups lessons]
      required_tables.each do |table|
        count = table.classify.constantize.count
        if count == 0
          raise "Required table #{table} is empty"
        end
      end
    end
    
    def self.validate_data_consistency
      # Check for data consistency issues
      # ... validation logic
    end
  end
end
```

### Testing Strategy
```ruby
# Test suite for synchronization system
RSpec.describe 'Curriculum Synchronization' do
  describe 'export process' do
    it 'exports all curriculum data' do
      export_data = Services::CurriculumExport.export_all_curriculum_data
      
      expect(export_data).to have_key('scripts')
      expect(export_data).to have_key('script_levels')
      expect(export_data).to have_key('levels')
      # ... check all required tables
    end
    
    it 'exports data with GUIDs' do
      script = create(:script, guid: 'test-guid')
      export_data = Services::CurriculumExport.export_scripts
      
      script_data = export_data.find { |s| s['name'] == script.name }
      expect(script_data['id']).to eq('test-guid')
    end
  end
  
  describe 'import process' do
    it 'imports curriculum data correctly' do
      export_data = {
        'scripts' => [build(:script).as_json.merge('id' => 'test-guid')],
        'script_levels' => [],
        'levels' => []
      }
      
      Services::CurriculumImport.import_from_hash(export_data)
      
      expect(Script.find_by(guid: 'test-guid')).to be_present
    end
  end
  
  describe 'synchronization process' do
    it 'completes synchronization successfully' do
      expect { Services::CurriculumSynchronization.sync_from_production }
        .not_to raise_error
    end
  end
end
```

## Rollback Strategy

### Rollback Plan
1. **Restore Seeding Process**: Revert to original seeding system
2. **Data Rollback**: Restore data from backup
3. **Code Rollback**: Revert application code changes
4. **Validation**: Verify system functionality

### Rollback Commands
```ruby
# Rollback commands
namespace :curriculum do
  desc "Rollback to seeding process"
  task rollback_to_seeding: :environment do
    puts "Rolling back to seeding process..."
    
    # Restore original seeding
    Rake::Task['db:seed:scripts'].invoke
    
    puts "Rollback completed!"
  end
end
```

## Timeline

- **Week 1-2**: Export system development
- **Week 3-4**: Import system development
- **Week 5-6**: Synchronization orchestration
- **Week 7-8**: Level builder integration
- **Week 9-10**: Testing and validation
- **Week 11-12**: Performance optimization and deployment

## Dependencies

- Database schema must support GUIDs
- Application code must use GUIDs
- S3 bucket must be configured for data storage
- Level builder must generate GUIDs
- All environments must support new synchronization process