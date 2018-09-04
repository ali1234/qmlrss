import QtQuick 2.2

PathView {
    id: newsslider
    width: parent.width
    height: parent.height
    //model: MergedXmlListModel{}

    highlightRangeMode: PathView.StrictlyEnforceRange
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightMoveDuration: 600
    snapMode: PathView.SnapOneItem

    delegate: FeedDelegate {}

    pathItemCount: 3 // only show previous, current, next

    path: Path { // horizontal
        startX: -width; startY: height/2
        PathLine{x: width*2; y: height/2}
    }

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

    function onLeft() {
        vs.currentItem.incrementCurrentIndex();
        vs.currentItem.onMovementStarted();
        vs.currentItem.onMovementEnded();
    }

    function onRight() {
        vs.currentItem.decrementCurrentIndex();
        vs.currentItem.onMovementStarted();
        vs.currentItem.onMovementEnded();
    }

    Connections {
        target: nl
        onFinished: {
            console.log("going to load model now");
            newsslider.model = Qt.createComponent("FeedModel.qml").createObject(newsslider);
            modeltimer.start();
        }
    }

}
