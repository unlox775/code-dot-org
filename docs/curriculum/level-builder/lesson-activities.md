# Lesson Activities

**Last Updated**: 2025-01-27  
**Purpose**: Manage lesson activities and their configuration in the level builder interface

## Overview

The Lesson Activities interface allows level builders to create, edit, and manage activities within lessons. Activities are the building blocks of lessons and can include hands-on exercises, discussions, and interactive elements.

## URL Patterns

- **Edit Activities**: `/lessons/{lesson_id}/activities`
- **Controller**: `LessonsController#edit`, `LessonsController#update`
- **View Template**: `dashboard/app/views/lessons/activities.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`lesson_activities`** - Activity data
  - `name`, `position`, `duration`, `instructions`
  - `teacher_notes`, `student_notes`
  - `lesson_id`, `created_at`, `updated_at`

### Secondary Tables
- **`activity_sections`** - Activity steps
  - `name`, `position`, `instructions`
  - `teacher_notes`, `student_notes`
  - `activity_id`, `created_at`, `updated_at`

- **`stages`** - Parent lesson
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

## Key Features

### 1. Activity Management
- **Activity List**: Add, remove, reorder activities
- **Activity Properties**: Title, duration, instructions
- **Activity Sections**: Break down activities into steps
- **Notes**: Teacher and student notes

### 2. Activity Configuration
- **Basic Information**: Name, position, duration
- **Instructions**: Step-by-step instructions
- **Notes**: Teacher and student guidance
- **Sections**: Organize activity into sections

### 3. Activity Types
- **Hands-on Activities**: Physical exercises and experiments
- **Discussion Activities**: Group discussions and reflections
- **Interactive Activities**: Digital tools and simulations
- **Assessment Activities**: Quizzes and evaluations

### 4. Activity Organization
- **Sequencing**: Order activities within lesson
- **Grouping**: Group related activities
- **Timing**: Set duration and pacing
- **Dependencies**: Link activities together

## Navigation Instructions

### Accessing Lesson Activities
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **Select**: Click on a script name
5. **Click**: "Edit" button
6. **Select**: Click on a lesson
7. **Click**: "Activities" tab

### Creating a New Activity
1. **Click**: "New Activity" button
2. **Fill**: Basic activity information
3. **Add Sections**: Break down into steps
4. **Save**: Create the activity

### Editing an Existing Activity
1. **Find**: Activity in the list
2. **Click**: Activity name or "Edit" button
3. **Modify**: Activity properties or sections
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Activity Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Position**: Activity position in lesson
- **Duration**: Estimated time in minutes

### Activity Content
- **Instructions**: Step-by-step instructions
- **Teacher Notes**: Guidance for teachers
- **Student Notes**: Guidance for students
- **Materials**: Required materials list

### Activity Sections
- **Section List**: Drag-and-drop reordering
- **Section Properties**: Title, instructions, notes
- **Section Dependencies**: Link sections together
- **Section Timing**: Set duration for each section

## Example Activity Types

### Hands-on Activities
- **Graph Paper Programming**: Physical algorithm practice
- **Debugging Practice**: Find and fix errors
- **Design Challenges**: Create solutions to problems
- **Prototype Building**: Build physical prototypes

### Discussion Activities
- **Algorithm Discussion**: Talk about problem-solving
- **Reflection Time**: Think about learning
- **Group Problem Solving**: Collaborate on solutions
- **Peer Review**: Review each other's work

### Interactive Activities
- **Digital Simulations**: Use online tools
- **Coding Challenges**: Practice programming
- **Data Analysis**: Work with real data
- **Virtual Experiments**: Test hypotheses

### Assessment Activities
- **Quick Quizzes**: Check understanding
- **Performance Tasks**: Demonstrate skills
- **Portfolio Reviews**: Show progress
- **Peer Assessments**: Evaluate each other

## Validation Rules

### Activity Name
- Must be unique within lesson
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Activity Properties
- Title is required
- Position must be unique within lesson
- Duration must be positive number
- Instructions are required

### Activity Sections
- Sections must have unique positions
- Section instructions are required
- Section dependencies must be valid
- Section timing must be positive

## Screenshots

*Screenshots will be added here showing:*
- Main activities interface
- Activity list with metadata
- Activity editor form
- Section management interface

## Related Views

- [Lesson Editor](lesson-editor.md) - Edit lessons containing activities
- [Activity Sections](activity-sections.md) - Edit activity steps
- [Script Editor](script-editor.md) - Edit scripts containing lessons

## Technical Notes

- Uses `LessonActivity.all` for data loading
- Supports drag-and-drop reordering
- Includes real-time validation
- Handles activity-section relationships
- Supports internationalization and localization
- Changes are tracked for audit purposes