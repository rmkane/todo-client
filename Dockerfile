# Use the official Python 3.9 image from the Docker Hub
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Create a new user "appuser"
RUN useradd -m appuser

# Change the ownership of the /app directory to appuser
RUN chown -R appuser:appuser /app

# Upgrade pip and install the package from PyPI
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefix=/usr/local todo-client

# Switch to the new user
USER appuser

# Default command to keep the container running for inspection
CMD ["bash"]
