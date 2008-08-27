From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/lock.c libmultipa ...
Date: 27 Aug 2008 19:14:59 -0000
Message-ID: <20080827191459.10839.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-08-27 19:14:58

Modified files:
	libmultipath   : lock.c lock.h log_pthread.c waiter.c 
	multipathd     : main.c 

Log message:
	Fix a multipathd signal deadlock.  If multipathd is run with -v3, both the
	SIGHUP, and the SIGUSR1 signal handlers will log a message.  If a multipathd
	thread receives one of these signals while it has a log lock held, it deadlocks
	itself. Also, the SIGHUP handler will grab the vecs lock, so if any thread
	receives a SIGHUP while holding the vecs lock, it deadlocks itself.  This
	commit blocks the appropriate signals to guard against this.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/lock.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/lock.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/log_pthread.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.7&r2=1.69.2.8

--- multipath-tools/libmultipath/lock.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/lock.c	2008/08/27 19:14:57	1.1.2.1
@@ -1,6 +1,15 @@
 #include <pthread.h>
+#include <signal.h>
 #include "lock.h"
 
+void block_signal(int signum, sigset_t *old)
+{
+	sigset_t set;
+	sigemptyset(&set);
+	sigaddset(&set, signum);
+	pthread_sigmask(SIG_BLOCK, &set, old);
+}	
+
 void cleanup_lock (void * data)
 {
 	unlock((pthread_mutex_t *)data);
--- multipath-tools/libmultipath/lock.h	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/lock.h	2008/08/27 19:14:57	1.1.2.1
@@ -1,6 +1,8 @@
 #ifndef _LOCK_H
 #define _LOCK_H
 
+#include <signal.h>
+
 #ifdef LCKDBG
 #define lock(a) \
 	        fprintf(stderr, "%s:%s(%i) lock %p\n", __FILE__, __FUNCTION__, __LINE__, a); \
@@ -18,5 +20,6 @@
 #endif
 
 void cleanup_lock (void * data);
+void block_signal(int signum, sigset_t *old);
 
 #endif /* _LOCK_H */
--- multipath-tools/libmultipath/log_pthread.c	2007/06/15 19:03:02	1.1.2.1
+++ multipath-tools/libmultipath/log_pthread.c	2008/08/27 19:14:57	1.1.2.2
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
 	//va_start(ap, fmt);
 	log_enqueue(prio, fmt, ap);
@@ -23,6 +29,8 @@
 	pthread_mutex_lock(logev_lock);
 	pthread_cond_signal(logev_cond);
 	pthread_mutex_unlock(logev_lock);
+
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
 }
 
 static void flush_logqueue (void)
--- multipath-tools/libmultipath/waiter.c	2007/06/15 19:03:02	1.1.2.1
+++ multipath-tools/libmultipath/waiter.c	2008/08/27 19:14:57	1.1.2.2
@@ -32,11 +32,13 @@
 
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
@@ -48,6 +50,7 @@
 		condlog(3, "free_waiter, mpp freed before wp=%p,", wp);
 
 	unlock(wp->vecs->lock);
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
 
 	if (wp->dmt)
 		dm_task_destroy(wp->dmt);
--- multipath-tools/multipathd/main.c	2008/05/12 18:48:03	1.69.2.7
+++ multipath-tools/multipathd/main.c	2008/08/27 19:14:58	1.69.2.8
@@ -705,6 +705,9 @@
 static void *
 ueventloop (void * ap)
 {
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
+
 	if (uevent_listen(&uev_trigger, ap))
 		fprintf(stderr, "error starting uevent listener");
 		
@@ -720,6 +723,9 @@
 	if (alloc_handlers())
 		return NULL;
 
+	block_signal(SIGUSR1, NULL);
+	block_signal(SIGHUP, NULL);
+
 	add_handler(LIST+PATHS, cli_list_paths);
 	add_handler(LIST+MAPS, cli_list_maps);
 	add_handler(LIST+MAPS+STATUS, cli_list_maps_status);
@@ -880,6 +886,7 @@
 	int count = 0;
 	int newstate;
 	unsigned int i;
+	sigset_t old;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -893,6 +900,7 @@
 	}
 
 	while (1) {
+		block_signal(SIGHUP, &old);
 		pthread_cleanup_push(cleanup_lock, vecs->lock);
 		lock(vecs->lock);
 		condlog(4, "tick");
@@ -1051,6 +1059,7 @@
 		}
 		
 		lock_cleanup_pop(vecs->lock);
+		pthread_sigmask(SIG_SETMASK, &old, NULL);
 		sleep(1);
 	}
 	return NULL;
@@ -1532,6 +1541,7 @@
 	/*
 	 * exit path
 	 */
+	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
 	remove_maps(vecs, stop_waiter_thread);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
