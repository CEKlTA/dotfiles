import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    property bool hasContent: false

    color: "black"
    border.color: "gray"
    radius: 8
    implicitWidth: 480
    implicitHeight: 240
    visible: hasContent

    ListModel { id: contactModel }

    ListView {
        id: listView
        model: contactModel
        anchors.fill: parent
        anchors.margins: 16
        spacing: 4
        focus: true
        currentIndex: 0

        delegate: Rectangle {
            required property string path
            required property string name
            required property string icon
            
            width: listView.width
            height: textItem.implicitHeight + 4
            color: ListView.isCurrentItem ? "lightsteelblue" : "transparent"

            RowLayout {
                anchors.fill: parent
                spacing: 16

                Image {
                    source: icon
                    sourceSize: Qt.size(24, 24)
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    id: textItem
                    text: name
                    color: ListView.isCurrentItem ? "black" : "white"
                    Layout.alignment: Qt.AlignVCenter
                    font.pixelSize: 16
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }
    }

    function setContent(content) {
        contactModel.clear();

        if (content.length === 0) return reset()

        for (let item of content) {
            console.log(item.icon)
            contactModel.append({"name": item.name, "path": item.path, "icon": item.icon || ""});
        }

        hasContent = true
        listView.currentIndex = 0
    }

    function reset() {
        contactModel.clear();
        hasContent = false
    }

    function next() {
        if (listView.currentIndex > 0) {
            listView.currentIndex--
            listView.positionViewAtIndex(listView.currentIndex, ListView.Visible)
        }
    }

    function prev() {
        if (listView.currentIndex < contactModel.count - 1) {
            listView.currentIndex++
            listView.positionViewAtIndex(listView.currentIndex, ListView.Visible)
        }
    }

    function getPath() {
        if (hasContent) return listView.itemAtIndex(listView.currentIndex).path
    }
}
