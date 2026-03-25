# Phase 2: Build New Seeding System

**Phase**: 2 of 4  
**Goal**: Create export/import processes and validate old/new seeding produce identical results  
**Impact**: Non-breaking - new processes alongside existing  
**Status**: ✅ IMPLEMENTED - Ready for Testing

## 🎯 **Phase 2 Overview**

### **What We're Doing**
- Build export process to extract curriculum data with GUIDs
- Create import process to load curriculum data from external format
- Develop validation to ensure old/new seeding produce identical results
- Test dry-run synchronization between environments
- Design modular curriculum system architecture

### **Why This Phase**
- **Validates dual system** - proves GUID system works correctly
- **Enables data synchronization** - curriculum can be shared across environments
- **Prepares for cutover** - new seeding system ready
- **Creates modular system** - curriculum separated from application code

## 📊 **Export/Import Targets**

### **Curriculum Data Export**
- All 27 curriculum content tables with GUIDs
- All foreign key relationships using GUIDs
- Level files with embedded GUIDs
- Complete curriculum state as external format

### **Target Format: SQL Dump Files**
- SQL files without ID columns (GUID-only)
- `REPLACE INTO` statements for idempotent imports
- Modular structure for selective curriculum loading
- Version-controlled curriculum definitions

## 🔧 **Implementation Steps**

### **Step 1: Build Export Process**
- Create script to export all curriculum data with GUIDs
- Generate SQL dump files without ID columns
- Include all foreign key relationships using GUIDs
- Store exported data in experiments folder

### **Step 2: Build Import Process**
- Create script to import curriculum data from SQL files
- Use `REPLACE INTO` for idempotent imports
- Handle GUID-based foreign key relationships
- Support selective curriculum loading

### **Step 3: Create Validation System**
- Build script to compare old vs new seeding results
- Verify zero differences between approaches
- Test dry-run synchronization between environments
- Validate GUID consistency across systems

### **Step 4: Test End-to-End Process**
- Run old seeding process
- Immediately run new seeding process
- Verify identical results
- Test cross-environment synchronization

## ✅ **Success Criteria**

### **Export/Import System**
- Curriculum data exports successfully with GUIDs
- SQL dump files generated without ID columns
- Import process loads data correctly
- Modular curriculum loading works

### **Validation Results**
- Old and new seeding produce identical results
- Zero differences between seeding approaches
- Cross-environment synchronization works
- GUID consistency maintained across systems

### **System Architecture**
- Curriculum separated from application code
- External curriculum format established
- Version-controlled curriculum definitions
- Ready for production cutover

## 🔧 **Implementation Details**

### **Migration Files Created**
- `20251017170000_create_guid_mapping_tables.rb` - Creates 27 mapping tables linking keys to GUIDs

### **Rake Tasks Created**
- `curriculum:export_guids` - Exports all curriculum data with GUIDs to JSON files
- `curriculum:import_guids[export_path]` - Imports curriculum data using GUID mapping

### **Mapping Tables (27 total)**
Each curriculum table has a corresponding mapping table:
- `script_guid_mappings`, `lesson_guid_mappings`, `level_guid_mappings`, etc.
- Links existing unique identifiers (keys) to GUIDs
- Enables consistent GUID assignment across environments

### **Export System**
- **Location**: `lib/tasks/curriculum_export_guids.rake`
- **Output**: JSON files in `tmp/curriculum_guid_export/TIMESTAMP/`
- **Format**: Each table exported with GUIDs and mapping keys
- **Usage**: `bundle exec rake curriculum:export_guids`

### **Import System**
- **Location**: `lib/tasks/curriculum_import_guids.rake`
- **Input**: JSON files from export system
- **Process**: Uses mapping tables to ensure consistent GUID assignment
- **Usage**: `bundle exec rake curriculum:import_guids[path_to_export]`

### **Key Benefits**
- **No file modification** - existing level/script files unchanged
- **Consistent GUIDs** - same GUID assigned to same content across environments
- **Modular curriculum** - curriculum data separated from application code
- **Validation ready** - can compare old vs new seeding results

## 🚀 **Next Phase**
After Phase 2 completion, proceed to **Phase 3: Cutover to GUIDs** where we switch the seeding process to use GUIDs instead of IDs and make the new system primary.