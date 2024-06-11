import os
import sys

import toml

sys.path.insert(0, os.path.abspath("../../src"))

# Parse the pyproject.toml file
pyproject = toml.load("../../pyproject.toml")

# Get the project information
project = pyproject["tool"]["poetry"]["name"]
release = pyproject["tool"]["poetry"]["version"]
author = pyproject["tool"]["poetry"]["authors"][0]

# Other Sphinx configuration
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",  # Include links to the source code
    "sphinx.ext.githubpages",  # Suitable for publishing to GitHub Pages
]
templates_path = ["_templates"]
exclude_patterns = []
html_theme = "alabaster"
html_static_path = ["_static"]
html_show_sourcelink = False  # Do not show link to source
