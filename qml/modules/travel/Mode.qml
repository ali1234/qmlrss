import QtQuick 2.4

import "../.."

import "Constants.js" as Constants

Rectangle {

    width: travelslider.width
    height: travelslider.height

    color: "white"

    property var modes: []
    property var lineids: []

    ListModel {id: lines}
    ListModel {id: arrivals}

    function init() {
        reload();
    }

    function reload() {
        var xhrl = new XMLHttpRequest;
        xhrl.open("GET", "https://api.tfl.gov.uk/line/mode/" + modes.join(',') + "/status");
        xhrl.onreadystatechange = function() {
            if (xhrl.readyState == XMLHttpRequest.DONE)
                parseLines(xhrl.responseText);
        }
        xhrl.send();
    }

    function parseLines(json) {
        if ( json == "" ) return;
        var arr = JSON.parse(json);
        lines.clear();
        for (var i = 0; i < arr.length; i++) {
            console.log(modes + " " + arr[i].modeName);
            if (modes.indexOf(arr[i].modeName) > -1) {
                lines.append({
                    id:arr[i].id,
                    name:arr[i].name,
                    mode:arr[i].modeName,
                    status: arr[i].lineStatuses[0].statusSeverityDescription
                });
            }
        }
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
                text: "Network Status"
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 18
                font.bold: true
            }

        }
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - 74

        Rectangle {
            width: parent.width / 2
            height: parent.height
            StyledList {
                model: lines
                delegate: StyledDelegate {
                    colours: Constants.get_colours(id, mode)
                    leftText: name
                    rightText: status
                }
                headerText: "Lines"
            }
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height

        }
    }
}


