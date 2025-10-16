# Database Schema Migration Plan - Curriculum GUID Migration

**Created:** 2025-10-16 18:34:36  
**Parent Plan:** [Master Plan](./20251016_183436_curriculum_guid_migration_plan.md)  
**Status:** Planning Phase  

## Overview

This document details the database schema changes required to migrate curriculum tables from integer IDs to GUIDs. The migration will be implemented in phases to ensure zero downtime and data integrity.

## Current Schema Analysis

### Primary Curriculum Tables
```sql
-- Current structure
scripts (id: integer, name: string, ...)
script_levels (id: integer, script_id: integer, stage_id: integer, ...)
levels (id: integer, name: string, ...)
lesson_groups (id: integer, script_id: integer, ...)
lessons (id: integer, script_id: integer, ...)
unit_groups (id: integer, name: string, ...)
course_versions (id: integer, content_root_id: integer, ...)
course_offerings (id: integer, ...)
```

### Foreign Key Dependencies
- `user_levels.level_id` → `levels.id`
- `user_scripts.script_id` → `scripts.id`
- `script_levels.script_id` → `scripts.id`
- `script_levels.stage_id` → `lessons.id`
- `levels_script_levels.level_id` → `levels.id`
- `levels_script_levels.script_level_id` → `script_levels.id`
- And 20+ more foreign key relationships

## Migration Strategy

### Phase 1: Add GUID Infrastructure

#### 1.1 Add GUID Columns
```sql
-- Add GUID columns to all curriculum tables
ALTER TABLE scripts ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE script_levels ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE levels ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE lesson_groups ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE lessons ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE lesson_activities ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE activity_sections ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE unit_groups ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE course_versions ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
ALTER TABLE course_offerings ADD COLUMN guid VARCHAR(36) NOT NULL DEFAULT '';
```

#### 1.2 Generate GUIDs for Existing Data
```sql
-- Generate GUIDs for existing records
UPDATE scripts SET guid = UUID() WHERE guid = '';
UPDATE script_levels SET guid = UUID() WHERE guid = '';
UPDATE levels SET guid = UUID() WHERE guid = '';
-- ... repeat for all tables
```

#### 1.3 Create GUID Indexes
```sql
-- Create unique indexes on GUID columns
CREATE UNIQUE INDEX idx_scripts_guid ON scripts(guid);
CREATE UNIQUE INDEX idx_script_levels_guid ON script_levels(guid);
CREATE UNIQUE INDEX idx_levels_guid ON levels(guid);
-- ... repeat for all tables
```

### Phase 2: Add GUID Foreign Key Columns

#### 2.1 Add GUID Foreign Key Columns
```sql
-- Add GUID foreign key columns to dependent tables
ALTER TABLE user_levels ADD COLUMN level_guid VARCHAR(36);
ALTER TABLE user_scripts ADD COLUMN script_guid VARCHAR(36);
ALTER TABLE script_levels ADD COLUMN script_guid VARCHAR(36);
ALTER TABLE script_levels ADD COLUMN lesson_guid VARCHAR(36);
ALTER TABLE levels_script_levels ADD COLUMN level_guid VARCHAR(36);
ALTER TABLE levels_script_levels ADD COLUMN script_level_guid VARCHAR(36);
-- ... continue for all foreign key relationships
```

#### 2.2 Populate GUID Foreign Keys
```sql
-- Populate GUID foreign keys based on existing ID relationships
UPDATE user_levels ul 
JOIN levels l ON ul.level_id = l.id 
SET ul.level_guid = l.guid;

UPDATE user_scripts us 
JOIN scripts s ON us.script_id = s.id 
SET us.script_guid = s.guid;

-- ... continue for all relationships
```

#### 2.3 Create GUID Foreign Key Indexes
```sql
-- Create indexes on GUID foreign key columns
CREATE INDEX idx_user_levels_level_guid ON user_levels(level_guid);
CREATE INDEX idx_user_scripts_script_guid ON user_scripts(script_guid);
-- ... continue for all foreign key columns
```

### Phase 3: Switch to GUID Primary Keys

#### 3.1 Update Foreign Key Constraints
```sql
-- Drop existing foreign key constraints
ALTER TABLE user_levels DROP FOREIGN KEY fk_user_levels_level_id;
ALTER TABLE user_scripts DROP FOREIGN KEY fk_user_scripts_script_id;
-- ... drop all existing foreign key constraints

-- Add new GUID-based foreign key constraints
ALTER TABLE user_levels ADD CONSTRAINT fk_user_levels_level_guid 
  FOREIGN KEY (level_guid) REFERENCES levels(guid);
ALTER TABLE user_scripts ADD CONSTRAINT fk_user_scripts_script_guid 
  FOREIGN KEY (script_guid) REFERENCES scripts(guid);
-- ... add all new foreign key constraints
```

#### 3.2 Update Primary Key Constraints
```sql
-- Drop existing primary key constraints
ALTER TABLE scripts DROP PRIMARY KEY;
ALTER TABLE script_levels DROP PRIMARY KEY;
-- ... drop all primary key constraints

-- Add GUID as primary key
ALTER TABLE scripts ADD PRIMARY KEY (guid);
ALTER TABLE script_levels ADD PRIMARY KEY (guid);
-- ... update all primary keys
```

### Phase 4: Cleanup

#### 4.1 Remove ID Columns
```sql
-- Remove integer ID columns (after ensuring all code uses GUIDs)
ALTER TABLE scripts DROP COLUMN id;
ALTER TABLE script_levels DROP COLUMN id;
ALTER TABLE levels DROP COLUMN id;
-- ... remove all ID columns
```

#### 4.2 Remove GUID Foreign Key Columns
```sql
-- Remove the old ID-based foreign key columns
ALTER TABLE user_levels DROP COLUMN level_id;
ALTER TABLE user_scripts DROP COLUMN script_id;
-- ... remove all ID-based foreign key columns
```

## Migration Scripts

### Script 1: Add GUID Infrastructure
```ruby
# Migration: Add GUID columns to curriculum tables
class AddGuidColumnsToCurriculumTables < ActiveRecord::Migration[7.0]
  def up
    # Add GUID columns
    add_column :scripts, :guid, :string, limit: 36, null: false, default: ''
    add_column :script_levels, :guid, :string, limit: 36, null: false, default: ''
    add_column :levels, :guid, :string, limit: 36, null: false, default: ''
    # ... add for all curriculum tables
    
    # Generate GUIDs for existing records
    Script.find_each { |s| s.update!(guid: SecureRandom.uuid) }
    ScriptLevel.find_each { |sl| sl.update!(guid: SecureRandom.uuid) }
    Level.find_each { |l| l.update!(guid: SecureRandom.uuid) }
    # ... generate for all tables
    
    # Add unique indexes
    add_index :scripts, :guid, unique: true
    add_index :script_levels, :guid, unique: true
    add_index :levels, :guid, unique: true
    # ... add for all tables
  end
  
  def down
    # Remove GUID columns and indexes
    remove_index :scripts, :guid
    remove_index :script_levels, :guid
    remove_index :levels, :guid
    # ... remove all indexes
    
    remove_column :scripts, :guid
    remove_column :script_levels, :guid
    remove_column :levels, :guid
    # ... remove all columns
  end
end
```

### Script 2: Add GUID Foreign Keys
```ruby
# Migration: Add GUID foreign key columns
class AddGuidForeignKeys < ActiveRecord::Migration[7.0]
  def up
    # Add GUID foreign key columns
    add_column :user_levels, :level_guid, :string, limit: 36
    add_column :user_scripts, :script_guid, :string, limit: 36
    # ... add for all foreign key relationships
    
    # Populate GUID foreign keys
    UserLevel.find_each do |ul|
      ul.update!(level_guid: ul.level.guid)
    end
    
    UserScript.find_each do |us|
      us.update!(script_guid: us.script.guid)
    end
    # ... populate all relationships
    
    # Add indexes
    add_index :user_levels, :level_guid
    add_index :user_scripts, :script_guid
    # ... add for all foreign key columns
  end
  
  def down
    # Remove GUID foreign key columns and indexes
    remove_index :user_levels, :level_guid
    remove_index :user_scripts, :script_guid
    # ... remove all indexes
    
    remove_column :user_levels, :level_guid
    remove_column :user_scripts, :script_guid
    # ... remove all columns
  end
end
```

## Data Validation

### Validation Scripts
```ruby
# Validate GUID generation
class ValidateGuidMigration < ActiveRecord::Migration[7.0]
  def up
    # Ensure all records have GUIDs
    raise "Scripts missing GUIDs" if Script.where(guid: '').exists?
    raise "Levels missing GUIDs" if Level.where(guid: '').exists?
    
    # Ensure GUIDs are unique
    raise "Duplicate script GUIDs" if Script.group(:guid).having('count(*) > 1').exists?
    raise "Duplicate level GUIDs" if Level.group(:guid).having('count(*) > 1').exists?
    
    # Ensure foreign key relationships are maintained
    UserLevel.find_each do |ul|
      level = Level.find_by(guid: ul.level_guid)
      raise "Missing level for user_level #{ul.id}" unless level
      raise "GUID mismatch for user_level #{ul.id}" unless ul.level_id == level.id
    end
  end
end
```

## Performance Considerations

### Index Strategy
- GUID columns will be indexed for fast lookups
- Composite indexes may be needed for complex queries
- Consider partitioning for very large tables

### Query Optimization
- Update application queries to use GUIDs
- Optimize JOIN operations with GUIDs
- Update caching strategies for GUID-based lookups

## Rollback Strategy

### Rollback Plan
1. **Phase 1 Rollback**: Remove GUID columns and indexes
2. **Phase 2 Rollback**: Remove GUID foreign key columns
3. **Phase 3 Rollback**: Restore ID-based foreign key constraints
4. **Phase 4 Rollback**: Restore ID-based primary keys

### Data Integrity Checks
- Verify all foreign key relationships are maintained
- Ensure no data loss during rollback
- Validate application functionality after rollback

## Testing Strategy

### Unit Tests
- Test GUID generation for all table types
- Test foreign key population logic
- Test constraint creation and removal

### Integration Tests
- Test application functionality with dual-key system
- Test data synchronization with GUIDs
- Test performance with GUID-based queries

### Load Tests
- Test performance impact of GUID lookups
- Test migration performance on large datasets
- Test concurrent access during migration

## Timeline

- **Week 1-2**: Schema analysis and migration script development
- **Week 3-4**: Phase 1 implementation (GUID infrastructure)
- **Week 5-6**: Phase 2 implementation (GUID foreign keys)
- **Week 7-8**: Phase 3 implementation (GUID primary keys)
- **Week 9-10**: Phase 4 implementation (cleanup)
- **Week 11-12**: Testing and validation

## Dependencies

- Application code must support dual-key lookups during transition
- Seeding process must be updated to handle GUIDs
- Level builder must generate GUIDs for new content
- All foreign key relationships must be mapped and updated