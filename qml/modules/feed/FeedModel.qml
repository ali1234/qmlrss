import QtQuick 2.2
import QtQuick.XmlListModel 2.0


ListModel {

    ListElement {
        title: "Loading feeds..."
        description: ""
        image: "qrc:///loading.jpg"
        link: ""
        pubDate: ""
        guid: ""
    }

    property var slider
    property bool please_delete_last_item: false

    function netup() {
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

    property list<XmlListModel> feeds: [
        XmlListModel {
                source: "https://feeds.bbci.co.uk/news/world/africa/rss.xml"
                query: "/rss/channel/item"
                namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/';"
                XmlRole { name: "title"; query: "title/string()" }
                // Remove any links from the description
                XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
                XmlRole { name: "image"; query: "media:thumbnail/@url/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                XmlRole { name: "guid"; query: "guid/string()" }
                onStatusChanged: {
                    rebuildList();
                }
        },

        XmlListModel {
                source: "https://feeds.bbci.co.uk/news/business/rss.xml"
                query: "/rss/channel/item"
                namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/';"
                XmlRole { name: "title"; query: "title/string()" }
                // Remove any links from the description
                XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
                XmlRole { name: "image"; query: "media:thumbnail/@url/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                XmlRole { name: "guid"; query: "guid/string()" }
                onStatusChanged: {
                    rebuildList();
                }
        }
    ]

}
