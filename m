From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/78] discovery: do not fail discovery on
	individual devices
Date: Mon, 16 Mar 2015 13:35:52 +0100
Message-ID: <1426509425-15978-6-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

Any errors returned from individual devices during discovery do
not invalidate the entire discovery. So instead of returning
the pointless accumulated error count we should be returning
the number of devices which which could not be discovered or
the negative error number if the discovery itself failed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_persist.c | 14 ++++++-------
 libmultipath/discovery.c        | 46 ++++++++++++++++++++---------------------
 libmultipath/discovery.h        |  4 ++++
 multipath/main.c                |  2 +-
 multipathd/main.c               |  6 ++++--
 5 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 9f65ca6..d427c5b 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -178,7 +178,7 @@ int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
 		goto out;
 	}
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER) < 0) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
@@ -262,13 +262,13 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	curmp = vector_alloc ();
 	pathvec = vector_alloc ();
 
-	 if (!curmp || !pathvec){
-                condlog (0, "%s: vector allocation failed.", alias);
-                ret = MPATH_PR_DMMP_ERROR;
-                goto out;
-        }
+	if (!curmp || !pathvec){
+		condlog (0, "%s: vector allocation failed.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER) < 0) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 91eab74..3e0afc4 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -34,7 +34,7 @@ int
 store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 		int flag, struct path **pp_ptr)
 {
-	int err = 1;
+	int err = PATHINFO_FAILED;
 	struct path * pp;
 	const char * devname;
 
@@ -43,12 +43,12 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 
 	devname = udev_device_get_sysname(udevice);
 	if (!devname)
-		return 1;
+		return PATHINFO_FAILED;
 
 	pp = alloc_path();
 
 	if (!pp)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if(safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
@@ -82,22 +82,19 @@ path_discover (vector pathvec, struct config * conf,
 
 	devname = udev_device_get_sysname(udevice);
 	if (!devname)
-		return 0;
+		return PATHINFO_FAILED;
 
 	if (filter_property(conf, udevice) > 0)
-		return 0;
+		return PATHINFO_SKIPPED;
 
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
 			   (char *)devname) > 0)
-		return 0;
+		return PATHINFO_SKIPPED;
 
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
-		if (store_pathinfo(pathvec, conf->hwtable,
-				   udevice, flag, NULL) != 1)
-			return 0;
-		else
-			return 1;
+		return store_pathinfo(pathvec, conf->hwtable,
+				      udevice, flag, NULL);
 	}
 	return pathinfo(pp, conf->hwtable, flag);
 }
@@ -109,11 +106,11 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 	struct udev_list_entry *entry;
 	struct udev_device *udevice;
 	const char *devpath;
-	int r = 0;
+	int num_paths = 0, total_paths = 0;
 
 	udev_iter = udev_enumerate_new(conf->udev);
 	if (!udev_iter)
-		return 1;
+		return -ENOMEM;
 
 	udev_enumerate_add_match_subsystem(udev_iter, "block");
 	udev_enumerate_scan_devices(udev_iter);
@@ -126,19 +123,20 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 		udevice = udev_device_new_from_syspath(conf->udev, devpath);
 		if (!udevice) {
 			condlog(4, "%s: no udev information", devpath);
-			r++;
 			continue;
 		}
 		devtype = udev_device_get_devtype(udevice);
 		if(devtype && !strncmp(devtype, "disk", 4)) {
-			r += path_discover(pathvec, conf,
-						   udevice, flag);
+			total_paths++;
+			if (path_discover(pathvec, conf,
+					  udevice, flag) == PATHINFO_OK)
+				num_paths++;
 		}
 		udev_device_unref(udevice);
 	}
 	udev_enumerate_unref(udev_iter);
-	condlog(4, "Discovery status %d", r);
-	return r;
+	condlog(4, "Discovered %d/%d paths", num_paths, total_paths);
+	return (total_paths - num_paths);
 }
 
 #define declare_sysfs_get_str(fname)					\
@@ -1034,7 +1032,7 @@ get_state (struct path * pp, int daemon)
 
 	if (!checker_selected(c)) {
 		if (daemon) {
-			if (pathinfo(pp, conf->hwtable, DI_SYSFS) != 0) {
+			if (pathinfo(pp, conf->hwtable, DI_SYSFS) != PATHINFO_OK) {
 				condlog(3, "%s: couldn't get sysfs pathinfo",
 					pp->dev);
 				return PATH_UNCHECKED;
@@ -1168,7 +1166,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	int path_state;
 
 	if (!pp)
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
 
@@ -1176,12 +1174,12 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	 * fetch info available in sysfs
 	 */
 	if (mask & DI_SYSFS && sysfs_pathinfo(pp))
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		if (filter_device(conf->blist_device, conf->elist_device,
 				  pp->vendor_id, pp->product_id) > 0) {
-			return 2;
+			return PATHINFO_SKIPPED;
 		}
 	}
 
@@ -1234,7 +1232,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	if (mask & DI_BLACKLIST && mask & DI_WWID) {
 		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
 				pp->wwid) > 0) {
-			return 2;
+			return PATHINFO_SKIPPED;
 		}
 	}
 
@@ -1251,7 +1249,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	}
 
 	pp->initialized = 1;
-	return 0;
+	return PATHINFO_OK;
 
 blank:
 	/*
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 6f78918..f14fcee 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -24,6 +24,10 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
+#define PATHINFO_OK 0
+#define PATHINFO_FAILED 1
+#define PATHINFO_SKIPPED 2
+
 struct config;
 
 ssize_t sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
diff --git a/multipath/main.c b/multipath/main.c
index d085f64..dadbb2a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -343,7 +343,7 @@ configure (void)
 		/* maximum info */
 		di_flag = DI_ALL;
 
-	if (path_discovery(pathvec, conf, di_flag))
+	if (path_discovery(pathvec, conf, di_flag) < 0)
 		goto out;
 
 	if (conf->verbosity > 2)
diff --git a/multipathd/main.c b/multipathd/main.c
index 9667ba1..4f02211 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1409,7 +1409,7 @@ configure (struct vectors * vecs, int start_waiters)
 	struct multipath * mpp;
 	struct path * pp;
 	vector mpvec;
-	int i;
+	int i, ret;
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc()))
 		return 1;
@@ -1423,7 +1423,9 @@ configure (struct vectors * vecs, int start_waiters)
 	/*
 	 * probe for current path (from sysfs) and map (from dm) sets
 	 */
-	path_discovery(vecs->pathvec, conf, DI_ALL);
+	ret = path_discovery(vecs->pathvec, conf, DI_ALL);
+	if (ret < 0)
+		return 1;
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
 		if (filter_path(conf, pp) > 0){
-- 
1.8.4.5
