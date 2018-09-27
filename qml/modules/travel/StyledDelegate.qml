import QtQuick 2.6


Rectangle {

    width: parent.width
    height: childrenRect.height

    property var colours: ["yellow", "black"]
    property var leftText: ""
    property var rightText: ""

    color: colours[1]

    Text {
        color: colours[0]
        padding: 3
        text: leftText
        font.pixelSize: 15
    }

    Text {
        color: colours[0]
        anchors.right: parent.right
        padding: 3
        text: rightText
        horizontalAlignment: Qt.AlignRight
        font.pixelSize: 15
    }

}