# Curriculum Level Builder Views

**Last Updated**: 2025-01-27  
**Purpose**: Documentation of all level builder screens that modify curriculum tables

## Overview

This directory contains documentation for all level builder interfaces that allow curriculum developers and level builders to create, edit, and manage curriculum content. These interfaces modify the curriculum tables documented in the main data model.

## View Categories

### 1. Script/Unit Management
- [Script Editor](script-editor.md) - Create and edit curriculum scripts
- [Script Index](script-index.md) - List and manage all scripts
- [Script Settings](script-settings.md) - Configure script properties

### 2. Level Management
- [Level Editor](level-editor.md) - Create and edit individual levels
- [Level Index](level-index.md) - List and manage all levels
- [Level Properties](level-properties.md) - Configure level settings

### 3. Lesson Management
- [Lesson Editor](lesson-editor.md) - Create and edit lessons
- [Lesson Activities](lesson-activities.md) - Manage lesson activities
- [Activity Sections](activity-sections.md) - Edit activity steps

### 4. Course Management
- [Course Editor](course-editor.md) - Create and edit academic courses
- [Course Offerings](course-offerings.md) - Manage course instances
- [Course Scripts](course-scripts.md) - Link courses to scripts

### 5. Resource Management
- [Resource Manager](resource-manager.md) - Manage curriculum resources
- [Standards Alignment](standards-alignment.md) - Align content to standards
- [Vocabulary Manager](vocabulary-manager.md) - Manage lesson vocabulary

### 6. Assessment Management
- [Rubric Editor](rubric-editor.md) - Create and edit assessment rubrics
- [Learning Goals](learning-goals.md) - Define learning objectives
- [Programming Expressions](programming-expressions.md) - Manage programming concepts

## Access Requirements

### Level Builder Mode
Most level builder views require level builder mode to be enabled:
- **Production**: `levelbuilder-studio.code.org`
- **Development**: Local development environment
- **Authentication**: Level builder account required

### Permissions
- **Script Management**: Create, edit, delete scripts
- **Level Management**: Create, edit, delete levels
- **Course Management**: Create, edit, delete courses
- **Resource Management**: Upload and manage resources

## Curriculum Table Modifications

Each level builder view documents:
- **Tables Modified**: Which curriculum tables are updated
- **Key Operations**: Create, Read, Update, Delete operations
- **Validation Rules**: Data validation and constraints
- **Dependencies**: Related tables and relationships

## Navigation Instructions

Each view includes detailed navigation instructions:
1. **Access Point**: How to reach the level builder interface
2. **Authentication**: Login requirements
3. **Navigation Steps**: Path to specific functionality
4. **Example Workflows**: Common editing tasks

## Screenshots

Each view documentation includes placeholders for screenshots:
- **Main Interface**: Overall editor layout
- **Form Fields**: Specific input forms
- **Data Tables**: List and management views
- **Validation Messages**: Error handling and feedback

## Related Documentation

- [Curriculum Data Model](../data-model.md) - Understanding the underlying data structure
- [User-Facing Views](../views/) - How content appears to end users
- [GUID Migration Plan](../../../experimental/curriculum_guid_migration/README.md) - Data migration details

## Development Notes

- Level builder views use Rails controllers and views
- Most interfaces support real-time validation
- Changes are tracked for audit purposes
- Export/import functionality available for data migration