From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/devmapper.c libmu ...
Date: 3 Apr 2009 15:09:05 -0000
Message-ID: <20090403150905.2617.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-03 15:09:03

Modified files:
	libmultipath   : devmapper.c dmparser.c hwtable.c pgpolicies.c 
	                 waiter.c waiter.h 
	multipathd     : main.c 

Log message:
	Fix for bz #459629.  Multipathd needs to wait for the waiter threads to finish
	before freeing the vecs locks.  This bug has already been fixed upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.6&r2=1.22.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dmparser.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.13&r2=1.13.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.16&r2=1.20.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/pgpolicies.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.4&r2=1.1.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.16&r2=1.69.2.17

--- multipath-tools/libmultipath/devmapper.c	2008/09/19 03:27:08	1.22.2.6
+++ multipath-tools/libmultipath/devmapper.c	2009/04/03 15:09:02	1.22.2.7
@@ -716,6 +716,7 @@
 	vector vec;
 	struct multipath *mpp;
 	int i;
+	int ret = 0;
 
 	vec = vector_alloc();
 
@@ -723,20 +724,20 @@
 		return 0;
 
 	if (dm_get_maps(vec, type)) {
-		vector_free(vec);
+		free_multipathvec(vec, FREE_PATHS);
 		return 0;
 	}
 
 	vector_foreach_slot(vec, mpp, i) {
 		if (!strcmp(uuid, mpp->wwid)) {
-			vector_free(vec);
 			strcpy(name, mpp->alias);
-			return 1;
+			ret = 1;
+			break;
 		}
 	}
 
-	vector_free(vec);
-	return 0;
+	free_multipathvec(vec, FREE_PATHS);
+	return ret;
 }
 
 int
--- multipath-tools/libmultipath/dmparser.c	2006/11/30 23:25:13	1.13
+++ multipath-tools/libmultipath/dmparser.c	2009/04/03 15:09:02	1.13.2.1
@@ -329,6 +329,7 @@
 	FREE(word);
 out:
 	free_pgvec(mpp->pg, KEEP_PATHS);
+	mpp->pg=NULL;
 	return 1;
 }
 
--- multipath-tools/libmultipath/hwtable.c	2008/12/02 20:24:24	1.20.2.16
+++ multipath-tools/libmultipath/hwtable.c	2009/04/03 15:09:02	1.20.2.17
@@ -169,7 +169,7 @@
                 .no_path_retry = 12,
                 .minio         = 100,
                 .checker_name  = TUR,
-	}
+	},
 	{
 		.vendor        = "HP",
 		.product       = "A6189A",
--- multipath-tools/libmultipath/pgpolicies.c	2006/06/06 18:32:43	1.7
+++ multipath-tools/libmultipath/pgpolicies.c	2009/04/03 15:09:02	1.7.2.1
@@ -127,6 +127,7 @@
 	FREE(bitmap);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -198,6 +199,7 @@
 	FREE(bitmap);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -232,6 +234,7 @@
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -264,6 +267,7 @@
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -338,6 +342,7 @@
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 
 }
--- multipath-tools/libmultipath/waiter.c	2009/03/30 19:58:39	1.1.2.4
+++ multipath-tools/libmultipath/waiter.c	2009/04/03 15:09:02	1.1.2.5
@@ -20,6 +20,9 @@
 #include "lock.h"
 #include "waiter.h"
 
+pthread_cond_t waiter_cond = PTHREAD_COND_INITIALIZER;
+int num_waiters = 0; /* protected by the vecs lock */
+
 struct event_thread *alloc_waiter (void)
 {
 
@@ -49,6 +52,8 @@
 	else
 		condlog(3, "free_waiter, mpp freed before wp=%p,", wp);
 
+	num_waiters--;
+	pthread_cond_signal(&waiter_cond);
 	unlock(wp->vecs->lock);
 	pthread_sigmask(SIG_SETMASK, &old, NULL);
 
@@ -223,6 +228,7 @@
 	strncpy(wp->mapname, mpp->alias, WWID_SIZE);
 	wp->vecs = vecs;
 	wp->mpp = mpp;
+	num_waiters++;
 
 	if (pthread_create(&wp->thread, &attr, waitevent, wp)) {
 		condlog(0, "%s: cannot create event checker", wp->mapname);
@@ -232,7 +238,8 @@
 
 	return 0;
 out1:
-	free_waiter(wp);
+	num_waiters--;
+	FREE(wp);
 	mpp->waiter = NULL;
 out:
 	condlog(0, "failed to start waiter thread");
--- multipath-tools/libmultipath/waiter.h	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/waiter.h	2009/04/03 15:09:02	1.1.2.1
@@ -3,6 +3,9 @@
 
 #if DAEMON
 
+extern pthread_cond_t waiter_cond;
+extern int num_waiters;
+
 struct event_thread {
 	struct dm_task *dmt;
 	pthread_t thread;
--- multipath-tools/multipathd/main.c	2009/03/30 19:58:40	1.69.2.16
+++ multipath-tools/multipathd/main.c	2009/04/03 15:09:03	1.69.2.17
@@ -440,7 +440,7 @@
 		/*
  		 * deal with asynchronous uevents :((
  		 */
-		if (mpp->action == ACT_RELOAD & retrys > 0) {
+		if (mpp->action == ACT_RELOAD && retrys > 0) {
 			condlog(0, "%s: uev_add_path sleep", mpp->alias);
 			sleep(1);
 			retrys--;
@@ -1524,7 +1524,7 @@
 	unsigned int new_ns = (unsigned long)param & NEW_NS;
 #endif
 	struct multipath * mpp;
-	int i;
+	int i, ret;
 
 	if (daemon)
 		setup_daemon();
@@ -1617,6 +1617,7 @@
 			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps(vecs, stop_waiter_thread);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
+	vecs->pathvec=NULL;
 
 	pthread_cancel(check_thr);
 	pthread_cancel(uevent_thr);
@@ -1628,6 +1629,14 @@
 	handlers = NULL;
 	free_polls();
 
+	ret = 0;
+	while (num_waiters > 0 && ret == 0)
+		ret = pthread_cond_wait(&waiter_cond, vecs->lock);
+	if (ret) {
+		condlog(0, "error while waiting for event threads: %s",
+			strerror(errno));
+		exit(1);
+	}
 	unlock(vecs->lock);
 	pthread_mutex_destroy(vecs->lock);
 	FREE(vecs->lock);
