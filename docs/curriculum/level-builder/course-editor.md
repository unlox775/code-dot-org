# Course Editor

**Last Updated**: 2025-01-27  
**Purpose**: Create and edit academic courses in the level builder interface

## Overview

The Course Editor is the primary interface for creating and modifying academic courses. It allows level builders to define course properties, organize units, and configure all aspects of a course.

## URL Patterns

- **Edit Existing**: `/courses/{course_id}/edit`
- **Create New**: `/courses/new`
- **Controller**: `CoursesController#edit`, `CoursesController#update`
- **View Template**: `dashboard/app/views/courses/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`courses`** - Main course data
  - `name`, `title`, `description`
  - `course_family`, `version_year`
  - `published`, `created_at`, `updated_at`

### Secondary Tables
- **`course_offerings`** - Course instances
  - `name`, `display_name`, `description`
  - `year`, `published`, `assignable`

- **`course_scripts`** - Course-script relationships
  - `position`, `course_id`, `script_id`

- **`unit_groups`** - Course families
  - `name`, `title`, `family_name`
  - `version_year`, `published`

## Key Features

### 1. Course Properties
- **Basic Information**: Name, title, description
- **Course Family**: Link to course family
- **Version Year**: Course version year
- **Publication Status**: Make course available

### 2. Unit Management
- **Unit List**: Add, remove, reorder units
- **Unit Properties**: Title, description, position
- **Unit Dependencies**: Link units together
- **Unit Resources**: Add course-specific resources

### 3. Course Configuration
- **Prerequisites**: Required prior knowledge
- **Learning Objectives**: What students will learn
- **Assessment**: Course evaluation criteria
- **Resources**: Course materials and guides

### 4. Course Integration
- **Unit Groups**: Link to curriculum families
- **Course Offerings**: Create course instances
- **Version Management**: Handle course versions
- **Standards Alignment**: Align to educational standards

## Navigation Instructions

### Accessing the Course Editor
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Courses section
4. **Select**: Click on a course name or "New Course"

### Creating a New Course
1. **Click**: "New Course" button
2. **Fill**: Basic course information
3. **Add Units**: Link scripts to course
4. **Save**: Create the course

### Editing an Existing Course
1. **Find**: Course in the list
2. **Click**: Course name or "Edit" button
3. **Modify**: Course properties or units
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Course Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Description**: Course description
- **Course Family**: Link to course family

### Course Properties
- **Version Year**: Course version year
- **Published**: Make course available
- **Prerequisites**: Required prior knowledge
- **Learning Objectives**: What students will learn

### Unit Configuration
- **Unit List**: Drag-and-drop reordering
- **Unit Properties**: Title, description, position
- **Unit Dependencies**: Link units together
- **Unit Resources**: Add course-specific resources

## Example Course Configurations

### CS Fundamentals (K-5)
- **Course Family**: CSF
- **Version Year**: 2024
- **Units**: Course A, B, C, D, E, F
- **Grade Levels**: K-5
- **Description**: "Computer science fundamentals for elementary students"

### CS Discoveries (6-10)
- **Course Family**: CSD
- **Version Year**: 2024
- **Units**: 6 units covering web development, data, and programming
- **Grade Levels**: 6-10
- **Description**: "Computer science discoveries for middle and high school"

### CS Principles (9-12)
- **Course Family**: CSP
- **Version Year**: 2024
- **Units**: 8 units covering computer science principles
- **Grade Levels**: 9-12
- **Description**: "AP Computer Science Principles curriculum"

## Validation Rules

### Course Name
- Must be unique
- Cannot be changed after creation
- Must be valid identifier

### Course Properties
- Title is required
- Description is required
- Version year must be current
- Course family must exist

### Unit Configuration
- Units must have unique positions
- Unit dependencies must be valid
- Unit resources must exist
- Unit properties must be complete

## Screenshots

*Screenshots will be added here showing:*
- Main course editor interface
- Course properties form
- Unit management panel
- Course integration settings

## Related Views

- [Course Offerings](course-offerings.md) - Manage course instances
- [Course Scripts](course-scripts.md) - Link courses to scripts
- [Script Editor](script-editor.md) - Edit scripts in course

## Technical Notes

- Uses `Course.find()` for data loading
- Supports real-time validation
- Handles complex course-unit relationships
- Includes drag-and-drop functionality for reordering
- Supports internationalization and localization
- Changes are tracked for audit purposes