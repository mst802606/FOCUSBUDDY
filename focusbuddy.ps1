# FocusBuddy - An Automated Focus and Break Cycle Assistant for ADHD
# PowerShell Version

# Configuration
$FOCUS_DURATION = 25  # minutes
$BREAK_DURATION = 5   # minutes
$TASKS_FILE = "tasks.txt"
$COMPLETED_TASKS_FILE = "completed_tasks.csv"
$LOG_FILE = "focus_sessions.log"

# Colors for better visibility
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$RED = "`e[31m"
$NC = "`e[0m" # No Color

# Function to display a message with timestamp
function Log-Message {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value $logMessage
}

# Function to check if tasks file exists and create if it doesn't
function Check-TasksFile {
    if (-not (Test-Path $TASKS_FILE)) {
        Write-Host "No tasks file found. Creating new tasks file..."
        Set-Content -Path $TASKS_FILE -Value "# Add your tasks here, one per line`nExample task"
    }
}

# Function to add a new task
function Add-NewTask {
    Write-Host "`n${BLUE}Add New Task${NC}"
    Write-Host "${YELLOW}Enter your task (or press Enter to cancel):${NC}"
    $newTask = Read-Host
    
    if ($newTask) {
        Add-Content -Path $TASKS_FILE -Value $newTask
        Write-Host "${GREEN}Task added successfully!${NC}"
        return $true
    }
    return $false
}

# Function to import tasks from a file
function Import-Tasks {
    Write-Host "`n${BLUE}Import Tasks${NC}"
    Write-Host "${YELLOW}Enter the path to your to-do list file:${NC}"
    $importFile = Read-Host
    
    if (Test-Path $importFile) {
        try {
            $importedTasks = Get-Content $importFile
            $importedTasks | ForEach-Object {
                if ($_ -and $_ -notmatch "^#") {
                    Add-Content -Path $TASKS_FILE -Value $_
                }
            }
            Write-Host "${GREEN}Tasks imported successfully!${NC}"
            return $true
        }
        catch {
            Write-Host "${RED}Error importing tasks: $_${NC}"
            return $false
        }
    }
    else {
        Write-Host "${RED}File not found: $importFile${NC}"
        return $false
    }
}

# Function to display and select a task
function Select-Task {
    Write-Host "`n${BLUE}Available tasks:${NC}"
    $tasks = Get-Content $TASKS_FILE | Where-Object { $_ -notmatch "^#" }
    if (-not $tasks) {
        Write-Host "${YELLOW}No tasks available. Please add some tasks first.${NC}"
        return $null
    }
    
    $tasks | ForEach-Object { $i = 1 } { Write-Host "$i. $_"; $i++ }
    Write-Host ""
    
    $taskNum = Read-Host "Select task number (or press Enter to skip)"
    
    if ($taskNum) {
        $selectedTask = $tasks[$taskNum - 1]
        if ($selectedTask) {
            Write-Host "${GREEN}Selected task: $selectedTask${NC}"
            return $selectedTask
        }
    }
    return $null
}

# Function to start a focus session
function Start-FocusSession {
    param($Task)
    $startTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Log-Message "Starting focus session for task: $Task"
    Write-Host "${GREEN}Focus session started!${NC}"
    Write-Host "${YELLOW}Focus for $FOCUS_DURATION minutes...${NC}"
    
    # Timer
    for ($i = $FOCUS_DURATION; $i -gt 0; $i--) {
        Write-Host -NoNewline "${BLUE}Time remaining: $i minutes`r${NC}"
        Start-Sleep -Seconds 60
    }
    
    $endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Log-Message "Focus session completed"
    
    # Log completed task
    Add-Content -Path $COMPLETED_TASKS_FILE -Value "$startTime,$endTime,$Task"
    
    # Remove completed task from tasks file
    $content = Get-Content $TASKS_FILE
    $content | Where-Object { $_ -ne $Task } | Set-Content $TASKS_FILE
}

# Function to start a break
function Start-Break {
    Write-Host "${YELLOW}Break time! Take a $BREAK_DURATION minute break.${NC}"
    
    # Timer
    for ($i = $BREAK_DURATION; $i -gt 0; $i--) {
        Write-Host -NoNewline "${BLUE}Break time remaining: $i minutes`r${NC}"
        Start-Sleep -Seconds 60
    }
    
    Write-Host "${GREEN}Break is over! Ready for next session?${NC}"
}

# Function to display main menu
function Show-MainMenu {
    Write-Host "`n${BLUE}FocusBuddy Menu${NC}"
    Write-Host "1. Start Focus Session"
    Write-Host "2. Add New Task"
    Write-Host "3. Import Tasks from File"
    Write-Host "4. View Current Tasks"
    Write-Host "5. Exit"
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-5)"
    return $choice
}

# Main program
function Main {
    Check-TasksFile
    
    while ($true) {
        $choice = Show-MainMenu
        
        switch ($choice) {
            "1" {
                $selectedTask = Select-Task
                if ($selectedTask) {
                    Start-FocusSession $selectedTask
                    Start-Break
                }
            }
            "2" {
                Add-NewTask
            }
            "3" {
                Import-Tasks
            }
            "4" {
                Write-Host "`n${BLUE}Current Tasks:${NC}"
                Get-Content $TASKS_FILE | Where-Object { $_ -notmatch "^#" } | ForEach-Object { Write-Host "- $_" }
            }
            "5" {
                Write-Host "${GREEN}Thanks for using FocusBuddy!${NC}"
                exit
            }
            default {
                Write-Host "${RED}Invalid choice. Please try again.${NC}"
            }
        }
        
        if ($choice -eq "1") {
            $continueSession = Read-Host "Continue with another session? (y/n)"
            if ($continueSession -notmatch "^[Yy]$") {
                Write-Host "${GREEN}Thanks for using FocusBuddy!${NC}"
                exit
            }
        }
    }
}

# Run the program
Main 