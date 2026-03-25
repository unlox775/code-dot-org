# Curriculum GUID Migration - Experiments

**Purpose**: Testing and validation for migrating curriculum data from ID-based to GUID-based tables  
**Master Plan**: See [/workspace/docs/specs/](../../docs/specs/) (Phase 1-4 documents)

## 🎯 **Migration Phases**

### **Phase 1: Establish Dual ID/GUID System** (`phase1_add_guid_columns/`)
- **What**: Add GUID columns to all curriculum tables AND all referencing tables
- **Impact**: Complete dual system - both ID and GUID everywhere
- **Goal**: System speaks both IDs and GUIDs, GUIDs stored in level files

### **Phase 2: Build New Seeding System** (`phase2_test_dual_system/`)
- **What**: Create export/import processes and validate old/new seeding produce identical results
- **Impact**: New processes alongside existing, curriculum becomes modular
- **Goal**: Export curriculum to external format, validate zero differences between approaches

### **Phase 3: Cutover to GUIDs** (`phase3_cutover_to_guids/`)
- **What**: Switch seeding process to use GUIDs instead of IDs
- **Impact**: New seeding process takes over
- **Goal**: GUID-based seeding becomes primary method

### **Phase 4: Cleanup Old IDs** (`phase4_cleanup_old_ids/`)
- **What**: Remove old ID columns and seeding code
- **Impact**: Final cleanup, GUID-only system
- **Goal**: Complete migration to GUID-based system

## 📊 **Curriculum Tables**

### **Tables to Migrate (27 total)**
- **Core Content**: `scripts`, `stages`, `levels`, `lesson_groups`, `lesson_activities`, `activity_sections`, `courses`, `course_offerings`, `course_versions`, `objectives`, `programming_expressions`, `rubrics`, `learning_goals`
- **Organization**: `unit_groups`, `script_levels`, `levels_script_levels`
- **Resources**: `course_scripts`, `unit_groups_resources`, `unit_groups_student_resources`, `scripts_resources`, `scripts_student_resources`, `lessons_resources`, `stages_standards`, `lessons_vocabularies`
- **Join Tables**: `lessons_programming_expressions`, `learning_goal_evidence_levels`, `lessons_opportunity_standards`

### **Tables to Keep ID-Based (4 total)**
- **User Progress**: `user_levels`, `user_scripts`, `activities`, `user_level_interactions`
- **Reason**: These are transactional data, not curriculum content

## 🧪 **Testing Structure**

Each phase contains tests with consistent naming:
- **Script**: `test_name.rb`
- **Output**: `test_name-output.json`
- **Analysis**: `test_name-output-AI_analysis.md`

## 📁 **Current Files**

- `curriculum_tables_list.md` - Definitive list of 27 curriculum tables
- `non_curriculum_tables.md` - Tables excluded from migration
- `curriculum_relationships_diagram.md` - Visual relationship diagram
- `run_all_analyses.rb` - Master analysis script