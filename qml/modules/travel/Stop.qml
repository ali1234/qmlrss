import QtQuick 2.4

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

    ListModel {id: lines}
    ListModel {id: arrivals}

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
        reload();
    }

    function reload() {
        // reload arrivals and line status
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.tfl.gov.uk/stoppoint/" + stopid + "/arrivals");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
                parseArrivals(xhr.responseText);
        }
        xhr.send();

        var xhrl = new XMLHttpRequest;
        xhrl.open("GET", "https://api.tfl.gov.uk/line/" + lineids.join(',') + "/status");
        xhrl.onreadystatechange = function() {
            if (xhrl.readyState == XMLHttpRequest.DONE)
                parseLines(xhrl.responseText);
        }
        xhrl.send();
    }

    function parseArrivals(json) {
        if ( json == "" ) return;
        var arr = JSON.parse(json);
        arrivals.clear();
        arr.sort(function(a, b) {return a.timeToStation - b.timeToStation;});
        now = Date.now();
        for (var i = 0; i < arr.length; i++) {
            arr[i].eta = new Date(now + (arr[i].timeToStation*1000))
            arrivals.append(arr[i]);
        }
    }

    function parseLines(json) {
        if ( json == "" ) return;
        var arr = JSON.parse(json);
        lines.clear();
        for (var i = 0; i < arr.length; i++) {
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
                model: arrivals
                delegate: StyledDelegate {
                    leftText: destinationName
                    rightText: Math.ceil((eta - now)/60000) + " mins"
                }
                headerText: "Arrivals"
            }
        }
    }
}


