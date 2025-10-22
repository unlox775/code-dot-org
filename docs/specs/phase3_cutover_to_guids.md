# Phase 3: Cutover to GUIDs

**Phase**: 3 of 4  
**Goal**: Switch seeding process to use GUIDs instead of IDs  
**Impact**: Breaking - seeding process changes  
**Status**: Ready after Phase 2 completion

## 🎯 **Phase 3 Overview**

### **What We're Doing**
- Update seeding process to use GUIDs instead of IDs
- Modify Level Builder to generate GUIDs
- Update curriculum synchronization to use GUIDs
- Switch all curriculum references to GUID-based

### **Why This Phase**
- **Eliminates ID dependencies** - removes numeric ID requirements
- **Enables data synchronization** - GUIDs work across environments
- **Prepares for cleanup** - old ID system can be removed
- **Completes migration** - curriculum system is GUID-based

## 🔧 **Implementation Steps**

### **Step 1: Update Seeding Process**
- Modify `script_seed.rb` to use GUIDs
- Update all curriculum import/export logic
- Ensure GUID-based seeding works correctly

### **Step 2: Update Level Builder**
- Modify Level Builder to generate GUIDs
- Update curriculum creation process
- Ensure new content gets GUIDs

### **Step 3: Update Synchronization**
- Modify curriculum synchronization to use GUIDs
- Update S3 export/import process
- Ensure data consistency across environments

### **Step 4: Update Application Code**
- Modify models to use GUIDs for curriculum references
- Update caching to use GUIDs
- Ensure all curriculum code uses GUIDs

## ✅ **Success Criteria**

### **Seeding Process**
- All curriculum seeding uses GUIDs
- No ID-based seeding remains
- Data synchronization works with GUIDs
- Level Builder generates GUIDs

### **Application Code**
- All curriculum references use GUIDs
- Caching updated to use GUIDs
- No ID-based curriculum code remains
- All tests pass

## 🚀 **Next Phase**
After Phase 3 completion, proceed to **Phase 4: Cleanup Old IDs** where we remove old ID columns and ID-based code.