# Curriculum System Documentation

**Last Updated**: 2025-01-27  
**Purpose**: Comprehensive documentation of the Code.org curriculum system

## Overview

This directory contains complete documentation of the Code.org curriculum system, including the data model, user-facing views, and level builder interfaces. The curriculum system manages 27 core tables that define curriculum content, organization, and resources.

## Documentation Structure

### 📊 [Data Model](data-model.md)
Complete documentation of the curriculum system's data model and table relationships.

**Key Topics:**
- 27 core curriculum tables
- Table relationships and dependencies
- Data flow through the system
- GUID migration status
- Excluded tables (user progress)

### 👥 [User-Facing Views](views/)
Documentation of all pages that display curriculum data to end users.

**Key Views:**
- [Script Overview Page](views/script-overview.md) - Main script landing page
- [Level Play Page](views/level-play.md) - Main level playing interface
- [Course Catalog Page](views/course-catalog.md) - Browse available courses
- [Lesson Overview Page](views/lesson-overview.md) - Individual lesson details
- [Teacher Dashboard Views](views/teacher-dashboard.md) - Teacher-specific interfaces

### 🔧 [Level Builder Views](level-builder/)
Documentation of all level builder screens that modify curriculum tables.

**Key Interfaces:**
- [Script Editor](level-builder/script-editor.md) - Create and edit curriculum scripts
- [Level Editor](level-builder/level-editor.md) - Create and edit individual levels
- [Lesson Editor](level-builder/lesson-editor.md) - Create and edit lessons
- [Resource Manager](level-builder/resource-manager.md) - Manage curriculum resources
- [Assessment Tools](level-builder/assessment-tools.md) - Create rubrics and assessments

## Quick Start Guide

### For Curriculum Developers
1. **Understand the Data Model**: Start with [Data Model](data-model.md) to understand table relationships
2. **Explore User Views**: Review [User-Facing Views](views/) to see how content appears to users
3. **Learn Level Builder**: Study [Level Builder Views](level-builder/) to understand editing interfaces

### For Teachers
1. **Browse Courses**: Use [Course Catalog Page](views/course-catalog.md) to find curriculum
2. **Navigate Scripts**: Follow [Script Overview Page](views/script-overview.md) for script navigation
3. **Play Levels**: Use [Level Play Page](views/level-play.md) for student engagement

### For Students
1. **Find Content**: Use [Course Catalog Page](views/course-catalog.md) to discover courses
2. **Start Learning**: Follow [Script Overview Page](views/script-overview.md) to begin
3. **Complete Levels**: Use [Level Play Page](views/level-play.md) for coding challenges

## Curriculum Table Summary

### Core Content (13 tables)
- `scripts` - Complete curriculum courses
- `stages` - Individual lessons
- `levels` - Coding challenges
- `lesson_groups` - Chapter groupings
- `lesson_activities` - Hands-on exercises
- `activity_sections` - Activity steps
- `courses` - Academic course definitions
- `course_offerings` - Specific course instances
- `course_versions` - Course version definitions
- `objectives` - Lesson objectives
- `programming_expressions` - Programming concepts
- `rubrics` - Assessment rubrics
- `learning_goals` - Learning objectives

### Organization (3 tables)
- `unit_groups` - Curriculum families
- `script_levels` - Level roadmap
- `levels_script_levels` - Complex level relationships

### Resources (8 tables)
- `course_scripts` - Course-script links
- `unit_groups_resources` - Unit group resources
- `unit_groups_student_resources` - Student resources
- `scripts_resources` - Script resources
- `scripts_student_resources` - Student script resources
- `lessons_resources` - Lesson resources
- `stages_standards` - Standards alignment
- `lessons_vocabularies` - Lesson vocabulary

### Join Tables (3 tables)
- `lessons_programming_expressions` - Lesson-programming expression links
- `learning_goal_evidence_levels` - Evidence levels for learning goals
- `lessons_opportunity_standards` - Opportunity standards for lessons

## Navigation Instructions

Each view documentation includes detailed navigation instructions:

1. **Starting Point**: Where to begin (e.g., "Go to studio.code.org")
2. **Authentication**: Login requirements if any
3. **Navigation Steps**: Step-by-step path to the view
4. **Example Data**: Specific curriculum examples to look for
5. **URL Patterns**: Direct URL patterns for the view

## Screenshots

Each view documentation includes placeholders for screenshots that will be added:

- **Main View Screenshots**: Overall page layout
- **Detail Screenshots**: Specific sections or features
- **Mobile Screenshots**: Mobile-responsive versions
- **Level Builder Screenshots**: Editing interface details

## Related Documentation

- [GUID Migration Plan](../../experimental/curriculum_guid_migration/README.md) - Data migration details
- [Curriculum Tables List](../../experimental/curriculum_guid_migration/curriculum_tables_list.md) - Detailed table descriptions
- [Curriculum Relationships](../../experimental/curriculum_guid_migration/curriculum_relationships_diagram.md) - Visual relationship diagram

## Contributing

When updating curriculum documentation:

1. **Update Timestamps**: Change "Last Updated" dates
2. **Test Navigation**: Verify all navigation instructions work
3. **Add Screenshots**: Include relevant screenshots
4. **Update Examples**: Use current curriculum examples
5. **Check Links**: Ensure all internal links work

## Support

For questions about the curriculum system:

- **Technical Issues**: Contact the development team
- **Content Questions**: Contact curriculum team
- **Access Issues**: Contact support team
- **Documentation**: Update this documentation