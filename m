From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 04/10] multipathd: add "map failures" format
	wildcard
Date: Fri, 28 Oct 2016 21:55:20 -0500
Message-ID: <1477709726-5442-5-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

This patch adds a new wildcard, 'x', for the "show maps format" command.
This wildcard show the number of map failures that have occurred. A map
failure is any time that the multipath device enters a state where it
has no paths and is not set to queue_if_no_paths. It can be used to see
if a multipath device was ever in a state were it could fail IO errors
up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c       |  7 +++++++
 libmultipath/structs.h     |  1 +
 libmultipath/structs_vec.c | 28 ++++++++++++++++------------
 multipathd/cli_handlers.c  | 11 ++++++++++-
 multipathd/main.c          |  2 ++
 5 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 9aa41ad..f626dc5 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -245,6 +245,12 @@ snprint_q_timeouts (char * buff, size_t len, struct multipath * mpp)
 }
 
 static int
+snprint_map_failures (char * buff, size_t len, struct multipath * mpp)
+{
+	return snprint_uint(buff, len, mpp->stat_map_failures);
+}
+
+static int
 snprint_multipath_uuid (char * buff, size_t len, struct multipath * mpp)
 {
 	return snprint_str(buff, len, mpp->wwid);
@@ -619,6 +625,7 @@ struct multipath_data mpd[] = {
 	{'t', "dm-st",         0, snprint_dm_map_state},
 	{'S', "size",          0, snprint_multipath_size},
 	{'f', "features",      0, snprint_features},
+	{'x', "failures",      0, snprint_map_failures},
 	{'h', "hwhandler",     0, snprint_hwhandler},
 	{'A', "action",        0, snprint_action},
 	{'0', "path_faults",   0, snprint_path_faults},
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 2078413..3a716d8 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -277,6 +277,7 @@ struct multipath {
 	unsigned int stat_map_loads;
 	unsigned int stat_total_queueing_time;
 	unsigned int stat_queueing_timeouts;
+	unsigned int stat_map_failures;
 
 	/* checkers shared data */
 	void * mpcontext;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index a0c8869..e898528 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -610,19 +610,23 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
  */
 void update_queue_mode_del_path(struct multipath *mpp)
 {
-	if (--mpp->nr_active == 0 && mpp->no_path_retry > 0) {
-		struct config *conf = get_multipath_config();
+	if (--mpp->nr_active == 0) {
+		if (mpp->no_path_retry > 0) {
+			struct config *conf = get_multipath_config();
 
-		/*
-		 * Enter retry mode.
-		 * meaning of +1: retry_tick may be decremented in
-		 *                checkerloop before starting retry.
-		 */
-		mpp->stat_queueing_timeouts++;
-		mpp->retry_tick = mpp->no_path_retry * conf->checkint + 1;
-		condlog(1, "%s: Entering recovery mode: max_retries=%d",
-			mpp->alias, mpp->no_path_retry);
-		put_multipath_config(conf);
+			/*
+			 * Enter retry mode.
+			 * meaning of +1: retry_tick may be decremented in
+			 *                checkerloop before starting retry.
+			 */
+			mpp->stat_queueing_timeouts++;
+			mpp->retry_tick = mpp->no_path_retry *
+					  conf->checkint + 1;
+			condlog(1, "%s: Entering recovery mode: max_retries=%d",
+				mpp->alias, mpp->no_path_retry);
+			put_multipath_config(conf);
+		} else if (mpp->no_path_retry != NO_PATH_RETRY_QUEUE)
+			mpp->stat_map_failures++;
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 181b2b8..b0eeca6 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -498,9 +498,14 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 			c += snprint_multipath_header(c, reply + maxlen - c,
 						      style);
 
-		vector_foreach_slot(vecs->mpvec, mpp, i)
+		vector_foreach_slot(vecs->mpvec, mpp, i) {
+			if (update_multipath(vecs, mpp->alias, 0)) {
+				i--;
+				continue;
+			}
 			c += snprint_multipath(c, reply + maxlen - c,
 					       style, mpp, pretty);
+		}
 
 		again = ((c - reply) == (maxlen - 1));
 
@@ -997,6 +1002,8 @@ cli_disable_queueing(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
+	if (mpp->nr_active == 0)
+		mpp->stat_map_failures++;
 	mpp->retry_tick = -1;
 	dm_queue_if_no_path(mpp->alias, 0);
 	return 0;
@@ -1011,6 +1018,8 @@ cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
 
 	condlog(2, "disable queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (mpp->nr_active == 0)
+			mpp->stat_map_failures++;
 		mpp->retry_tick = -1;
 		dm_queue_if_no_path(mpp->alias, 0);
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 03c2dd9..dbcaa03 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -889,6 +889,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 				mpp->retry_tick = 0;
 				mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 				mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
+				mpp->stat_map_failures++;
 				dm_queue_if_no_path(mpp->alias, 0);
 			}
 			if (!flush_map(mpp, vecs, 1)) {
@@ -1397,6 +1398,7 @@ retry_count_tick(vector mpvec)
 			mpp->stat_total_queueing_time++;
 			condlog(4, "%s: Retrying.. No active path", mpp->alias);
 			if(--mpp->retry_tick == 0) {
+				mpp->stat_map_failures++;
 				dm_queue_if_no_path(mpp->alias, 0);
 				condlog(2, "%s: Disable queueing", mpp->alias);
 			}
-- 
1.8.3.1
