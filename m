From: tang.junhui@zte.com.cn
Subject: [PATCH 12/12] libmultipath: use existing wwid when wwid
	has already been existed in uevent
Date: Tue, 27 Dec 2016 16:03:29 +0800
Message-ID: <1482825809-9528-13-git-send-email-tang.junhui@zte.com.cn>
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

Use existing wwid when wwid has already been existed in uevent, it
avoids to get wwid again in pathinfo(), and reduces the count of calling
getuid(), which would promote processing efficiency.

Change-Id: Ia0c7273d33a220e5b415ec42d6b72660018cf4d9
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/discovery.c | 9 ++++++---
 libmultipath/discovery.h | 4 +++-
 multipathd/main.c        | 4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d1aec31..4985e03 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -32,7 +32,7 @@
 #include "defaults.h"
 
 int
-alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
+alloc_path_with_pathinfo (struct config *conf, struct uevent *uev,
 			  int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
@@ -42,7 +42,7 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (pp_ptr)
 		*pp_ptr = NULL;
 
-	devname = udev_device_get_sysname(udevice);
+	devname = udev_device_get_sysname(uev->udev);
 	if (!devname)
 		return PATHINFO_FAILED;
 
@@ -51,10 +51,13 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
+	if(uev->wwid)
+		strncpy(pp->wwid, uev->wwid, sizeof(pp->wwid));
+
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
 	} else {
-		pp->udev = udev_device_ref(udevice);
+		pp->udev = udev_device_ref(uev->udev);
 		err = pathinfo(pp, conf, flag | DI_BLACKLIST);
 	}
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 3039268..df7de0f 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -1,6 +1,8 @@
 #ifndef DISCOVERY_H
 #define DISCOVERY_H
 
+#include "uevent.h"
+
 #define SYSFS_PATH_SIZE 255
 #define INQUIRY_CMDLEN  6
 #define INQUIRY_CMD     0x12
@@ -36,7 +38,7 @@ int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon);
 int pathinfo (struct path * pp, struct config * conf, int mask);
-int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
+int alloc_path_with_pathinfo (struct config *conf, struct uevent *uev,
 			      int flag, struct path **pp_ptr);
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
diff --git a/multipathd/main.c b/multipathd/main.c
index 0b18f6c..7a1cd09 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -664,7 +664,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	 * get path vital state
 	 */
 	conf = get_multipath_config();
-	ret = alloc_path_with_pathinfo(conf, uev->udev,
+	ret = alloc_path_with_pathinfo(conf, uev,
 				       DI_ALL, &pp);
 	put_multipath_config(conf);
 	if (!pp) {
@@ -1026,7 +1026,7 @@ out:
 			int flag = DI_SYSFS | DI_WWID;
 
 			conf = get_multipath_config();
-			retval = alloc_path_with_pathinfo(conf, uev->udev, flag, NULL);
+			retval = alloc_path_with_pathinfo(conf, uev, flag, NULL);
 			put_multipath_config(conf);
 
 			if (retval == PATHINFO_SKIPPED) {
-- 
2.8.1.windows.1
