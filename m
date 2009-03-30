From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/log_pthread.c lib ...
Date: 30 Mar 2009 19:58:41 -0000
Message-ID: <20090330195841.25175.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-03-30 19:58:40

Modified files:
	libmultipath   : log_pthread.c waiter.c 
	multipathd     : main.c 

Log message:
	Fixes for bzs 465117 and 474627.  I've alreay posted the upstream patch for
	465117 and 474627 is not an issue upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/log_pthread.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.2&r2=1.1.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.3&r2=1.1.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.15&r2=1.69.2.16

--- multipath-tools/libmultipath/log_pthread.c	2008/08/27 19:14:57	1.1.2.2
+++ multipath-tools/libmultipath/log_pthread.c	2009/03/30 19:58:38	1.1.2.3
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <pthread.h>
 #include <sys/mman.h>
+#include <limits.h>
 
 #include <memory.h>
 
@@ -61,6 +62,7 @@
 
 void log_thread_start (void)
 {
+	size_t stacksize = 64 * 1024;
 	pthread_attr_t attr;
 	
 	logdbg(stderr,"enter log_thread_start\n");
@@ -74,7 +76,9 @@
 	pthread_cond_init(logev_cond, NULL);
 	
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 
 	if (log_init("multipathd", 0)) {
 		fprintf(stderr,"can't initialize log buffer\n");
--- multipath-tools/libmultipath/waiter.c	2008/09/08 22:01:20	1.1.2.3
+++ multipath-tools/libmultipath/waiter.c	2009/03/30 19:58:39	1.1.2.4
@@ -199,6 +199,7 @@
 
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
+	size_t stacksize = 32 * 1024;
 	pthread_attr_t attr;
 	struct event_thread *wp;
 
@@ -208,7 +209,9 @@
 	if (pthread_attr_init(&attr))
 		goto out;
 
-	pthread_attr_setstacksize(&attr, 32 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
 	wp = alloc_waiter();
--- multipath-tools/multipathd/main.c	2009/03/26 03:28:09	1.69.2.15
+++ multipath-tools/multipathd/main.c	2009/03/30 19:58:40	1.69.2.16
@@ -362,6 +362,7 @@
 	struct path * pp;
 	char empty_buff[WWID_SIZE] = {0};
 	int ret;
+	int retrys = 10;
 
 	ret = device_ok_to_add(devname);
 	if (ret < 0)
@@ -439,9 +440,10 @@
 		/*
  		 * deal with asynchronous uevents :((
  		 */
-		if (mpp->action == ACT_RELOAD) {
+		if (mpp->action == ACT_RELOAD & retrys > 0) {
 			condlog(0, "%s: uev_add_path sleep", mpp->alias);
 			sleep(1);
+			retrys--;
 			update_mpp_paths(mpp, vecs->pathvec);
 			goto rescan;
 		}
@@ -1243,7 +1245,6 @@
 static int
 unmount_extra_devs(void)
 {
-	int ret;
 	char buf[LINE_MAX];
 	FILE *file;
 
@@ -1276,7 +1277,7 @@
 		}
 	}
 	fclose(file);
-	return ret;
+	return 0;
 }	
 	
 	
@@ -1514,6 +1515,7 @@
 static int
 child (void * param)
 {
+	size_t stacksize = 64 * 1024;
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t attr;
 	struct vectors * vecs;
@@ -1594,7 +1596,9 @@
 	 * start threads
 	 */
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 	
 	pthread_create(&check_thr, &attr, checkerloop, vecs);
