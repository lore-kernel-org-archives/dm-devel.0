From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Fix a multipathd signal deadlock.
Date: Thu, 2 Apr 2009 15:18:55 -0500
Message-ID: <20090402201855.GT15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

If multipathd is run with -v3, both the SIGHUP, and the SIGUSR1 signal handlers
will log a message.  If a multipathd thread receives one of these signals while
it has a log lock held, it deadlocks itself. Also, the SIGHUP handler will grab
the vecs lock, so if any thread receives a SIGHUP while holding the vecs lock,
it deadlocks itself.  This commit blocks the appropriate signals to guard
against this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/lock.c        |   10 ++++++++++
 libmultipath/lock.h        |    3 +++
 libmultipath/log_pthread.c |    8 ++++++++
 libmultipath/waiter.c      |    5 +++++
 multipathd/main.c          |   10 ++++++++++
 5 files changed, 36 insertions(+)

Index: multipath-tools-090330/libmultipath/lock.c
===================================================================
--- multipath-tools-090330.orig/libmultipath/lock.c
+++ multipath-tools-090330/libmultipath/lock.c
@@ -1,6 +1,16 @@
 #include <pthread.h>
+#include <signal.h>
 #include "lock.h"
 #include <stdio.h>
+
+void block_signal (int signum, sigset_t *old)
+{
+	sigset_t set;
+	sigemptyset(&set);
+	sigaddset(&set, signum);
+	pthread_sigmask(SIG_BLOCK, &set, old);
+}
+
 void cleanup_lock (void * data)
 {
 	unlock ((*(struct mutex_lock *)data));
Index: multipath-tools-090330/libmultipath/lock.h
===================================================================
--- multipath-tools-090330.orig/libmultipath/lock.h
+++ multipath-tools-090330/libmultipath/lock.h
@@ -1,6 +1,8 @@
 #ifndef _LOCK_H
 #define _LOCK_H
 
+#include <signal.h>
+
 /*
  * Wrapper for the mutex. Includes a ref-count to keep
  * track of how many there are out-standing threads blocking
@@ -27,5 +29,6 @@ struct mutex_lock {
 #endif
 
 void cleanup_lock (void * data);
+void block_signal(int signum, sigset_t *old);
 
 #endif /* _LOCK_H */
Index: multipath-tools-090330/libmultipath/log_pthread.c
===================================================================
--- multipath-tools-090330.orig/libmultipath/log_pthread.c
+++ multipath-tools-090330/libmultipath/log_pthread.c
@@ -11,9 +11,15 @@
 
 #include "log_pthread.h"
 #include "log.h"
+#include "lock.h"
 
 void log_safe (int prio, const char * fmt, va_list ap)
 {
+	sigset_t old;
+
+	block_signal(SIGUSR1, &old);
+	block_signal(SIGHUP, NULL);
+
 	pthread_mutex_lock(logq_lock);
 	log_enqueue(prio, fmt, ap);
 	pthread_mutex_unlock(logq_lock);
@@ -21,6 +27,8 @@ void log_safe (int prio, const char * fm
 	pthread_mutex_lock(logev_lock);
 	pthread_cond_signal(logev_cond);
 	pthread_mutex_unlock(logev_lock);
+
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
 }
 
 static void flush_logqueue (void)
Index: multipath-tools-090330/libmultipath/waiter.c
===================================================================
--- multipath-tools-090330.orig/libmultipath/waiter.c
+++ multipath-tools-090330/libmultipath/waiter.c
@@ -32,11 +32,13 @@ struct event_thread *alloc_waiter (void)
 
 void free_waiter (void *data)
 {
+	sigset_t old;
 	struct event_thread *wp = (struct event_thread *)data;
 
 	/*
 	 * indicate in mpp that the wp is already freed storage
 	 */
+	block_signal(SIGHUP, &old);
 	lock(wp->vecs->lock);
 
 	if (wp->mpp)
@@ -51,6 +53,7 @@ void free_waiter (void *data)
 		condlog(3, "free_waiter, mpp freed before wp=%p (%s).", wp, wp->mapname);
 
 	unlock(wp->vecs->lock);
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
 
 	if (wp->dmt)
 		dm_task_destroy(wp->dmt);
@@ -185,6 +188,8 @@ void *waitevent (void *et)
 	waiter = (struct event_thread *)et;
 	pthread_cleanup_push(free_waiter, et);
 
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
 	while (1) {
 		r = waiteventloop(waiter);
 
Index: multipath-tools-090330/multipathd/main.c
===================================================================
--- multipath-tools-090330.orig/multipathd/main.c
+++ multipath-tools-090330/multipathd/main.c
@@ -688,6 +688,9 @@ out:
 static void *
 ueventloop (void * ap)
 {
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
+
 	if (uevent_listen(&uev_trigger, ap))
 		fprintf(stderr, "error starting uevent listener");
 
@@ -697,6 +700,9 @@ ueventloop (void * ap)
 static void *
 uxlsnrloop (void * ap)
 {
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
+
 	if (cli_init())
 		return NULL;
 
@@ -1007,6 +1013,7 @@ checkerloop (void *ap)
 	struct path *pp;
 	int count = 0;
 	unsigned int i;
+	sigset_t old;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -1020,6 +1027,7 @@ checkerloop (void *ap)
 	}
 
 	while (1) {
+		block_signal(SIGHUP, &old);
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(vecs->lock);
 		condlog(4, "tick");
@@ -1042,6 +1050,7 @@ checkerloop (void *ap)
 		}
 
 		lock_cleanup_pop(vecs->lock);
+		pthread_sigmask(SIG_SETMASK, &old, NULL);
 		sleep(1);
 	}
 	return NULL;
@@ -1358,6 +1367,7 @@ child (void * param)
 	/*
 	 * exit path
 	 */
+	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
 	remove_maps_and_stop_waiters(vecs);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
