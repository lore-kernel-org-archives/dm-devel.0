From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 51/78] Rework uev_add_path()
Date: Mon, 16 Mar 2015 13:36:38 +0100
Message-ID: <1426509425-15978-52-git-send-email-hare@suse.de>
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

Rework uev_add_path() to handle failed and blacklisted
paths properly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   | 34 +++++++++++++++++++++++
 libmultipath/discovery.h   |  2 ++
 libmultipath/structs_vec.c |  3 +++
 multipathd/main.c          | 67 +++++++++++++++++++++++++++++-----------------
 4 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6ba14ac..b1db00f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -31,6 +31,40 @@
 #include "defaults.h"
 
 int
+alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
+			  int flag, struct path **pp_ptr)
+{
+	int err = PATHINFO_FAILED;
+	struct path * pp;
+	const char * devname;
+
+	if (pp_ptr)
+		*pp_ptr = NULL;
+
+	devname = udev_device_get_sysname(udevice);
+	if (!devname)
+		return PATHINFO_FAILED;
+
+	pp = alloc_path();
+
+	if (!pp)
+		return PATHINFO_FAILED;
+
+	if (safe_sprintf(pp->dev, "%s", devname)) {
+		condlog(0, "pp->dev too small");
+	} else {
+		pp->udev = udev_device_ref(udevice);
+		err = pathinfo(pp, hwtable, flag | DI_BLACKLIST);
+	}
+
+	if (err)
+		free_path(pp);
+	else if (pp_ptr)
+		*pp_ptr = pp;
+	return err;
+}
+
+int
 store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 		int flag, struct path **pp_ptr)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 7e5680e..da7652c 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -36,6 +36,8 @@ int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, int daemon);
 int pathinfo (struct path *, vector hwtable, int mask);
+int alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
+			      int flag, struct path **pp_ptr);
 int store_pathinfo (vector pathvec, vector hwtable,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6d2d45e..d9a731a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -459,6 +459,9 @@ add_map_with_path (struct vectors * vecs,
 {
 	struct multipath * mpp;
 
+	if (!strlen(pp->wwid))
+		return NULL;
+
 	if (!(mpp = alloc_multipath()))
 		return NULL;
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 0608f06..394bec4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -401,7 +401,7 @@ static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
-	int ret, i;
+	int ret = 0, i;
 
 	condlog(2, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
@@ -414,44 +414,63 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
+		int r;
+
 		condlog(0, "%s: spurious uevent, path already in pathvec",
 			uev->kernel);
-		if (pp->mpp)
-			return 0;
-		if (!strlen(pp->wwid)) {
+		if (!pp->mpp && !strlen(pp->wwid)) {
+			condlog(3, "%s: reinitialize path", uev->kernel);
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
-			ret = pathinfo(pp, conf->hwtable,
-				       DI_ALL | DI_BLACKLIST);
-			if (ret == 2) {
+			r = pathinfo(pp, conf->hwtable,
+				     DI_ALL | DI_BLACKLIST);
+			if (r == PATHINFO_OK)
+				ret = ev_add_path(pp, vecs);
+			else if (r == PATHINFO_SKIPPED) {
+				condlog(3, "%s: remove blacklisted path",
+					uev->kernel);
 				i = find_slot(vecs->pathvec, (void *)pp);
 				if (i != -1)
 					vector_del_slot(vecs->pathvec, i);
 				free_path(pp);
-				return 0;
-			} else if (ret == 1) {
+			} else {
 				condlog(0, "%s: failed to reinitialize path",
 					uev->kernel);
-				return 1;
+				ret = 1;
 			}
 		}
-	} else {
-		/*
-		 * get path vital state
-		 */
-		ret = store_pathinfo(vecs->pathvec, conf->hwtable,
-				     uev->udev, DI_ALL, &pp);
-		if (!pp) {
-			if (ret == 2)
-				return 0;
-			condlog(0, "%s: failed to store path info",
-				uev->kernel);
-			return 1;
-		}
+		return ret;
+	}
+
+	/*
+	 * get path vital state
+	 */
+	ret = alloc_path_with_pathinfo(conf->hwtable, uev->udev,
+				       DI_ALL, &pp);
+	if (!pp) {
+		if (ret == PATHINFO_SKIPPED)
+			return 0;
+		condlog(3, "%s: failed to get path info", uev->kernel);
+		return 1;
+	}
+	if (!strlen(pp->wwid)) {
+		condlog(3, "%s: Failed to get path wwid", uev->kernel);
+		free_path(pp);
+		return 1;
+	}
+	ret = store_path(vecs->pathvec, pp);
+	if (!ret) {
 		pp->checkint = conf->checkint;
+		ret = ev_add_path(pp, vecs);
+	} else {
+		condlog(0, "%s: failed to store path info, "
+			"dropping event",
+			uev->kernel);
+		free_path(pp);
+		ret = 1;
 	}
 
-	return ev_add_path(pp, vecs);
+	return ret;
 }
 
 /*
-- 
1.8.4.5
