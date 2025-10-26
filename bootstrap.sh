#!/bin/bash

set -e

# Get user information
read -p "Enter your first name: " first_name
read -p "Enter your last name: " last_name
read -p "Enter your email: " email

# Get project name from current directory and replace - with _
project_name=$(basename "$PWD" | tr '-' '_')

echo "Setting up project: ${project_name}"
echo "Author: ${last_name}, ${first_name} <${email}>"

# Update pyproject.toml
sed -i "s/name = \"project_name\"/name = \"${project_name}\"/" pyproject.toml
sed -i "s/name = \"last_name, first_name\", email = \"name@domain.com\"/name = \"${last_name}, ${first_name}\", email = \"${email}\"/" pyproject.toml
sed -i "s/source = \[\"project_name\"\]/source = [\"${project_name}\"]/" pyproject.toml

# Update CI workflow
sed -i "s/--cov=project_name/--cov=${project_name}/" .github/workflows/ci.yaml

# Rename project directory
mv project_name "${project_name}"

# Update project __init__.py
sed -i "s/\"The Python project package.\"/\"The ${project_name} package.\"/" "${project_name}/__init__.py"

# Update tests __init__.py
sed -i "s/\"Test for the Python application.\"/\"Tests for ${project_name}.\"/" "tests/__init__.py"

# Rename and update test file
mv tests/test_project_name.py "tests/test_${project_name}.py"
sed -i "s/from project_name/from ${project_name}/" "tests/test_${project_name}.py"
sed -i "s/\"Tests for project version.\"/\"Tests for ${project_name} version.\"/" "tests/test_${project_name}.py"

echo "Setup complete!"