# Level Properties

**Last Updated**: 2025-01-27  
**Purpose**: Configure advanced level properties and settings in the level builder interface

## Overview

The Level Properties interface allows level builders to configure advanced properties and settings for coding levels. This includes level-specific configuration, validation rules, and other level-level settings.

## URL Patterns

- **Edit Properties**: `/levels/{level_id}/properties`
- **Controller**: `LevelsController#level_properties`
- **View Template**: `dashboard/app/views/levels/properties.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`levels`** - Level configuration
  - `name`, `type`, `title`, `description`
  - `properties` (JSON containing level-specific configuration)
  - `instructions`, `hint`, `solution_blocks`
  - `encrypted`, `published`, `user_id`

### Secondary Tables
- **`script_levels`** - Level usage settings
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

- **`rubrics`** - Assessment rubrics
  - `name`, `description`, `key_concept`

- **`learning_goals`** - Learning objectives
  - `name`, `description`, `position`

## Key Features

### 1. Basic Properties
- Level name and title
- Type and description
- Instructions and hints
- Solution blocks

### 2. Level-Specific Configuration
- **Blockly Levels**: Toolbox, start blocks, validation
- **Lab Levels**: Code editor settings, data tables
- **Assessment Levels**: Questions, answers, scoring
- **Unplugged Levels**: Activities, worksheets, videos

### 3. Advanced Settings
- Encryption settings
- Publication status
- Validation rules
- Success conditions

### 4. Assessment Configuration
- Rubric assignment
- Learning goals
- Scoring criteria
- Feedback settings

## Navigation Instructions

### Accessing Level Properties
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Levels section
4. **Select**: Click on a level name
5. **Click**: "Properties" tab

### Configuring Properties
1. **Modify**: Change level properties
2. **Validate**: Check for errors
3. **Save**: Apply changes
4. **Test**: Verify properties work correctly

## Form Fields and Controls

### Basic Information
- **Level Name**: Unique identifier
- **Title**: Display title
- **Type**: Level type (cannot be changed)
- **Description**: Level description

### Level-Specific Fields
- **Blockly Levels**: Toolbox XML, start blocks, solution blocks
- **Lab Levels**: Code editor settings, design mode options
- **Assessment Levels**: Question text, answer options, scoring
- **Unplugged Levels**: Activity instructions, worksheet links

### Advanced Configuration
- **Properties**: JSON configuration for level behavior
- **Validation**: Success/failure conditions
- **Hints**: Student help and guidance
- **Encryption**: Encrypt sensitive data

### Assessment Settings
- **Rubric**: Assessment rubric configuration
- **Learning Goals**: Learning objective definitions
- **Scoring**: Point values and grading criteria
- **Feedback**: Automated feedback messages

## Example Configurations

### Maze Level Properties
- **Type**: Maze
- **Toolbox**: Basic movement blocks
- **Start Blocks**: Empty workspace
- **Solution**: moveForward(); moveForward();
- **Validation**: Check if character reaches goal

### App Lab Level Properties
- **Type**: Applab
- **Design Mode**: Button and label creation
- **Code Mode**: JavaScript editor
- **Validation**: Check if app displays "Hello World"
- **Hints**: "Use setText() function"

### Assessment Level Properties
- **Type**: Multi
- **Questions**: Multiple choice questions
- **Answers**: Correct answer options
- **Scoring**: 1 point per correct answer
- **Rubric**: Assessment criteria

## Validation Rules

### Level Name
- Must be unique
- Cannot be changed after creation
- Must be valid identifier

### Level Type
- Cannot be changed after creation
- Determines available configuration options
- Must be one of supported types

### Level Properties
- Must be valid JSON
- Must conform to level type schema
- Required fields must be present

## Screenshots

*Screenshots will be added here showing:*
- Main properties interface
- Level-specific configuration
- Form fields and controls
- Validation messages

## Related Views

- [Level Editor](level-editor.md) - Edit level content
- [Level Index](level-index.md) - List all levels
- [Rubric Editor](rubric-editor.md) - Create assessment rubrics

## Technical Notes

- Uses `Level.find()` for data loading
- Supports real-time validation
- Handles multiple level types with different interfaces
- Includes audit logging for changes
- Supports internationalization and localization