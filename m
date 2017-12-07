From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 12/12] multipathd: marginal path code fixes
Date: Thu,  7 Dec 2017 12:49:06 -0600
Message-ID: <1512672546-12785-13-git-send-email-bmarzins@redhat.com>
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
Cc: Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

There are a couple of issues I noticed with the marginal paths code.

In hit_io_err_recheck_time() there are some problems with the initial
checks. We should always recover the path if there are no other usable
paths to the device, so this check should be first. Also, we just
checked that io_err_disable_reinstate isn't zero before calling this
function, so we don't need to check again here (and it doesn't make any
sense to continue disabling the path if io_err_disable_reinstate is set
to zero).  Finally, the only kind of errors we can get while calling
clock_gettime() are going to happen on every call. So, if we can't get
the time, assume that the timeout has passed.

The multipath.conf.5 description of marginal_path_err_sample_time,
states that sampling is stopped for marginal_path_err_rate_threshold
seconds, when it should be marginal_path_err_recheck_gap_time
seconds.

Lastly, there is a race that can cause multipathd to access freed memory
on shutdown. io_err_stat_thr is started as a detached thread. This means
that stop_io_err_stat_thread() can't know when it has actually stopped,
after pthread_cancel() and pthread_kill() are called. To be safe, it
should not start the thread in a deteched state, and call join to verify
that it has stopped before freeing the memory it uses.  But more
importantly, stop_io_err_stat_thread() was being called before the
checker and uevent threads were being canceled. Both of these threads
access data that is freed in stop_io_err_stat_thread(). To avoid the
chance of these threads accessing freed memory, child() should wait
until these threads are stopped before calling
stop_io_err_stat_thread().

Cc: Guan Junxiong <guanjunxiong@huawei.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 12 +++++-------
 multipath/multipath.conf.5 |  2 +-
 multipathd/main.c          |  6 +++---
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 75a6df6..5b10f03 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -379,17 +379,14 @@ int hit_io_err_recheck_time(struct path *pp)
 	struct timespec curr_time;
 	int r;
 
-	if (pp->io_err_disable_reinstate == 0)
-		return 1;
-	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
-		return 1;
-	if (pp->io_err_pathfail_cnt != PATH_IO_ERR_IN_POLLING_RECHECK)
-		return 1;
 	if (pp->mpp->nr_active <= 0) {
 		io_err_stat_log(2, "%s: recover path early", pp->dev);
 		goto recover;
 	}
-	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
+	if (pp->io_err_pathfail_cnt != PATH_IO_ERR_IN_POLLING_RECHECK)
+		return 1;
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
+	    (curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
 			pp->mpp->marginal_path_err_recheck_gap_time) {
 		io_err_stat_log(4, "%s: reschedule checking after %d seconds",
 				pp->dev,
@@ -738,6 +735,7 @@ void stop_io_err_stat_thread(void)
 {
 	pthread_cancel(io_err_stat_thr);
 	pthread_kill(io_err_stat_thr, SIGUSR2);
+	pthread_join(io_err_stat_thr, NULL);
 	free_io_err_pathvec(paths);
 	io_destroy(ioctx);
 }
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ba5d3bc..ab151e7 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -867,7 +867,7 @@ accounting process for the path will last for
 \fImarginal_path_err_sample_time\fR.
 If the rate of IO error on a particular path is greater than the
 \fImarginal_path_err_rate_threshold\fR, then the path will not reinstate for
-\fImarginal_path_err_rate_threshold\fR seconds unless there is only one
+\fImarginal_path_err_recheck_gap_time\fR seconds unless there is only one
 active path. After \fImarginal_path_err_recheck_gap_time\fR expires, the path
 will be requeueed for rechecking. If checking result is good enough, the
 path will be reinstated.
diff --git a/multipathd/main.c b/multipathd/main.c
index 16e4fdf..0703ca0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2332,7 +2332,7 @@ child (void * param)
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
-	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 1);
+	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 
 	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
@@ -2508,8 +2508,6 @@ child (void * param)
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
-	stop_io_err_stat_thread();
-
 	pthread_cancel(check_thr);
 	pthread_cancel(uevent_thr);
 	pthread_cancel(uxlsnr_thr);
@@ -2520,6 +2518,8 @@ child (void * param)
 	pthread_join(uxlsnr_thr, NULL);
 	pthread_join(uevq_thr, NULL);
 
+	stop_io_err_stat_thread();
+
 	lock(&vecs->lock);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 	vecs->pathvec = NULL;
-- 
2.7.4
