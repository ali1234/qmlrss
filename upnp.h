#include <QObject>
#include "QtUPnP/upnp/controlpoint.hpp"
#include "QtUPnP/upnp/avcontrol.hpp"

namespace QtUPnP
{
    class CControlPoint;
    class CAVControl;
    class CPixmapCache;
    class CDidlItem;
}


class UPnP : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString artist MEMBER m_artist NOTIFY artistChanged)
    Q_PROPERTY(QString album MEMBER m_album NOTIFY albumChanged)
    Q_PROPERTY(QString title MEMBER m_title NOTIFY titleChanged)
    Q_PROPERTY(QString albumart MEMBER m_albumart NOTIFY albumartChanged)

    Q_PROPERTY(qint32 volume MEMBER m_volume NOTIFY volumeChanged)
    Q_PROPERTY(bool mute MEMBER m_mute NOTIFY muteChanged)

signals:
    void artistChanged();
    void albumChanged();
    void titleChanged();
    void albumartChanged();

    void volumeChanged();
    void muteChanged();

public:
    explicit UPnP();

protected slots :
    // QtUPnP
    /*! A new device is detected. */
    void newDevice (QString const & uuid);

    /*! A device is closed. */
    void lostDevice (QString const & uuid);

    /*! An UPnP event is emitted. */
    void eventReady (QStringList const & emitter);

    /*! An UPnP error is detected. */
    void upnpError (int error, QString const & description);

    /*! An network error is detected. */
    void networkError (QString const & device, QNetworkReply::NetworkError error, QString const & description);


private:

    void updateURIMetaData(QString const & URIMetaData);

    QtUPnP::CControlPoint* m_cp = nullptr; // The control point.
    QtUPnP::CAVControl m_ctl;
    QString m_renderer;
    QString m_server;

    QString m_artist;
    QString m_album;
    QString m_title;
    QString m_albumart;

    qint32 m_volume;
    bool m_mute;

};
