From: mwilck@suse.com
Subject: [PATCH 48/54] libmultipath: get_refwwid(): call
	get_multipath_config() only once
Date: Thu,  9 Jul 2020 12:36:17 +0200
Message-ID: <20200709103623.8302-7-mwilck@suse.com>
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

rather than 7 times in a single function. In get_refwwid(), the code that
is not run under the RCU read lock is negligible, so we might as well
keep the lock.

The "invalid" variable becomes obsolete by this change.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 60 ++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 39 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e8d6db8..c4712d7 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1344,22 +1344,14 @@ struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type)
 	return ud;
 }
 
-/*
- * returns:
- * 0 - success
- * 1 - failure
- * 2 - blacklist
- */
-int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
-		vector pathvec, char **wwid)
+static int _get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
+			vector pathvec, struct config *conf, char **wwid)
 {
 	int ret = 1;
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
 	int flags = DI_SYSFS | DI_WWID;
-	struct config *conf;
-	int invalid = 0;
 
 	if (!wwid)
 		return 1;
@@ -1386,11 +1378,8 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			if (!udevice)
 				return 1;
 
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
-			pthread_cleanup_pop(1);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1399,13 +1388,8 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				return ret;
 			}
 		}
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			invalid = 1;
-		pthread_cleanup_pop(1);
-		if (invalid)
 			return 2;
 
 		refwwid = pp->wwid;
@@ -1424,11 +1408,8 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				return 1;
 			}
 
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
-			pthread_cleanup_pop(1);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1437,13 +1418,8 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				return ret;
 			}
 		}
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			invalid = 1;
-		pthread_cleanup_pop(1);
-		if (invalid)
 			return 2;
 		refwwid = pp->wwid;
 		goto out;
@@ -1455,24 +1431,16 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		if (!udevice)
 			return 1;
 
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
-		pthread_cleanup_pop(1);
 		udev_device_unref(udevice);
 		if (!pp) {
 			if (ret == 1)
 				condlog(0, "%s: can't store path info", dev);
 			return ret;
 		}
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
 		    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-			invalid = 1;
-		pthread_cleanup_pop(1);
-		if (invalid)
 			return 2;
 		refwwid = pp->wwid;
 		goto out;
@@ -1480,8 +1448,6 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 
 	if (dev_type == DEV_DEVMAP) {
 
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		if (((dm_get_uuid(dev, tmpwwid, WWID_SIZE)) == 0)
 		    && (strlen(tmpwwid))) {
 			refwwid = tmpwwid;
@@ -1512,9 +1478,6 @@ check:
 		if (refwwid && strlen(refwwid) &&
 		    filter_wwid(conf->blist_wwid, conf->elist_wwid, refwwid,
 				NULL) > 0)
-			invalid = 1;
-		pthread_cleanup_pop(1);
-		if (invalid)
 			return 2;
 	}
 out:
@@ -1526,6 +1489,25 @@ out:
 	return 1;
 }
 
+/*
+ * returns:
+ * 0 - success
+ * 1 - failure
+ * 2 - blacklist
+ */
+int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
+		vector pathvec, char **wwid)
+
+{
+	int ret;
+	struct config *conf = get_multipath_config();
+
+	pthread_cleanup_push(put_multipath_config, conf);
+	ret = _get_refwwid(cmd, dev, dev_type, pathvec, conf, wwid);
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	       int is_daemon)
 {
-- 
2.26.2
