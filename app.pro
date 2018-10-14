TEMPLATE = app

TARGET = qmlrss

QT += quick qml xml xmlpatterns
SOURCES = main.cpp netlink.cpp upnp.cpp
HEADERS = upnp.h
RESOURCES += qmlrss.qrc

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/QtUPnP/upnp/release/ -lqtupnp
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/QtUPnP/upnp/debug/ -lqtupnp

unix {
  LIBS += $$OUT_PWD/QtUPnP/upnp/libqtupnp.a
  PRE_TARGETDEPS += $$OUT_PWD/QtUPnP/upnp/libqtupnp.a
}

target.path = /usr/bin
INSTALLS += target
