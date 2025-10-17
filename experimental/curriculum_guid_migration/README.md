# Curriculum GUID Migration Testing Framework

This directory contains comprehensive testing and verification tools for the curriculum GUID migration process.

## Structure

```
experimental/curriculum_guid_migration/
├── README.md                           # This file
├── phase1_database_schema/            # Phase 1 testing
│   ├── README.md
│   ├── verify_curriculum_tables.rb    # Verify table identification
│   ├── test_migration_execution.rb    # Test migration execution
│   └── validate_data_integrity.rb     # Validate data integrity
├── phase2_application_code/           # Phase 2 testing
│   ├── README.md
│   ├── test_guid_support.rb          # Test GuidSupport module
│   ├── test_dual_key_lookups.rb      # Test dual-key functionality
│   └── test_model_updates.rb         # Test model updates
├── phase3_seeding_replacement/        # Phase 3 testing
│   ├── README.md
│   ├── test_export_service.rb        # Test export functionality
│   ├── test_import_service.rb        # Test import functionality
│   └── test_s3_integration.rb        # Test S3 integration
├── phase4_level_builder/              # Phase 4 testing
│   ├── README.md
│   ├── test_guid_generation.rb       # Test GUID generation
│   └── test_level_file_updates.rb    # Test level file updates
├── test_data/                         # Test data and fixtures
│   ├── sample_curriculum_data.rb     # Sample curriculum data
│   ├── create_test_users.rb          # Create test users
│   └── restore_test_data.rb          # Restore test data
└── utils/                             # Utility scripts
    ├── database_helpers.rb           # Database helper methods
    ├── verification_helpers.rb       # Verification helper methods
    └── reporting_helpers.rb          # Reporting helper methods
```

## Testing Philosophy

Each phase and step must have:
1. **Concrete Verification**: Tangible proof that the code works
2. **Data Validation**: Verify data integrity at each step
3. **Rollback Testing**: Ensure we can rollback if needed
4. **Performance Testing**: Ensure no performance degradation
5. **Integration Testing**: Test with real data and scenarios

## Prerequisites

Before running any tests, ensure:
- Ruby 3.3.7+ is installed
- Rails environment is set up
- Database is accessible
- Required gems are installed

## Quick Start

1. **Setup Test Environment**:
   ```bash
   cd /workspace/experimental/curriculum_guid_migration
   ruby test_data/create_test_users.rb
   ```

2. **Run Phase 1 Tests**:
   ```bash
   cd phase1_database_schema
   ruby verify_curriculum_tables.rb
   ruby test_migration_execution.rb
   ```

3. **Run Phase 2 Tests**:
   ```bash
   cd phase2_application_code
   ruby test_guid_support.rb
   ruby test_dual_key_lookups.rb
   ```

## Test Data Requirements

Some tests require existing data. Use the test data scripts to:
- Create sample curriculum data
- Create test users and students
- Set up realistic test scenarios
- Restore clean state between tests

## Reporting

Each test generates detailed reports showing:
- What was tested
- What passed/failed
- Performance metrics
- Data integrity verification
- Rollback capabilities

## Safety

All tests are designed to be:
- **Non-destructive**: Tests don't modify production data
- **Reversible**: Can be rolled back if needed
- **Isolated**: Tests don't interfere with each other
- **Documented**: Clear logs of what was tested