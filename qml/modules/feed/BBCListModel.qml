import QtQuick 2.2
import QtQuick.XmlListModel 2.0


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
}