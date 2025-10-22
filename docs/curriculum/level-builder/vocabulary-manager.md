# Vocabulary Manager

**Last Updated**: 2025-01-27  
**Purpose**: Manage lesson vocabulary and terminology in the level builder interface

## Overview

The Vocabulary Manager interface allows level builders to create, edit, and manage vocabulary terms used throughout the curriculum. This ensures consistent terminology and provides students with clear definitions.

## URL Patterns

- **Main URL**: `/vocabularies`
- **Controller**: `VocabulariesController#index`, `VocabulariesController#create`, `VocabulariesController#update`
- **View Template**: `dashboard/app/views/vocabularies/index.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`vocabularies`** - Vocabulary term data
  - `word`, `definition`, `context`
  - `example_sentence`, `position`
  - `created_at`, `updated_at`

### Secondary Tables
- **`lessons_vocabularies`** - Lesson-vocabulary relationships
  - `lesson_id`, `vocabulary_id`, `position`

- **`stages`** - Lessons containing vocabulary
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

- **`scripts`** - Scripts containing lessons
  - `name`, `title`, `description`
  - `published`, `is_migrated`

## Key Features

### 1. Vocabulary Management
- **Vocabulary List**: View all vocabulary terms
- **Vocabulary Search**: Find specific terms
- **Vocabulary Filter**: Filter by lesson, script, or category
- **Vocabulary Import**: Import vocabulary from external sources

### 2. Vocabulary Creation
- **New Terms**: Create new vocabulary terms
- **Term Properties**: Word, definition, context
- **Example Sentences**: Provide usage examples
- **Term Organization**: Categorize and organize terms

### 3. Vocabulary Integration
- **Lesson Linking**: Link terms to specific lessons
- **Script Linking**: Link terms to entire scripts
- **Course Linking**: Link terms to courses
- **Cross-References**: Link related terms

### 4. Vocabulary Tools
- **Auto-Suggestions**: Suggest terms based on content
- **Bulk Import**: Import multiple terms at once
- **Vocabulary Templates**: Use pre-defined term patterns
- **Validation**: Check for duplicate or conflicting terms

## Navigation Instructions

### Accessing Vocabulary Manager
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Vocabulary section
4. **View**: All available vocabulary terms

### Creating New Vocabulary
1. **Click**: "New Vocabulary" button
2. **Fill**: Term information
3. **Link**: Connect to lessons or scripts
4. **Save**: Create the vocabulary term

### Managing Vocabulary
1. **Search**: Find specific terms
2. **Filter**: Narrow down results
3. **Edit**: Modify term properties
4. **Organize**: Categorize and group terms

## Form Fields and Controls

### Basic Information
- **Word**: Vocabulary term (required)
- **Definition**: Term definition (required)
- **Context**: Usage context
- **Example Sentence**: Usage example

### Vocabulary Properties
- **Category**: Term category
- **Grade Level**: Appropriate grade level
- **Subject**: Subject area
- **Tags**: Searchable tags

### Vocabulary Integration
- **Lesson Selection**: Choose lessons to link
- **Script Selection**: Choose scripts to link
- **Course Selection**: Choose courses to link
- **Cross-References**: Link related terms

## Example Vocabulary Categories

### Programming Concepts
- **Control Structures**: Loops, conditionals, functions
- **Data Types**: Variables, arrays, objects
- **Operators**: Mathematical, logical, comparison
- **Functions**: Built-in and custom functions

### Computer Science Terms
- **Hardware**: CPU, memory, storage
- **Software**: Operating systems, applications
- **Networks**: Internet, protocols, security
- **Algorithms**: Sorting, searching, optimization

### Problem Solving
- **Debugging**: Finding and fixing errors
- **Design Thinking**: Problem-solving process
- **Computational Thinking**: Algorithmic thinking
- **Collaboration**: Working with others

### Assessment Terms
- **Evaluation**: Assessing student work
- **Rubrics**: Scoring criteria
- **Feedback**: Providing guidance
- **Reflection**: Thinking about learning

## Validation Rules

### Vocabulary Term
- Word must be unique
- Cannot be empty
- Must be valid text
- Cannot contain special characters

### Vocabulary Properties
- Definition is required
- Context must be appropriate
- Example sentence must be valid
- Category must be specified

### Vocabulary Integration
- Lesson must exist
- Script must exist
- Course must exist
- Cross-references must be valid

## Screenshots

*Screenshots will be added here showing:*
- Main vocabulary manager interface
- Vocabulary list with metadata
- Create vocabulary form
- Vocabulary integration panel

## Related Views

- [Lesson Editor](lesson-editor.md) - Edit lessons with vocabulary
- [Script Editor](script-editor.md) - Edit scripts with vocabulary
- [Course Editor](course-editor.md) - Edit courses with vocabulary

## Technical Notes

- Uses `Vocabulary.all` for data loading
- Supports search and filter functionality
- Includes auto-suggestion features
- Handles vocabulary-relationship management
- Supports internationalization and localization
- Changes are tracked for audit purposes