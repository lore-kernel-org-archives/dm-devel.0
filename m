From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd log_pthread.c log_p ...
Date: 1 Sep 2009 20:38:41 -0000
Message-ID: <20090901203841.4863.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2009-09-01 20:38:40

Modified files:
	multipathd     : log_pthread.c log_pthread.h main.c 

Log message:
	Fix for bz #516253. Port pthread stacksize fix from upstream to RHEL4.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/log_pthread.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/log_pthread.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.6&r2=1.66.2.7

--- multipath-tools/multipathd/Attic/log_pthread.c	2005/11/16 20:24:58	1.5
+++ multipath-tools/multipathd/Attic/log_pthread.c	2009/09/01 20:38:40	1.5.2.1
@@ -51,10 +51,8 @@
 	}
 }
 
-void log_thread_start (void)
+void log_thread_start (pthread_attr_t *attr)
 {
-	pthread_attr_t attr;
-	
 	logdbg(stderr,"enter log_thread_start\n");
 
 	logq_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
@@ -65,14 +63,11 @@
 	pthread_mutex_init(logev_lock, NULL);
 	pthread_cond_init(logev_cond, NULL);
 	
-	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
-
 	if (log_init("multipathd", 0)) {
 		fprintf(stderr,"can't initialize log buffer\n");
 		exit(1);
 	}
-	pthread_create(&log_thr, &attr, log_thread, NULL);
+	pthread_create(&log_thr, attr, log_thread, NULL);
 
 	return;
 }
--- multipath-tools/multipathd/Attic/log_pthread.h	2005/06/08 19:40:10	1.2
+++ multipath-tools/multipathd/Attic/log_pthread.h	2009/09/01 20:38:40	1.2.2.1
@@ -1,6 +1,8 @@
 #ifndef _LOG_PTHREAD_H
 #define _LOG_PTHREAD_H
 
+#include <pthread.h>
+
 pthread_t log_thr;
 
 pthread_mutex_t *logq_lock;
@@ -8,7 +10,7 @@
 pthread_cond_t *logev_cond;
 
 void log_safe(int prio, char * fmt, va_list ap);
-void log_thread_start(void);
+void log_thread_start(pthread_attr_t *attr);
 void log_thread_stop(void);
 
 #endif /* _LOG_PTHREAD_H */
--- multipath-tools/multipathd/main.c	2009/01/17 00:46:52	1.66.2.6
+++ multipath-tools/multipathd/main.c	2009/09/01 20:38:40	1.66.2.7
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <limits.h>
 
 /*
  * libsysfs
@@ -85,6 +86,7 @@
 
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
+pthread_attr_t waiter_attr;
 
 /*
  * structs
@@ -646,18 +648,11 @@
 static int
 start_waiter_thread (struct multipath * mpp, struct vectors * vecs)
 {
-	pthread_attr_t attr;
 	struct event_thread * wp;
 
 	if (!mpp)
 		return 0;
 
-	if (pthread_attr_init(&attr))
-		goto out;
-
-	pthread_attr_setstacksize(&attr, 32 * 1024);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
-
 	wp = alloc_waiter();
 
 	if (!wp)
@@ -667,7 +662,7 @@
 	strncpy(wp->mapname, mpp->alias, WWID_SIZE);
 	wp->vecs = vecs;
 
-	if (pthread_create(&wp->thread, &attr, waitevent, wp)) {
+	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
 		condlog(0, "%s: cannot create event checker", wp->mapname);
 		goto out1;
 	}
@@ -1594,18 +1589,48 @@
 	fprintf(fp, "%i", val);
 	fclose(fp);
 }
+
+void
+setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
+{
+	if (pthread_attr_init(attr)) {
+		fprintf(stderr, "can't initialize thread attr: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+
+	if (pthread_attr_setstacksize(attr, stacksize)) {
+		fprintf(stderr, "can't set thread stack size to %lu: %s\n",
+			(unsigned long)stacksize, strerror(errno));
+		exit(1);
+	}
+	if (detached && pthread_attr_setdetachstate(attr,
+						    PTHREAD_CREATE_DETACHED)) {
+		fprintf(stderr, "can't set thread to detached: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+}
 	
 static int
 child (void * param)
 {
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
-	pthread_attr_t attr;
+	pthread_attr_t log_attr, misc_attr;
 	struct vectors * vecs;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 
-	if (logsink)
-		log_thread_start();
+	setup_thread_attr(&misc_attr, 64 * 1024, 1);
+	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
+	
+	if (logsink){
+		setup_thread_attr(&log_attr, 64 * 1024, 0);
+		log_thread_start(&log_attr);
+		pthread_attr_destroy(&log_attr);
+	}
 
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
@@ -1665,13 +1690,10 @@
 	/*
 	 * start threads
 	 */
-	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
-	
-	pthread_create(&check_thr, &attr, checkerloop, vecs);
-	pthread_create(&uevent_thr, &attr, ueventloop, vecs);
-	pthread_create(&uxlsnr_thr, &attr, uxlsnrloop, vecs);
+	pthread_create(&check_thr, &misc_attr, checkerloop, vecs);
+	pthread_create(&uevent_thr, &misc_attr, ueventloop, vecs);
+	pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs);
+	pthread_attr_destroy(&misc_attr);
 
 	pthread_cond_wait(&exit_cond, &exit_mutex);
 
