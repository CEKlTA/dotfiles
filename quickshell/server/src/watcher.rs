use std::{
    collections::HashMap,
    path::{Path, PathBuf},
};
use notify::{recommended_watcher, Error, Event, RecommendedWatcher, RecursiveMode, Watcher};
use once_cell::sync::Lazy;
use tokio::sync::{mpsc, Mutex};

type Callback = dyn Fn(Event) + Send + Sync + 'static;

struct AppState {
    watcher: RecommendedWatcher,
    callbacks: HashMap<PathBuf, Box<Callback>>,
}

static APP_STATE: Lazy<Mutex<AppState>> = Lazy::new(|| {
    let (tx, mut rx) = mpsc::channel::<Result<Event, Error>>(100);

    tokio::spawn(async move {
        while let Some(res) = rx.recv().await {
            if let Ok(event) = res {
                for path in &event.paths {
                    // Bloqueamos el estado para leer los callbacks.
                    let state = APP_STATE.lock().await;
                    if let Some(callback) = state.callbacks.get(path) {
                        println!("Evento detectado en: {:?}. Ejecutando callback.", path);
                        callback(event.clone());
                    }
                }
            }
        }
    });

    let event_handler = move |res: Result<Event, Error>| {
        if tx.blocking_send(res).is_err() {
            println!("Error: El receptor del canal de eventos fue cerrado.");
        }
    };

    let watcher = recommended_watcher(event_handler).expect("No se pudo crear el watcher");
    let callbacks = HashMap::new();

    Mutex::new(AppState { watcher, callbacks })
});

pub async fn watch<P, C>(path: P, callback: C)
where
    P: AsRef<Path>,
    C: Fn(Event) + Send + Sync + 'static,
{
    let path_buf = path.as_ref().to_path_buf();

    let mut state = APP_STATE.lock().await;

    state
        .watcher
        .watch(&path_buf, RecursiveMode::Recursive)
        .expect("Error al registrar la ruta en el watcher.");
    
    state.callbacks.insert(path_buf, Box::new(callback));
}