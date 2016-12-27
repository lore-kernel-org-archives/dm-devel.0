From: tang.junhui@zte.com.cn
Subject: [PATCH 06/12] multipathd: move uev_discard() to uevent.c
	and change its name to uevent_can_discard()
Date: Tue, 27 Dec 2016 16:03:23 +0800
Message-ID: <1482825809-9528-7-git-send-email-tang.junhui@zte.com.cn>
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

Move uev_discard() form uevent processing thread to uevent listening
thread to discard unnecessary uevents as soon as possible.

Change-Id: Iaac159ffe3930e53c3325d1069c3ed497e440c0c
Signed-off-by: tang.wenjun <tang.wenjun3@zte.com.cn>
---
 libmultipath/uevent.c | 28 ++++++++++++++++++++++++++++
 multipathd/main.c     | 25 -------------------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 181b3b8..ac49cac 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -24,6 +24,7 @@
 
 #include <unistd.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <stdlib.h>
 #include <stddef.h>
@@ -80,6 +81,28 @@ struct uevent * alloc_uevent (void)
 	return uev;
 }
 
+bool
+uevent_can_discard(char *devpath)
+{
+	char *tmp;
+	char a[11], b[11];
+
+	/*
+	 * keep only block devices, discard partitions
+	 */
+	tmp = strstr(devpath, "/block/");
+	if (tmp == NULL){
+		condlog(4, "no /block/ in '%s'", devpath);
+		return true;
+	}
+	if (sscanf(tmp, "/block/%10s", a) != 1 ||
+	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
+		condlog(4, "discard event on %s", devpath);
+		return true;
+	}
+	return false;
+}
+
 void
 service_uevq(struct list_head *tmpq)
 {
@@ -527,6 +550,11 @@ int uevent_listen(struct udev *udev)
 			uev = uevent_from_udev_device(dev);
 			if (!uev)
 				continue;
+			if (uevent_can_discard(uev->devpath)) {
+				 udev_device_unref(uev->udev);
+				 FREE(uev);
+				 continue;
+			}
 			list_add_tail(&uev->node, &uevlisten_tmp);
 			events++;
 			continue;
diff --git a/multipathd/main.c b/multipathd/main.c
index 68c8e17..51f7b60 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1087,28 +1087,6 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
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
@@ -1118,9 +1096,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 
 	vecs = (struct vectors *)trigger_data;
 
-	if (uev_discard(uev->devpath))
-		return 0;
-
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
 	if (running_state != DAEMON_IDLE &&
-- 
2.8.1.windows.1
