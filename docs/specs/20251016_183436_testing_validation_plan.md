# Testing and Validation Plan - Curriculum GUID Migration

**Created:** 2025-10-16 18:34:36  
**Parent Plan:** [Master Plan](./20251016_183436_curriculum_guid_migration_plan.md)  
**Status:** Planning Phase  

## Overview

This document outlines the comprehensive testing and validation strategy for the curriculum GUID migration. The testing approach ensures data integrity, system functionality, and performance are maintained throughout the migration process.

## Testing Strategy Overview

### Testing Phases
1. **Unit Testing**: Individual component testing
2. **Integration Testing**: Component interaction testing
3. **System Testing**: End-to-end functionality testing
4. **Performance Testing**: Load and performance validation
5. **User Acceptance Testing**: Curriculum team validation
6. **Production Testing**: Live environment validation

### Testing Environments
- **Development**: Initial development and unit testing
- **Staging**: Integration and system testing
- **Production-like**: Performance and load testing
- **Production**: Final validation and rollback testing

## Phase 1: Unit Testing

### 1.1 Model Testing

#### GUID Generation Tests
```ruby
# Test GUID generation for all curriculum models
RSpec.describe 'Curriculum GUID Generation' do
  describe Unit do
    it 'generates GUID on creation' do
      unit = Unit.create!(name: 'test-unit', title: 'Test Unit')
      expect(unit.guid).to be_present
      expect(unit.guid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
    end
    
    it 'does not change existing GUID on update' do
      unit = Unit.create!(name: 'test-unit', title: 'Test Unit')
      original_guid = unit.guid
      
      unit.update!(title: 'Updated Title')
      expect(unit.guid).to eq(original_guid)
    end
    
    it 'generates unique GUIDs' do
      guids = 100.times.map { Unit.create!(name: "unit-#{rand(10000)}", title: 'Test').guid }
      expect(guids.uniq.length).to eq(100)
    end
  end
  
  describe ScriptLevel do
    it 'generates GUID on creation' do
      unit = create(:unit)
      lesson = create(:lesson, script: unit)
      script_level = ScriptLevel.create!(script: unit, lesson: lesson)
      
      expect(script_level.guid).to be_present
    end
  end
  
  describe Level do
    it 'generates GUID on creation' do
      level = Level.create!(name: 'test-level', type: 'Maze')
      expect(level.guid).to be_present
    end
  end
end
```

#### Association Testing
```ruby
# Test GUID-based associations
RSpec.describe 'Curriculum GUID Associations' do
  describe Unit do
    it 'loads script_levels via GUID' do
      unit = create(:unit, guid: 'unit-guid')
      script_level = create(:script_level, script_guid: 'unit-guid')
      
      expect(unit.script_levels).to include(script_level)
    end
    
    it 'loads lessons via GUID' do
      unit = create(:unit, guid: 'unit-guid')
      lesson = create(:lesson, script_guid: 'unit-guid')
      
      expect(unit.lessons).to include(lesson)
    end
  end
  
  describe ScriptLevel do
    it 'loads script via GUID' do
      unit = create(:unit, guid: 'unit-guid')
      script_level = create(:script_level, script_guid: 'unit-guid')
      
      expect(script_level.script).to eq(unit)
    end
    
    it 'loads lesson via GUID' do
      lesson = create(:lesson, guid: 'lesson-guid')
      script_level = create(:script_level, lesson_guid: 'lesson-guid')
      
      expect(script_level.lesson).to eq(lesson)
    end
  end
end
```

#### Lookup Method Testing
```ruby
# Test GUID-based lookup methods
RSpec.describe 'Curriculum GUID Lookups' do
  describe Unit do
    it 'finds by GUID' do
      unit = create(:unit, guid: 'test-guid')
      expect(Unit.find_by_identifier('test-guid')).to eq(unit)
    end
    
    it 'finds by name when GUID not found' do
      unit = create(:unit, name: 'test-unit')
      expect(Unit.find_by_identifier('test-unit')).to eq(unit)
    end
    
    it 'raises error for non-existent identifier' do
      expect { Unit.find_by_identifier('non-existent') }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe Level do
    it 'finds by GUID' do
      level = create(:level, guid: 'test-guid')
      expect(Level.find_by_key('test-guid')).to eq(level)
    end
    
    it 'finds by name when GUID not found' do
      level = create(:level, name: 'test-level')
      expect(Level.find_by_key('test-level')).to eq(level)
    end
  end
end
```

### 1.2 Service Testing

#### Export Service Testing
```ruby
# Test curriculum export service
RSpec.describe 'CurriculumExport' do
  describe '.export_all_curriculum_data' do
    it 'exports all curriculum tables' do
      create(:unit, guid: 'unit-guid')
      create(:level, guid: 'level-guid')
      
      export_data = Services::CurriculumExport.export_all_curriculum_data
      
      expect(export_data).to have_key('scripts')
      expect(export_data).to have_key('levels')
      expect(export_data['scripts']).to be_an(Array)
      expect(export_data['levels']).to be_an(Array)
    end
    
    it 'exports data with GUIDs' do
      unit = create(:unit, guid: 'unit-guid')
      export_data = Services::CurriculumExport.export_scripts
      
      script_data = export_data.find { |s| s['name'] == unit.name }
      expect(script_data['id']).to eq('unit-guid')
    end
    
    it 'exports foreign keys as GUIDs' do
      unit = create(:unit, guid: 'unit-guid')
      lesson = create(:lesson, script: unit, guid: 'lesson-guid')
      script_level = create(:script_level, script: unit, lesson: lesson, guid: 'sl-guid')
      
      export_data = Services::CurriculumExport.export_script_levels
      sl_data = export_data.find { |sl| sl['id'] == 'sl-guid' }
      
      expect(sl_data['script_id']).to eq('unit-guid')
      expect(sl_data['stage_id']).to eq('lesson-guid')
    end
  end
end
```

#### Import Service Testing
```ruby
# Test curriculum import service
RSpec.describe 'CurriculumImport' do
  describe '.import_from_hash' do
    it 'imports curriculum data correctly' do
      import_data = {
        'scripts' => [build(:unit).as_json.merge('id' => 'test-guid')],
        'script_levels' => [],
        'levels' => []
      }
      
      Services::CurriculumImport.import_from_hash(import_data)
      
      expect(Unit.find_by(guid: 'test-guid')).to be_present
    end
    
    it 'maintains foreign key relationships' do
      import_data = {
        'scripts' => [build(:unit).as_json.merge('id' => 'unit-guid')],
        'lessons' => [build(:lesson).as_json.merge('id' => 'lesson-guid', 'script_id' => 'unit-guid')],
        'script_levels' => [build(:script_level).as_json.merge('id' => 'sl-guid', 'script_id' => 'unit-guid', 'stage_id' => 'lesson-guid')],
        'levels' => []
      }
      
      Services::CurriculumImport.import_from_hash(import_data)
      
      unit = Unit.find_by(guid: 'unit-guid')
      lesson = Lesson.find_by(guid: 'lesson-guid')
      script_level = ScriptLevel.find_by(guid: 'sl-guid')
      
      expect(script_level.script).to eq(unit)
      expect(script_level.lesson).to eq(lesson)
    end
  end
end
```

## Phase 2: Integration Testing

### 2.1 End-to-End Workflow Testing

#### Curriculum Creation Workflow
```ruby
# Test complete curriculum creation workflow
RSpec.describe 'Curriculum Creation Workflow' do
  it 'creates complete curriculum with GUIDs' do
    # Create unit
    unit = Unit.create!(name: 'test-unit', title: 'Test Unit')
    expect(unit.guid).to be_present
    
    # Create lesson group
    lesson_group = LessonGroup.create!(script: unit, key: 'test-group', display_name: 'Test Group')
    expect(lesson_group.guid).to be_present
    
    # Create lesson
    lesson = Lesson.create!(script: unit, lesson_group: lesson_group, name: 'test-lesson')
    expect(lesson.guid).to be_present
    
    # Create level
    level = Level.create!(name: 'test-level', type: 'Maze')
    expect(level.guid).to be_present
    
    # Create script level
    script_level = ScriptLevel.create!(script: unit, lesson: lesson, levels: [level])
    expect(script_level.guid).to be_present
    
    # Verify relationships
    expect(unit.script_levels).to include(script_level)
    expect(unit.lessons).to include(lesson)
    expect(script_level.levels).to include(level)
  end
end
```

#### Seeding Workflow Testing
```ruby
# Test seeding workflow with GUIDs
RSpec.describe 'Seeding Workflow' do
  it 'seeds curriculum from JSON files' do
    # Create curriculum in level builder
    unit = create(:unit, guid: 'unit-guid')
    level = create(:level, guid: 'level-guid')
    script_level = create(:script_level, script: unit, levels: [level], guid: 'sl-guid')
    
    # Export to JSON
    unit.write_script_json
    
    # Clear database
    Unit.destroy_all
    Level.destroy_all
    ScriptLevel.destroy_all
    
    # Seed from JSON
    Services::CurriculumSeeding.seed_from_json_files
    
    # Verify data was seeded correctly
    seeded_unit = Unit.find_by(guid: 'unit-guid')
    seeded_level = Level.find_by(guid: 'level-guid')
    seeded_script_level = ScriptLevel.find_by(guid: 'sl-guid')
    
    expect(seeded_unit).to be_present
    expect(seeded_level).to be_present
    expect(seeded_script_level).to be_present
    expect(seeded_script_level.script).to eq(seeded_unit)
    expect(seeded_script_level.levels).to include(seeded_level)
  end
end
```

### 2.2 Data Integrity Testing

#### Foreign Key Integrity
```ruby
# Test foreign key integrity with GUIDs
RSpec.describe 'Foreign Key Integrity' do
  it 'maintains referential integrity' do
    unit = create(:unit, guid: 'unit-guid')
    lesson = create(:lesson, script: unit, guid: 'lesson-guid')
    script_level = create(:script_level, script: unit, lesson: lesson, guid: 'sl-guid')
    
    # Verify all foreign keys are valid
    expect(script_level.script.guid).to eq('unit-guid')
    expect(script_level.lesson.guid).to eq('lesson-guid')
    expect(unit.script_levels).to include(script_level)
    expect(unit.lessons).to include(lesson)
  end
  
  it 'prevents orphaned records' do
    unit = create(:unit, guid: 'unit-guid')
    script_level = create(:script_level, script: unit, guid: 'sl-guid')
    
    # Delete unit
    unit.destroy
    
    # Verify script level is also deleted (if cascade is configured)
    expect(ScriptLevel.find_by(guid: 'sl-guid')).to be_nil
  end
end
```

#### Data Consistency Testing
```ruby
# Test data consistency across operations
RSpec.describe 'Data Consistency' do
  it 'maintains consistency during updates' do
    unit = create(:unit, guid: 'unit-guid')
    script_level = create(:script_level, script: unit, guid: 'sl-guid')
    
    # Update unit
    unit.update!(title: 'Updated Title')
    
    # Verify script level still references correct unit
    script_level.reload
    expect(script_level.script).to eq(unit)
    expect(script_level.script.title).to eq('Updated Title')
  end
  
  it 'maintains consistency during deletions' do
    unit = create(:unit, guid: 'unit-guid')
    script_level = create(:script_level, script: unit, guid: 'sl-guid')
    
    # Delete script level
    script_level.destroy
    
    # Verify unit no longer has the script level
    unit.reload
    expect(unit.script_levels).not_to include(script_level)
  end
end
```

## Phase 3: System Testing

### 3.1 Performance Testing

#### Load Testing
```ruby
# Test performance with large datasets
RSpec.describe 'Performance Testing' do
  it 'handles large curriculum datasets' do
    # Create large dataset
    units = 100.times.map { create(:unit) }
    levels = 1000.times.map { create(:level) }
    
    # Test lookup performance
    start_time = Time.current
    units.each { |unit| Unit.find_by_identifier(unit.guid) }
    lookup_time = Time.current - start_time
    
    expect(lookup_time).to be < 5.seconds
  end
  
  it 'handles concurrent access' do
    unit = create(:unit, guid: 'unit-guid')
    
    # Simulate concurrent access
    threads = 10.times.map do
      Thread.new do
        100.times { Unit.find_by_identifier('unit-guid') }
      end
    end
    
    threads.each(&:join)
    
    # Verify no errors occurred
    expect(unit.reload).to be_present
  end
end
```

#### Memory Testing
```ruby
# Test memory usage with GUIDs
RSpec.describe 'Memory Usage' do
  it 'does not significantly increase memory usage' do
    # Measure memory before
    memory_before = `ps -o rss= -p #{Process.pid}`.to_i
    
    # Create large dataset
    1000.times { create(:unit) }
    
    # Measure memory after
    memory_after = `ps -o rss= -p #{Process.pid}`.to_i
    memory_increase = memory_after - memory_before
    
    # Memory increase should be reasonable (less than 100MB)
    expect(memory_increase).to be < 100_000
  end
end
```

### 3.2 Caching Testing

#### Cache Performance
```ruby
# Test caching with GUIDs
RSpec.describe 'Cache Performance' do
  it 'caches GUID lookups efficiently' do
    unit = create(:unit, guid: 'unit-guid')
    
    # First lookup (cache miss)
    start_time = Time.current
    Unit.find_by_identifier('unit-guid')
    first_lookup_time = Time.current - start_time
    
    # Second lookup (cache hit)
    start_time = Time.current
    Unit.find_by_identifier('unit-guid')
    second_lookup_time = Time.current - start_time
    
    # Cache hit should be faster
    expect(second_lookup_time).to be < first_lookup_time
  end
  
  it 'invalidates cache on updates' do
    unit = create(:unit, guid: 'unit-guid')
    
    # Cache the unit
    Unit.find_by_identifier('unit-guid')
    
    # Update the unit
    unit.update!(title: 'Updated Title')
    
    # Verify cache is invalidated
    cached_unit = Unit.find_by_identifier('unit-guid')
    expect(cached_unit.title).to eq('Updated Title')
  end
end
```

## Phase 4: User Acceptance Testing

### 4.1 Curriculum Team Testing

#### Level Builder Testing
```ruby
# Test level builder functionality
RSpec.describe 'Level Builder UAT' do
  it 'allows curriculum team to create units' do
    # Simulate level builder workflow
    visit '/units/new'
    
    fill_in 'Name', with: 'test-unit'
    fill_in 'Title', with: 'Test Unit'
    click_button 'Create Unit'
    
    unit = Unit.find_by(name: 'test-unit')
    expect(unit).to be_present
    expect(unit.guid).to be_present
  end
  
  it 'allows curriculum team to edit units' do
    unit = create(:unit, guid: 'unit-guid')
    
    visit "/units/#{unit.guid}/edit"
    
    fill_in 'Title', with: 'Updated Title'
    click_button 'Update Unit'
    
    unit.reload
    expect(unit.title).to eq('Updated Title')
  end
  
  it 'allows curriculum team to create levels' do
    visit '/levels/new'
    
    fill_in 'Name', with: 'test-level'
    select 'Maze', from: 'Type'
    click_button 'Create Level'
    
    level = Level.find_by(name: 'test-level')
    expect(level).to be_present
    expect(level.guid).to be_present
  end
end
```

#### File Generation Testing
```ruby
# Test file generation in level builder
RSpec.describe 'File Generation UAT' do
  it 'generates JSON files with GUIDs' do
    unit = create(:unit, guid: 'unit-guid')
    unit.write_script_json
    
    file_path = Unit.script_json_filepath(unit.name)
    file_data = JSON.parse(File.read(file_path))
    
    expect(file_data['scripts'].first['id']).to eq('unit-guid')
  end
  
  it 'generates level files with GUIDs' do
    level = create(:level, guid: 'level-guid')
    Services::LevelFiles.write_custom_level_file(level)
    
    file_path = "#{Rails.root}/config/levels/#{level.name}.level"
    file_data = JSON.parse(File.read(file_path))
    
    expect(file_data['id']).to eq('level-guid')
  end
end
```

### 4.2 End User Testing

#### Student Experience Testing
```ruby
# Test student experience with GUIDs
RSpec.describe 'Student Experience UAT' do
  it 'allows students to access units' do
    unit = create(:unit, guid: 'unit-guid')
    
    visit "/s/#{unit.guid}"
    
    expect(page).to have_content(unit.title)
  end
  
  it 'allows students to access levels' do
    unit = create(:unit, guid: 'unit-guid')
    level = create(:level, guid: 'level-guid')
    script_level = create(:script_level, script: unit, levels: [level], guid: 'sl-guid')
    
    visit "/s/#{unit.guid}/lessons/1/levels/1"
    
    expect(page).to have_content(level.name)
  end
end
```

#### Teacher Experience Testing
```ruby
# Test teacher experience with GUIDs
RSpec.describe 'Teacher Experience UAT' do
  it 'allows teachers to assign units' do
    unit = create(:unit, guid: 'unit-guid')
    teacher = create(:teacher)
    
    visit "/teacher-dashboard"
    
    # Assign unit to class
    click_button "Assign #{unit.title}"
    
    expect(teacher.assigned_units).to include(unit)
  end
  
  it 'allows teachers to view student progress' do
    unit = create(:unit, guid: 'unit-guid')
    student = create(:student)
    user_level = create(:user_level, user: student, script: unit)
    
    visit "/teacher-dashboard/students/#{student.id}"
    
    expect(page).to have_content(unit.title)
  end
end
```

## Phase 5: Production Testing

### 5.1 Migration Testing

#### Data Migration Testing
```ruby
# Test data migration in production-like environment
RSpec.describe 'Production Migration Testing' do
  it 'migrates existing data to GUIDs' do
    # Create test data with IDs
    unit = Unit.create!(name: 'test-unit', title: 'Test Unit')
    level = Level.create!(name: 'test-level', type: 'Maze')
    script_level = ScriptLevel.create!(script: unit, levels: [level])
    
    # Run migration
    Rake::Task['curriculum:migrate_to_guids'].invoke
    
    # Verify GUIDs were generated
    unit.reload
    level.reload
    script_level.reload
    
    expect(unit.guid).to be_present
    expect(level.guid).to be_present
    expect(script_level.guid).to be_present
  end
  
  it 'maintains data integrity during migration' do
    # Create test data
    unit = create(:unit)
    level = create(:level)
    script_level = create(:script_level, script: unit, levels: [level])
    
    # Run migration
    Rake::Task['curriculum:migrate_to_guids'].invoke
    
    # Verify relationships are maintained
    script_level.reload
    expect(script_level.script).to eq(unit)
    expect(script_level.levels).to include(level)
  end
end
```

#### Rollback Testing
```ruby
# Test rollback functionality
RSpec.describe 'Rollback Testing' do
  it 'rolls back to ID-based system' do
    # Migrate to GUIDs
    Rake::Task['curriculum:migrate_to_guids'].invoke
    
    # Verify GUIDs exist
    unit = Unit.first
    expect(unit.guid).to be_present
    
    # Rollback to IDs
    Rake::Task['curriculum:rollback_to_ids'].invoke
    
    # Verify system works with IDs
    unit = Unit.first
    expect(Unit.find(unit.id)).to eq(unit)
  end
end
```

### 5.2 Synchronization Testing

#### Cross-Environment Testing
```ruby
# Test synchronization between environments
RSpec.describe 'Cross-Environment Synchronization' do
  it 'synchronizes data between environments' do
    # Create data in source environment
    unit = create(:unit, guid: 'unit-guid')
    level = create(:level, guid: 'level-guid')
    script_level = create(:script_level, script: unit, levels: [level], guid: 'sl-guid')
    
    # Export data
    export_data = Services::CurriculumExport.export_all_curriculum_data
    
    # Clear target environment
    Unit.destroy_all
    Level.destroy_all
    ScriptLevel.destroy_all
    
    # Import data
    Services::CurriculumImport.import_from_hash(export_data)
    
    # Verify data was synchronized
    expect(Unit.find_by(guid: 'unit-guid')).to be_present
    expect(Level.find_by(guid: 'level-guid')).to be_present
    expect(ScriptLevel.find_by(guid: 'sl-guid')).to be_present
  end
end
```

## Test Data Management

### Test Data Generation
```ruby
# Factory for generating test data
FactoryBot.define do
  factory :unit do
    sequence(:name) { |n| "unit-#{n}" }
    title { "Unit #{name}" }
    guid { SecureRandom.uuid }
  end
  
  factory :level do
    sequence(:name) { |n| "level-#{n}" }
    type { 'Maze' }
    guid { SecureRandom.uuid }
  end
  
  factory :script_level do
    association :script, factory: :unit
    association :lesson, factory: :lesson
    guid { SecureRandom.uuid }
  end
end
```

### Test Data Cleanup
```ruby
# Cleanup after tests
RSpec.configure do |config|
  config.before(:each) do
    # Clean up test data
    Unit.destroy_all
    Level.destroy_all
    ScriptLevel.destroy_all
  end
  
  config.after(:each) do
    # Additional cleanup if needed
  end
end
```

## Test Automation

### Continuous Integration
```yaml
# GitHub Actions workflow for testing
name: Curriculum GUID Migration Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.0
    
    - name: Install dependencies
      run: bundle install
    
    - name: Set up database
      run: |
        bundle exec rails db:create
        bundle exec rails db:migrate
    
    - name: Run tests
      run: bundle exec rspec
    
    - name: Run performance tests
      run: bundle exec rspec spec/performance/
    
    - name: Run integration tests
      run: bundle exec rspec spec/integration/
```

### Test Reporting
```ruby
# Test reporting configuration
RSpec.configure do |config|
  config.add_formatter :documentation
  config.add_formatter :json, :file => 'test-results.json'
  config.add_formatter :junit, :file => 'test-results.xml'
end
```

## Success Criteria

### Functional Requirements
1. **GUID Generation**: All curriculum objects have unique GUIDs
2. **Data Integrity**: All foreign key relationships maintained
3. **Lookup Functionality**: All lookup methods work with GUIDs
4. **Seeding Process**: Seeding works with GUID-based data
5. **Level Builder**: Level builder generates and uses GUIDs

### Performance Requirements
1. **Lookup Performance**: GUID lookups are as fast as ID lookups
2. **Memory Usage**: No significant increase in memory usage
3. **Cache Performance**: Caching works efficiently with GUIDs
4. **Migration Time**: Migration completes within acceptable time

### Quality Requirements
1. **Test Coverage**: 100% test coverage for new code
2. **Code Quality**: All code passes linting and style checks
3. **Documentation**: All new code is properly documented
4. **Error Handling**: Proper error handling for all edge cases

## Timeline

- **Week 1-2**: Unit testing development
- **Week 3-4**: Integration testing development
- **Week 5-6**: System testing development
- **Week 7-8**: User acceptance testing
- **Week 9-10**: Production testing
- **Week 11-12**: Test automation and reporting

## Dependencies

- Database schema must support GUIDs
- Application code must use GUIDs
- Seeding process must handle GUIDs
- Level builder must generate GUIDs
- All test environments must be configured
- Test data must be properly managed