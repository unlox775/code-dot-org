# Non-Curriculum Tables - Keep ID-Based

**Purpose**: Tables that should NOT be migrated to GUIDs  
**Reason**: These are transactional/user data tables, not curriculum content  
**Total Tables**: 4 user progress tables

## 🚫 **EXCLUDED Tables (4 total)**

### **1. `user_levels` (UserLevel) - Student Progress on Coding Challenges**
- **What it is**: Tracks individual student progress on specific levels
- **Real-world example**: "Student John completed Maze: Move Forward with score 100%"
- **Why excluded**: Contains `user_id` - this is transactional data tracking individual student progress
- **Should remain**: ID-based for performance and simplicity

### **2. `user_scripts` (UserScript) - Student Progress on Curriculum Courses**
- **What it is**: Tracks individual student enrollment and progress in scripts
- **Real-world example**: "Student Sarah enrolled in CS Discoveries on 2024-09-01"
- **Why excluded**: Contains `user_id` - this is transactional data tracking individual student progress
- **Should remain**: ID-based for performance and simplicity

### **3. `activities` (Activity) - Student Interactions and Attempts**
- **What it is**: Tracks individual student actions and interactions
- **Real-world example**: "Student clicked button X at time Y"
- **Why excluded**: Contains `user_id` - this is transactional data tracking individual student actions
- **Should remain**: ID-based for performance and simplicity

### **4. `user_level_interactions` (UserLevelInteraction) - Additional Student Interactions**
- **What it is**: Tracks additional student interactions with levels
- **Real-world example**: "Student spent 5 minutes on level, made 3 attempts"
- **Why excluded**: Contains `user_id` - this is transactional data
- **Should remain**: ID-based for performance and simplicity

## 🎯 **Why These Are Excluded**

### **Curriculum Content vs User Progress**
- **Curriculum content** = What students learn (scripts, stages, levels)
- **User progress** = How students learn (user_levels, user_scripts)
- **GUID migration** = Focus on content that needs to be synchronized
- **User data** = Keep ID-based for performance and simplicity

### **Real-World Example**
- **Script "CS Discoveries"** = Curriculum content (needs GUID for sync)
- **Student John's progress** = User data (keep ID for performance)
- **Level "Maze: Move Forward"** = Curriculum content (needs GUID for sync)
- **Student John completed level** = User data (keep ID for performance)

## ✅ **Migration Impact**

### **Tables to Migrate to GUIDs**
- **19 curriculum content tables** - Define what students learn
- **Focus on content synchronization** - Needs to be identical across environments

### **Tables to Keep ID-Based**
- **4 user progress tables** - Track how students learn
- **Focus on performance** - Individual student data, not synchronized

## 🎯 **Final Result**

- **Curriculum content** = GUID-based (synchronized across environments)
- **User progress** = ID-based (individual student data)
- **Migration scope** = Content only, not individual student tracking
- **Performance** = User data remains fast with ID-based lookups