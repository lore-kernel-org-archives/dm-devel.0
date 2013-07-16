From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/30] multipath: reference the udev context when
	starting event queue
Date: Tue, 16 Jul 2013 09:13:15 +0200
Message-ID: <1373958801-103613-25-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The uevent listener is running asynchronously, so it might still
be active and receiving events when the main thread is already
shut down. So it need to take a separate reference to the udev
context to avoid the context becoming invalid while the listener
is running.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uevent.c | 16 ++++++++++++----
 libmultipath/uevent.h |  4 +++-
 multipathd/main.c     |  4 ++--
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0643e14..9ee3ade 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -47,7 +47,6 @@
 #include "list.h"
 #include "uevent.h"
 #include "vector.h"
-#include "config.h"
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
@@ -127,11 +126,14 @@ service_uevq(struct list_head *tmpq)
 
 static void uevq_stop(void *arg)
 {
+	struct udev *udev = arg;
+
 	condlog(3, "Stopping uev queue");
 	pthread_mutex_lock(uevq_lockp);
 	my_uev_trigger = NULL;
 	pthread_cond_signal(uev_condp);
 	pthread_mutex_unlock(uevq_lockp);
+	udev_unref(udev);
 }
 
 void
@@ -399,7 +401,7 @@ exit:
 	return 1;
 }
 
-int uevent_listen(void)
+int uevent_listen(struct udev *udev)
 {
 	int err;
 	struct udev_monitor *monitor = NULL;
@@ -411,11 +413,17 @@ int uevent_listen(void)
 	 * thereby not getting to empty the socket's receive buffer queue
 	 * often enough.
 	 */
-	pthread_cleanup_push(uevq_stop, NULL);
+	if (!udev) {
+		condlog(1, "no udev context");
+		return 1;
+	}
+	udev_ref(udev);
+	pthread_cleanup_push(uevq_stop, udev);
 
-	monitor = udev_monitor_new_from_netlink(conf->udev, "udev");
+	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
 		condlog(2, "failed to create udev monitor");
+		err = 2;
 		goto out;
 	}
 #ifdef LIBUDEV_API_RECVBUF
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 762595a..e5fdfcc 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -13,6 +13,8 @@
 #define NETLINK_KOBJECT_UEVENT		15
 #endif
 
+struct udev;
+
 struct uevent {
 	struct list_head node;
 	struct udev_device *udev;
@@ -27,7 +29,7 @@ struct uevent {
 int is_uevent_busy(void);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 
-int uevent_listen(void);
+int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
 		    void * trigger_data);
 int uevent_get_major(struct uevent *uev);
diff --git a/multipathd/main.c b/multipathd/main.c
index aa5a298..b41fc64 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -835,7 +835,7 @@ out:
 static void *
 ueventloop (void * ap)
 {
-	if (uevent_listen())
+	if (uevent_listen(udev))
 		condlog(0, "error starting uevent listener");
 
 	return NULL;
@@ -1658,7 +1658,7 @@ child (void * param)
 	/*
 	 * Start uevent listener early to catch events
 	 */
-	if ((rc = pthread_create(&uevent_thr, &misc_attr, ueventloop, vecs))) {
+	if ((rc = pthread_create(&uevent_thr, &misc_attr, ueventloop, udev))) {
 		condlog(0, "failed to create uevent thread: %d", rc);
 		exit(1);
 	}
-- 
1.7.12.4
