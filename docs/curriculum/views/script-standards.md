# Script Standards Page

**Last Updated**: 2025-01-27  
**Purpose**: Display all educational standards alignment for a curriculum script in a printable format

## Overview

The Script Standards Page provides a comprehensive, printable view of all educational standards that are aligned with a curriculum script. It helps teachers understand how the curriculum addresses specific learning standards and requirements.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/standards`
- **New Format**: `/courses/{course_name}/units/{unit_position}/standards`
- **Controller**: `ScriptsController#standards`
- **View Template**: `dashboard/app/views/scripts/standards.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`stages_standards`** - Standards alignment for lessons
  - `standard_code`, `description`, `position`
  - `framework`, `category`

### Secondary Tables
- **`stages`** - Lessons with standards alignment
  - `name`, `title`, `relative_position`
  - `unplugged`, `lockable`

- **`scripts`** - Script context
  - `name`, `title`, `description`
  - `has_verified_resources`

### Standards Frameworks
- **CSTA**: Computer Science Teachers Association
- **NGSS**: Next Generation Science Standards
- **Common Core**: Math and English Language Arts
- **ISTE**: International Society for Technology in Education

## Key Features Displayed

### 1. Standards List
- All standards aligned with the script
- Standard codes and descriptions
- Framework information
- Lesson references

### 2. Organization
- Grouped by framework
- Sorted by standard code
- Lesson mapping
- Category classification

### 3. Standards Details
- Full standard descriptions
- Learning objectives
- Assessment criteria
- Prerequisites

### 4. Print-Friendly Format
- Optimized for printing
- Clear typography
- Page breaks
- Header and footer information

## Navigation Instructions

### For Teachers
1. **Go to**: `studio.code.org`
2. **Login**: Use your teacher account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Standards" tab
4. **Example URLs**:
   - CS Fundamentals Course 1: `/s/course1/standards`
   - CS Discoveries: `/s/csp1/standards`

### For Administrators
1. **Go to**: `studio.code.org`
2. **Login**: Use admin account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Standards" tab
4. **Review**: Standards alignment for curriculum approval

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Scripts section
   - Select a script
   - Click "Standards" tab

## Example Curriculum Data

### CS Fundamentals Course 1 Standards
- **CSTA 1A-AP-14**: Debug (identify and fix) errors in an algorithm or program
- **CSTA 1A-AP-15**: Create programs with sequences of commands
- **CSTA 1A-AP-16**: Create programs with loops and conditionals
- **CSTA 1A-AP-17**: Decompose problems into smaller subproblems

### CS Discoveries Standards
- **CSTA 2-AP-11**: Create clearly named variables and use them to store data
- **CSTA 2-AP-12**: Design and iteratively develop programs with control structures
- **CSTA 2-AP-13**: Decompose problems and subproblems into parts
- **CSTA 2-AP-14**: Create procedures with parameters

## Standards Frameworks

### CSTA (Computer Science Teachers Association)
- **1A**: Grades K-2 (Ages 5-7)
- **1B**: Grades 3-5 (Ages 8-11)
- **2**: Grades 6-8 (Ages 11-14)
- **3A**: Grades 9-10 (Ages 14-16)
- **3B**: Grades 11-12 (Ages 16-18)

### NGSS (Next Generation Science Standards)
- **Engineering Design**: Problem solving and design thinking
- **Computational Thinking**: Algorithmic thinking and data analysis
- **Crosscutting Concepts**: Patterns, cause and effect, systems

### Common Core
- **Math**: Mathematical practices and content standards
- **English Language Arts**: Reading, writing, speaking, listening
- **Literacy in Science**: Reading and writing in science contexts

### ISTE (International Society for Technology in Education)
- **Computational Thinker**: Problem solving and data analysis
- **Creative Communicator**: Digital communication and expression
- **Digital Citizen**: Responsible technology use

## Screenshots

*Screenshots will be added here showing:*
- Main standards page layout
- Standards list with codes and descriptions
- Framework grouping
- Print preview
- Mobile responsive layout

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Script Vocabulary Page](script-vocabulary.md) - Script vocabulary
- [Script Resources Page](script-resources.md) - Script resources
- [Script Code Page](script-code.md) - Programming expressions

## Technical Notes

- Uses `@unit_summary` data from `Script.summarize_for_rollup()`
- Includes print-friendly CSS styling
- Supports internationalization and localization
- Optimized for printing and PDF generation
- Includes standards filtering and search functionality