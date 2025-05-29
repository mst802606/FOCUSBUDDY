use anyhow::Result;
use chrono::Local;
use clap::Parser;
use colored::*;
use dialoguer::{theme::ColorfulTheme, Select};
use indicatif::{ProgressBar, ProgressStyle};
use serde::{Deserialize, Serialize};
use std::{
    fs,
    path::Path,
    time::Duration,
};

#[cfg(feature = "notifications")]
use notify::{Config, RecommendedWatcher, RecursiveMode, Watcher};
#[cfg(feature = "notifications")]
use notify_debouncer_mini::new_debouncer;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    /// Start a focus session
    #[arg(short, long)]
    start: bool,

    /// Add a new task
    #[arg(short, long)]
    add: Option<String>,

    /// List all tasks
    #[arg(short, long)]
    list: bool,

    /// Import tasks from a file
    #[arg(short, long)]
    import: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
struct Task {
    description: String,
    completed: bool,
    created_at: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct Config {
    focus_duration: u64,
    break_duration: u64,
    tasks: Vec<Task>,
}

impl Config {
    fn new() -> Self {
        Self {
            focus_duration: 25,
            break_duration: 5,
            tasks: Vec::new(),
        }
    }

    fn load() -> Result<Self> {
        let config_path = "focusbuddy.json";
        if Path::new(config_path).exists() {
            let contents = fs::read_to_string(config_path)?;
            Ok(serde_json::from_str(&contents)?)
        } else {
            Ok(Self::new())
        }
    }

    fn save(&self) -> Result<()> {
        let contents = serde_json::to_string_pretty(self)?;
        fs::write("focusbuddy.json", contents)?;
        Ok(())
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let mut config = Config::load()?;

    match cli {
        Cli { start: true, .. } => start_focus_session(&mut config)?,
        Cli { add: Some(task), .. } => add_task(&mut config, &task)?,
        Cli { list: true, .. } => list_tasks(&config)?,
        Cli { import: Some(path), .. } => import_tasks(&mut config, &path)?,
        _ => show_menu(&mut config)?,
    }

    Ok(())
}

fn show_menu(config: &mut Config) -> Result<()> {
    let options = vec!["Start Focus Session", "Add New Task", "Import Tasks", "View Tasks", "Exit"];
    
    loop {
        let selection = Select::with_theme(&ColorfulTheme::default())
            .with_prompt("What would you like to do?")
            .items(&options)
            .default(0)
            .interact()?;

        match selection {
            0 => start_focus_session(config)?,
            1 => {
                let task = dialoguer::Input::<String>::new()
                    .with_prompt("Enter task description")
                    .interact_text()?;
                add_task(config, &task)?;
            }
            2 => {
                let path = dialoguer::Input::<String>::new()
                    .with_prompt("Enter path to task file")
                    .interact_text()?;
                import_tasks(config, &path)?;
            }
            3 => list_tasks(config)?,
            4 => break,
            _ => unreachable!(),
        }
    }

    Ok(())
}

fn start_focus_session(config: &mut Config) -> Result<()> {
    if config.tasks.is_empty() {
        println!("{}", "No tasks available. Add some tasks first!".red());
        return Ok(());
    }

    let task_options: Vec<String> = config.tasks
        .iter()
        .filter(|t| !t.completed)
        .map(|t| t.description.clone())
        .collect();

    if task_options.is_empty() {
        println!("{}", "No incomplete tasks available!".yellow());
        return Ok(());
    }

    let selection = Select::with_theme(&ColorfulTheme::default())
        .with_prompt("Select a task")
        .items(&task_options)
        .default(0)
        .interact()?;

    let selected_task = &mut config.tasks[selection];
    println!("{}", format!("\nStarting focus session for: {}", selected_task.description).green());

    // Focus timer
    let pb = ProgressBar::new(config.focus_duration * 60);
    pb.set_style(ProgressStyle::default_bar()
        .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos}/{len} seconds")
        .unwrap());

    for _ in 0..(config.focus_duration * 60) {
        std::thread::sleep(Duration::from_secs(1));
        pb.inc(1);
    }
    pb.finish_with_message("Focus session complete!");

    // Break timer
    println!("{}", "\nBreak time!".yellow());
    let pb = ProgressBar::new(config.break_duration * 60);
    pb.set_style(ProgressStyle::default_bar()
        .template("{spinner:.yellow} [{elapsed_precise}] [{bar:40.yellow/blue}] {pos}/{len} seconds")
        .unwrap());

    for _ in 0..(config.break_duration * 60) {
        std::thread::sleep(Duration::from_secs(1));
        pb.inc(1);
    }
    pb.finish_with_message("Break is over!");

    selected_task.completed = true;
    config.save()?;

    Ok(())
}

fn add_task(config: &mut Config, description: &str) -> Result<()> {
    let task = Task {
        description: description.to_string(),
        completed: false,
        created_at: Local::now().to_rfc3339(),
    };
    config.tasks.push(task);
    config.save()?;
    println!("{}", "Task added successfully!".green());
    Ok(())
}

fn list_tasks(config: &Config) -> Result<()> {
    if config.tasks.is_empty() {
        println!("{}", "No tasks available.".yellow());
        return Ok(());
    }

    println!("\n{}", "Current Tasks:".blue());
    for (i, task) in config.tasks.iter().enumerate() {
        let status = if task.completed { "✓" } else { " " };
        println!("{}. [{}] {}", i + 1, status, task.description);
    }
    Ok(())
}

fn import_tasks(config: &mut Config, path: &str) -> Result<()> {
    let contents = fs::read_to_string(path)?;
    for line in contents.lines() {
        if !line.trim().is_empty() && !line.starts_with('#') {
            add_task(config, line.trim())?;
        }
    }
    println!("{}", "Tasks imported successfully!".green());
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    fn create_test_config() -> Config {
        Config {
            focus_duration: 25,
            break_duration: 5,
            tasks: Vec::new(),
        }
    }

    #[test]
    fn test_add_task() {
        let mut config = create_test_config();
        let result = add_task(&mut config, "Test task");
        assert!(result.is_ok());
        
        // Verify task was added
        assert_eq!(config.tasks.len(), 1);
        assert_eq!(config.tasks[0].description, "Test task");
        assert!(!config.tasks[0].completed);
    }

    #[test]
    fn test_list_tasks() {
        let mut config = create_test_config();
        
        // Add some test tasks
        add_task(&mut config, "Task 1").unwrap();
        add_task(&mut config, "Task 2").unwrap();
        add_task(&mut config, "Task 3").unwrap();
        
        // Test listing tasks
        let result = list_tasks(&config);
        assert!(result.is_ok());
        
        // Verify tasks were added
        assert_eq!(config.tasks.len(), 3);
    }

    #[test]
    fn test_start_focus_session() {
        let mut config = create_test_config();
        
        // Add a test task
        add_task(&mut config, "Test task").unwrap();
        
        // Test starting a focus session
        let result = start_focus_session(&mut config);
        assert!(result.is_ok());
        
        // Verify task was marked as completed
        assert!(config.tasks[0].completed);
    }
} 