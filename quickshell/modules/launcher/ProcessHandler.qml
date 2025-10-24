import QtQuick
import Quickshell.Io

Item {
    id: processHandler

    property bool showOutput: false

    Process {
        id: process

        stdout: StdioCollector {
            onStreamFinished: () => {
                if (showOutput) console.log(this.text);
                lineReceived(this.text);
            }
        }
    }
    
    signal lineReceived(string line)

    function execCommand(cmd) {
        process.exec(cmd);
    }
}
