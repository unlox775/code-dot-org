# Phase 4: Cleanup Old IDs

**Phase**: 4 of 4  
**Goal**: Remove old ID columns and ID-based code  
**Impact**: Breaking - removes old system  
**Status**: Ready after Phase 3 completion

## 🎯 **Phase 4 Overview**

### **What We're Doing**
- Remove old ID columns from curriculum tables
- Remove old ID-based foreign key columns
- Remove old ID-based code and references
- Clean up migration artifacts

### **Why This Phase**
- **Completes migration** - removes old ID system entirely
- **Reduces complexity** - single identifier system
- **Improves performance** - no dual system overhead
- **Final cleanup** - migration is complete

## 🔧 **Implementation Steps**

### **Step 1: Remove ID Columns**
- Create migration to drop ID columns
- Remove old foreign key columns
- Clean up old indexes

### **Step 2: Remove ID-Based Code**
- Remove old ID-based references
- Clean up migration artifacts
- Remove old seeding code

### **Step 3: Final Validation**
- Verify all curriculum code uses GUIDs
- Ensure no ID references remain
- Validate system works correctly

## ✅ **Success Criteria**

### **Database Changes**
- All ID columns removed from curriculum tables
- All old foreign key columns removed
- Old indexes cleaned up
- Database schema is GUID-only

### **Code Changes**
- All curriculum code uses GUIDs
- No ID-based references remain
- Old seeding code removed
- System is fully GUID-based

## 🎉 **Migration Complete**
After Phase 4 completion, the curriculum system is fully migrated to GUIDs and the old ID-based system is completely removed.