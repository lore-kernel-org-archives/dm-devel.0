From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH RFC 2/3] multipath-tools: add flags to path
	struct to track internel state
Date: Fri, 21 Jul 2017 13:07:31 +0800
Message-ID: <1500613652-9084-3-git-send-email-guanjunxiong@huawei.com>
References: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
List-Id: dm-devel.ids

The flags which will be used in the next patch indicates the internel
state of the path such as whether the wwid of the path is referenced
by another path. With this flag, we can avoid overflow of getting wwid
of a certain path by recurring method in the next patch.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/discovery.c |  5 ++++-
 libmultipath/discovery.h | 11 ++++++++++-
 libmultipath/structs.h   |  1 +
 multipathd/main.c        |  4 ++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f46b9b17..1d3f591e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -34,7 +34,8 @@
 
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			  char *wwid, int flag, struct path **pp_ptr)
+			  char *wwid, int flag, struct path **pp_ptr,
+			  int path_flag)
 {
 	int err = PATHINFO_FAILED;
 	struct path * pp;
@@ -52,6 +53,8 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
+	pp->flags = path_flag;
+
 	if(wwid)
 		strncpy(pp->wwid, wwid, sizeof(pp->wwid));
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 51c23d6f..53120501 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -38,7 +38,8 @@ int get_state (struct path * pp, struct config * conf, int daemon);
 int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			      char *wwid, int flag, struct path **pp_ptr);
+			      char *wwid, int flag, struct path **pp_ptr,
+			      int path_flag);
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
@@ -73,5 +74,13 @@ enum discovery_mode {
 
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
+/*
+ * internal path flag bitmask
+ */
+enum pathflag_mode {
+	__PATHFLAG_UID_TO_BE_REFERENCED,
+};
+
+#define PATHFLAG_UID_TO_BE_REFERENCED (1 << __PATHFLAG_UID_TO_BE_REFERENCED)
 
 #endif /* DISCOVERY_H */
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 01e031ad..0d2bc40d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -235,6 +235,7 @@ struct path {
 	time_t dis_reinstate_time;
 	int disable_reinstate;
 	int san_path_err_forget_rate;
+	int flags;
 	/* configlet pointers */
 	struct hwentry * hwe;
 };
diff --git a/multipathd/main.c b/multipathd/main.c
index 4be2c579..25b2b363 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -667,7 +667,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	 */
 	conf = get_multipath_config();
 	ret = alloc_path_with_pathinfo(conf, uev->udev,
-				       uev->wwid, DI_ALL, &pp);
+				       uev->wwid, DI_ALL, &pp, 0);
 	put_multipath_config(conf);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
@@ -1033,7 +1033,7 @@ out:
 			int flag = DI_SYSFS | DI_WWID;
 
 			conf = get_multipath_config();
-			retval = alloc_path_with_pathinfo(conf, uev->udev, uev->wwid, flag, NULL);
+			retval = alloc_path_with_pathinfo(conf, uev->udev, uev->wwid, flag, NULL, 0);
 			put_multipath_config(conf);
 
 			if (retval == PATHINFO_SKIPPED) {
-- 
2.11.1
