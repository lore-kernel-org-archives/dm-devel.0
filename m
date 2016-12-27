From: tang.junhui@zte.com.cn
Subject: [PATCH 07/12] multipathd: move calling filter_devnode()
	from uev_trigger() to uevent_can_discard()
Date: Tue, 27 Dec 2016 16:03:24 +0800
Message-ID: <1482825809-9528-8-git-send-email-tang.junhui@zte.com.cn>
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

Move calling filter_devnode() from uev_trigger() to uevent_can_discard()
since they do the similar work.

Change-Id: I0322443fa551b21aa3211bf1ce3fad7d37aeeab4
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 25 +++++++++++++++++++++++--
 multipathd/main.c     |  9 ---------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index ac49cac..cc10d65 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -47,6 +47,9 @@
 #include "list.h"
 #include "uevent.h"
 #include "vector.h"
+#include "structs.h"
+#include "config.h"
+#include "blacklist.h"
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
@@ -82,10 +85,11 @@ struct uevent * alloc_uevent (void)
 }
 
 bool
-uevent_can_discard(char *devpath)
+uevent_can_discard(char *devpath, char *kernel)
 {
 	char *tmp;
 	char a[11], b[11];
+	struct config * conf;
 
 	/*
 	 * keep only block devices, discard partitions
@@ -100,6 +104,23 @@ uevent_can_discard(char *devpath)
 		condlog(4, "discard event on %s", devpath);
 		return true;
 	}
+
+	/* 
+	 * do not filter dm devices by devnode
+	 */
+	if (!strncmp(kernel, "dm-", 3))
+		return false;
+	/* 
+	 * filter paths devices by devnode
+	 */
+	conf = get_multipath_config();
+	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
+			   kernel) > 0) {
+		put_multipath_config(conf);
+		return true;
+	}
+	put_multipath_config(conf);
+
 	return false;
 }
 
@@ -550,7 +571,7 @@ int uevent_listen(struct udev *udev)
 			uev = uevent_from_udev_device(dev);
 			if (!uev)
 				continue;
-			if (uevent_can_discard(uev->devpath)) {
+			if (uevent_can_discard(uev->devpath, uev->kernel)) {
 				 udev_device_unref(uev->udev);
 				 FREE(uev);
 				 continue;
diff --git a/multipathd/main.c b/multipathd/main.c
index 51f7b60..15a6175 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1092,7 +1092,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
 	struct vectors * vecs;
-	struct config *conf;
 
 	vecs = (struct vectors *)trigger_data;
 
@@ -1126,14 +1125,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	/*
 	 * path add/remove event
 	 */
-	conf = get_multipath_config();
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0) {
-		put_multipath_config(conf);
-		goto out;
-	}
-	put_multipath_config(conf);
-
 	if (!strncmp(uev->action, "add", 3)) {
 		r = uev_add_path(uev, vecs, 1);
 		goto out;
-- 
2.8.1.windows.1
