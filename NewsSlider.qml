import QtQuick 2.2

PathView {
    id: newsslider
    anchors.fill: parent
    //model: MergedXmlListModel{}

    highlightRangeMode: PathView.StrictlyEnforceRange
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightMoveDuration: 600
    snapMode: PathView.SnapOneItem

    delegate: NewsDelegate {}

    pathItemCount: 3 // only show previous, current, next

    path: Path { // horizontal
        startX: -width; startY: height/2
        PathLine{x: width*2; y: height/2}
    }
/*
    path: Path { // vertical
        startX: width/2; startY: -height
        PathLine{x: width/2; y: height*2}
    }
*/

    Timer {
        id: modeltimer
        interval: 600000; running: false; repeat: true;
        onTriggered: model.reload()
    }

    Timer {
        id: autotimer
        interval: 10000; running: true; repeat: true;
        onTriggered: {
            incrementCurrentIndex()
        }
    }

    Timer {
        id: manualtimer
        interval: 20000; running: false; repeat: false;
        onTriggered: autotimer.restart()
    }

    onMovementStarted: {
        autotimer.stop()
        manualtimer.stop()
    }

    onMovementEnded: {
        manualtimer.restart()
    } 

    Connections {
        target: nl
        onFinished: {
            console.log("going to load model now");
            newsslider.model = Qt.createComponent("MergedXmlListModel.qml").createObject(newsslider);
            modeltimer.start();
        }
    }

}
