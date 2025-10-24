use std::{collections::HashMap, sync::{Arc, RwLock}};
use once_cell::sync::Lazy;
use serde_json::Value as JSON;

type Cache = Arc<RwLock<HashMap<String, JSON>>>;

pub static CACHE: Lazy<Cache> = Lazy::new(|| {
    let initial_data = HashMap::new();
    Arc::new(RwLock::new(initial_data))
});