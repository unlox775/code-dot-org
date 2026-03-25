# Programming Expressions

**Last Updated**: 2025-01-27  
**Purpose**: Manage programming concepts and expressions in the level builder interface

## Overview

The Programming Expressions interface allows level builders to create, edit, and manage programming concepts and expressions used throughout the curriculum. This ensures consistent terminology and provides students with clear programming guidance.

## URL Patterns

- **Main URL**: `/programming_expressions`
- **Controller**: `ProgrammingExpressionsController#index`, `ProgrammingExpressionsController#create`, `ProgrammingExpressionsController#update`
- **View Template**: `dashboard/app/views/programming_expressions/index.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`programming_expressions`** - Programming expression data
  - `name`, `category`, `description`
  - `syntax`, `example`, `documentation`
  - `created_at`, `updated_at`

### Secondary Tables
- **`lessons_programming_expressions`** - Lesson-programming expression relationships
  - `lesson_id`, `programming_expression_id`, `position`

- **`stages`** - Lessons containing programming expressions
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

- **`scripts`** - Scripts containing lessons
  - `name`, `title`, `description`
  - `published`, `is_migrated`

## Key Features

### 1. Expression Management
- **Expression List**: View all programming expressions
- **Expression Search**: Find specific expressions
- **Expression Filter**: Filter by category, language, or difficulty
- **Expression Import**: Import expressions from external sources

### 2. Expression Creation
- **New Expressions**: Create new programming concepts
- **Expression Properties**: Name, category, description
- **Syntax Examples**: Provide code syntax
- **Documentation**: Add detailed explanations

### 3. Expression Categories
- **Control Structures**: Loops, conditionals, functions
- **Data Types**: Variables, arrays, objects
- **Operators**: Mathematical, logical, comparison
- **Functions**: Built-in and custom functions

### 4. Expression Integration
- **Lesson Linking**: Link expressions to specific lessons
- **Script Linking**: Link expressions to entire scripts
- **Course Linking**: Link expressions to courses
- **Cross-References**: Link related expressions

## Navigation Instructions

### Accessing Programming Expressions
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Programming Expressions section
4. **View**: All available programming expressions

### Creating New Expressions
1. **Click**: "New Expression" button
2. **Fill**: Expression information
3. **Add Syntax**: Provide code examples
4. **Save**: Create the expression

### Managing Expressions
1. **Search**: Find specific expressions
2. **Filter**: Narrow down results
3. **Edit**: Modify expression properties
4. **Organize**: Categorize and group expressions

## Form Fields and Controls

### Basic Information
- **Expression Name**: Unique identifier (required)
- **Category**: Expression category (required)
- **Description**: Expression description (required)
- **Language**: Programming language

### Expression Properties
- **Syntax**: Code syntax example
- **Example**: Usage example
- **Documentation**: Detailed explanation
- **Tags**: Searchable tags

### Expression Integration
- **Lesson Selection**: Choose lessons to link
- **Script Selection**: Choose scripts to link
- **Course Selection**: Choose courses to link
- **Cross-References**: Link related expressions

## Example Expression Categories

### Control Structures
- **Loops**: for, while, repeat
- **Conditionals**: if, else, elif
- **Functions**: define, call, return
- **Events**: onEvent, onClick, onKeyPress

### Data Types
- **Variables**: var, let, const
- **Numbers**: integers, floats, calculations
- **Strings**: text, concatenation, formatting
- **Booleans**: true, false, comparisons

### Operators
- **Mathematical**: +, -, *, /, %
- **Logical**: &&, ||, !
- **Comparison**: ==, !=, <, >, <=, >=
- **Assignment**: =, +=, -=, *=, /=

### Functions
- **Built-in**: print, input, length
- **Custom**: define, parameters, return
- **Methods**: string methods, array methods
- **Callbacks**: event handlers, timers

## Validation Rules

### Expression Name
- Must be unique
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Expression Properties
- Category is required
- Description is required
- Syntax must be valid
- Example must be appropriate

### Expression Integration
- Lesson must exist
- Script must exist
- Course must exist
- Cross-references must be valid

## Screenshots

*Screenshots will be added here showing:*
- Main programming expressions interface
- Expression list with metadata
- Create expression form
- Expression integration panel

## Related Views

- [Lesson Editor](lesson-editor.md) - Link expressions to lessons
- [Script Editor](script-editor.md) - Link expressions to scripts
- [Course Editor](course-editor.md) - Link expressions to courses
- [Vocabulary Manager](vocabulary-manager.md) - Manage related vocabulary

## Technical Notes

- Uses `ProgrammingExpression.all` for data loading
- Supports search and filter functionality
- Includes syntax highlighting
- Handles expression-relationship management
- Supports internationalization and localization
- Changes are tracked for audit purposes