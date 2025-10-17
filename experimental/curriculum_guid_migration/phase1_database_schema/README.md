# Phase 1: Database Schema Migration Testing

This directory contains tests for Phase 1 of the curriculum GUID migration, focusing on database schema changes.

## Phase 1 Steps

### Step 1: Verify Curriculum Table Identification
**Goal**: Verify we correctly identified all curriculum-related tables

**Test**: `verify_curriculum_tables.rb`
- **Input**: Database schema analysis
- **Verification**: Compare identified tables against multiple sources
- **Evidence**: Report showing table identification accuracy

### Step 2: Test Migration Execution
**Goal**: Verify database migrations can be executed successfully

**Test**: `test_migration_execution.rb`
- **Input**: Migration files
- **Verification**: Execute migrations and verify schema changes
- **Evidence**: Database schema before/after comparison

### Step 3: Validate Data Integrity
**Goal**: Verify data integrity after migration

**Test**: `validate_data_integrity.rb`
- **Input**: Database with migrated schema
- **Verification**: Validate GUID generation, foreign keys, and data consistency
- **Evidence**: Data integrity report

## Test Data Requirements

Before running tests, ensure:
1. **Empty Database**: Start with clean database
2. **Sample Data**: Create sample curriculum data
3. **Test Users**: Create test users and students
4. **Realistic Scenarios**: Set up realistic curriculum relationships

## Running Tests

```bash
# 1. Setup test data
cd /workspace/experimental/curriculum_guid_migration
ruby test_data/create_test_users.rb
ruby test_data/sample_curriculum_data.rb

# 2. Run Phase 1 tests
cd phase1_database_schema
ruby verify_curriculum_tables.rb
ruby test_migration_execution.rb
ruby validate_data_integrity.rb
```

## Expected Outcomes

- ✅ **Table Identification**: 100% accuracy in identifying curriculum tables
- ✅ **Migration Success**: All migrations execute without errors
- ✅ **Data Integrity**: All data remains consistent after migration
- ✅ **Performance**: No significant performance degradation
- ✅ **Rollback**: Can rollback migrations if needed

## Evidence Generated

Each test generates:
1. **Detailed Reports**: What was tested and results
2. **Schema Snapshots**: Before/after database schema
3. **Data Samples**: Sample data showing changes
4. **Performance Metrics**: Execution time and resource usage
5. **Validation Results**: Data integrity verification results