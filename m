From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/12] multipathd: remove select_* from
	setup_multipath
Date: Thu,  7 Dec 2017 12:49:01 -0600
Message-ID: <1512672546-12785-8-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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

select_rr_weight() and select_pgfailback() don't need to be set each
time setup_multipath is called, since nothing ever changes the value
of the multipath variable that they set.

select_flush_on_last_del() and select_no_path retry() are a little more
involved.  In multipathd, it is possible to override no_path_retry by
either setting flush_on_last_del, or by manually running the
"disablequeueing" mutipathd command. Queueing gets restored when a path
gets added back to the multipath device. This was done by moving the
select_* functions into setup_multipath, where they frequently get
called unnecessarily.  select_flush_on_last_del() can get removed by
simply using another variable besides flush_on_last_del to track wether
or not we should be force queueing to be disabled.

Since it's only possible to change whether or not you have queueing
force disabled by reloading the device with path, or by manually
restoring it, there is no reason to call select_no_path_retry() on every
call to setup_multipath

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  3 +++
 libmultipath/propsel.c     |  6 ++----
 libmultipath/structs.h     |  2 +-
 libmultipath/structs_vec.c |  5 -----
 multipathd/cli_handlers.c  | 22 ++++++++++++++++++----
 multipathd/main.c          |  3 +--
 6 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7ca84b8..b94e7ea 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -272,6 +272,8 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	 * free features, selector, and hwhandler properties if they are being reused
 	 */
 	free_multipath_attributes(mpp);
+	if (mpp->disable_queueing && VECTOR_SIZE(mpp->paths) != 0)
+		mpp->disable_queueing = 0;
 
 	/*
 	 * properties selectors
@@ -302,6 +304,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 	select_ghost_delay(conf, mpp);
+	select_flush_on_last_del(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	put_multipath_config(conf);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 4404e68..be371fc 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -520,8 +520,8 @@ int select_no_path_retry(struct config *conf, struct multipath *mp)
 	char *origin = NULL;
 	char buff[12];
 
-	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
-		condlog(0, "%s: flush_on_last_del in progress", mp->alias);
+	if (mp->disable_queueing) {
+		condlog(0, "%s: queueing disabled", mp->alias);
 		mp->no_path_retry = NO_PATH_RETRY_FAIL;
 		return 0;
 	}
@@ -613,8 +613,6 @@ int select_flush_on_last_del(struct config *conf, struct multipath *mp)
 {
 	char *origin;
 
-	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
-		return 0;
 	mp_set_mpe(flush_on_last_del);
 	mp_set_ovr(flush_on_last_del);
 	mp_set_hwe(flush_on_last_del);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index effa52f..bfa660a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -99,7 +99,6 @@ enum flush_states {
 	FLUSH_UNDEF = YNU_UNDEF,
 	FLUSH_DISABLED = YNU_NO,
 	FLUSH_ENABLED = YNU_YES,
-	FLUSH_IN_PROGRESS,
 };
 
 enum log_checker_err_states {
@@ -272,6 +271,7 @@ struct multipath {
 	int nr_active;     /* current available(= not known as failed) paths */
 	int no_path_retry; /* number of retries after all paths are down */
 	int retry_tick;    /* remaining times for retries */
+	int disable_queueing;
 	int minio;
 	int flush_on_last_del;
 	int attribute_flags;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 32a4d9e..70fb005 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -311,7 +311,6 @@ void set_no_path_retry(struct config *conf, struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	select_no_path_retry(conf, mpp);
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
@@ -360,10 +359,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 
 	if (reset) {
 		conf = get_multipath_config();
-		select_rr_weight(conf, mpp);
-		select_pgfailback(conf, mpp);
 		set_no_path_retry(conf, mpp);
-		select_flush_on_last_del(conf, mpp);
 		put_multipath_config(conf);
 		if (VECTOR_SIZE(mpp->paths) != 0)
 			dm_cancel_deferred_remove(mpp);
@@ -421,7 +417,6 @@ retry:
 		goto fail;
 	}
 	verify_paths(mpp, vecs);
-	mpp->flush_on_last_del = FLUSH_UNDEF;
 	mpp->action = ACT_RELOAD;
 
 	extract_hwe_from_path(mpp);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index e232fb2..bf0d9f6 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -22,7 +22,7 @@
 #include <libudev.h>
 #include "util.h"
 #include "prkey.h"
-
+#include "propsel.h"
 #include "main.h"
 #include "cli.h"
 #include "uevent.h"
@@ -973,6 +973,7 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 	char * mapname = get_keyparam(v, MAP);
 	struct multipath *mpp;
 	int minor;
+	struct config *conf;
 
 	mapname = convert_dev(mapname, 0);
 	condlog(2, "%s: restore map queueing (operator)", mapname);
@@ -986,6 +987,11 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
+	conf = get_multipath_config();
+	mpp->disable_queueing = 0;
+	select_no_path_retry(conf, mpp);
+	put_multipath_config(conf);
+
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 		dm_queue_if_no_path(mpp->alias, 1);
@@ -1009,13 +1015,17 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 
 	condlog(2, "restore queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		struct config *conf = get_multipath_config();
+		mpp->disable_queueing = 0;
+		select_no_path_retry(conf, mpp);
+		put_multipath_config(conf);
 		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 			dm_queue_if_no_path(mpp->alias, 1);
 			if (mpp->nr_active > 0)
 				mpp->retry_tick = 0;
 			else {
-				struct config *conf = get_multipath_config();
+				conf = get_multipath_config();
 				mpp->retry_tick = mpp->no_path_retry * conf->checkint;
 				put_multipath_config(conf);
 			}
@@ -1046,7 +1056,9 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 
 	if (mpp->nr_active == 0)
 		mpp->stat_map_failures++;
-	mpp->retry_tick = -1;
+	mpp->retry_tick = 0;
+	mpp->no_path_retry = NO_PATH_RETRY_FAIL;
+	mpp->disable_queueing = 1;
 	dm_queue_if_no_path(mpp->alias, 0);
 	return 0;
 }
@@ -1062,7 +1074,9 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (mpp->nr_active == 0)
 			mpp->stat_map_failures++;
-		mpp->retry_tick = -1;
+		mpp->retry_tick = 0;
+		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
+		mpp->disable_queueing = 1;
 		dm_queue_if_no_path(mpp->alias, 0);
 	}
 	return 0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 39fedc4..a420c83 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -697,7 +697,6 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs);
-		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 		extract_hwe_from_path(mpp);
 	} else {
@@ -852,7 +851,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 				condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
 				mpp->retry_tick = 0;
 				mpp->no_path_retry = NO_PATH_RETRY_FAIL;
-				mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
+				mpp->disable_queueing = 1;
 				mpp->stat_map_failures++;
 				dm_queue_if_no_path(mpp->alias, 0);
 			}
-- 
2.7.4
