From: tang.junhui@zte.com.cn
Subject: [PATCH 08/12] libmultipath: wait one seconds for more
	uevents in uevent_listen() in uevents burst situations
Date: Thu, 29 Dec 2016 09:54:58 +0800
Message-ID: <1482976498-11424-1-git-send-email-tang.junhui@zte.com.cn>
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
To: mwilck@suse.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

The more uevents are merged, the higher efficiency program will performs.
So, do not process uevents after receiving immediately in uevents burst
situations, but continue wait one seconds for more uevents except that
too much uevents (2048) have already been received or too much time
eclipse (30 seconds).

Change-Id: I763d491540e8114a81d12d603281540a81502742
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index cc10d65..0345e6e 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -39,6 +39,7 @@
 #include <linux/netlink.h>
 #include <pthread.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <libudev.h>
 #include <errno.h>
 
@@ -51,6 +52,10 @@
 #include "config.h"
 #include "blacklist.h"
 
+#define MAX_ACCUMULATION_COUNT 2048
+#define MAX_ACCUMULATION_TIME 30*1000
+#define MIN_BURST_SPEED 10
+
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
 LIST_HEAD(uevq);
@@ -490,11 +495,43 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 	return uev;
 }
 
+bool uevent_burst(struct timeval *start_time, int events)
+{
+	struct timeval diff_time, end_time;
+	unsigned long speed;
+	unsigned long eclipse_ms;
+
+	if(events > MAX_ACCUMULATION_COUNT) {
+		condlog(2, "burst got %u uevents, too much uevents, stopped", events);
+		return false;
+	}
+
+	gettimeofday(&end_time, NULL);
+	timersub(&end_time, start_time, &diff_time);
+
+	eclipse_ms = diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
+
+	if (eclipse_ms == 0)
+		return true;
+
+	if (eclipse_ms > MAX_ACCUMULATION_TIME) {
+		condlog(2, "burst continued %lu ms, too long time, stopped", eclipse_ms);
+		return false;
+	}
+
+	speed = (events * 1000) / eclipse_ms;
+	if (speed > MIN_BURST_SPEED)
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
@@ -548,6 +585,7 @@ int uevent_listen(struct udev *udev)
 	}
 
 	events = 0;
+	gettimeofday(&start_time, NULL);
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
@@ -562,7 +600,8 @@ int uevent_listen(struct udev *udev)
 		errno = 0;
 		fdcount = poll(&ev_poll, 1, poll_timeout);
 		if (fdcount && ev_poll.revents & POLLIN) {
-			timeout = 0;
+			timeout = uevent_burst(&start_time, events + 1) ? 1 : 0;
+
 			dev = udev_monitor_receive_device(monitor);
 			if (!dev) {
 				condlog(0, "failed getting udev device");
@@ -600,6 +639,7 @@ int uevent_listen(struct udev *udev)
 			pthread_mutex_unlock(uevq_lockp);
 			events = 0;
 		}
+		gettimeofday(&start_time, NULL);
 		timeout = 30;
 	}
 	need_failback = 0;
-- 
2.8.1.windows.1
