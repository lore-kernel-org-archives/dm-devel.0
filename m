From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/2] multipathd: start marginal path checker
	thread lazily
Date: Wed,  7 Mar 2018 15:07:33 +0100
Message-ID: <20180307140733.28709-3-mwilck@suse.com>
References: <20180307140733.28709-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307140733.28709-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

I noticed that the io_error checker thread accounts for most of the
activity of multipathd even if the marginal path checking paramters
are not set (which is still the default in most installations I assume).

Therefore, start the io_error checker thread only if there's at least
one map with marginal error path checking configured. Also, make sure
the thread is really up when start_io_err_stat_thread() returns.

This requires adding a "vecs" argument to setup_map, because vecs
needs to be passed to the io_error checking code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 14 ++++++++---
 libmultipath/configure.h   |  3 ++-
 libmultipath/io_err_stat.c | 58 ++++++++++++++++++++++++++++++++++++++++++----
 libmultipath/structs_vec.c |  3 ++-
 multipathd/cli_handlers.c  |  2 +-
 multipathd/main.c          |  8 ++-----
 6 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 42b7c896ee65..fa6e21cb31af 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -41,6 +41,7 @@
 #include "uxsock.h"
 #include "wwids.h"
 #include "sysfs.h"
+#include "io_err_stat.h"
 
 /* group paths in pg by host adapter
  */
@@ -255,7 +256,8 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 	return 0;
 }
 
-int setup_map(struct multipath *mpp, char *params, int params_size)
+int setup_map(struct multipath *mpp, char *params, int params_size,
+	      struct vectors *vecs)
 {
 	struct pathgroup * pgp;
 	struct config *conf;
@@ -315,6 +317,12 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	put_multipath_config(conf);
+
+	if (mpp->marginal_path_double_failed_time > 0 &&
+	    mpp->marginal_path_err_sample_time > 0 &&
+	    mpp->marginal_path_err_recheck_gap_time > 0 &&
+	    mpp->marginal_path_err_rate_threshold >= 0)
+		start_io_err_stat_thread(vecs);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
@@ -1019,7 +1027,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		verify_paths(mpp, vecs);
 
 		params[0] = '\0';
-		if (setup_map(mpp, params, PARAMS_SIZE)) {
+		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 			remove_map(mpp, vecs, 0);
 			continue;
 		}
@@ -1348,7 +1356,7 @@ int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 			}
 		}
 	}
-	if (setup_map(mpp, params, PARAMS_SIZE)) {
+	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 		condlog(0, "%s: failed to setup map", mpp->alias);
 		return 1;
 	}
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 0f5d30a540ca..27a7e6f60a63 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -28,7 +28,8 @@ enum actions {
 
 struct vectors;
 
-int setup_map (struct multipath * mpp, char * params, int params_size );
+int setup_map (struct multipath * mpp, char * params, int params_size,
+	       struct vectors *vecs );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 536ba87968fd..02b1453ea527 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -74,6 +74,10 @@ struct io_err_stat_path {
 pthread_t		io_err_stat_thr;
 pthread_attr_t		io_err_stat_attr;
 
+static pthread_mutex_t io_err_thread_lock = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t io_err_thread_cond = PTHREAD_COND_INITIALIZER;
+static int io_err_thread_running = 0;
+
 static struct io_err_stat_pathvec *paths;
 struct vectors *vecs;
 io_context_t	ioctx;
@@ -316,6 +320,9 @@ int io_err_stat_handle_pathfail(struct path *path)
 	struct timespec curr_time;
 	int res;
 
+	if (uatomic_read(&io_err_thread_running) == 0)
+		return 1;
+
 	if (path->io_err_disable_reinstate) {
 		io_err_stat_log(3, "%s: reinstate is already disabled",
 				path->dev);
@@ -380,6 +387,8 @@ int hit_io_err_recheck_time(struct path *pp)
 	struct timespec curr_time;
 	int r;
 
+	if (uatomic_read(&io_err_thread_running) == 0)
+		return 0;
 	if (pp->mpp->nr_active <= 0) {
 		io_err_stat_log(2, "%s: recover path early", pp->dev);
 		goto recover;
@@ -690,6 +699,16 @@ static void service_paths(void)
 	pthread_mutex_unlock(&paths->mutex);
 }
 
+static void cleanup_unlock(void *arg)
+{
+	pthread_mutex_unlock((pthread_mutex_t*) arg);
+}
+
+static void cleanup_exited(void *arg)
+{
+	uatomic_set(&io_err_thread_running, 0);
+}
+
 static void *io_err_stat_loop(void *data)
 {
 	sigset_t set;
@@ -698,10 +717,18 @@ static void *io_err_stat_loop(void *data)
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
+	pthread_cleanup_push(cleanup_exited, NULL);
+
 	sigfillset(&set);
 	sigdelset(&set, SIGUSR2);
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
+
+	pthread_mutex_lock(&io_err_thread_lock);
+	uatomic_set(&io_err_thread_running, 1);
+	pthread_cond_broadcast(&io_err_thread_cond);
+	pthread_mutex_unlock(&io_err_thread_lock);
+
 	while (1) {
 		struct timespec ts;
 
@@ -716,12 +743,18 @@ static void *io_err_stat_loop(void *data)
 		pselect(1, NULL, NULL, NULL, &ts, &set);
 	}
 
+	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 	return NULL;
 }
 
 int start_io_err_stat_thread(void *data)
 {
+	int ret;
+
+	if (uatomic_read(&io_err_thread_running) == 1)
+		return 0;
+
 	if (io_setup(CONCUR_NR_EVENT, &ioctx) != 0) {
 		io_err_stat_log(4, "io_setup failed");
 		return 1;
@@ -730,12 +763,24 @@ int start_io_err_stat_thread(void *data)
 	if (!paths)
 		goto destroy_ctx;
 
-	if (pthread_create(&io_err_stat_thr, &io_err_stat_attr,
-				io_err_stat_loop, data)) {
+	pthread_mutex_lock(&io_err_thread_lock);
+	pthread_cleanup_push(cleanup_unlock, &io_err_thread_lock);
+
+	ret = pthread_create(&io_err_stat_thr, &io_err_stat_attr,
+			     io_err_stat_loop, data);
+
+	while (!ret && !uatomic_read(&io_err_thread_running) &&
+	       pthread_cond_wait(&io_err_thread_cond,
+				 &io_err_thread_lock) == 0);
+
+	pthread_cleanup_pop(1);
+
+	if (ret) {
 		io_err_stat_log(0, "cannot create io_error statistic thread");
 		goto out_free;
 	}
-	io_err_stat_log(3, "thread started");
+
+	io_err_stat_log(2, "io_error statistic thread started");
 	return 0;
 
 out_free:
@@ -748,7 +793,12 @@ destroy_ctx:
 
 void stop_io_err_stat_thread(void)
 {
-	pthread_cancel(io_err_stat_thr);
+	if (io_err_stat_thr == (pthread_t)0)
+		return;
+
+	if (uatomic_read(&io_err_thread_running) == 1)
+		pthread_cancel(io_err_stat_thr);
+
 	pthread_join(io_err_stat_thr, NULL);
 	free_io_err_pathvec(paths);
 	io_destroy(ioctx);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3aafee7b217b..b3b94678438a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -18,6 +18,7 @@
 #include "prio.h"
 #include "configure.h"
 #include "libdevmapper.h"
+#include "io_err_stat.h"
 
 /*
  * creates or updates mpp->paths reading mpp->pg
@@ -426,7 +427,7 @@ retry:
 	mpp->action = ACT_RELOAD;
 
 	extract_hwe_from_path(mpp);
-	if (setup_map(mpp, params, PARAMS_SIZE)) {
+	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
 		goto fail;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index c0ae54aae841..7169e8d3d7ed 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -894,7 +894,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 
 	mpp->size = size;
 	update_mpp_paths(mpp, vecs->pathvec);
-	setup_map(mpp, params, PARAMS_SIZE);
+	setup_map(mpp, params, PARAMS_SIZE, vecs);
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
 	if (domap(mpp, params, 1) <= 0) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 09a59292245f..ccfc41a1f680 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -734,7 +734,7 @@ rescan:
 	/*
 	 * push the map to the device-mapper
 	 */
-	if (setup_map(mpp, params, PARAMS_SIZE)) {
+	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 		condlog(0, "%s: failed to setup map for addition of new "
 			"path %s", mpp->alias, pp->dev);
 		goto fail_map;
@@ -873,7 +873,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			 */
 		}
 
-		if (setup_map(mpp, params, PARAMS_SIZE)) {
+		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias, pp->dev);
 			goto fail;
@@ -2489,10 +2489,6 @@ child (void * param)
 	/*
 	 * start threads
 	 */
-	rc = start_io_err_stat_thread(vecs);
-	if (rc)
-		goto failed;
-
 	if ((rc = pthread_create(&check_thr, &misc_attr, checkerloop, vecs))) {
 		condlog(0,"failed to create checker loop thread: %d", rc);
 		goto failed;
-- 
2.16.1
