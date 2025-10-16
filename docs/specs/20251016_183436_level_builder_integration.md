# Level Builder Integration Plan - Curriculum GUID Migration

**Created:** 2025-10-16 18:34:36  
**Parent Plan:** [Master Plan](./20251016_183436_curriculum_guid_migration_plan.md)  
**Status:** Planning Phase  

## Overview

This document outlines the integration of the level builder system with the GUID-based curriculum migration. The level builder is where curriculum teams create and edit curriculum content, and it must continue to work seamlessly with the new GUID-based system.

## Current Level Builder Analysis

### Current Level Builder Workflow
1. **Content Creation**: Curriculum team creates units, lessons, and levels
2. **Database Updates**: Changes are saved to the database
3. **File Generation**: Level files are generated in `dashboard/config/` directories
4. **Seeding Process**: Files are used for seeding other environments
5. **Validation**: Content is validated and tested

### Current Level Builder Components
```ruby
# Current level builder models
class Unit < ApplicationRecord
  def write_script_json
    return unless Rails.application.config.levelbuilder_mode
    
    filepath = Unit.script_json_filepath(name)
    File.write(filepath, Services::ScriptSeed.serialize_seeding_json(self))
  end
end

class Level < ApplicationRecord
  after_save { Services::LevelFiles.write_custom_level_file(self) }
  after_destroy { Services::LevelFiles.delete_custom_level_file(self) }
end
```

### Current File Structure
```
dashboard/config/
├── scripts/           # Unit definitions
├── scripts_json/      # JSON serializations
├── levels/           # Level definitions
├── courses/          # Course definitions
└── course_offerings/ # Course offering definitions
```

## Integration Strategy

### Phase 1: GUID Generation in Level Builder

#### 1.1 Update Level Builder Models
```ruby
# Update Unit model for level builder
class Unit < ApplicationRecord
  before_create :generate_guid, if: -> { Rails.application.config.levelbuilder_mode }
  before_save :ensure_guid, if: -> { Rails.application.config.levelbuilder_mode }
  
  def write_script_json
    return unless Rails.application.config.levelbuilder_mode
    
    filepath = Unit.script_json_filepath(name)
    json_data = serialize_seeding_json_with_guids
    File.write(filepath, json_data)
  end
  
  private
  
  def generate_guid
    self.guid = SecureRandom.uuid if guid.blank?
  end
  
  def ensure_guid
    generate_guid if guid.blank?
  end
  
  def serialize_seeding_json_with_guids
    # Serialize with GUIDs for seeding
    {
      scripts: [as_json(include: :all).merge('id' => guid)],
      script_levels: script_levels.map { |sl| sl.as_json.merge('id' => sl.guid) },
      levels: levels.map { |l| l.as_json.merge('id' => l.guid) },
      lesson_groups: lesson_groups.map { |lg| lg.as_json.merge('id' => lg.guid) },
      lessons: lessons.map { |l| l.as_json.merge('id' => l.guid) },
      # ... all related objects with GUIDs
    }.to_json
  end
end

# Update ScriptLevel model for level builder
class ScriptLevel < ApplicationRecord
  before_create :generate_guid, if: -> { Rails.application.config.levelbuilder_mode }
  before_save :ensure_guid, if: -> { Rails.application.config.levelbuilder_mode }
  
  private
  
  def generate_guid
    self.guid = SecureRandom.uuid if guid.blank?
  end
  
  def ensure_guid
    generate_guid if guid.blank?
  end
end

# Update Level model for level builder
class Level < ApplicationRecord
  before_create :generate_guid, if: -> { Rails.application.config.levelbuilder_mode }
  before_save :ensure_guid, if: -> { Rails.application.config.levelbuilder_mode }
  
  private
  
  def generate_guid
    self.guid = SecureRandom.uuid if guid.blank?
  end
  
  def ensure_guid
    generate_guid if guid.blank?
  end
end
```

#### 1.2 Update Level Builder Controllers
```ruby
# Update UnitsController for level builder
class UnitsController < ApplicationController
  def create
    @script = Unit.new(unit_params)
    
    # Generate GUID for new units
    @script.guid = SecureRandom.uuid if @script.guid.blank?
    
    if @script.save
      # Write JSON file with GUID
      @script.write_script_json if Rails.application.config.levelbuilder_mode
      redirect_to @script
    else
      render :new
    end
  end
  
  def update
    if @script.update(unit_params)
      # Update JSON file with GUID
      @script.write_script_json if Rails.application.config.levelbuilder_mode
      redirect_to @script
    else
      render :edit
    end
  end
  
  private
  
  def unit_params
    params.require(:unit).permit(:name, :title, :description, :guid, ...)
  end
end

# Update ScriptLevelsController for level builder
class ScriptLevelsController < ApplicationController
  def create
    @script_level = ScriptLevel.new(script_level_params)
    
    # Generate GUID for new script levels
    @script_level.guid = SecureRandom.uuid if @script_level.guid.blank?
    
    if @script_level.save
      # Update parent unit JSON file
      @script_level.script.write_script_json if Rails.application.config.levelbuilder_mode
      redirect_to @script_level
    else
      render :new
    end
  end
  
  def update
    if @script_level.update(script_level_params)
      # Update parent unit JSON file
      @script_level.script.write_script_json if Rails.application.config.levelbuilder_mode
      redirect_to @script_level
    else
      render :edit
    end
  end
  
  private
  
  def script_level_params
    params.require(:script_level).permit(:script_id, :lesson_id, :position, :guid, ...)
  end
end
```

### Phase 2: File Format Updates

#### 2.1 Update JSON File Format
```ruby
# Update ScriptSeed service for level builder
module Services
  module ScriptSeed
    def self.serialize_seeding_json(script)
      # Include GUIDs in serialized JSON
      {
        scripts: [serialize_script_with_guids(script)],
        script_levels: serialize_script_levels_with_guids(script),
        levels: serialize_levels_with_guids(script),
        lesson_groups: serialize_lesson_groups_with_guids(script),
        lessons: serialize_lessons_with_guids(script),
        # ... all related objects with GUIDs
      }.to_json
    end
    
    private
    
    def self.serialize_script_with_guids(script)
      script.as_json(include: :all).merge(
        'id' => script.guid,
        'created_at' => script.created_at.iso8601,
        'updated_at' => script.updated_at.iso8601
      )
    end
    
    def self.serialize_script_levels_with_guids(script)
      script.script_levels.map do |sl|
        sl.as_json.merge(
          'id' => sl.guid,
          'script_id' => sl.script.guid,
          'stage_id' => sl.lesson.guid,
          'created_at' => sl.created_at.iso8601,
          'updated_at' => sl.updated_at.iso8601
        )
      end
    end
    
    # ... similar methods for all related objects
  end
end
```

#### 2.2 Update Level Files
```ruby
# Update LevelFiles service for level builder
module Services
  module LevelFiles
    def self.write_custom_level_file(level)
      return unless Rails.application.config.levelbuilder_mode
      
      file_path = level_file_path(level)
      level_data = serialize_level_with_guid(level)
      
      File.write(file_path, level_data)
    end
    
    private
    
    def self.serialize_level_with_guid(level)
      level.as_json.merge(
        'id' => level.guid,
        'created_at' => level.created_at.iso8601,
        'updated_at' => level.updated_at.iso8601
      ).to_json
    end
    
    def self.level_file_path(level)
      "#{Rails.root}/config/levels/#{level.name}.level"
    end
  end
end
```

### Phase 3: Seeding Integration

#### 3.1 Update Seeding Process
```ruby
# Update seeding process to handle GUIDs
module Services
  module CurriculumSeeding
    def self.seed_from_level_files
      puts "Seeding curriculum from level files..."
      
      # Seed from JSON files (level builder output)
      seed_from_json_files
      
      # Seed from level files
      seed_from_level_files
      
      puts "Curriculum seeding completed!"
    end
    
    def self.seed_from_json_files
      json_files = Dir.glob("#{Unit.unit_json_directory}/*.script_json")
      
      json_files.each do |file_path|
        unit_name = File.basename(file_path, '.script_json')
        seed_unit_from_json(unit_name, file_path)
      end
    end
    
    def self.seed_unit_from_json(unit_name, file_path)
      json_data = JSON.parse(File.read(file_path))
      
      # Seed using GUID-based approach
      Services::CurriculumImport.import_from_hash(json_data)
    end
    
    def self.seed_from_level_files
      level_files = Dir.glob("#{Rails.root}/config/levels/*.level")
      
      level_files.each do |file_path|
        level_name = File.basename(file_path, '.level')
        seed_level_from_file(level_name, file_path)
      end
    end
    
    def self.seed_level_from_file(level_name, file_path)
      level_data = JSON.parse(File.read(file_path))
      
      # Create or update level with GUID
      level = Level.find_or_initialize_by(guid: level_data['id'])
      level.assign_attributes(level_data.except('id', 'created_at', 'updated_at'))
      level.save!
    end
  end
end
```

#### 3.2 Update Rake Tasks
```ruby
# Update rake tasks for level builder
namespace :curriculum do
  desc "Seed curriculum from level builder files"
  task seed_from_level_builder: :environment do
    Services::CurriculumSeeding.seed_from_level_files
  end
  
  desc "Export curriculum data for other environments"
  task export_for_environments: :environment do
    return unless Rails.application.config.levelbuilder_mode
    
    puts "Exporting curriculum data for other environments..."
    
    # Export all curriculum data
    export_data = Services::CurriculumExport.export_all_curriculum_data
    
    # Save to S3 for other environments
    s3_key = "curriculum-data/levelbuilder/#{Date.current.strftime('%Y%m%d')}/curriculum-#{Time.current.strftime('%H%M%S')}.json"
    Services::S3.upload(s3_key, export_data.to_json)
    
    puts "Curriculum data exported to S3: #{s3_key}"
  end
end
```

### Phase 4: Validation and Testing

#### 4.1 Level Builder Validation
```ruby
# Validation service for level builder
module Services
  module LevelBuilderValidation
    def self.validate_curriculum_data
      puts "Validating curriculum data in level builder..."
      
      # Validate GUIDs
      validate_guids
      
      # Validate relationships
      validate_relationships
      
      # Validate file consistency
      validate_file_consistency
      
      puts "Level builder validation completed!"
    end
    
    def self.validate_guids
      # Ensure all curriculum objects have GUIDs
      Unit.find_each do |unit|
        raise "Unit #{unit.name} missing GUID" if unit.guid.blank?
      end
      
      ScriptLevel.find_each do |sl|
        raise "ScriptLevel #{sl.id} missing GUID" if sl.guid.blank?
      end
      
      Level.find_each do |level|
        raise "Level #{level.name} missing GUID" if level.guid.blank?
      end
    end
    
    def self.validate_relationships
      # Validate foreign key relationships use GUIDs
      ScriptLevel.find_each do |sl|
        unless Unit.exists?(guid: sl.script_guid)
          raise "ScriptLevel #{sl.guid} references non-existent Unit #{sl.script_guid}"
        end
        unless Lesson.exists?(guid: sl.lesson_guid)
          raise "ScriptLevel #{sl.guid} references non-existent Lesson #{sl.lesson_guid}"
        end
      end
    end
    
    def self.validate_file_consistency
      # Validate that files match database
      Unit.find_each do |unit|
        file_path = Unit.script_json_filepath(unit.name)
        next unless File.exist?(file_path)
        
        file_data = JSON.parse(File.read(file_path))
        file_script = file_data['scripts'].first
        
        unless file_script['id'] == unit.guid
          raise "File GUID mismatch for Unit #{unit.name}: DB=#{unit.guid}, File=#{file_script['id']}"
        end
      end
    end
  end
end
```

#### 4.2 Testing Strategy
```ruby
# Test suite for level builder integration
RSpec.describe 'Level Builder GUID Integration' do
  describe 'GUID generation' do
    it 'generates GUIDs for new units' do
      unit = Unit.create!(name: 'test-unit', title: 'Test Unit')
      expect(unit.guid).to be_present
      expect(unit.guid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
    end
    
    it 'generates GUIDs for new script levels' do
      unit = create(:unit)
      lesson = create(:lesson, script: unit)
      script_level = ScriptLevel.create!(script: unit, lesson: lesson)
      
      expect(script_level.guid).to be_present
    end
    
    it 'generates GUIDs for new levels' do
      level = Level.create!(name: 'test-level', type: 'Maze')
      expect(level.guid).to be_present
    end
  end
  
  describe 'file generation' do
    it 'includes GUIDs in JSON files' do
      unit = create(:unit, guid: 'test-guid')
      unit.write_script_json
      
      file_path = Unit.script_json_filepath(unit.name)
      file_data = JSON.parse(File.read(file_path))
      
      expect(file_data['scripts'].first['id']).to eq('test-guid')
    end
    
    it 'includes GUIDs in level files' do
      level = create(:level, guid: 'test-level-guid')
      Services::LevelFiles.write_custom_level_file(level)
      
      file_path = "#{Rails.root}/config/levels/#{level.name}.level"
      file_data = JSON.parse(File.read(file_path))
      
      expect(file_data['id']).to eq('test-level-guid')
    end
  end
  
  describe 'seeding process' do
    it 'seeds from JSON files with GUIDs' do
      # Create test JSON file
      unit = create(:unit, guid: 'test-guid')
      unit.write_script_json
      
      # Clear database
      Unit.destroy_all
      
      # Seed from file
      Services::CurriculumSeeding.seed_from_json_files
      
      # Verify unit was created with correct GUID
      seeded_unit = Unit.find_by(guid: 'test-guid')
      expect(seeded_unit).to be_present
      expect(seeded_unit.name).to eq(unit.name)
    end
  end
end
```

## Migration Timeline

### Phase 1: GUID Generation (Weeks 1-2)
- Update level builder models to generate GUIDs
- Update controllers to handle GUIDs
- Test GUID generation in level builder

### Phase 2: File Format Updates (Weeks 3-4)
- Update JSON file format to include GUIDs
- Update level file format to include GUIDs
- Test file generation with GUIDs

### Phase 3: Seeding Integration (Weeks 5-6)
- Update seeding process to use GUIDs
- Update rake tasks for level builder
- Test end-to-end seeding process

### Phase 4: Validation and Testing (Weeks 7-8)
- Implement validation services
- Create comprehensive test suite
- Test level builder workflow

## Rollback Strategy

### Rollback Plan
1. **Revert Model Changes**: Remove GUID generation from models
2. **Revert File Format**: Restore original file format
3. **Revert Seeding**: Restore original seeding process
4. **Data Cleanup**: Remove GUID columns if needed

### Rollback Commands
```ruby
# Rollback commands for level builder
namespace :levelbuilder do
  desc "Rollback to ID-based system"
  task rollback_to_ids: :environment do
    puts "Rolling back level builder to ID-based system..."
    
    # Revert model changes
    # ... rollback code
    
    puts "Level builder rollback completed!"
  end
end
```

## Dependencies

- Database schema must support GUIDs
- Application code must use GUIDs
- Seeding process must handle GUIDs
- File format must include GUIDs
- All level builder workflows must be tested

## Success Criteria

1. **GUID Generation**: All new curriculum objects get GUIDs
2. **File Consistency**: Generated files include GUIDs
3. **Seeding Works**: Level builder output can be seeded elsewhere
4. **No Breaking Changes**: Existing level builder workflow unchanged
5. **Performance Maintained**: No significant performance impact
6. **Data Integrity**: All relationships maintained with GUIDs