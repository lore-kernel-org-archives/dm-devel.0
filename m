From: mwilck@suse.com
Subject: [PATCH 50/54] libmultipath: get_refwwid(): use symbolic
	return values
Date: Thu,  9 Jul 2020 12:36:19 +0200
Message-ID: <20200709103623.8302-9-mwilck@suse.com>
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

The return values of get_refwwid() are the same as those of pathinfo().
So use them.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index defc54b..e68494b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1354,11 +1354,11 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	int flags = DI_SYSFS | DI_WWID;
 
 	if (!wwid)
-		return 1;
+		return PATHINFO_FAILED;
 	*wwid = NULL;
 
 	if (dev_type == DEV_NONE)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (cmd != CMD_REMOVE_WWID)
 		flags |= DI_BLACKLIST;
@@ -1367,7 +1367,7 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		if (basenamecpy(dev, buff, FILE_NAME_SIZE) == 0) {
 			condlog(1, "basename failed for '%s' (%s)",
 				dev, buff);
-			return 1;
+			return PATHINFO_FAILED;
 		}
 
 		pp = find_path_by_dev(pathvec, buff);
@@ -1376,13 +1376,13 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				get_udev_device(buff, dev_type);
 
 			if (!udevice)
-				return 1;
+				return PATHINFO_FAILED;
 
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
-				if (ret == 1)
+				if (ret == PATHINFO_FAILED)
 					condlog(0, "%s: can't store path info",
 						dev);
 				return ret;
@@ -1390,7 +1390,7 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		}
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			return 2;
+			return PATHINFO_SKIPPED;
 
 		refwwid = pp->wwid;
 		goto out;
@@ -1405,14 +1405,14 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 
 			if (!udevice) {
 				condlog(0, "%s: cannot find block device", dev);
-				return 1;
+				return PATHINFO_FAILED;
 			}
 
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
-				if (ret == 1)
+				if (ret == PATHINFO_FAILED)
 					condlog(0, "%s can't store path info",
 						buff);
 				return ret;
@@ -1420,7 +1420,7 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		}
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			return 2;
+			return PATHINFO_SKIPPED;
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -1429,19 +1429,19 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		struct udev_device *udevice = get_udev_device(dev, dev_type);
 
 		if (!udevice)
-			return 1;
+			return PATHINFO_FAILED;
 
 		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
-			if (ret == 1)
+			if (ret == PATHINFO_FAILED)
 				condlog(0, "%s: can't store path info", dev);
 			return ret;
 		}
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			return 2;
+			return PATHINFO_SKIPPED;
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -1469,22 +1469,19 @@ static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		if (refwwid && strlen(refwwid) &&
 		    filter_wwid(conf->blist_wwid, conf->elist_wwid, refwwid,
 				NULL) > 0)
-			return 2;
+			return PATHINFO_SKIPPED;
 	}
 out:
 	if (refwwid && strlen(refwwid)) {
 		*wwid = STRDUP(refwwid);
-		return 0;
+		return PATHINFO_OK;
 	}
 
-	return 1;
+	return PATHINFO_FAILED;
 }
 
 /*
- * returns:
- * 0 - success
- * 1 - failure
- * 2 - blacklist
+ * Returns: PATHINFO_OK, PATHINFO_FAILED, or PATHINFO_SKIPPED (see pathinfo())
  */
 int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		vector pathvec, char **wwid)
-- 
2.26.2
