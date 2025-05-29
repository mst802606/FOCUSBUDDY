# FocusBuddy 🧠

A modern, Rust-based command-line tool designed to help people with ADHD (or anyone who struggles with focus) manage their time, tasks, and energy with minimal mental overhead.

## 🎯 Features

- 🎯 25-minute focus sessions (Pomodoro-style)
- 📝 Task management system
- ⏰ Automatic break reminders
- 📊 Session logging and task tracking
- 🎨 Color-coded terminal interface
- ➕ Add custom tasks
- 📥 Import tasks from external files
- 📋 View and manage task list

## 🚀 Quick Start

### Prerequisites

- Rust (latest stable version)
- Cargo (comes with Rust)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/focusbuddy.git
   cd focusbuddy
   ```

2. Build the project:
   ```bash
   cargo build --release
   ```

3. Run the application:
   ```bash
   ./target/release/focusbuddy
   ```

## 💻 Usage

### Command Line Options

```bash
# Start a focus session
focusbuddy --start

# Add a new task
focusbuddy --add "Your task description"

# List all tasks
focusbuddy --list

# Import tasks from a file
focusbuddy --import path/to/tasks.txt
```

### Interactive Mode

If no options are provided, FocusBuddy starts in interactive mode with a menu:

1. Start Focus Session
2. Add New Task
3. Import Tasks
4. View Tasks
5. Exit

## 📁 Project Structure

```
focusbuddy/
├── src/
│   └── main.rs
├── .github/
│   └── workflows/
│       └── main.yml
├── Cargo.toml
└── README.md
```

## 🛠️ Development

### Building

```bash
cargo build
```

### Testing

```bash
cargo test
```

### Cross-compilation

The project includes GitHub Actions for cross-compilation to aarch64-unknown-linux-gnu.

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 