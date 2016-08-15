From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Mon, 15 Aug 2016 08:28:29 -0700
Message-ID: <14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
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

Use pthread_join() to wait until worker threads have finished
instead of using a counter to keep track of how many threads are
trying to grab a mutex. Remove mutex_lock.depth since this member
variable is no longer needed.

This patch fixes two race conditions:
* Incrementing "depth" in lock() without holding a mutex.
* Destroying a mutex from the main thread without waiting for the
  worker threads to finish using that mutex.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/lock.h | 15 +--------------
 multipathd/main.c   | 13 ++++++-------
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 9808480..a170efe 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -3,35 +3,22 @@
 
 #include <pthread.h>
 
-/*
- * Wrapper for the mutex. Includes a ref-count to keep
- * track of how many there are out-standing threads blocking
- * on a mutex. */
 struct mutex_lock {
 	pthread_mutex_t mutex;
-	int depth;
 };
 
 static inline void lock(struct mutex_lock *a)
 {
-	a->depth++;
 	pthread_mutex_lock(&a->mutex);
 }
 
 static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
 {
-	int r;
-
-	a->depth++;
-	r = pthread_mutex_timedlock(&a->mutex, tmo);
-	if (r)
-		a->depth--;
-	return r;
+	return pthread_mutex_timedlock(&a->mutex, tmo);
 }
 
 static inline void unlock(struct mutex_lock *a)
 {
-	a->depth--;
 	pthread_mutex_unlock(&a->mutex);
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index fff482c..c288195 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2046,7 +2046,6 @@ init_vecs (void)
 		return NULL;
 
 	pthread_mutex_init(&vecs->lock.mutex, NULL);
-	vecs->lock.depth = 0;
 
 	return vecs;
 }
@@ -2394,16 +2393,16 @@ child (void * param)
 	pthread_cancel(uxlsnr_thr);
 	pthread_cancel(uevq_thr);
 
+	pthread_join(check_thr, NULL);
+	pthread_join(uevent_thr, NULL);
+	pthread_join(uxlsnr_thr, NULL);
+	pthread_join(uevq_thr, NULL);
+
 	lock(&vecs->lock);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 	vecs->pathvec = NULL;
 	unlock(&vecs->lock);
-	/* Now all the waitevent threads will start rushing in. */
-	while (vecs->lock.depth > 0) {
-		sleep (1); /* This is weak. */
-		condlog(3, "Have %d wait event checkers threads to de-alloc,"
-			" waiting...", vecs->lock.depth);
-	}
+
 	pthread_mutex_destroy(&vecs->lock.mutex);
 	FREE(vecs);
 	vecs = NULL;
-- 
2.9.2
