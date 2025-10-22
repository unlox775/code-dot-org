# Curriculum Table Relationships Diagram

**Created**: 2025-10-17  
**Purpose**: Visual representation of how curriculum tables connect to each other  

## 🎯 **Core Curriculum Hierarchy**

```
Unit Groups (unit_groups)
    └── Scripts (scripts) - Complete curriculum units
        ├── Lesson Groups (lesson_groups) - Chapters within scripts
        │   └── Lessons (stages) - Individual learning sessions
        │       ├── Lesson Activities (lesson_activities) - Hands-on exercises
        │       │   └── Activity Sections (activity_sections) - Steps within activities
        │       ├── Lesson Resources (lessons_resources) - Lesson-specific materials
        │       └── Standards Alignment (stages_standards) - Educational standards
        ├── Script Levels (script_levels) - Level sequence within scripts
        │   └── Levels (levels) - Individual coding challenges
        │       └── Levels Script Levels (levels_script_levels) - Complex relationships
        └── Script Resources (scripts_resources) - Script-specific materials
```

## 🏫 **Course Management Structure**

```
Academic Courses (courses) - Course definitions
    └── Course Offerings (course_offerings) - Specific instances
        └── Course Scripts (course_scripts) - Scripts included in courses
            └── Scripts (scripts) - Curriculum content
```

## 👥 **User Progress Tracking**

```
Students (users)
├── User Scripts (user_scripts) - Script enrollment and progress
│   └── Scripts (scripts) - What they're learning
└── User Levels (user_levels) - Level completion and performance
    └── Levels (levels) - What they've accomplished
```

## 🔗 **Key Relationships Explained**

### **1. Scripts → Stages (1:many)**
- **What it means**: Each script contains many lessons
- **Real-world**: "CS Discoveries" has 20+ lessons like "Problem Solving", "Web Development"
- **Why important**: Students work through lessons in order to complete a script

### **2. Scripts → Script Levels (1:many)**
- **What it means**: Each script has a specific sequence of coding levels
- **Real-world**: "CS Discoveries" starts with "Maze: Move Forward", then "Dance Party"
- **Why important**: This defines the learning progression and difficulty curve

### **3. Stages → Lesson Activities (1:many)**
- **What it means**: Each lesson contains multiple activities
- **Real-world**: "Problem Solving" lesson has "Brainstorming", "Solution Testing", "Reflection"
- **Why important**: Activities are where students actually engage with content

### **4. User Scripts → Scripts (many:1)**
- **What it means**: Students can be enrolled in multiple scripts
- **Real-world**: A student might be in "CS Discoveries" and "CS Principles" simultaneously
- **Why important**: Tracks which curricula students are working on

### **5. User Levels → Levels (many:1)**
- **What it means**: Students complete many levels across different scripts
- **Real-world**: A student completes "Maze: Move Forward" in "CS Discoveries" and "CS Principles"
- **Why important**: Tracks individual level completion and performance

### **6. Courses → Course Scripts → Scripts (1:many:many)**
- **What it means**: Academic courses can include multiple scripts
- **Real-world**: "AP Computer Science A" includes "Programming Fundamentals" and "Data Structures"
- **Why important**: Ensures academic courses have appropriate curriculum content

## 📊 **Data Flow Through the System**

### **Student Learning Journey**
1. **Enrollment**: Student enrolled in script via `user_scripts`
2. **Lesson Progression**: Student works through lessons in `stages`
3. **Activity Completion**: Student completes activities in `lesson_activities`
4. **Level Mastery**: Student completes levels in `levels` via `script_levels`
5. **Progress Tracking**: All progress tracked in `user_levels` and `user_scripts`

### **Teacher Management**
1. **Course Planning**: Teachers assign scripts to courses via `course_scripts`
2. **Lesson Delivery**: Teachers use lesson plans from `stages` and `lesson_activities`
3. **Resource Access**: Teachers access materials via `scripts_resources` and `lessons_resources`
4. **Progress Monitoring**: Teachers track student progress via `user_levels` and `user_scripts`

### **Curriculum Development**
1. **Script Creation**: Curriculum developers create scripts in `scripts`
2. **Lesson Design**: Developers create lessons in `stages` and activities in `lesson_activities`
3. **Level Sequencing**: Developers define level order via `script_levels`
4. **Resource Integration**: Developers add materials via `scripts_resources` and `lessons_resources`
5. **Standards Alignment**: Developers align content to standards via `stages_standards`

## 🎯 **GUID Migration Impact**

### **Primary Tables (Need GUIDs)**
- `scripts`, `stages`, `levels`, `lesson_groups`
- `lesson_activities`, `activity_sections`
- `courses`, `course_offerings`, `unit_groups`
- `script_levels`, `levels_script_levels`
- `user_levels`, `user_scripts`

### **Foreign Key Updates Needed**
- All `*_id` columns need corresponding `*_guid` columns
- All foreign key constraints need to reference GUIDs
- All application code needs to use GUIDs for lookups

### **Relationship Preservation**
- All existing relationships must be maintained
- GUID foreign keys must point to correct GUID primary keys
- Data integrity must be preserved during migration

This diagram shows how the curriculum system is structured and how data flows through it, which is essential for understanding the GUID migration requirements.