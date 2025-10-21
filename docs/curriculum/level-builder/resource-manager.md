# Resource Manager

**Last Updated**: 2025-01-27  
**Purpose**: Manage curriculum resources in the level builder interface

## Overview

The Resource Manager interface allows level builders to upload, organize, and manage curriculum resources including documents, images, videos, and other materials used throughout the curriculum.

## URL Patterns

- **Main URL**: `/resources`
- **Controller**: `ResourcesController#index`, `ResourcesController#create`, `ResourcesController#update`
- **View Template**: `dashboard/app/views/resources/index.html.haml`

## Curriculum Tables Modified

### Primary Tables
- **`resources`** - Resource data
  - `name`, `url`, `type`, `description`
  - `audience`, `position`, `created_at`, `updated_at`

### Secondary Tables
- **`scripts_resources`** - Script-resource relationships
  - `script_id`, `resource_id`, `position`

- **`lessons_resources`** - Lesson-resource relationships
  - `lesson_id`, `resource_id`, `position`

- **`unit_groups_resources`** - Unit group-resource relationships
  - `unit_group_id`, `resource_id`, `position`

## Key Features

### 1. Resource Management
- **Resource List**: View all available resources
- **Resource Upload**: Upload new resources
- **Resource Organization**: Categorize and organize resources
- **Resource Search**: Find specific resources

### 2. Resource Types
- **Documents**: PDFs, Word docs, presentations
- **Images**: Photos, diagrams, illustrations
- **Videos**: Instructional videos, demonstrations
- **Audio**: Sound effects, music, narration

### 3. Resource Organization
- **Categories**: Group resources by type
- **Tags**: Tag resources for easy finding
- **Collections**: Create resource collections
- **Favorites**: Mark frequently used resources

### 4. Resource Integration
- **Script Linking**: Link resources to scripts
- **Lesson Linking**: Link resources to lessons
- **Unit Group Linking**: Link resources to unit groups
- **Course Linking**: Link resources to courses

## Navigation Instructions

### Accessing Resource Manager
1. **Go to**: `levelbuilder-studio.code.org`
2. **Login**: Use your level builder account
3. **Navigate**: Go to Resources section
4. **View**: All available resources

### Uploading New Resources
1. **Click**: "Upload Resource" button
2. **Select**: Choose file to upload
3. **Fill**: Resource information
4. **Save**: Upload the resource

### Organizing Resources
1. **Select**: Choose resources to organize
2. **Categorize**: Assign categories and tags
3. **Group**: Create resource collections
4. **Save**: Apply organization changes

## Form Fields and Controls

### Basic Information
- **Resource Name**: Unique identifier (required)
- **Title**: Display title (required)
- **Description**: Resource description
- **Type**: Resource type (document, image, video, audio)

### Resource Properties
- **URL**: Resource location
- **Audience**: Teacher, student, or both
- **Position**: Order within category
- **Tags**: Searchable tags

### Resource Organization
- **Categories**: Group resources by type
- **Collections**: Create resource collections
- **Favorites**: Mark frequently used resources
- **Sharing**: Control resource visibility

## Example Resource Types

### Teacher Resources
- **Lesson Plans**: Detailed lesson instructions
- **Answer Keys**: Solutions for activities
- **Assessment Rubrics**: Evaluation criteria
- **Professional Development**: Training materials

### Student Resources
- **Worksheets**: Activity sheets and handouts
- **Reference Materials**: Study guides and references
- **Templates**: Project and activity templates
- **Study Guides**: Review and study materials

### Digital Resources
- **Online Tools**: Web-based applications
- **Interactive Simulations**: Digital experiments
- **Video Tutorials**: Instructional videos
- **Assessment Platforms**: Online testing tools

### Print Resources
- **PDF Documents**: Printable materials
- **Handout Templates**: Activity handouts
- **Reference Cards**: Quick reference materials
- **Instruction Sheets**: Step-by-step guides

## Validation Rules

### Resource Name
- Must be unique
- Cannot be empty
- Must be valid identifier
- Cannot contain special characters

### Resource Properties
- Title is required
- Type must be valid
- URL must be accessible
- Audience must be specified

### Resource Organization
- Categories must be valid
- Tags must be appropriate
- Collections must be unique
- Sharing settings must be valid

## Screenshots

*Screenshots will be added here showing:*
- Main resource manager interface
- Resource list with metadata
- Upload resource dialog
- Resource organization panel

## Related Views

- [Script Editor](script-editor.md) - Link resources to scripts
- [Lesson Editor](lesson-editor.md) - Link resources to lessons
- [Course Editor](course-editor.md) - Link resources to courses

## Technical Notes

- Uses `Resource.all` for data loading
- Supports file upload and storage
- Includes search and filter functionality
- Handles resource-relationship management
- Supports internationalization and localization
- Changes are tracked for audit purposes