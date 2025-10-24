//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import Quickshell.Io
import QtQuick.Layouts

import qs.modules.wallpaper
import qs.modules.dynamic
// import qs.modules.launcher
// import qs.modules.bar

ShellRoot {
    Wallpaper {
        src: "/home/cekita/.repas/quickshell/assets/skull"
    }

    Dynamic {
        id: dynamic
    }

    // Launcher {
    //     id: launcher
    // }
    // Bar {}

    IpcHandler {
        id: handler
        target: "QSUI"

        function toggle() {
            dynamic.toggle();
        }
    }
}
