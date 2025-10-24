SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
qs --path $SCRIPT_DIR
$SCRIPT_DIR/API/target/release/