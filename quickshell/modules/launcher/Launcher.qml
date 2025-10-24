import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

PanelWindow {
    id: window
    
    property bool isActive: false;

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0
    visible: isActive
    color: "transparent"
    implicitHeight: 480
    anchors {
        top: true
        left: true
        right: true
    }
    margins.top: 16

    ColumnLayout {
        id: layout
        anchors.fill: parent

        InputBox {
            id: inputBox
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.preferredHeight: implicitHeight

            onExecute: (text, isCommand) => {
                if (text.length === 0) {
                    outputView.reset();
                    return;
                }

                if (isCommand) {
                    processHandler.execCommand(["sh", "-c", ...text.split(" ")]);
                } else {
                    processHandler.execCommand([Qt.resolvedUrl("../../server/target/release/QSAPI"), text]);
                }
            }

            onOpen: {
                const path = outputView.getPath();
                if (path) {
                    const command = `grep '^Exec=' ${path} | head -n1 | sed 's/^Exec=//' | sed 's/%.//g' | xargs -r sh -c`
                    processHandler.execCommand(["sh", "-c", command]);
                    return;
                }
                handler.toggle();
            }

            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Qt.Key_Escape: handler.toggle(); break;
                    case Qt.Key_Up: outputView.next(); break;
                    case Qt.Key_Down: outputView.prev(); break;
                }
            }
        }

        ProcessHandler {
            id: processHandler

            onLineReceived: (line) => {
                try {
                    console.log(line)
                    outputView.setContent(JSON.parse(line));
                } catch (e) {
                    return;
                }
            }
        }

        OutputView {
            id: outputView
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
        }
    }

    function toggle() {
        inputBox.reset();
        outputView.reset();
        isActive = !isActive;
    }
}