#include <QThread>

struct nlmsghdr;

class Netlink : public QThread {

public:
    void run();
 
private:
    bool parse_route(struct nlmsghdr *nlh);

};
