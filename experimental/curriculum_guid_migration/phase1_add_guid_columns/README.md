# Phase 1: Add GUID Columns

**Purpose**: Create GUID columns on all curriculum tables and populate them  
**Impact**: Shippable - doesn't affect existing functionality  
**Goal**: GUIDs exist but aren't referenced yet

## 🎯 **What This Phase Does**

### **Add GUID Columns**
- Add `guid` column to all 19 curriculum tables
- Populate with UUIDs for existing data
- Add unique indexes on GUID columns

### **No Functional Changes**
- Existing ID-based system continues to work
- No foreign key references to GUIDs yet
- Completely backward compatible

## 🧪 **Tests in This Phase**

### **1. `analyze_curriculum_tables.rb`**
- **Purpose**: Identify which tables need GUID migration
- **Output**: `analyze_curriculum_tables-output.json`
- **Analysis**: `analyze_curriculum_tables-output-AI_analysis.md`
- **Result**: 19 curriculum tables identified, 4 user tables excluded

### **2. `discover_models.rb`**
- **Purpose**: Discover actual models used in seeding code
- **Output**: `discover_models-output.json`
- **Analysis**: `discover_models-output-AI_analysis.md`
- **Result**: Found naming mismatches and additional models

### **3. `run_analysis.rb`**
- **Purpose**: Orchestrate multiple analysis methods
- **Output**: `run_analysis-output.json`
- **Analysis**: `run_analysis-output-AI_analysis.md`
- **Result**: 85% confidence, 20 curriculum tables identified

## 🎯 **Phase 1 Success Criteria**

- [ ] **19 curriculum tables** have GUID columns added
- [ ] **GUIDs populated** for all existing data
- [ ] **Unique indexes** created on GUID columns
- [ ] **No functional changes** to existing system
- [ ] **Backward compatibility** maintained

## 🚀 **Next Phase**

**Phase 2: Test Dual System** - Add foreign key references to GUIDs and test both old and new systems work simultaneously.