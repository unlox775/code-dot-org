# Script Code Page

**Last Updated**: 2025-01-27  
**Purpose**: Display all programming expressions and code concepts for a curriculum script in a printable format

## Overview

The Script Code Page provides a comprehensive, printable view of all programming expressions, code concepts, and programming language elements used throughout a curriculum script. It's designed for teachers and students to reference programming concepts and syntax.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/code`
- **New Format**: `/courses/{course_name}/units/{unit_position}/code`
- **Controller**: `ScriptsController#code`
- **View Template**: `dashboard/app/views/scripts/code.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`programming_expressions`** - Programming language elements
  - `name`, `category`, `description`
  - `syntax`, `example`, `documentation`

### Secondary Tables
- **`lessons_programming_expressions`** - Lesson-programming expression links
  - `lesson_id`, `programming_expression_id`, `position`

- **`stages`** - Lessons using programming expressions
  - `name`, `title`, `relative_position`
  - `unplugged`, `lockable`

- **`scripts`** - Script context
  - `name`, `title`, `description`
  - `has_verified_resources`

### Programming Categories
- **Control Structures**: Loops, conditionals, functions
- **Data Types**: Variables, arrays, objects
- **Operators**: Mathematical, logical, comparison
- **Functions**: Built-in and custom functions
- **Events**: User interactions and system events

## Key Features Displayed

### 1. Programming Expressions List
- All programming concepts used in the script
- Syntax and examples
- Category organization
- Lesson references

### 2. Code Examples
- Syntax examples
- Usage patterns
- Best practices
- Common mistakes

### 3. Organization
- Grouped by category
- Sorted alphabetically
- Lesson mapping
- Difficulty indicators

### 4. Print-Friendly Format
- Optimized for printing
- Clear typography
- Code highlighting
- Page breaks

## Navigation Instructions

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Code" tab
4. **Example URLs**:
   - CS Fundamentals Course 1: `/s/course1/code`
   - CS Discoveries: `/s/csp1/code`

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Code" tab
4. **Reference**: Use as programming reference

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Scripts section
   - Select a script
   - Click "Code" tab

## Example Curriculum Data

### CS Fundamentals Course 1 Code
- **moveForward()**: Move the character forward one space
- **turnLeft()**: Turn the character left 90 degrees
- **turnRight()**: Turn the character right 90 degrees
- **repeat**: Execute a block of code multiple times

### CS Discoveries Code
- **if/else**: Conditional statements for decision making
- **for loops**: Repeat code a specific number of times
- **while loops**: Repeat code while a condition is true
- **functions**: Reusable blocks of code

### CS Principles Code
- **variables**: Store and retrieve data
- **arrays**: Store multiple values in a list
- **objects**: Store related data and functions
- **APIs**: Application Programming Interfaces

## Programming Categories

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

## Screenshots

*Screenshots will be added here showing:*
- Main code page layout
- Programming expressions list
- Code examples and syntax
- Print preview
- Mobile responsive layout

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Script Vocabulary Page](script-vocabulary.md) - Script vocabulary
- [Script Resources Page](script-resources.md) - Script resources
- [Script Standards Page](script-standards.md) - Standards alignment

## Technical Notes

- Uses `@unit_summary` data from `Script.summarize_for_rollup()`
- Includes print-friendly CSS styling
- Supports code syntax highlighting
- Optimized for printing and PDF generation
- Includes programming expression filtering and search functionality