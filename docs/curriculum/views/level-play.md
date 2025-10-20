# Level Play Page

**Last Updated**: 2025-01-27  
**Purpose**: Main interface for students to play coding levels and complete curriculum challenges

## Overview

The Level Play Page is the core learning interface where students interact with coding challenges, puzzles, and activities. It's the primary engagement point for curriculum content and supports multiple level types including Blockly, App Lab, Game Lab, and more.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/lessons/{lesson_position}/levels/{level_position}`
- **New Format**: `/courses/{course_name}/units/{unit_position}/lessons/{lesson_position}/levels/{level_position}`
- **Controller**: `ScriptLevelsController#show`
- **View Template**: `dashboard/app/views/levels/show.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`levels`** - Main level data
  - `name`, `type`, `level_num`, `title`, `description`
  - `properties` (JSON containing level-specific configuration)
  - `instructions`, `hint`, `solution_blocks`

- **`script_levels`** - Level positioning and context
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`, `lesson_id`

### Secondary Tables
- **`stages`** - Lesson context
  - `name`, `title`, `description`, `relative_position`
  - `unplugged`, `lockable`, `has_lesson_plan`

- **`scripts`** - Script context
  - `name`, `title`, `description`
  - `login_required`, `hideable_lessons`

- **`lesson_activities`** - Activity context
  - `name`, `position`, `duration`
  - `instructions`, `teacher_notes`

### Assessment Tables
- **`rubrics`** - Level assessment rubrics
  - `name`, `description`, `key_concept`
  - `performance_level_1` through `performance_level_4`

- **`learning_goals`** - Specific learning objectives
  - `name`, `description`, `position`

### User Progress Tables
- **`user_levels`** - Student progress on this level
  - `attempts`, `best_result`, `time_spent`
  - `submitted`, `readonly_answers`

- **`activities`** - Student interactions
  - `level_source_id`, `data`, `created_at`

## Key Features Displayed

### 1. Level Interface
- Level title and instructions
- Coding workspace (Blockly, text editor, etc.)
- Run/Submit buttons
- Reset and hint options

### 2. Progress Tracking
- Attempt counter
- Time spent on level
- Completion status
- Next level navigation

### 3. Level-Specific Elements
- **Blockly Levels**: Toolbox, workspace, blocks
- **App Lab**: Design mode, code mode, data tables
- **Game Lab**: Sprite editor, animation tools
- **Unplugged**: Instructions, worksheets, videos

### 4. Teacher Features (when viewing as teacher)
- Student progress indicators
- Solution viewing
- Code review capabilities
- Rubric assessment tools

## Navigation Instructions

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: 
   - Go to a script overview page
   - Click on a lesson
   - Click on a specific level
4. **Example URLs**:
   - CS Fundamentals Course 1, Lesson 1, Level 1: `/s/course1/lessons/1/levels/1`
   - CS Discoveries, Unit 1, Lesson 1, Level 1: `/courses/csd-2024/units/1/lessons/1/levels/1`

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: 
   - Go to Teacher Dashboard
   - Select a section and script
   - Navigate to specific level
4. **View Student Work**: Add `?user_id={student_id}` to URL
5. **Example URLs**:
   - View student work: `/s/course1/lessons/1/levels/1?user_id=123&section_id=456`

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Levels section
   - Search for specific level
   - Click "Edit" to modify level
4. **Example URLs**:
   - Edit level: `/levels/{level_id}/edit`
   - View level: `/levels/{level_id}`

## Example Curriculum Data

### Maze: Move Forward (CS Fundamentals Course 1)
- **Level Name**: `maze_1`
- **Type**: `Maze`
- **Instructions**: "Help the bird get to the pig"
- **Toolbox**: Basic movement blocks (move forward, turn left, turn right)
- **Solution**: `moveForward(); moveForward(); moveForward();`

### Dance Party (CS Discoveries)
- **Level Name**: `dance_party_1`
- **Type**: `Dancelab`
- **Instructions**: "Create a dance for your character"
- **Toolbox**: Dance move blocks, event blocks
- **Features**: Character selection, music selection, animation preview

### App Lab: Hello World (CS Principles)
- **Level Name**: `app_lab_hello_world`
- **Type**: `Applab`
- **Instructions**: "Create an app that says 'Hello World'"
- **Features**: Design mode, code mode, button creation
- **Code**: `setText("label1", "Hello World");`

## Level Types Supported

### Blockly-Based Levels
- **Maze**: Grid-based movement puzzles
- **Artist**: Drawing and geometry
- **Flappy**: Game development
- **Studio**: Sprite-based programming

### Lab-Based Levels
- **App Lab**: Web app development
- **Game Lab**: Game development
- **Web Lab**: HTML/CSS/JavaScript
- **Python Lab**: Python programming

### Assessment Levels
- **Free Response**: Text-based responses
- **Multi**: Multiple choice questions
- **Match**: Matching exercises
- **Text Match**: Text matching

### Unplugged Activities
- **Unplugged**: Offline activities
- **Standalone Video**: Video content
- **Curriculum Reference**: External content

## Screenshots

*Screenshots will be added here showing:*
- Main level interface layout
- Different level types (Maze, App Lab, etc.)
- Teacher view with student progress
- Mobile responsive layout
- Level completion and navigation

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Lesson Overview Page](lesson-overview.md) - Lesson context
- [Level Properties API](level-properties-api.md) - JSON data for level
- [Teacher Script View](teacher-script-view.md) - Teacher's progress view

## Technical Notes

- Uses `Level.summarize_for_lab2_properties()` for modern labs
- Supports multiple level types with different interfaces
- Handles user progress tracking and persistence
- Includes accessibility features and keyboard navigation
- Supports internationalization and localization
- Caches level data for performance