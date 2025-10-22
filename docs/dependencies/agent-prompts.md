# AI Agent Prompts for Dependency Documentation

> **⚠️ AI Generated Report**  
> This file contains prompts and instructions for AI agents to maintain the dependency documentation.

## Overview

This file contains standardized prompts and instructions for AI agents to help maintain and update the dependency documentation. Use these prompts to ensure consistent and thorough analysis.

## Maintenance Tasks

### 1. Dependency Validation Check

**Prompt:**
```
Run the dependency checker tool and analyze the results:

1. Execute: `make check-dependencies` or `python dependency_checker.py`
2. Review the output for:
   - Missing dependencies not documented
   - Dependencies without full detail (missing necessity line)
3. For any missing or incomplete dependencies, update the appropriate markdown files
4. Ensure all dependencies have the required format:
   - [x] checkbox for completed analysis
   - **Necessity**: [LOW|MEDIUM|HIGH|CRITICAL]
   - **Compensation if removed**: Description
   - **Documentation**: Links to docs and GitHub
   - **Current version**: Version in use
   - **Latest stable**: Latest available version
   - **Upgrade path**: Notes on upgrades

Focus on completing the analysis for any unchecked boxes ([ ]) in the documentation.
```

### 2. Documentation Standards Compliance

**Prompt:**
```
Review all dependency documentation files and ensure they follow the standards:

1. Check that every dependency entry has:
   - [x] or [ ] checkbox
   - **Necessity**: [LOW|MEDIUM|HIGH|CRITICAL] assessment
   - **Compensation if removed**: Clear description
   - **Documentation**: Working links to official docs and GitHub
   - **Current version**: Actual version in use
   - **Latest stable**: Latest available version
   - **Upgrade path**: Notes on upgrade requirements

2. Verify that all dependencies from source files are documented
3. Ensure consistent formatting across all files
4. Update any incomplete entries

Use the dependency checker tool to validate completeness.
```

### 3. New Dependency Analysis

**Prompt:**
```
When a new dependency is added to the project:

1. Run the dependency checker to identify the new dependency
2. Determine which category file it belongs in
3. Add a complete entry following the standard format:
   - [ ] **dependency-name** (version) - Brief description
   - **Usage**: How it's used in the project
   - **Files**: Count of files using it
   - **Key locations**: Specific file paths (if <5 files)
   - **Necessity**: [LOW|MEDIUM|HIGH|CRITICAL] with justification
   - **Compensation if removed**: What would be needed to replace it
   - **Documentation**: [Official Docs](link) | [GitHub](link)
   - **Current version**: X.x.x | **Latest stable**: Y.y.y | **Upgrade path**: Notes

4. Update the category README.md if needed
5. Run the dependency checker to verify the new entry
```

### 4. Version Update Analysis

**Prompt:**
```
When dependencies are updated:

1. Identify which dependencies have version changes
2. Update the "Current version" field in the documentation
3. Research and update the "Latest stable" version
4. Review and update the "Upgrade path" notes
5. Check for any breaking changes that might affect the project
6. Update the necessity assessment if the dependency's role has changed
7. Run the dependency checker to ensure all changes are properly documented
```

### 5. Dependency Cleanup

**Prompt:**
```
When dependencies are removed from the project:

1. Run the dependency checker to identify removed dependencies
2. Remove the dependency entries from the appropriate markdown files
3. Update the category README.md if needed
4. Clean up any orphaned references
5. Run the dependency checker to verify the cleanup
6. Update the main README.md statistics if needed
```

## Quality Assurance

### Before Making Changes
1. Always run `make check-dependencies` first
2. Review the current state of documentation
3. Identify what needs to be updated

### After Making Changes
1. Run `make check-dependencies` to verify changes
2. Ensure all new entries follow the standard format
3. Check that all links are working
4. Verify that necessity assessments are accurate

### Documentation Standards
- Use [x] for completed analysis, [ ] for pending
- Necessity must be one of: LOW, MEDIUM, HIGH, CRITICAL
- Always provide compensation description
- Include working documentation links
- Keep version information current
- Use consistent formatting across all files

## Troubleshooting

### Common Issues
1. **Missing dependencies**: Add to appropriate category file
2. **Incomplete entries**: Add missing necessity line and other required fields
3. **Broken links**: Update documentation and GitHub links
4. **Inconsistent formatting**: Follow the standard format exactly

### Validation Commands
```bash
# Check all dependencies are documented
make check-dependencies

# Check markdown formatting
make check-format

# Run all checks
make check-all
```

## Notes

- Always maintain the "AI Generated Report" disclaimer at the top of files
- Keep the documentation up-to-date with actual project usage
- Focus on accuracy and completeness over speed
- When in doubt, err on the side of caution and mark as incomplete ([ ])