import QtQuick 2.6
import QSyncable 1.0
import SortFilterProxyModel 0.2

import "../.."

import "Constants.js" as Constants

Rectangle {

    width: travelslider.width
    height: travelslider.height

    color: "white"

    property var modes: []

    // this works

    AutoJsonListModel {
        id: lines_inner
        keyField: "id"
        url: "https://api.tfl.gov.uk/line/mode/" + modes.join(',') + "/status"
        interval: 300000
    }

    SortFilterProxyModel {
        id: lines
        sourceModel: lines_inner
        sorters: [
            StringSorter { roleName: "modeName"; sortOrder: Qt.DescendingOrder },
            StringSorter { roleName: "name"; sortOrder: Qt.AscendingOrder }
        ]
    }

    // this does not: "Cannot assign object to property"
/*
    SortFilterProxyModel {
        id: lines
        sourceModel: AutoJsonListModel {
            url: "https://api.tfl.gov.uk/line/mode/" + modes.join(',') + "/status"
            interval: 300000
        }
        sorters: [
            StringSorter { roleName: "modeName"; sortOrder: Qt.DescendingOrder },
            StringSorter { roleName: "name"; sortOrder: Qt.AscendingOrder }
        ]
    }
*/

    function init() {
        //reload();
    }

    Rectangle {
        color: "#FF00007F"

        height:74

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Column {
            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.topMargin: 12
            spacing: 8

            Text {
                color: "white"
                id: titleText
                text: "Network Status"
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 18
                font.bold: true
            }

        }
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - 74

        Rectangle {
            width: parent.width / 2
            height: parent.height
            StyledList {
                model: lines
                delegate: StyledDelegate {
                    colours: Constants.get_colours(id, modeName)
                    leftText: name
                    rightText: lineStatuses[0].statusSeverityDescription
                }
                headerText: "Lines"
            }
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height
            StyledList {
                spacing: 12
                model: SortFilterProxyModel {
                    sourceModel: lines
                    filters: [
                        ExpressionFilter { expression: lineStatuses[0].disruption !== undefined }
                    ]
                }
                delegate: Column
                {
                    width: parent.width
                    height: childrenRect.height
                    property var colours: Constants.get_colours(id, modeName)

                    Rectangle {
                        color: colours[1]
                        width: parent.width
                        height: childrenRect.height
                        Text {
                            color: colours[0]
                            text: name
                            font.pixelSize: 15
                            padding: 3
                        }
                    }

                    Text {
                        width: parent.width
                        text: lineStatuses[0].disruption.description
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                        topPadding: 5
                    }
                }
                headerText: "Disruptions"
            }

        }
    }
}


