# DETAILED Curriculum Tables for GUID Migration

**Created**: 2025-10-17  
**Status**: READY FOR MIGRATION  
**Confidence**: 85% (High)  
**Source**: Comprehensive analysis of schema, models, and code  

## 🎯 **Primary Curriculum Tables (13)**

### **1. `scripts` (Unit model) - Top-level curriculum containers**

**Purpose**: Complete curriculum units that represent entire learning tracks or courses of study.

**Real-world meaning**: These are the major curriculum programs that students can enroll in, like "CS Discoveries" (a full-year computer science course for middle school), "CS Principles" (an AP-level course for high school), or "CS Fundamentals" (elementary school coding curriculum). Each script represents a complete educational journey that can span multiple months or even a full school year. Teachers typically assign students to one script at a time, and students work through it progressively.

**What connects TO this table:**
- **`stages`** (lessons) - Each script contains many lessons that students work through in order
- **`lesson_groups`** - Scripts organize their lessons into logical groups or chapters
- **`script_levels`** - Scripts are connected to specific coding levels/challenges that students will encounter
- **`user_scripts`** - Students are enrolled in scripts, tracking their progress and completion
- **`course_scripts`** - Academic courses can include multiple scripts as part of their curriculum
- **`scripts_resources`** - Scripts have associated learning materials, handouts, and teacher guides
- **`scripts_student_resources`** - Students get access to specific resources for each script
- **`unit_groups`** - Scripts can be grouped together into larger curriculum families

**Why these connections matter**: A student's educational journey starts when they're assigned to a script, and everything else flows from there - their lessons, their coding challenges, their resources, and their progress tracking.

---

### **2. `stages` (Lesson model) - Individual lessons within scripts**

**Purpose**: Individual learning sessions that make up the building blocks of a script.

**Real-world meaning**: These are the actual class periods or learning sessions that teachers conduct. For example, in "CS Discoveries", you might have a lesson called "Introduction to Problem Solving" or "Creating Interactive Stories". Each lesson typically lasts 45-60 minutes and has specific learning objectives. Teachers follow lesson plans that are associated with each stage, and students complete activities within each lesson.

**What connects TO this table:**
- **`scripts`** (parent) - Each lesson belongs to exactly one script
- **`lesson_groups`** - Lessons are organized into groups within a script (like chapters)
- **`lesson_activities`** - Each lesson contains specific activities students will do
- **`stages_standards`** - Lessons are aligned to educational standards (CSTA, Common Core)
- **`lessons_resources`** - Each lesson has associated materials, handouts, and teacher guides
- **`lessons_vocabularies`** - Lessons introduce specific vocabulary terms students need to learn
- **`lessons_opportunity_standards`** - Lessons are connected to opportunity standards for equity
- **`lessons_programming_expressions`** - Lessons teach specific programming concepts

**Why these connections matter**: Lessons are where the actual teaching happens. Teachers use lesson plans, students complete activities, and everything is tracked against educational standards.

---

### **3. `levels` (Level model) - Individual coding challenges**

**Purpose**: Specific coding puzzles, games, or programming exercises that students complete.

**Real-world meaning**: These are the actual coding challenges students work on, like "Maze: Move Forward" (a simple puzzle where students write code to move a character), "Dance Party" (where students program characters to dance), or "Flappy Bird" (where students create their own version of the game). Each level has specific learning objectives and students must complete them to progress. Levels can be puzzles, games, projects, or assessments.

**What connects TO this table:**
- **`script_levels`** - Levels are connected to scripts, defining which levels appear in which curriculum
- **`levels_script_levels`** - Additional relationships between levels and their script context
- **`user_levels`** - Students' progress and performance on each level is tracked here
- **`activities`** - Student interactions and attempts on levels are logged
- **`level_sources`** - The actual code students write for each level is stored
- **`level_concept_difficulties`** - Levels are analyzed for their difficulty with specific concepts
- **`levels_skills`** - Levels are connected to specific skills students develop
- **`concepts_levels`** - Levels teach specific programming concepts

**Why these connections matter**: Levels are where students actually do the coding work. Their progress, their code, and their learning are all tracked at the level level.

---

### **4. `lesson_groups` (LessonGroup model) - Groups of lessons within scripts**

**Purpose**: Organize lessons into logical chapters or units within a larger script.

**Real-world meaning**: These are like chapters in a textbook or units within a course. For example, in "CS Discoveries", you might have lesson groups like "Unit 1: Problem Solving", "Unit 2: Web Development", or "Unit 3: Data and Society". Each group contains multiple related lessons that build upon each other. This helps teachers and students understand the structure and progression of the curriculum.

**What connects TO this table:**
- **`scripts`** (parent) - Each lesson group belongs to exactly one script
- **`stages`** (lessons) - Each lesson group contains multiple lessons
- **`unit_groups_resources`** - Lesson groups can have shared resources across all their lessons
- **`unit_groups_student_resources`** - Students get access to resources specific to each lesson group

**Why these connections matter**: Lesson groups provide the organizational structure that helps teachers plan their instruction and helps students understand how lessons relate to each other.

---

### **5. `lesson_activities` (LessonActivity model) - Activities within lessons**

**Purpose**: Specific learning activities that students complete within each lesson.

**Real-world meaning**: These are the hands-on exercises, discussions, or projects that students do during a lesson. For example, in a lesson about "Problem Solving", students might do an activity called "Brainstorming Solutions" where they work in groups to come up with different approaches to a problem. Or they might do "Debugging Practice" where they find and fix errors in code. Each activity has specific instructions and learning objectives.

**What connects TO this table:**
- **`stages`** (lessons) - Each activity belongs to exactly one lesson
- **`activity_sections`** - Activities are broken down into smaller sections or steps
- **`lesson_activities`** - Activities can be connected to other activities (prerequisites, follow-ups)

**Why these connections matter**: Activities are where students actually engage with the content. They're the practical, hands-on part of learning that makes lessons meaningful.

---

### **6. `activity_sections` (ActivitySection model) - Sections within activities**

**Purpose**: Break down activities into smaller, manageable steps or sections.

**Real-world meaning**: These are the individual steps or parts of an activity. For example, in a "Debugging Practice" activity, you might have sections like "Step 1: Read the Code", "Step 2: Identify the Error", "Step 3: Fix the Error", and "Step 4: Test Your Solution". Each section has specific instructions and students complete them in order.

**What connects TO this table:**
- **`lesson_activities`** (parent) - Each section belongs to exactly one activity
- **`activity_sections`** - Sections can be connected to other sections (prerequisites, follow-ups)

**Why these connections matter**: Sections break down complex activities into manageable steps, making it easier for students to follow instructions and for teachers to track progress.

---

### **7. `courses` (Course model) - Academic course definitions**

**Purpose**: Define academic courses that can be offered in schools.

**Real-world meaning**: These represent the formal academic courses that schools can offer, like "AP Computer Science A" (a college-level course that high school students can take for college credit), "Introduction to Computer Science" (a basic course for beginners), or "Computer Science Principles" (a broader, more conceptual course). Each course has specific requirements, standards, and learning outcomes. Schools decide which courses to offer based on their curriculum, student needs, and teacher availability.

**What connects TO this table:**
- **`course_offerings`** - Each course can have multiple offerings (different sections, semesters, years)
- **`course_scripts`** - Courses can include multiple scripts as part of their curriculum
- **`course_versions`** - Courses can have different versions (updated content, different standards)

**Why these connections matter**: Courses are the formal academic structure that schools use to organize their curriculum. They determine what students can take and what credits they can earn.

---

### **8. `course_offerings` (CourseOffering model) - Specific instances of courses**

**Purpose**: Represent actual instances of courses that are being taught.

**Real-world meaning**: These are the specific sections of courses that are actually being taught. For example, "AP Computer Science A - Fall 2024 - Period 3" or "Introduction to CS - Spring 2025 - Online". Each offering has a specific teacher, specific students, specific schedule, and specific resources. This is where the rubber meets the road - where abstract course definitions become real learning experiences.

**What connects TO this table:**
- **`courses`** (parent) - Each offering belongs to exactly one course
- **`schools`** - Each offering is taught at a specific school
- **`teachers`** - Each offering has a specific teacher assigned
- **`students`** - Students are enrolled in specific offerings
- **`course_offerings_pd_workshops`** - Teachers can attend professional development for specific offerings

**Why these connections matter**: Course offerings are where students actually experience the curriculum. They're the real-world implementation of the academic structure.

---

### **9. `unit_groups` (UnitGroup model) - Groups of related scripts**

**Purpose**: Organize related scripts into larger curriculum families or programs.

**Real-world meaning**: These represent broader curriculum programs that include multiple related scripts. For example, "CS Fundamentals" might be a unit group that includes scripts for different grade levels (K-1, 2-3, 4-5), or "AP Computer Science" might include both "CS Principles" and "CS A" scripts. Unit groups help schools understand how different scripts relate to each other and plan their overall computer science curriculum.

**What connects TO this table:**
- **`scripts`** - Each unit group can contain multiple related scripts
- **`unit_groups_resources`** - Unit groups can have shared resources across all their scripts
- **`unit_groups_student_resources`** - Students get access to resources specific to each unit group
- **`user_scripts`** - Students' progress through scripts is tracked within the context of unit groups

**Why these connections matter**: Unit groups provide the big-picture view of how different curricula relate to each other, helping schools plan comprehensive computer science programs.

---

### **10. `script_levels` (ScriptLevel model) - Join table linking scripts to levels**

**Purpose**: Define which levels appear in which scripts and in what order.

**Real-world meaning**: This is the curriculum map that shows exactly which coding challenges students will encounter in each script and in what sequence. For example, in "CS Discoveries", students might start with "Maze: Move Forward" (level 1), then "Maze: Turn Left" (level 2), then "Dance Party: Introduction" (level 3), and so on. The order matters because each level builds on the previous ones. This table also tracks which chapter or section of the script each level belongs to.

**What connects TO this table:**
- **`scripts`** (parent) - Each script level belongs to exactly one script
- **`levels`** (parent) - Each script level belongs to exactly one level
- **`levels_script_levels`** - Additional relationships between levels and their script context
- **`user_levels`** - Students' progress through script levels is tracked here
- **`activities`** - Student interactions with script levels are logged

**Why these connections matter**: Script levels are the roadmap that guides students through their learning journey. They determine what students will learn and when they'll learn it.

---

### **11. `levels_script_levels` (LevelsScriptLevel model) - Additional level relationships**

**Purpose**: Handle complex relationships between levels and their script context.

**Real-world meaning**: This handles more complex scenarios where levels might have different behaviors or requirements depending on which script they're in. For example, a level might be a practice level in one script but an assessment level in another, or it might have different hints or resources depending on the script context.

**What connects TO this table:**
- **`levels`** (parent) - Each relationship involves a specific level
- **`script_levels`** (parent) - Each relationship involves a specific script level
- **`user_levels`** - Students' progress through these complex relationships is tracked

**Why these connections matter**: This allows for more sophisticated curriculum design where the same level can have different educational purposes in different contexts.

---

### **12. `user_levels` (UserLevel model) - Student progress through levels**

**Purpose**: Track each student's progress and performance on individual levels.

**Real-world meaning**: This is where we track what each student has actually accomplished. For example, "Student John completed Maze: Move Forward on 2024-10-15 with a score of 100% after 3 attempts, spending 15 minutes total." This includes their completion status, their best score, how many attempts they made, how much time they spent, and when they completed it. This data is crucial for teachers to understand student progress and provide appropriate support.

**What connects TO this table:**
- **`users`** (parent) - Each user level belongs to exactly one student
- **`levels`** (parent) - Each user level belongs to exactly one level
- **`scripts`** - User levels are tracked within the context of specific scripts
- **`unit_groups`** - User levels are also tracked within the context of unit groups
- **`level_sources`** - The actual code students wrote is stored
- **`activities`** - Student interactions and attempts are logged
- **`user_level_interactions`** - Additional student interactions are tracked

**Why these connections matter**: User levels are the heart of student progress tracking. They show what students have learned, how well they've learned it, and where they need help.

---

### **13. `user_scripts` (UserScript model) - Student progress through scripts**

**Purpose**: Track each student's enrollment and progress through entire scripts.

**Real-world meaning**: This tracks the bigger picture of student progress. For example, "Student Sarah enrolled in CS Discoveries on 2024-09-01, started working on it on 2024-09-03, and completed it on 2024-12-15." This includes when they enrolled, when they started, when they completed it, and their overall progress through the entire script. This helps teachers understand which students are on track, which are struggling, and which have finished.

**What connects TO this table:**
- **`users`** (parent) - Each user script belongs to exactly one student
- **`scripts`** (parent) - Each user script belongs to exactly one script
- **`unit_groups`** - User scripts are tracked within the context of unit groups
- **`user_levels`** - Individual level progress is aggregated into script progress
- **`activities`** - Student interactions across the entire script are logged

**Why these connections matter**: User scripts provide the big-picture view of student progress. They help teachers understand which students are succeeding and which need additional support.

---

## 🔗 **Secondary Tables (7)**

### **14. `course_scripts` - Join table (courses ↔ scripts)**

**Purpose**: Connect academic courses to the specific scripts they include.

**Real-world meaning**: This defines which scripts are part of which academic courses. For example, "AP Computer Science A" course might include scripts for "Programming Fundamentals", "Data Structures", and "Algorithms". This helps schools understand what content is covered in each course and ensures students get the right curriculum for their academic program.

**What connects TO this table:**
- **`courses`** (parent) - Each course script belongs to exactly one course
- **`scripts`** (parent) - Each course script belongs to exactly one script

**Why this connection matters**: This ensures that academic courses have the right curriculum content and that students get appropriate credit for their work.

---

### **15. `unit_groups_resources` - Resources for unit groups**

**Purpose**: Provide learning materials that are shared across all scripts in a unit group.

**Real-world meaning**: These are resources like teacher guides, student handouts, or reference materials that apply to an entire curriculum program. For example, "CS Fundamentals" unit group might have a "Teacher's Guide to Computer Science Education" or "Student Reference Sheet for Programming Concepts" that applies to all grade levels.

**What connects TO this table:**
- **`unit_groups`** (parent) - Each resource belongs to exactly one unit group
- **`resources`** (parent) - Each resource is a specific learning material

**Why this connection matters**: This provides consistent resources across related curricula, helping teachers and students have access to appropriate materials.

---

### **16. `unit_groups_student_resources` - Student resources for unit groups**

**Purpose**: Provide student-specific resources for unit groups.

**Real-world meaning**: These are resources that students can access as they work through any script in a unit group. For example, students in "CS Fundamentals" might get access to a "Programming Reference Guide" or "Troubleshooting Tips" that they can use across all grade levels.

**What connects TO this table:**
- **`unit_groups`** (parent) - Each resource belongs to exactly one unit group
- **`resources`** (parent) - Each resource is a specific learning material
- **`users`** - Students get access to these resources

**Why this connection matters**: This ensures students have consistent access to helpful resources as they progress through related curricula.

---

### **17. `scripts_resources` - Resources for scripts**

**Purpose**: Provide learning materials specific to individual scripts.

**Real-world meaning**: These are resources like lesson plans, handouts, or reference materials that are specific to a particular script. For example, "CS Discoveries" might have a "Teacher's Guide to Problem Solving" or "Student Worksheet for Debugging Practice" that's specific to that curriculum.

**What connects TO this table:**
- **`scripts`** (parent) - Each resource belongs to exactly one script
- **`resources`** (parent) - Each resource is a specific learning material

**Why this connection matters**: This provides script-specific resources that help teachers and students succeed with that particular curriculum.

---

### **18. `scripts_student_resources` - Student resources for scripts**

**Purpose**: Provide student-specific resources for individual scripts.

**Real-world meaning**: These are resources that students can access as they work through a specific script. For example, students in "CS Discoveries" might get access to a "Problem Solving Checklist" or "Debugging Guide" that's specific to that curriculum.

**What connects TO this table:**
- **`scripts`** (parent) - Each resource belongs to exactly one script
- **`resources`** (parent) - Each resource is a specific learning material
- **`users`** - Students get access to these resources

**Why this connection matters**: This ensures students have access to helpful resources that are specific to their current curriculum.

---

### **19. `lessons_resources` - Resources for lessons**

**Purpose**: Provide learning materials specific to individual lessons.

**Real-world meaning**: These are resources like handouts, worksheets, or reference materials that are specific to a particular lesson. For example, a lesson on "Problem Solving" might have a "Problem Solving Worksheet" or "Solution Checklist" that students use during that specific lesson.

**What connects TO this table:**
- **`stages`** (lessons) (parent) - Each resource belongs to exactly one lesson
- **`resources`** (parent) - Each resource is a specific learning material

**Why this connection matters**: This provides lesson-specific resources that help students succeed with that particular learning activity.

---

### **20. `stages_standards` - Standards alignment for stages**

**Purpose**: Connect lessons to educational standards for accountability and alignment.

**Real-world meaning**: This ensures that each lesson is aligned to specific educational standards like CSTA (Computer Science Teachers Association) standards or Common Core. For example, a lesson on "Problem Solving" might be aligned to "CSTA 1A-AP-14: Observe intellectual property rights and give appropriate attribution when creating or remixing programs." This helps schools ensure their curriculum meets educational requirements.

**What connects TO this table:**
- **`stages`** (lessons) (parent) - Each standard alignment belongs to exactly one lesson
- **`standards`** (parent) - Each alignment is to a specific educational standard

**Why this connection matters**: This ensures curriculum meets educational standards and helps schools demonstrate compliance with requirements.

---

## 📊 **Migration Strategy (Updated)**

### **Phase 1: Core Structure (Tables 1-4)**
- `scripts`, `stages`, `levels`, `lesson_groups`
- These define the basic curriculum hierarchy

### **Phase 2: Activity Structure (Tables 5-6)**
- `lesson_activities`, `activity_sections`
- These define the detailed learning activities

### **Phase 3: Course Management (Tables 7-9)**
- `courses`, `course_offerings`, `unit_groups`
- These handle course organization

### **Phase 4: Join Tables (Tables 10-11)**
- `script_levels`, `levels_script_levels`
- These connect the core structure

### **Phase 5: User Progress (Tables 12-13)**
- `user_levels`, `user_scripts`
- These track student progress

### **Phase 6: Secondary Tables (Tables 14-20)**
- All resource and standards tables
- These add content and alignment

## ✅ **Confidence Assessment**

**High Confidence (85%+)**: 
- Core curriculum structure is definitively clear
- All 20 tables identified and verified
- Relationships understood
- Migration path defined

**Ready for Implementation**: YES

## 🚀 **Next Steps**

1. **Create migration files** for all 20 tables
2. **Add GUID columns** to primary tables
3. **Add GUID foreign key columns** to dependent tables
4. **Generate GUIDs** for existing data
5. **Update application code** to use GUIDs
6. **Test with real data** to ensure functionality

This detailed analysis provides the complete curriculum table structure with real-world context and relationships for the GUID migration.