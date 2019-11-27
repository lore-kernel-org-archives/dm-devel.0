From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 3/5] libmultipath: drop mpp->nr_active field
Date: Wed, 27 Nov 2019 15:05:50 +0000
Message-ID: <20191127150604.31417-4-martin.wilck@suse.com>
References: <20191127150604.31417-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191127150604.31417-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The tracking of nr_active has turned out to be error prone and hard
to verify. Calculating it on the fly is a quick operation, so
do this rather than trying to track nr_active. Use a boolean
field instead to track whether a map is currently in recovery mode.

Moreover, clean up the recovery logic by making set_no_path_retry()
the place that checks the current configuration and state, sets
"queue_if_no_path" if necessary, and enters or leaves recovery
mode if necessary. This ensures that consistent logic is applied.

In the client handlers, we can't be sure that mpp->features is
up-to-date. Also, users that change the queuing mode expect that
the requested action is performed, regardless of state. Therefore,
transform set_no_path_retry() into __set_no_path_retry(), which takes
an additional parameter indicating whether the current state should
be checked, and set this parameter to false when calling the function
from the client handler code, true otherwise. Moreover, in the very
unlikely case mpp->features is NULL, don't assume that queuing is off,
just make no assumption about the current state.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  5 +--
 libmultipath/devmapper.c   |  2 +-
 libmultipath/io_err_stat.c |  4 +-
 libmultipath/print.c       |  5 ++-
 libmultipath/structs.c     | 19 +++++++++
 libmultipath/structs.h     |  4 +-
 libmultipath/structs_vec.c | 81 ++++++++++++++++++++++++++------------
 libmultipath/structs_vec.h |  4 +-
 multipathd/cli_handlers.c  | 41 ++++++++-----------
 multipathd/main.c          | 19 +++------
 10 files changed, 110 insertions(+), 74 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5ac7d903..c95848a0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -401,7 +401,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 			condlog(2, "%s: setting up map with %d/%d path checkers pending",
 				mpp->alias, n_pending, n_paths);
 	}
-	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 
 	/*
 	 * ponders each path group and determine highest prio pg
@@ -934,8 +933,8 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		}
 
 		sysfs_set_max_sectors_kb(mpp, 0);
-		if (is_daemon && mpp->ghost_delay > 0 && mpp->nr_active &&
-		    pathcount(mpp, PATH_GHOST) == mpp->nr_active)
+		if (is_daemon && mpp->ghost_delay > 0 && count_active_paths(mpp) &&
+		    pathcount(mpp, PATH_UP) == 0)
 			mpp->ghost_delay_tick = mpp->ghost_delay;
 		r = dm_addmap_create(mpp, params);
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index acf576aa..bed8ddc6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -403,7 +403,7 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
 	/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
 	return	(mpp->skip_kpartx == SKIP_KPARTX_ON ?
 		 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
-		((mpp->nr_active == 0 || mpp->ghost_delay_tick > 0)?
+		((count_active_paths(mpp) == 0 || mpp->ghost_delay_tick > 0) ?
 		 MPATH_UDEV_NO_PATHS_FLAG : 0) |
 		(reload && !mpp->force_udev_reload ?
 		 MPATH_UDEV_RELOAD_FLAG : 0);
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index dcc8690d..1b9cd6c0 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -383,7 +383,7 @@ int need_io_err_check(struct path *pp)
 
 	if (uatomic_read(&io_err_thread_running) == 0)
 		return 0;
-	if (pp->mpp->nr_active <= 0) {
+	if (count_active_paths(pp->mpp) <= 0) {
 		io_err_stat_log(2, "%s: recover path early", pp->dev);
 		goto recover;
 	}
@@ -481,7 +481,7 @@ static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
 		 */
 		path->tick = 1;
 
-	} else if (path->mpp && path->mpp->nr_active > 0) {
+	} else if (path->mpp && count_active_paths(path->mpp) > 0) {
 		io_err_stat_log(3, "%s: keep failing the dm path %s",
 				path->mpp->alias, path->dev);
 		path->io_err_pathfail_cnt = PATH_IO_ERR_WAITING_TO_CHECK;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b98e9bda..e1ef4d3f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -181,9 +181,10 @@ snprint_queueing (char * buff, size_t len, const struct multipath * mpp)
 		return snprintf(buff, len, "-");
 	else if (mpp->no_path_retry > 0) {
 		if (mpp->retry_tick > 0)
+
 			return snprintf(buff, len, "%i sec",
 					mpp->retry_tick);
-		else if (mpp->retry_tick == 0 && mpp->nr_active > 0)
+		else if (mpp->retry_tick == 0 && count_active_paths(mpp) > 0)
 			return snprintf(buff, len, "%i chk",
 					mpp->no_path_retry);
 		else
@@ -195,7 +196,7 @@ snprint_queueing (char * buff, size_t len, const struct multipath * mpp)
 static int
 snprint_nb_paths (char * buff, size_t len, const struct multipath * mpp)
 {
-	return snprint_int(buff, len, mpp->nr_active);
+	return snprint_int(buff, len, count_active_paths(mpp));
 }
 
 static int
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f420ee5c..cc931e4e 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -478,6 +478,25 @@ int pathcount(const struct multipath *mpp, int state)
 	return count;
 }
 
+int count_active_paths(const struct multipath *mpp)
+{
+	struct pathgroup *pgp;
+	struct path *pp;
+	int count = 0;
+	int i, j;
+
+	if (!mpp->pg)
+		return 0;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->state == PATH_UP || pp->state == PATH_GHOST)
+				count++;
+		}
+	}
+	return count;
+}
+
 int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
 {
 	int i, j;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 3665b89a..da4b6ca0 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -3,6 +3,7 @@
 
 #include <sys/types.h>
 #include <inttypes.h>
+#include <stdbool.h>
 
 #include "prio.h"
 #include "byteorder.h"
@@ -309,7 +310,6 @@ struct multipath {
 	int pgfailback;
 	int failback_tick;
 	int rr_weight;
-	int nr_active;     /* current available(= not known as failed) paths */
 	int no_path_retry; /* number of retries after all paths are down */
 	int retry_tick;    /* remaining times for retries */
 	int disable_queueing;
@@ -319,6 +319,7 @@ struct multipath {
 	int fast_io_fail;
 	int retain_hwhandler;
 	int deferred_remove;
+	bool in_recovery;
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
@@ -449,6 +450,7 @@ struct path * first_path (const struct multipath *mpp);
 
 int pathcountgr (const struct pathgroup *, int);
 int pathcount (const struct multipath *, int);
+int count_active_paths(const struct multipath *);
 int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fbe97662..3dbbaa0f 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -290,10 +290,15 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 	return 0;
 }
 
-void enter_recovery_mode(struct multipath *mpp)
+static void enter_recovery_mode(struct multipath *mpp)
 {
 	unsigned int checkint;
-	struct config *conf = get_multipath_config();
+	struct config *conf;
+
+	if (mpp->in_recovery || mpp->no_path_retry <= 0)
+		return;
+
+	conf = get_multipath_config();
 	checkint = conf->checkint;
 	put_multipath_config(conf);
 
@@ -302,37 +307,63 @@ void enter_recovery_mode(struct multipath *mpp)
 	 * meaning of +1: retry_tick may be decremented in checkerloop before
 	 * starting retry.
 	 */
+	mpp->in_recovery = true;
 	mpp->stat_queueing_timeouts++;
 	mpp->retry_tick = mpp->no_path_retry * checkint + 1;
 	condlog(1, "%s: Entering recovery mode: max_retries=%d",
 		mpp->alias, mpp->no_path_retry);
 }
 
-void set_no_path_retry(struct multipath *mpp)
+static void leave_recovery_mode(struct multipath *mpp)
+{
+	bool recovery = mpp->in_recovery;
+
+	mpp->in_recovery = false;
+	mpp->retry_tick = 0;
+
+	/*
+	 * in_recovery is only ever set if mpp->no_path_retry > 0
+	 * (see enter_recovery_mode()). But no_path_retry may have been
+	 * changed while the map was recovering, so test it here again.
+	 */
+	if (recovery && (mpp->no_path_retry == NO_PATH_RETRY_QUEUE ||
+			 mpp->no_path_retry > 0)) {
+		dm_queue_if_no_path(mpp->alias, 1);
+		condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
+		condlog(1, "%s: Recovered to normal mode", mpp->alias);
+	}
+}
+
+void __set_no_path_retry(struct multipath *mpp, bool check_features)
 {
-	char is_queueing = 0;
+	bool is_queueing;
 
-	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
-		is_queueing = 1;
+	check_features = check_features && mpp->features != NULL;
+	if (check_features)
+		is_queueing = strstr(mpp->features, "queue_if_no_path");
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		if (is_queueing)
+		if (!check_features || is_queueing)
 			dm_queue_if_no_path(mpp->alias, 0);
 		break;
 	case NO_PATH_RETRY_QUEUE:
-		if (!is_queueing)
+		if (!check_features || !is_queueing)
 			dm_queue_if_no_path(mpp->alias, 1);
 		break;
 	default:
-		if (mpp->nr_active > 0) {
-			mpp->retry_tick = 0;
-			if (!is_queueing)
+		if (count_active_paths(mpp) > 0) {
+			/*
+			 * If in_recovery is set, leave_recovery_mode() takes
+			 * care of dm_queue_if_no_path. Otherwise, do it here.
+			 */
+			if ((!check_features || !is_queueing) &&
+			    !mpp->in_recovery)
 				dm_queue_if_no_path(mpp->alias, 1);
-		} else if (is_queueing && mpp->retry_tick == 0)
+			leave_recovery_mode(mpp);
+		} else
 			enter_recovery_mode(mpp);
 		break;
 	}
@@ -480,25 +511,23 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
  */
 void update_queue_mode_del_path(struct multipath *mpp)
 {
-	if (--mpp->nr_active == 0) {
-		if (mpp->no_path_retry > 0)
-			enter_recovery_mode(mpp);
-		else if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
+	int active = count_active_paths(mpp);
+
+	if (active == 0) {
+		enter_recovery_mode(mpp);
+		if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
 			mpp->stat_map_failures++;
 	}
-	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
+	condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
 }
 
 void update_queue_mode_add_path(struct multipath *mpp)
 {
-	if (mpp->nr_active++ == 0 && mpp->no_path_retry > 0) {
-		/* come back to normal mode from retry mode */
-		mpp->retry_tick = 0;
-		dm_queue_if_no_path(mpp->alias, 1);
-		condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
-		condlog(1, "%s: Recovered to normal mode", mpp->alias);
-	}
-	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
+	int active = count_active_paths(mpp);
+
+	if (active > 0)
+		leave_recovery_mode(mpp);
+	condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
 }
 
 vector get_used_hwes(const struct _vector *pathvec)
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index d3219278..2a5e3d60 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -11,8 +11,8 @@ struct vectors {
 	vector mpvec;
 };
 
-void set_no_path_retry(struct multipath *mpp);
-void enter_recovery_mode(struct multipath *mpp);
+void __set_no_path_retry(struct multipath *mpp, bool check_features);
+#define set_no_path_retry(mpp) __set_no_path_retry(mpp, true)
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_paths(vector pathvec, struct multipath *mpp,
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 371b0a79..14447c3c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1024,16 +1024,16 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 	select_no_path_retry(conf, mpp);
 	pthread_cleanup_pop(1);
 
-	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
-		dm_queue_if_no_path(mpp->alias, 1);
-		if (mpp->no_path_retry > 0) {
-			if (mpp->nr_active > 0)
-				mpp->retry_tick = 0;
-			else
-				enter_recovery_mode(mpp);
-		}
-	}
+	/*
+	 * Don't call set_no_path_retry() for the NO_PATH_RETRY_FAIL case.
+	 * That would disable queueing when "restorequeueing" is called,
+	 * and the code never behaved that way. Users might not expect it.
+	 * In almost all cases, queueing will be disabled anyway when we
+	 * are here.
+	 */
+	if (mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+		__set_no_path_retry(mpp, false);
+
 	return 0;
 }
 
@@ -1051,16 +1051,9 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 		pthread_cleanup_push(put_multipath_config, conf);
 		select_no_path_retry(conf, mpp);
 		pthread_cleanup_pop(1);
-		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
-			dm_queue_if_no_path(mpp->alias, 1);
-			if (mpp->no_path_retry > 0) {
-				if (mpp->nr_active > 0)
-					mpp->retry_tick = 0;
-				else
-					enter_recovery_mode(mpp);
-			}
-		}
+		/* See comment in cli_restore_queueing() */
+		if (mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+			__set_no_path_retry(mpp, false);
 	}
 	return 0;
 }
@@ -1085,12 +1078,12 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	if (mpp->nr_active == 0)
+	if (count_active_paths(mpp) == 0)
 		mpp->stat_map_failures++;
 	mpp->retry_tick = 0;
 	mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 	mpp->disable_queueing = 1;
-	dm_queue_if_no_path(mpp->alias, 0);
+	__set_no_path_retry(mpp, false);
 	return 0;
 }
 
@@ -1103,12 +1096,12 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 
 	condlog(2, "disable queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (mpp->nr_active == 0)
+		if (count_active_paths(mpp) == 0)
 			mpp->stat_map_failures++;
 		mpp->retry_tick = 0;
 		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 		mpp->disable_queueing = 1;
-		dm_queue_if_no_path(mpp->alias, 0);
+		__set_no_path_retry(mpp, false);
 	}
 	return 0;
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index a21d96e4..c0423602 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1616,7 +1616,7 @@ fail_path (struct path * pp, int del_active)
  * caller must have locked the path list before calling that function
  */
 static int
-reinstate_path (struct path * pp, int add_active)
+reinstate_path (struct path * pp)
 {
 	int ret = 0;
 
@@ -1628,8 +1628,7 @@ reinstate_path (struct path * pp, int add_active)
 		ret = 1;
 	} else {
 		condlog(2, "%s: reinstated", pp->dev_t);
-		if (add_active)
-			update_queue_mode_add_path(pp->mpp);
+		update_queue_mode_add_path(pp->mpp);
 	}
 	return ret;
 }
@@ -1861,7 +1860,7 @@ static int check_path_reinstate_state(struct path * pp) {
 
 	if (pp->disable_reinstate) {
 		/* If there are no other usable paths, reinstate the path */
-		if (pp->mpp->nr_active == 0) {
+		if (count_active_paths(pp->mpp) == 0) {
 			condlog(2, "%s : reinstating path early", pp->dev);
 			goto reinstate_path;
 		}
@@ -1960,7 +1959,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int newstate;
 	int new_path_up = 0;
 	int chkr_new_path_up = 0;
-	int add_active;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
 	int retrigger_tries, verbosity;
@@ -2134,7 +2132,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	 * paths if there are no other active paths in map.
 	 */
 	disable_reinstate = (newstate == PATH_GHOST &&
-			     pp->mpp->nr_active == 0 &&
+			     count_active_paths(pp->mpp) == 0 &&
 			     path_get_tpgs(pp) == TPGS_IMPLICIT) ? 1 : 0;
 
 	pp->chkrstate = newstate;
@@ -2185,12 +2183,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		/*
 		 * reinstate this path
 		 */
-		if (oldstate != PATH_UP &&
-		    oldstate != PATH_GHOST)
-			add_active = 1;
-		else
-			add_active = 0;
-		if (!disable_reinstate && reinstate_path(pp, add_active)) {
+		if (!disable_reinstate && reinstate_path(pp)) {
 			condlog(3, "%s: reload map", pp->dev);
 			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
@@ -2213,7 +2206,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		    pp->dmstate == PSTATE_UNDEF) &&
 		    !disable_reinstate) {
 			/* Clear IO errors */
-			if (reinstate_path(pp, 0)) {
+			if (reinstate_path(pp)) {
 				condlog(3, "%s: reload map", pp->dev);
 				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
-- 
2.24.0
