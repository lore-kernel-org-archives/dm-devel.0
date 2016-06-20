From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/26] libmultipath: add 'cmd' as argument for
	get_refwwid()
Date: Mon, 20 Jun 2016 10:08:56 +0200
Message-ID: <1466410153-23896-10-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds an 'cmd' argument to get_refwwid(). This allows
store_pathvec() to be simplified and avoids accesses to conf->cmd.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c  | 13 +++++++++----
 libmultipath/configure.h  |  3 ++-
 libmultipath/discovery.c  |  4 +---
 multipath/main.c          |  4 ++--
 multipathd/cli_handlers.c |  4 ++--
 multipathd/main.c         |  2 +-
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 44b2d2b..8c16e23 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -925,12 +925,14 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
  * 2 - blacklist
  */
 extern int
-get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
+get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
+	     vector pathvec, char **wwid)
 {
 	int ret = 1;
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
+	int flags = DI_SYSFS | DI_WWID;
 
 	if (!wwid)
 		return 1;
@@ -939,6 +941,9 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 	if (dev_type == DEV_NONE)
 		return 1;
 
+	if (cmd != CMD_REMOVE_WWID)
+		flags |= DI_BLACKLIST;
+
 	if (dev_type == DEV_DEVNODE) {
 		if (basenamecpy(dev, buff, FILE_NAME_SIZE) == 0) {
 			condlog(1, "basename failed for '%s' (%s)",
@@ -955,7 +960,7 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return 1;
 			}
 			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
-					     DI_SYSFS | DI_WWID, &pp);
+					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -987,7 +992,7 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return 1;
 			}
 			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
-					     DI_SYSFS | DI_WWID, &pp);
+					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1012,7 +1017,7 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 			return 1;
 		}
 		ret = store_pathinfo(pathvec, conf->hwtable, udevice,
-				     DI_SYSFS | DI_WWID, &pp);
+				     flags, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
 			if (ret == 1)
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 8d474ea..442c956 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -29,6 +29,7 @@ int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
-int get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid);
+int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
+		 vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 126a54f..6fc2e8f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -90,9 +90,7 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 		goto out;
 	}
 	pp->udev = udev_device_ref(udevice);
-	err = pathinfo(pp, hwtable,
-		       (conf->cmd == CMD_REMOVE_WWID)? flag :
-						       (flag | DI_BLACKLIST));
+	err = pathinfo(pp, hwtable, flag);
 	if (err)
 		goto out;
 
diff --git a/multipath/main.c b/multipath/main.c
index e16c6cc..bf2fd31 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -281,8 +281,8 @@ configure (void)
 	 * failing the translation is fatal (by policy)
 	 */
 	if (conf->dev) {
-		int failed = get_refwwid(conf->dev, conf->dev_type, pathvec,
-					 &refwwid);
+		int failed = get_refwwid(conf->cmd, conf->dev, conf->dev_type,
+					 pathvec, &refwwid);
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", conf->dev);
 			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index eaeaa74..05dcb41 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -708,8 +708,8 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 		if (!alias && !count) {
 			condlog(2, "%s: mapname not found for %d:%d",
 				param, major, minor);
-			rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec,
-								&refwwid);
+			rc = get_refwwid(CMD_NONE, param, DEV_DEVMAP,
+					 vecs->pathvec, &refwwid);
 			if (refwwid) {
 				if (coalesce_paths(vecs, NULL, refwwid, 0, 1))
 					condlog(2, "%s: coalesce_paths failed",
diff --git a/multipathd/main.c b/multipathd/main.c
index 036872c..6230798 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -484,7 +484,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 			return 1;
 		}
 	}
-	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
+	r = get_refwwid(CMD_NONE, dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
 		r = coalesce_paths(vecs, NULL, refwwid, 0, CMD_NONE);
-- 
2.6.6
