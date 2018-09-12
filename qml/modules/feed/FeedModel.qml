import QtQuick 2.2
import QtQuick.XmlListModel 2.0


ListModel {

    ListElement {
        title: "Loading feeds..."
        description: ""
        image: "qrc:///loading.png"
        link: ""
        pubDate: ""
        guid: ""
    }

    property var feeds: []

    property var slider
    property bool please_delete_last_item: false

    function init() {
        var sources = "news/technology:news/business";

        if (Qt.application.arguments[1] !== undefined) {
            sources = Qt.application.arguments[1];
        }
        sources = sources.split(":");

        var component = Qt.createComponent("BBCListModel.qml");

        for (i=0; i<sources.length; i++) {
            var object = component.createObject(null, {
                "source": "https://feeds.bbci.co.uk/" + sources[i] + "/rss.xml",
            });
            object.onStatusChanged.connect(rebuildList);

            feeds.push(object);
        }

        for (var i = 0; i < feeds.length; i++) {
            if (feeds[i].status === XmlListModel.Error || feeds[i].status === XmlListModel.Null) {
                feeds[i].reload();
            }
        }
    }

    function reload() {
        for (var i = 0; i < feeds.length; i++) {
            feeds[i].reload();
        }
    }

    function rebuildList() {

        for (var i = 0; i < feeds.length; i++) {
            if(feeds[i].status === XmlListModel.Loading) {
                // Wait until all feeds have either loaded or failed
                return;
            }
        }

        // remove dupes
        var hash = {};
        for (var i = 0; i < feeds.length; i++) {
            for (var j = 0; j < feeds[i].count; j++) {
                var item = feeds[i].get(j);
                hash[item.guid] = item;
            }
        }

        var newitems = [];

        for (var key in hash) {
            newitems.push(hash[key]);
        }

        // sort new list
        newitems.sort(function(a, b) {return a.pubDate > b.pubDate;});

        // update later
        Qt.callLater(updateListModel, newitems);
    }

    function updateListModel(newitems) {

        if(slider.moving || !(slider.offset % 1 === 0)) {
            // wait for the slider to stop moving
            Qt.callLater(updateListModel, newitems);
            return;
        }

        // sigh...
        var current_item = JSON.parse(JSON.stringify(get(slider.currentIndex)));
        var position = -1;

        clear();

        for (var i = 0; i < newitems.length; i++) {
            if (newitems[i].guid == current_item.guid) {
                position = i;
            }
            append(newitems[i]);
        }

        if (position == -1) {
            append(current_item);
            slider.positionViewAtIndex((count-1), PathView.Center);
            if(current_item.guid == "")
                slider.incrementCurrentIndex()
            please_delete_last_item = true;
        } else {
            slider.positionViewAtIndex(position, PathView.Center);
        }
    }

}
