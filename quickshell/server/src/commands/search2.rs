use std::{collections::HashMap, sync::{Arc, RwLock}};

use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use serde_json::{from_value, Value};

type Table = HashMap<String, Value>;

type Cache = Arc<RwLock<Table>>;

pub static CACHE: Lazy<Cache> = Lazy::new(|| {
    let initial_data = HashMap::new();
    Arc::new(RwLock::new(initial_data))
});

#[derive(Serialize, Deserialize)]
pub struct AppEntry {
    name: String,
    path: String,
    icon: Option<String>,
}

const KEY: &str = "apps";
static WATCHED: Lazy<Arc<RwLock<bool>>> = Lazy::new(|| {
    Arc::new(RwLock::new(true))
});

pub fn search_app(search_term: &str) -> Vec<AppEntry> {
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
        let mut paths = get_directories();

        for path in paths {
            register_callback(&path, |_| {
                // println!("==> Callback ejecutado! Evento detallado: {:?}", e);
                let data = get_data(&path).unwrap();

                cache.insert(KEY.to_string(), to_value(data).unwrap());
            });
        }

        cache.insert(STATE_KEY.to_string(), json!({}));
    }

    vec![]
}

fn get_directories() -> Vec<PathBuf> {
    let mut paths = vec![PathBuf::from("/usr/share/applications")];
    if let Ok(home_dir) = env::var("HOME") {
        paths.push(PathBuf::from(home_dir).join(".local/share/applications"));
    }
    paths
}