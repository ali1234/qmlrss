#include <netinet/in.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <net/if.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <QDebug>

#include "netlink.h"

bool Netlink::parse_route(struct nlmsghdr *nlh)
{
    struct rtmsg *r = (struct rtmsg *) NLMSG_DATA(nlh);
    int route_attribute_len = RTM_PAYLOAD(nlh);

    if (r->rtm_table != RT_TABLE_MAIN) return false;
    if (r->rtm_family != AF_INET) return false;

    struct rtattr *route_attribute = (struct rtattr *) RTM_RTA(r);

    for ( ; RTA_OK(route_attribute, route_attribute_len);
        route_attribute = RTA_NEXT(route_attribute, route_attribute_len))
    {
        switch (route_attribute->rta_type) {
        case RTA_SRC: // if route has any of these
        case RTA_DST: // it isn't a default route
        case RTA_IIF: // so return false.
            return false;
        default:
            break;

        }
    }

    return true;
}

void Netlink::run() {
    qDebug("Netlink: Waiting for default route...");

    struct sockaddr_nl addr;
    int monsock, dumpsock, len;
    char buffer[4096];
    struct nlmsghdr *nlh;

    if ((monsock = socket(PF_NETLINK, SOCK_RAW, NETLINK_ROUTE)) == -1) {
        qDebug("Netlink: Unable to open netlink socket.");
        return;
    }

    memset(&addr, 0, sizeof(addr));
    addr.nl_family = AF_NETLINK;
    addr.nl_groups = RTMGRP_IPV4_ROUTE;

    if (bind(monsock, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
        qDebug("Netlink: Unable to bind netlink socket.");
        close(monsock);
        return;
    }

    if ((dumpsock = socket(PF_NETLINK, SOCK_RAW, NETLINK_ROUTE)) == -1) {
        qDebug("Netlink: Unable to open netlink socket.");
        close(monsock);
        return;
    }

    struct nlmsghdr *nlMsg;
    char msgBuf[2048];

    /* Initialize the buffer */
    memset(msgBuf, 0, 2048);

    /* point the header and the msg structure pointers into the buffer */
    nlMsg = (struct nlmsghdr *)msgBuf;

    /* Fill in the nlmsg header */
    nlMsg->nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));      // Length of message.
    nlMsg->nlmsg_type = RTM_GETROUTE;   // Get the routes from kernel routing table .

    nlMsg->nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST;    // The message is a request for dump.
    nlMsg->nlmsg_seq = 0;       // Sequence of the message packet.
    nlMsg->nlmsg_pid = getpid();        // PID of process sending the request.

    /* Send the request */
    if (send(dumpsock, nlMsg, nlMsg->nlmsg_len, 0) < 0) {
        qDebug("Netlink: Unable to send netlink message.");
        close(monsock);
        close(dumpsock);
        return;
    }

    nlh = (struct nlmsghdr *)buffer;

    int done = 0;
    while(!done) {
        len = recv(dumpsock, nlh, 4096, 0);

        while (NLMSG_OK(nlh, len)) {
            if (nlh->nlmsg_type == RTM_NEWROUTE) {
                if(parse_route(nlh)) {
                    close(dumpsock);
                    close(monsock);
                    qDebug("Netlink: Pre-existing default route.");
                    return;
                }
            } else if (nlh->nlmsg_type == NLMSG_DONE) {
                done = 1;
            }
            nlh = NLMSG_NEXT(nlh, len);
        }
    }

    close(dumpsock);

    done = 0;

    while(1) {
        len = recv(monsock, nlh, 4096, 0);

        while (!done && NLMSG_OK(nlh, len)) {
            if (nlh->nlmsg_type == RTM_NEWROUTE) {
                if(parse_route(nlh)) {
                    close(monsock);
                    qDebug("Netlink: Default route added.");
                    return;
                }
            } else if (nlh->nlmsg_type != NLMSG_DONE) {
                done = 1;
            }
            nlh = NLMSG_NEXT(nlh, len);
        }
    }

    qDebug("Netlink: Unreachable.");
    return;
}
