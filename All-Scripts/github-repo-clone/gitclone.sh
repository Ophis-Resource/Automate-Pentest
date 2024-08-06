#!/bin/bash

# Function to clone repositories
clone_repositories() {
    for repo in "${repos[@]}"; do
        git clone "$repo"
    done
}

echo "Enter GitHub repository URLs one by one."
echo "Press Enter twice to confirm and clone the repositories."

# Array to store repository URLs
repos=()

# Reading repository URLs from user input
while true; do
    read -rp "Repository URL (or press Enter twice to finish): " repo_url
    # Check if the input is empty (user pressed Enter twice)
    if [ -z "$repo_url" ]; then
        break
    fi
    # Add the URL to the array
    repos+=("$repo_url")
done

# Check if there are repositories to clone
if [ ${#repos[@]} -eq 0 ]; then
    echo "No repositories to clone. Exiting."
else
    echo "Cloning repositories..."
    clone_repositories
fi
