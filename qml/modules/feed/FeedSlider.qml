import QtQuick 2.2

import "../../slider"


Slider {
    id: newsslider
    width: parent.width
    height: parent.height
    path: SliderPathH {}
    delegate: FeedDelegate {}
    model: FeedModel {slider: newsslider}

    Timer {
        id: modeltimer
        interval: 600000; running: false; repeat: true;
        onTriggered: model.reload()
    }

    Timer {
        id: autotimer
        interval: 10000; running: true; repeat: true;
        onTriggered: {
            if (model.please_delete_last_item && currentIndex != (count-1)) {
                model.remove(model.count-1, 1);
                model.please_delete_last_item = false
            }
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
        incrementCurrentIndex();
        onMovementStarted();
        onMovementEnded();
    }

    function onRight() {
        decrementCurrentIndex();
        onMovementStarted();
        onMovementEnded();
    }

    Connections {
        target: nl
        onFinished: {
            model.netup();
            modeltimer.start();
        }
    }

}
