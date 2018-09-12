import QtQuick 2.2
import QtQml.Models 2.3

ObjectModel {

    Stop {stopid: "910GFORESTH"; modes: ["overground", "tube"]} // forest hill station
    Stop {stopid: "490G00006920"; modes: ["bus"]} // bus stop
    Stop {stopid: "HUBZCW"; modes: ["overground", "national-rail"]} // canada water hub

    function init() {
        for (var i = 0; i < count; i++) {
            get(i).init();
        }
    }

    function reload() {
        for (var i = 0; i < count; i++) {
            get(i).reload();
        }
    }

}
