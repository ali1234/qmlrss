import QtQuick 2.4

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
    }

    function parseArrivals(json) {
        if ( json == "" ) return;
        var arr = JSON.parse(json);
        console.log(stopid);
        arrivals.clear();
        arr.sort(function(a, b) {return a.timeToStation - b.timeToStation;});
        for (var i = 0; i < arr.length; i++) {
            arrivals.append(arr[i]);
            console.log(arr[i].timeToStation + " " + arr[i].destinationName);
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
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height
            //color: "green"

            ListView {
                anchors.fill: parent
                anchors.rightMargin: 35
                anchors.leftMargin: 35
                anchors.topMargin: 12
                anchors.bottomMargin: 12

                header: Rectangle {
                    height: 40
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        z: 100
                        id: flibble
                        text: "Arrivals"
                        font.pixelSize: 20

                    }
                }

                headerPositioning: ListView.OverlayHeader

                clip: true
                width: 200
                height: 200
                model: arrivals
                delegate: ArrivalDelegate {}

                footer: Rectangle {
                    height: 40
                    Text {
                        id: footerText

                        anchors.verticalCenter: parent.verticalCenter
                        z: 100
                        id: flibble
                        text: "Arrivals"
                        font.pixelSize: 14

                    }
                }

                footerPositioning: ListView.OverlayFooter


            }

        }
    }
}


