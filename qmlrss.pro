TEMPLATE = app

QT += quick qml xml xmlpatterns
SOURCES = main.cpp
RESOURCES += qmlrss.qrc

OTHER_FILES = *.qml

target.path = /usr/bin
INSTALLS += target
