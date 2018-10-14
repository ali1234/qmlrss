import QtQuick 2.2

import "../.."

Image {
    //color: "red"
    width: parent.width
    height: parent.height

    source: upnp.albumart
    fillMode: Image.PreserveAspectCrop

    Rectangle {
        color: "#6F000000"

        height:90
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.topMargin: 12
            spacing: 8

            StyledText {
                id: titleText
                text: upnp.artist + " " + upnp.title
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 18
                font.bold: true
            }

            StyledText {
                id: descriptionText

                text: upnp.album
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                textFormat: Text.StyledText
                horizontalAlignment: Qt.AlignLeft
            }
        }
    }

    function onLeft() {
    }

    function onRight() {
    }

}