import os
import sys

# Add the parent directory to the sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

# Now the relative import will work
from todo_client.core.helpers import index_in_range  # noqa: E402

# Define the base directory for resources
RESOURCE_DIR = os.path.join(os.path.dirname(__file__), "resources", "config")


def test_index_in_range():
    mock_todos = list(range(10))

    # In range
    assert index_in_range(1, mock_todos)
    assert index_in_range(9, mock_todos)

    # Out of range
    assert not index_in_range(-1, mock_todos)
    assert not index_in_range(10, mock_todos)
