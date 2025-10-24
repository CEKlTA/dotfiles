mod search;

use search::search_app;
use serde_json::to_value;

pub async fn execute(prompt: &str) -> String {
    let commands: Vec<&str> = prompt.split(' ').collect();

    let res = match commands[0] {
        "search" => to_value(search_app(&commands[1..].join(" ")).await).unwrap().to_string(),
        _ => return String::from("Error: Unknown command"),
    };

    println!("{:?}", res);

    res
}
