# Curriculum User-Facing Views

**Last Updated**: 2025-01-27  
**Purpose**: Documentation of all user-facing pages that display curriculum data

## Overview

This directory contains documentation for every distinct view or page that displays curriculum data to users (students, teachers, and administrators). Each view is documented with:

- **Purpose**: What the view is for and who uses it
- **URL Pattern**: How to access the view
- **Curriculum Tables Used**: Which curriculum tables are queried
- **Key Columns**: Which specific columns are displayed or used
- **Navigation Instructions**: Step-by-step instructions to reach the view
- **Example Screenshots**: Placeholder for actual screenshots

## View Categories

### 1. Script/Unit Views
- [Script Overview Page](script-overview.md) - Main script landing page
- [Script Resources Page](script-resources.md) - Script-specific resources
- [Script Standards Page](script-standards.md) - Standards alignment for script
- [Script Vocabulary Page](script-vocabulary.md) - Vocabulary for entire script
- [Script Code Page](script-code.md) - Programming expressions for script

### 2. Lesson Views
- [Lesson Overview Page](lesson-overview.md) - Individual lesson landing page
- [Lesson Extras Page](lesson-extras.md) - Bonus levels and additional content

### 3. Level Views
- [Level Play Page](level-play.md) - Main level playing interface
- [Level Properties API](level-properties-api.md) - JSON API for level data
- [Level Rubric API](level-rubric-api.md) - JSON API for level rubrics

### 4. Course Views
- [Course Catalog Page](course-catalog.md) - Browse available courses
- [Course Overview Page](course-overview.md) - Individual course landing page

### 5. Teacher Dashboard Views
- [Teacher Script View](teacher-script-view.md) - Teacher's view of script progress
- [Student Progress View](student-progress-view.md) - Teacher viewing student progress

## Navigation Instructions

Each view includes detailed navigation instructions to help users find specific examples. Instructions typically include:

1. **Starting Point**: Where to begin (e.g., "Go to studio.code.org")
2. **Authentication**: Login requirements if any
3. **Navigation Steps**: Step-by-step path to the view
4. **Example Data**: Specific curriculum examples to look for
5. **URL Patterns**: Direct URL patterns for the view

## Curriculum Table Usage

Each view documents:
- **Primary Tables**: Main curriculum tables queried
- **Secondary Tables**: Supporting tables used
- **Join Tables**: Relationship tables accessed
- **User Progress Tables**: Student progress data displayed
- **Key Columns**: Specific columns that affect the display

## Screenshots

Each view documentation includes placeholders for screenshots that will be added later:
- **Main View Screenshot**: Overall page layout
- **Detail Screenshots**: Specific sections or features
- **Mobile Screenshots**: Mobile-responsive versions where applicable

## Related Documentation

- [Curriculum Data Model](../data-model.md) - Understanding the underlying data structure
- [Level Builder Views](../level-builder/) - Curriculum editing interfaces
- [GUID Migration Plan](../../../experimental/curriculum_guid_migration/README.md) - Data migration details