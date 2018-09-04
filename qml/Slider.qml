import QtQuick 2.2


PathView{
    highlightRangeMode: PathView.StrictlyEnforceRange
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightMoveDuration: 600
    snapMode: PathView.SnapOneItem
    pathItemCount: 3 // only show previous, current, next
}