From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/6] libmultipath: Convert lock() and unlock()
 into inline functions
Date: Mon, 15 Aug 2016 08:26:39 -0700
Message-ID: <4b04f69e-478c-089b-af4d-b68f8c6f8e3b@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Convert lock() and unlock() from macros into inline functions.
This conversion makes it possible for the compiler to perform
type checking on the lock() and unlock() arguments. However,
this makes it necessary to change the argument type from "struct
mutex_lock" into "struct mutex_lock *".

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.c   |  4 +++-
 libmultipath/lock.h   | 14 ++++++++++++--
 libmultipath/waiter.c |  2 +-
 multipathd/cli.c      |  2 +-
 multipathd/main.c     | 28 ++++++++++++++--------------
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index 8d7b2ad..72c70e3 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -2,5 +2,7 @@
 
 void cleanup_lock (void * data)
 {
-	unlock ((*(struct mutex_lock *)data));
+	struct mutex_lock *lock = data;
+
+	unlock(lock);
 }
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 71baf10..461b095 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -12,8 +12,18 @@ struct mutex_lock {
 	int depth;
 };
 
-#define lock(a) a.depth++; pthread_mutex_lock(a.mutex)
-#define unlock(a) a.depth--; pthread_mutex_unlock(a.mutex)
+static inline void lock(struct mutex_lock *a)
+{
+	a->depth++;
+	pthread_mutex_lock(a->mutex);
+}
+
+static inline void unlock(struct mutex_lock *a)
+{
+	a->depth--;
+	pthread_mutex_unlock(a->mutex);
+}
+
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 
 void cleanup_lock (void * data);
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 4079b13..995ea1a 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -138,7 +138,7 @@ static int waiteventloop (struct event_thread *waiter)
 		 * 5) a switch group : nothing to do
 		 */
 		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
-		lock(waiter->vecs->lock);
+		lock(&waiter->vecs->lock);
 		pthread_testcancel();
 		r = update_multipath(waiter->vecs, waiter->mapname, 1);
 		lock_cleanup_pop(waiter->vecs->lock);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 3663c0a..01b5ac8 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -490,7 +490,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 			vecs->lock.depth++;
 			r = pthread_mutex_timedlock(vecs->lock.mutex, &tmo);
 		} else {
-			lock(vecs->lock);
+			lock(&vecs->lock);
 			r = 0;
 		}
 		if (r == 0) {
diff --git a/multipathd/main.c b/multipathd/main.c
index f5e9a01..e0dc045 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -451,7 +451,7 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 		}
 	}
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	pthread_testcancel();
 	rc = ev_add_map(uev->kernel, alias, vecs);
 	lock_cleanup_pop(vecs->lock);
@@ -557,7 +557,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	minor = uevent_get_minor(uev);
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	pthread_testcancel();
 	mpp = find_mp_by_minor(vecs->mpvec, minor);
 
@@ -618,7 +618,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	}
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
@@ -668,7 +668,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		return 1;
 	}
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	pthread_testcancel();
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
@@ -831,7 +831,7 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs)
 
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp)
@@ -957,7 +957,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
 			uev->kernel, ro);
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(vecs->lock);
+		lock(&vecs->lock);
 		pthread_testcancel();
 		/*
 		 * pthread_mutex_lock() and pthread_mutex_unlock()
@@ -1794,7 +1794,7 @@ checkerloop (void *ap)
 		}
 		if (vecs->pathvec) {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(vecs->lock);
+			lock(&vecs->lock);
 			pthread_testcancel();
 			vector_foreach_slot (vecs->pathvec, pp, i) {
 				rc = check_path(vecs, pp, ticks);
@@ -1810,7 +1810,7 @@ checkerloop (void *ap)
 		}
 		if (vecs->mpvec) {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(vecs->lock);
+			lock(&vecs->lock);
 			pthread_testcancel();
 			defered_failback_tick(vecs->mpvec);
 			retry_count_tick(vecs->mpvec);
@@ -1821,7 +1821,7 @@ checkerloop (void *ap)
 			count--;
 		else {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(vecs->lock);
+			lock(&vecs->lock);
 			pthread_testcancel();
 			condlog(4, "map garbage collection");
 			mpvec_garbage_collector(vecs);
@@ -2377,7 +2377,7 @@ child (void * param)
 		pthread_cleanup_pop(1);
 		if (running_state == DAEMON_CONFIGURE) {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(vecs->lock);
+			lock(&vecs->lock);
 			pthread_testcancel();
 			if (!need_to_delay_reconfig(vecs)) {
 				reconfigure(vecs);
@@ -2391,24 +2391,24 @@ child (void * param)
 		}
 	}
 
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	conf = get_multipath_config();
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
 	put_multipath_config(conf);
 	remove_maps_and_stop_waiters(vecs);
-	unlock(vecs->lock);
+	unlock(&vecs->lock);
 
 	pthread_cancel(check_thr);
 	pthread_cancel(uevent_thr);
 	pthread_cancel(uxlsnr_thr);
 	pthread_cancel(uevq_thr);
 
-	lock(vecs->lock);
+	lock(&vecs->lock);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 	vecs->pathvec = NULL;
-	unlock(vecs->lock);
+	unlock(&vecs->lock);
 	/* Now all the waitevent threads will start rushing in. */
 	while (vecs->lock.depth > 0) {
 		sleep (1); /* This is weak. */
-- 
2.9.2
