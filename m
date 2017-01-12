From: tang.junhui@zte.com.cn
Subject: [PATCH 06/11] multipathd: move uev_discard() to uevent.c
	and change its name to uevent_can_discard()
Date: Thu, 12 Jan 2017 13:52:22 +0800
Message-ID: <1484200347-11188-7-git-send-email-tang.junhui@zte.com.cn>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

This patch is mainly done to adjust the code for the preparation of
uevents merging.

Change-Id: Iaac159ffe3930e53c3325d1069c3ed497e440c0c
Signed-off-by: tang.wenjun <tang.wenjun3@zte.com.cn>
---
 libmultipath/uevent.c | 40 ++++++++++++++++++++++++++++++++++++++++
 multipathd/main.c     | 25 -------------------------
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 9b6b1d1..d6c02a6 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -24,6 +24,7 @@
 
 #include <unistd.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <stdlib.h>
 #include <stddef.h>
@@ -80,6 +81,44 @@ struct uevent * alloc_uevent (void)
 	return uev;
 }
 
+bool
+uevent_can_discard(struct uevent *uev)
+{
+	char *tmp;
+	char a[11], b[11];
+
+	/*
+	 * keep only block devices, discard partitions
+	 */
+	tmp = strstr(uev->devpath, "/block/");
+	if (tmp == NULL){
+		condlog(4, "no /block/ in '%s'", uev->devpath);
+		return true;
+	}
+	if (sscanf(tmp, "/block/%10s", a) != 1 ||
+	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
+		condlog(4, "discard event on %s", uev->devpath);
+		return true;
+	}
+
+	return false;
+}
+
+void
+uevent_discard(struct list_head *tmpq)
+{
+	struct uevent *uev, *tmp;
+
+	list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
+		if (uevent_can_discard(uev)) {
+			list_del_init(&uev->node);
+			if (uev->udev)
+				udev_device_unref(uev->udev);
+			FREE(uev);
+		}
+	}
+}
+
 void
 service_uevq(struct list_head *tmpq)
 {
@@ -144,6 +183,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		pthread_mutex_unlock(uevq_lockp);
 		if (!my_uev_trigger)
 			break;
+		uevent_discard(&uevq_tmp);
 		service_uevq(&uevq_tmp);
 	}
 	condlog(3, "Terminating uev service queue");
diff --git a/multipathd/main.c b/multipathd/main.c
index 718c5e7..66d5c3d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1115,28 +1115,6 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	return r;
 }
 
-static int
-uev_discard(char * devpath)
-{
-	char *tmp;
-	char a[11], b[11];
-
-	/*
-	 * keep only block devices, discard partitions
-	 */
-	tmp = strstr(devpath, "/block/");
-	if (tmp == NULL){
-		condlog(4, "no /block/ in '%s'", devpath);
-		return 1;
-	}
-	if (sscanf(tmp, "/block/%10s", a) != 1 ||
-	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
-		condlog(4, "discard event on %s", devpath);
-		return 1;
-	}
-	return 0;
-}
-
 int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
@@ -1146,9 +1124,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 
 	vecs = (struct vectors *)trigger_data;
 
-	if (uev_discard(uev->devpath))
-		return 0;
-
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
 	if (running_state != DAEMON_IDLE &&
-- 
2.8.1.windows.1
