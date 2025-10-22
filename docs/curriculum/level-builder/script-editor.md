# Script Editor

**Last Updated**: 2025-01-27  
**Purpose**: Create and edit curriculum scripts/units in the level builder interface

## Overview

The Script Editor is the primary interface for creating and modifying curriculum scripts. It allows level builders to define script properties, organize lessons, sequence levels, and configure all aspects of a curriculum unit.

## URL Patterns

- **Edit Existing**: `/scripts/{script_name}/edit`
- **Create New**: `/scripts/new`
- **Controller**: `ScriptsController#edit`, `ScriptsController#update`
- **View Template**: `dashboard/app/views/scripts/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`scripts`** - Main script data
  - `name`, `title`, `description`, `student_description`
  - `hideable_lessons`, `lesson_extras_available`, `has_verified_resources`
  - `project_widget_visible`, `show_calendar`, `weekly_instructional_minutes`
  - `is_migrated`, `announcements`, `lesson_groups`

### Secondary Tables
- **`stages`** - Lessons within the script
  - `name`, `title`, `description`, `relative_position`
  - `lockable`, `unplugged`, `has_lesson_plan`

- **`script_levels`** - Level sequence
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

- **`lesson_groups`** - Chapter groupings
  - `name`, `title`, `position`, `user_facing`

### Resource Tables
- **`scripts_resources`** - Script-specific resources
- **`scripts_student_resources`** - Student-facing resources

## Key Features

### 1. Script Properties
- **Basic Information**: Name, title, description
- **Student Description**: Student-facing description
- **Course Integration**: Link to unit groups and courses
- **Visibility Settings**: Hideable lessons, login requirements

### 2. Lesson Management
- **Lesson List**: Add, remove, reorder lessons
- **Lesson Properties**: Title, description, position
- **Lesson Groups**: Organize lessons into chapters
- **Lockable Lessons**: Configure lesson unlocking

### 3. Level Sequencing
- **Level Order**: Define the sequence of levels
- **Level Properties**: Bonus levels, challenge levels
- **Assessment Levels**: Mark levels as assessments
- **Level Variants**: Handle multiple level versions

### 4. Resource Management
- **Teacher Resources**: Upload and link resources
- **Student Resources**: Student-facing materials
- **Resource Organization**: Categorize and organize resources

### 5. Advanced Settings
- **Announcements**: Script-wide announcements
- **Project Widgets**: Configure project sharing
- **Calendar Integration**: Show calendar features
- **Instructional Minutes**: Set time estimates

## Navigation Instructions

### Accessing the Script Editor
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **Select**: Click on a script name or "New Script"

### Creating a New Script
1. **Click**: "New Script" button
2. **Fill**: Basic script information
3. **Save**: Create the script
4. **Edit**: Configure lessons and levels

### Editing an Existing Script
1. **Find**: Script in the scripts list
2. **Click**: Script name or "Edit" button
3. **Modify**: Script properties, lessons, or levels
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Script Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Description**: Teacher-facing description
- **Student Description**: Student-facing description
- **Course Integration**: Link to unit groups

### Lesson Configuration
- **Lesson List**: Drag-and-drop reordering
- **Lesson Properties**: Title, description, position
- **Lesson Groups**: Chapter organization
- **Lockable Settings**: Unlock requirements

### Level Configuration
- **Level Sequence**: Drag-and-drop ordering
- **Level Properties**: Bonus, challenge, assessment flags
- **Level Variants**: Multiple versions per level
- **Assessment Settings**: Rubric and evaluation

### Resource Management
- **Resource Upload**: File upload interface
- **Resource Links**: External resource URLs
- **Resource Categories**: Teacher vs student resources
- **Resource Organization**: Grouping and ordering

## Example Workflows

### Creating a New CS Fundamentals Course
1. **Create Script**: Name "course1", Title "CS Fundamentals Course 1"
2. **Add Lessons**: Create 20 lessons with titles and descriptions
3. **Organize Chapters**: Group lessons into logical chapters
4. **Add Levels**: Import or create levels for each lesson
5. **Configure Resources**: Add teacher guides and student materials
6. **Set Properties**: Configure visibility and access settings

### Modifying an Existing Script
1. **Open Script**: Select script from list
2. **Edit Properties**: Update title, description, or settings
3. **Reorder Lessons**: Drag and drop to change sequence
4. **Add Levels**: Insert new levels into sequence
5. **Update Resources**: Add or modify resources
6. **Save Changes**: Changes are saved automatically

## Validation Rules

### Script Name
- Must be unique across all scripts
- Cannot start with dot or tilde
- Cannot contain slashes
- Must be valid identifier

### Lesson Configuration
- Lessons must have unique positions
- Lesson groups must be properly nested
- Lockable lessons must have unlock conditions

### Level Sequencing
- Levels must have unique positions within lessons
- Assessment levels must have proper configuration
- Level variants must be properly linked

## Screenshots

*Screenshots will be added here showing:*
- Main script editor interface
- Lesson management panel
- Level sequencing interface
- Resource management section
- Form validation messages

## Related Views

- [Script Index](script-index.md) - List all scripts
- [Level Editor](level-editor.md) - Edit individual levels
- [Lesson Editor](lesson-editor.md) - Edit individual lessons
- [Resource Manager](resource-manager.md) - Manage resources

## Technical Notes

- Uses `Unit.summarize_for_unit_edit()` for data loading
- Supports real-time validation and auto-save
- Handles complex lesson and level relationships
- Includes drag-and-drop functionality for reordering
- Supports internationalization and localization
- Changes are tracked for audit purposes