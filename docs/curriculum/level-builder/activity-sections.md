# Activity Sections

**Last Updated**: 2025-01-27  
**Purpose**: Edit and manage activity steps and sections in the level builder interface

## Overview

The Activity Sections interface allows level builders to create, edit, and manage the individual steps and sections within lesson activities. This provides detailed breakdown of how activities should be conducted.

## URL Patterns

- **Edit Sections**: `/activities/{activity_id}/sections`
- **Controller**: `ActivitiesController#edit`, `ActivitiesController#update`
- **View Template**: `dashboard/app/views/activities/sections.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`activity_sections`** - Section data
  - `name`, `position`, `instructions`
  - `teacher_notes`, `student_notes`
  - `activity_id`, `created_at`, `updated_at`

### Secondary Tables
- **`lesson_activities`** - Parent activity
  - `name`, `position`, `duration`
  - `instructions`, `teacher_notes`

- **`stages`** - Parent lesson
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

## Key Features

### 1. Section Management
- **Section List**: Add, remove, reorder sections
- **Section Properties**: Title, instructions, notes
- **Section Dependencies**: Link sections together
- **Section Timing**: Set duration for each section

### 2. Section Configuration
- **Basic Information**: Name, position, instructions
- **Notes**: Teacher and student guidance
- **Dependencies**: Link to other sections
- **Timing**: Set duration and pacing

### 3. Section Types
- **Introduction Sections**: Set up the activity
- **Instruction Sections**: Provide step-by-step guidance
- **Practice Sections**: Allow hands-on practice
- **Reflection Sections**: Encourage thinking and discussion

### 4. Section Organization
- **Sequencing**: Order sections within activity
- **Grouping**: Group related sections
- **Timing**: Set duration and pacing
- **Dependencies**: Link sections together

## Navigation Instructions

### Accessing Activity Sections
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **Select**: Click on a script name
5. **Click**: "Edit" button
6. **Select**: Click on a lesson
7. **Click**: "Activities" tab
8. **Select**: Click on an activity
9. **Click**: "Sections" tab

### Creating a New Section
1. **Click**: "New Section" button
2. **Fill**: Basic section information
3. **Set Dependencies**: Link to other sections
4. **Save**: Create the section

### Editing an Existing Section
1. **Find**: Section in the list
2. **Click**: Section name or "Edit" button
3. **Modify**: Section properties or dependencies
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Section Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Position**: Section position in activity
- **Duration**: Estimated time in minutes

### Section Content
- **Instructions**: Step-by-step instructions
- **Teacher Notes**: Guidance for teachers
- **Student Notes**: Guidance for students
- **Materials**: Required materials list

### Section Dependencies
- **Prerequisites**: Sections that must be completed first
- **Dependencies**: Sections that depend on this one
- **Timing**: When this section should be done
- **Conditions**: Special conditions for this section

## Example Section Types

### Introduction Sections
- **Welcome**: Greet students and set context
- **Objectives**: Explain what students will learn
- **Materials**: List required materials
- **Setup**: Prepare the learning environment

### Instruction Sections
- **Step 1**: First step of the activity
- **Step 2**: Second step of the activity
- **Step 3**: Third step of the activity
- **Summary**: Recap what was learned

### Practice Sections
- **Hands-on Practice**: Allow students to practice
- **Group Work**: Encourage collaboration
- **Individual Work**: Allow independent practice
- **Peer Review**: Have students review each other

### Reflection Sections
- **Discussion**: Talk about what was learned
- **Questions**: Ask students questions
- **Sharing**: Have students share their work
- **Next Steps**: Plan what comes next

## Validation Rules

### Section Name
- Must be unique within activity
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Section Properties
- Title is required
- Position must be unique within activity
- Duration must be positive number
- Instructions are required

### Section Dependencies
- Dependencies must be valid section IDs
- Cannot create circular dependencies
- Prerequisites must exist
- Timing must be logical

## Screenshots

*Screenshots will be added here showing:*
- Main sections interface
- Section list with metadata
- Section editor form
- Dependency management interface

## Related Views

- [Lesson Activities](lesson-activities.md) - Edit activities containing sections
- [Lesson Editor](lesson-editor.md) - Edit lessons containing activities
- [Script Editor](script-editor.md) - Edit scripts containing lessons

## Technical Notes

- Uses `ActivitySection.all` for data loading
- Supports drag-and-drop reordering
- Includes real-time validation
- Handles section-dependency relationships
- Supports internationalization and localization
- Changes are tracked for audit purposes