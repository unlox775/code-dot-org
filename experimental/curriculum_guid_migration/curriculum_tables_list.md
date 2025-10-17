# Curriculum Tables for GUID Migration

**Purpose**: Definitive list of tables to migrate from ID-based to GUID-based  
**Total Tables**: 24 curriculum content tables  
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

### **9. `course_versions` (CourseVersion) - Course Version Definitions**
- **What it is**: Different versions of a course (e.g., 2023 vs 2024)
- **Real-world example**: "AP CS A 2024 version"
- **Connections**: Belongs to one course_offering, has content_root_id

### **10. `objectives` (Objective) - Lesson Objectives**
- **What it is**: Learning objectives for specific lessons
- **Real-world example**: "Students will understand loops"
- **Connections**: Belongs to one lesson (stage)

### **11. `programming_expressions` (ProgrammingExpression) - Programming Language Elements**
- **What it is**: Programming language expressions and concepts
- **Real-world example**: "for loop", "if statement", "variable"
- **Connections**: Used by lessons via lessons_programming_expressions

### **12. `rubrics` (Rubric) - Assessment Rubrics**
- **What it is**: Assessment rubrics for lessons and levels
- **Real-world example**: "Code quality rubric for Maze levels"
- **Connections**: Belongs to one lesson and one level

### **13. `learning_goals` (LearningGoal) - Learning Goals for Rubrics**
- **What it is**: Specific learning goals within rubrics
- **Real-world example**: "Student demonstrates proper loop usage"
- **Connections**: Belongs to one rubric

## 🏗️ **Curriculum Organization (3 tables)**

### **14. `unit_groups` (UnitGroup) - Curriculum Families**
- **What it is**: Groups of related scripts/courses
- **Real-world example**: "CS Fundamentals" family
- **Connections**: Contains many scripts, has resources

### **15. `script_levels` (ScriptLevel) - Level Roadmap**
- **What it is**: Defines the sequence of levels in a script
- **Real-world example**: "CS Discoveries level 1 is Maze: Move Forward"
- **Connections**: Belongs to one script, references one level

### **16. `levels_script_levels` (LevelsScriptLevel) - Complex Level Relationships**
- **What it is**: Join table for complex level dependencies
- **Real-world example**: "Level A must be completed before Level B"
- **Connections**: Links levels to script_levels

## 📚 **Curriculum Resources (8 tables)**

### **17. `course_scripts` (CourseScript) - Course-Script Links**
- **What it is**: Links courses to scripts
- **Real-world example**: "AP CS A includes CS Principles script"
- **Connections**: Links courses to scripts

### **18. `unit_groups_resources` (UnitGroupResource) - Unit Group Resources**
- **What it is**: Resources for unit groups
- **Real-world example**: "CS Fundamentals teacher guide"
- **Connections**: Belongs to one unit_group

### **19. `unit_groups_student_resources` (UnitGroupStudentResource) - Student Resources**
- **What it is**: Student-facing resources for unit groups
- **Real-world example**: "CS Fundamentals student reference"
- **Connections**: Belongs to one unit_group

### **20. `scripts_resources` (ScriptResource) - Script Resources**
- **What it is**: Resources for scripts
- **Real-world example**: "CS Discoveries teacher guide"
- **Connections**: Belongs to one script

### **21. `scripts_student_resources` (ScriptStudentResource) - Student Script Resources**
- **What it is**: Student-facing resources for scripts
- **Real-world example**: "CS Discoveries student reference"
- **Connections**: Belongs to one script

### **22. `lessons_resources` (LessonResource) - Lesson Resources**
- **What it is**: Resources for lessons
- **Real-world example**: "Problem Solving worksheet"
- **Connections**: Belongs to one stage (lesson)

### **23. `stages_standards` (StageStandard) - Standards Alignment**
- **What it is**: Educational standards alignment for lessons
- **Real-world example**: "CSTA 1A-AP-14 alignment"
- **Connections**: Belongs to one stage (lesson)

### **24. `lessons_vocabularies` (LessonVocabulary) - Lesson Vocabulary**
- **What it is**: Vocabulary terms for lessons
- **Real-world example**: "Problem Solving terms"
- **Connections**: Belongs to one stage (lesson)

## 🔗 **Curriculum Join Tables (3 tables)**

### **25. `lessons_programming_expressions` (LessonsProgrammingExpression) - Lesson-Programming Expression Links**
- **What it is**: Join table linking lessons to programming expressions
- **Real-world example**: "Lesson 1 uses for loops and variables"
- **Connections**: Links lessons to programming_expressions

### **26. `learning_goal_evidence_levels` (LearningGoalEvidenceLevel) - Evidence Levels for Learning Goals**
- **What it is**: Evidence levels for assessing learning goals
- **Real-world example**: "Novice, Developing, Proficient, Advanced"
- **Connections**: Belongs to one learning_goal

### **27. `lessons_opportunity_standards` (LessonsOpportunityStandard) - Opportunity Standards for Lessons**
- **What it is**: Opportunity standards linked to lessons
- **Real-world example**: "CSTA 1A-AP-14 opportunity standard"
- **Connections**: Links lessons to opportunity standards

## 🚫 **EXCLUDED Tables (Keep ID-Based)**

### **User Progress Tables (4 tables)**
- **`user_levels`** - Student progress on coding challenges
- **`user_scripts`** - Student progress on curriculum courses  
- **`activities`** - Student interactions and attempts
- **`user_level_interactions`** - Additional student interactions

**Why excluded**: These contain `user_id` and are transactional data, not curriculum content. They should remain ID-based for performance.

## 🎯 **Migration Strategy**

### **Phase 1: Add GUID Columns**
- Add `guid` column to all 27 curriculum tables
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