# Curriculum Data Migration to GUIDs - Master Plan

**Created:** 2025-10-16 18:34:36  
**Status:** Planning Phase  
**Priority:** High  

## Executive Summary

This document outlines a comprehensive plan to migrate Code.org's curriculum data from ID-based tables to GUID-based tables, eliminating the current complex and time-consuming seeding process that takes 30+ minutes and requires production data synchronization.

## Problem Statement

### Current Issues
1. **Complex Seeding Process**: Every environment requires an exhaustive 30+ minute seeding script that pulls data from production
2. **ID Dependencies**: All curriculum tables use auto-incrementing integer IDs, creating tight coupling between environments
3. **Data Synchronization**: Production data must be seeded to all environments, making deployments slow and error-prone
4. **Level Builder Integration**: Curriculum team uses level builder system that generates both database records and local files
5. **Maintenance Overhead**: Any curriculum change requires complex seeding across all environments

### Root Cause
The fundamental issue is that curriculum data is stored with auto-incrementing integer primary keys that differ across environments, making it impossible to synchronize data without complex ID mapping and seeding processes.

## Solution Overview

Migrate all curriculum-related tables from integer ID primary keys to GUID/UUID primary keys, enabling:
- **Direct Data Synchronization**: Complete table dumps from production can be imported directly
- **Elimination of Seeding**: No more complex seeding scripts or ID mapping
- **Faster Deployments**: Simple data synchronization instead of 30+ minute seeding
- **Environment Independence**: Each environment can maintain identical curriculum data

## Scope

### Core Curriculum Tables (Primary Migration Targets)
- `scripts` (Units)
- `script_levels` 
- `levels`
- `lesson_groups`
- `lessons`
- `lesson_activities`
- `activity_sections`
- `unit_groups` (Courses)
- `course_versions`
- `course_offerings`

### Supporting Tables (Foreign Key Updates Required)
- `user_levels` (user progress tracking)
- `user_scripts` (user progress tracking)
- `levels_script_levels` (join table)
- `scripts_resources` (join table)
- `scripts_student_resources` (join table)
- `concepts_levels` (join table)
- `parent_levels_child_levels` (join table)
- `section_hidden_scripts` (teacher controls)
- All other tables with foreign keys to curriculum tables

## Migration Strategy

### Phase 1: Preparation and Analysis
1. **Audit Current Dependencies**
   - Map all foreign key relationships to curriculum tables
   - Identify all code that references curriculum IDs
   - Document current seeding process and dependencies

2. **GUID Infrastructure Setup**
   - Add GUID columns to all curriculum tables
   - Create indexes for GUID columns
   - Update models to support both ID and GUID lookups

### Phase 2: Dual-Key Implementation
1. **Add GUID Columns**
   - Add `guid` columns to all curriculum tables
   - Generate GUIDs for existing records
   - Create unique indexes on GUID columns

2. **Update Foreign Key References**
   - Add GUID-based foreign key columns to dependent tables
   - Populate new foreign key columns with corresponding GUIDs
   - Update application code to use both ID and GUID during transition

3. **Coexistence Period**
   - Maintain both ID and GUID columns
   - Update seeding process to handle both identifiers
   - Ensure level builder continues to work with both systems

### Phase 3: GUID Migration
1. **Switch Primary References**
   - Update all foreign key constraints to use GUIDs
   - Modify application code to use GUIDs as primary identifiers
   - Update caching and lookup mechanisms

2. **Data Synchronization Implementation**
   - Create new synchronization process using GUIDs
   - Implement complete table synchronization (not seeding)
   - Test synchronization across environments

### Phase 4: Cleanup and Optimization
1. **Remove ID Dependencies**
   - Drop integer ID columns from curriculum tables
   - Remove old seeding infrastructure
   - Clean up dual-key support code

2. **Performance Optimization**
   - Optimize GUID-based indexes
   - Update caching strategies for GUID lookups
   - Monitor and tune performance

## Detailed Implementation Plans

### 1. Database Schema Changes
- [ ] Add GUID columns to all curriculum tables
- [ ] Create GUID-based foreign key columns
- [ ] Update indexes and constraints
- [ ] Implement GUID generation for existing data

### 2. Application Code Updates
- [ ] Update model associations to use GUIDs
- [ ] Modify lookup methods and caching
- [ ] Update serialization/deserialization logic
- [ ] Ensure level builder compatibility

### 3. Seeding Process Replacement
- [ ] Create new data synchronization system
- [ ] Implement complete table synchronization
- [ ] Replace seeding with direct data import
- [ ] Update deployment processes

### 4. Level Builder Integration
- [ ] Update level files to include GUIDs
- [ ] Modify level builder to generate GUIDs
- [ ] Ensure compatibility with existing workflow
- [ ] Update file-based curriculum management

## Risk Assessment

### High Risk
- **Data Loss**: Incorrect GUID generation could break data relationships
- **Performance Impact**: GUID lookups may be slower than integer lookups
- **Deployment Issues**: Migration could break existing deployments

### Medium Risk
- **Code Complexity**: Dual-key support adds temporary complexity
- **Testing Overhead**: Extensive testing required across all environments
- **Rollback Complexity**: Difficult to rollback once GUIDs are in use

### Low Risk
- **User Impact**: Migration should be transparent to end users
- **Feature Development**: New features can be developed with GUID support

## Success Criteria

1. **Elimination of Seeding**: No more 30+ minute seeding processes
2. **Direct Synchronization**: Complete data sync in under 5 minutes
3. **Environment Consistency**: All environments have identical curriculum data
4. **Level Builder Compatibility**: Existing curriculum creation workflow unchanged
5. **Performance Maintained**: No significant performance degradation
6. **Zero Data Loss**: All existing data and relationships preserved

## Timeline Estimate

- **Phase 1 (Preparation)**: 2-3 weeks
- **Phase 2 (Dual-Key)**: 4-6 weeks  
- **Phase 3 (GUID Migration)**: 3-4 weeks
- **Phase 4 (Cleanup)**: 2-3 weeks

**Total Estimated Duration**: 11-16 weeks

## Next Steps

1. **Immediate Actions**
   - [ ] Create detailed database schema migration plan
   - [ ] Audit all foreign key dependencies
   - [ ] Design GUID generation strategy
   - [ ] Plan testing approach

2. **Short Term (Next 2 weeks)**
   - [ ] Complete dependency analysis
   - [ ] Design dual-key implementation
   - [ ] Create migration scripts
   - [ ] Set up development environment for testing

3. **Medium Term (Next 2 months)**
   - [ ] Implement dual-key system
   - [ ] Update application code
   - [ ] Test extensively across environments
   - [ ] Prepare synchronization system

## Related Documents

- [Database Schema Migration Plan](./20251016_183436_database_schema_migration.md)
- [Application Code Migration Plan](./20251016_183436_application_code_migration.md)
- [Seeding Process Replacement Plan](./20251016_183436_seeding_replacement_plan.md)
- [Level Builder Integration Plan](./20251016_183436_level_builder_integration.md)
- [Testing and Validation Plan](./20251016_183436_testing_validation_plan.md)

## Appendices

### A. Current Curriculum Table Structure
[Detailed analysis of current table schemas and relationships]

### B. Foreign Key Dependency Map
[Complete mapping of all foreign key relationships]

### C. Performance Impact Analysis
[Analysis of GUID vs integer performance characteristics]

### D. Rollback Strategy
[Detailed plan for rolling back migration if needed]