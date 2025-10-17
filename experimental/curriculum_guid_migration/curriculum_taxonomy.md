# Curriculum Data Taxonomy

**Purpose**: Define what each table actually represents in the curriculum system  
**Method**: Deep code analysis, model examination, and real-world understanding  
**Status**: In Progress  

## 🎯 Core Curriculum Entities

### **Units (Scripts)**
- **Table**: `units` (formerly `scripts`)
- **Purpose**: Top-level curriculum containers (e.g., "CS Discoveries", "CS Principles")
- **Real-world meaning**: A complete course or curriculum track
- **Key relationships**: Contains lessons, has course associations

### **Lessons (Stages)**
- **Table**: `stages` (formerly `lessons`)
- **Purpose**: Individual lessons within a unit
- **Real-world meaning**: A single class session or learning activity
- **Key relationships**: Belongs to unit, contains activities

### **Activities**
- **Table**: `lesson_activities`
- **Purpose**: Specific learning activities within a lesson
- **Real-world meaning**: Hands-on exercises, coding challenges, discussions
- **Key relationships**: Belongs to lesson, has activity sections

### **Levels**
- **Table**: `levels`
- **Purpose**: Individual coding challenges or exercises
- **Real-world meaning**: A specific puzzle, game, or coding task
- **Key relationships**: Used in activities, has user progress tracking

## 🔗 Relationship Tables

### **Script Levels**
- **Table**: `script_levels`
- **Purpose**: Join table connecting units to levels
- **Real-world meaning**: Which levels appear in which units, in what order
- **Key relationships**: Links units to levels, defines sequence

### **Lesson Activities**
- **Table**: `lesson_activities`
- **Purpose**: Join table connecting lessons to activities
- **Real-world meaning**: Which activities are in which lessons
- **Key relationships**: Links lessons to activities, defines order

## 📚 Content Tables

### **Resources**
- **Table**: `resources`
- **Purpose**: Learning materials (videos, documents, images)
- **Real-world meaning**: Teacher guides, student handouts, reference materials
- **Key relationships**: Associated with lessons or units

### **Vocabularies**
- **Table**: `vocabularies`
- **Purpose**: Key terms and definitions
- **Real-world meaning**: Glossary items, technical terms
- **Key relationships**: Associated with lessons

### **Standards**
- **Table**: `standards`
- **Purpose**: Educational standards alignment
- **Real-world meaning**: CSTA standards, Common Core alignment
- **Key relationships**: Associated with lessons

## 👥 User Progress Tables

### **User Levels**
- **Table**: `user_levels`
- **Purpose**: Track student progress through levels
- **Real-world meaning**: Which levels a student has completed, their scores
- **Key relationships**: Links users to levels, tracks completion

### **User Scripts**
- **Table**: `user_scripts`
- **Purpose**: Track student progress through units
- **Real-world meaning**: Which units a student is enrolled in, completion status
- **Key relationships**: Links users to units, tracks progress

## 🏫 Course Management Tables

### **Courses**
- **Table**: `courses`
- **Purpose**: Academic course definitions
- **Real-world meaning**: School courses like "AP Computer Science"
- **Key relationships**: Contains units, has course offerings

### **Course Offerings**
- **Table**: `course_offerings`
- **Purpose**: Specific instances of courses
- **Real-world meaning**: "AP CS A - Fall 2024 - Period 3"
- **Key relationships**: Belongs to course, has students

## 📊 Assessment Tables

### **Rubrics**
- **Table**: `rubrics`
- **Purpose**: Assessment rubrics for activities
- **Real-world meaning**: Grading criteria, learning objectives
- **Key relationships**: Associated with activities

### **Learning Goals**
- **Table**: `learning_goals`
- **Purpose**: Specific learning objectives
- **Real-world meaning**: What students should learn from an activity
- **Key relationships**: Belongs to rubrics

## 🔍 Analysis Status

- [ ] **Units/Scripts**: Need to verify table name and structure
- [ ] **Lessons/Stages**: Need to verify table name and structure  
- [ ] **Activities**: Need to verify table name and structure
- [ ] **Levels**: Need to verify table name and structure
- [ ] **User Progress**: Need to verify all user tracking tables
- [ ] **Resources**: Need to verify content tables
- [ ] **Standards**: Need to verify standards alignment tables

## 📋 Next Steps

1. **Run all analysis scripts** to get current state
2. **Examine actual database schema** to verify table names
3. **Read model files** to understand relationships
4. **Update taxonomy** based on real findings
5. **Create definitive curriculum table list** for migration