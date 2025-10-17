# Experiments Folder Restructure - COMPLETE

**Date**: 2025-10-17  
**Status**: ✅ COMPLETE  
**Purpose**: Clean up confusing historical iterations and create clear phase structure

## 🎯 **What Was Done**

### **🧹 Cleanup Actions**
- **Removed 8 failed test files** - All ActiveRecord-dependent tests deleted
- **Removed 11 confusing files** - Historical iterations with adjectives (CLEAR_, CORRECTED_, DEFINITIVE_, etc.)
- **Removed empty directories** - Cleaned up phase1_database_schema, phase2_application_code, test_data, utils
- **Removed duplicate files** - Consolidated similar documentation

### **🏗️ Restructure Actions**
- **Created 4 phase directories** with descriptive names:
  - `phase1_add_guid_columns/` - Add GUID columns to curriculum tables
  - `phase2_test_dual_system/` - Test both ID and GUID systems work
  - `phase3_cutover_to_guids/` - Switch seeding process to use GUIDs
  - `phase4_cleanup_old_ids/` - Remove old ID columns and seeding code

### **📝 Standardized Naming**
- **Script files**: `script_name.rb`
- **Output files**: `script_name-output.json`
- **Analysis files**: `script_name-output-AI_analysis.md`
- **All files sort together** in each phase directory

## 📁 **Final Structure**

```
experimental/curriculum_guid_migration/
├── README.md                                    # Main overview
├── curriculum_tables_list.md                   # 19 tables to migrate
├── non_curriculum_tables.md                    # 4 tables to keep ID-based
├── curriculum_relationships_diagram.md         # Visual relationships
├── phase1_add_guid_columns/                    # Phase 1: Add GUID columns
│   ├── README.md
│   ├── analyze_curriculum_tables.rb
│   ├── analyze_curriculum_tables-output.json
│   ├── analyze_curriculum_tables-output-AI_analysis.md
│   ├── discover_models.rb
│   ├── discover_models-output.json
│   ├── discover_models-output-AI_analysis.md
│   ├── run_analysis.rb
│   ├── run_analysis-output.json
│   └── run_analysis-output-AI_analysis.md
├── phase2_test_dual_system/                    # Phase 2: Test dual system
│   └── README.md
├── phase3_cutover_to_guids/                    # Phase 3: Cutover to GUIDs
│   └── README.md
└── phase4_cleanup_old_ids/                     # Phase 4: Cleanup old IDs
    └── README.md
```

## ✅ **Phase Definitions**

### **Phase 1: Add GUID Columns**
- **What**: Create GUID columns on all curriculum tables and populate them
- **Impact**: Shippable - doesn't affect existing functionality
- **Goal**: GUIDs exist but aren't referenced yet

### **Phase 2: Test Dual System**
- **What**: Add foreign key references to GUIDs, test both old and new systems
- **Impact**: Both ID and GUID systems work simultaneously
- **Goal**: Validate that both seeding approaches work identically

### **Phase 3: Cutover to GUIDs**
- **What**: Switch seeding process to use GUIDs instead of IDs
- **Impact**: New seeding process takes over
- **Goal**: GUID-based seeding becomes primary method

### **Phase 4: Cleanup Old IDs**
- **What**: Remove old ID columns and seeding code
- **Impact**: Final cleanup, GUID-only system
- **Goal**: Complete migration to GUID-based system

## 🎯 **Key Improvements**

### **Clear Phase Structure**
- **Descriptive phase names** - Immediately understand what each phase does
- **Consistent naming** - All files follow script-output-AI_analysis pattern
- **Logical organization** - Each phase has its own directory

### **Simplified Documentation**
- **Main README** references docs/specs plan
- **Phase READMEs** explain what each phase does
- **No more adjectives** - Clear, direct naming

### **Preserved Best Content**
- **Curriculum tables list** - Definitive list of 19 tables to migrate
- **Non-curriculum tables** - 4 tables to keep ID-based
- **Working tests** - 3 successful analysis scripts in Phase 1

## 🚀 **Ready for Use**

The experiments folder is now clean, organized, and ready for use. Each phase has a clear purpose, consistent naming, and the structure supports the GUID migration process outlined in the docs/specs plan.

**Next Steps**: Use Phase 1 tests to validate curriculum table identification, then proceed with implementing Phase 1 migration code.