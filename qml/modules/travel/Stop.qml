import QtQuick 2.2

import "../.."

Rectangle {

    width: travelslider.width
    height: travelslider.height

    color: "white"

    property string stopid
    property var modes
    property var lineids: []

    ListModel {id: lines}
    ListModel {id: arrivals}

    onStopidChanged: {reload();}

    function init() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.tfl.gov.uk/stoppoint/" + stopid);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
                parseStop(xhr.responseText);
        }
        xhr.send();
    }

    function parseStop(json) {
        if ( json === "" ) return;
        var stop = JSON.parse(json);
        titleText.text = stop["commonName"];
        lineids = []
        for (var x in stop["lines"]) {
            lineids.push(stop["lines"][x]["id"])
        }
        descriptionText.text = lineids.join(", ").toUpperCase()
    }

    function reload() {
        // reload arrivals and line status

    }

    Rectangle {
        color: "#FF00007F"

        height:74
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Column {
            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.topMargin: 12
            spacing: 8

            Text {
                color: "white"
                id: titleText
                text: "title"
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                color: "white"
                id: descriptionText

                text: stopid
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                textFormat: Text.StyledText
                horizontalAlignment: Qt.AlignLeft
            }

        }
    }


}