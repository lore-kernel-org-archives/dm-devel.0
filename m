From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 2/3] set pthread stack size to at least
	PTHREAD_STACK_MIN
Date: Fri, 13 Mar 2009 15:55:14 -0500
Message-ID: <20090313205514.GL32340@ether.msp.redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>
	<49BA3ACF.1010101@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49BA3ACF.1010101@suse.de>
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

> Hmm. I don't quite agree. I run into the same problem, but having
> discovered that we're not checking any return values at all here
> we should rather do the prudent thing and check them once and for all.
>
> I've chosen this approach:
>
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index 9e9aebe..c33480e 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -53,9 +53,30 @@ static void * log_thread (void * et)
> void log_thread_start (void)
> {
>        pthread_attr_t attr;
> +       size_t stacksize;
>
>        logdbg(stderr,"enter log_thread_start\n");
>
> +       if (pthread_attr_init(&attr)) {
> +               fprintf(stderr,"can't initialize log thread\n");
> +               exit(1);
> +       }
> +
> +       if (pthread_attr_getstacksize(&attr, &stacksize) != 0)
> +               stacksize = PTHREAD_STACK_MIN:
> +
> +       /* Check if the stacksize is large enough */
> +       if (stacksize < (64 * 1024))
> +               stacksize = 64 * 1024;
> +
> +       /* Set stacksize and try to reinitialize attr if failed */
> +       if (stacksize > PTHREAD_STACK_MIN &&
> +           pthread_attr_setstacksize(&attr, stacksize) != 0 &&
> +           pthread_attr_init(&attr)) {
> +               fprintf(stderr,"can't set log thread stack size\n");
> +               exit(1);
> +       }
> +
>        logq_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
>        logev_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
>        logev_cond = (pthread_cond_t *) malloc(sizeof(pthread_cond_t));
> @@ -64,9 +85,6 @@ void log_thread_start (void)
>        pthread_mutex_init(logev_lock, NULL);
>        pthread_cond_init(logev_cond, NULL);
>
> -       pthread_attr_init(&attr);
> -       pthread_attr_setstacksize(&attr, 64 * 1024);
> -
>        if (log_init("multipathd", 0)) {
>                fprintf(stderr,"can't initialize log buffer\n");
>                exit(1);
>
>
> This way we'll at least be notified if something goes wrong in
> the future. We shouldn't make the same mistake again and
> ignore error codes which don't happen to trigger now.
>
> If agreed I'll post the full patch here.

This approach doesn't doesn't actually fix the bug that I see. The
problem I was seeing is that setting the stacksize too small just causes
pthread_attr_setstacksize() to fail, leaving you with the default stack
size. On some architectures, the default stacksize is large, like 10Mb.
Since you start one waiter thread per multipath device, every 100
devices eats up 1Gb of memory. Your approach always uses the default
stack size, unless it's too small.  I've never seen problems with the
stack being too small. Only too large. Maybe your experience has been
different.

The other problem is that when I actually read the pthread_attr_init man
page (it can fail. who knew?), I saw that it can fail with ENOMEM. Also,
that it had a function to free it, and that the result of reinitializing
an attr that hadn't been freed was undefined.  Clearly, this function
wasn't intended to be called over and over without ever freeing the
attr, which is how we've been using it in multipathd. So, in the spirit
of writing code to the interface, instead of to how it appears to be
currently implemented, how about this.
---
 libmultipath/log_pthread.c |    9 +-------
 libmultipath/log_pthread.h |    4 ++-
 libmultipath/waiter.c      |   11 ++--------
 libmultipath/waiter.h      |    2 +
 multipathd/main.c          |   48 +++++++++++++++++++++++++++++++++++----------
 5 files changed, 48 insertions(+), 26 deletions(-)

Index: multipath-tools-090311/libmultipath/waiter.c
===================================================================
--- multipath-tools-090311.orig/libmultipath/waiter.c
+++ multipath-tools-090311/libmultipath/waiter.c
@@ -20,6 +20,8 @@
 #include "lock.h"
 #include "waiter.h"
 
+pthread_attr_t waiter_attr;
+
 struct event_thread *alloc_waiter (void)
 {
 
@@ -194,18 +196,11 @@ void *waitevent (void *et)
 
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
-	pthread_attr_t attr;
 	struct event_thread *wp;
 
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
@@ -216,7 +211,7 @@ int start_waiter_thread (struct multipat
 	wp->vecs = vecs;
 	wp->mpp = mpp;
 
-	if (pthread_create(&wp->thread, &attr, waitevent, wp)) {
+	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
 		condlog(0, "%s: cannot create event checker", wp->mapname);
 		goto out1;
 	}
Index: multipath-tools-090311/multipathd/main.c
===================================================================
--- multipath-tools-090311.orig/multipathd/main.c
+++ multipath-tools-090311/multipathd/main.c
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <limits.h>
 
 /*
  * libcheckers
@@ -1264,17 +1265,47 @@ set_oom_adj (int val)
 	fclose(fp);
 }
 
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
+
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
+	if (logsink) {
+		setup_thread_attr(&log_attr, 64 * 1024, 0);
+		log_thread_start(&log_attr);
+		pthread_attr_destroy(&log_attr);
+	}
 
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
@@ -1346,13 +1377,10 @@ child (void * param)
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
 
Index: multipath-tools-090311/libmultipath/log_pthread.c
===================================================================
--- multipath-tools-090311.orig/libmultipath/log_pthread.c
+++ multipath-tools-090311/libmultipath/log_pthread.c
@@ -50,10 +50,8 @@ static void * log_thread (void * et)
 	}
 }
 
-void log_thread_start (void)
+void log_thread_start (pthread_attr_t *attr)
 {
-	pthread_attr_t attr;
-
 	logdbg(stderr,"enter log_thread_start\n");
 
 	logq_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
@@ -64,14 +62,11 @@ void log_thread_start (void)
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
Index: multipath-tools-090311/libmultipath/log_pthread.h
===================================================================
--- multipath-tools-090311.orig/libmultipath/log_pthread.h
+++ multipath-tools-090311/libmultipath/log_pthread.h
@@ -1,6 +1,8 @@
 #ifndef _LOG_PTHREAD_H
 #define _LOG_PTHREAD_H
 
+#include <pthread.h>
+
 pthread_t log_thr;
 
 pthread_mutex_t *logq_lock;
@@ -8,7 +10,7 @@ pthread_mutex_t *logev_lock;
 pthread_cond_t *logev_cond;
 
 void log_safe(int prio, const char * fmt, va_list ap);
-void log_thread_start(void);
+void log_thread_start(pthread_attr_t *attr);
 void log_thread_stop(void);
 
 #endif /* _LOG_PTHREAD_H */
Index: multipath-tools-090311/libmultipath/waiter.h
===================================================================
--- multipath-tools-090311.orig/libmultipath/waiter.h
+++ multipath-tools-090311/libmultipath/waiter.h
@@ -1,6 +1,8 @@
 #ifndef _WAITER_H
 #define _WAITER_H
 
+extern pthread_attr_t waiter_attr;
+
 struct event_thread {
 	struct dm_task *dmt;
 	pthread_t thread;
