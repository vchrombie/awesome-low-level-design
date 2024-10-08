#!/bin/bash

# Check if pyreverse is installed
if ! command -v pyreverse &> /dev/null; then
    echo "pyreverse could not be found. Please install it with 'pip install pylint'."
    exit 1
fi

# Get the current directory
base_dir=$(pwd)

# Loop through each folder in the base directory
for dir in $(find "$base_dir" -type d); do
    # Skip the base directory itself
    if [ "$dir" == "$base_dir" ]; then
        continue
    fi

    # Create __init__.py file if it doesn't exist
    init_file="$dir/__init__.py"
    if [ ! -f "$init_file" ]; then
        touch "$init_file"
        echo "Created $init_file"
    fi

    # Run pyreverse command on the folder to generate class diagrams
    pyreverse -o png "$dir"

    # Move the generated images to the current folder if they exist
    if [ -f "classes.png" ] && [ -f "packages.png" ]; then
        mv classes.png "$dir"
        mv packages.png "$dir"
        echo "Moved classes.png and packages.png to $dir"
    else
        echo "No pyreverse output for $dir"
    fi
done
