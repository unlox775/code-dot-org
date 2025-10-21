# Standards Alignment

**Last Updated**: 2025-01-27  
**Purpose**: Align curriculum content to educational standards in the level builder interface

## Overview

The Standards Alignment interface allows level builders to align curriculum content to educational standards including CSTA, NGSS, Common Core, and ISTE standards. This ensures curriculum meets educational requirements.

## URL Patterns

- **Edit Alignment**: `/standards/alignment`
- **Controller**: `StandardsController#alignment`, `StandardsController#update_alignment`
- **View Template**: `dashboard/app/views/standards/alignment.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`stages_standards`** - Lesson-standards relationships
  - `lesson_id`, `standard_id`, `position`
  - `created_at`, `updated_at`

- **`standards`** - Educational standards
  - `name`, `description`, `framework`
  - `category`, `grade_level`, `subject`

### Secondary Tables
- **`stages`** - Lessons with standards alignment
  - `name`, `title`, `description`
  - `relative_position`, `unplugged`

- **`scripts`** - Scripts containing lessons
  - `name`, `title`, `description`
  - `published`, `is_migrated`

## Key Features

### 1. Standards Management
- **Standards List**: View all available standards
- **Standards Search**: Find specific standards
- **Standards Filter**: Filter by framework, grade, subject
- **Standards Import**: Import standards from external sources

### 2. Alignment Management
- **Lesson Alignment**: Align lessons to standards
- **Script Alignment**: Align entire scripts to standards
- **Alignment Validation**: Check alignment completeness
- **Alignment Reports**: Generate alignment reports

### 3. Standards Frameworks
- **CSTA**: Computer Science Teachers Association
- **NGSS**: Next Generation Science Standards
- **Common Core**: Math and English Language Arts
- **ISTE**: International Society for Technology in Education

### 4. Alignment Tools
- **Auto-Alignment**: Suggest standards based on content
- **Bulk Alignment**: Align multiple lessons at once
- **Alignment Templates**: Use pre-defined alignment patterns
- **Alignment Validation**: Check for missing alignments

## Navigation Instructions

### Accessing Standards Alignment
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Standards section
4. **Click**: "Alignment" tab

### Aligning Lessons to Standards
1. **Select**: Choose lesson to align
2. **Search**: Find relevant standards
3. **Align**: Link lesson to standards
4. **Save**: Apply alignment changes

### Bulk Alignment
1. **Select**: Choose multiple lessons
2. **Template**: Use alignment template
3. **Review**: Check suggested alignments
4. **Apply**: Apply bulk alignments

## Form Fields and Controls

### Standards Selection
- **Framework**: Choose standards framework
- **Grade Level**: Select grade level
- **Subject**: Choose subject area
- **Search**: Search for specific standards

### Alignment Configuration
- **Lesson Selection**: Choose lessons to align
- **Standard Selection**: Choose standards to align
- **Alignment Type**: Required, recommended, or optional
- **Notes**: Additional alignment notes

### Alignment Management
- **Add Alignment**: Link lesson to standard
- **Remove Alignment**: Unlink lesson from standard
- **Edit Alignment**: Modify alignment details
- **Validate Alignment**: Check alignment completeness

## Example Standards Frameworks

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

## Validation Rules

### Standards Selection
- Framework must be valid
- Grade level must be appropriate
- Subject must be relevant
- Standard must exist

### Alignment Configuration
- Lesson must exist
- Standard must be valid
- Alignment type must be specified
- Notes must be appropriate

### Alignment Management
- Cannot create duplicate alignments
- Alignment must be meaningful
- Validation must pass
- Reports must be accurate

## Screenshots

*Screenshots will be added here showing:*
- Main standards alignment interface
- Standards selection panel
- Lesson alignment form
- Alignment validation results

## Related Views

- [Lesson Editor](lesson-editor.md) - Edit lessons with standards
- [Script Editor](script-editor.md) - Edit scripts with standards
- [Course Editor](course-editor.md) - Edit courses with standards

## Technical Notes

- Uses `Standard.all` for data loading
- Supports multiple standards frameworks
- Includes auto-alignment suggestions
- Handles bulk alignment operations
- Supports internationalization and localization
- Changes are tracked for audit purposes