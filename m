From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 6/21] [libmultipath] Fix debugging output
Date: Mon, 21 May 2007 11:23:35 +0200
Message-ID: <20070521092335.21485D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Implement a proper output function for libdevmapper which ties
into our verbosity level. This allows us for a finer grained
control about the error messages from libdevmapper and we get
better debugging output to boot.

Signed-off-by: Stefan Bader <bader@de.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c   |    2 -
 libmultipath/debug.c       |    2 +-
 libmultipath/debug.h       |    2 +-
 libmultipath/devmapper.c   |   60 ++++++++++++++++++++++++++++++++++---------
 libmultipath/devmapper.h   |    3 +-
 libmultipath/log_pthread.c |    2 +-
 libmultipath/log_pthread.h |    2 +-
 libmultipath/structs_vec.c |   32 ++++++++++++++---------
 libmultipath/waiter.c      |    9 +++---
 multipath/main.c           |    1 +
 multipathd/main.c          |    3 ++
 11 files changed, 80 insertions(+), 38 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9632fb4..a5bad4c 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -324,7 +324,6 @@ domap (struct multipath * mpp)
 				mpp->alias);
 			return DOMAP_RETRY;
 		}
-		dm_shut_log();
 
 		if (dm_map_present(mpp->alias))
 			break;
@@ -345,7 +344,6 @@ domap (struct multipath * mpp)
 		}
 
 		lock_multipath(mpp, 0);
-		dm_restore_log();
 		break;
 
 	case ACT_RELOAD:
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index fa06cbd..05dfb06 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -14,7 +14,7 @@
 #include "vector.h"
 #include "config.h"
 
-void dlog (int sink, int prio, char * fmt, ...)
+void dlog (int sink, int prio, const char * fmt, ...)
 {
 	va_list ap;
 	int thres;
diff --git a/libmultipath/debug.h b/libmultipath/debug.h
index 74ed531..082fff1 100644
--- a/libmultipath/debug.h
+++ b/libmultipath/debug.h
@@ -1,4 +1,4 @@
-void dlog (int sink, int prio, char * fmt, ...)
+void dlog (int sink, int prio, const char * fmt, ...)
 	__attribute__((format(printf, 3, 4)));
 
 #if DAEMON
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index dece079..d762cc1 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
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
@@ -28,21 +35,50 @@
 #define UUID_PREFIX_LEN 6
 
 static void
-dm_dummy_log (int level, const char *file, int line, const char *f, ...)
+dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
-	return;
-}
+	va_list ap;
+	int thres;
+
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
 
-void
-dm_restore_log (void)
-{
-	dm_log_init(NULL);
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
 
 static int
@@ -764,9 +800,7 @@ dm_mapname(int major, int minor)
 	 * daemon uev_trigger -> uev_add_map
 	 */
 	while (--loop) {
-		dm_shut_log();
 		r = dm_task_run(dmt);
-		dm_restore_log();
 
 		if (r)
 			break;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 59afd01..8438034 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,5 +1,4 @@
-void dm_shut_log(void);
-void dm_restore_log(void);
+void dm_init(void);
 int dm_prereq (char *);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index f98cfa4..5a82b6a 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -12,7 +12,7 @@
 #include "log_pthread.h"
 #include "log.h"
 
-void log_safe (int prio, char * fmt, va_list ap)
+void log_safe (int prio, const char * fmt, va_list ap)
 {
 	pthread_mutex_lock(logq_lock);
 	//va_start(ap, fmt);
diff --git a/libmultipath/log_pthread.h b/libmultipath/log_pthread.h
index 7c902c7..2b18f59 100644
--- a/libmultipath/log_pthread.h
+++ b/libmultipath/log_pthread.h
@@ -7,7 +7,7 @@ pthread_mutex_t *logq_lock;
 pthread_mutex_t *logev_lock;
 pthread_cond_t *logev_cond;
 
-void log_safe(int prio, char * fmt, va_list ap);
+void log_safe(int prio, const char * fmt, va_list ap);
 void log_thread_start(void);
 void log_thread_stop(void);
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 53b7e17..a4a996a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -16,7 +16,6 @@
 #include "discovery.h"
 #include "waiter.h"
 
-
 /*
  * creates or updates mpp->paths reading mpp->pg
  */
@@ -118,6 +117,8 @@ remove_map (struct multipath * mpp, stru
 {
 	int i;
 
+	condlog(4, "%s: remove multipath map", mpp->alias);
+
 	/*
 	 * stop the DM event waiter thread
 	 */
@@ -245,8 +246,17 @@ extern int
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
@@ -270,6 +280,7 @@ retry:
 #endif
 			goto retry;
 		}
+		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
 
@@ -282,7 +293,6 @@ retry:
 
 	return 0;
 out:
-	condlog(0, "%s: failed to setup multipath", mpp->alias);
 	remove_map(mpp, vecs, NULL, 1);
 	return 1;
 }
@@ -390,18 +400,19 @@ int update_multipath (struct vectors *ve
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
@@ -429,11 +440,8 @@ int update_multipath (struct vectors *ve
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
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 75ed90c..d7af0d1 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -117,15 +117,11 @@ int waiteventloop (struct event_thread *
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
@@ -157,8 +153,11 @@ int waiteventloop (struct event_thread *
 		r = update_multipath(waiter->vecs, waiter->mapname);
 		lock_cleanup_pop(waiter->vecs->lock);
 
-		if (r)
+		if (r) {
+			condlog(2, "%s: event checker exit", 
+				waiter->mapname);
 			return -1; /* stop the thread */
+		}
 
 		event_nr = dm_geteventnr(waiter->mapname);
 
diff --git a/multipath/main.c b/multipath/main.c
index 67076db..acc3137 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -401,6 +401,7 @@ main (int argc, char *argv[])
 			conf->dev_type = DEV_DEVMAP;
 
 	}
+	dm_init();
 
 	if (conf->remove == FLUSH_ONE) {
 		if (conf->dev_type == DEV_DEVMAP)
diff --git a/multipathd/main.c b/multipathd/main.c
index f2f9a96..9975dd8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -225,6 +225,8 @@ ev_add_map (char * devname, struct vecto
 	int map_present;
 	int r = 1;
 
+	/* libsysfs seems to forget to terminate the string... */
+	memset(dev_t, 0, BLK_DEV_SIZE);
 	if (sscanf(devname, "dm-%d", &minor) == 1 &&
 	    !sysfs_get_dev(sysfs_path, devname, dev_t, BLK_DEV_SIZE) &&
 	    sscanf(dev_t, "%d:%d", &major, &minor) == 2)
@@ -1397,6 +1399,7 @@ main (int argc, char *argv[])
 	int err;
 	
 	logsink = 1;
+	dm_init();
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
-- 
1.4.3.4
