import QtQuick 2.2

Image {

    width: PathView.view.width
    height: PathView.view.height
    source: image
    fillMode: Image.PreserveAspectCrop

    // This function is from the Qt rssnews example
    // Returns a string representing how long ago an event occurred
    function timeSinceEvent(pubDate) {
        var result = pubDate;

        // We need to modify the pubDate read from the RSS feed
        // so the JavaScript Date object can interpret it
        var d = pubDate.replace(',','').split(' ');
        if (d.length != 6)
            return result;

        var date = new Date([d[0], d[2], d[1], d[3], d[4], 'GMT' + d[5]].join(' '));

        if (!isNaN(date.getDate())) {
            var age = new Date() - date;
            var minutes = Math.floor(Number(age) / 60000);
            if (minutes < 1440) {
                if (minutes < 2)
                    result = qsTr("Just now");
                else if (minutes < 60)
                    result = '' + minutes + ' ' + qsTr("minutes ago")
                else if (minutes < 120)
                    result = qsTr("1 hour ago");
                else
                    result = '' + Math.floor(minutes/60) + ' ' + qsTr("hours ago");
            }
            else {
                result = date.toDateString();
            }
        }
        return result;
    }

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
                text: title
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 18
                font.bold: true
            }
/*
            StyledText {
                width: parent.width
                font.pixelSize: 12
                textFormat: Text.RichText
                font.italic: true
                text: timeSinceEvent(pubDate)
            }
*/
            StyledText {
                id: descriptionText

                text: description
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                textFormat: Text.StyledText
                horizontalAlignment: Qt.AlignLeft
            }
        }
    }
}
