import QtQuick 2.2
import QSyncable 1.0

JsonListModel {
    property var url
    property var reloadTime

    onUrlChanged: {
        if (reloadtimer.running) {
            reloadtimer.stop();
            reloadtimer.start();
        }
    }

    function reload() {
        if (url === undefined) {
            return;
        }

        var xhr = new XMLHttpRequest;
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200 && xhr.responseText !== "") {
                source = JSON.parse(xhr.responseText);
            }
        }
        xhr.send();
    }

    property var reloadtimer: Timer {
        interval: reloadTime
        running: false; repeat: true; triggeredOnStart: true;
        onTriggered: reload()
    }

    property var connections: Connections {
        target: nl
        onFinished: {
            reloadtimer.start();
        }
    }
}