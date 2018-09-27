import QtQuick 2.6

import "../.."

import "Constants.js" as Constants

Rectangle {

    width: travelslider.width
    height: travelslider.height

    color: "white"

    property var modes: []
    property var lineids: []

    ListModel {id: lines}
    ListModel {id: disruption}

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
        disruption.clear();
        for (var i = 0; i < arr.length; i++) {
            if (modes.indexOf(arr[i].modeName) > -1) {
                lines.append({
                    id: arr[i].id,
                    name: arr[i].name,
                    mode: arr[i].modeName,
                    status: arr[i].lineStatuses[0].statusSeverityDescription
                });
                if (arr[i].lineStatuses[0].disruption !== undefined) {
                    disruption.append({
                        id: arr[i].id,
                        name: arr[i].name,
                        mode: arr[i].modeName,
                        description: arr[i].lineStatuses[0].disruption.description
                    })
                }
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
            StyledList {
                spacing: 12
                model: disruption
                delegate: Column {
                    width: parent.width
                    height: childrenRect.height
                    property var colours: Constants.get_colours(id, mode)

                    Rectangle {
                        color: colours[1]
                        width: parent.width
                        height: childrenRect.height
                        Text {
                            color: colours[0]
                            text: name
                            font.pixelSize: 15
                            padding: 3
                        }
                    }

                    Text {
                        width: parent.width
                        text: description
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                        topPadding: 5
                    }
                }
                headerText: "Disruptions"
            }

        }
    }
}


