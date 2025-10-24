import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    spacing: 16
    
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    
    anchors.topMargin: 16 

    Repeater {
        model: window.aliasCommands

        Button {
            id: control
            text: modelData.text

            contentItem: Text {
                text: control.text

                font.family: "Roboto, Inter, Arial"
                font.weight: Font.Medium
                font.pointSize: 10

                opacity: enabled ? 1.0 : 0.4
                color: control.down ? "#DDD" : "#EEE"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                radius: 8
                border.width: 1
                border.color: "#444"

                color: {
                    if (!control.enabled) return "#2A2A2AF0"; // Deshabilitado: color base
                    if (control.down) return "#444";        // Presionado: color más oscuro
                    if (control.hovered) return "#3A3A3A"; // Hover: Gris intermedio (HIGHLIGHT)
                    return "#2A2A2A";                      // Base: color normal de reposo
                }
            }
            
            onClicked: () => {
                Quickshell.execDetached(["sh", "-i", "-c", modelData.command])
                // processHandler.execCommand(["sh", "-i", "-c", `nohup ${modelData.command} > /dev/null 2>&1 &`])
                window.toggle()
            }
        }
    }
}