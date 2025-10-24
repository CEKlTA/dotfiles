import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    id: variant

    required property string src

    model: Quickshell.screens

    PanelWindow {
        id: window

        required property ShellScreen modelData
        
        WlrLayershell.exclusionMode: ExclusionMode.Ignore // Do not take space
        WlrLayershell.layer: WlrLayer.Background // On background        
        
        screen: modelData
        
        color: "transparent"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Image {
            id: sourceImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: variant.src

            opacity: 1
            // visible: false
        }

        // ShaderEffect {
        //     id: imageEffect
        //     anchors.fill: parent 
            
        //     // 1. Pasar la imagen como fuente principal.
        //     property variant sourceTexture: sourceImage 
            
        //     // Las rutas deben ser file:// si no es QRC
        //     vertexShader: "file:///home/cekita/.repas/quickshell/assets/verts.vert.qsb"
        //     fragmentShader: "file:///home/cekita/.repas/quickshell/assets/frags.frag.qsb"

        //     property real iTime: 0.0 
            
        //     // Conexión del bloque uniforme de Qt 6
        //     property variant custom: QtObject {
        //         property real iTime: imageEffect.iTime
        //     }

        //     SequentialAnimation on iTime {
        //         loops: Animation.Infinite
        //         NumberAnimation {
        //             from: 0.0
        //             to: 10000.0
        //             duration: 100000
        //         }
        //     }
        // }
    }
}