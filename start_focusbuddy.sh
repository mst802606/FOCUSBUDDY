#!/bin/bash

# FocusBuddy Launcher Script
# This script ensures FocusBuddy runs properly every time

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
cd "$SCRIPT_DIR"

# Check if required files exist
if [ ! -f "focusbuddy.sh" ]; then
    echo "Error: focusbuddy.sh not found!"
    exit 1
fi

# Make sure the script is executable
chmod +x focusbuddy.sh

# Create necessary files if they don't exist
touch tasks.txt completed_tasks.csv focus_sessions.log

# Run FocusBuddy using bash explicitly
bash focusbuddy.sh 