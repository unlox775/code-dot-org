# CLEAR Curriculum Tables for GUID Migration

**Created**: 2025-10-17  
**Purpose**: Simple, clear explanation of what each table means and how they connect  

## 🎯 **The Big Picture**

Think of the curriculum system like a school:
- **Scripts** = Complete courses (like "CS Discoveries")
- **Stages** = Individual lessons within those courses
- **Levels** = Specific coding challenges students do
- **Students** = Track their progress through everything

## 📚 **Core Tables**

### **1. `scripts` - Complete Curriculum Courses**

**What it really is**: A full curriculum program that students can take, like "CS Discoveries" or "CS Principles". Think of it as a complete textbook or course syllabus.

**Real-world example**: "CS Discoveries" is a script that teaches computer science to middle school students over a full school year.

**How it connects to other things**:
- **Contains many stages** (lessons) - Students work through lessons in order
- **Contains many script_levels** (coding challenges) - Students complete coding puzzles
- **Students enroll in scripts** - Teachers assign students to specific scripts
- **Can be grouped into unit_groups** - Related scripts can be organized together

---

### **2. `stages` - Individual Lessons**

**What it really is**: A single lesson within a script, like "Introduction to Problem Solving" or "Creating Interactive Stories". Each lesson typically lasts one class period.

**Real-world example**: In "CS Discoveries", there's a lesson called "Problem Solving" where students learn to break down complex problems into smaller steps.

**How it connects to other things**:
- **Belongs to one script** - Each lesson is part of a specific curriculum course
- **Can belong to a lesson_group** - Lessons are organized into chapters or units
- **Contains lesson_activities** - Each lesson has hands-on exercises students do
- **Has lesson_resources** - Teachers get handouts and materials for each lesson
- **Students progress through stages** - We track which lessons students have completed

---

### **3. `levels` - Coding Challenges**

**What it really is**: Individual coding puzzles, games, or exercises that students complete. These are the actual "work" students do.

**Real-world example**: "Maze: Move Forward" is a level where students write code to make a character move through a maze.

**How it connects to other things**:
- **Appears in scripts via script_levels** - Each script has a specific sequence of levels
- **Students complete levels** - We track when students finish each coding challenge
- **Can have complex relationships** - Some levels depend on others or behave differently in different contexts

---

### **4. `lesson_groups` - Chapters or Units**

**What it really is**: Groups of related lessons within a script, like chapters in a textbook.

**Real-world example**: In "CS Discoveries", there might be a lesson group called "Unit 1: Problem Solving" that contains 5 related lessons about problem-solving techniques.

**How it connects to other things**:
- **Belongs to one script** - Each chapter is part of a specific curriculum
- **Contains many stages** - Each chapter has multiple lessons
- **Can have shared resources** - All lessons in a chapter might share some materials

---

### **5. `lesson_activities` - Hands-on Exercises**

**What it really is**: Specific activities students do within a lesson, like group discussions, coding exercises, or projects.

**Real-world example**: In the "Problem Solving" lesson, students might do a "Brainstorming Solutions" activity where they work in groups to come up with different approaches to a problem.

**How it connects to other things**:
- **Belongs to one stage** - Each activity is part of a specific lesson
- **Can have activity_sections** - Complex activities are broken into steps
- **Students complete activities** - We track which activities students have finished

---

### **6. `activity_sections` - Steps Within Activities**

**What it really is**: Individual steps or parts of an activity that students complete in order.

**Real-world example**: The "Brainstorming Solutions" activity might have steps like "Step 1: Read the problem", "Step 2: List possible solutions", "Step 3: Evaluate each solution".

**How it connects to other things**:
- **Belongs to one lesson_activity** - Each step is part of a specific activity
- **Students complete sections** - We track which steps students have finished

---

### **7. `courses` - Academic Course Definitions**

**What it really is**: Formal academic courses that schools can offer, like "AP Computer Science A" or "Introduction to Computer Science".

**Real-world example**: "AP Computer Science A" is a college-level course that high school students can take for college credit.

**How it connects to other things**:
- **Has many course_offerings** - Schools can offer the same course multiple times
- **Can include multiple scripts** - A course might use several different curricula
- **Students enroll in courses** - This is how students get academic credit

---

### **8. `course_offerings` - Actual Course Instances**

**What it really is**: Specific instances of courses being taught, like "AP Computer Science A - Fall 2024 - Period 3".

**Real-world example**: "AP Computer Science A - Fall 2024 - Period 3" is a specific class with a specific teacher, specific students, and specific schedule.

**How it connects to other things**:
- **Belongs to one course** - Each offering is an instance of a specific academic course
- **Has specific students** - Students are enrolled in specific offerings
- **Uses specific scripts** - Each offering uses particular curricula

---

### **9. `unit_groups` - Curriculum Families**

**What it really is**: Groups of related scripts that work together, like a complete computer science program.

**Real-world example**: "CS Fundamentals" might be a unit group that includes scripts for different grade levels (K-1, 2-3, 4-5) that all teach basic computer science concepts.

**How it connects to other things**:
- **Contains many scripts** - Each family has multiple related curricula
- **Students progress through unit_groups** - We track student progress across related curricula
- **Can have shared resources** - All scripts in a family might share some materials

---

### **10. `script_levels` - Curriculum Roadmap**

**What it really is**: The roadmap that shows which coding levels students will encounter in each script and in what order.

**Real-world example**: In "CS Discoveries", students start with "Maze: Move Forward" (level 1), then "Maze: Turn Left" (level 2), then "Dance Party: Introduction" (level 3), and so on.

**How it connects to other things**:
- **Belongs to one script** - Each roadmap is for a specific curriculum
- **References one level** - Each roadmap entry points to a specific coding challenge
- **Students follow script_levels** - Students complete levels in the order defined by the roadmap

---

### **11. `user_levels` - Student Progress on Coding Challenges**

**What it really is**: Tracks each student's progress and performance on individual coding levels.

**Real-world example**: "Student John completed Maze: Move Forward on 2024-10-15 with a score of 100% after 3 attempts, spending 15 minutes total."

**How it connects to other things**:
- **Belongs to one user** - Each record is for a specific student
- **References one level** - Each record is for a specific coding challenge
- **Belongs to one script** - We track which curriculum the student was working on
- **Belongs to one unit_group** - We also track which curriculum family

---

### **12. `user_scripts` - Student Progress on Curriculum Courses**

**What it really is**: Tracks each student's enrollment and progress through entire curriculum courses.

**Real-world example**: "Student Sarah enrolled in CS Discoveries on 2024-09-01, started working on it on 2024-09-03, and completed it on 2024-12-15."

**How it connects to other things**:
- **Belongs to one user** - Each record is for a specific student
- **References one script** - Each record is for a specific curriculum course
- **Belongs to one unit_group** - We also track which curriculum family

---

## 🔗 **How It All Works Together**

### **Student Learning Journey**
1. **Student enrolls** in a script (via `user_scripts`)
2. **Student works through** lessons in order (via `stages`)
3. **Student completes** activities within lessons (via `lesson_activities`)
4. **Student masters** coding levels (via `user_levels`)
5. **Everything is tracked** so teachers can see progress

### **Teacher Management**
1. **Teacher assigns** students to scripts
2. **Teacher uses** lesson plans and resources
3. **Teacher tracks** student progress
4. **Teacher adjusts** instruction based on progress

### **Curriculum Development**
1. **Developers create** scripts with lessons and levels
2. **Developers organize** lessons into chapters
3. **Developers sequence** coding challenges
4. **Developers provide** resources and materials

## 🎯 **GUID Migration Strategy**

### **Phase 1: Core Structure (4 tables)**
- `scripts` - The main curriculum courses
- `stages` - The lessons within courses
- `levels` - The coding challenges
- `lesson_groups` - The chapters that organize lessons

### **Phase 2: Activities (2 tables)**
- `lesson_activities` - The hands-on exercises
- `activity_sections` - The steps within exercises

### **Phase 3: Course Management (3 tables)**
- `courses` - Academic course definitions
- `course_offerings` - Actual course instances
- `unit_groups` - Curriculum families

### **Phase 4: Progress Tracking (2 tables)**
- `user_levels` - Student progress on coding challenges
- `user_scripts` - Student progress on curriculum courses

### **Phase 5: Roadmaps (1 table)**
- `script_levels` - The roadmap of which levels appear in which scripts

### **Phase 6: Resources and Standards (8 tables)**
- All the resource and standards tables that add content and alignment

## ✅ **Why This Makes Sense**

Each table has a clear purpose:
- **Scripts** = The big picture (complete courses)
- **Stages** = The lessons (what students do each day)
- **Levels** = The coding work (the actual challenges)
- **Everything else** = Supporting the core learning experience

The relationships are simple:
- **Scripts contain stages** (courses have lessons)
- **Stages contain activities** (lessons have exercises)
- **Scripts have levels** (courses have coding challenges)
- **Students progress through everything** (we track their learning)

This is the foundation for the GUID migration - we need to add GUIDs to all these tables so they can be uniquely identified across different environments.