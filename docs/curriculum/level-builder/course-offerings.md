# Course Offerings

**Last Updated**: 2025-01-27  
**Purpose**: Manage course instances and offerings in the level builder interface

## Overview

The Course Offerings interface allows level builders to create and manage specific instances of academic courses. Course offerings represent the actual courses that students can enroll in and teachers can assign.

## URL Patterns

- **Edit Offerings**: `/course_offerings/{offering_id}/edit`
- **Create New**: `/course_offerings/new`
- **Controller**: `CourseOfferingsController#edit`, `CourseOfferingsController#update`
- **View Template**: `dashboard/app/views/course_offerings/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`course_offerings`** - Course instance data
  - `name`, `display_name`, `description`
  - `year`, `published`, `assignable`
  - `family_name`, `version_year`

### Secondary Tables
- **`courses`** - Parent course
  - `name`, `title`, `description`
  - `course_family`, `version_year`

- **`unit_groups`** - Course families
  - `name`, `title`, `family_name`
  - `version_year`, `published`

## Key Features

### 1. Offering Management
- **Offering List**: Add, remove, edit offerings
- **Offering Properties**: Name, display name, description
- **Publication Status**: Make offerings available
- **Assignment Settings**: Control who can assign

### 2. Offering Configuration
- **Basic Information**: Name, display name, description
- **Year Settings**: Academic year and version
- **Family Settings**: Link to course family
- **Publication Settings**: Control availability

### 3. Offering Types
- **Published Offerings**: Available to students and teachers
- **Draft Offerings**: Work in progress
- **Archived Offerings**: No longer active
- **Test Offerings**: For testing and development

### 4. Offering Integration
- **Course Linking**: Link to parent course
- **Family Relationships**: Connect to course families
- **Version Management**: Handle offering versions
- **Assignment Control**: Control who can assign

## Navigation Instructions

### Accessing Course Offerings
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Courses section
4. **Select**: Click on a course name
5. **Click**: "Offerings" tab

### Creating a New Offering
1. **Click**: "New Offering" button
2. **Fill**: Basic offering information
3. **Set Properties**: Configure offering settings
4. **Save**: Create the offering

### Editing an Existing Offering
1. **Find**: Offering in the list
2. **Click**: Offering name or "Edit" button
3. **Modify**: Offering properties or settings
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Offering Name**: Unique identifier (required)
- **Display Name**: User-facing title (required)
- **Description**: Offering description
- **Academic Year**: Year for this offering

### Offering Properties
- **Published**: Make offering available
- **Assignable**: Allow teachers to assign
- **Family Name**: Link to course family
- **Version Year**: Course version year

### Offering Settings
- **Start Date**: When offering becomes available
- **End Date**: When offering expires
- **Enrollment**: Who can enroll
- **Assignment**: Who can assign

## Example Offering Configurations

### CS Fundamentals 2024
- **Display Name**: "CS Fundamentals 2024"
- **Academic Year**: 2024
- **Published**: Yes
- **Assignable**: Yes
- **Family**: CSF
- **Version**: 2024

### CS Discoveries 2024
- **Display Name**: "CS Discoveries 2024"
- **Academic Year**: 2024
- **Published**: Yes
- **Assignable**: Yes
- **Family**: CSD
- **Version**: 2024

### CS Principles 2024
- **Display Name**: "CS Principles 2024"
- **Academic Year**: 2024
- **Published**: Yes
- **Assignable**: Yes
- **Family**: CSP
- **Version**: 2024

## Validation Rules

### Offering Name
- Must be unique
- Cannot be changed after creation
- Must be valid identifier

### Offering Properties
- Display name is required
- Description is required
- Academic year must be valid
- Family name must exist

### Offering Settings
- Start date must be before end date
- Enrollment settings must be valid
- Assignment settings must be valid
- Publication settings must be consistent

## Screenshots

*Screenshots will be added here showing:*
- Main offerings interface
- Offering list with metadata
- Offering editor form
- Settings configuration panel

## Related Views

- [Course Editor](course-editor.md) - Edit parent courses
- [Course Scripts](course-scripts.md) - Link courses to scripts
- [Script Editor](script-editor.md) - Edit scripts in course

## Technical Notes

- Uses `CourseOffering.find()` for data loading
- Supports real-time validation
- Handles complex course-offering relationships
- Includes publication and assignment controls
- Supports internationalization and localization
- Changes are tracked for audit purposes