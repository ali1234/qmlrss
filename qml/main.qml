import QtQuick 2.2
import QtQml.Models 2.1

Rectangle {
    id: window
    color: "black"
    width: 800
    height: 480

    PathView{

        id: vs

        anchors.fill: parent

        highlightRangeMode: PathView.StrictlyEnforceRange
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightMoveDuration: 600
        snapMode: PathView.SnapOneItem

        pathItemCount: 3 // only show previous, current, next

        path: Path { // vertical
            startX: width/2; startY: -height
            PathLine{x: width/2; y: height*2}
        }

        model: ObjectModel {
            FeedSlider {}
        }
    }

    StaticClock{}

    focus: true

    Keys.onLeftPressed: {
        vs.currentItem.onLeft();
    }

    Keys.onRightPressed: {
        vs.currentItem.onRight();
    }

    Keys.onUpPressed: {
        vs.incrementCurrentIndex();
        vs.onMovementStarted();
        vs.onMovementEnded();
    }

    Keys.onDownPressed: {
        vs.decrementCurrentIndex();
        vs.onMovementStarted();
        vs.onMovementEnded();
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Q) {
            Qt.quit();
        }
    }

    Component.onCompleted: nl.start();
}


