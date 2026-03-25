# Course Catalog Page

**Last Updated**: 2025-01-27  
**Purpose**: Browse and discover available curriculum courses and programs

## Overview

The Course Catalog Page provides a comprehensive view of all available curriculum courses, allowing users to browse, filter, and discover educational content. It serves as the main entry point for curriculum discovery and enrollment.

## URL Patterns

- **Main URL**: `/catalog`
- **Controller**: `CurriculumCatalogController#index`
- **View Template**: `dashboard/app/views/curriculum_catalog/index.html.haml`

## Curriculum Tables Used

### Primary Tables
- **`course_offerings`** - Available course instances
  - `name`, `display_name`, `description`
  - `year`, `published`, `assignable`
  - `family_name`, `version_year`

- **`courses`** - Course definitions
  - `name`, `title`, `description`
  - `course_family`, `version_year`

### Secondary Tables
- **`unit_groups`** - Course families
  - `name`, `title`, `description`
  - `family_name`, `version_year`

- **`scripts`** - Individual curriculum units
  - `name`, `title`, `description`
  - `published`, `login_required`

- **`course_scripts`** - Course-script relationships
  - `position`, `course_id`, `script_id`

### User Context Tables
- **`sections`** - User's enrolled sections
  - `name`, `course_offering_id`, `hidden`

- **`user_scripts`** - User's script enrollments
  - `script_id`, `user_id`, `completed_at`

## Key Features Displayed

### 1. Course Grid
- Course cards with titles and descriptions
- Course family groupings
- Version year indicators
- Published status indicators

### 2. Filtering and Search
- Filter by grade level
- Filter by subject area
- Search by course name or description
- Filter by availability

### 3. User Context
- Enrolled courses highlighted
- Progress indicators
- Recommended courses
- Section assignments

### 4. Course Details
- Course description and overview
- Prerequisites and requirements
- Estimated duration
- Learning objectives

## Navigation Instructions

### For Students
1. **Go to**: `studio.code.org/catalog`
2. **Login**: Use your student account (optional)
3. **Browse**: Scroll through available courses
4. **Filter**: Use filters to narrow down options
5. **Enroll**: Click on a course to view details and enroll

### For Teachers
1. **Go to**: `studio.code.org/catalog`
2. **Login**: Use your teacher account
3. **Browse**: View all available courses
4. **Filter**: Use grade level and subject filters
5. **Assign**: Click to assign courses to sections
6. **View Progress**: See which courses your sections are using

### For Administrators
1. **Go to**: `studio.code.org/catalog`
2. **Login**: Use admin account
3. **Manage**: View all courses including unpublished
4. **Configure**: Modify course settings and availability
5. **Analytics**: View course usage statistics

## Example Curriculum Data

### CS Fundamentals (K-5)
- **Course Family**: `csf`
- **Versions**: 2024, 2023, 2022
- **Grade Levels**: K-5
- **Units**: Course A, B, C, D, E, F
- **Description**: "Computer science fundamentals for elementary students"

### CS Discoveries (6-10)
- **Course Family**: `csd`
- **Versions**: 2024, 2023, 2022
- **Grade Levels**: 6-10
- **Units**: 6 units covering web development, data, and programming
- **Description**: "Computer science discoveries for middle and high school"

### CS Principles (9-12)
- **Course Family**: `csp`
- **Versions**: 2024, 2023, 2022
- **Grade Levels**: 9-12
- **Units**: 8 units covering computer science principles
- **Description**: "AP Computer Science Principles curriculum"

### CS A (9-12)
- **Course Family**: `csa`
- **Versions**: 2024, 2023, 2022
- **Grade Levels**: 9-12
- **Units**: 10 units covering Java programming
- **Description**: "AP Computer Science A curriculum"

## Course Categories

### Elementary School (K-5)
- CS Fundamentals Course A-F
- Pre-Reader Express
- Express Course

### Middle School (6-8)
- CS Discoveries
- CS Fundamentals Express
- CS Fundamentals for Middle School

### High School (9-12)
- CS Principles
- CS A
- CS Discoveries
- CS Fundamentals for High School

### Professional Learning
- CS Fundamentals for Teachers
- CS Discoveries for Teachers
- CS Principles for Teachers

## Filtering Options

### Grade Level
- Pre-K
- Elementary (K-5)
- Middle School (6-8)
- High School (9-12)
- College and Beyond

### Subject Area
- Computer Science
- Mathematics
- Science
- Social Studies
- Language Arts

### Course Type
- Full Courses
- Express Courses
- Professional Learning
- Hour of Code

### Availability
- Available Now
- Coming Soon
- Archived

## Screenshots

*Screenshots will be added here showing:*
- Main catalog grid layout
- Course card details
- Filtering interface
- Teacher vs student view differences
- Mobile responsive layout

## Related Views

- [Script Overview Page](script-overview.md) - Individual script details
- [Course Overview Page](course-overview.md) - Individual course details
- [Teacher Dashboard](teacher-dashboard.md) - Teacher's course management

## Technical Notes

- Uses `CourseOffering.assignable_published_for_students_course_offerings` for data
- Supports internationalization and localization
- Includes user context and enrollment status
- Handles course versioning and family relationships
- Supports responsive design for mobile devices
- Caches course data for performance