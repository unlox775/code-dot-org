# Course Scripts

**Last Updated**: 2025-01-27  
**Purpose**: Link courses to scripts and manage course-script relationships in the level builder interface

## Overview

The Course Scripts interface allows level builders to link academic courses to curriculum scripts and manage the relationships between them. This determines which scripts are included in each course.

## URL Patterns

- **Edit Scripts**: `/courses/{course_id}/scripts`
- **Controller**: `CoursesController#scripts`, `CoursesController#update_scripts`
- **View Template**: `dashboard/app/views/courses/scripts.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`course_scripts`** - Course-script relationships
  - `position`, `course_id`, `script_id`
  - `created_at`, `updated_at`

### Secondary Tables
- **`courses`** - Parent course
  - `name`, `title`, `description`
  - `course_family`, `version_year`

- **`scripts`** - Linked scripts
  - `name`, `title`, `description`
  - `published`, `is_migrated`

## Key Features

### 1. Script Management
- **Script List**: Add, remove, reorder scripts
- **Script Properties**: Title, description, position
- **Script Dependencies**: Link scripts together
- **Script Resources**: Add course-specific resources

### 2. Script Configuration
- **Basic Information**: Name, title, description
- **Position**: Order within course
- **Dependencies**: Required prior scripts
- **Resources**: Course-specific materials

### 3. Script Types
- **Core Scripts**: Required for course completion
- **Optional Scripts**: Additional content
- **Prerequisite Scripts**: Required before course
- **Extension Scripts**: Advanced content

### 4. Script Integration
- **Course Linking**: Link scripts to course
- **Position Management**: Order scripts within course
- **Dependency Management**: Handle script prerequisites
- **Resource Management**: Add course-specific resources

## Navigation Instructions

### Accessing Course Scripts
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Courses section
4. **Select**: Click on a course name
5. **Click**: "Scripts" tab

### Adding Scripts to Course
1. **Click**: "Add Script" button
2. **Select**: Choose script from dropdown
3. **Set Position**: Order within course
4. **Save**: Add script to course

### Reordering Scripts
1. **Drag**: Script to new position
2. **Drop**: Release to reorder
3. **Save**: Apply new order

## Form Fields and Controls

### Script Selection
- **Script Dropdown**: Choose from available scripts
- **Script Search**: Search for specific scripts
- **Script Filter**: Filter by script type
- **Script Preview**: Preview script content

### Script Configuration
- **Position**: Order within course
- **Dependencies**: Required prior scripts
- **Resources**: Course-specific materials
- **Settings**: Script-specific settings

### Script Management
- **Add Script**: Add new script to course
- **Remove Script**: Remove script from course
- **Reorder Scripts**: Change script order
- **Edit Script**: Modify script properties

## Example Course-Script Configurations

### CS Fundamentals Course 1
- **Script 1**: Course A (Position 1)
- **Script 2**: Course B (Position 2)
- **Script 3**: Course C (Position 3)
- **Script 4**: Course D (Position 4)

### CS Discoveries Unit 1
- **Script 1**: Problem Solving (Position 1)
- **Script 2**: Web Development (Position 2)
- **Script 3**: Data and Society (Position 3)
- **Script 4**: The Design Process (Position 4)

### CS Principles Unit 1
- **Script 1**: Digital Information (Position 1)
- **Script 2**: The Internet (Position 2)
- **Script 3**: Programming (Position 3)
- **Script 4**: Algorithms (Position 4)

## Validation Rules

### Script Selection
- Script must exist
- Script must be published
- Script must be compatible with course
- Script cannot be duplicated

### Script Configuration
- Position must be unique within course
- Dependencies must be valid
- Resources must exist
- Settings must be valid

### Script Management
- Cannot remove required scripts
- Cannot create circular dependencies
- Position changes must be valid
- Script properties must be complete

## Screenshots

*Screenshots will be added here showing:*
- Main course scripts interface
- Script list with positions
- Script selection dropdown
- Script configuration panel

## Related Views

- [Course Editor](course-editor.md) - Edit parent courses
- [Course Offerings](course-offerings.md) - Manage course instances
- [Script Editor](script-editor.md) - Edit individual scripts

## Technical Notes

- Uses `CourseScript.all` for data loading
- Supports drag-and-drop reordering
- Includes real-time validation
- Handles complex script-dependency relationships
- Supports internationalization and localization
- Changes are tracked for audit purposes