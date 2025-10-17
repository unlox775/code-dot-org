# Curriculum GUID Migration - Experiments

**Purpose**: Testing and validation for migrating curriculum data from ID-based to GUID-based tables  
**Master Plan**: See [/workspace/docs/specs/](../../docs/specs/) (Phase 1-4 documents)

## 🎯 **Migration Phases**

### **Phase 1: Add GUID Columns** (`phase1_add_guid_columns/`)
- **What**: Create GUID columns on all curriculum tables and populate them
- **Impact**: Shippable - doesn't affect existing functionality
- **Goal**: GUIDs exist but aren't referenced yet

### **Phase 2: Test Dual System** (`phase2_test_dual_system/`)
- **What**: Add foreign key references to GUIDs, test both old and new systems
- **Impact**: Both ID and GUID systems work simultaneously
- **Goal**: Validate that both seeding approaches work identically

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