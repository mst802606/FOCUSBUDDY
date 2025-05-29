#!/bin/bash

# FocusBuddy - An Automated Focus and Break Cycle Assistant for ADHD
# Author: Your Name
# Version: 1.0.0

# Configuration
FOCUS_DURATION=25  # minutes
BREAK_DURATION=5   # minutes
TASKS_FILE="tasks.txt"
COMPLETED_TASKS_FILE="completed_tasks.csv"
LOG_FILE="focus_sessions.log"

# Colors for better visibility
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display a message with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if tasks file exists and create if it doesn't
check_tasks_file() {
    if [ ! -f "$TASKS_FILE" ]; then
        echo "No tasks file found. Creating new tasks file..."
        echo "# Add your tasks here, one per line" > "$TASKS_FILE"
        echo "Example task" >> "$TASKS_FILE"
    fi
}

# Function to display and select a task
select_task() {
    echo -e "${BLUE}Available tasks:${NC}"
    # Get only non-comment, non-empty lines and number them
    grep -v "^#" "$TASKS_FILE" | grep -v "^[[:space:]]*$" | nl -w2 -s'. '
    echo
    read -p "Select task number (or press Enter to skip): " task_num
    
    if [ -n "$task_num" ]; then
        # Get the task by its line number, excluding comments and empty lines
        selected_task=$(grep -v "^#" "$TASKS_FILE" | grep -v "^[[:space:]]*$" | sed -n "${task_num}p")
        if [ -n "$selected_task" ]; then
            echo -e "${GREEN}Selected task: $selected_task${NC}"
            return 0
        fi
    fi
    return 1
}

# Function to start a focus session
start_focus_session() {
    local task="$1"
    local start_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    log_message "Starting focus session for task: $task"
    echo -e "${GREEN}Focus session started!${NC}"
    echo -e "${YELLOW}Focus for $FOCUS_DURATION minutes...${NC}"
    
    # Timer
    for ((i=FOCUS_DURATION; i>0; i--)); do
        echo -ne "${BLUE}Time remaining: $i minutes\r${NC}"
        sleep 60
    done
    
    local end_time=$(date '+%Y-%m-%d %H:%M:%S')
    log_message "Focus session completed"
    
    # Log completed task
    echo "$start_time,$end_time,$task" >> "$COMPLETED_TASKS_FILE"
    
    # Remove completed task from tasks file
    sed -i "/$task/d" "$TASKS_FILE"
}

# Function to start a break
start_break() {
    echo -e "${YELLOW}Break time! Take a $BREAK_DURATION minute break.${NC}"
    
    # Timer
    for ((i=BREAK_DURATION; i>0; i--)); do
        echo -ne "${BLUE}Break time remaining: $i minutes\r${NC}"
        sleep 60
    done
    
    echo -e "${GREEN}Break is over! Ready for next session?${NC}"
}

# Function to add a new task
add_new_task() {
    echo -e "${BLUE}Add a new task:${NC}"
    read -p "Enter task description: " new_task
    
    if [ -n "$new_task" ]; then
        echo "$new_task" >> "$TASKS_FILE"
        echo -e "${GREEN}Task added successfully!${NC}"
        log_message "Added new task: $new_task"
    else
        echo -e "${RED}No task description provided. Task not added.${NC}"
    fi
}

# Function to import tasks from a file
import_tasks() {
    echo -e "${BLUE}Import tasks from a file:${NC}"
    read -p "Enter the path to your todo list file: " import_file
    
    if [ -f "$import_file" ]; then
        # Read each line from the file and add non-empty, non-comment lines
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip empty lines and comments
            if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
                echo "$line" >> "$TASKS_FILE"
            fi
        done < "$import_file"
        echo -e "${GREEN}Tasks imported successfully!${NC}"
        log_message "Imported tasks from: $import_file"
    else
        echo -e "${RED}File not found: $import_file${NC}"
    fi
}

# Function to display menu
show_menu() {
    echo -e "\n${BLUE}FocusBuddy Menu:${NC}"
    echo "1. Start Focus Session"
    echo "2. Add New Task"
    echo "3. Import Tasks from File"
    echo "4. View Current Tasks"
    echo "5. Exit"
    echo
    read -p "Select an option (1-5): " menu_choice
}

# Function to view current tasks
view_tasks() {
    echo -e "\n${BLUE}Current Tasks:${NC}"
    grep -v "^#" "$TASKS_FILE" | grep -v "^[[:space:]]*$" | nl -w2 -s'. '
    echo
    read -p "Press Enter to continue..."
}

# Main program
main() {
    check_tasks_file
    
    while true; do
        show_menu
        
        case $menu_choice in
            1)
                if select_task; then
                    start_focus_session "$selected_task"
                    start_break
                else
                    echo -e "${YELLOW}No task selected.${NC}"
                fi
                ;;
            2)
                add_new_task
                ;;
            3)
                import_tasks
                ;;
            4)
                view_tasks
                ;;
            5)
                echo -e "${GREEN}Thanks for using FocusBuddy!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                ;;
        esac
    done
}

# Run the program
main 