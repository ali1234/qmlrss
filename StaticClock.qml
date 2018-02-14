import QtQuick 2.2
 
Rectangle {
    color: "#6F000000"
    width: 260
    height: 148
    radius: 15
    anchors.verticalCenter: parent.top
    anchors.horizontalCenter: parent.left

    Column {

        anchors.top: parent.verticalCenter
        anchors.topMargin: 4
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 10

        Text {
            color: "white"
            id: time
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true; font.pixelSize: 34
        }

        Text {
            color: "white"
            id: date
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true; font.pixelSize: 14
        }

    }

    function timeChanged() {
        var dt = new Date;
        time.text = dt.toLocaleTimeString(Qt.locale("en_UK"), "hh:mm");
        date.text = dt.toLocaleDateString(Qt.locale("en_UK"), "ddd d MMM");
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }
}
