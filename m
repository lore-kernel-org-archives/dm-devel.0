From: Hannes Reinecke <hare@suse.de>
Subject: libmultipath: use poll() in uevent_listen()
Date: Wed, 11 May 2016 12:35:53 +0200
Message-ID: <1462962953-9492-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

As we're not modifying the signal mask anymore we can switch
back to normal 'poll' instead of 'ppoll'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/uevent.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index fbe9c44..454b819 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -477,7 +477,6 @@ int uevent_listen(struct udev *udev)
 	int fd, fd_ep = -1, socket_flags, events;
 	int need_failback = 1;
 	int timeout = 30;
-	sigset_t mask;
 	LIST_HEAD(uevlisten_tmp);
 
 	/*
@@ -528,22 +527,20 @@ int uevent_listen(struct udev *udev)
 		goto out;
 	}
 
-	pthread_sigmask(SIG_SETMASK, NULL, &mask);
 	events = 0;
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
 		struct pollfd ev_poll;
-		struct timespec poll_timeout;
+		int poll_timeout;
 		int fdcount;
 
 		memset(&ev_poll, 0, sizeof(struct pollfd));
 		ev_poll.fd = fd;
 		ev_poll.events = POLLIN;
-		memset(&poll_timeout, 0, sizeof(struct timespec));
-		poll_timeout.tv_sec = timeout;
+		poll_timeout = timeout * 1000;
 		errno = 0;
-		fdcount = ppoll(&ev_poll, 1, &poll_timeout, &mask);
+		fdcount = poll(&ev_poll, 1, poll_timeout);
 		if (fdcount && ev_poll.revents & POLLIN) {
 			timeout = 0;
 			dev = udev_monitor_receive_device(monitor);
-- 
2.6.6
