# Script Overview Page

**Last Updated**: 2025-01-27  
**Purpose**: Main landing page for a curriculum script/unit

## Overview

The Script Overview Page is the primary landing page for a curriculum script (unit). It provides students and teachers with an overview of the entire curriculum program, including lesson progression, resources, and navigation options.

## URL Patterns

- **Legacy Format**: `/s/{script_name}` (e.g., `/s/course1`)
- **New Format**: `/courses/{course_name}/units/{unit_position}` (e.g., `/courses/csf-2024/units/1`)
- **Controller**: `ScriptsController#show`
- **View Template**: `dashboard/app/views/scripts/show.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`scripts`** - Main script data
  - `name`, `title`, `description`, `student_description`
  - `hideable_lessons`, `lesson_extras_available`, `has_verified_resources`
  - `project_widget_visible`, `show_calendar`, `weekly_instructional_minutes`

### Secondary Tables
- **`stages`** - Lessons within the script
  - `name`, `title`, `description`, `relative_position`
  - `lockable`, `unplugged`, `has_lesson_plan`

- **`lesson_groups`** - Chapter groupings
  - `name`, `title`, `position`, `user_facing`

- **`script_levels`** - Level sequence
  - `position`, `chapter`, `bonus`, `challenge`

- **`levels`** - Individual coding challenges
  - `name`, `type`, `level_num`, `title`

### Resource Tables
- **`scripts_resources`** - Script-specific resources
- **`scripts_student_resources`** - Student-facing resources
- **`lessons_resources`** - Lesson-specific resources

### Course Integration
- **`unit_groups`** - Course family information
- **`course_scripts`** - Course-script relationships
- **`courses`** - Academic course definitions

## Key Features Displayed

### 1. Script Header
- Script title and description
- Course context (if part of a course)
- Progress indicators
- Navigation breadcrumbs

### 2. Lesson Progression
- List of lessons with titles and descriptions
- Lesson numbering and positioning
- Lock/unlock status for students
- Lesson completion indicators

### 3. Resources Section
- Teacher resources
- Student resources
- Standards alignment
- Vocabulary lists
- Programming expressions

### 4. Navigation
- Previous/Next lesson buttons
- Course navigation
- Teacher dashboard links
- Section selection (for teachers)

## Navigation Instructions

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: Click on "Courses" or go directly to a script URL
4. **Example URLs**:
   - CS Fundamentals Course 1: `/s/course1`
   - CS Discoveries: `/s/csp1`
   - CS Principles: `/s/csp2`

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: Go to Teacher Dashboard or use direct script URLs
4. **Section Context**: Select a section to view script in context
5. **Example URLs**:
   - With section: `/s/course1?section_id=123`
   - Course format: `/courses/csf-2024/units/1`

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: Go to Scripts section or use direct URLs
4. **Edit Access**: Additional edit buttons and controls available

## Example Curriculum Data

### CS Fundamentals Course 1
- **Script Name**: `course1`
- **Title**: "CS Fundamentals Course 1"
- **Lessons**: 20 lessons including "Graph Paper Programming", "Real-Life Algorithms"
- **Levels**: Mix of unplugged activities and Blockly puzzles

### CS Discoveries
- **Script Name**: `csp1`
- **Title**: "CS Discoveries"
- **Lessons**: 6 units with multiple lessons each
- **Levels**: Web development, data analysis, and programming challenges

## Screenshots

*Screenshots will be added here showing:*
- Main script overview layout
- Lesson progression display
- Resources section
- Teacher vs student view differences
- Mobile responsive layout

## Related Views

- [Lesson Overview Page](lesson-overview.md) - Individual lesson details
- [Script Resources Page](script-resources.md) - Script-specific resources
- [Teacher Script View](teacher-script-view.md) - Teacher's progress view
- [Course Catalog Page](course-catalog.md) - Browse available courses

## Technical Notes

- Uses `Unit.summarize()` method to gather script data
- Supports both legacy and new URL formats
- Handles course context and unit positioning
- Includes redirect logic for deprecated scripts
- Supports internationalization and localization