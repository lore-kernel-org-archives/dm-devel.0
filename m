From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/26] libmultipath: drop 'daemon' configuration
	setting
Date: Mon, 20 Jun 2016 10:08:54 +0200
Message-ID: <1466410153-23896-8-git-send-email-hare@suse.de>
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

There is no need anymore to access the 'daemon' configuration setting
as all callers export the 'is_daemon' argument, so it can be removed
from the config structure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  2 +-
 libmultipath/config.h           |  1 -
 multipath/main.c                |  5 ++---
 multipathd/cli_handlers.c       |  6 +++---
 multipathd/main.c               | 18 ++++++++----------
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index ad6aec9..af2374f 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -395,7 +395,7 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
 		condlog(3, "status = %s", status);
-		disassemble_map (pathvec, params, mpp, conf->daemon);
+		disassemble_map (pathvec, params, mpp, 0);
 
 		/*
 		 * disassemble_map() can add new paths to pathvec.
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2acee25..51afd22 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -115,7 +115,6 @@ struct config {
 	int queue_without_daemon;
 	int ignore_wwids;
 	int checker_timeout;
-	int daemon;
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
diff --git a/multipath/main.c b/multipath/main.c
index 4b77023..7c35ce1 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -206,7 +206,7 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 		dm_get_status(mpp->alias, status);
 		condlog(3, "status = %s", status);
 
-		disassemble_map(pathvec, params, mpp, conf->daemon);
+		disassemble_map(pathvec, params, mpp, 0);
 
 		/*
 		 * disassemble_map() can add new paths to pathvec.
@@ -381,7 +381,7 @@ configure (void)
 	 * core logic entry point
 	 */
 	r = coalesce_paths(&vecs, NULL, refwwid,
-			   conf->force_reload, conf->daemon);
+			   conf->force_reload, 0);
 
 out:
 	if (refwwid)
@@ -604,7 +604,6 @@ main (int argc, char *argv[])
 			goto out;
 		}
 	}
-	conf->daemon = 0;
 	if (conf->dev_type == DEV_UEVENT) {
 		openlog("multipath", 0, LOG_DAEMON);
 		setlogmask(LOG_UPTO(conf->verbosity + 3));
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0ca0807..eaeaa74 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -711,7 +711,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 			rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec,
 								&refwwid);
 			if (refwwid) {
-				if (coalesce_paths(vecs, NULL, refwwid, 0, conf->daemon))
+				if (coalesce_paths(vecs, NULL, refwwid, 0, 1))
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
@@ -789,7 +789,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	return reload_map(vecs, mpp, 0, conf->daemon);
+	return reload_map(vecs, mpp, 0, 1);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
@@ -802,7 +802,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	update_mpp_paths(mpp, vecs->pathvec);
 	setup_map(mpp, params, PARAMS_SIZE);
 	mpp->action = ACT_RESIZE;
-	if (domap(mpp, params, conf->daemon) <= 0) {
+	if (domap(mpp, params, 1) <= 0) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
diff --git a/multipathd/main.c b/multipathd/main.c
index 22284f9..9568ae9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -379,7 +379,7 @@ retry:
 		retries = -1;
 		goto fail;
 	}
-	if (domap(mpp, params, conf->daemon) <= 0 && retries-- > 0) {
+	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
 		condlog(0, "%s: map_udate sleep", mpp->alias);
 		sleep(1);
 		goto retry;
@@ -487,7 +487,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
-		r = coalesce_paths(vecs, NULL, refwwid, 0, conf->daemon);
+		r = coalesce_paths(vecs, NULL, refwwid, 0, 1);
 		dm_lib_release();
 	}
 
@@ -724,7 +724,7 @@ rescan:
 	 * reload the map for the multipath mapped device
 	 */
 retry:
-	ret = domap(mpp, params, conf->daemon);
+	ret = domap(mpp, params, 1);
 	if (ret <= 0) {
 		if (ret < 0 && retries-- > 0) {
 			condlog(0, "%s: retry domap for addition of new "
@@ -866,7 +866,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 		 * reload the map
 		 */
 		mpp->action = ACT_RELOAD;
-		if (domap(mpp, params, conf->daemon) <= 0) {
+		if (domap(mpp, params, 1) <= 0) {
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
@@ -931,7 +931,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 			if (mpp) {
-				retval = reload_map(vecs, mpp, 0, conf->daemon);
+				retval = reload_map(vecs, mpp, 0, 1);
 
 				condlog(2, "%s: map %s reloaded (retval %d)",
 					uev->kernel, mpp->alias, retval);
@@ -1361,7 +1361,7 @@ int update_prio(struct path *pp, int refresh_all)
 
 int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 {
-	if (reload_map(vecs, mpp, refresh, conf->daemon))
+	if (reload_map(vecs, mpp, refresh, 1))
 		return 1;
 
 	dm_lib_release();
@@ -1452,7 +1452,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	/*
 	 * Synchronize with kernel state
 	 */
-	if (update_multipath_strings(pp->mpp, vecs->pathvec)) {
+	if (update_multipath_strings(pp->mpp, vecs->pathvec, 1)) {
 		condlog(1, "%s: Could not synchronize with kernel state",
 			pp->dev);
 		pp->dmstate = PSTATE_UNDEF;
@@ -1798,7 +1798,7 @@ configure (struct vectors * vecs, int start_waiters)
 	/*
 	 * create new set of maps & push changed ones into dm
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 1, conf->daemon))
+	if (coalesce_paths(vecs, mpvec, NULL, 1, 1))
 		return 1;
 
 	/*
@@ -1882,7 +1882,6 @@ reconfigure (struct vectors * vecs)
 		conf->verbosity = old->verbosity;
 		conf->bindings_read_only = old->bindings_read_only;
 		conf->ignore_new_devs = old->ignore_new_devs;
-		conf->daemon = 1;
 		configure(vecs, 1);
 		free_config(old);
 		retval = 0;
@@ -2161,7 +2160,6 @@ child (void * param)
 	setscheduler();
 	set_oom_adj();
 
-	conf->daemon = 1;
 	dm_udev_set_sync_support(0);
 #ifdef USE_SYSTEMD
 	envp = getenv("WATCHDOG_USEC");
-- 
2.6.6
