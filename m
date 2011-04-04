From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/lock.h libmultipa ...
Date: 4 Apr 2011 19:48:48 -0000
Message-ID: <20110404194848.3889.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Changes by:	bmarzins@sourceware.org	2011-04-04 19:48:47

Modified files:
	libmultipath   : lock.h uevent.c 
	multipathd     : main.c 

Log message:
	Fix for bz #639429.  It was possible for multipathd threads to access freed
	data during shutdown. Now the threads call pthread_testcancel() after acquiring
	the vecs->lock to make sure they immediately shutdown.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/lock.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/uevent.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.33&r2=1.69.2.34

--- multipath-tools/libmultipath/lock.h	2008/08/27 19:14:57	1.1.2.1
+++ multipath-tools/libmultipath/lock.h	2011/04/04 19:48:46	1.1.2.2
@@ -16,7 +16,7 @@
 #else
 #define lock(a) pthread_mutex_lock(a)
 #define unlock(a) pthread_mutex_unlock(a)
-#define lock_cleanup_pop(a) pthread_cleanup_pop(1);
+#define lock_cleanup_pop(a) pthread_cleanup_pop(1) 
 #endif
 
 void cleanup_lock (void * data);
--- multipath-tools/libmultipath/uevent.c	2006/06/06 18:32:43	1.4
+++ multipath-tools/libmultipath/uevent.c	2011/04/04 19:48:46	1.4.2.1
@@ -100,6 +100,11 @@
 	}
 }
 
+void cancel_thread(void * data)
+{
+	pthread_cancel((pthread_t)data);
+}
+
 int uevent_listen(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		  void * trigger_data)
 {
@@ -130,6 +135,7 @@
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 64 * 1024);
 	pthread_create(&uevq_thr, &attr, uevq_thread, NULL);
+	pthread_cleanup_push(cancel_thread, (void *)uevq_thr);
 
 	memset(&snl, 0x00, sizeof(struct sockaddr_nl));
 	snl.nl_family = AF_NETLINK;
@@ -255,7 +261,7 @@
 	close(sock);
 
 	pthread_mutex_lock(uevq_lockp);
-	pthread_cancel(uevq_thr);
+	pthread_cleanup_pop(1);
 	pthread_mutex_unlock(uevq_lockp);
 
 	pthread_mutex_destroy(uevq_lockp);
--- multipath-tools/multipathd/main.c	2011/03/07 05:19:38	1.69.2.33
+++ multipath-tools/multipathd/main.c	2011/04/04 19:48:46	1.69.2.34
@@ -82,6 +82,7 @@
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
 
+int exitting = 0;
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -648,6 +649,7 @@
 
 	pthread_cleanup_push(cleanup_lock, vecs->lock);
 	lock(vecs->lock);
+	pthread_testcancel();
 
 	r = parse_cmd(str, reply, len, vecs);
 
@@ -696,7 +698,9 @@
 		return 0;
 
 	basenamecpy(uev->devpath, devname);
+	pthread_cleanup_push(cleanup_lock, vecs->lock);
 	lock(vecs->lock);
+	pthread_testcancel();
 
 	/*
 	 * device map event
@@ -736,6 +740,8 @@
 
 out:
 	unlock(vecs->lock);
+	lock_cleanup_pop(vecs->lock);
+/*	; */
 	return r;
 }
 
@@ -941,14 +947,15 @@
 {
 	int oldpriority;
 	struct pathgroup * pgp;
+	struct path *pp1;
 	int i, j, changed = 0;
 
 	if (refresh_all) {
 		vector_foreach_slot (pp->mpp->pg, pgp, i) {
-			vector_foreach_slot (pgp->paths, pp, j) {
-				oldpriority = pp->priority;
-				pathinfo(pp, conf->hwtable, DI_PRIO);
-				if (pp->priority != oldpriority)
+			vector_foreach_slot (pgp->paths, pp1, j) {
+				oldpriority = pp1->priority;
+				pathinfo(pp1, conf->hwtable, DI_PRIO);
+				if (pp1->priority != oldpriority)
 					changed = 1;
 			}
 		}
@@ -1012,6 +1019,7 @@
 		block_signal(SIGHUP, &old);
 		pthread_cleanup_push(cleanup_lock, vecs->lock);
 		lock(vecs->lock);
+		pthread_testcancel();
 		condlog(4, "tick");
 
 		vector_foreach_slot (vecs->pathvec, pp, i) {
@@ -1497,7 +1505,8 @@
 	condlog(2, "reconfigure (SIGHUP)");
 
 	lock(gvecs->lock);
-	reconfigure(gvecs);
+	if (!exitting);
+		reconfigure(gvecs);
 	unlock(gvecs->lock);
 
 #ifdef _DEBUG_
@@ -1698,6 +1707,7 @@
 	 */
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
+	exitting = 1;
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
