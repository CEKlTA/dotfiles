import Quickshell
import QtQuick
import Quickshell.Wayland

import qs.modules.launcher

PanelWindow {
    id: window

    property bool isActive: false;

    property var aliasCommands: [
        { text: "TWS", command: "bluetoothctl connect F8:3C:29:CF:E5:45" },
        { text: "TWS Disconnect", command: "bluetoothctl disconnect" },
        { text: "Minecraft", command: "prismlauncher -l 1.16.5" },
    ]

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive     // Take keyboard
    WlrLayershell.layer: WlrLayer.Overlay                       // Top layer
    WlrLayershell.exclusionMode: ExclusionMode.Ignore           // Do not take space

    visible: isActive
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Item {
        id: mainContainer
        anchors.fill: parent

        Buttons {}
    }

    ProcessHandler {
        id: processHandler
        showOutput: true
    }

    function toggle() {
        isActive = !isActive;
    }
}