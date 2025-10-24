use std::env;
use std::fs::{self, File};
use std::io::{self, BufRead};
use std::path::{Path, PathBuf};

use notify::Event;
use serde::{Deserialize, Serialize};
use serde_json::{from_value, json};

use crate::cache::CACHE;
use crate::watcher::watch;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AppEntry {
    name: String,
    path: String,
    icon: Option<String>,
}

const KEY: &str = "apps";
const STATE_KEY: &str = "apps_state";

pub async fn search_app(search_term: &str) -> Vec<AppEntry> {
    let mut cache = CACHE.write().unwrap();

    println!("{:?}", cache.get(KEY));

    if let Some(apps) = cache.get(KEY) {
        let apps: Vec<AppEntry> = from_value(apps.clone()).unwrap_or_default();

        if search_term.is_empty() {
            return apps;
        }

        return apps
            .into_iter()
            .filter(|app| {
                app.name
                    .to_lowercase()
                    .contains(&search_term.to_lowercase())
            })
            .collect();
    }

    if let None = cache.get(STATE_KEY) {
        let paths = get_directories();

        for path in paths {
            watch(&path, |event: Event| {
                println!("==> Callback ejecutado! Evento detallado: {:?}", event);
                println!("==> Data obtenida: {:?}", get_data(event.paths.get(0).unwrap()));
                // let data = get_data(&path).unwrap();

                // cache.insert(KEY.to_string(), to_value(data).unwrap());
            }).await;
        }

        cache.insert(STATE_KEY.to_string(), json!({}));
    }

    vec![]
}

fn get_data(path: &Path) -> Result<Vec<AppEntry>, std::io::Error> {
    let dir = fs::read_dir(path)?;

    let mut apps: Vec<AppEntry> = Vec::new();

    for entry in dir {
        if let Some(app) = parse_desktop_file(entry?.path()) {
            apps.push(app);
        }
    }

    Ok(apps)
}

fn parse_desktop_file<T: AsRef<Path>>(path: T) -> Option<AppEntry> {
    let file = File::open(&path).ok()?;
    let reader = io::BufReader::new(file);

    let mut name = String::new();
    let mut no_display = false;
    let mut icon = None;

    for line in reader.lines() {
        if let Ok(line) = line {
            if let Some(value) = line.strip_prefix("Name=") {
                name = value.to_string();
            }
            if let Some(value) = line.strip_prefix("NoDisplay=") {
                no_display = value.to_lowercase() == "true";
            }
            if let Some(value) = line.strip_prefix("Icon=") {
                icon = Some(value.to_string());
            }
        }
    }

    if !no_display && !name.is_empty() {
        Some(AppEntry {
            name,
            path: path.as_ref().to_string_lossy().to_string(),
            icon,
        })
    } else {
        None
    }
}

fn get_directories() -> Vec<PathBuf> {
    let mut paths = vec![PathBuf::from("/usr/share/applications")];
    if let Ok(home_dir) = env::var("HOME") {
        paths.push(PathBuf::from(home_dir).join(".local/share/applications"));
    }
    paths
}