use std::io::{Read, Write};
use std::path::Path;
use std::thread;
use std::{
    io::Result,
    os::unix::net::{UnixListener, UnixStream},
};

use crate::commands::execute;

mod cache;
mod commands;
mod watcher;

const SOCKET: &str = "/tmp/lgs-server.sock";

fn main() -> Result<()> {
    let listener = bind_and_listen(SOCKET)?;
    println!("Servidor escuchando en: {}", SOCKET);

    for may_stream in listener.incoming() {
        match may_stream {
            Ok(stream) => {
                println!("user connected: {stream:?}");

                thread::spawn(move || {
                    if let Err(e) = handle_client(stream) {
                        println!("Error handling connection: {e:?}")
                    };
                });
            }
            Err(error) => {
                println!("connection error: {error}");
            }
        }
    }

    Ok(())
}

fn handle_client(mut stream: UnixStream) -> std::io::Result<()> {
    let mut buf = [0u8; 1024];

    loop {
        let n = stream.read(&mut buf)?;
        if n == 0 {
            println!("client disconnected");
            return Ok(());
        }

        let input = String::from_utf8_lossy(&buf[..n]);

        let output = execute(&input);

        stream.write_all(input.as_bytes())?;
    }
}

fn bind_and_listen(path: impl AsRef<Path>) -> std::io::Result<UnixListener> {
    let path = path.as_ref();

    if path.exists() {
        std::fs::remove_file(path)?;
    }

    UnixListener::bind(path)
}
