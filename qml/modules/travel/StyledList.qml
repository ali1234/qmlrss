import QtQuick 2.4

ListView {
    anchors.fill: parent
    anchors.rightMargin: 35
    anchors.leftMargin: 35
    anchors.topMargin: 3
    anchors.bottomMargin: 12
    spacing: 2
    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter
    clip: true

    property var headerText: "Header"
    property var footerText: ""

    header: Rectangle {
        height: 40
        Text {
            anchors.verticalCenter: parent.verticalCenter
            z: 100
            text: headerText
            font.pixelSize: 18
        }
    }
}