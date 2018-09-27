import QtQuick 2.2


Rectangle {
//    width: 300
 //   height: 14

    width: parent.width
    height: 24

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        id:dest
        text: destinationName
        font.pixelSize: 16
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        id:time
        text: Math.ceil(timeToStation/60) + " min"
        horizontalAlignment: Qt.AlignRight
        font.pixelSize: 16
    }

}