# Lesson Overview Page

**Last Updated**: 2025-01-27  
**Purpose**: Display detailed lesson information including activities, objectives, and resources

## Overview

The Lesson Overview Page provides a comprehensive view of an individual lesson within a curriculum script. It includes lesson plans, activities, objectives, resources, and standards alignment for teachers and students.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/lessons/{lesson_position}`
- **New Format**: `/courses/{course_name}/units/{unit_position}/lessons/{lesson_position}`
- **Controller**: `LessonsController#show`
- **View Template**: `dashboard/app/views/lessons/show.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`stages`** - Main lesson data
  - `name`, `title`, `description`, `relative_position`
  - `overview`, `student_overview`, `assessment_opportunities`
  - `unplugged`, `lockable`, `has_lesson_plan`

### Secondary Tables
- **`lesson_activities`** - Activities within the lesson
  - `name`, `position`, `duration`, `instructions`
  - `teacher_notes`, `student_notes`

- **`activity_sections`** - Activity steps
  - `name`, `position`, `instructions`
  - `teacher_notes`, `student_notes`

- **`script_levels`** - Levels within the lesson
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

- **`levels`** - Individual coding challenges
  - `name`, `type`, `title`, `description`

### Resource Tables
- **`lessons_resources`** - Lesson-specific resources
  - `name`, `url`, `type`, `description`

- **`lessons_vocabularies`** - Lesson vocabulary
  - `word`, `definition`, `context`

- **`stages_standards`** - Standards alignment
  - `standard_code`, `description`, `framework`

### Assessment Tables
- **`objectives`** - Lesson objectives
  - `name`, `description`, `position`

- **`rubrics`** - Assessment rubrics
  - `name`, `description`, `key_concept`

## Key Features Displayed

### 1. Lesson Header
- Lesson title and description
- Lesson number and position
- Overview and student overview
- Assessment opportunities

### 2. Activities Section
- List of activities within the lesson
- Activity instructions and duration
- Teacher and student notes
- Activity sections and steps

### 3. Levels Section
- Coding challenges and puzzles
- Level descriptions and objectives
- Assessment and bonus levels
- Level progression

### 4. Resources Section
- Teacher resources and guides
- Student materials and handouts
- Vocabulary terms and definitions
- Standards alignment

### 5. Objectives and Assessment
- Learning objectives
- Assessment criteria
- Rubric information
- Evaluation guidelines

## Navigation Instructions

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: 
   - Go to a script overview page
   - Click on a specific lesson
4. **Example URLs**:
   - CS Fundamentals Course 1, Lesson 1: `/s/course1/lessons/1`
   - CS Discoveries, Unit 1, Lesson 1: `/courses/csd-2024/units/1/lessons/1`

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: 
   - Go to a script overview page
   - Click on a specific lesson
4. **View**: Lesson content and activities

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Scripts section
   - Select a script
   - Click on a lesson
4. **Edit**: Click "Edit" to modify lesson

## Example Curriculum Data

### CS Fundamentals Course 1, Lesson 1: "Graph Paper Programming"
- **Title**: "Graph Paper Programming"
- **Overview**: "Students learn about algorithms and debugging"
- **Activities**: 
  - "Introduction to Algorithms"
  - "Graph Paper Programming"
  - "Debugging Practice"
- **Levels**: 4 coding challenges
- **Vocabulary**: algorithm, debug, program

### CS Discoveries, Unit 1, Lesson 1: "Problem Solving"
- **Title**: "Problem Solving"
- **Overview**: "Students learn problem-solving strategies"
- **Activities**:
  - "Brainstorming Solutions"
  - "Solution Testing"
  - "Reflection and Iteration"
- **Levels**: 6 coding challenges
- **Vocabulary**: problem, solution, iteration

## Lesson Types

### Unplugged Lessons
- Offline activities and discussions
- Hands-on exercises
- Group work and collaboration
- Reflection and discussion

### Programming Lessons
- Coding challenges and puzzles
- Interactive activities
- Project-based learning
- Assessment and evaluation

### Mixed Lessons
- Combination of unplugged and programming
- Transition between concepts
- Reinforcement activities
- Extension challenges

## Screenshots

*Screenshots will be added here showing:*
- Main lesson overview layout
- Activities section
- Levels section
- Resources section
- Teacher vs student view differences

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Level Play Page](level-play.md) - Play individual levels
- [Script Resources Page](script-resources.md) - Script resources
- [Script Standards Page](script-standards.md) - Standards alignment

## Technical Notes

- Uses `Lesson.summarize_for_lesson_show()` for data loading
- Supports both teacher and student views
- Includes lesson plan functionality
- Handles unplugged and programming activities
- Supports internationalization and localization