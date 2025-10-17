# AI Analysis of Database Schema

**Source**: `/workspace/dashboard/db/schema.rb`  
**Analysis Date**: 2025-10-17  
**Method**: Direct schema examination  

## 🎯 **ACTUAL Curriculum Tables Found**

### **Core Curriculum Structure**

1. **`scripts`** - Top-level curriculum containers
   - **Purpose**: Complete curriculum units (e.g., "CS Discoveries", "CS Principles")
   - **Key fields**: `name`, `family_name`, `published_state`, `instruction_type`
   - **Real-world meaning**: A full curriculum track or course

2. **`stages`** - Individual lessons within scripts
   - **Purpose**: Individual learning sessions within a script
   - **Key fields**: `name`, `script_id`, `lesson_group_id`, `key`, `has_lesson_plan`
   - **Real-world meaning**: A single class session or lesson

3. **`levels`** - Individual coding challenges
   - **Purpose**: Specific coding puzzles, games, or exercises
   - **Key fields**: `name`, `level_num`, `type`, `published`, `properties`
   - **Real-world meaning**: A specific coding task or puzzle

4. **`lesson_groups`** - Groups of lessons within scripts
   - **Purpose**: Organize lessons into logical groups
   - **Key fields**: `name`, `script_id`, `position`
   - **Real-world meaning**: A chapter or unit within a curriculum

### **Relationship Tables**

5. **`script_levels`** - Join table linking scripts to levels
   - **Purpose**: Defines which levels appear in which scripts, in what order
   - **Key fields**: `script_id`, `level_id`, `position`, `chapter`
   - **Real-world meaning**: The sequence of coding challenges in a curriculum

6. **`lesson_activities`** - Activities within lessons
   - **Purpose**: Specific learning activities within a lesson
   - **Key fields**: `lesson_id`, `position`, `name`
   - **Real-world meaning**: Hands-on exercises or discussions

7. **`activity_sections`** - Sections within activities
   - **Purpose**: Break down activities into smaller parts
   - **Key fields**: `lesson_activity_id`, `key`, `position`, `properties`
   - **Real-world meaning**: Steps within an activity

### **Course Management**

8. **`courses`** - Academic course definitions
   - **Purpose**: School course definitions
   - **Key fields**: `name`, `properties`
   - **Real-world meaning**: "AP Computer Science", "Intro to CS"

9. **`course_offerings`** - Specific instances of courses
   - **Purpose**: Actual course instances with students
   - **Key fields**: `course_id`, `school_id`, `school_year`
   - **Real-world meaning**: "AP CS A - Fall 2024 - Period 3"

10. **`unit_groups`** - Groups of related scripts
    - **Purpose**: Organize scripts into larger groups
    - **Key fields**: `name`, `published_state`, `instruction_type`
    - **Real-world meaning**: A collection of related curricula

### **User Progress Tracking**

11. **`user_levels`** - Student progress through levels
    - **Purpose**: Track which levels students have completed
    - **Key fields**: `user_id`, `level_id`, `script_id`, `attempts`, `best_result`
    - **Real-world meaning**: Student's progress and performance

12. **`user_scripts`** - Student progress through scripts
    - **Purpose**: Track which scripts students are enrolled in
    - **Key fields**: `user_id`, `script_id`, `started_at`, `completed_at`
    - **Real-world meaning**: Student's enrollment and completion status

## 🔍 **Key Discoveries**

### **1. Naming Convention Confirmed**
- **`scripts`** = Our "Units" (top-level containers)
- **`stages`** = Our "Lessons" (individual learning sessions)
- **`levels`** = Individual coding challenges (correct)

### **2. Missing Tables from Our Assumptions**
- **`CourseScript`** - Not found (may be `course_scripts`)
- **`StageScript`** - Not found (may be `stages` with `script_id`)
- **`UnitGroupCourse`** - Not found (may be `unit_groups` with course relationships)

### **3. Additional Tables Found**
- **`lesson_groups`** - Groups of lessons within scripts
- **`activity_sections`** - Sections within activities
- **`course_offerings`** - Specific course instances
- **`unit_groups`** - Groups of related scripts

### **4. User Progress Tables Exist**
- **`user_levels`** - Student progress through levels
- **`user_scripts`** - Student progress through scripts
- These ARE part of the curriculum system and should be included in migration

## 📊 **Updated Curriculum Table List**

### **Primary Curriculum Tables (12)**
1. `scripts` - Top-level curriculum containers
2. `stages` - Individual lessons
3. `levels` - Coding challenges
4. `lesson_groups` - Groups of lessons
5. `lesson_activities` - Activities within lessons
6. `activity_sections` - Sections within activities
7. `courses` - Academic course definitions
8. `course_offerings` - Specific course instances
9. `unit_groups` - Groups of related scripts
10. `script_levels` - Join table (scripts ↔ levels)
11. `user_levels` - Student progress through levels
12. `user_scripts` - Student progress through scripts

### **Secondary Tables (8)**
- `course_scripts` - Join table (courses ↔ scripts)
- `unit_groups_resources` - Resources for unit groups
- `unit_groups_student_resources` - Student resources
- `scripts_resources` - Resources for scripts
- `scripts_student_resources` - Student resources for scripts
- `stages_standards` - Standards alignment
- `levels_script_levels` - Join table (levels ↔ script_levels)
- `lessons_resources` - Resources for lessons

## 🎯 **Migration Strategy Update**

### **Phase 1: Core Curriculum Tables**
Focus on the 12 primary tables first:
- `scripts`, `stages`, `levels`, `lesson_groups`
- `lesson_activities`, `activity_sections`
- `courses`, `course_offerings`, `unit_groups`
- `script_levels`, `user_levels`, `user_scripts`

### **Phase 2: Secondary Tables**
Add the 8 secondary tables:
- All join tables and resource tables
- Standards alignment tables

### **Phase 3: Content Tables**
Add content-related tables:
- `resources`, `vocabularies`, `standards`
- `rubrics`, `learning_goals`, `objectives`

## ✅ **Confidence Assessment**

**High Confidence (90%+)**: Core curriculum structure is now clear
**Medium Confidence (70-89%)**: Secondary tables need verification
**Low Confidence (<70%)**: Content tables need further analysis

## 🚀 **Next Steps**

1. **Verify all 20 tables exist** in the database
2. **Check foreign key relationships** between tables
3. **Test with actual data** to ensure completeness
4. **Update migration plan** based on this analysis
5. **Create definitive curriculum table list** for GUID migration

This schema analysis provides a much clearer picture of the actual curriculum structure than our initial assumptions.