From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 04/17] libmultipath: fix marginal paths
	queueing errors
Date: Sat, 30 Mar 2019 01:05:53 -0500
Message-ID: <1553925966-20958-5-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The current marginal paths code tries to enqueue paths for io error
checking when multipathd receives a uevent on path failure. This can run
into a couple of problems. First, this uevent could happen before or
after multipathd actually fails the path, so simply checking nr_active
doesn't tell us if this is the last active path. Also, The code to fail
the path in enqueue_io_err_stat_by_path() doesn't ever update the path
state. This can cause the path to get failed twice, temporarily leading
to incorrect nr_active counts. Further, The point when multipathd should
care if this is the last active path is when the path has come up again,
not when it goes down. Lastly, if the path is down, it is often
impossible to open the path device, causing setup_directio_ctx() to
fail, which causes multipathd to skip io error checking and mark the
path as not marginal.

Instead, multipathd should just make sure that if the path is marginal,
it gets failed in the uevent, so as not to race with the checkerloop
thread. Then, when the path comes back up, check_path() can enqueue it,
just like it does for paths that need to get rechecked. To make it
obvious that the state PATH_IO_ERR_IN_POLLING_RECHECK and the function
hit_io_err_recheck_time() now apply to paths waiting to be enqueued for
the first time as well, I've also changed their names to
PATH_IO_ERR_WAITING_TO_CHECK and need_io_err_check(), respectively.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 55 +++++++++++++++++---------------------
 libmultipath/io_err_stat.h |  2 +-
 multipathd/main.c          |  2 +-
 3 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 416e13a..72aacf3 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -41,7 +41,7 @@
 #define CONCUR_NR_EVENT			32
 
 #define PATH_IO_ERR_IN_CHECKING		-1
-#define PATH_IO_ERR_IN_POLLING_RECHECK	-2
+#define PATH_IO_ERR_WAITING_TO_CHECK	-2
 
 #define io_err_stat_log(prio, fmt, args...) \
 	condlog(prio, "io error statistic: " fmt, ##args)
@@ -283,24 +283,6 @@ static int enqueue_io_err_stat_by_path(struct path *path)
 	vector_set_slot(paths->pathvec, p);
 	pthread_mutex_unlock(&paths->mutex);
 
-	if (!path->io_err_disable_reinstate) {
-		/*
-		 *fail the path in the kernel for the time of the to make
-		 *the test more reliable
-		 */
-		io_err_stat_log(3, "%s: fail dm path %s before checking",
-				path->mpp->alias, path->dev);
-		path->io_err_disable_reinstate = 1;
-		dm_fail_path(path->mpp->alias, path->dev_t);
-		update_queue_mode_del_path(path->mpp);
-
-		/*
-		 * schedule path check as soon as possible to
-		 * update path state to delayed state
-		 */
-		path->tick = 1;
-
-	}
 	io_err_stat_log(2, "%s: enqueue path %s to check",
 			path->mpp->alias, path->dev);
 	return 0;
@@ -317,7 +299,6 @@ free_ioerr_path:
 int io_err_stat_handle_pathfail(struct path *path)
 {
 	struct timespec curr_time;
-	int res;
 
 	if (uatomic_read(&io_err_thread_running) == 0)
 		return 1;
@@ -332,8 +313,6 @@ int io_err_stat_handle_pathfail(struct path *path)
 
 	if (!path->mpp)
 		return 1;
-	if (path->mpp->nr_active <= 1)
-		return 1;
 	if (path->mpp->marginal_path_double_failed_time <= 0 ||
 		path->mpp->marginal_path_err_sample_time <= 0 ||
 		path->mpp->marginal_path_err_recheck_gap_time <= 0 ||
@@ -371,17 +350,33 @@ int io_err_stat_handle_pathfail(struct path *path)
 	}
 	path->io_err_pathfail_cnt++;
 	if (path->io_err_pathfail_cnt >= FLAKY_PATHFAIL_THRESHOLD) {
-		res = enqueue_io_err_stat_by_path(path);
-		if (!res)
-			path->io_err_pathfail_cnt = PATH_IO_ERR_IN_CHECKING;
-		else
-			path->io_err_pathfail_cnt = 0;
+		path->io_err_disable_reinstate = 1;
+		path->io_err_pathfail_cnt = PATH_IO_ERR_WAITING_TO_CHECK;
+		/* enqueue path as soon as it comes up */
+		path->io_err_dis_reinstate_time = 0;
+		if (path->state != PATH_DOWN) {
+			struct config *conf;
+			int oldstate = path->state;
+			int checkint;
+
+			conf = get_multipath_config();
+			checkint = conf->checkint;
+			put_multipath_config(conf);
+			io_err_stat_log(2, "%s: mark as failed", path->dev);
+			path->mpp->stat_path_failures++;
+			path->state = PATH_DOWN;
+			path->dmstate = PSTATE_FAILED;
+			if (oldstate == PATH_UP || oldstate == PATH_GHOST)
+				update_queue_mode_del_path(path->mpp);
+			if (path->tick > checkint)
+				path->tick = checkint;
+		}
 	}
 
 	return 0;
 }
 
-int hit_io_err_recheck_time(struct path *pp)
+int need_io_err_check(struct path *pp)
 {
 	struct timespec curr_time;
 	int r;
@@ -392,7 +387,7 @@ int hit_io_err_recheck_time(struct path *pp)
 		io_err_stat_log(2, "%s: recover path early", pp->dev);
 		goto recover;
 	}
-	if (pp->io_err_pathfail_cnt != PATH_IO_ERR_IN_POLLING_RECHECK)
+	if (pp->io_err_pathfail_cnt != PATH_IO_ERR_WAITING_TO_CHECK)
 		return 1;
 	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
 	    (curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
@@ -489,7 +484,7 @@ static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
 	} else if (path->mpp && path->mpp->nr_active > 1) {
 		io_err_stat_log(3, "%s: keep failing the dm path %s",
 				path->mpp->alias, path->dev);
-		path->io_err_pathfail_cnt = PATH_IO_ERR_IN_POLLING_RECHECK;
+		path->io_err_pathfail_cnt = PATH_IO_ERR_WAITING_TO_CHECK;
 		path->io_err_disable_reinstate = 1;
 		path->io_err_dis_reinstate_time = currtime.tv_sec;
 		io_err_stat_log(3, "%s: disable reinstating of %s",
diff --git a/libmultipath/io_err_stat.h b/libmultipath/io_err_stat.h
index bbf31b4..53d6d7d 100644
--- a/libmultipath/io_err_stat.h
+++ b/libmultipath/io_err_stat.h
@@ -10,6 +10,6 @@ extern pthread_attr_t io_err_stat_attr;
 int start_io_err_stat_thread(void *data);
 void stop_io_err_stat_thread(void);
 int io_err_stat_handle_pathfail(struct path *path);
-int hit_io_err_recheck_time(struct path *pp);
+int need_io_err_check(struct path *pp);
 
 #endif /* _IO_ERR_STAT_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index fe6d8ef..43830e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2080,7 +2080,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-	    pp->io_err_disable_reinstate && hit_io_err_recheck_time(pp)) {
+	    pp->io_err_disable_reinstate && need_io_err_check(pp)) {
 		pp->state = PATH_SHAKY;
 		/*
 		 * to reschedule as soon as possible,so that this path can
-- 
2.17.2
