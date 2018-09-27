import QtQuick 2.2
import QtQml.Models 2.3

ObjectModel {

    Mode {modes: ["tube", "dlr", "overground"]}
    Stop {stopid: "910GFORESTH"; modes: ["overground", "national-rail"]} // forest hill station
    Stop {stopid: "490006920W"; modes: ["bus"]} // bus stop
    Stop {stopid: "490004733C"; modes: ["overground", "tube"]} // canada water hub

    function init() {
        for (var i = 0; i < count; i++) {
            get(i).init();
        }
    }

    function reload() {
        console.log("Reload travel model");
        for (var i = 0; i < count; i++) {
            get(i).reload();
        }
    }

}
