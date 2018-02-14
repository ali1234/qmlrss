import QtQuick 2.2
import QtQuick.XmlListModel 2.0


ListModel {

    function rebuildListModel() {
        for (var i = 0; i < feeds.length; i++) {
            if (feeds[i].status === XmlListModel.Loading)
                return
        }
        clear()
        for (var i = 0; i < feeds.length; i++) {
            for (var j = 0; j < feeds[i].count; j++) {
                append(feeds[i].get(j))
            }
        }
        console.log("Rebuild")
    }

    property list<XmlListModel> feeds: [
/*
        XmlListModel {
                source: "http://feeds.bbci.co.uk/news/business/rss.xml"
                query: "/rss/channel/item"
                namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/';"
                XmlRole { name: "title"; query: "title/string()" }
                // Remove any links from the description
                XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
                XmlRole { name: "image"; query: "media:thumbnail/@url/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                onStatusChanged: {
                    rebuildListModel()
                }
        },
*/
        XmlListModel {
                source: Qt.application.arguments[1]
                query: "/rss/channel/item"
                namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/';"
                XmlRole { name: "title"; query: "title/string()" }
                // Remove any links from the description
                XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
                XmlRole { name: "image"; query: "media:thumbnail/@url/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "pubDate"; query: "pubDate/string()" }
                onStatusChanged: {
                    rebuildListModel()
                }
        }
    ]

    function reload() {
        for (var i = 0; i < feeds.length; i++) {
            feeds[i].reload()
        }
    }

}
