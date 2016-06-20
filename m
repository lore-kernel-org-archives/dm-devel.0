From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/26] libmultipath: use 'is_daemon' as argument
	for domap() etc
Date: Mon, 20 Jun 2016 10:08:53 +0200
Message-ID: <1466410153-23896-7-git-send-email-hare@suse.de>
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

Use 'is_daemon' as argument for domap() and coalesce_paths()
to avoid having to access struct config.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c   | 16 ++++++++--------
 libmultipath/configure.h   |  6 +++---
 libmultipath/structs_vec.c | 15 ++++++++-------
 libmultipath/structs_vec.h |  9 +++++----
 multipath/main.c           |  3 ++-
 multipathd/cli_handlers.c  |  6 +++---
 multipathd/main.c          | 14 +++++++-------
 7 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index f7cd110..d15d898 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -579,7 +579,7 @@ fail:
 #define DOMAP_DRY	3
 
 extern int
-domap (struct multipath * mpp, char * params)
+domap (struct multipath * mpp, char * params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 
@@ -655,7 +655,7 @@ domap (struct multipath * mpp, char * params)
 		 */
 		if (mpp->action == ACT_CREATE)
 			remember_wwid(mpp->wwid);
-		if (!conf->daemon) {
+		if (!is_daemon) {
 			/* multipath client mode */
 			dm_switchgroup(mpp->alias, mpp->bestpg);
 		} else  {
@@ -731,7 +731,7 @@ out:
 }
 
 extern int
-coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_reload)
+coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_reload, int is_daemon)
 {
 	int r = 1;
 	int k, i;
@@ -830,7 +830,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (mpp->action == ACT_UNDEF)
 			select_action(mpp, curmp, force_reload);
 
-		r = domap(mpp, params);
+		r = domap(mpp, params, is_daemon);
 
 		if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
 			condlog(3, "%s: domap (%u) failure "
@@ -848,7 +848,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (r == DOMAP_DRY)
 			continue;
 
-		if (!conf->daemon && !conf->allow_queueing && !check_daemon()) {
+		if (!is_daemon && !conf->allow_queueing && !check_daemon()) {
 			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
 				condlog(3, "%s: multipathd not running, unset "
@@ -873,7 +873,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			}
 		}
 
-		if (!conf->daemon && mpp->action != ACT_NOTHING)
+		if (!is_daemon && mpp->action != ACT_NOTHING)
 			print_multipath_topology(mpp, conf->verbosity);
 
 		if (newmp) {
@@ -1068,7 +1068,7 @@ out:
 	return 1;
 }
 
-extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
+extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon)
 {
 	char params[PARAMS_SIZE] = {0};
 	struct path *pp;
@@ -1091,7 +1091,7 @@ extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
 	}
 	select_action(mpp, vecs->mpvec, 1);
 
-	r = domap(mpp, params);
+	r = domap(mpp, params, is_daemon);
 	if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
 		condlog(3, "%s: domap (%u) failure "
 			"for reload map", mpp->alias, r);
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index f357d9a..c0338bf 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -25,9 +25,9 @@ enum actions {
 #define FLUSH_ALL 2
 
 int setup_map (struct multipath * mpp, char * params, int params_size );
-int domap (struct multipath * mpp, char * params);
+int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
-int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload);
+int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, int is_daemon);
 int get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid);
-int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh);
+int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 1b1a5f3..8e75504 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -247,7 +247,7 @@ extract_hwe_from_path(struct multipath * mpp)
 }
 
 static int
-update_multipath_table (struct multipath *mpp, vector pathvec)
+update_multipath_table (struct multipath *mpp, vector pathvec, int is_daemon)
 {
 	char params[PARAMS_SIZE] = {0};
 
@@ -259,7 +259,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec)
 		return 1;
 	}
 
-	if (disassemble_map(pathvec, params, mpp, conf->daemon)) {
+	if (disassemble_map(pathvec, params, mpp, is_daemon)) {
 		condlog(3, "%s: cannot disassemble map", mpp->alias);
 		return 1;
 	}
@@ -314,7 +314,7 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 }
 
 extern int
-update_multipath_strings (struct multipath *mpp, vector pathvec)
+update_multipath_strings (struct multipath *mpp, vector pathvec, int is_daemon)
 {
 	if (!mpp)
 		return 1;
@@ -326,7 +326,7 @@ update_multipath_strings (struct multipath *mpp, vector pathvec)
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
 
-	if (update_multipath_table(mpp, pathvec))
+	if (update_multipath_table(mpp, pathvec, is_daemon))
 		return 1;
 	sync_paths(mpp, pathvec);
 
@@ -365,7 +365,8 @@ set_no_path_retry(struct multipath *mpp)
 }
 
 extern int
-__setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
+__setup_multipath (struct vectors * vecs, struct multipath * mpp,
+		   int reset, int is_daemon)
 {
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
@@ -379,7 +380,7 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 		goto out;
 	}
 
-	if (update_multipath_strings(mpp, vecs->pathvec)) {
+	if (update_multipath_strings(mpp, vecs->pathvec, is_daemon)) {
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
@@ -548,7 +549,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 		return 2;
 	}
 
-	if (__setup_multipath(vecs, mpp, reset))
+	if (__setup_multipath(vecs, mpp, reset, 1))
 		return 1; /* mpp freed in setup_multipath */
 
 	/*
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 2e06beb..c8e78b5 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -22,10 +22,11 @@ void orphan_path (struct path * pp, const char *reason);
 int verify_paths(struct multipath * mpp, struct vectors * vecs);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
-		       int reset);
-#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
-int update_multipath_strings (struct multipath *mpp, vector pathvec);
-	
+		       int reset, int is_daemon);
+#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1, 1)
+int update_multipath_strings (struct multipath *mpp, vector pathvec,
+			      int is_daemon);
+
 void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
 void remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs, int purge_vec);
 void remove_maps (struct vectors * vecs);
diff --git a/multipath/main.c b/multipath/main.c
index 30710ea..4b77023 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -380,7 +380,8 @@ configure (void)
 	/*
 	 * core logic entry point
 	 */
-	r = coalesce_paths(&vecs, NULL, refwwid, conf->force_reload);
+	r = coalesce_paths(&vecs, NULL, refwwid,
+			   conf->force_reload, conf->daemon);
 
 out:
 	if (refwwid)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 52bcdaa..0ca0807 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -711,7 +711,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 			rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec,
 								&refwwid);
 			if (refwwid) {
-				if (coalesce_paths(vecs, NULL, refwwid, 0))
+				if (coalesce_paths(vecs, NULL, refwwid, 0, conf->daemon))
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
@@ -789,7 +789,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	return reload_map(vecs, mpp, 0);
+	return reload_map(vecs, mpp, 0, conf->daemon);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
@@ -802,7 +802,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	update_mpp_paths(mpp, vecs->pathvec);
 	setup_map(mpp, params, PARAMS_SIZE);
 	mpp->action = ACT_RESIZE;
-	if (domap(mpp, params) <= 0) {
+	if (domap(mpp, params, conf->daemon) <= 0) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
diff --git a/multipathd/main.c b/multipathd/main.c
index 8592982..22284f9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -379,7 +379,7 @@ retry:
 		retries = -1;
 		goto fail;
 	}
-	if (domap(mpp, params) <= 0 && retries-- > 0) {
+	if (domap(mpp, params, conf->daemon) <= 0 && retries-- > 0) {
 		condlog(0, "%s: map_udate sleep", mpp->alias);
 		sleep(1);
 		goto retry;
@@ -487,7 +487,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
-		r = coalesce_paths(vecs, NULL, refwwid, 0);
+		r = coalesce_paths(vecs, NULL, refwwid, 0, conf->daemon);
 		dm_lib_release();
 	}
 
@@ -724,7 +724,7 @@ rescan:
 	 * reload the map for the multipath mapped device
 	 */
 retry:
-	ret = domap(mpp, params);
+	ret = domap(mpp, params, conf->daemon);
 	if (ret <= 0) {
 		if (ret < 0 && retries-- > 0) {
 			condlog(0, "%s: retry domap for addition of new "
@@ -866,7 +866,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 		 * reload the map
 		 */
 		mpp->action = ACT_RELOAD;
-		if (domap(mpp, params) <= 0) {
+		if (domap(mpp, params, conf->daemon) <= 0) {
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
@@ -931,7 +931,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 			if (mpp) {
-				retval = reload_map(vecs, mpp, 0);
+				retval = reload_map(vecs, mpp, 0, conf->daemon);
 
 				condlog(2, "%s: map %s reloaded (retval %d)",
 					uev->kernel, mpp->alias, retval);
@@ -1361,7 +1361,7 @@ int update_prio(struct path *pp, int refresh_all)
 
 int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 {
-	if (reload_map(vecs, mpp, refresh))
+	if (reload_map(vecs, mpp, refresh, conf->daemon))
 		return 1;
 
 	dm_lib_release();
@@ -1798,7 +1798,7 @@ configure (struct vectors * vecs, int start_waiters)
 	/*
 	 * create new set of maps & push changed ones into dm
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 1))
+	if (coalesce_paths(vecs, mpvec, NULL, 1, conf->daemon))
 		return 1;
 
 	/*
-- 
2.6.6
