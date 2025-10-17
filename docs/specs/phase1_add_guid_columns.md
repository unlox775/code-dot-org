# Phase 1: Add GUID Columns to Curriculum Tables

**Phase**: 1 of 4  
**Goal**: Add GUID columns to all curriculum tables and populate them  
**Impact**: Non-breaking - GUIDs added alongside existing IDs  
**Status**: Ready to implement

## 🎯 **Phase 1 Overview**

### **What We're Doing**
- Add `guid` column to all 27 curriculum content tables
- Populate existing records with UUIDs
- Add unique indexes on GUID columns
- Keep existing ID-based system intact

### **Why This Phase**
- **Non-breaking change** - existing code continues to work
- **Prepares for migration** - GUIDs ready for future use
- **Safe to ship** - no impact on current functionality
- **Enables dual system** - both ID and GUID available

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

### **Step 1: Create Migration Files**
- Generate migration to add `guid` columns
- Add unique indexes on GUID columns
- Include data population logic

### **Step 2: Test Migration**
- Run migration on development database
- Verify GUIDs are populated correctly
- Ensure no data loss or corruption

### **Step 3: Validate Results**
- Check all 27 tables have GUID columns
- Verify GUIDs are unique and populated
- Confirm existing functionality still works

## ✅ **Success Criteria**

### **Database Changes**
- All 27 curriculum tables have `guid` columns
- All existing records have populated GUIDs
- Unique indexes created on GUID columns
- No data loss or corruption

### **Functionality Verification**
- Existing code continues to work unchanged
- No performance degradation
- All tests pass
- Migration runs successfully

## 🚀 **Next Phase**
After Phase 1 completion, proceed to **Phase 2: Test Dual System** where we add foreign key references to GUIDs and test both systems simultaneously.