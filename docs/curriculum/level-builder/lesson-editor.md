# Lesson Editor

**Last Updated**: 2025-01-27  
**Purpose**: Create and edit individual lessons in the level builder interface

## Overview

The Lesson Editor is the primary interface for creating and modifying individual lessons within curriculum scripts. It allows level builders to define lesson properties, organize activities, sequence levels, and configure all aspects of a lesson.

## URL Patterns

- **Edit Existing**: `/lessons/{lesson_id}/edit`
- **Create New**: `/lessons/new`
- **Controller**: `LessonsController#edit`, `LessonsController#update`
- **View Template**: `dashboard/app/views/lessons/edit.html.haml`

## Curriculum Tables Modified

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

- **`script_levels`** - Level sequence
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

### Resource Tables
- **`lessons_resources`** - Lesson-specific resources
- **`lessons_vocabularies`** - Lesson vocabulary
- **`stages_standards`** - Standards alignment

## Key Features

### 1. Lesson Properties
- **Basic Information**: Name, title, description
- **Overview**: Teacher and student overviews
- **Assessment**: Assessment opportunities and criteria
- **Settings**: Unplugged, lockable, lesson plan flags

### 2. Activities Management
- **Activity List**: Add, remove, reorder activities
- **Activity Properties**: Title, duration, instructions
- **Activity Sections**: Break down activities into steps
- **Notes**: Teacher and student notes

### 3. Level Sequencing
- **Level Order**: Define the sequence of levels
- **Level Properties**: Bonus levels, challenge levels
- **Assessment Levels**: Mark levels as assessments
- **Level Variants**: Handle multiple level versions

### 4. Resource Management
- **Lesson Resources**: Upload and link resources
- **Vocabulary**: Add vocabulary terms and definitions
- **Standards**: Align lesson to educational standards
- **Programming Expressions**: Link programming concepts

## Navigation Instructions

### Accessing the Lesson Editor
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **Select**: Click on a script name
5. **Click**: "Edit" button
6. **Select**: Click on a lesson

### Creating a New Lesson
1. **Click**: "New Lesson" button
2. **Fill**: Basic lesson information
3. **Save**: Create the lesson
4. **Edit**: Configure activities and levels

### Editing an Existing Lesson
1. **Find**: Lesson in the script
2. **Click**: Lesson name or "Edit" button
3. **Modify**: Lesson properties, activities, or levels
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Lesson Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Description**: Lesson description
- **Position**: Lesson position in script

### Lesson Properties
- **Overview**: Teacher-facing lesson overview
- **Student Overview**: Student-facing lesson overview
- **Assessment Opportunities**: Assessment criteria
- **Unplugged**: Mark as unplugged activity
- **Lockable**: Mark as lockable lesson

### Activities Configuration
- **Activity List**: Drag-and-drop reordering
- **Activity Properties**: Title, duration, instructions
- **Activity Sections**: Step-by-step breakdown
- **Notes**: Teacher and student notes

### Level Configuration
- **Level Sequence**: Drag-and-drop ordering
- **Level Properties**: Bonus, challenge, assessment flags
- **Level Variants**: Multiple versions per level
- **Assessment Settings**: Rubric and evaluation

## Example Workflows

### Creating a New CS Fundamentals Lesson
1. **Create Lesson**: Name "lesson_1", Title "Introduction to Algorithms"
2. **Set Properties**: Overview, student overview, assessment opportunities
3. **Add Activities**: "Algorithm Discussion", "Graph Paper Programming"
4. **Add Levels**: Import or create 4 levels
5. **Configure Resources**: Add teacher guide and student handout
6. **Set Standards**: Align to CSTA standards

### Modifying an Existing Lesson
1. **Open Lesson**: Select lesson from script
2. **Edit Properties**: Update title, description, or settings
3. **Reorder Activities**: Drag and drop to change sequence
4. **Add Levels**: Insert new levels into sequence
5. **Update Resources**: Add or modify resources
6. **Save Changes**: Changes are saved automatically

## Validation Rules

### Lesson Name
- Must be unique within script
- Cannot start with dot or tilde
- Cannot contain slashes
- Must be valid identifier

### Lesson Properties
- Overview is required
- Student overview is required
- Position must be unique within script
- Lockable lessons must have proper configuration

### Activities Configuration
- Activities must have unique positions
- Activity sections must be properly nested
- Instructions are required for each activity

## Screenshots

*Screenshots will be added here showing:*
- Main lesson editor interface
- Activities management panel
- Level sequencing interface
- Resource management section
- Form validation messages

## Related Views

- [Script Editor](script-editor.md) - Edit scripts containing lessons
- [Level Editor](level-editor.md) - Edit individual levels
- [Resource Manager](resource-manager.md) - Manage resources

## Technical Notes

- Uses `Lesson.summarize_for_lesson_edit()` for data loading
- Supports real-time validation and auto-save
- Handles complex activity and level relationships
- Includes drag-and-drop functionality for reordering
- Supports internationalization and localization
- Changes are tracked for audit purposes