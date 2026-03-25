# Curriculum System Data Model

**Last Updated**: 2025-01-27  
**Purpose**: Comprehensive documentation of the curriculum system's data model and table relationships

## Overview

The Code.org curriculum system is built around 27 core tables that define curriculum content, organization, and resources. This system supports both traditional ID-based relationships and a new GUID-based system for improved data synchronization and consistency.

## Core Curriculum Tables (27 tables)

### 1. Core Curriculum Content (13 tables)

#### `scripts` (Unit) - Complete Curriculum Courses
- **Purpose**: A full curriculum program like "CS Discoveries"
- **Example**: "CS Discoveries" course with 6 units
- **Key Fields**: `name`, `title`, `description`, `is_migrated`
- **Relationships**: Contains many stages (lessons), contains many script_levels (coding challenges)

#### `stages` (Lesson) - Individual Lessons
- **Purpose**: A single learning session within a script
- **Example**: "Problem Solving" lesson in CS Discoveries
- **Key Fields**: `name`, `title`, `description`, `relative_position`
- **Relationships**: Belongs to one script, contains many lesson_activities

#### `levels` (Level) - Coding Challenges
- **Purpose**: A specific coding challenge students complete
- **Example**: "Maze: Move Forward" puzzle
- **Key Fields**: `name`, `type`, `level_num`, `properties`
- **Relationships**: Referenced by script_levels, completed by students (user_levels)

#### `lesson_groups` (LessonGroup) - Chapters
- **Purpose**: Logical grouping of lessons within a script
- **Example**: "Unit 1: Problem Solving" chapter
- **Key Fields**: `name`, `title`, `position`
- **Relationships**: Belongs to one script, contains many stages (lessons)

#### `lesson_activities` (LessonActivity) - Hands-on Exercises
- **Purpose**: Specific activities within a lesson
- **Example**: "Brainstorming Solutions" activity
- **Key Fields**: `name`, `position`, `duration`
- **Relationships**: Belongs to one stage (lesson), contains many activity_sections

#### `activity_sections` (ActivitySection) - Activity Steps
- **Purpose**: Individual steps within an activity
- **Example**: "Step 1: Read the Code" instruction
- **Key Fields**: `name`, `position`, `instructions`
- **Relationships**: Belongs to one lesson_activity

#### `courses` (Course) - Academic Course Definitions
- **Purpose**: Formal academic course like "AP Computer Science A"
- **Example**: "AP Computer Science A" course definition
- **Key Fields**: `name`, `title`, `description`
- **Relationships**: Contains many course_offerings, linked to scripts via course_scripts

#### `course_offerings` (CourseOffering) - Specific Course Instances
- **Purpose**: A specific instance of a course in a school
- **Example**: "AP CS A - Fall 2024 - Period 3"
- **Key Fields**: `name`, `display_name`, `year`
- **Relationships**: Belongs to one course, linked to scripts via course_scripts

#### `course_versions` (CourseVersion) - Course Version Definitions
- **Purpose**: Different versions of a course (e.g., 2023 vs 2024)
- **Example**: "AP CS A 2024 version"
- **Key Fields**: `name`, `version`, `content_root_id`
- **Relationships**: Belongs to one course_offering, has content_root_id

#### `objectives` (Objective) - Lesson Objectives
- **Purpose**: Learning objectives for specific lessons
- **Example**: "Students will understand loops"
- **Key Fields**: `name`, `description`, `position`
- **Relationships**: Belongs to one lesson (stage)

#### `programming_expressions` (ProgrammingExpression) - Programming Language Elements
- **Purpose**: Programming language expressions and concepts
- **Example**: "for loop", "if statement", "variable"
- **Key Fields**: `name`, `category`, `description`
- **Relationships**: Used by lessons via lessons_programming_expressions

#### `rubrics` (Rubric) - Assessment Rubrics
- **Purpose**: Assessment rubrics for lessons and levels
- **Example**: "Code quality rubric for Maze levels"
- **Key Fields**: `name`, `description`
- **Relationships**: Belongs to one lesson and one level

#### `learning_goals` (LearningGoal) - Learning Goals for Rubrics
- **Purpose**: Specific learning goals within rubrics
- **Example**: "Student demonstrates proper loop usage"
- **Key Fields**: `name`, `description`, `position`
- **Relationships**: Belongs to one rubric

### 2. Curriculum Organization (3 tables)

#### `unit_groups` (UnitGroup) - Curriculum Families
- **Purpose**: Groups of related scripts/courses
- **Example**: "CS Fundamentals" family
- **Key Fields**: `name`, `title`, `description`
- **Relationships**: Contains many scripts, has resources

#### `script_levels` (ScriptLevel) - Level Roadmap
- **Purpose**: Defines the sequence of levels in a script
- **Example**: "CS Discoveries level 1 is Maze: Move Forward"
- **Key Fields**: `position`, `chapter`, `bonus`, `challenge`
- **Relationships**: Belongs to one script, references one level

#### `levels_script_levels` (LevelsScriptLevel) - Complex Level Relationships
- **Purpose**: Join table for complex level dependencies
- **Example**: "Level A must be completed before Level B"
- **Key Fields**: `position`, `kind`
- **Relationships**: Links levels to script_levels

### 3. Curriculum Resources (8 tables)

#### `course_scripts` (CourseScript) - Course-Script Links
- **Purpose**: Links courses to scripts
- **Example**: "AP CS A includes CS Principles script"
- **Key Fields**: `position`
- **Relationships**: Links courses to scripts

#### `unit_groups_resources` (UnitGroupResource) - Unit Group Resources
- **Purpose**: Resources for unit groups
- **Example**: "CS Fundamentals teacher guide"
- **Key Fields**: `name`, `url`, `type`
- **Relationships**: Belongs to one unit_group

#### `unit_groups_student_resources` (UnitGroupStudentResource) - Student Resources
- **Purpose**: Student-facing resources for unit groups
- **Example**: "CS Fundamentals student reference"
- **Key Fields**: `name`, `url`, `type`
- **Relationships**: Belongs to one unit_group

#### `scripts_resources` (ScriptResource) - Script Resources
- **Purpose**: Resources for scripts
- **Example**: "CS Discoveries teacher guide"
- **Key Fields**: `name`, `url`, `type`
- **Relationships**: Belongs to one script

#### `scripts_student_resources` (ScriptStudentResource) - Student Script Resources
- **Purpose**: Student-facing resources for scripts
- **Example**: "CS Discoveries student reference"
- **Key Fields**: `name`, `url`, `type`
- **Relationships**: Belongs to one script

#### `lessons_resources` (LessonResource) - Lesson Resources
- **Purpose**: Resources for lessons
- **Example**: "Problem Solving worksheet"
- **Key Fields**: `name`, `url`, `type`
- **Relationships**: Belongs to one stage (lesson)

#### `stages_standards` (StageStandard) - Standards Alignment
- **Purpose**: Educational standards alignment for lessons
- **Example**: "CSTA 1A-AP-14 alignment"
- **Key Fields**: `standard_code`, `description`
- **Relationships**: Belongs to one stage (lesson)

#### `lessons_vocabularies` (LessonVocabulary) - Lesson Vocabulary
- **Purpose**: Vocabulary terms for lessons
- **Example**: "Problem Solving terms"
- **Key Fields**: `word`, `definition`
- **Relationships**: Belongs to one stage (lesson)

### 4. Curriculum Join Tables (3 tables)

#### `lessons_programming_expressions` (LessonsProgrammingExpression) - Lesson-Programming Expression Links
- **Purpose**: Join table linking lessons to programming expressions
- **Example**: "Lesson 1 uses for loops and variables"
- **Key Fields**: `position`
- **Relationships**: Links lessons to programming_expressions

#### `learning_goal_evidence_levels` (LearningGoalEvidenceLevel) - Evidence Levels for Learning Goals
- **Purpose**: Evidence levels for assessing learning goals
- **Example**: "Novice, Developing, Proficient, Advanced"
- **Key Fields**: `name`, `description`, `position`
- **Relationships**: Belongs to one learning_goal

#### `lessons_opportunity_standards` (LessonsOpportunityStandard) - Opportunity Standards for Lessons
- **Purpose**: Opportunity standards linked to lessons
- **Example**: "CSTA 1A-AP-14 opportunity standard"
- **Key Fields**: `standard_code`, `description`
- **Relationships**: Links lessons to opportunity standards

## Excluded Tables (Keep ID-Based)

### User Progress Tables (4 tables)
- **`user_levels`** - Student progress on coding challenges
- **`user_scripts`** - Student progress on curriculum courses  
- **`activities`** - Student interactions and attempts
- **`user_level_interactions`** - Additional student interactions

**Why excluded**: These contain `user_id` and are transactional data, not curriculum content. They should remain ID-based for performance.

## Data Flow Through the System

### Student Learning Journey
1. **Enrollment**: Student enrolled in script via `user_scripts`
2. **Lesson Progression**: Student works through lessons in `stages`
3. **Activity Completion**: Student completes activities in `lesson_activities`
4. **Level Mastery**: Student completes levels in `levels` via `script_levels`
5. **Progress Tracking**: All progress tracked in `user_levels` and `user_scripts`

### Teacher Management
1. **Course Planning**: Teachers assign scripts to courses via `course_scripts`
2. **Lesson Delivery**: Teachers use lesson plans from `stages` and `lesson_activities`
3. **Resource Access**: Teachers access materials via `scripts_resources` and `lessons_resources`
4. **Progress Monitoring**: Teachers track student progress via `user_levels` and `user_scripts`

### Curriculum Development
1. **Script Creation**: Curriculum developers create scripts in `scripts`
2. **Lesson Design**: Developers create lessons in `stages` and activities in `lesson_activities`
3. **Level Sequencing**: Developers define level order via `script_levels`
4. **Resource Integration**: Developers add materials via `scripts_resources` and `lessons_resources`
5. **Standards Alignment**: Developers align content to standards via `stages_standards`

## GUID Migration Status

The curriculum system is currently undergoing a migration from ID-based to GUID-based relationships. This migration includes:

- **Phase 1**: Add GUID columns to all 27 curriculum tables ✅
- **Phase 2**: Create mapping tables and export/import system ✅
- **Phase 3**: Switch to GUID-based seeding (in progress)
- **Phase 4**: Cleanup old ID columns (planned)

For more details on the GUID migration, see [experimental/curriculum_guid_migration/README.md](../../experimental/curriculum_guid_migration/README.md).

## Related Documentation

- [User-Facing Views](../curriculum/views/) - Documentation of all user-facing curriculum pages
- [Level Builder Views](../curriculum/level-builder/) - Documentation of curriculum editing interfaces
- [GUID Migration Plan](../../experimental/curriculum_guid_migration/README.md) - Detailed migration documentation