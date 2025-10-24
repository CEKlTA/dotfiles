import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Rectangle {
    id: rect
    
    property int padding: 16
    property bool isCommand: false
    
    signal execute(string text, bool isCommand)
    signal open()

    color: "black"
    implicitHeight: container.height + padding
    implicitWidth: container.width + padding * 2
    border.color: isCommand ? "orange" : "gray"
    border.width: 1
    radius: 8

    RowLayout {
        id: container
        x: padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Image {
            source: Qt.resolvedUrl("search")
            sourceSize.width: 24
            sourceSize.height: 24
        }

        Item {
            width: 240
            height: input.implicitHeight

            TextInput {
                id: input

                anchors.fill: parent
                font.pixelSize: 16
                color: "white"
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignLeft
                clip: true
                focus: true

                onTextChanged: {
                    if (text.startsWith(">")) {
                        isCommand = true;
                        text = "> " + text.substring(2);
                    } else {
                        isCommand = false;
                    }

                    if (!isCommand) {
                        execute(text, isCommand);
                    }
                }

                onAccepted: {
                    if (isCommand && text.length - 2 > 0) {
                        execute(text, isCommand);
                    }
                    else if (!isCommand && text.length > 0) {
                        open();
                    }
                    
                    reset();
                }
            }
        }
    }

    function reset() {
        input.text = ""
        isCommand = false
        input.focus = true
    }
}
