# Script Settings

**Last Updated**: 2025-01-27  
**Purpose**: Configure advanced script properties and settings in the level builder interface

## Overview

The Script Settings interface allows level builders to configure advanced properties and settings for curriculum scripts. This includes visibility settings, course integration, and other script-level configurations.

## URL Patterns

- **Edit Settings**: `/scripts/{script_name}/settings`
- **Controller**: `ScriptsController#edit`, `ScriptsController#update`
- **View Template**: `dashboard/app/views/scripts/settings.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`scripts`** - Script configuration
  - `name`, `title`, `description`, `student_description`
  - `hideable_lessons`, `lesson_extras_available`, `has_verified_resources`
  - `project_widget_visible`, `show_calendar`, `weekly_instructional_minutes`
  - `login_required`, `published`, `is_migrated`

### Secondary Tables
- **`unit_groups`** - Script family settings
  - `name`, `title`, `family_name`, `version_year`

- **`course_scripts`** - Course integration
  - `position`, `course_id`, `script_id`

## Key Features

### 1. Basic Settings
- Script name and title
- Description and student description
- Publication status
- Login requirements

### 2. Visibility Settings
- Hideable lessons configuration
- Lesson extras availability
- Verified resources settings
- Project widget visibility

### 3. Course Integration
- Unit group assignment
- Course positioning
- Version year settings
- Family relationships

### 4. Advanced Configuration
- Weekly instructional minutes
- Calendar integration
- Assessment settings
- Resource requirements

## Navigation Instructions

### Accessing Script Settings
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **Select**: Click on a script name
5. **Click**: "Settings" tab

### Configuring Settings
1. **Modify**: Change script properties
2. **Validate**: Check for errors
3. **Save**: Apply changes
4. **Test**: Verify settings work correctly

## Form Fields and Controls

### Basic Information
- **Script Name**: Unique identifier
- **Title**: Display title
- **Description**: Teacher-facing description
- **Student Description**: Student-facing description

### Visibility Settings
- **Hideable Lessons**: Allow hiding lessons
- **Lesson Extras**: Enable lesson extras
- **Verified Resources**: Require verified resources
- **Project Widget**: Show project widget

### Course Integration
- **Unit Group**: Assign to unit group
- **Course Position**: Position within course
- **Version Year**: Course version year
- **Family Name**: Script family

### Advanced Settings
- **Weekly Minutes**: Instructional time per week
- **Calendar Integration**: Show calendar features
- **Login Required**: Require user login
- **Published**: Make script available

## Example Configurations

### CS Fundamentals Course 1
- **Hideable Lessons**: Yes
- **Lesson Extras**: Yes
- **Verified Resources**: Yes
- **Project Widget**: Yes
- **Weekly Minutes**: 45
- **Login Required**: No

### CS Discoveries Unit 1
- **Hideable Lessons**: No
- **Lesson Extras**: Yes
- **Verified Resources**: Yes
- **Project Widget**: Yes
- **Weekly Minutes**: 60
- **Login Required**: Yes

## Validation Rules

### Script Name
- Must be unique
- Cannot be changed after creation
- Must be valid identifier

### Course Integration
- Unit group must exist
- Course position must be valid
- Version year must be current

### Visibility Settings
- Must be consistent with script type
- Cannot conflict with course requirements
- Must support student experience

## Screenshots

*Screenshots will be added here showing:*
- Main settings interface
- Form fields and controls
- Validation messages
- Save confirmation

## Related Views

- [Script Editor](script-editor.md) - Edit script content
- [Script Index](script-index.md) - List all scripts
- [Course Editor](course-editor.md) - Edit courses

## Technical Notes

- Uses `Script.find_by_name()` for data loading
- Supports real-time validation
- Handles complex course relationships
- Includes audit logging for changes
- Supports internationalization and localization