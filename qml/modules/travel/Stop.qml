import QtQuick 2.4
import QSyncable 1.0
import SortFilterProxyModel 0.2

import "../.."

import "Constants.js" as Constants

Rectangle {

    width: travelslider.width
    height: travelslider.height

    color: "white"

    property string stopid
    property var modes: []
    property var lineids: []
    property var now: Date.now()

    AutoJsonListModel {
        id: lines
        keyField: "id"
        // url will be discovered later
        interval: 300000
    }

    AutoJsonListModel {
        id: arrivals
        keyField: "id"
        url: "https://api.tfl.gov.uk/stoppoint/" + stopid + "/arrivals"
        interval: 120000
    }

    function init() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.tfl.gov.uk/stoppoint/" + stopid);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200 && xhr.responseText !== "") {
                var stop = JSON.parse(xhr.responseText);
                titleText.text = stop["commonName"];
                lineids = []
                for (var x in stop["lines"]) {
                    lineids.push(stop["lines"][x]["id"])
                }
                descriptionText.text = lineids.join(", ").toUpperCase()
                lines.url = "https://api.tfl.gov.uk/line/" + lineids.join(',') + "/status"
            }
        }
        xhr.send();
    }

    Timer {
        interval: 10000; running: true; repeat: true;
        onTriggered: now = Date.now();
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

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - 74

        Rectangle {
            width: parent.width / 2
            height: parent.height
            StyledList {
                model: SortFilterProxyModel {
                    sourceModel: lines
                    sorters: [
                        StringSorter { roleName: "modeName"; sortOrder: Qt.DescendingOrder },
                        StringSorter { roleName: "name"; sortOrder: Qt.AscendingOrder }
                    ]
                    filters: [
                        ExpressionFilter { expression: modes.indexOf(modeName) > -1 }
                    ]
                }
                delegate: StyledDelegate
                {
                    colours: Constants.get_colours(id, modeName)
                    leftText: name
                    rightText: lineStatuses[0].statusSeverityDescription
                }
                headerText: "Lines"
            }
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height
            StyledList {
                model: SortFilterProxyModel {
                    sourceModel: arrivals
                    sorters: [
                        StringSorter { roleName: "expectedArrival"; sortOrder: Qt.AscendingOrder }
                    ]
                    filters: [
                        RangeFilter { roleName: "expectedArrival"; minimumValue: (new Date(now - 60000)).toISOString(); maximumValue: "Z" }
                    ]
                }
                delegate: StyledDelegate {
                    leftText: destinationName
                    rightText: Math.max(0, Math.ceil((new Date(expectedArrival) - now)/60000)) + " mins"
                }
                headerText: "Arrivals"
            }
        }
    }
}


