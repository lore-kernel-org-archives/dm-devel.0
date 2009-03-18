From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Race-condition fix with free_waiter threads
	during shutdown.
Date: Wed, 18 Mar 2009 19:38:09 -0400
Message-ID: <1237419489-3303-5-git-send-email-konrad@virtualiron.com>
References: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-2-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-3-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-4-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237419489-3303-4-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

When we shutdown, the main process locks the mutex, causing
all of the free_waiter functions to pile up on their lock.
Once we unlock in the main process, all of the free_waiters
start working. However the next instruction in the main proces
is to destroy the mutex. The short window is all the free_waiter
threads have to do their cleanup before they attempt to unlock
the mutex - which might have been de-allocated (and set to NULL).
End result can be a seg-fault.

This fix adds a ref-count to the mutex so that during shutdown
we spin and wait until all of the free_waiter functions
have completed and the ref-count is set to zero.
---
 libmultipath/lock.c        |    4 ++--
 libmultipath/lock.h        |   23 ++++++++++++++++-------
 libmultipath/structs_vec.h |    8 +++++++-
 libmultipath/waiter.c      |   14 ++++++++++----
 multipath/main.c           |    1 +
 multipathd/main.c          |   28 +++++++++++++++++-----------
 6 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index 0ca8783..54e2988 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -1,8 +1,8 @@
 #include <pthread.h>
 #include "lock.h"
-
+#include <stdio.h>
 void cleanup_lock (void * data)
 {
-	unlock((pthread_mutex_t *)data);
+	unlock ((*(struct mutex_lock *)data));
 }
 
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 6afecda..f0e0bfa 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -1,19 +1,28 @@
 #ifndef _LOCK_H
 #define _LOCK_H
 
+/*
+ * Wrapper for the mutex. Includes a ref-count to keep
+ * track of how many there are out-standing threads blocking
+ * on a mutex. */
+struct mutex_lock {
+	pthread_mutex_t *mutex;
+	int depth;
+};
+
 #ifdef LCKDBG
 #define lock(a) \
-	        fprintf(stderr, "%s:%s(%i) lock %p\n", __FILE__, __FUNCTION__, __LINE__, a); \
-        pthread_mutex_lock(a)
+	        fprintf(stderr, "%s:%s(%i) lock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
+		a.depth++; pthread_mutex_lock(a.mutex)
 #define unlock(a) \
-	        fprintf(stderr, "%s:%s(%i) unlock %p\n", __FILE__, __FUNCTION__, __LINE__, a); \
-        pthread_mutex_unlock(a)
+	        fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
+        a.depth--; pthread_mutex_unlock(a.mutex)
 #define lock_cleanup_pop(a) \
-	        fprintf(stderr, "%s:%s(%i) unlock %p\n", __FILE__, __FUNCTION__, __LINE__, a); \
+	        fprintf(stderr, "%s:%s(%i) unlock %p depth: %d (%ld)\n", __FILE__, __FUNCTION__, __LINE__, a.mutex, a.depth, pthread_self()); \
         pthread_cleanup_pop(1);
 #else
-#define lock(a) pthread_mutex_lock(a)
-#define unlock(a) pthread_mutex_unlock(a)
+#define lock(a) a.depth++; pthread_mutex_lock(a.mutex)
+#define unlock(a) a.depth--; pthread_mutex_unlock(a.mutex)
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1);
 #endif
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 19a2387..78e468a 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -1,8 +1,14 @@
 #ifndef _STRUCTS_VEC_H
 #define _STRUCTS_VEC_H
 
+#include "lock.h"
+/*
+struct mutex_lock {
+	pthread_mutex_t *mutex;
+	int depth;
+}; */
 struct vectors {
-	pthread_mutex_t *lock;
+	struct mutex_lock lock; /* defined in lock.h */
 	vector pathvec;
 	vector mpvec;
 };
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 54cd19f..e9cde8b 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -45,7 +45,10 @@ void free_waiter (void *data)
 		 */
 		wp->mpp->waiter = NULL;
 	else
-		condlog(3, "free_waiter, mpp freed before wp=%p,", wp);
+		/*
+		 * This is OK condition during shutdown.
+		 */
+		condlog(3, "free_waiter, mpp freed before wp=%p (%s).", wp, wp->mapname);
 
 	unlock(wp->vecs->lock);
 
@@ -58,13 +61,16 @@ void free_waiter (void *data)
 void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
 	struct event_thread *wp = (struct event_thread *)mpp->waiter;
+	pthread_t thread;
 
 	if (!wp) {
 		condlog(3, "%s: no waiter thread", mpp->alias);
 		return;
 	}
-	condlog(2, "%s: stop event checker thread", wp->mapname);
-	pthread_kill((pthread_t)wp->thread, SIGUSR1);
+	thread = wp->thread;
+	condlog(2, "%s: stop event checker thread (%lu)", wp->mapname, thread);
+
+	pthread_kill(thread, SIGUSR1);
 }
 
 static sigset_t unblock_signals(void)
@@ -148,7 +154,7 @@ int waiteventloop (struct event_thread *waiter)
 		 * 4) a path reinstate : nothing to do
 		 * 5) a switch group : nothing to do
 		 */
-		pthread_cleanup_push(cleanup_lock, waiter->vecs->lock);
+		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
 		lock(waiter->vecs->lock);
 		r = update_multipath(waiter->vecs, waiter->mapname);
 		lock_cleanup_pop(waiter->vecs->lock);
diff --git a/multipath/main.c b/multipath/main.c
index ade858d..dacae1f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -440,6 +440,7 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 	
 out:
+
 	sysfs_cleanup();
 	dm_lib_release();
 	dm_lib_exit();
diff --git a/multipathd/main.c b/multipathd/main.c
index 323ed7f..b7532f1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -582,7 +582,7 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	*len = 0;
 	vecs = (struct vectors *)trigger_data;
 
-	pthread_cleanup_push(cleanup_lock, vecs->lock);
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
 
 	r = parse_cmd(str, reply, len, vecs);
@@ -740,9 +740,9 @@ exit_daemon (int status)
 	condlog(3, "unlink pidfile");
 	unlink(DEFAULT_PIDFILE);
 
-	lock(&exit_mutex);
+	pthread_mutex_lock(&exit_mutex);
 	pthread_cond_signal(&exit_cond);
-	unlock(&exit_mutex);
+	pthread_mutex_unlock(&exit_mutex);
 
 	return status;
 }
@@ -1020,7 +1020,7 @@ checkerloop (void *ap)
 	}
 
 	while (1) {
-		pthread_cleanup_push(cleanup_lock, vecs->lock);
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(vecs->lock);
 		condlog(4, "tick");
 
@@ -1163,13 +1163,14 @@ init_vecs (void)
 	if (!vecs)
 		return NULL;
 
-	vecs->lock =
+	vecs->lock.mutex =
 		(pthread_mutex_t *)MALLOC(sizeof(pthread_mutex_t));
 
-	if (!vecs->lock)
+	if (!vecs->lock.mutex)
 		goto out;
 
-	pthread_mutex_init(vecs->lock, NULL);
+	pthread_mutex_init(vecs->lock.mutex, NULL);
+	vecs->lock.depth = 0;
 
 	return vecs;
 
@@ -1341,7 +1342,6 @@ child (void * param)
 		condlog(0, "failure during configuration");
 		exit(1);
 	}
-
 	/*
 	 * start threads
 	 */
@@ -1375,9 +1375,15 @@ child (void * param)
 	free_polls();
 
 	unlock(vecs->lock);
-	pthread_mutex_destroy(vecs->lock);
-	FREE(vecs->lock);
-	vecs->lock = NULL;
+	/* Now all the waitevent threads will start rushing in. */
+	while (vecs->lock.depth > 0) {
+		sleep (1); /* This is weak. */
+		condlog(3,"Have %d wait event checkers threads to de-alloc, waiting..\n", vecs->lock.depth);
+	}
+	pthread_mutex_destroy(vecs->lock.mutex);
+	FREE(vecs->lock.mutex);
+	vecs->lock.depth = 0;
+	vecs->lock.mutex = NULL;
 	FREE(vecs);
 	vecs = NULL;
 
-- 
1.5.4.1
