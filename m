From: mwilck@suse.com
Subject: [PATCH 51/54] libmultipath: get_refwwid(): use switch
	statement
Date: Thu,  9 Jul 2020 12:36:20 +0200
Message-ID: <20200709103623.8302-10-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This code calls for a switch. Some additional compaction is possible by
observing that the code for DEV_DEVNODE, DEV_DEVT, and DEV_UEVENT is almost
the same, and factoring it out into a "common" section. Doing this with
a goto inside the switch statement is a bit unusual, but shows the intention
of the code more clearly than other variants I tried.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 81 ++++++++++++----------------------------
 1 file changed, 24 insertions(+), 57 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e68494b..db9a255 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1351,6 +1351,7 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
+	struct udev_device *udevice;
 	int flags = DI_SYSFS | DI_WWID;
 
 	if (!wwid)
@@ -1363,45 +1364,31 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	if (cmd != CMD_REMOVE_WWID)
 		flags |= DI_BLACKLIST;
 
-	if (dev_type == DEV_DEVNODE) {
+	switch (dev_type) {
+	case DEV_DEVNODE:
 		if (basenamecpy(dev, buff, FILE_NAME_SIZE) == 0) {
 			condlog(1, "basename failed for '%s' (%s)",
 				dev, buff);
 			return PATHINFO_FAILED;
 		}
 
-		pp = find_path_by_dev(pathvec, buff);
-		if (!pp) {
-			struct udev_device *udevice =
-				get_udev_device(buff, dev_type);
+		/* dev is used in common code below */
+		dev = buff;
+		pp = find_path_by_dev(pathvec, dev);
+		goto common;
 
-			if (!udevice)
-				return PATHINFO_FAILED;
-
-			ret = store_pathinfo(pathvec, conf, udevice,
-					     flags, &pp);
-			udev_device_unref(udevice);
-			if (!pp) {
-				if (ret == PATHINFO_FAILED)
-					condlog(0, "%s: can't store path info",
-						dev);
-				return ret;
-			}
-		}
-		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			return PATHINFO_SKIPPED;
-
-		refwwid = pp->wwid;
-		goto out;
-	}
-
-	if (dev_type == DEV_DEVT) {
+	case DEV_DEVT:
 		strchop(dev);
 		pp = find_path_by_devt(pathvec, dev);
+		goto common;
+
+	case DEV_UEVENT:
+		pp = NULL;
+		/* For condlog below, dev is unused in get_udev_device() */
+		dev = "environment";
+	common:
 		if (!pp) {
-			struct udev_device *udevice =
-				get_udev_device(dev, dev_type);
+			udevice = get_udev_device(dev, dev_type);
 
 			if (!udevice) {
 				condlog(0, "%s: cannot find block device", dev);
@@ -1413,8 +1400,8 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == PATHINFO_FAILED)
-					condlog(0, "%s can't store path info",
-						buff);
+					condlog(0, "%s: can't store path info",
+						dev);
 				return ret;
 			}
 		}
@@ -1422,32 +1409,9 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
 			return PATHINFO_SKIPPED;
 		refwwid = pp->wwid;
-		goto out;
-	}
-
-	if (dev_type == DEV_UEVENT) {
-		struct udev_device *udevice = get_udev_device(dev, dev_type);
-
-		if (!udevice)
-			return PATHINFO_FAILED;
-
-		ret = store_pathinfo(pathvec, conf, udevice,
-				     flags, &pp);
-		udev_device_unref(udevice);
-		if (!pp) {
-			if (ret == PATHINFO_FAILED)
-				condlog(0, "%s: can't store path info", dev);
-			return ret;
-		}
-		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			return PATHINFO_SKIPPED;
-		refwwid = pp->wwid;
-		goto out;
-	}
-
-	if (dev_type == DEV_DEVMAP) {
+		break;
 
+	case DEV_DEVMAP:
 		if (((dm_get_uuid(dev, tmpwwid, WWID_SIZE)) == 0)
 		    && (strlen(tmpwwid)))
 			refwwid = tmpwwid;
@@ -1470,8 +1434,11 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		    filter_wwid(conf->blist_wwid, conf->elist_wwid, refwwid,
 				NULL) > 0)
 			return PATHINFO_SKIPPED;
+		break;
+	default:
+		break;
 	}
-out:
+
 	if (refwwid && strlen(refwwid)) {
 		*wwid = STRDUP(refwwid);
 		return PATHINFO_OK;
-- 
2.26.2
