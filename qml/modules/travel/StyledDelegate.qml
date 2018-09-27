import QtQuick 2.2


Rectangle {

    width: parent.width
    height: 24

    property var colours: ["yellow", "black"]
    property var leftText: ""
    property var rightText: ""

    color: colours[1]

    Text {
        color: colours[0]
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: leftText
        font.pixelSize: 15
    }

    Text {
        color: colours[0]
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: rightText
        horizontalAlignment: Qt.AlignRight
        font.pixelSize: 15
    }

}