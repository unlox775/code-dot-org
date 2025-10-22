# Learning Goals

**Last Updated**: 2025-01-27  
**Purpose**: Define and manage learning objectives in the level builder interface

## Overview

The Learning Goals interface allows level builders to create, edit, and manage learning objectives that define what students should know and be able to do. These goals guide curriculum development and assessment.

## URL Patterns

- **Edit Goals**: `/learning_goals/{goal_id}/edit`
- **Create New**: `/learning_goals/new`
- **Controller**: `LearningGoalsController#edit`, `LearningGoalsController#update`
- **View Template**: `dashboard/app/views/learning_goals/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`learning_goals`** - Learning goal data
  - `name`, `description`, `position`
  - `created_at`, `updated_at`

### Secondary Tables
- **`lessons_learning_goals`** - Lesson-learning goal relationships
  - `lesson_id`, `learning_goal_id`, `position`

- **`stages`** - Lessons with learning goals
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

- **`scripts`** - Scripts containing lessons
  - `name`, `title`, `description`
  - `published`, `is_migrated`

## Key Features

### 1. Learning Goal Creation
- **New Goals**: Create new learning objectives
- **Goal Properties**: Name, description, position
- **Goal Categories**: Organize goals by type
- **Goal Dependencies**: Link related goals

### 2. Learning Goal Configuration
- **Basic Information**: Name, description, position
- **Goal Type**: Knowledge, skill, or attitude
- **Grade Level**: Appropriate grade level
- **Subject Area**: Subject or domain

### 3. Learning Goal Types
- **Knowledge Goals**: What students should know
- **Skill Goals**: What students should be able to do
- **Attitude Goals**: What students should value
- **Process Goals**: How students should approach learning

### 4. Learning Goal Integration
- **Lesson Linking**: Link goals to specific lessons
- **Script Linking**: Link goals to entire scripts
- **Course Linking**: Link goals to courses
- **Assessment Linking**: Link goals to assessments

## Navigation Instructions

### Accessing Learning Goals
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Learning Goals section
4. **View**: All available learning goals

### Creating New Learning Goals
1. **Click**: "New Learning Goal" button
2. **Fill**: Goal information
3. **Categorize**: Assign goal type and category
4. **Save**: Create the learning goal

### Managing Learning Goals
1. **Search**: Find specific goals
2. **Filter**: Narrow down results
3. **Edit**: Modify goal properties
4. **Organize**: Categorize and group goals

## Form Fields and Controls

### Basic Information
- **Goal Name**: Unique identifier (required)
- **Description**: Goal description (required)
- **Position**: Order within category
- **Type**: Knowledge, skill, or attitude

### Goal Properties
- **Category**: Goal category
- **Grade Level**: Appropriate grade level
- **Subject Area**: Subject or domain
- **Tags**: Searchable tags

### Goal Integration
- **Lesson Selection**: Choose lessons to link
- **Script Selection**: Choose scripts to link
- **Course Selection**: Choose courses to link
- **Assessment Selection**: Choose assessments to link

## Example Learning Goal Categories

### Programming Skills
- **Algorithm Design**: Create step-by-step solutions
- **Code Implementation**: Write working code
- **Debugging**: Find and fix errors
- **Testing**: Verify code works correctly

### Problem Solving
- **Problem Analysis**: Break down complex problems
- **Solution Design**: Plan effective solutions
- **Implementation**: Execute solution plans
- **Evaluation**: Assess solution effectiveness

### Collaboration
- **Communication**: Share ideas clearly
- **Teamwork**: Work effectively with others
- **Leadership**: Guide group efforts
- **Conflict Resolution**: Handle disagreements constructively

### Critical Thinking
- **Analysis**: Examine information carefully
- **Synthesis**: Combine ideas creatively
- **Evaluation**: Judge quality and value
- **Reflection**: Think about learning process

## Validation Rules

### Learning Goal Name
- Must be unique
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Learning Goal Properties
- Description is required
- Type must be valid
- Grade level must be appropriate
- Subject area must be specified

### Learning Goal Integration
- Lesson must exist
- Script must exist
- Course must exist
- Assessment must exist

## Screenshots

*Screenshots will be added here showing:*
- Main learning goals interface
- Learning goals list with metadata
- Create learning goal form
- Goal integration panel

## Related Views

- [Lesson Editor](lesson-editor.md) - Link goals to lessons
- [Script Editor](script-editor.md) - Link goals to scripts
- [Course Editor](course-editor.md) - Link goals to courses
- [Rubric Editor](rubric-editor.md) - Link goals to rubrics

## Technical Notes

- Uses `LearningGoal.all` for data loading
- Supports search and filter functionality
- Includes goal categorization
- Handles goal-relationship management
- Supports internationalization and localization
- Changes are tracked for audit purposes