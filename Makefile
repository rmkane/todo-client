# Define the Python version and virtual environment directory
PYTHON = python3
VENV_DIR = .venv

# Create virtual environment and install Poetry
create-venv: $(VENV_DIR)/bin/activate # Create a Python virtual environment and install Poetry

$(VENV_DIR)/bin/activate:
	$(PYTHON) -m venv $(VENV_DIR)
	. $(VENV_DIR)/bin/activate && pip install --upgrade pip poetry

# Activate virtual environment
activate: create-venv # Activate the virtual environment
	@echo "source $(VENV_DIR)/bin/activate"

# Install project dependencies using Poetry
install-deps: activate # Install project dependencies using Poetry
	. $(VENV_DIR)/bin/activate && poetry install --no-root --with dev

# Format code
format: install-deps # Format code using Black
	. $(VENV_DIR)/bin/activate && poetry run black .

# Run tests
test: install-deps # Run tests using pytest
	. $(VENV_DIR)/bin/activate && PYTHONPATH=src poetry run pytest

# Build the project
build: install-deps # Build the project
	. $(VENV_DIR)/bin/activate && poetry build

# Generate Sphinx .rst files
apidoc: install-deps # Generate Sphinx .rst files from source code
	. $(VENV_DIR)/bin/activate && poetry run sphinx-apidoc -o docs/source/ src/todo_client

# Build Sphinx documentation
docs: apidoc # Build Sphinx HTML documentation
	mkdir -p ./docs/source/_static
	. $(VENV_DIR)/bin/activate && poetry run sphinx-build -b html docs/source docs/_build

# Upload to PyPI
publish: build # Build the project and upload to PyPI
	. $(VENV_DIR)/bin/activate && poetry publish

# Install the package
install: install-deps # Install the package in the virtual environment
	. $(VENV_DIR)/bin/activate && poetry install

# Build the Docker image
docker-build: docker-down # Build the Docker image using Docker Compose
	docker compose build

# Start the Docker container
docker-up: docker-build # Start the Docker container using Docker Compose
	docker compose up -d

# Stop the Docker container
docker-down: # Stop the Docker container using Docker Compose
	docker compose down

# Run an interactive shell in the Docker container
docker: docker-up # Run an interactive shell in the Docker container
	docker run -it todo-client-test bash

# Clean build artifacts
clean: # Remove build artifacts
	rm -rf dist/
	rm -rf docs/_build

# Clean all generated files
clean-all: clean # Remove virtual environment, build artifacts, and __pycache__ directories
	rm -rf $(VENV_DIR)
	find . -type d -name "__pycache__" -exec rm -rf {} +

# Display help message
help: # Display this help message
	@printf "Usage: make \033[1;34m[target]\033[0m\n\nTargets:\n"
	@awk 'BEGIN {FS = ":.*#"} /^[a-zA-Z_-]+:.*?#/ { printf "  \033[1;34m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# Default target
all: build # Default target to build the project

# Main targets
.PHONY: all build clean docs docker install help format publish test

# Secondary targets
.PHONY: activate apidoc clean-all create-venv docker-build docker-down docker-up install-deps
