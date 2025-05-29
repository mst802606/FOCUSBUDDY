# FocusBuddy 🧠

A lightweight, terminal-based automation tool designed to help people with ADHD (or anyone who struggles with focus) manage their time, tasks, and energy with minimal mental overhead.

## 🚀 Quick Start

### For macOS Users
1. Open Terminal
2. Navigate to the FocusBuddy directory
3. Run the launcher script:
   ```bash
   bash start_focusbuddy.sh
   ```

### For Other Unix/Linux Users
1. Open Terminal
2. Navigate to the FocusBuddy directory
3. Run the launcher script:
   ```bash
   ./start_focusbuddy.sh
   ```

That's it! The launcher script will:
- Ensure all necessary files exist
- Set proper permissions
- Start FocusBuddy automatically

## 💻 Manual Start (Alternative)

### For macOS Users
```bash
bash focusbuddy.sh
```

### For Other Unix/Linux Users
```bash
chmod +x focusbuddy.sh
./focusbuddy.sh
```

## 📁 Project Structure

- `focusbuddy.sh` - Main script
- `start_focusbuddy.sh` - Launcher script
- `tasks.txt` - Your task list
- `completed_tasks.csv` - Log of completed tasks
- `focus_sessions.log` - Detailed session log

## 🎮 Features

- 🎯 25-minute focus sessions (Pomodoro-style)
- 📝 Task management system
- ⏰ Automatic break reminders
- 📊 Session logging and task tracking
- 🎨 Color-coded terminal interface
- ➕ Add custom tasks
- 📥 Import tasks from external files
- 📋 View and manage task list

## 🎯 Key Benefits for ADHD Users

- **Reduced Decision Fatigue**: Automatically manages your focus/break cycles, eliminating the need to constantly check the time
- **Task Management**: Breaks down work into manageable chunks with clear start and end points
- **Visual Progress Tracking**: Color-coded interface and progress indicators help maintain engagement
- **Structured Breaks**: Enforces regular breaks to prevent burnout and maintain productivity
- **Minimal Setup**: Works directly in your terminal, no complex setup or distracting interfaces
- **Task Completion Tracking**: Automatically logs completed tasks, providing a sense of accomplishment
- **Reduced Cognitive Load**: Simple menu system and clear prompts reduce mental effort

## 🚀 Features

- 🎯 25-minute focus sessions (Pomodoro-style)
- 📝 Task management system
- ⏰ Automatic break reminders
- 📊 Session logging and task tracking
- 🎨 Color-coded terminal interface
- 📂 Simple CSV-based logging
- ➕ Add custom tasks
- 📥 Import tasks from external files
- 📋 View and manage task list

## 💻 Installation

1. Clone this repository or download the files
2. Make the script executable:
   ```powershell
   # For Windows PowerShell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```

## 🎮 Usage Guide

### Starting FocusBuddy
```powershell
.\focusbuddy.ps1
```

### Main Menu Options

1. **Start Focus Session**
   - Select a task from your list
   - 25-minute focus timer starts automatically
   - Visual countdown shows remaining time
   - 5-minute break follows automatically
   - Task is marked as complete and logged

2. **Add New Task**
   - Enter task description when prompted
   - Task is added to your task list
   - Can add multiple tasks in sequence
   - Press Enter without text to cancel

3. **Import Tasks from File**
   - Enter the path to your task file
   - Supports any text file with one task per line
   - Lines starting with # are treated as comments
   - Example file format:
     ```
     # My Tasks
     Task 1
     Task 2
     Task 3
     ```

4. **View Current Tasks**
   - Displays all active tasks
   - Shows task numbers for selection
   - Excludes completed tasks

5. **Exit**
   - Safely exits the program
   - Saves all progress and logs

### Automated Features

- **Focus Cycle Automation**
  - Automatic session timing
  - Break reminders
  - Progress tracking
  - Task completion logging

- **Task Management Automation**
  - Automatic task removal after completion
  - Session logging with timestamps
  - CSV-based task tracking
  - Break timing management

- **Progress Tracking**
  - Completed tasks are logged in `completed_tasks.csv`
  - Session details are stored in `focus_sessions.log`
  - Task list is automatically updated

## 📁 File Structure

- `focusbuddy.ps1` - Main script
- `tasks.txt` - Your task list
- `completed_tasks.csv` - Log of completed tasks
- `focus_sessions.log` - Detailed session log

## ⚙️ Customization

You can modify these variables in `focusbuddy.sh`:
- `FOCUS_DURATION` - Length of focus sessions (default: 25 minutes)
- `BREAK_DURATION` - Length of breaks (default: 5 minutes)

## 💡 Tips for Success

1. **Task Management**
   - Break large tasks into smaller, manageable pieces
   - Use specific, actionable task descriptions
   - Keep your task list updated and organized

2. **Focus Sessions**
   - Start with shorter sessions if 25 minutes feels too long
   - Use the break time to move around and refresh
   - Don't skip breaks - they're crucial for maintaining focus

3. **Progress Tracking**
   - Review your completed tasks log regularly
   - Celebrate completed sessions
   - Use the logs to identify your most productive times

4. **Environment**
   - Use in a quiet, distraction-free environment
   - Keep your terminal window visible
   - Consider using a second monitor for your work

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is open source and available under the MIT License.
