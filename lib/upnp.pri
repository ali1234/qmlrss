!contains( CONFIG, c\+\+1[14] ): warning("QtUPnP needs at least c++11, add CONFIG += c++11 to your .pro")

QT += core network xml

QTUPNP_PATH = $$PWD/QtUPnP/upnp

INCLUDEPATH += $$PWD/QtUPnP

SOURCES += \
    $$QTUPNP_PATH/actionmanager.cpp \
    $$QTUPNP_PATH/controlpoint.cpp \
    $$QTUPNP_PATH/datacaller.cpp \
    $$QTUPNP_PATH/devicemap.cpp \
    $$QTUPNP_PATH/helper.cpp \
    $$QTUPNP_PATH/initialdiscovery.cpp \
    $$QTUPNP_PATH/multicastsocket.cpp \
    $$QTUPNP_PATH/unicastsocket.cpp \
    $$QTUPNP_PATH/upnpsocket.cpp \
    $$QTUPNP_PATH/httpparser.cpp \
    $$QTUPNP_PATH/waitingloop.cpp \
    $$QTUPNP_PATH/didlitem.cpp \
    $$QTUPNP_PATH/xmlh.cpp \
    $$QTUPNP_PATH/xmlhdidllite.cpp \
    $$QTUPNP_PATH/browsereply.cpp \
    $$QTUPNP_PATH/connectioninfo.cpp \
    $$QTUPNP_PATH/transportinfo.cpp \
    $$QTUPNP_PATH/transportsettings.cpp \
    $$QTUPNP_PATH/mediainfo.cpp \
    $$QTUPNP_PATH/positioninfo.cpp \
    $$QTUPNP_PATH/devicecaps.cpp \
    $$QTUPNP_PATH/devicepixmap.cpp \
    $$QTUPNP_PATH/xmlhdevice.cpp \
    $$QTUPNP_PATH/device.cpp \
    $$QTUPNP_PATH/service.cpp \
    $$QTUPNP_PATH/statevariable.cpp \
    $$QTUPNP_PATH/action.cpp \
    $$QTUPNP_PATH/xmlhservice.cpp \
    $$QTUPNP_PATH/argument.cpp \
    $$QTUPNP_PATH/avtransport.cpp \
    $$QTUPNP_PATH/connectionmanager.cpp \
    $$QTUPNP_PATH/renderingcontrol.cpp \
    $$QTUPNP_PATH/contentdirectory.cpp \
    $$QTUPNP_PATH/avcontrol.cpp \
    $$QTUPNP_PATH/eventingmanager.cpp \
    $$QTUPNP_PATH/xmlhevent.cpp \
    $$QTUPNP_PATH/actioninfo.cpp \
    $$QTUPNP_PATH/xmlhaction.cpp \
    $$QTUPNP_PATH/control.cpp \
    $$QTUPNP_PATH/didlitem_playlist.cpp \
    $$QTUPNP_PATH/httpserver.cpp \
    $$QTUPNP_PATH/pixmapcache.cpp \
    $$QTUPNP_PATH/dump.cpp \
    $$QTUPNP_PATH/plugin.cpp \
    $$QTUPNP_PATH/oauth2.cpp \
    $$QTUPNP_PATH/aesencryption.cpp

HEADERS +=\
    $$QTUPNP_PATH/upnp_global.hpp \
    $$QTUPNP_PATH/actionmanager.hpp \
    $$QTUPNP_PATH/controlpoint.hpp \
    $$QTUPNP_PATH/datacaller.hpp \
    $$QTUPNP_PATH/devicemap.hpp \
    $$QTUPNP_PATH/helper.hpp \
    $$QTUPNP_PATH/initialdiscovery.hpp \
    $$QTUPNP_PATH/multicastsocket.hpp \
    $$QTUPNP_PATH/unicastsocket.hpp \
    $$QTUPNP_PATH/upnpsocket.hpp \
    $$QTUPNP_PATH/using_upnp_namespace.hpp \
    $$QTUPNP_PATH/httpparser.hpp \
    $$QTUPNP_PATH/waitingloop.hpp \
    $$QTUPNP_PATH/didlitem.hpp \
    $$QTUPNP_PATH/xmlh.hpp \
    $$QTUPNP_PATH/xmlhdidllite.hpp \
    $$QTUPNP_PATH/browsereply.hpp \
    $$QTUPNP_PATH/connectioninfo.hpp \
    $$QTUPNP_PATH/transportinfo.hpp \
    $$QTUPNP_PATH/transportsettings.hpp \
    $$QTUPNP_PATH/mediainfo.hpp \
    $$QTUPNP_PATH/positioninfo.hpp \
    $$QTUPNP_PATH/devicecaps.hpp \
    $$QTUPNP_PATH/status.hpp \
    $$QTUPNP_PATH/devicepixmap.hpp \
    $$QTUPNP_PATH/xmlhdevice.hpp \
    $$QTUPNP_PATH/device.hpp \
    $$QTUPNP_PATH/service.hpp \
    $$QTUPNP_PATH/statevariable.hpp \
    $$QTUPNP_PATH/action.hpp \
    $$QTUPNP_PATH/xmlhservice.hpp \
    $$QTUPNP_PATH/argument.hpp \
    $$QTUPNP_PATH/avtransport.hpp \
    $$QTUPNP_PATH/connectionmanager.hpp \
    $$QTUPNP_PATH/control.hpp \
    $$QTUPNP_PATH/renderingcontrol.hpp \
    $$QTUPNP_PATH/contentdirectory.hpp \
    $$QTUPNP_PATH/avcontrol.hpp \
    $$QTUPNP_PATH/eventingmanager.hpp \
    $$QTUPNP_PATH/xmlhevent.hpp \
    $$QTUPNP_PATH/actioninfo.hpp \
    $$QTUPNP_PATH/xmlhaction.hpp \
    $$QTUPNP_PATH/httpserver.hpp \
    $$QTUPNP_PATH/pixmapcache.hpp \
    $$QTUPNP_PATH/dump.hpp \
    $$QTUPNP_PATH/plugin.hpp \
    $$QTUPNP_PATH/oauth2.hpp \
    $$QTUPNP_PATH/aesencryption.h \
    $$QTUPNP_PATH/aes256.h

