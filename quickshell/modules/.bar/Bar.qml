import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

PanelWindow {
    id: window
    implicitHeight: 32
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        left: 8
        right: 8
        top: 0
    }

    Rectangle {
        anchors.fill: parent
        bottomLeftRadius: 6
        bottomRightRadius: 6
        color: "white"
        
        RowLayout {
            id: layout
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            // Input {
            //     Layout.alignment: Qt.AlignHCenter
            // }
        }
    }
}