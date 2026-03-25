# Level Editor

**Last Updated**: 2025-01-27  
**Purpose**: Create and edit individual coding levels and activities in the level builder interface

## Overview

The Level Editor is the core interface for creating and modifying individual levels. It supports multiple level types including Blockly puzzles, Lab environments, assessment levels, and unplugged activities. Each level type has its own specialized editing interface.

## URL Patterns

- **Edit Existing**: `/levels/{level_id}/edit`
- **Create New**: `/levels/new?type={level_type}`
- **Controller**: `LevelsController#edit`, `LevelsController#update`, `LevelsController#create`
- **View Template**: `dashboard/app/views/levels/edit.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`levels`** - Main level data
  - `name`, `type`, `level_num`, `title`, `description`
  - `properties` (JSON containing level-specific configuration)
  - `instructions`, `hint`, `solution_blocks`
  - `encrypted`, `published`, `user_id`

### Secondary Tables
- **`script_levels`** - Level positioning (when edited in script context)
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

- **`levels_script_levels`** - Complex level relationships
  - `position`, `kind`

### Assessment Tables
- **`rubrics`** - Level assessment rubrics
  - `name`, `description`, `key_concept`
  - `performance_level_1` through `performance_level_4`

- **`learning_goals`** - Specific learning objectives
  - `name`, `description`, `position`

### Resource Tables
- **`level_sources`** - Level solution data
- **`level_assets`** - Level-specific assets

## Supported Level Types

### Blockly-Based Levels
- **Maze**: Grid-based movement puzzles
- **Artist**: Drawing and geometry
- **Flappy**: Game development
- **Studio**: Sprite-based programming
- **Bounce**: Physics-based games

### Lab-Based Levels
- **App Lab**: Web app development
- **Game Lab**: Game development
- **Web Lab**: HTML/CSS/JavaScript
- **Python Lab**: Python programming
- **Java Lab**: Java programming
- **Music Lab**: Music programming

### Assessment Levels
- **Free Response**: Text-based responses
- **Multi**: Multiple choice questions
- **Match**: Matching exercises
- **Text Match**: Text matching
- **Evaluation Multi**: Multi-part assessments

### Specialized Levels
- **Unplugged**: Offline activities
- **Standalone Video**: Video content
- **Curriculum Reference**: External content
- **Level Group**: Collections of sub-levels
- **Bubble Choice**: Student choice levels

## Key Features

### 1. Level Properties
- **Basic Information**: Name, title, description
- **Level Type**: Select from supported types
- **Level Number**: Sequential numbering
- **Instructions**: Student-facing instructions

### 2. Level-Specific Configuration
- **Blockly Levels**: Toolbox, start blocks, solution blocks
- **Lab Levels**: Code editor, design mode, data tables
- **Assessment Levels**: Questions, answer options, scoring
- **Unplugged Levels**: Activities, worksheets, videos

### 3. Advanced Settings
- **Encryption**: Encrypt sensitive level data
- **Publishing**: Control level visibility
- **Validation**: Set success/failure conditions
- **Hints**: Provide student hints and help

### 4. Asset Management
- **Images**: Upload and manage images
- **Audio**: Add sound effects and music
- **Videos**: Embed instructional videos
- **Documents**: Attach worksheets and guides

### 5. Assessment Configuration
- **Rubrics**: Create assessment rubrics
- **Learning Goals**: Define learning objectives
- **Scoring**: Configure point values and grading
- **Feedback**: Set up automated feedback

## Navigation Instructions

### Accessing the Level Editor
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Levels section
4. **Select**: Click on a level name or "New Level"

### Creating a New Level
1. **Click**: "New Level" button
2. **Select**: Level type from dropdown
3. **Fill**: Basic level information
4. **Configure**: Level-specific settings
5. **Save**: Create the level

### Editing an Existing Level
1. **Find**: Level in the levels list
2. **Click**: Level name or "Edit" button
3. **Modify**: Level properties or configuration
4. **Save**: Changes are saved automatically

## Form Fields and Controls

### Basic Information
- **Level Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Description**: Level description
- **Level Number**: Sequential number
- **Type**: Level type selection

### Level-Specific Fields
- **Blockly Levels**: Toolbox XML, start blocks, solution blocks
- **Lab Levels**: Code editor settings, design mode options
- **Assessment Levels**: Question text, answer options, scoring
- **Unplugged Levels**: Activity instructions, worksheet links

### Advanced Configuration
- **Properties**: JSON configuration for level behavior
- **Validation**: Success/failure conditions
- **Hints**: Student help and guidance
- **Assets**: Images, audio, video, documents

### Assessment Settings
- **Rubric**: Assessment rubric configuration
- **Learning Goals**: Learning objective definitions
- **Scoring**: Point values and grading criteria
- **Feedback**: Automated feedback messages

## Example Workflows

### Creating a Maze Level
1. **Select Type**: Choose "Maze" from dropdown
2. **Set Properties**: Name "maze_1", Title "Move Forward"
3. **Configure Grid**: Set up 8x8 grid with walls
4. **Add Toolbox**: Include movement blocks
5. **Set Solution**: Define expected solution
6. **Test Level**: Verify level works correctly

### Creating an App Lab Level
1. **Select Type**: Choose "Applab" from dropdown
2. **Set Properties**: Name "app_hello_world", Title "Hello World"
3. **Configure Design**: Set up button and label
4. **Add Code**: Provide starter code
5. **Set Validation**: Define success conditions
6. **Test Level**: Verify app works correctly

### Creating an Assessment Level
1. **Select Type**: Choose "Multi" from dropdown
2. **Set Properties**: Name "quiz_loops", Title "Loop Quiz"
3. **Add Questions**: Create multiple choice questions
4. **Set Answers**: Define correct answers
5. **Configure Scoring**: Set point values
6. **Test Level**: Verify assessment works correctly

## Validation Rules

### Level Name
- Must be unique across all levels
- Cannot contain special characters
- Must be valid identifier
- Cannot be changed after creation

### Level Type
- Must be one of supported types
- Cannot be changed after creation
- Determines available configuration options

### Level Properties
- Must be valid JSON
- Must conform to level type schema
- Required fields must be present

## Screenshots

*Screenshots will be added here showing:*
- Main level editor interface
- Level type selection
- Blockly level configuration
- Lab level configuration
- Assessment level configuration
- Form validation messages

## Related Views

- [Script Editor](script-editor.md) - Edit scripts containing levels
- [Level Index](level-index.md) - List all levels
- [Rubric Editor](rubric-editor.md) - Create assessment rubrics
- [Resource Manager](resource-manager.md) - Manage level assets

## Technical Notes

- Uses `Level.summarize_for_edit()` for data loading
- Supports real-time validation and auto-save
- Handles multiple level types with different interfaces
- Includes drag-and-drop functionality for assets
- Supports internationalization and localization
- Changes are tracked for audit purposes
- Level properties are stored as JSON for flexibility