From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/configure.c libmu ...
Date: 15 Jun 2007 19:03:04 -0000
Message-ID: <20070615190304.3184.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-15 19:03:02

Modified files:
	libmultipath   : configure.c debug.c debug.h devmapper.c 
	                 devmapper.h log_pthread.c log_pthread.h 
	                 structs_vec.c waiter.c 
	multipath      : main.c 
	multipathd     : main.c 

Log message:
	Pulled in some upstream fixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/debug.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/debug.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22&r2=1.22.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11&r2=1.11.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/log_pthread.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/log_pthread.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/waiter.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.1&r2=1.44.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.1&r2=1.69.2.2

--- multipath-tools/libmultipath/configure.c	2006/07/13 20:35:22	1.2
+++ multipath-tools/libmultipath/configure.c	2007/06/15 19:03:02	1.2.2.1
@@ -324,7 +324,6 @@
 				mpp->alias);
 			return DOMAP_RETRY;
 		}
-		dm_shut_log();
 
 		if (dm_map_present(mpp->alias))
 			break;
@@ -345,7 +344,6 @@
 		}
 
 		lock_multipath(mpp, 0);
-		dm_restore_log();
 		break;
 
 	case ACT_RELOAD:
--- multipath-tools/libmultipath/debug.c	2006/08/02 21:37:22	1.7
+++ multipath-tools/libmultipath/debug.c	2007/06/15 19:03:02	1.7.2.1
@@ -14,7 +14,7 @@
 #include "vector.h"
 #include "config.h"
 
-void dlog (int sink, int prio, char * fmt, ...)
+void dlog (int sink, int prio, const char * fmt, ...)
 {
 	va_list ap;
 	int thres;
--- multipath-tools/libmultipath/debug.h	2006/08/02 21:37:22	1.5
+++ multipath-tools/libmultipath/debug.h	2007/06/15 19:03:02	1.5.2.1
@@ -1,4 +1,4 @@
-void dlog (int sink, int prio, char * fmt, ...)
+void dlog (int sink, int prio, const char * fmt, ...)
 	__attribute__((format(printf, 3, 4)));
 
 #if DAEMON
--- multipath-tools/libmultipath/devmapper.c	2006/11/28 15:46:21	1.22
+++ multipath-tools/libmultipath/devmapper.c	2007/06/15 19:03:02	1.22.2.1
@@ -20,6 +20,13 @@
 #include "debug.h"
 #include "memory.h"
 #include "devmapper.h"
+#include "config.h"
+
+#if DAEMON
+#include "log_pthread.h"
+#include <sys/types.h>
+#include <time.h>
+#endif
 
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
@@ -29,21 +36,50 @@
 
 
 static void
-dm_dummy_log (int level, const char *file, int line, const char *f, ...)
+dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
-	return;
-}
+	va_list ap;
+	int thres;
 
-void
-dm_restore_log (void)
-{
-	dm_log_init(NULL);
+	if (level > 6)
+		level = 6;
+
+	thres = (conf) ? conf->verbosity : 0;
+	if (thres <= 3 || level > thres)
+		return;
+
+        va_start(ap, f);
+#if DAEMON
+	if (!logsink) {
+		time_t t = time(NULL);
+		struct tm *tb = localtime(&t);
+		char buff[16];
+
+		strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
+		buff[sizeof(buff)-1] = '\0';
+
+		fprintf(stdout, "%s | ", buff);
+		fprintf(stdout, "libdevmapper: %s(%i): ", file, line);
+		vfprintf(stdout, f, ap);
+		fprintf(stdout, "\n");
+	} else {
+		condlog(level, "libdevmapper: %s(%i): ", file, line);
+		log_safe(level + 3, f, ap);
+	}
+#else
+	fprintf(stdout, "libdevmapper: %s(%i): ", file, line);
+	vfprintf(stdout, f, ap);
+	fprintf(stdout, "\n");
+#endif
+        va_end(ap);
+
+	return;
 }
 
-void
-dm_shut_log (void)
-{
-	dm_log_init(&dm_dummy_log);
+extern void
+dm_init(void) {
+	dm_log_init(&dm_write_log);
+	dm_log_init_verbose(conf ? conf->verbosity + 3 : 0);
 }
 
 extern int
@@ -733,9 +769,7 @@
 	 * daemon uev_trigger -> uev_add_map
 	 */
 	while (--loop) {
-		dm_shut_log();
 		r = dm_task_run(dmt);
-		dm_restore_log();
 
 		if (r)
 			break;
--- multipath-tools/libmultipath/devmapper.h	2006/06/06 18:32:43	1.11
+++ multipath-tools/libmultipath/devmapper.h	2007/06/15 19:03:02	1.11.2.1
@@ -1,5 +1,4 @@
-void dm_shut_log(void);
-void dm_restore_log(void);
+void dm_init(void);
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
--- multipath-tools/libmultipath/log_pthread.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/log_pthread.c	2007/06/15 19:03:02	1.1.2.1
@@ -12,7 +12,7 @@
 #include "log_pthread.h"
 #include "log.h"
 
-void log_safe (int prio, char * fmt, va_list ap)
+void log_safe (int prio, const char * fmt, va_list ap)
 {
 	pthread_mutex_lock(logq_lock);
 	//va_start(ap, fmt);
--- multipath-tools/libmultipath/log_pthread.h	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/log_pthread.h	2007/06/15 19:03:02	1.1.2.1
@@ -7,7 +7,7 @@
 pthread_mutex_t *logev_lock;
 pthread_cond_t *logev_cond;
 
-void log_safe(int prio, char * fmt, va_list ap);
+void log_safe(int prio, const char * fmt, va_list ap);
 void log_thread_start(void);
 void log_thread_stop(void);
 
--- multipath-tools/libmultipath/structs_vec.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/structs_vec.c	2007/06/15 19:03:02	1.1.2.1
@@ -16,7 +16,6 @@
 #include "discovery.h"
 #include "waiter.h"
 
-
 /*
  * creates or updates mpp->paths reading mpp->pg
  */
@@ -118,6 +117,8 @@
 {
 	int i;
 
+	condlog(4, "%s: remove multipath map", mpp->alias);
+
 	/*
 	 * stop the DM event waiter thread
 	 */
@@ -245,8 +246,17 @@
 setup_multipath (struct vectors * vecs, struct multipath * mpp)
 {
 retry:
-	if (dm_get_info(mpp->alias, &mpp->dmi))
+	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+		/* Error accessing table */
+		condlog(3, "%s: cannot access table", mpp->alias); 
+		goto out;
+	}
+
+	if (!dm_map_present(mpp->alias)) {
+		/* Table has been removed */
+		condlog(3, "%s: table does not exist", mpp->alias); 
 		goto out;
+	}
 
 	set_multipath_wwid(mpp);
 	mpp->mpe = find_mpe(mpp->wwid);
@@ -270,6 +280,7 @@
 #endif
 			goto retry;
 		}
+		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
 
@@ -282,7 +293,6 @@
 
 	return 0;
 out:
-	condlog(0, "%s: failed to setup multipath", mpp->alias);
 	remove_map(mpp, vecs, NULL, 1);
 	return 1;
 }
@@ -390,18 +400,19 @@
 	struct pathgroup  *pgp;
 	struct path *pp;
 	int i, j;
-	int r = 1;
 
 	mpp = find_mp_by_alias(vecs->mpvec, mapname);
 
-	if (!mpp)
-		goto out;
+	if (!mpp) {
+		condlog(3, "%s: multipath map not found\n", mapname);
+		return 2;
+	}
 
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
 
 	if (setup_multipath(vecs, mpp))
-		goto out; /* mpp freed in setup_multipath */
+		return 1; /* mpp freed in setup_multipath */
 
 	/*
 	 * compare checkers states with DM states
@@ -429,11 +440,8 @@
 			}
 		}
 	}
-	r = 0;
-out:
-	if (r)
-		condlog(0, "failed to update multipath");
-	return r;
+
+	return 0;
 }
 
 /*
--- multipath-tools/libmultipath/waiter.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/waiter.c	2007/06/15 19:03:02	1.1.2.1
@@ -117,15 +117,11 @@
 	/* accept wait interruption */
 	set = unblock_signals();
 
-	/* interruption spits messages */
-	dm_shut_log();
-
 	/* wait */
 	r = dm_task_run(waiter->dmt);
 
 	/* wait is over : event or interrupt */
 	pthread_sigmask(SIG_SETMASK, &set, NULL);
-	//dm_restore_log();
 
 	if (!r) /* wait interrupted by signal */
 		return -1;
@@ -157,8 +153,11 @@
 		r = update_multipath(waiter->vecs, waiter->mapname);
 		lock_cleanup_pop(waiter->vecs->lock);
 
-		if (r)
+		if (r) {
+			condlog(2, "%s: event checker exit", 
+				waiter->mapname);
 			return -1; /* stop the thread */
+		}
 
 		event_nr = dm_geteventnr(waiter->mapname);
 
--- multipath-tools/multipath/main.c	2007/01/10 20:08:08	1.44.2.1
+++ multipath-tools/multipath/main.c	2007/06/15 19:03:02	1.44.2.2
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.1 2007/01/10 20:08:08 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.2 2007/06/15 19:03:02 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -395,6 +395,7 @@
 			conf->dev_type = DEV_DEVMAP;
 
 	}
+	dm_init();
 
 	if (conf->remove == FLUSH_ONE) {
 		if (conf->dev_type == DEV_DEVMAP)
--- multipath-tools/multipathd/main.c	2007/01/10 20:08:09	1.69.2.1
+++ multipath-tools/multipathd/main.c	2007/06/15 19:03:02	1.69.2.2
@@ -225,6 +225,8 @@
 	int map_present;
 	int r = 1;
 
+	/* libsysfs seems to forget to terminate the string... */
+	memset(dev_t, 0, BLK_DEV_SIZE);
 	if (sscanf(devname, "dm-%d", &minor) == 1 &&
 	    !sysfs_get_dev(sysfs_path, devname, dev_t, BLK_DEV_SIZE) &&
 	    sscanf(dev_t, "%d:%d", &major, &minor) == 2)
@@ -654,10 +656,12 @@
 	lock(vecs->lock);
 
 	/*
-	 * device map add/remove event
+	 * device map event
+	 * Add events are ignored here as the tables
+	 * are not fully initialised then.
 	 */
 	if (!strncmp(devname, "dm-", 3)) {
-		if (!strncmp(uev->action, "add", 3)) {
+		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(devname, vecs);
 			goto out;
 		}
@@ -1424,6 +1428,7 @@
 	int err;
 	
 	logsink = 1;
+	dm_init();
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
