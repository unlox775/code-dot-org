# Script Vocabulary Page

**Last Updated**: 2025-01-27  
**Purpose**: Display all vocabulary terms for a curriculum script in a printable format

## Overview

The Script Vocabulary Page provides a comprehensive, printable view of all vocabulary terms used throughout a curriculum script. It's designed for teachers to print and use as reference material or distribute to students.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/vocab`
- **New Format**: `/courses/{course_name}/units/{unit_position}/vocab`
- **Controller**: `ScriptsController#vocab`
- **View Template**: `dashboard/app/views/scripts/vocab.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`lessons_vocabularies`** - Lesson vocabulary terms
  - `word`, `definition`, `position`
  - `context`, `example_sentence`

### Secondary Tables
- **`stages`** - Lessons containing vocabulary
  - `name`, `title`, `relative_position`
  - `unplugged`, `lockable`

- **`scripts`** - Script context
  - `name`, `title`, `description`
  - `has_verified_resources`

### Join Tables
- **`lessons_vocabularies`** - Links lessons to vocabulary terms
  - `lesson_id`, `vocabulary_id`

## Key Features Displayed

### 1. Vocabulary List
- All vocabulary terms from the script
- Definitions and context
- Example sentences
- Lesson references

### 2. Organization
- Grouped by lesson
- Alphabetical ordering
- Position indicators
- Lesson titles and numbers

### 3. Print-Friendly Format
- Optimized for printing
- Clear typography
- Page breaks
- Header and footer information

### 4. Search and Filter
- Search vocabulary terms
- Filter by lesson
- Sort options
- Export functionality

## Navigation Instructions

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Vocabulary" tab
4. **Example URLs**:
   - CS Fundamentals Course 1: `/s/course1/vocab`
   - CS Discoveries: `/s/csp1/vocab`

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Vocabulary" tab
4. **Print**: Use browser print function

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Scripts section
   - Select a script
   - Click "Vocabulary" tab

## Example Curriculum Data

### CS Fundamentals Course 1 Vocabulary
- **Algorithm**: A list of steps to finish a task
- **Debug**: Finding and fixing problems in code
- **Loop**: The action of doing something over and over again
- **Program**: An algorithm that has been coded into something that can be run by a machine

### CS Discoveries Vocabulary
- **Abstraction**: Pulling out specific differences to make one solution work for multiple problems
- **Data**: Information that is stored in a computer
- **Function**: A piece of code that can be called over and over
- **Variable**: A placeholder for a piece of information that can change

## Vocabulary Categories

### Programming Concepts
- Control structures (loops, conditionals)
- Data types and variables
- Functions and procedures
- Algorithms and logic

### Computer Science Terms
- Hardware and software
- Networks and internet
- Security and privacy
- Artificial intelligence

### Problem Solving
- Debugging and testing
- Design thinking
- Computational thinking
- Collaboration

## Screenshots

*Screenshots will be added here showing:*
- Main vocabulary page layout
- Vocabulary list with definitions
- Print preview
- Mobile responsive layout

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Script Resources Page](script-resources.md) - Other script resources
- [Script Standards Page](script-standards.md) - Standards alignment
- [Script Code Page](script-code.md) - Programming expressions

## Technical Notes

- Uses `@unit_summary` data from `Script.summarize_for_rollup()`
- Includes print-friendly CSS styling
- Supports internationalization and localization
- Optimized for printing and PDF generation
- Includes search and filter functionality