# Application Code Migration Plan - Curriculum GUID Migration

**Created:** 2025-10-16 18:34:36  
**Parent Plan:** [Master Plan](./20251016_183436_curriculum_guid_migration_plan.md)  
**Status:** Planning Phase  

## Overview

This document details the application code changes required to migrate from integer ID-based curriculum lookups to GUID-based lookups. The migration will maintain backward compatibility during the transition period.

## Current Code Analysis

### Model Associations
```ruby
# Current ID-based associations
class Unit < ApplicationRecord
  has_many :script_levels, foreign_key: 'script_id'
  has_many :lessons, through: :lesson_groups
  belongs_to :wrapup_video, class_name: 'Video', optional: true
end

class ScriptLevel < ApplicationRecord
  belongs_to :script, class_name: 'Unit', optional: true
  belongs_to :lesson, foreign_key: 'stage_id', optional: true
  has_and_belongs_to_many :levels
end

class Level < ApplicationRecord
  has_and_belongs_to_many :script_levels
  belongs_to :game, optional: true
end
```

### Lookup Methods
```ruby
# Current ID-based lookups
Unit.find(123)
Unit.find_by(name: 'course1')
ScriptLevel.find(456)
Level.find_by(name: 'level1')
```

### Caching Mechanisms
```ruby
# Current ID-based caching
@@unit_cache = {}
@@unit_cache[unit.id.to_s] = unit
@@unit_cache[unit.name] = unit
```

## Migration Strategy

### Phase 1: Dual-Key Support

#### 1.1 Update Model Associations
```ruby
# Add GUID-based associations alongside ID-based ones
class Unit < ApplicationRecord
  # Existing ID-based associations (maintained during transition)
  has_many :script_levels, foreign_key: 'script_id'
  has_many :lessons, through: :lesson_groups
  
  # New GUID-based associations
  has_many :script_levels_guid, foreign_key: 'script_guid', primary_key: 'guid'
  has_many :lessons_guid, through: :lesson_groups_guid
  
  # Dual lookup methods
  def self.find_by_id_or_guid(identifier)
    if identifier.match?(/\A[0-9]+\z/)
      find(identifier)
    else
      find_by(guid: identifier)
    end
  end
end

class ScriptLevel < ApplicationRecord
  # Existing associations
  belongs_to :script, class_name: 'Unit', optional: true
  belongs_to :lesson, foreign_key: 'stage_id', optional: true
  
  # New GUID-based associations
  belongs_to :script_guid, class_name: 'Unit', foreign_key: 'script_guid', primary_key: 'guid', optional: true
  belongs_to :lesson_guid, class_name: 'Lesson', foreign_key: 'lesson_guid', primary_key: 'guid', optional: true
  
  # Dual lookup methods
  def self.find_by_id_or_guid(identifier)
    if identifier.match?(/\A[0-9]+\z/)
      find(identifier)
    else
      find_by(guid: identifier)
    end
  end
end
```

#### 1.2 Update Lookup Methods
```ruby
# Create unified lookup methods
module CurriculumLookup
  def self.find_unit(identifier)
    if identifier.match?(/\A[0-9]+\z/)
      Unit.find(identifier)
    else
      Unit.find_by(guid: identifier) || Unit.find_by(name: identifier)
    end
  end
  
  def self.find_level(identifier)
    if identifier.match?(/\A[0-9]+\z/)
      Level.find(identifier)
    else
      Level.find_by(guid: identifier) || Level.find_by(name: identifier)
    end
  end
  
  def self.find_script_level(identifier)
    if identifier.match?(/\A[0-9]+\z/)
      ScriptLevel.find(identifier)
    else
      ScriptLevel.find_by(guid: identifier)
    end
  end
end
```

#### 1.3 Update Caching Mechanisms
```ruby
# Update caching to support both ID and GUID lookups
class Unit < ApplicationRecord
  def self.unit_cache_from_db
    {}.tap do |cache|
      Unit.with_associated_models.find_each do |unit|
        # Cache by both ID and GUID
        cache[unit.id.to_s] = unit
        cache[unit.guid] = unit
        cache[unit.name] = unit
      end
    end
  end
  
  def self.get_from_cache(identifier)
    return nil unless should_cache?
    
    cache_key = identifier.to_s
    script_cache.fetch(cache_key) do
      # Try both ID and GUID lookups
      get_without_cache(identifier) || get_without_cache_by_guid(identifier)
    end
  end
  
  def self.get_without_cache_by_guid(guid)
    Unit.with_associated_models.find_by(guid: guid)
  end
end
```

### Phase 2: GUID-First Implementation

#### 2.1 Update Primary Lookup Methods
```ruby
# Switch primary lookup methods to use GUIDs
class Unit < ApplicationRecord
  def self.find_by_identifier(identifier)
    # Try GUID first, then fall back to ID for backward compatibility
    find_by(guid: identifier) || find_by(id: identifier) || find_by(name: identifier)
  end
  
  def self.cache_find(identifier)
    return nil unless should_cache?
    
    # Update cache to prioritize GUID lookups
    script_cache.fetch(identifier.to_s) do
      get_without_cache(identifier)
    end
  end
end
```

#### 2.2 Update Serialization
```ruby
# Update serialization to use GUIDs
class Unit < ApplicationRecord
  def summarize(include_lessons = true, user = nil, include_bonus_levels = false, locale_code = 'en-us', unit_group_unit: original_unit_group_unit)
    # ... existing code ...
    summary = {
      id: guid,  # Use GUID instead of ID
      name: name,
      title: title_for_display(unit_group_unit: unit_group_unit),
      # ... rest of summary
    }
    # ... rest of method
  end
  
  def seeding_key(seed_context)
    {'script.guid': guid}.stringify_keys  # Use GUID in seeding key
  end
end
```

#### 2.3 Update Foreign Key References
```ruby
# Update foreign key references to use GUIDs
class UserLevel < ApplicationRecord
  belongs_to :user
  belongs_to :level, foreign_key: 'level_guid', primary_key: 'guid'
  belongs_to :script, foreign_key: 'script_guid', primary_key: 'guid'
  
  # Maintain backward compatibility during transition
  def level
    @level ||= Level.find_by(guid: level_guid) || Level.find(level_id) if level_id
  end
  
  def script
    @script ||= Unit.find_by(guid: script_guid) || Unit.find(script_id) if script_id
  end
end
```

### Phase 3: GUID-Only Implementation

#### 3.1 Remove ID Dependencies
```ruby
# Remove all ID-based lookups and associations
class Unit < ApplicationRecord
  # Remove ID-based associations
  # has_many :script_levels, foreign_key: 'script_id'  # REMOVED
  
  # Keep only GUID-based associations
  has_many :script_levels, foreign_key: 'script_guid', primary_key: 'guid'
  has_many :lessons, through: :lesson_groups
  
  # Remove dual lookup methods
  # def self.find_by_id_or_guid(identifier)  # REMOVED
  
  # Use GUID-only lookups
  def self.find_by_identifier(identifier)
    find_by(guid: identifier) || find_by(name: identifier)
  end
end
```

#### 3.2 Update All References
```ruby
# Update all code that references curriculum IDs
class ScriptLevelsController < ApplicationController
  def show
    # OLD: @script_level = ScriptLevel.find(params[:id])
    @script_level = ScriptLevel.find_by(guid: params[:id])
    
    # OLD: @script = @script_level.script
    @script = @script_level.script  # Now uses GUID-based association
    
    # ... rest of method
  end
end
```

## Specific Code Changes

### 1. Model Updates

#### Unit Model
```ruby
class Unit < ApplicationRecord
  # Update associations
  has_many :script_levels, foreign_key: 'script_guid', primary_key: 'guid'
  has_many :lessons, through: :lesson_groups
  has_many :user_scripts, foreign_key: 'script_guid', primary_key: 'guid'
  
  # Update lookup methods
  def self.get_from_cache(identifier, raise_exceptions: true)
    script = if should_cache?
      cache_key = identifier.to_s
      script_cache.fetch(cache_key) do
        get_without_cache(identifier)
      end
    else
      get_without_cache(identifier)
    end
    
    return script if script
    if raise_exceptions
      raise ActiveRecord::RecordNotFound.new("Couldn't find Unit with guid|name=#{identifier}")
    end
  end
  
  def self.get_without_cache(identifier)
    # Try GUID first, then name
    Unit.with_associated_models.find_by(guid: identifier) ||
    Unit.with_associated_models.find_by(name: identifier)
  end
  
  # Update serialization
  def summarize(include_lessons = true, user = nil, include_bonus_levels = false, locale_code = 'en-us', unit_group_unit: original_unit_group_unit)
    # ... existing code ...
    summary = {
      id: guid,  # Use GUID as primary identifier
      name: name,
      # ... rest of summary
    }
    # ... rest of method
  end
end
```

#### ScriptLevel Model
```ruby
class ScriptLevel < ApplicationRecord
  # Update associations
  belongs_to :script, class_name: 'Unit', foreign_key: 'script_guid', primary_key: 'guid', optional: true
  belongs_to :lesson, foreign_key: 'lesson_guid', primary_key: 'guid', optional: true
  has_and_belongs_to_many :levels, join_table: 'levels_script_levels', foreign_key: 'script_level_guid', association_foreign_key: 'level_guid'
  
  # Update lookup methods
  def self.cache_find(script_level_guid)
    return nil unless should_cache?
    Unit.script_level_cache[script_level_guid]
  end
  
  # Update serialization
  def summarize(include_prev_next = true, for_edit: false, user_id: nil, unit_group_unit: nil)
    # ... existing code ...
    summary = {
      id: guid,  # Use GUID as primary identifier
      ids: level_guids.map(&:to_s),  # Use level GUIDs
      # ... rest of summary
    }
    # ... rest of method
  end
end
```

#### Level Model
```ruby
class Level < ApplicationRecord
  # Update associations
  has_and_belongs_to_many :script_levels, join_table: 'levels_script_levels', foreign_key: 'level_guid', association_foreign_key: 'script_level_guid'
  
  # Update lookup methods
  def self.cache_find(level_guid)
    return nil unless should_cache?
    Unit.level_cache[level_guid]
  end
  
  def self.find_by_key(key)
    # Try GUID first, then name
    find_by(guid: key) || find_by(name: key)
  end
  
  # Update serialization
  def summarize
    {
      level_id: guid,  # Use GUID as primary identifier
      type: self.class.to_s,
      name: name,
      # ... rest of summary
    }
  end
end
```

### 2. Controller Updates

#### ScriptLevelsController
```ruby
class ScriptLevelsController < ApplicationController
  def show
    # Update to use GUID lookups
    @script_level = ScriptLevel.find_by(guid: params[:id])
    raise ActiveRecord::RecordNotFound unless @script_level
    
    @script = @script_level.script
    @level = @script_level.oldest_active_level
    
    # ... rest of method
  end
  
  def level_properties
    # Update to use GUID lookups
    @script_level = ScriptLevel.find_by(guid: params[:script_level_id])
    @level = @script_level.oldest_active_level
    
    # ... rest of method
  end
end
```

#### UnitsController
```ruby
class UnitsController < ApplicationController
  def show
    # Update to use GUID lookups
    @script = Unit.find_by(guid: params[:id]) || Unit.find_by(name: params[:id])
    raise ActiveRecord::RecordNotFound unless @script
    
    # ... rest of method
  end
end
```

### 3. Service Updates

#### ScriptSeed Service
```ruby
module Services
  module ScriptSeed
    # Update seeding to use GUIDs
    def self.seed_from_json_file(unit_name)
      filepath = Unit.script_json_filepath(unit_name)
      return unless File.exist?(filepath)
      
      json_data = JSON.parse(File.read(filepath))
      seed_from_hash(json_data)
    end
    
    def self.seed_from_hash(json_data)
      # Update to use GUID-based seeding
      script_data = json_data['scripts'].first
      script = Unit.find_or_initialize_by(guid: script_data['guid'])
      script.assign_attributes(script_data.except('id', 'guid'))
      script.save!
      
      # Update all related objects to use GUIDs
      # ... rest of seeding logic
    end
    
    def self.serialize_seeding_json(script)
      # Update serialization to use GUIDs
      {
        scripts: [script.as_json(include: :all).merge('id' => script.guid)],
        # ... rest of serialization
      }.to_json
    end
  end
end
```

### 4. Cache Updates

#### Unit Cache
```ruby
class Unit < ApplicationRecord
  def self.unit_cache_from_db
    {}.tap do |cache|
      Unit.with_associated_models.find_each do |unit|
        # Cache by GUID and name
        cache[unit.guid] = unit
        cache[unit.name] = unit
      end
    end
  end
  
  def self.script_level_cache
    return nil unless should_cache?
    @@script_level_cache ||= {}.tap do |cache|
      script_cache.each_value do |unit|
        cache.merge!(unit.script_levels.index_by(&:guid))
      end
    end
  end
  
  def self.level_cache
    return nil unless should_cache?
    @@level_cache ||= {}.tap do |cache|
      script_level_cache.each_value do |script_level|
        level = script_level.level
        next unless level
        cache[level.guid] = level unless cache.key? level.guid
        cache[level.name] = level unless cache.key? level.name
      end
    end
  end
end
```

## Testing Strategy

### Unit Tests
```ruby
# Test GUID-based lookups
RSpec.describe Unit do
  describe '.find_by_identifier' do
    it 'finds by GUID' do
      unit = create(:unit, guid: 'test-guid-123')
      expect(Unit.find_by_identifier('test-guid-123')).to eq(unit)
    end
    
    it 'finds by name when GUID not found' do
      unit = create(:unit, name: 'test-unit')
      expect(Unit.find_by_identifier('test-unit')).to eq(unit)
    end
  end
  
  describe 'associations' do
    it 'loads script_levels via GUID' do
      unit = create(:unit, guid: 'unit-guid')
      script_level = create(:script_level, script_guid: 'unit-guid')
      expect(unit.script_levels).to include(script_level)
    end
  end
end
```

### Integration Tests
```ruby
# Test end-to-end functionality
RSpec.describe 'Curriculum GUID Migration' do
  it 'maintains data integrity during migration' do
    # Create test data with both ID and GUID
    unit = create(:unit, guid: 'unit-guid')
    script_level = create(:script_level, script_id: unit.id, script_guid: unit.guid)
    
    # Test that both lookups work
    expect(ScriptLevel.find(script_level.id)).to eq(script_level)
    expect(ScriptLevel.find_by(guid: script_level.guid)).to eq(script_level)
    
    # Test associations work with both keys
    expect(unit.script_levels).to include(script_level)
  end
end
```

## Performance Considerations

### Index Optimization
- Ensure GUID columns are properly indexed
- Consider composite indexes for common query patterns
- Monitor query performance during migration

### Caching Strategy
- Update cache keys to use GUIDs
- Implement cache warming for GUID-based lookups
- Monitor cache hit rates during transition

### Query Optimization
- Update N+1 query patterns to use GUIDs
- Optimize JOIN operations with GUIDs
- Consider query result caching for expensive operations

## Rollback Strategy

### Code Rollback
1. **Phase 1**: Remove GUID-based code, restore ID-based code
2. **Phase 2**: Update associations back to ID-based
3. **Phase 3**: Restore original lookup methods
4. **Phase 4**: Update serialization back to ID-based

### Data Rollback
- Ensure ID columns are restored and populated
- Verify foreign key relationships are maintained
- Test application functionality with ID-based lookups

## Timeline

- **Week 1-2**: Code analysis and dual-key implementation
- **Week 3-4**: GUID-first implementation
- **Week 5-6**: GUID-only implementation
- **Week 7-8**: Testing and validation
- **Week 9-10**: Performance optimization
- **Week 11-12**: Rollback testing and documentation

## Dependencies

- Database schema must support dual-key system
- Seeding process must be updated for GUIDs
- All foreign key relationships must be mapped
- Caching mechanisms must be updated
- All tests must be updated for GUID-based lookups