# NON-CURRICULUM TABLES - DO NOT MIGRATE TO GUIDs

**Created**: 2025-10-17  
**Purpose**: List tables that should NOT be part of curriculum GUID migration  
**Reason**: These are transactional/user data tables, not curriculum content tables  

## 🚨 **TABLES TO EXCLUDE FROM GUID MIGRATION**

### **User Progress Tables (Transactional Data)**
1. **`user_levels`** - Student progress on coding challenges
   - **Why exclude**: Contains `user_id` - this is transactional data tracking individual student progress
   - **Real-world meaning**: "Student John completed Maze: Move Forward with score 100%"
   - **Type**: User data, not curriculum content

2. **`user_scripts`** - Student progress on curriculum courses  
   - **Why exclude**: Contains `user_id` - this is transactional data tracking individual student progress
   - **Real-world meaning**: "Student Sarah enrolled in CS Discoveries on 2024-09-01"
   - **Type**: User data, not curriculum content

### **Other User-Related Tables (Transactional Data)**
3. **`activities`** - Student interactions and attempts
   - **Why exclude**: Contains `user_id` - this is transactional data tracking individual student actions
   - **Real-world meaning**: "Student clicked button X at time Y"
   - **Type**: User data, not curriculum content

4. **`user_level_interactions`** - Additional student interactions
   - **Why exclude**: Contains `user_id` - this is transactional data
   - **Type**: User data, not curriculum content

## ✅ **CURRICULUM TABLES (Content Only)**

### **Core Curriculum Content (8 tables)**
1. **`scripts`** - Complete curriculum courses (NO user_id)
2. **`stages`** - Individual lessons (NO user_id)
3. **`levels`** - Coding challenges (NO user_id)
4. **`lesson_groups`** - Chapters that organize lessons (NO user_id)
5. **`lesson_activities`** - Hands-on exercises (NO user_id)
6. **`activity_sections`** - Steps within activities (NO user_id)
7. **`courses`** - Academic course definitions (NO user_id)
8. **`course_offerings`** - Specific course instances (NO user_id)

### **Curriculum Organization (3 tables)**
9. **`unit_groups`** - Curriculum families (NO user_id)
10. **`script_levels`** - Roadmap of levels in scripts (NO user_id)
11. **`levels_script_levels`** - Complex level relationships (NO user_id)

### **Curriculum Resources (8 tables)**
12. **`course_scripts`** - Join table (courses ↔ scripts) (NO user_id)
13. **`unit_groups_resources`** - Resources for unit groups (NO user_id)
14. **`unit_groups_student_resources`** - Student resources for unit groups (NO user_id)
15. **`scripts_resources`** - Resources for scripts (NO user_id)
16. **`scripts_student_resources`** - Student resources for scripts (NO user_id)
17. **`lessons_resources`** - Resources for lessons (NO user_id)
18. **`stages_standards`** - Standards alignment (NO user_id)
19. **`lessons_vocabularies`** - Vocabulary for lessons (NO user_id)

## 🎯 **UPDATED MIGRATION STRATEGY**

### **Phase 1: Core Curriculum Content (8 tables)**
- `scripts`, `stages`, `levels`, `lesson_groups`
- `lesson_activities`, `activity_sections`
- `courses`, `course_offerings`

### **Phase 2: Curriculum Organization (3 tables)**
- `unit_groups`, `script_levels`, `levels_script_levels`

### **Phase 3: Curriculum Resources (8 tables)**
- All resource and standards tables

### **EXCLUDED: User Progress Tables (4 tables)**
- `user_levels`, `user_scripts`, `activities`, `user_level_interactions`
- These remain ID-based for transactional data

## ✅ **VERIFICATION CHECKLIST**

- [ ] **Remove user_levels from migration plan**
- [ ] **Remove user_scripts from migration plan**
- [ ] **Remove activities from migration plan**
- [ ] **Remove user_level_interactions from migration plan**
- [ ] **Update migration files to exclude these tables**
- [ ] **Update documentation to reflect correct table list**
- [ ] **Re-run all analysis scripts with corrected table list**

## 🚨 **CRITICAL ERROR CORRECTION**

The original analysis incorrectly included user progress tables as curriculum tables. This was a major error because:

1. **User progress tables are transactional data** - they track individual student actions
2. **Curriculum tables are content data** - they define what students learn
3. **GUID migration should focus on content** - not individual student progress
4. **User data should remain ID-based** - for performance and simplicity

This correction reduces the migration scope from 20 tables to 19 tables, focusing only on curriculum content.