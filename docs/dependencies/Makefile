# Dependency Documentation Management Makefile

.PHONY: help install check-dependencies check-format check-all clean

# Default target
help:
	@echo "Dependency Documentation Management"
	@echo "=================================="
	@echo ""
	@echo "Available targets:"
	@echo "  install              - Install Python dependencies for the checker"
	@echo "  check-dependencies   - Run dependency validation checker"
	@echo "  check-format         - Check markdown formatting"
	@echo "  check-all           - Run all checks"
	@echo "  clean               - Clean up temporary files"
	@echo ""

# Install Python dependencies
install:
	@echo "Installing Python dependencies..."
	pip install pyyaml
	@echo "✅ Dependencies installed!"

# Run the dependency checker
check-dependencies:
	@echo "Running dependency checker..."
	python dependency_checker.py

# Check markdown formatting (basic check)
check-format:
	@echo "Checking markdown formatting..."
	@find . -name "*.md" -not -path "./node_modules/*" | while read file; do \
		echo "Checking $$file..."; \
		if ! grep -q "AI Generated Report" "$$file"; then \
			echo "❌ Missing AI Generated Report header in $$file"; \
		fi; \
	done
	@echo "✅ Format check complete!"

# Run all checks
check-all: check-dependencies check-format
	@echo "✅ All checks completed!"

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleanup complete!"