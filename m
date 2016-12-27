From: tang.junhui@zte.com.cn
Subject: [PATCH 08/12] libmultipath: wait one seconds for more
	uevents in uevent_listen() in uevents burst situations
Date: Tue, 27 Dec 2016 16:03:25 +0800
Message-ID: <1482825809-9528-9-git-send-email-tang.junhui@zte.com.cn>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, hare@suse.de, bmarzins@redhat.com, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

The more uevents are merged, the higher efficiency program will performs.
So, do not process uevents after receiving immediately in uevents burst
situations, but continue wait 1 seconds for more uevents except that too
much uevents (2048) have already been received or too much time eclipse
(60 seconds).

Change-Id: I763d491540e8114a81d12d603281540a81502742
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index cc10d65..b0b05e9 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -39,6 +39,7 @@
 #include <linux/netlink.h>
 #include <pthread.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <libudev.h>
 #include <errno.h>
 
@@ -490,11 +491,37 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 	return uev;
 }
 
+bool uevent_burst(struct timeval *start_time, int events)
+{
+	struct timeval diff_time, end_time;
+	unsigned long speed;
+	unsigned long eclipse_ms;
+
+	gettimeofday(&end_time, NULL);
+	timersub(&end_time, start_time, &diff_time);
+
+	eclipse_ms = diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
+	if (eclipse_ms == 0)
+		return true;
+	/* max wait 60s */
+	if (eclipse_ms > 60*1000) {
+		condlog(1, "burst continued =%lu ms, stoped", eclipse_ms);
+		return false;
+	}
+
+	speed = (events * 1000) / eclipse_ms;
+	if (speed > 10)
+		return true;
+
+	return false;
+}
+
 int uevent_listen(struct udev *udev)
 {
 	int err = 2;
 	struct udev_monitor *monitor = NULL;
 	int fd, socket_flags, events;
+	struct timeval start_time;
 	int need_failback = 1;
 	int timeout = 30;
 	LIST_HEAD(uevlisten_tmp);
@@ -548,6 +575,7 @@ int uevent_listen(struct udev *udev)
 	}
 
 	events = 0;
+	gettimeofday(&start_time, NULL);
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
@@ -562,7 +590,8 @@ int uevent_listen(struct udev *udev)
 		errno = 0;
 		fdcount = poll(&ev_poll, 1, poll_timeout);
 		if (fdcount && ev_poll.revents & POLLIN) {
-			timeout = 0;
+			timeout = uevent_burst(&start_time, events + 1) ? 1:0;
+
 			dev = udev_monitor_receive_device(monitor);
 			if (!dev) {
 				condlog(0, "failed getting udev device");
@@ -578,7 +607,8 @@ int uevent_listen(struct udev *udev)
 			}
 			list_add_tail(&uev->node, &uevlisten_tmp);
 			events++;
-			continue;
+			if(events < 2048)
+				continue;
 		}
 		if (fdcount < 0) {
 			if (errno == EINTR)
@@ -600,6 +630,7 @@ int uevent_listen(struct udev *udev)
 			pthread_mutex_unlock(uevq_lockp);
 			events = 0;
 		}
+		gettimeofday(&start_time, NULL);
 		timeout = 30;
 	}
 	need_failback = 0;
-- 
2.8.1.windows.1
