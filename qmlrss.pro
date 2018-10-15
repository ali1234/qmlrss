TEMPLATE = app

TARGET = qmlrss

CONFIG += c++14
QT += quick qml xml xmlpatterns network
SOURCES += src/main.cpp src/netlink.cpp src/upnp.cpp
HEADERS += src/upnp.h
RESOURCES += qmlrss.qrc

include(lib/upnp.pri)

target.path = /usr/bin
INSTALLS += target
