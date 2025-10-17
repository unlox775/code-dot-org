# Phase 2: Test Dual System

**Phase**: 2 of 4  
**Goal**: Add foreign key references to GUIDs and test both ID and GUID systems simultaneously  
**Impact**: Non-breaking - both systems coexist  
**Status**: Ready after Phase 1 completion

## 🎯 **Phase 2 Overview**

### **What We're Doing**
- Add `_guid` foreign key columns to dependent tables
- Populate GUID foreign keys from existing ID relationships
- Add indexes on GUID foreign key columns
- Test both ID and GUID systems work simultaneously

### **Why This Phase**
- **Dual system testing** - ensures both approaches work
- **Non-breaking change** - existing code continues to work
- **Validates migration** - proves GUID system is functional
- **Prepares for cutover** - both systems ready for switch

## 📊 **Tables to Update**

### **Foreign Key Updates**
- Add `script_guid` to tables referencing `scripts`
- Add `stage_guid` to tables referencing `stages`
- Add `level_guid` to tables referencing `levels`
- Add `course_guid` to tables referencing `courses`
- Add `lesson_group_guid` to tables referencing `lesson_groups`
- Add `objective_guid` to tables referencing `objectives`
- Add `rubric_guid` to tables referencing `rubrics`
- Add `learning_goal_guid` to tables referencing `learning_goals`

### **Dependent Tables**
- All tables that reference curriculum content tables
- Join tables between curriculum tables
- Resource tables linked to curriculum content

## 🔧 **Implementation Steps**

### **Step 1: Add GUID Foreign Key Columns**
- Create migration to add `_guid` columns
- Add indexes on GUID foreign key columns
- Include data population logic

### **Step 2: Populate GUID Foreign Keys**
- Map existing ID relationships to GUID relationships
- Ensure data consistency between ID and GUID systems
- Validate all relationships are correctly mapped

### **Step 3: Test Dual System**
- Verify both ID and GUID systems work
- Test data consistency between systems
- Ensure no performance issues
- Validate all functionality works

## ✅ **Success Criteria**

### **Database Changes**
- All dependent tables have GUID foreign key columns
- All GUID foreign keys are populated correctly
- Indexes created on GUID foreign key columns
- Data consistency maintained between systems

### **Functionality Verification**
- Both ID and GUID systems work simultaneously
- No data inconsistencies between systems
- All tests pass
- Performance remains acceptable

## 🚀 **Next Phase**
After Phase 2 completion, proceed to **Phase 3: Cutover to GUIDs** where we switch the seeding process to use GUIDs instead of IDs.