From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 09/12] multipathd: move recovery mode code to
	function
Date: Thu,  7 Dec 2017 12:49:03 -0600
Message-ID: <1512672546-12785-10-git-send-email-bmarzins@redhat.com>
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

Instead of having multiple functions all running slightly different
code to move a multipath device to recovery mode, there is now
an enter_recovery_mode() function that all of them call.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 52 ++++++++++++++++++++--------------------------
 libmultipath/structs_vec.h |  2 +-
 multipathd/cli_handlers.c  | 14 ++++---------
 3 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 814a4b9..2f1f277 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -307,7 +307,23 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 	return 0;
 }
 
-void set_no_path_retry(struct config *conf, struct multipath *mpp)
+void enter_recovery_mode(struct multipath *mpp)
+{
+	struct config *conf = get_multipath_config();
+
+	/*
+	 * Enter retry mode.
+	 * meaning of +1: retry_tick may be decremented in checkerloop before
+	 * starting retry.
+	 */
+	mpp->stat_queueing_timeouts++;
+	mpp->retry_tick = mpp->no_path_retry * conf->checkint + 1;
+	condlog(1, "%s: Entering recovery mode: max_retries=%d",
+		mpp->alias, mpp->no_path_retry);
+	put_multipath_config(conf);
+}
+
+static void set_no_path_retry(struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
@@ -323,14 +339,8 @@ void set_no_path_retry(struct config *conf, struct multipath *mpp)
 		break;
 	default:
 		dm_queue_if_no_path(mpp->alias, 1);
-		if (mpp->nr_active == 0) {
-			struct config *conf = get_multipath_config();
-			/* Enter retry mode */
-			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
-			condlog(1, "%s: Entering recovery mode: max_retries=%d",
-				mpp->alias, mpp->no_path_retry);
-			put_multipath_config(conf);
-		}
+		if (mpp->nr_active == 0)
+			enter_recovery_mode(mpp);
 		break;
 	}
 }
@@ -338,8 +348,6 @@ void set_no_path_retry(struct config *conf, struct multipath *mpp)
 int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		      int reset)
 {
-	struct config *conf;
-
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
 		condlog(3, "%s: cannot access table", mpp->alias);
@@ -358,9 +366,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 	}
 
 	if (reset) {
-		conf = get_multipath_config();
-		set_no_path_retry(conf, mpp);
-		put_multipath_config(conf);
+		set_no_path_retry(mpp);
 		if (VECTOR_SIZE(mpp->paths) != 0)
 			dm_cancel_deferred_remove(mpp);
 	}
@@ -638,21 +644,9 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 void update_queue_mode_del_path(struct multipath *mpp)
 {
 	if (--mpp->nr_active == 0) {
-		if (mpp->no_path_retry > 0) {
-			struct config *conf = get_multipath_config();
-
-			/*
-			 * Enter retry mode.
-			 * meaning of +1: retry_tick may be decremented in
-			 *                checkerloop before starting retry.
-			 */
-			mpp->stat_queueing_timeouts++;
-			mpp->retry_tick = mpp->no_path_retry *
-					  conf->checkint + 1;
-			condlog(1, "%s: Entering recovery mode: max_retries=%d",
-				mpp->alias, mpp->no_path_retry);
-			put_multipath_config(conf);
-		} else if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
+		if (mpp->no_path_retry > 0)
+			enter_recovery_mode(mpp);
+		else if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
 			mpp->stat_map_failures++;
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 04fa0dd..b81413b 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -11,7 +11,7 @@ struct vectors {
 	vector mpvec;
 };
 
-void set_no_path_retry(struct config *conf, struct multipath *mpp);
+void enter_recovery_mode(struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_paths (vector pathvec, struct multipath * mpp);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index bf0d9f6..7f13bc9 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -997,11 +997,8 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 		dm_queue_if_no_path(mpp->alias, 1);
 		if (mpp->nr_active > 0)
 			mpp->retry_tick = 0;
-		else {
-			struct config *conf = get_multipath_config();
-			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
-			put_multipath_config(conf);
-		}
+		else
+			enter_recovery_mode(mpp);
 	}
 	return 0;
 }
@@ -1024,11 +1021,8 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 			dm_queue_if_no_path(mpp->alias, 1);
 			if (mpp->nr_active > 0)
 				mpp->retry_tick = 0;
-			else {
-				conf = get_multipath_config();
-				mpp->retry_tick = mpp->no_path_retry * conf->checkint;
-				put_multipath_config(conf);
-			}
+			else
+				enter_recovery_mode(mpp);
 		}
 	}
 	return 0;
-- 
2.7.4
