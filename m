From: mwilck@suse.com
Subject: [PATCH 04/23] multipathd: move vecs desctruction into
	cleanup function
Date: Thu, 24 Sep 2020 15:40:35 +0200
Message-ID: <20200924134054.14632-5-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This will make it easer to move the stuff around later.
The only functional change is that map destuction now happens after
joining all threads, which should actually improve robustness.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 64 +++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4d714e8..2642570 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -148,7 +148,7 @@ int should_exit(void)
 /*
  * global copy of vecs for use in sig handlers
  */
-struct vectors * gvecs;
+static struct vectors * gvecs;
 
 struct config *multipath_conf;
 
@@ -2889,6 +2889,44 @@ set_oom_adj (void)
 	condlog(0, "couldn't adjust oom score");
 }
 
+static void cleanup_maps(struct vectors *vecs)
+{
+	int queue_without_daemon, i;
+	struct multipath *mpp;
+	struct config *conf;
+
+	conf = get_multipath_config();
+	queue_without_daemon = conf->queue_without_daemon;
+	put_multipath_config(conf);
+	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
+		vector_foreach_slot(vecs->mpvec, mpp, i)
+			dm_queue_if_no_path(mpp->alias, 0);
+	remove_maps_and_stop_waiters(vecs);
+	vecs->mpvec = NULL;
+}
+
+static void cleanup_paths(struct vectors *vecs)
+{
+	free_pathvec(vecs->pathvec, FREE_PATHS);
+	vecs->pathvec = NULL;
+}
+
+static void cleanup_vecs(void)
+{
+	if (!gvecs)
+		return;
+	/*
+	 * We can't take the vecs lock here, because exit() may
+	 * have been called from the child() thread, holding the lock already.
+	 * Anyway, by the time we get here, all threads that might access
+	 * vecs should have been joined already (in cleanup_threads).
+	 */
+	cleanup_maps(gvecs);
+	cleanup_paths(gvecs);
+	pthread_mutex_destroy(&gvecs->lock.mutex);
+	FREE(gvecs);
+}
+
 /*
  * Use a non-default call_rcu_data for child().
  *
@@ -2936,13 +2974,10 @@ child (__attribute__((unused)) void *param)
 	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
 	pthread_attr_t log_attr, misc_attr, uevent_attr;
 	struct vectors * vecs;
-	struct multipath * mpp;
-	int i;
 	int rc;
 	int pid_fd = -1;
 	struct config *conf;
 	char *envp;
-	int queue_without_daemon;
 	enum daemon_status state;
 	struct call_rcu_data *crdp;
 
@@ -3108,17 +3143,6 @@ child (__attribute__((unused)) void *param)
 	if (poll_dmevents)
 		pthread_cancel(dmevent_thr);
 
-	conf = get_multipath_config();
-	queue_without_daemon = conf->queue_without_daemon;
-	put_multipath_config(conf);
-
-	lock(&vecs->lock);
-	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
-		vector_foreach_slot(vecs->mpvec, mpp, i)
-			dm_queue_if_no_path(mpp->alias, 0);
-	remove_maps_and_stop_waiters(vecs);
-	unlock(&vecs->lock);
-
 	pthread_join(check_thr, NULL);
 	pthread_join(uevent_thr, NULL);
 	pthread_join(uxlsnr_thr, NULL);
@@ -3128,15 +3152,7 @@ child (__attribute__((unused)) void *param)
 
 	stop_io_err_stat_thread();
 
-	lock(&vecs->lock);
-	free_pathvec(vecs->pathvec, FREE_PATHS);
-	vecs->pathvec = NULL;
-	unlock(&vecs->lock);
-
-	pthread_mutex_destroy(&vecs->lock.mutex);
-	FREE(vecs);
-	vecs = NULL;
-
+	cleanup_vecs();
 	cleanup_foreign();
 	cleanup_checkers();
 	cleanup_prio();
-- 
2.28.0
