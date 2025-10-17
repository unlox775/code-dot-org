# AI Analysis of Model Files

**Source**: `/workspace/dashboard/app/models/`  
**Analysis Date**: 2025-10-17  
**Method**: Direct model file examination  

## 🎯 **Model-to-Table Mapping Discovered**

### **Core Curriculum Models**

1. **`Unit`** → `scripts` table
   - **Purpose**: Top-level curriculum containers
   - **Real-world meaning**: Complete curriculum units (e.g., "CS Discoveries")
   - **Key relationships**: `has_many :lessons`, `has_many :script_levels`

2. **`Lesson`** → `stages` table
   - **Purpose**: Individual lessons within units
   - **Real-world meaning**: Single class sessions or learning activities
   - **Key relationships**: `belongs_to :unit`, `has_many :lesson_activities`

3. **`Level`** → `levels` table
   - **Purpose**: Individual coding challenges
   - **Real-world meaning**: Specific puzzles, games, or coding tasks
   - **Key relationships**: `has_many :script_levels`, `has_many :user_levels`

4. **`LessonGroup`** → `lesson_groups` table
   - **Purpose**: Groups of lessons within units
   - **Real-world meaning**: Chapters or units within a curriculum
   - **Key relationships**: `belongs_to :unit`, `has_many :lessons`

### **Activity Models**

5. **`LessonActivity`** → `lesson_activities` table
   - **Purpose**: Activities within lessons
   - **Real-world meaning**: Hands-on exercises or discussions
   - **Key relationships**: `belongs_to :lesson`, `has_many :activity_sections`

6. **`ActivitySection`** → `activity_sections` table
   - **Purpose**: Sections within activities
   - **Real-world meaning**: Steps within an activity
   - **Key relationships**: `belongs_to :lesson_activity`

### **Join Table Models**

7. **`ScriptLevel`** → `script_levels` table
   - **Purpose**: Join table linking units to levels
   - **Real-world meaning**: Which levels appear in which units, in what order
   - **Key relationships**: `belongs_to :unit`, `belongs_to :level`

8. **`LevelsScriptLevel`** → `levels_script_levels` table
   - **Purpose**: Join table for levels and script levels
   - **Real-world meaning**: Additional level relationships
   - **Key relationships**: `belongs_to :level`, `belongs_to :script_level`

### **Course Management Models**

9. **`Course`** → `courses` table
   - **Purpose**: Academic course definitions
   - **Real-world meaning**: "AP Computer Science", "Intro to CS"
   - **Key relationships**: `has_many :course_offerings`

10. **`CourseOffering`** → `course_offerings` table
    - **Purpose**: Specific instances of courses
    - **Real-world meaning**: "AP CS A - Fall 2024 - Period 3"
    - **Key relationships**: `belongs_to :course`

11. **`UnitGroup`** → `unit_groups` table
    - **Purpose**: Groups of related units
    - **Real-world meaning**: Collections of related curricula
    - **Key relationships**: `has_many :units`

### **User Progress Models**

12. **`UserLevel`** → `user_levels` table
    - **Purpose**: Student progress through levels
    - **Real-world meaning**: Which levels students have completed, their scores
    - **Key relationships**: `belongs_to :user`, `belongs_to :level`

13. **`UserScript`** → `user_scripts` table
    - **Purpose**: Student progress through units
    - **Real-world meaning**: Which units students are enrolled in, completion status
    - **Key relationships**: `belongs_to :user`, `belongs_to :unit`

## 🔍 **Key Discoveries**

### **1. Naming Convention Confirmed**
- **`Unit`** (model) = `scripts` (table) = Our "Units"
- **`Lesson`** (model) = `stages` (table) = Our "Lessons"
- **`Level`** (model) = `levels` (table) = Our "Levels"

### **2. Model Relationships**
The curriculum system follows this hierarchy:
```
Unit (scripts)
├── LessonGroup (lesson_groups)
│   └── Lesson (stages)
│       └── LessonActivity (lesson_activities)
│           └── ActivitySection (activity_sections)
└── ScriptLevel (script_levels)
    └── Level (levels)
```

### **3. User Progress Tracking**
- **`UserLevel`** tracks individual level completion
- **`UserScript`** tracks unit enrollment and completion
- Both are essential for student progress tracking

### **4. Course Management**
- **`Course`** defines academic courses
- **`CourseOffering`** represents specific instances
- **`UnitGroup`** organizes related units

## 📊 **Updated Curriculum Table List (Definitive)**

### **Primary Curriculum Tables (13)**
1. `scripts` (Unit model) - Top-level curriculum containers
2. `stages` (Lesson model) - Individual lessons
3. `levels` (Level model) - Coding challenges
4. `lesson_groups` (LessonGroup model) - Groups of lessons
5. `lesson_activities` (LessonActivity model) - Activities within lessons
6. `activity_sections` (ActivitySection model) - Sections within activities
7. `courses` (Course model) - Academic course definitions
8. `course_offerings` (CourseOffering model) - Specific course instances
9. `unit_groups` (UnitGroup model) - Groups of related units
10. `script_levels` (ScriptLevel model) - Join table (units ↔ levels)
11. `levels_script_levels` (LevelsScriptLevel model) - Additional level relationships
12. `user_levels` (UserLevel model) - Student progress through levels
13. `user_scripts` (UserScript model) - Student progress through units

### **Secondary Tables (7)**
- `course_scripts` - Join table (courses ↔ units)
- `unit_groups_resources` - Resources for unit groups
- `unit_groups_student_resources` - Student resources
- `scripts_resources` - Resources for units
- `scripts_student_resources` - Student resources for units
- `stages_standards` - Standards alignment
- `lessons_resources` - Resources for lessons

## 🎯 **Migration Strategy (Updated)**

### **Phase 1: Core Curriculum Structure (13 tables)**
Focus on the primary curriculum tables:
- `scripts`, `stages`, `levels`, `lesson_groups`
- `lesson_activities`, `activity_sections`
- `courses`, `course_offerings`, `unit_groups`
- `script_levels`, `levels_script_levels`
- `user_levels`, `user_scripts`

### **Phase 2: Secondary Tables (7 tables)**
Add join tables and resource tables:
- All `*_resources` tables
- All `*_scripts` join tables
- Standards alignment tables

### **Phase 3: Content Tables**
Add content-related tables:
- `resources`, `vocabularies`, `standards`
- `rubrics`, `learning_goals`, `objectives`

## ✅ **Confidence Assessment**

**High Confidence (95%+)**: Core curriculum structure is now definitively clear
**Medium Confidence (80-94%)**: Secondary tables are well-defined
**Low Confidence (<80%)**: Content tables need further analysis

## 🚀 **Next Steps**

1. **Verify all 20 tables exist** in the database
2. **Check foreign key relationships** between tables
3. **Test with actual data** to ensure completeness
4. **Update migration plan** based on this analysis
5. **Create definitive curriculum table list** for GUID migration

This model analysis provides the definitive curriculum structure for the GUID migration.