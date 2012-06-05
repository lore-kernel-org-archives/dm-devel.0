From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: libudev cleanup and bugfixes
Date: Tue, 5 Jun 2012 18:04:36 -0500
Message-ID: <20120605230436.GC12482@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

get_refwwid wasn't working anymore, since it wasn't setting the path's udevice. 
Also, cli_add_path was dereferencing a NULL pointer (pp). Finally, there were
a number of places where udev devices weren't getting dereferenced when they
should have been, causing memory leaks.  This patch cleans these up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c  |   42 +++++++++++++++++++-----------------------
 libmultipath/discovery.c  |   10 ++++++----
 libmultipath/uevent.c     |    1 +
 multipathd/cli_handlers.c |    8 +++++---
 multipathd/main.c         |    6 +-----
 5 files changed, 32 insertions(+), 35 deletions(-)

Index: multipath-tools-120518/libmultipath/configure.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/configure.c
+++ multipath-tools-120518/libmultipath/configure.c
@@ -13,6 +13,7 @@
 #include <sys/file.h>
 #include <errno.h>
 #include <libdevmapper.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -680,18 +681,17 @@ get_refwwid (char * dev, enum devtypes d
 
 		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
-			pp = alloc_path();
+			struct udev_device *udevice = udev_device_new_from_subsystem_sysname(conf->udev, "block", buff);
 
-			if (!pp)
+			if (!udevice) {
+				condlog(2, "%s: can't get udev device", buff);
 				return NULL;
-
-			strncpy(pp->dev, buff, FILE_NAME_SIZE);
-
-			if (pathinfo(pp, conf->hwtable, DI_SYSFS | DI_WWID))
-				return NULL;
-
-			if (store_path(pathvec, pp)) {
-				free_path(pp);
+			}
+			pp = store_pathinfo(pathvec, conf->hwtable, udevice,
+					    DI_SYSFS | DI_WWID);
+			udev_device_unref(udevice);
+			if (!pp) {
+				condlog(0, "%s can't store path info", buff);
 				return NULL;
 			}
 		}
@@ -703,21 +703,17 @@ get_refwwid (char * dev, enum devtypes d
 		strchop(dev);
 		pp = find_path_by_devt(pathvec, dev);
 		if (!pp) {
-			if (devt2devname(buff, FILE_NAME_SIZE, dev))
-				return NULL;
+			struct udev_device *udevice = udev_device_new_from_devnum(conf->udev, 'b', parse_devt(dev));
 
-			pp = alloc_path();
-
-			if (!pp)
-				return NULL;
-
-			strncpy(pp->dev, buff, FILE_NAME_SIZE);
-
-			if (pathinfo(pp, conf->hwtable, DI_SYSFS | DI_WWID))
+			if (!udevice) {
+				condlog(2, "%s: can't get udev device", dev);
 				return NULL;
-
-			if (store_path(pathvec, pp)) {
-				free_path(pp);
+			}
+			pp = store_pathinfo(pathvec, conf->hwtable, udevice,
+					    DI_SYSFS | DI_WWID);
+			udev_device_unref(udevice);
+			if (!pp) {
+				condlog(0, "%s can't store path info", buff);
 				return NULL;
 			}
 		}
Index: multipath-tools-120518/libmultipath/uevent.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/uevent.c
+++ multipath-tools-120518/libmultipath/uevent.c
@@ -443,6 +443,7 @@ int uevent_listen(void)
 
 		uev = alloc_uevent();
 		if (!uev) {
+			udev_device_unref(dev);
 			condlog(1, "lost uevent, oom");
 			continue;
 		}
Index: multipath-tools-120518/multipathd/cli_handlers.c
===================================================================
--- multipath-tools-120518.orig/multipathd/cli_handlers.c
+++ multipath-tools-120518/multipathd/cli_handlers.c
@@ -430,15 +430,17 @@ cli_add_path (void * v, char ** reply, i
 	} else {
 		struct udev_device *udevice;
 
-		udevice = udev_device_new_from_devnum(conf->udev, 'b',
-						      parse_devt(pp->dev_t));
+		udevice = udev_device_new_from_subsystem_sysname(conf->udev,
+								 "block",
+								 param);
 		pp = store_pathinfo(vecs->pathvec, conf->hwtable,
 				    udevice, DI_ALL);
+		udev_device_unref(udevice);
 		if (!pp) {
 			condlog(0, "%s: failed to store path info", param);
-			udev_device_unref(udevice);
 			return 1;
 		}
+		pp->checkint = conf->checkint;
 	}
 	r = ev_add_path(pp, vecs);
 	if (r == 2)
Index: multipath-tools-120518/libmultipath/discovery.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/discovery.c
+++ multipath-tools-120518/libmultipath/discovery.c
@@ -215,11 +215,11 @@ sysfs_get_tgt_nodename (struct path *pp,
 		const char *value;
 
 		value = udev_device_get_sysattr_value(tgtdev, "node_name");
+		udev_device_unref(tgtdev);
 		if (value) {
 			strncpy(node, value, NODE_NAME_SIZE);
 			return 0;
 		}
-		udev_device_unref(tgtdev);
 	}
 
 	/* Check for iSCSI */
@@ -234,15 +234,15 @@ sysfs_get_tgt_nodename (struct path *pp,
 	}
 	if (parent) {
 		tgtdev = udev_device_new_from_subsystem_sysname(conf->udev, "iscsi_session", targetid);
-		if (node) {
+		if (tgtdev) {
 			const char *value;
 
 			value = udev_device_get_sysattr_value(tgtdev, "targetname");
+			udev_device_unref(tgtdev);
 			if (value) {
 				strncpy(node, value, NODE_NAME_SIZE);
 				return 0;
 			}
-			udev_device_unref(tgtdev);
 		}
 	}
 	return 1;
@@ -288,7 +288,7 @@ sysfs_set_rport_tmo(struct multipath *mp
 						 value, 11) < 0)
 				condlog(0, "%s failed to set dev_loss_tmo",
 					mpp->alias);
-			return;
+			goto out;
 		}
 	}
 	if (mpp->fast_io_fail){
@@ -304,6 +304,8 @@ sysfs_set_rport_tmo(struct multipath *mp
 				mpp->alias);
 		}
 	}
+out:
+	udev_device_unref(rport_dev);
 }
 
 int
Index: multipath-tools-120518/multipathd/main.c
===================================================================
--- multipath-tools-120518.orig/multipathd/main.c
+++ multipath-tools-120518/multipathd/main.c
@@ -390,17 +390,13 @@ uev_add_path (struct uevent *uev, struct
 		if (pp->mpp)
 			return 0;
 	} else {
-		struct udev_device *udevice;
-
 		/*
 		 * get path vital state
 		 */
-		udevice = udev_device_ref(uev->udev);
 		if (!(pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-					  udevice, DI_ALL))) {
+					  uev->udev, DI_ALL))) {
 			condlog(0, "%s: failed to store path info",
 				uev->kernel);
-			udev_device_unref(udevice);
 			return 1;
 		}
 		pp->checkint = conf->checkint;
