From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/3] multipathd: move __setup_multipath to
	multipathd
Date: Fri, 16 Mar 2018 16:31:06 -0500
Message-ID: <1521235867-29476-3-git-send-email-bmarzins@redhat.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

__setup_multipath is only called from multipathd, so it shouldn't be in
libmultipath.  Move it, update_multpath (which calls it) and
set_no_path_retry (which is a helper function for it) into multipathd.
None of these functions were changed, only copied.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 103 ---------------------------------------------
 libmultipath/structs_vec.h |   4 --
 multipathd/dmevents.c      |   1 +
 multipathd/main.c          | 103 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.h          |   4 ++
 multipathd/waiter.c        |   1 +
 6 files changed, 109 insertions(+), 107 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index e9a0274..8c8fb25 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -290,61 +290,6 @@ void enter_recovery_mode(struct multipath *mpp)
 	put_multipath_config(conf);
 }
 
-static void set_no_path_retry(struct multipath *mpp)
-{
-	char is_queueing = 0;
-
-	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
-		is_queueing = 1;
-
-	switch (mpp->no_path_retry) {
-	case NO_PATH_RETRY_UNDEF:
-		break;
-	case NO_PATH_RETRY_FAIL:
-		if (is_queueing)
-			dm_queue_if_no_path(mpp->alias, 0);
-		break;
-	case NO_PATH_RETRY_QUEUE:
-		if (!is_queueing)
-			dm_queue_if_no_path(mpp->alias, 1);
-		break;
-	default:
-		if (mpp->nr_active > 0) {
-			mpp->retry_tick = 0;
-			dm_queue_if_no_path(mpp->alias, 1);
-		} else if (is_queueing && mpp->retry_tick == 0)
-			enter_recovery_mode(mpp);
-		break;
-	}
-}
-
-int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
-		      int reset)
-{
-	if (dm_get_info(mpp->alias, &mpp->dmi)) {
-		/* Error accessing table */
-		condlog(3, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-
-	if (update_multipath_strings(mpp, vecs->pathvec, 1)) {
-		condlog(0, "%s: failed to setup multipath", mpp->alias);
-		goto out;
-	}
-
-	if (reset) {
-		set_no_path_retry(mpp);
-		if (VECTOR_SIZE(mpp->paths) != 0)
-			dm_cancel_deferred_remove(mpp);
-	}
-
-	return 0;
-out:
-	remove_map(mpp, vecs, PURGE_VEC);
-	return 1;
-}
-
 void
 sync_map_state(struct multipath *mpp)
 {
@@ -468,54 +413,6 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 	return count;
 }
 
-int update_multipath (struct vectors *vecs, char *mapname, int reset)
-{
-	struct multipath *mpp;
-	struct pathgroup  *pgp;
-	struct path *pp;
-	int i, j;
-
-	mpp = find_mp_by_alias(vecs->mpvec, mapname);
-
-	if (!mpp) {
-		condlog(3, "%s: multipath map not found", mapname);
-		return 2;
-	}
-
-	if (__setup_multipath(vecs, mpp, reset))
-		return 1; /* mpp freed in setup_multipath */
-
-	/*
-	 * compare checkers states with DM states
-	 */
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->dmstate != PSTATE_FAILED)
-				continue;
-
-			if (pp->state != PATH_DOWN) {
-				struct config *conf = get_multipath_config();
-				int oldstate = pp->state;
-				condlog(2, "%s: mark as failed", pp->dev);
-				mpp->stat_path_failures++;
-				pp->state = PATH_DOWN;
-				if (oldstate == PATH_UP ||
-				    oldstate == PATH_GHOST)
-					update_queue_mode_del_path(mpp);
-
-				/*
-				 * if opportune,
-				 * schedule the next check earlier
-				 */
-				if (pp->tick > conf->checkint)
-					pp->tick = conf->checkint;
-				put_multipath_config(conf);
-			}
-		}
-	}
-	return 0;
-}
-
 /*
  * mpp->no_path_retry:
  *   -2 (QUEUE) : queue_if_no_path enabled, never turned off
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 0adba17..4220ea3 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -19,9 +19,6 @@ void orphan_path (struct path * pp, const char *reason);
 
 int verify_paths(struct multipath * mpp, struct vectors * vecs);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
-int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
-		       int reset);
-#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
 int update_multipath_strings (struct multipath *mpp, vector pathvec,
 			      int is_daemon);
 void extract_hwe_from_path(struct multipath * mpp);
@@ -36,7 +33,6 @@ void remove_maps (struct vectors * vecs);
 void sync_map_state (struct multipath *);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
-int update_multipath (struct vectors *vecs, char *mapname, int reset);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
 int update_multipath_table (struct multipath *mpp, vector pathvec,
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 1ef811e..2281a10 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -22,6 +22,7 @@
 #include "structs_vec.h"
 #include "devmapper.h"
 #include "debug.h"
+#include "main.h"
 #include "dmevents.h"
 
 #ifndef DM_DEV_ARM_POLL
diff --git a/multipathd/main.c b/multipathd/main.c
index e35231e..70aff5d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -347,6 +347,109 @@ set_multipath_wwid (struct multipath * mpp)
 	dm_get_uuid(mpp->alias, mpp->wwid);
 }
 
+static void set_no_path_retry(struct multipath *mpp)
+{
+	char is_queueing = 0;
+
+	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
+	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
+		is_queueing = 1;
+
+	switch (mpp->no_path_retry) {
+	case NO_PATH_RETRY_UNDEF:
+		break;
+	case NO_PATH_RETRY_FAIL:
+		if (is_queueing)
+			dm_queue_if_no_path(mpp->alias, 0);
+		break;
+	case NO_PATH_RETRY_QUEUE:
+		if (!is_queueing)
+			dm_queue_if_no_path(mpp->alias, 1);
+		break;
+	default:
+		if (mpp->nr_active > 0) {
+			mpp->retry_tick = 0;
+			dm_queue_if_no_path(mpp->alias, 1);
+		} else if (is_queueing && mpp->retry_tick == 0)
+			enter_recovery_mode(mpp);
+		break;
+	}
+}
+
+int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
+		      int reset)
+{
+	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+		/* Error accessing table */
+		condlog(3, "%s: cannot access table", mpp->alias);
+		goto out;
+	}
+
+	if (update_multipath_strings(mpp, vecs->pathvec, 1)) {
+		condlog(0, "%s: failed to setup multipath", mpp->alias);
+		goto out;
+	}
+
+	if (reset) {
+		set_no_path_retry(mpp);
+		if (VECTOR_SIZE(mpp->paths) != 0)
+			dm_cancel_deferred_remove(mpp);
+	}
+
+	return 0;
+out:
+	remove_map(mpp, vecs, PURGE_VEC);
+	return 1;
+}
+
+int update_multipath (struct vectors *vecs, char *mapname, int reset)
+{
+	struct multipath *mpp;
+	struct pathgroup  *pgp;
+	struct path *pp;
+	int i, j;
+
+	mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (!mpp) {
+		condlog(3, "%s: multipath map not found", mapname);
+		return 2;
+	}
+
+	if (__setup_multipath(vecs, mpp, reset))
+		return 1; /* mpp freed in setup_multipath */
+
+	/*
+	 * compare checkers states with DM states
+	 */
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (pp->dmstate != PSTATE_FAILED)
+				continue;
+
+			if (pp->state != PATH_DOWN) {
+				struct config *conf = get_multipath_config();
+				int oldstate = pp->state;
+				condlog(2, "%s: mark as failed", pp->dev);
+				mpp->stat_path_failures++;
+				pp->state = PATH_DOWN;
+				if (oldstate == PATH_UP ||
+				    oldstate == PATH_GHOST)
+					update_queue_mode_del_path(mpp);
+
+				/*
+				 * if opportune,
+				 * schedule the next check earlier
+				 */
+				if (pp->tick > conf->checkint)
+					pp->tick = conf->checkint;
+				put_multipath_config(conf);
+			}
+		}
+	}
+	return 0;
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index 0e9c5e3..af39558 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -39,5 +39,9 @@ void * mpath_pr_event_handler_fn (void * );
 int update_map_pr(struct multipath *mpp);
 void * mpath_pr_event_handler_fn (void * pathp );
 void handle_signals(bool);
+int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
+		       int reset);
+#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
+int update_multipath (struct vectors *vecs, char *mapname, int reset);
 
 #endif /* MAIN_H */
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index e894294..c70ad21 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -21,6 +21,7 @@
 #include "debug.h"
 #include "lock.h"
 #include "waiter.h"
+#include "main.h"
 
 pthread_attr_t waiter_attr;
 struct mutex_lock waiter_lock = { .mutex = PTHREAD_MUTEX_INITIALIZER };
-- 
2.7.4
