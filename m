From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipathd: use struct path as argument for
	event processing
Date: Mon, 30 Apr 2012 12:25:55 +0200
Message-ID: <1335781568-13299-5-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

ev_add/remove_path should be using struct path as the argument,
this makes transitioning to use libudev easier.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.h  |    2 +
 multipathd/cli_handlers.c |   39 ++++++++++++++---
 multipathd/main.c         |  100 ++++++++++++++++++++++-----------------------
 multipathd/main.h         |    4 +-
 4 files changed, 85 insertions(+), 60 deletions(-)

diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 1b4d437..c071026 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -24,6 +24,8 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
+struct config;
+
 int sysfs_get_dev (const char * dev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4c4295d..5cf5f4b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -8,6 +8,7 @@
 #include <structs_vec.h>
 #include <libdevmapper.h>
 #include <devmapper.h>
+#include <discovery.h>
 #include <config.h>
 #include <configure.h>
 #include <blacklist.h>
@@ -410,18 +411,37 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
+	struct path *pp;
 	int r;
 
 	condlog(2, "%s: add path (operator)", param);
 
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-	    param) > 0 || (r = ev_add_path(param, vecs)) == 2) {
-		*reply = strdup("blacklisted\n");
-		*len = strlen(*reply) + 1;
-		condlog(2, "%s: path blacklisted", param);
-		return 0;
+			   param) > 0)
+		goto blacklisted;
+
+	pp = find_path_by_dev(vecs->pathvec, param);
+	if (pp) {
+		condlog(2, "%s: path already in pathvec", param);
+		if (pp->mpp)
+			return 0;
+	} else {
+		pp = store_pathinfo(vecs->pathvec, conf->hwtable,
+				    param, DI_ALL);
+		if (!pp) {
+			condlog(0, "%s: failed to store path info", param);
+			return 1;
+		}
 	}
+	r = ev_add_path(pp, vecs);
+	if (r == 2)
+		goto blacklisted;
 	return r;
+blacklisted:
+	*reply = strdup("blacklisted\n");
+	*len = strlen(*reply) + 1;
+	condlog(2, "%s: path blacklisted", param);
+	return 0;
 }
 
 int
@@ -429,10 +449,15 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
+	struct path *pp;
 
 	condlog(2, "%s: remove path (operator)", param);
-
-	return ev_remove_path(param, vecs);
+	pp = find_path_by_dev(vecs->pathvec, param);
+	if (!pp) {
+		condlog(0, "%s: path already removed", param);
+		return 0;
+	}
+	return ev_remove_path(pp, vecs);
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index 0667a2b..e87375c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -372,59 +372,59 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
-	condlog(2, "%s: add path (uevent)", uev->kernel);
-	return (ev_add_path(dev->kernel, vecs) != 1)? 0 : 1;
-}
-
-/*
- * returns:
- * 0: added
- * 1: error
- * 2: blacklisted
- */
-int
-ev_add_path (char * devname, struct vectors * vecs)
-{
-	struct multipath * mpp;
-	struct path * pp;
-	char empty_buff[WWID_SIZE] = {0};
-	char params[PARAMS_SIZE] = {0};
-	int retries = 3;
-	int start_waiter = 0;
+	struct path *pp;
 
-	if (strstr(devname, "..") != NULL) {
+	condlog(2, "%s: add path (uevent)", uev->kernel);
+	if (strstr(uev->kernel, "..") != NULL) {
 		/*
 		 * Don't allow relative device names in the pathvec
 		 */
-		condlog(0, "%s: path name is invalid", devname);
+		condlog(0, "%s: path name is invalid", uev->kernel);
 		return 1;
 	}
 
-	pp = find_path_by_dev(vecs->pathvec, devname);
-
+	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		condlog(0, "%s: spurious uevent, path already in pathvec",
-			devname);
+			uev->kernel);
 		if (pp->mpp)
 			return 0;
-	}
-	else {
+	} else {
 		/*
 		 * get path vital state
 		 */
 		if (!(pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-		      devname, DI_ALL))) {
-			condlog(0, "%s: failed to store path info", devname);
+					  uev->kernel, DI_ALL))) {
+			condlog(0, "%s: failed to store path info",
+				uev->kernel);
 			return 1;
 		}
 		pp->checkint = conf->checkint;
 	}
 
+	return (ev_add_path(pp, vecs) != 1)? 0 : 1;
+}
+
+/*
+ * returns:
+ * 0: added
+ * 1: error
+ * 2: blacklisted
+ */
+int
+ev_add_path (struct path * pp, struct vectors * vecs)
+{
+	struct multipath * mpp;
+	char empty_buff[WWID_SIZE] = {0};
+	char params[PARAMS_SIZE] = {0};
+	int retries = 3;
+	int start_waiter = 0;
+
 	/*
 	 * need path UID to go any further
 	 */
 	if (memcmp(empty_buff, pp->wwid, WWID_SIZE) == 0) {
-		condlog(0, "%s: failed to get path uid", devname);
+		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
 	if (filter_path(conf, pp) > 0){
@@ -441,11 +441,11 @@ rescan:
 			if (!pp->size)
 				condlog(0, "%s: failed to add new path %s, "
 					"device size is 0",
-					devname, pp->dev);
+					mpp->alias, pp->dev);
 			else
 				condlog(0, "%s: failed to add new path %s, "
 					"device size mismatch",
-					devname, pp->dev);
+					mpp->alias, pp->dev);
 			int i = find_slot(vecs->pathvec, (void *)pp);
 			if (i != -1)
 				vector_del_slot(vecs->pathvec, i);
@@ -465,7 +465,7 @@ rescan:
 	else {
 		if (!pp->size) {
 			condlog(0, "%s: failed to create new map,"
-				" %s device size is 0 ", devname, pp->dev);
+				" device size is 0 ", pp->dev);
 			int i = find_slot(vecs->pathvec, (void *)pp);
 			if (i != -1)
 				vector_del_slot(vecs->pathvec, i);
@@ -494,7 +494,7 @@ rescan:
 	 */
 	if (setup_map(mpp, params, PARAMS_SIZE)) {
 		condlog(0, "%s: failed to setup map for addition of new "
-			"path %s", mpp->alias, devname);
+			"path %s", mpp->alias, pp->dev);
 		goto fail_map;
 	}
 	/*
@@ -502,7 +502,7 @@ rescan:
 	 */
 	if (domap(mpp, params) <= 0) {
 		condlog(0, "%s: failed in domap for addition of new "
-			"path %s", mpp->alias, devname);
+			"path %s", mpp->alias, pp->dev);
 		/*
 		 * deal with asynchronous uevents :((
 		 */
@@ -533,7 +533,7 @@ rescan:
 			goto fail_map;
 
 	if (retries >= 0) {
-		condlog(2, "%s path added to devmap %s", devname, mpp->alias);
+		condlog(2, "%s path added to devmap %s", pp->dev, mpp->alias);
 		return 0;
 	}
 	else
@@ -549,28 +549,27 @@ fail:
 static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
-	int retval;
+	struct path *pp;
 
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
-	return ev_remove_path(uev->kernel, vecs);
+	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+
+	if (!pp) {
+		/* Not an error; path might have been purged earlier */
+		condlog(0, "%s: path already removed", uev->kernel);
+		return 0;
+	}
+
+	return ev_remove_path(pp, vecs);
 }
 
 int
-ev_remove_path (char * devname, struct vectors * vecs)
+ev_remove_path (struct path *pp, struct vectors * vecs)
 {
 	struct multipath * mpp;
-	struct path * pp;
 	int i, retval = 0;
 	char params[PARAMS_SIZE] = {0};
 
-	pp = find_path_by_dev(vecs->pathvec, devname);
-
-	if (!pp) {
-		/* Not an error; path might have been purged earlier */
-		condlog(0, "%s: path already removed", devname);
-		return 0;
-	}
-
 	/*
 	 * avoid referring to the map of an orphaned path
 	 */
@@ -618,8 +617,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 
 		if (setup_map(mpp, params, PARAMS_SIZE)) {
 			condlog(0, "%s: failed to setup map for"
-				" removal of path %s", mpp->alias,
-				devname);
+				" removal of path %s", mpp->alias, pp->dev);
 			goto fail;
 		}
 		/*
@@ -629,7 +627,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 		if (domap(mpp, params) <= 0) {
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
-				mpp->alias, devname);
+				mpp->alias, pp->dev);
 			retval = 1;
 		} else {
 			/*
@@ -641,7 +639,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 			sync_map_state(mpp);
 
 			condlog(2, "%s: path removed from map %s",
-				devname, mpp->alias);
+				pp->dev, mpp->alias);
 		}
 	}
 
diff --git a/multipathd/main.h b/multipathd/main.h
index 0733299..242f5e1 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -19,8 +19,8 @@ extern pid_t daemon_pid;
 int exit_daemon(int);
 const char * daemon_status(void);
 int reconfigure (struct vectors *);
-int ev_add_path (char *, struct vectors *);
-int ev_remove_path (char *, struct vectors *);
+int ev_add_path (struct path *, struct vectors *);
+int ev_remove_path (struct path *, struct vectors *);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
-- 
1.6.0.2
