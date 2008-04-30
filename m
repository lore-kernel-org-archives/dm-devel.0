From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Remove DAEMON defines
Date: Wed, 30 Apr 2008 11:04:50 +0200
Message-ID: <20080430090451.060C418C6FF@pentland.suse.de>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We're now building just one shared library for both programs,
multipath and multipathd. So any DAEMON defines are quite
pointless.
Remove them and use 'mpp->waiter == NULL' to distinguish between
multipath and multipathd where required.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile      |    8 ++------
 libmultipath/configure.c   |   28 +++++++++++++++-------------
 libmultipath/debug.c       |    8 +-------
 libmultipath/debug.h       |   10 +---------
 libmultipath/devmapper.c   |   12 ++----------
 libmultipath/discovery.c   |   11 +----------
 libmultipath/dmparser.c    |    5 ++---
 libmultipath/structs.c     |    4 +---
 libmultipath/structs_vec.c |   11 +++++------
 libmultipath/structs_vec.h |    2 --
 libmultipath/uxsock.c      |   10 ++++------
 libmultipath/waiter.h      |    3 ---
 multipath/main.c           |    2 ++
 multipathd/Makefile        |    2 +-
 multipathd/main.c          |    2 ++
 15 files changed, 39 insertions(+), 79 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 18241a2..05bcc37 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -11,12 +11,8 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        structs.o discovery.o propsel.o dict.o \
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
        switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-       log.o configure.o structs_vec.o sysfs.o prio.o checkers.o
-
-#ifeq ($(strip $(DAEMON)),1)
-	OBJS += lock.o waiter.o
-	CFLAGS += -DDAEMON
-#endif
+       log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
+       lock.o waiter.o
 
 LIBDM_API_FLUSH = $(shell if test -d /lib64 ; then objdump -T /lib64/libdevmapper.so* ; else objdump -T /lib/libdevmapper.so.* ; fi | grep -c dm_task_no_flush)
 
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index df31cdd..d9fa397 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -367,19 +367,21 @@ domap (struct multipath * mpp)
 		 * DM_DEVICE_CREATE, DM_DEVICE_RENAME, or DM_DEVICE_RELOAD
 		 * succeeded
 		 */
-#ifndef DAEMON
-		dm_switchgroup(mpp->alias, mpp->bestpg);
-		if (mpp->action != ACT_NOTHING)
-			print_multipath_topology(mpp, conf->verbosity);
-#else
-		mpp->stat_map_loads++;
-		condlog(2, "%s: load table [0 %llu %s %s]", mpp->alias,
-                        mpp->size, DEFAULT_TARGET, mpp->params);
-		/*
-		 * Required action is over, reset for the stateful daemon
-		 */
-		mpp->action = ACT_NOTHING;
-#endif
+		if (!mpp->waiter) {
+			/* multipath client mode */
+			dm_switchgroup(mpp->alias, mpp->bestpg);
+			if (mpp->action != ACT_NOTHING)
+				print_multipath_topology(mpp, conf->verbosity);
+		} else  {
+			/* multipath daemon mode */
+			mpp->stat_map_loads++;
+			condlog(2, "%s: load table [0 %llu %s %s]", mpp->alias,
+				mpp->size, DEFAULT_TARGET, mpp->params);
+			/*
+			 * Required action is over, reset for the stateful daemon
+			 */
+			mpp->action = ACT_NOTHING;
+		}
 		return DOMAP_OK;
 	}
 	return DOMAP_FAIL;
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index 05dfb06..d30517d 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -5,11 +5,9 @@
 #include <stdlib.h>
 #include <stdarg.h>
 
-#if DAEMON
 #include "log_pthread.h"
 #include <sys/types.h>
 #include <time.h>
-#endif
 
 #include "vector.h"
 #include "config.h"
@@ -23,12 +21,11 @@ void dlog (int sink, int prio, const char * fmt, ...)
 	thres = (conf) ? conf->verbosity : 0;
 
 	if (prio <= thres) {
-#if DAEMON
 		if (!sink) {
 			time_t t = time(NULL);
 			struct tm *tb = localtime(&t);
 			char buff[16];
-			
+
 			strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
 			buff[sizeof(buff)-1] = '\0';
 
@@ -37,9 +34,6 @@ void dlog (int sink, int prio, const char * fmt, ...)
 		}
 		else
 			log_safe(prio + 3, fmt, ap);
-#else
-		vfprintf(stdout, fmt, ap);
-#endif
 	}
 	va_end(ap);
 }
diff --git a/libmultipath/debug.h b/libmultipath/debug.h
index 082fff1..c6120c1 100644
--- a/libmultipath/debug.h
+++ b/libmultipath/debug.h
@@ -1,21 +1,13 @@
 void dlog (int sink, int prio, const char * fmt, ...)
 	__attribute__((format(printf, 3, 4)));
 
-#if DAEMON
 
 #include <pthread.h>
 #include <stdarg.h>
 
 #include "log_pthread.h"
 
-int logsink;
+extern int logsink;
 
 #define condlog(prio, fmt, args...) \
 	dlog(logsink, prio, fmt "\n", ##args)
-
-#else /* DAEMON */
-
-#define condlog(prio, fmt, args...) \
-	dlog(0, prio, fmt "\n", ##args)
-
-#endif /* DAEMON */
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f21d3ab..cc01486 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -22,11 +22,9 @@
 #include "devmapper.h"
 #include "config.h"
 
-#if DAEMON
 #include "log_pthread.h"
 #include <sys/types.h>
 #include <time.h>
-#endif
 
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
@@ -47,8 +45,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 	if (thres <= 3 || level > thres)
 		return;
 
-        va_start(ap, f);
-#if DAEMON
+	va_start(ap, f);
 	if (!logsink) {
 		time_t t = time(NULL);
 		struct tm *tb = localtime(&t);
@@ -65,12 +62,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 		condlog(level, "libdevmapper: %s(%i): ", file, line);
 		log_safe(level + 3, f, ap);
 	}
-#else
-	fprintf(stdout, "libdevmapper: %s(%i): ", file, line);
-	vfprintf(stdout, f, ap);
-	fprintf(stdout, "\n");
-#endif
-        va_end(ap);
+	va_end(ap);
 
 	return;
 }
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8cfb53f..7baa9e7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -716,10 +716,6 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	if (mask & DI_WWID && !strlen(pp->wwid))
 		get_uid(pp);
 
-#ifndef DAEMON
-	close(pp->fd);
-	pp->fd = -1;
-#endif
 	return 0;
 
 blank:
@@ -728,11 +724,6 @@ blank:
 	 */
 	memset(pp->wwid, 0, WWID_SIZE);
 	pp->state = PATH_DOWN;
-#ifndef DAEMON
-	if (pp->fd > 0){
-		close(pp->fd);
-		pp->fd = -1;
-	}
-#endif
+
 	return 0;
 }
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index fe7d986..df7a0c3 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -277,10 +277,9 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 
 				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
 
-#ifndef DAEMON
-				if (store_path(pathvec, pp))
+				/* Only call this in multipath client mode */
+				if (!mpp->waiter && store_path(pathvec, pp))
 					goto out;
-#endif
 			}
 			FREE(word);
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 11f3061..082d53f 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -170,14 +170,12 @@ free_multipath (struct multipath * mpp, int free_paths)
 
 	if (mpp->dmi)
 		FREE(mpp->dmi);
-	
-#if DAEMON
+
 	/*
 	 * better own vecs->lock here
 	 */
 	if (mpp->waiter)
 		((struct event_thread *)mpp->waiter)->mpp = NULL;
-#endif
 
 	free_pathvec(mpp->paths, free_paths);
 	free_pgvec(mpp->pg, free_paths);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f4d69bb..6757eb9 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -62,7 +62,7 @@ adopt_paths (vector pathvec, struct multipath * mpp)
 			condlog(3, "%s: ownership set to %s",
 				pp->dev, mpp->alias);
 			pp->mpp = mpp;
-			
+
 			if (!mpp->paths && !(mpp->paths = vector_alloc()))
 				return 1;
 
@@ -294,18 +294,17 @@ retry:
 		char new_alias[WWID_SIZE];
 
 		/*
-	 	 * detect an external rename of the multipath device
+		 * detect an external rename of the multipath device
 		 */
 		if (dm_get_name(mpp->wwid, DEFAULT_TARGET, new_alias)) {
 			condlog(3, "%s multipath mapped device name has "
 				"changed from %s to %s", mpp->wwid,
 				mpp->alias, new_alias);
 			strcpy(mpp->alias, new_alias);
-#if DAEMON
-			if (mpp->waiter) 
+
+			if (mpp->waiter)
 				strncpy(((struct event_thread *)mpp->waiter)->mapname,
 					new_alias, WWID_SIZE);
-#endif
 			goto retry;
 		}
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
@@ -341,7 +340,7 @@ add_map_without_path (struct vectors * vecs,
 
 	if (adopt_paths(vecs->pathvec, mpp))
 		goto out;
-	
+
 	if (!vector_alloc_slot(vecs->mpvec))
 		goto out;
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index b8a416f..19a2387 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -2,9 +2,7 @@
 #define _STRUCTS_VEC_H
 
 struct vectors {
-#if DAEMON
 	pthread_mutex_t *lock;
-#endif
 	vector pathvec;
 	vector mpvec;
 };
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index cdc3dbc..a070943 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -129,23 +129,21 @@ size_t read_all(int fd, void *buf, size_t len)
 int send_packet(int fd, const char *buf, size_t len)
 {
 	int ret = 0;
-#ifdef DAEMON
 	sigset_t set, old;
 
 	/* Block SIGPIPE */
 	sigemptyset(&set);
 	sigaddset(&set, SIGPIPE);
 	pthread_sigmask(SIG_BLOCK, &set, &old);
-#endif	
-	if (write_all(fd, &len, sizeof(len)) != sizeof(len)) 
+
+	if (write_all(fd, &len, sizeof(len)) != sizeof(len))
 		ret = -1;
 	if (!ret && write_all(fd, buf, len) != len)
-		ret = -1;	
+		ret = -1;
 
-#ifdef DAEMON
 	/* And unblock it again */
 	pthread_sigmask(SIG_SETMASK, &old, NULL);
-#endif	
+
 	return ret;
 }
 
diff --git a/libmultipath/waiter.h b/libmultipath/waiter.h
index 0223924..468ce5f 100644
--- a/libmultipath/waiter.h
+++ b/libmultipath/waiter.h
@@ -1,8 +1,6 @@
 #ifndef _WAITER_H
 #define _WAITER_H
 
-#if DAEMON
-
 struct event_thread {
 	struct dm_task *dmt;
 	pthread_t thread;
@@ -19,5 +17,4 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
 int waiteventloop (struct event_thread *waiter);
 void *waitevent (void *et);
 
-#endif /* DAEMON */
 #endif /* _WAITER_H */
diff --git a/multipath/main.c b/multipath/main.c
index b6ea6fd..c071cac 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -49,6 +49,8 @@
 #include <pgpolicies.h>
 #include <version.h>
 
+int logsink;
+
 static int
 filter_pathvec (vector pathvec, char * refwwid)
 {
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 6beb993..dd223c4 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 #
 # basic flags setting
 #
-CFLAGS += -DDAEMON -I$(multipathdir) -Wl,-rpath,$(libdir)
+CFLAGS += -I$(multipathdir) -Wl,-rpath,$(libdir)
 LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -laio \
 	   -lmultipath -L$(multipathdir)
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 385521c..2b1fd86 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -65,6 +65,8 @@
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
 
+int logsink;
+
 /*
  * global copy of vecs for use in sig handlers
  */
-- 
1.5.2.4
