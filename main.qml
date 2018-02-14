import QtQuick 2.2


Rectangle {
    id: window
    color: "black"
    width: 800
    height: 480

    NewsSlider{ id: ns }

    StaticClock{}

    focus: true

    Keys.onLeftPressed: {
        ns.incrementCurrentIndex();
        ns.onMovementStarted();
        ns.onMovementEnded();
    }

    Keys.onRightPressed: {
        ns.decrementCurrentIndex();
        ns.onMovementStarted();
        ns.onMovementEnded();
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Q) {
            Qt.quit();
        }
    }

    Component.onCompleted: nl.start();
}


