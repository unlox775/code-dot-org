# Script Index

**Last Updated**: 2025-01-27  
**Purpose**: List and manage all curriculum scripts in the level builder interface

## Overview

The Script Index provides a comprehensive list of all curriculum scripts available for editing in the level builder. It allows level builders to search, filter, and manage scripts, as well as create new ones.

## URL Patterns

- **Main URL**: `/scripts`
- **Controller**: `ScriptsController#index`
- **View Template**: `dashboard/app/views/scripts/index.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`scripts`** - All curriculum scripts
  - `name`, `title`, `description`, `published`
  - `login_required`, `hideable_lessons`, `is_migrated`
  - `created_at`, `updated_at`, `user_id`

### Secondary Tables
- **`stages`** - Lessons within scripts
  - `name`, `title`, `relative_position`
  - `unplugged`, `lockable`, `has_lesson_plan`

- **`script_levels`** - Level counts
  - `position`, `chapter`, `bonus`, `challenge`

- **`unit_groups`** - Script families
  - `name`, `title`, `family_name`

## Key Features Displayed

### 1. Script List
- All available scripts
- Script titles and descriptions
- Publication status
- Migration status

### 2. Search and Filter
- Search by script name or title
- Filter by publication status
- Filter by migration status
- Sort by various criteria

### 3. Script Information
- Script metadata
- Lesson counts
- Level counts
- Last modified date

### 4. Management Actions
- Create new script
- Edit existing script
- Clone script
- Delete script (with confirmation)

## Navigation Instructions

### Accessing the Script Index
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Scripts section
4. **View**: All available scripts

### Creating a New Script
1. **Click**: "New Script" button
2. **Fill**: Basic script information
3. **Save**: Create the script
4. **Edit**: Configure lessons and levels

### Editing an Existing Script
1. **Find**: Script in the list
2. **Click**: Script name or "Edit" button
3. **Modify**: Script properties, lessons, or levels
4. **Save**: Changes are saved automatically

## Example Script Data

### CS Fundamentals Scripts
- **Course 1**: 20 lessons, 4 levels per lesson
- **Course 2**: 20 lessons, 4 levels per lesson
- **Course 3**: 20 lessons, 4 levels per lesson
- **Course 4**: 20 lessons, 4 levels per lesson

### CS Discoveries Scripts
- **Unit 1**: 6 lessons, 8 levels per lesson
- **Unit 2**: 6 lessons, 8 levels per lesson
- **Unit 3**: 6 lessons, 8 levels per lesson
- **Unit 4**: 6 lessons, 8 levels per lesson

## Script Categories

### Published Scripts
- Available to students and teachers
- Fully tested and validated
- Production-ready content

### Draft Scripts
- Work in progress
- Not yet published
- Available for editing

### Archived Scripts
- No longer active
- Historical reference
- Read-only access

## Screenshots

*Screenshots will be added here showing:*
- Main script index layout
- Script list with metadata
- Search and filter interface
- Create new script dialog

## Related Views

- [Script Editor](script-editor.md) - Edit individual scripts
- [Level Editor](level-editor.md) - Edit individual levels
- [Course Editor](course-editor.md) - Edit courses

## Technical Notes

- Uses `Script.all` for data loading
- Supports pagination for large script lists
- Includes search and filter functionality
- Handles script creation and deletion
- Supports internationalization and localization