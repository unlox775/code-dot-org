# Curriculum Tables for GUID Migration

**Purpose**: Definitive list of tables to migrate from ID-based to GUID-based  
**Total Tables**: 19 curriculum content tables  
**Excluded**: 4 user progress tables (keep ID-based)

## 🎯 **Core Curriculum Content (8 tables)**

### **1. `scripts` (Unit) - Complete Curriculum Courses**
- **What it is**: A full curriculum program like "CS Discoveries"
- **Real-world example**: "CS Discoveries" course with 6 units
- **Connections**: Contains many stages (lessons), contains many script_levels (coding challenges)

### **2. `stages` (Lesson) - Individual Lessons**
- **What it is**: A single learning session within a script
- **Real-world example**: "Problem Solving" lesson in CS Discoveries
- **Connections**: Belongs to one script, contains many lesson_activities

### **3. `levels` (Level) - Coding Challenges**
- **What it is**: A specific coding challenge students complete
- **Real-world example**: "Maze: Move Forward" puzzle
- **Connections**: Referenced by script_levels, completed by students (user_levels)

### **4. `lesson_groups` (LessonGroup) - Chapters**
- **What it is**: Logical grouping of lessons within a script
- **Real-world example**: "Unit 1: Problem Solving" chapter
- **Connections**: Belongs to one script, contains many stages (lessons)

### **5. `lesson_activities` (LessonActivity) - Hands-on Exercises**
- **What it is**: Specific activities within a lesson
- **Real-world example**: "Brainstorming Solutions" activity
- **Connections**: Belongs to one stage (lesson), contains many activity_sections

### **6. `activity_sections` (ActivitySection) - Activity Steps**
- **What it is**: Individual steps within an activity
- **Real-world example**: "Step 1: Read the Code" instruction
- **Connections**: Belongs to one lesson_activity

### **7. `courses` (Course) - Academic Course Definitions**
- **What it is**: Formal academic course like "AP Computer Science A"
- **Real-world example**: "AP Computer Science A" course definition
- **Connections**: Contains many course_offerings, linked to scripts via course_scripts

### **8. `course_offerings` (CourseOffering) - Specific Course Instances**
- **What it is**: A specific instance of a course in a school
- **Real-world example**: "AP CS A - Fall 2024 - Period 3"
- **Connections**: Belongs to one course, linked to scripts via course_scripts

## 🏗️ **Curriculum Organization (3 tables)**

### **9. `unit_groups` (UnitGroup) - Curriculum Families**
- **What it is**: Groups of related scripts/courses
- **Real-world example**: "CS Fundamentals" family
- **Connections**: Contains many scripts, has resources

### **10. `script_levels` (ScriptLevel) - Level Roadmap**
- **What it is**: Defines the sequence of levels in a script
- **Real-world example**: "CS Discoveries level 1 is Maze: Move Forward"
- **Connections**: Belongs to one script, references one level

### **11. `levels_script_levels` (LevelsScriptLevel) - Complex Level Relationships**
- **What it is**: Join table for complex level dependencies
- **Real-world example**: "Level A must be completed before Level B"
- **Connections**: Links levels to script_levels

## 📚 **Curriculum Resources (8 tables)**

### **12. `course_scripts` (CourseScript) - Course-Script Links**
- **What it is**: Links courses to scripts
- **Real-world example**: "AP CS A includes CS Principles script"
- **Connections**: Links courses to scripts

### **13. `unit_groups_resources` (UnitGroupResource) - Unit Group Resources**
- **What it is**: Resources for unit groups
- **Real-world example**: "CS Fundamentals teacher guide"
- **Connections**: Belongs to one unit_group

### **14. `unit_groups_student_resources` (UnitGroupStudentResource) - Student Resources**
- **What it is**: Student-facing resources for unit groups
- **Real-world example**: "CS Fundamentals student reference"
- **Connections**: Belongs to one unit_group

### **15. `scripts_resources` (ScriptResource) - Script Resources**
- **What it is**: Resources for scripts
- **Real-world example**: "CS Discoveries teacher guide"
- **Connections**: Belongs to one script

### **16. `scripts_student_resources` (ScriptStudentResource) - Student Script Resources**
- **What it is**: Student-facing resources for scripts
- **Real-world example**: "CS Discoveries student reference"
- **Connections**: Belongs to one script

### **17. `lessons_resources` (LessonResource) - Lesson Resources**
- **What it is**: Resources for lessons
- **Real-world example**: "Problem Solving worksheet"
- **Connections**: Belongs to one stage (lesson)

### **18. `stages_standards` (StageStandard) - Standards Alignment**
- **What it is**: Educational standards alignment for lessons
- **Real-world example**: "CSTA 1A-AP-14 alignment"
- **Connections**: Belongs to one stage (lesson)

### **19. `lessons_vocabularies` (LessonVocabulary) - Lesson Vocabulary**
- **What it is**: Vocabulary terms for lessons
- **Real-world example**: "Problem Solving terms"
- **Connections**: Belongs to one stage (lesson)

## 🚫 **EXCLUDED Tables (Keep ID-Based)**

### **User Progress Tables (4 tables)**
- **`user_levels`** - Student progress on coding challenges
- **`user_scripts`** - Student progress on curriculum courses  
- **`activities`** - Student interactions and attempts
- **`user_level_interactions`** - Additional student interactions

**Why excluded**: These contain `user_id` and are transactional data, not curriculum content. They should remain ID-based for performance.

## 🎯 **Migration Strategy**

### **Phase 1: Add GUID Columns**
- Add `guid` column to all 19 curriculum tables
- Populate with UUIDs for existing data
- Add unique indexes on GUID columns

### **Phase 2: Add GUID Foreign Keys**
- Add `_guid` foreign key columns to dependent tables
- Populate based on existing ID relationships
- Test both ID and GUID systems work

### **Phase 3: Switch to GUID Seeding**
- Update seeding process to use GUIDs
- Test GUID-based data synchronization
- Validate both systems produce identical results

### **Phase 4: Cleanup**
- Remove old ID columns and references
- Remove old seeding code
- Complete migration to GUID-only system