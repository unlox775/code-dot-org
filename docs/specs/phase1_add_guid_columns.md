# Phase 1: Establish Dual ID/GUID System

**Phase**: 1 of 4  
**Goal**: Make the system speak both IDs and GUIDs - complete dual system  
**Impact**: Non-breaking - GUIDs added alongside existing IDs  
**Status**: Ready to implement

> **📋 Master Plan**: See [Curriculum GUID Migration Plan](../../experimental/curriculum_guid_migration/README.md) for complete project overview and table relationships.

> **🧪 Phase Tests**: See [Phase 1 Tests](../../experimental/curriculum_guid_migration/phase1_add_guid_columns/) for validation scripts and analysis results.

## 🎯 **Phase 1 Overview**

### **What We're Doing**
- Add `guid` column to all 27 curriculum content tables
- Add `_guid` foreign key columns to all referencing tables
- Populate all GUIDs and GUID foreign keys
- Ensure GUIDs are stored in level files and data locations
- Keep existing ID-based system intact

### **Why This Phase**
- **Complete dual system** - both ID and GUID available everywhere
- **Non-breaking change** - existing code continues to work
- **Safe to ship** - no impact on current functionality
- **Enables coexistence** - both systems work in parallel

## 📊 **Tables to Update (27 total)**

### **Core Curriculum Content (13 tables)**
- `scripts`, `stages`, `levels`, `lesson_groups`, `lesson_activities`, `activity_sections`
- `courses`, `course_offerings`, `course_versions`, `objectives`
- `programming_expressions`, `rubrics`, `learning_goals`

### **Curriculum Organization (3 tables)**
- `unit_groups`, `script_levels`, `levels_script_levels`

### **Curriculum Resources (8 tables)**
- `course_scripts`, `unit_groups_resources`, `unit_groups_student_resources`
- `scripts_resources`, `scripts_student_resources`, `lessons_resources`
- `stages_standards`, `lessons_vocabularies`

### **Curriculum Join Tables (3 tables)**
- `lessons_programming_expressions`, `learning_goal_evidence_levels`, `lessons_opportunity_standards`

## 🔧 **Implementation Steps**

### **Step 1: Add GUID Columns to Primary Tables**
- Add `guid` column to all 27 curriculum content tables
- Populate existing records with UUIDs
- Add unique indexes on GUID columns

### **Step 2: Add GUID Foreign Key Columns**
- Add `_guid` foreign key columns to all referencing tables
- Include curriculum tables that reference each other
- Include user progress tables that reference curriculum
- Add indexes on GUID foreign key columns

### **Step 3: Populate GUID Foreign Keys**
- Map existing ID relationships to GUID relationships
- Ensure all foreign key references have both ID and GUID
- Validate data consistency between ID and GUID systems

### **Step 4: Update Data Storage**
- Ensure GUIDs are stored in level files
- Update seeding process to include GUIDs
- Ensure GUIDs propagate to all environments

### **Step 5: Create Validation Script**
- Build script to verify ID/GUID consistency
- Check that every ID reference has corresponding GUID reference
- Validate that ID and GUID point to same entity

## ✅ **Success Criteria**

### **Database Changes**
- All 27 curriculum tables have `guid` columns
- All referencing tables have `_guid` foreign key columns
- All existing records have populated GUIDs and GUID foreign keys
- Unique indexes created on GUID columns
- Indexes created on GUID foreign key columns
- No data loss or corruption

### **Data Consistency**
- Every ID reference has corresponding GUID reference
- ID and GUID always point to same entity
- Validation script passes with zero inconsistencies
- GUIDs propagate to all environments

### **Functionality Verification**
- Existing code continues to work unchanged
- No performance degradation
- All tests pass
- Migration runs successfully
- GUIDs stored in level files and data locations

## 🔧 **Implementation Details**

### **Migration Files Created**
- `20251016183436_add_guid_columns_to_curriculum_tables.rb` - Adds `guid` columns to all 27 curriculum tables
- `20251017160000_add_guid_foreign_keys_to_curriculum_tables.rb` - Adds `_guid` foreign key columns to curriculum tables
- `20251017160001_create_guid_validation_script.rb` - Creates validation script for ID/GUID consistency

### **Model Files Modified (27 total)**
All curriculum model files updated with `include GuidSupport`:

**Core Curriculum Content (13 models)**:
- `Unit` (scripts), `Lesson` (stages), `Level` (levels), `LessonGroup` (lesson_groups)
- `LessonActivity` (lesson_activities), `ActivitySection` (activity_sections)
- `CourseVersion` (course_versions), `CourseOffering` (course_offerings)
- `Objective` (objectives), `ProgrammingExpression` (programming_expressions)
- `Rubric` (rubrics), `LearningGoal` (learning_goals)

**Curriculum Organization (3 models)**:
- `UnitGroup` (unit_groups), `ScriptLevel` (script_levels), `LevelsScriptLevel` (levels_script_levels)

**Curriculum Resources (8 models)**:
- `UnitGroupUnit` (course_scripts), `UnitGroupsResource` (unit_groups_resources)
- `UnitGroupsStudentResource` (unit_groups_student_resources), `ScriptsResource` (scripts_resources)
- `ScriptsStudentResource` (scripts_student_resources), `LessonsResource` (lessons_resources)
- `LessonsStandard` (stages_standards), `LessonsVocabulary` (lessons_vocabularies)

**Curriculum Join Tables (3 models)**:
- `LessonsProgrammingExpression` (lessons_programming_expressions)
- `LearningGoalEvidenceLevel` (learning_goal_evidence_levels)
- `LessonsOpportunityStandard` (lessons_opportunity_standards)

**GuidSupport Module Provides**:
- `find_by_guid(guid)` - Find by GUID
- `find_by_id_or_guid(identifier)` - Find by ID or GUID
- Automatic GUID generation and validation
- Dual-key support during migration period

### **Validation Script**
- `validate_guid_consistency.rb` - Ensures ID and GUID point to same entity
- Runs after Phase 1 completion
- Verifies all 27 tables have consistent ID/GUID relationships

## 🚀 **Next Phase**
After Phase 1 completion, proceed to **Phase 2: Build New Seeding System** where we create the export/import processes and validate that old and new seeding produce identical results.