# Phase 2: JSON Mapping File Approach - Build New Seeding System

**Date**: 2025-10-17  
**Status**: ✅ IMPLEMENTED - JSON Mapping File Approach  
**Phase**: 2 of 4 - Build New Seeding System

## 🎯 **Corrected Implementation Summary**

Phase 2 has been implemented using **JSON mapping files** instead of database tables. This approach maintains the existing file structure while enabling GUID-based synchronization through committed mapping files.

## 📊 **Key Innovation - JSON Mapping Files**

Instead of database mapping tables, the system uses:
- **JSON mapping files** committed to the codebase in `config/curriculum_guid_mappings/`
- **GUID Mapping Service** that loads and manages these files
- **Enhanced seeding service** that uses mappings to ensure consistent GUID assignment
- **No file modification** - existing level/script files remain unchanged

## 🔧 **Complete Implementation Details**

### **1. JSON Mapping Files (27 files)**

**Location**: `config/curriculum_guid_mappings/`

Each curriculum table has a corresponding JSON mapping file:

#### **Core Curriculum Content (13 files)**
- `scripts.json` - Maps script names to GUIDs
- `lessons.json` - Maps lesson keys to GUIDs  
- `levels.json` - Maps level keys to GUIDs
- `lesson_groups.json` - Maps lesson group keys to GUIDs
- `lesson_activities.json` - Maps lesson activity keys to GUIDs
- `activity_sections.json` - Maps activity section keys to GUIDs
- `courses.json` - Maps course keys to GUIDs
- `course_offerings.json` - Maps course offering keys to GUIDs
- `course_versions.json` - Maps course version keys to GUIDs
- `objectives.json` - Maps objective keys to GUIDs
- `programming_expressions.json` - Maps programming expression keys to GUIDs
- `rubrics.json` - Maps rubric keys to GUIDs
- `learning_goals.json` - Maps learning goal keys to GUIDs

#### **Curriculum Organization (3 files)**
- `unit_groups.json` - Maps unit group keys to GUIDs
- `script_levels.json` - Maps composite keys (script:lesson:position) to GUIDs
- `levels_script_levels.json` - Maps composite keys (level:script:lesson:position) to GUIDs

#### **Curriculum Resources (8 files)**
- `course_scripts.json` - Maps composite keys (course:script) to GUIDs
- `unit_group_resources.json` - Maps composite keys (unit_group:resource) to GUIDs
- `unit_group_student_resources.json` - Maps composite keys (unit_group:resource) to GUIDs
- `script_resources.json` - Maps composite keys (script:resource) to GUIDs
- `script_student_resources.json` - Maps composite keys (script:resource) to GUIDs
- `lesson_resources.json` - Maps composite keys (lesson:resource) to GUIDs
- `lesson_standards.json` - Maps composite keys (lesson:standard) to GUIDs
- `lesson_vocabularies.json` - Maps composite keys (lesson:vocabulary) to GUIDs

#### **Curriculum Join Tables (3 files)**
- `lesson_programming_expressions.json` - Maps composite keys (lesson:programming_expression) to GUIDs
- `learning_goal_evidence_levels.json` - Maps composite keys (learning_goal:evidence_level) to GUIDs
- `lesson_opportunity_standards.json` - Maps composite keys (lesson:standard) to GUIDs

### **2. GUID Mapping Service**

**Location**: `lib/services/guid_mapping_service.rb`

**Features**:
- Loads JSON mapping files into memory
- Provides methods to get/set GUIDs for entities
- Automatically creates new GUIDs for new entities
- Updates mapping files when new GUIDs are created
- Caches mappings for performance

**Key Methods**:
- `get_guid(entity_type, identifier)` - Get GUID for an entity
- `set_guid(entity_type, identifier, guid)` - Set GUID for an entity
- `get_or_create_guid(entity_type, identifier)` - Get or create GUID
- `has_guid?(entity_type, identifier)` - Check if entity has GUID
- `reload_mappings()` - Reload mappings from files

### **3. Enhanced Seeding Service**

**Location**: `lib/services/script_seed_with_guids.rb`

**Features**:
- Extends existing ScriptSeed service
- Uses GUID Mapping Service for consistent GUID assignment
- Overrides key import methods to use GUID mappings
- Ensures same content gets same GUID across environments
- Maintains existing seeding logic and relationships

**Overridden Methods**:
- `import_scripts()` - Uses script name → GUID mapping
- `import_lessons()` - Uses lesson key → GUID mapping
- `import_levels()` - Uses level key → GUID mapping
- `import_lesson_groups()` - Uses lesson group key → GUID mapping
- `import_lesson_activities()` - Uses lesson activity key → GUID mapping
- `import_activity_sections()` - Uses activity section key → GUID mapping
- `import_script_levels()` - Uses composite key → GUID mapping
- `import_levels_script_levels()` - Uses composite key → GUID mapping

### **4. Mapping Generation Task**

**Location**: `lib/tasks/curriculum_generate_guid_mappings.rake`

**Usage**: `bundle exec rake curriculum:generate_guid_mappings`

**Features**:
- Generates all 27 JSON mapping files
- Uses existing GUIDs from database
- Creates composite keys for join tables
- Provides detailed statistics
- Creates mapping summary file

## 🚀 **Usage Instructions**

### **Generate Initial Mappings**
```bash
# Generate all mapping files from existing data
bundle exec rake curriculum:generate_guid_mappings

# Output: config/curriculum_guid_mappings/*.json
# Creates 27 mapping files + summary
```

### **Use in Seeding Process**
```ruby
# In your seeding code
require 'services/script_seed_with_guids'

# Use the enhanced seeding service
Services::ScriptSeedWithGuids.import_scripts(scripts_data, seed_context)
Services::ScriptSeedWithGuids.import_lessons(lessons_data, seed_context)
# ... etc
```

### **Manual GUID Management**
```ruby
# Get GUID for an entity
guid_service = Services::GuidMappingService.new
script_guid = guid_service.get_guid('scripts', 'course1')

# Create new GUID for entity
new_guid = guid_service.get_or_create_guid('levels', 'new_level_key')

# Check if entity has GUID
has_guid = guid_service.has_guid?('lessons', 'lesson_key')
```

## 📁 **File Structure**

```
config/curriculum_guid_mappings/
├── scripts.json
├── lessons.json
├── levels.json
├── lesson_groups.json
├── lesson_activities.json
├── activity_sections.json
├── courses.json
├── course_offerings.json
├── course_versions.json
├── objectives.json
├── programming_expressions.json
├── rubrics.json
├── learning_goals.json
├── unit_groups.json
├── script_levels.json
├── levels_script_levels.json
├── course_scripts.json
├── unit_group_resources.json
├── unit_group_student_resources.json
├── script_resources.json
├── script_student_resources.json
├── lesson_resources.json
├── lesson_standards.json
├── lesson_vocabularies.json
├── lesson_programming_expressions.json
├── learning_goal_evidence_levels.json
├── lesson_opportunity_standards.json
└── mapping_summary.json
```

## 🎯 **Key Benefits**

### **1. No File Modification Required**
- Existing level/script files remain completely unchanged
- No need to modify thousands of curriculum files
- Maintains existing file structure and workflows

### **2. Consistent GUID Assignment**
- Same content gets same GUID across all environments
- JSON mapping files ensure deterministic GUID assignment
- Enables reliable data synchronization

### **3. Minimal Code Changes**
- Only 27 JSON files added to codebase
- Existing seeding process can be enhanced incrementally
- No database schema changes required

### **4. Version Control Friendly**
- Mapping files are committed to codebase
- Changes are tracked in git
- Easy to review and manage

### **5. Modular Curriculum System**
- Curriculum data separated from application code
- Can be shared across environments easily
- Enables independent curriculum updates

## 🔄 **Integration with Existing Seeding**

### **Phase 2 Integration**
1. **Generate mappings** from existing data
2. **Commit mapping files** to codebase
3. **Update seeding process** to use GUID mappings
4. **Test consistency** across environments

### **New Curriculum Creation**
1. **Create new curriculum** using existing tools
2. **GUID Mapping Service** automatically assigns GUIDs
3. **Mapping files updated** with new GUIDs
4. **Commit updated mappings** to codebase

## 🧪 **Testing Framework**

### **Test Script Created**
- **Location**: `experimental/curriculum_guid_migration/phase2_test_dual_system/test_phase2_workflow.rb`
- **Purpose**: Test JSON mapping file approach
- **Tests**: Mapping generation, GUID assignment, seeding consistency

### **Test Coverage**
1. **Mapping Generation Test**: Verifies mapping files are created correctly
2. **GUID Assignment Test**: Checks consistent GUID assignment
3. **Seeding Consistency Test**: Ensures same content gets same GUIDs
4. **File Integrity Test**: Validates JSON file structure

## 📋 **Next Steps**

### **Phase 3: Cutover to GUIDs**
- Switch seeding process to use GUIDs instead of IDs
- Update Level Builder to generate GUIDs
- Make new GUID-based system primary

### **Phase 4: Cleanup Old IDs**
- Remove old ID columns and seeding code
- Complete migration to GUID-only system

## 🎉 **Phase 2 Complete - JSON Mapping Approach**

Phase 2 implementation using JSON mapping files is complete and ready for testing. This approach provides a clean, maintainable solution for GUID-based curriculum synchronization while preserving existing file structures.

**Status**: ✅ READY FOR PHASE 3