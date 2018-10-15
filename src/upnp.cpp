#include "upnp.h"

#include "upnp/avtransport.hpp"
#include "upnp/avcontrol.hpp"
#include "upnp/renderingcontrol.hpp"
#include "upnp/xmlhdidllite.hpp"

USING_UPNP_NAMESPACE

UPnP::UPnP ()
{
    m_cp = new CControlPoint (this);

    connect (m_cp, SIGNAL(newDevice(QString const &)), this, SLOT(newDevice(QString const &)));
    connect (m_cp, SIGNAL(lostDevice(QString const &)), this, SLOT(lostDevice(QString const &)));

    connect (m_cp, SIGNAL(eventReady(QStringList const &)), this, SLOT(eventReady(QStringList const &)));
    connect (m_cp, SIGNAL(upnpError(int, QString const &)), this, SLOT(upnpError(int, QString const &)));
    connect (m_cp, SIGNAL(networkError(QString const &, QNetworkReply::NetworkError, QString const &)),
           this, SLOT(networkError(QString const &, QNetworkReply::NetworkError, QString const &)));

    m_ctl.setControlPoint (m_cp);

    qInfo() << "UPnP created";
}


void UPnP::newDevice (QString const & uuid)
{

    CDevice const & device = m_cp->device (uuid);
    qInfo() << "new device " << device.friendlyName() << " " << device.deviceType() << " " << device.uuid();

    if (device.friendlyName() == "gmediarender") {
        m_renderer = device.uuid();

        CTransportInfo  info           = m_ctl.avTransport().getTransportInfo(m_renderer);
        QString const & transportState = info.currentTransportState ();

        CMediaInfo minfo = m_ctl.avTransport().getMediaInfo(m_renderer);
        updateURIMetaData(minfo.currentURIMetaData());

        qInfo() << "got target device " << transportState;

        m_cp->subscribe(device.uuid());
    }

}

void UPnP::lostDevice (QString const & uuid)
{
    qInfo() << "lost device " << uuid;
    if (uuid == m_renderer) {
        m_renderer.clear();
        qInfo() << "lost target device";
    }
}



void UPnP::eventReady (QStringList const & emitter)
{
    qInfo() << "event ready ";


    if (!emitter.isEmpty ())
    {
        QString const & device  = emitter[0];
        QString const & service = emitter[1];
        CStateVariable  variable;
        QVariant        variant;
        for (QStringList::const_iterator it = emitter.cbegin () + 2, end = emitter.cend (); it != end; ++it)
        {
            QString const & name = *it;
            variable             = m_cp->stateVariable (device, service, name);
            if (name == "Mute" || name == "Volume" || name == "VolumeDB")
            {
                QList<TConstraint> constraint;
                constraint << TConstraint ("channel", "master");
                variant = variable.value (constraint);
                if (!variant.isValid ())
                {
                    variant = variable.value ();
                }
            }
            else
            {
                variant = variable.value ();
            }

            if (variant.isValid ())
            {
                //qDebug () << name << ':' << variant;

                if (name == "Volume")
                {
                    m_volume = variant.toInt ();
                }
                else if (name == "Mute")
                {
                    m_mute = variant.toBool();
                }
                else if (name == "AVTransportURIMetaData" || name == "CurrentTrackMetaData")
                {
                    updateURIMetaData(variant.toString());
                }
            /*        else if (name == "TransportState")
                {
                  QString state = variant.toString ();
                  // Asume PLAYING follow TRANSITIONING because some renderers send only TRANSITIONING.
            //          if (state == "STOPPED")
            //          {
            //            m_cp->abortStreaming ();
            //          }

                  bool playing = state == "PLAYING" || state == "TRANSITIONING";
                  playingIcon (playing);
                  togglePositionTimer (playing);
                }
                else if (name == "CurrentPlayMode")
                {
                  m_playMode = playMode (variant.toString ());
                  applyPlayMode ();
                }
                else if (name == "CurrentTrackDuration")
                {
                  int ms = static_cast<int>(timeToMS (variant.toString ()));
                  ui->m_position->blockSignals (true);
                  ui->m_position->setMaximum (ms);
                  ui->m_position->blockSignals (false);
                }
                else if (name == "AVTransportURI" || name == "CurrentTrackURI")
                {
                  QString uri = variant.toString ();
                  setItemBold (uri);
                  if (m_cp->playlistName ().isEmpty ())
                  {
                    ui->m_queue->setNextAVTransportURI (m_cp, m_renderer);
                  }
                }*/

            }
        }
    }
}

void UPnP::upnpError (int error, QString const & description)
{

    QString text = QString ("%1;UPnP error;%2%3")
                            .arg (QDateTime::currentDateTime ().toString ())
                            .arg (error).arg (description);

    qInfo() << text;

}

void UPnP::networkError (QString const & device, QNetworkReply::NetworkError error,
                                QString const & description)
{
    QString deviceName = m_cp->device (device).name ();
    QString text       = QString ("%1;Network error;%2;%3;%4")
                                  .arg (QDateTime::currentDateTime ().toString ())
                                  .arg (deviceName).arg (error).arg (description);

    qInfo() << text;

}


void UPnP::updateURIMetaData (QString const & URIMetaData)
{
    CXmlHDidlLite h;
    CDidlItem didl = h.firstItem(URIMetaData);

    setProperty("title", didl.title());
    setProperty("album", didl.album());
    setProperty("albumart", didl.albumArtURI(0));

    QString artist = didl.artist();
    if (artist.isEmpty())
    {
        artist = didl.albumArtist();
    }
    setProperty("artist", artist);

//    m_duration = didl.duration();
}