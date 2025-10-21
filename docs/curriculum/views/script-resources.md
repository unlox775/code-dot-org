# Script Resources Page

**Last Updated**: 2025-01-27  
**Purpose**: Display all resources for a curriculum script in a printable format

## Overview

The Script Resources Page provides a comprehensive, printable view of all resources associated with a curriculum script. It includes teacher resources, student resources, and lesson-specific materials organized for easy reference and printing.

## URL Patterns

- **Legacy Format**: `/s/{script_name}/resources`
- **New Format**: `/courses/{course_name}/units/{unit_position}/resources`
- **Controller**: `ScriptsController#resources`
- **View Template**: `dashboard/app/views/scripts/resources.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`scripts_resources`** - Script-specific resources
  - `name`, `url`, `type`, `position`
  - `description`, `audience`

- **`scripts_student_resources`** - Student-facing resources
  - `name`, `url`, `type`, `position`
  - `description`, `audience`

### Secondary Tables
- **`lessons_resources`** - Lesson-specific resources
  - `name`, `url`, `type`, `position`
  - `description`, `audience`

- **`stages`** - Lessons containing resources
  - `name`, `title`, `relative_position`
  - `unplugged`, `lockable`

- **`scripts`** - Script context
  - `name`, `title`, `description`
  - `has_verified_resources`

### Resource Types
- **Teacher Resources**: Guides, lesson plans, answer keys
- **Student Resources**: Worksheets, handouts, reference materials
- **Digital Resources**: Links to online tools and websites
- **Print Resources**: PDFs and printable materials

## Key Features Displayed

### 1. Resource Categories
- Teacher resources
- Student resources
- Lesson-specific resources
- Digital and print materials

### 2. Resource Information
- Resource name and description
- URL or file location
- Resource type and audience
- Lesson references

### 3. Organization
- Grouped by resource type
- Sorted by lesson or position
- Clear categorization
- Easy navigation

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
   - Click on "Resources" tab
4. **Example URLs**:
   - CS Fundamentals Course 1: `/s/course1/resources`
   - CS Discoveries: `/s/csp1/resources`

### For Students
1. **Go to**: `studio.code.org`
2. **Login**: Use your student account
3. **Navigate**: 
   - Go to a script overview page
   - Click on "Resources" tab
4. **Access**: Click on resource links

### For Level Builders
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use levelbuilder account
3. **Navigate**: 
   - Go to Scripts section
   - Select a script
   - Click "Resources" tab

## Example Curriculum Data

### CS Fundamentals Course 1 Resources
- **Teacher Guide**: Complete lesson plans and activities
- **Student Handouts**: Worksheets and activity sheets
- **Answer Keys**: Solutions for all activities
- **Videos**: Instructional videos for each lesson
- **Printouts**: Unplugged activity materials

### CS Discoveries Resources
- **Unit Overviews**: High-level unit descriptions
- **Lesson Plans**: Detailed lesson instructions
- **Student Workbooks**: Student activity books
- **Assessment Rubrics**: Evaluation criteria
- **Extension Activities**: Additional challenges

## Resource Types

### Teacher Resources
- Lesson plans and guides
- Answer keys and solutions
- Assessment rubrics
- Professional development materials
- Standards alignment documents

### Student Resources
- Worksheets and handouts
- Reference materials
- Activity sheets
- Study guides
- Project templates

### Digital Resources
- Online tools and websites
- Interactive simulations
- Video tutorials
- Coding environments
- Assessment platforms

### Print Resources
- PDF documents
- Printable worksheets
- Handout materials
- Reference cards
- Activity instructions

## Screenshots

*Screenshots will be added here showing:*
- Main resources page layout
- Resource categories and listings
- Print preview
- Mobile responsive layout

## Related Views

- [Script Overview Page](script-overview.md) - Return to script overview
- [Script Vocabulary Page](script-vocabulary.md) - Script vocabulary
- [Script Standards Page](script-standards.md) - Standards alignment
- [Script Code Page](script-code.md) - Programming expressions

## Technical Notes

- Uses `@unit_summary` data from `Script.summarize_for_rollup()`
- Includes print-friendly CSS styling
- Supports internationalization and localization
- Optimized for printing and PDF generation
- Includes resource filtering and search functionality