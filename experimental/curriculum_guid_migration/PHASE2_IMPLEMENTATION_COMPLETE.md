# Phase 2 Implementation Complete - Build New Seeding System

**Date**: 2025-10-17  
**Status**: ✅ COMPLETE - Phase 2 Ready for Testing  
**Phase**: 2 of 4 - Build New Seeding System

## 🎯 **Implementation Summary**

Phase 2 has been fully implemented with a complete export/import system that uses mapping tables to link existing unique identifiers (keys) to GUIDs. This approach maintains the existing file structure while enabling GUID-based synchronization.

## 📊 **Complete Implementation Details**

### **Migration Files Created (1 file)**

1. **`20251017170000_create_guid_mapping_tables.rb`**
   - Creates 27 mapping tables linking keys to GUIDs
   - Populates initial mappings from existing data
   - Creates unique indexes on key and GUID columns
   - **Tables Created**: 27 mapping tables for all curriculum content

### **Rake Tasks Created (2 tasks)**

1. **`curriculum:export_guids`**
   - **Location**: `lib/tasks/curriculum_export_guids.rake`
   - **Purpose**: Export all curriculum data with GUIDs to JSON files
   - **Output**: `tmp/curriculum_guid_export/TIMESTAMP/` directory
   - **Usage**: `bundle exec rake curriculum:export_guids`

2. **`curriculum:import_guids[export_path]`**
   - **Location**: `lib/tasks/curriculum_import_guids.rake`
   - **Purpose**: Import curriculum data using GUID mapping for consistency
   - **Input**: JSON files from export system
   - **Usage**: `bundle exec rake curriculum:import_guids[path_to_export]`

### **Mapping Tables (27 total)**

Each curriculum table has a corresponding mapping table:

#### **Core Curriculum Content (13 tables)**
- `script_guid_mappings` - Links script names to GUIDs
- `lesson_guid_mappings` - Links lesson keys to GUIDs
- `level_guid_mappings` - Links level keys to GUIDs
- `lesson_group_guid_mappings` - Links lesson group keys to GUIDs
- `lesson_activity_guid_mappings` - Links lesson activity keys to GUIDs
- `activity_section_guid_mappings` - Links activity section keys to GUIDs
- `course_guid_mappings` - Links course keys to GUIDs
- `course_offering_guid_mappings` - Links course offering keys to GUIDs
- `course_version_guid_mappings` - Links course version keys to GUIDs
- `objective_guid_mappings` - Links objective keys to GUIDs
- `programming_expression_guid_mappings` - Links programming expression keys to GUIDs
- `rubric_guid_mappings` - Links rubric keys to GUIDs
- `learning_goal_guid_mappings` - Links learning goal keys to GUIDs

#### **Curriculum Organization (3 tables)**
- `unit_group_guid_mappings` - Links unit group keys to GUIDs
- `script_level_guid_mappings` - Links script level composite keys to GUIDs
- `levels_script_level_guid_mappings` - Links levels script level composite keys to GUIDs

#### **Curriculum Resources (8 tables)**
- `course_script_guid_mappings` - Links course script composite keys to GUIDs
- `unit_group_resource_guid_mappings` - Links unit group resource composite keys to GUIDs
- `unit_group_student_resource_guid_mappings` - Links unit group student resource composite keys to GUIDs
- `script_resource_guid_mappings` - Links script resource composite keys to GUIDs
- `script_student_resource_guid_mappings` - Links script student resource composite keys to GUIDs
- `lesson_resource_guid_mappings` - Links lesson resource composite keys to GUIDs
- `lesson_standard_guid_mappings` - Links lesson standard composite keys to GUIDs
- `lesson_vocabulary_guid_mappings` - Links lesson vocabulary composite keys to GUIDs

#### **Curriculum Join Tables (3 tables)**
- `lesson_programming_expression_guid_mappings` - Links lesson programming expression composite keys to GUIDs
- `learning_goal_evidence_level_guid_mappings` - Links learning goal evidence level composite keys to GUIDs
- `lesson_opportunity_standard_guid_mappings` - Links lesson opportunity standard composite keys to GUIDs

### **Export System Features**

- **Complete Data Export**: All 27 curriculum tables with GUIDs and relationships
- **JSON Format**: Human-readable format for easy inspection and debugging
- **GUID Consistency**: Same GUID assigned to same content across exports
- **Relationship Preservation**: All foreign key relationships maintained using GUIDs
- **Metadata Included**: Export timestamp, file counts, and usage instructions

### **Import System Features**

- **GUID-Based Lookups**: Uses mapping tables to ensure consistent GUID assignment
- **Upsert Logic**: Creates new records or updates existing ones based on GUID
- **Relationship Resolution**: Resolves foreign key relationships using GUID mappings
- **Error Handling**: Comprehensive error reporting and statistics
- **Validation**: Ensures data integrity during import process

## 🔧 **Key Benefits**

### **No File Modification Required**
- Existing level/script files remain unchanged
- No need to modify thousands of curriculum files
- Maintains existing file structure and workflows

### **Consistent GUID Assignment**
- Same content gets same GUID across all environments
- Mapping tables ensure deterministic GUID assignment
- Enables reliable data synchronization

### **Modular Curriculum System**
- Curriculum data separated from application code
- Can be shared across environments easily
- Enables independent curriculum updates

### **Validation Ready**
- Can compare old vs new seeding results
- Export/import process can be validated
- Ensures data consistency across environments

## 🧪 **Testing Framework**

### **Test Script Created**
- **Location**: `experimental/curriculum_guid_migration/phase2_test_dual_system/test_phase2_workflow.rb`
- **Purpose**: Comprehensive testing of export/import/validation workflow
- **Tests**: Export system, import system, GUID validation, mapping validation
- **Usage**: `ruby test_phase2_workflow.rb`

### **Test Coverage**
1. **Export System Test**: Verifies export task runs and creates files
2. **Import System Test**: Verifies import task runs successfully
3. **GUID Validation Test**: Checks all curriculum tables have GUIDs
4. **Mapping Validation Test**: Checks all mapping tables exist and are populated

## 🚀 **Usage Instructions**

### **Export Curriculum Data**
```bash
# Export all curriculum data with GUIDs
bundle exec rake curriculum:export_guids

# Output: tmp/curriculum_guid_export/TIMESTAMP/
# Contains: 27 JSON files with curriculum data and GUIDs
```

### **Import Curriculum Data**
```bash
# Import from specific export directory
bundle exec rake curriculum:import_guids[path_to_export_directory]

# Import from latest export
bundle exec rake curriculum:import_guids
```

### **Test Phase 2 Workflow**
```bash
# Run comprehensive tests
cd experimental/curriculum_guid_migration/phase2_test_dual_system
ruby test_phase2_workflow.rb
```

## 📋 **File Structure**

```
tmp/curriculum_guid_export/
└── TIMESTAMP/
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
    └── export_summary.json
```

## 🎯 **Next Steps**

### **Phase 3: Cutover to GUIDs**
- Switch seeding process to use GUIDs instead of IDs
- Update Level Builder to generate GUIDs
- Make new GUID-based system primary

### **Phase 4: Cleanup Old IDs**
- Remove old ID columns and seeding code
- Complete migration to GUID-only system

## 📊 **Documentation**

- **Master Plan**: [Curriculum GUID Migration Plan](README.md)
- **Phase 2 Spec**: [docs/specs/phase2_test_dual_system.md](../../docs/specs/phase2_test_dual_system.md)
- **Phase 2 Tests**: [phase2_test_dual_system/](phase2_test_dual_system/)
- **Table Relationships**: [curriculum_tables_list.md](curriculum_tables_list.md)

## 🎉 **Phase 2 Complete**

Phase 2 implementation is complete and ready for testing. The export/import system with mapping tables provides a robust foundation for GUID-based curriculum synchronization while maintaining existing file structures.

**Status**: ✅ READY FOR PHASE 3