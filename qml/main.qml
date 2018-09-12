import QtQuick 2.2
import QtQml.Models 2.3

import "slider"
import "modules/feed"
import "modules/music"
import "modules/travel"


Rectangle {
    id: window
    color: "black"
    width: 800
    height: 480

    Slider{
        id: vs
        anchors.fill: parent
        path: SliderPathV {}
        model: ObjectModel {
            Music {}
            FeedSlider {}
            TravelSlider {}
        }
        currentIndex: 1
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


