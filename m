From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix shutdown crashes
Date: Fri, 10 Feb 2012 12:10:11 -0600
Message-ID: <20120210181011.GM1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

A number of processes don't reach a pthread cancellation point
before they use the pathvec or mpvec vectors, after they've
locked the vecs lock.  This can cause crashes on shutdown, since
these vectors are deallocated.  Also, the log thread accesses a
number of resources which may have been deallocated during shutdown
without holding any locks. This patch avoids these issues by
adding pthread_testcancel() checks after acquiring the vecs lock,
and having the child process make sure the log thread has exitted
before deallocating the resources.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log_pthread.c |    1 +
 libmultipath/waiter.c      |    1 +
 multipathd/main.c          |    6 +++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: multipath-tools-120123/multipathd/main.c
===================================================================
--- multipath-tools-120123.orig/multipathd/main.c
+++ multipath-tools-120123/multipathd/main.c
@@ -729,6 +729,7 @@ uxsock_trigger (char * str, char ** repl
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
+	pthread_testcancel();
 
 	r = parse_cmd(str, reply, len, vecs);
 
@@ -781,7 +782,9 @@ uev_trigger (struct uevent * uev, void *
 	if (uev_discard(uev->devpath))
 		return 0;
 
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
+	pthread_testcancel();
 
 	/*
 	 * device map event
@@ -821,7 +824,7 @@ uev_trigger (struct uevent * uev, void *
 	}
 
 out:
-	unlock(vecs->lock);
+	lock_cleanup_pop(vecs->lock);
 	return r;
 }
 
@@ -1261,6 +1264,7 @@ checkerloop (void *ap)
 		block_signal(SIGHUP, &old);
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(vecs->lock);
+		pthread_testcancel();
 		condlog(4, "tick");
 
 		if (vecs->pathvec) {
Index: multipath-tools-120123/libmultipath/waiter.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/waiter.c
+++ multipath-tools-120123/libmultipath/waiter.c
@@ -157,6 +157,7 @@ int waiteventloop (struct event_thread *
 		 */
 		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
 		lock(waiter->vecs->lock);
+		pthread_testcancel();
 		r = update_multipath(waiter->vecs, waiter->mapname, 1);
 		lock_cleanup_pop(waiter->vecs->lock);
 
Index: multipath-tools-120123/libmultipath/log_pthread.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/log_pthread.c
+++ multipath-tools-120123/libmultipath/log_pthread.c
@@ -87,6 +87,7 @@ void log_thread_stop (void)
 	pthread_mutex_lock(logq_lock);
 	pthread_cancel(log_thr);
 	pthread_mutex_unlock(logq_lock);
+	pthread_join(log_thr, NULL);
 
 	flush_logqueue();
 
