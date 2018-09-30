TEMPLATE = subdirs

SUBDIRS += app QtUPnP/upnp

app.file = app.pro
app.depends = QtUPnP/upnp