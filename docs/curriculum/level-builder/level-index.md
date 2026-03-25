# Level Index

**Last Updated**: 2025-01-27  
**Purpose**: List and manage all coding levels in the level builder interface

## Overview

The Level Index provides a comprehensive list of all coding levels available for editing in the level builder. It allows level builders to search, filter, and manage levels, as well as create new ones.

## URL Patterns

- **Main URL**: `/levels`
- **Controller**: `LevelsController#index`
- **View Template**: `dashboard/app/views/levels/index.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`levels`** - All coding levels
  - `name`, `type`, `title`, `description`
  - `published`, `encrypted`, `user_id`
  - `created_at`, `updated_at`

### Secondary Tables
- **`script_levels`** - Level usage in scripts
  - `position`, `chapter`, `bonus`, `challenge`
  - `assessment`, `lockable`

- **`stages`** - Lessons containing levels
  - `name`, `title`, `relative_position`

- **`scripts`** - Scripts using levels
  - `name`, `title`, `published`

## Key Features Displayed

### 1. Level List
- All available levels
- Level names and types
- Publication status
- Usage information

### 2. Search and Filter
- Search by level name or title
- Filter by level type
- Filter by publication status
- Sort by various criteria

### 3. Level Information
- Level metadata
- Type and description
- Usage in scripts
- Last modified date

### 4. Management Actions
- Create new level
- Edit existing level
- Clone level
- Delete level (with confirmation)

## Navigation Instructions

### Accessing the Level Index
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Levels section
4. **View**: All available levels

### Creating a New Level
1. **Click**: "New Level" button
2. **Select**: Level type from dropdown
3. **Fill**: Basic level information
4. **Save**: Create the level

### Editing an Existing Level
1. **Find**: Level in the list
2. **Click**: Level name or "Edit" button
3. **Modify**: Level properties or configuration
4. **Save**: Changes are saved automatically

## Example Level Data

### Blockly Levels
- **Maze Levels**: Grid-based movement puzzles
- **Artist Levels**: Drawing and geometry
- **Flappy Levels**: Game development
- **Studio Levels**: Sprite-based programming

### Lab Levels
- **App Lab Levels**: Web app development
- **Game Lab Levels**: Game development
- **Web Lab Levels**: HTML/CSS/JavaScript
- **Python Lab Levels**: Python programming

### Assessment Levels
- **Free Response**: Text-based responses
- **Multi**: Multiple choice questions
- **Match**: Matching exercises
- **Text Match**: Text matching

## Level Categories

### Published Levels
- Available for use in scripts
- Fully tested and validated
- Production-ready content

### Draft Levels
- Work in progress
- Not yet published
- Available for editing

### Archived Levels
- No longer active
- Historical reference
- Read-only access

## Screenshots

*Screenshots will be added here showing:*
- Main level index layout
- Level list with metadata
- Search and filter interface
- Create new level dialog

## Related Views

- [Level Editor](level-editor.md) - Edit individual levels
- [Script Editor](script-editor.md) - Edit scripts containing levels
- [Lesson Editor](lesson-editor.md) - Edit lessons containing levels

## Technical Notes

- Uses `Level.all` for data loading
- Supports pagination for large level lists
- Includes search and filter functionality
- Handles level creation and deletion
- Supports internationalization and localization