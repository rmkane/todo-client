# Define the Python version and virtual environment directory
PYTHON = python3
VENV_DIR = .venv

# Create virtual environment and install Poetry
create_venv: $(VENV_DIR)/bin/activate # Create virtual environment and install Poetry

$(VENV_DIR)/bin/activate:
	$(PYTHON) -m venv $(VENV_DIR)
	. $(VENV_DIR)/bin/activate && pip install --upgrade pip poetry

# Activate virtual environment
activate: create_venv # Activate the virtual environment
	@echo "source $(VENV_DIR)/bin/activate"

# Install project dependencies using Poetry
install_deps: activate # Install project dependencies
	. $(VENV_DIR)/bin/activate && poetry install --with dev

# Format code
format: install_deps # Format code using black
	. $(VENV_DIR)/bin/activate && poetry run black .

# Run tests
test: install_deps # Run tests using pytest
	. $(VENV_DIR)/bin/activate && PYTHONPATH=src poetry run pytest

# Build target
build: install_deps # Set up virtual environment and run build
	. $(VENV_DIR)/bin/activate && poetry build

# Generate Sphinx .rst files
apidoc: install_deps # Generate Sphinx .rst files
	. $(VENV_DIR)/bin/activate && poetry run sphinx-apidoc -o docs/source/ src/todo_client

# Build Sphinx documentation
docs: apidoc # Build Sphinx documentation
	. $(VENV_DIR)/bin/activate && poetry run sphinx-build -b html docs/source docs/_build

# Upload to PyPI
publish: build # Build the project and upload to PyPI
	. $(VENV_DIR)/bin/activate && poetry publish

# Install
install: install_deps # Install the package
	. $(VENV_DIR)/bin/activate && poetry install

# Clean target
clean: # Remove build artifacts
	rm -rf dist/
	rm -rf docs/_build

# Clean all generated files
clean_all: clean # Remove virtual environment, build artifacts, and __pycache__ directories
	rm -rf $(VENV_DIR)
	find . -type d -name "__pycache__" -exec rm -rf {} +

# Help target
help: # Display this help message
	@printf "Usage: make \033[1;34m[target]\033[0m\n\nTargets:\n"
	@awk 'BEGIN {FS = ":.*#"} /^[a-zA-Z_-]+:.*?#/ { printf "  \033[1;34m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# Default target
all: build

# Main targets
.PHONY: all build clean docs install help format publish test

# Secondary targets
.PHONY: activate apidoc clean_all create_venv install_deps
