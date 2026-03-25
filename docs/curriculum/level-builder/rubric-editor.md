# Rubric Editor

**Last Updated**: 2025-01-27  
**Purpose**: Create and edit assessment rubrics in the level builder interface

## Overview

The Rubric Editor interface allows level builders to create, edit, and manage assessment rubrics used to evaluate student work. Rubrics provide clear criteria for assessment and help ensure consistent evaluation.

## URL Patterns

- **Edit Rubric**: `/rubrics/{rubric_id}/edit`
- **Create New**: `/rubrics/new`
- **Controller**: `RubricsController#edit`, `RubricsController#update`
- **View Template**: `dashboard/app/views/rubrics/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`rubrics`** - Rubric data
  - `name`, `description`, `key_concept`
  - `performance_level_1` through `performance_level_4`
  - `created_at`, `updated_at`

### Secondary Tables
- **`levels`** - Levels using rubrics
  - `name`, `type`, `title`, `description`
  - `properties` (JSON containing rubric references)

- **`stages`** - Lessons using rubrics
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

## Key Features

### 1. Rubric Creation
- **New Rubrics**: Create new assessment rubrics
- **Rubric Properties**: Name, description, key concept
- **Performance Levels**: Define 4 performance levels
- **Criteria**: Set specific assessment criteria

### 2. Rubric Configuration
- **Basic Information**: Name, description, key concept
- **Performance Levels**: Define what each level means
- **Criteria**: Set specific assessment criteria
- **Scoring**: Define point values and weights

### 3. Rubric Types
- **Analytic Rubrics**: Multiple criteria with separate scores
- **Holistic Rubrics**: Single overall score
- **Checklist Rubrics**: Yes/no criteria
- **Rating Scale Rubrics**: Numerical rating scales

### 4. Rubric Integration
- **Level Linking**: Link rubrics to specific levels
- **Lesson Linking**: Link rubrics to lessons
- **Script Linking**: Link rubrics to entire scripts
- **Course Linking**: Link rubrics to courses

## Navigation Instructions

### Accessing Rubric Editor
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Rubrics section
4. **Select**: Click on a rubric name or "New Rubric"

### Creating a New Rubric
1. **Click**: "New Rubric" button
2. **Fill**: Basic rubric information
3. **Define**: Performance levels and criteria
4. **Save**: Create the rubric

### Editing an Existing Rubric
1. **Find**: Rubric in the list
2. **Click**: Rubric name or "Edit" button
3. **Modify**: Rubric properties or criteria
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Rubric Name**: Unique identifier (required)
- **Description**: Rubric description (required)
- **Key Concept**: Main learning objective
- **Type**: Analytic, holistic, checklist, or rating scale

### Performance Levels
- **Level 1**: Below expectations
- **Level 2**: Approaching expectations
- **Level 3**: Meets expectations
- **Level 4**: Exceeds expectations

### Criteria Configuration
- **Criteria List**: Add, remove, reorder criteria
- **Criteria Description**: What students need to demonstrate
- **Criteria Weight**: Importance of each criterion
- **Criteria Examples**: Specific examples for each level

## Example Rubric Types

### Programming Rubric
- **Criteria 1**: Code Functionality (40%)
- **Criteria 2**: Code Quality (30%)
- **Criteria 3**: Problem Solving (20%)
- **Criteria 4**: Documentation (10%)

### Design Rubric
- **Criteria 1**: User Experience (35%)
- **Criteria 2**: Visual Design (25%)
- **Criteria 3**: Functionality (25%)
- **Criteria 4**: Innovation (15%)

### Presentation Rubric
- **Criteria 1**: Content (40%)
- **Criteria 2**: Organization (25%)
- **Criteria 3**: Delivery (25%)
- **Criteria 4**: Visual Aids (10%)

### Collaboration Rubric
- **Criteria 1**: Communication (30%)
- **Criteria 2**: Contribution (30%)
- **Criteria 3**: Respect (20%)
- **Criteria 4**: Leadership (20%)

## Validation Rules

### Rubric Name
- Must be unique
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Rubric Properties
- Description is required
- Key concept must be specified
- Type must be valid
- Performance levels must be defined

### Criteria Configuration
- Criteria must be meaningful
- Weights must sum to 100%
- Examples must be appropriate
- Levels must be distinct

## Screenshots

*Screenshots will be added here showing:*
- Main rubric editor interface
- Rubric creation form
- Performance level configuration
- Criteria management panel

## Related Views

- [Level Editor](level-editor.md) - Link rubrics to levels
- [Lesson Editor](lesson-editor.md) - Link rubrics to lessons
- [Script Editor](script-editor.md) - Link rubrics to scripts

## Technical Notes

- Uses `Rubric.find()` for data loading
- Supports multiple rubric types
- Includes real-time validation
- Handles rubric-relationship management
- Supports internationalization and localization
- Changes are tracked for audit purposes