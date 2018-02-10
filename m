From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [RFC PATCH 2/5] move waiter code from libmultipath to
	multipathd
Date: Fri,  9 Feb 2018 23:07:28 -0600
Message-ID: <1518239251-29392-3-git-send-email-bmarzins@redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Only multipathd uses the code in waiter.[ch] and the functions that call
it directly, so they should all live in the multipathd directory.  This
patch is simply moving the waiter.[ch] files and the functions in
structs_vec that use them. None of the moved code has been changed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile      |   2 +-
 libmultipath/structs_vec.c |  98 ---------------------
 libmultipath/structs_vec.h |   4 +-
 libmultipath/waiter.c      | 215 ---------------------------------------------
 libmultipath/waiter.h      |  17 ----
 multipathd/Makefile        |   2 +-
 multipathd/main.c          |  96 ++++++++++++++++++++
 multipathd/waiter.c        | 215 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/waiter.h        |  17 ++++
 9 files changed, 332 insertions(+), 334 deletions(-)
 delete mode 100644 libmultipath/waiter.c
 delete mode 100644 libmultipath/waiter.h
 create mode 100644 multipathd/waiter.c
 create mode 100644 multipathd/waiter.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 6447d8d..a1005b2 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -42,7 +42,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
+	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o
 
 all: $(LIBS)
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index abf5327..77b045b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -10,7 +10,6 @@
 #include "structs.h"
 #include "structs_vec.h"
 #include "sysfs.h"
-#include "waiter.h"
 #include "devmapper.h"
 #include "dmparser.h"
 #include "propsel.h"
@@ -107,17 +106,6 @@ void orphan_paths(vector pathvec, struct multipath *mpp)
 	}
 }
 
-static void
-set_multipath_wwid (struct multipath * mpp)
-{
-	if (strlen(mpp->wwid))
-		return;
-
-	dm_get_uuid(mpp->alias, mpp->wwid);
-}
-
-#define PURGE_VEC 1
-
 void
 remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 {
@@ -379,92 +367,6 @@ sync_map_state(struct multipath *mpp)
 	}
 }
 
-int
-update_map (struct multipath *mpp, struct vectors *vecs)
-{
-	int retries = 3;
-	char params[PARAMS_SIZE] = {0};
-
-retry:
-	condlog(4, "%s: updating new map", mpp->alias);
-	if (adopt_paths(vecs->pathvec, mpp)) {
-		condlog(0, "%s: failed to adopt paths for new map update",
-			mpp->alias);
-		retries = -1;
-		goto fail;
-	}
-	verify_paths(mpp, vecs);
-	mpp->action = ACT_RELOAD;
-
-	extract_hwe_from_path(mpp);
-	if (setup_map(mpp, params, PARAMS_SIZE)) {
-		condlog(0, "%s: failed to setup new map in update", mpp->alias);
-		retries = -1;
-		goto fail;
-	}
-	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
-		condlog(0, "%s: map_udate sleep", mpp->alias);
-		sleep(1);
-		goto retry;
-	}
-	dm_lib_release();
-
-fail:
-	if (setup_multipath(vecs, mpp))
-		return 1;
-
-	sync_map_state(mpp);
-
-	if (retries < 0)
-		condlog(0, "%s: failed reload in new map update", mpp->alias);
-	return 0;
-}
-
-struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
-{
-	struct multipath * mpp = alloc_multipath();
-	struct config *conf;
-
-	if (!mpp)
-		return NULL;
-	if (!alias) {
-		FREE(mpp);
-		return NULL;
-	}
-
-	mpp->alias = STRDUP(alias);
-
-	if (dm_get_info(mpp->alias, &mpp->dmi)) {
-		condlog(3, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-	set_multipath_wwid(mpp);
-	conf = get_multipath_config();
-	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
-	put_multipath_config(conf);
-
-	if (update_multipath_table(mpp, vecs->pathvec, 1))
-		goto out;
-	if (update_multipath_status(mpp))
-		goto out;
-
-	if (!vector_alloc_slot(vecs->mpvec))
-		goto out;
-
-	vector_set_slot(vecs->mpvec, mpp);
-
-	if (update_map(mpp, vecs) != 0) /* map removed */
-		return NULL;
-
-	if (start_waiter_thread(mpp, vecs))
-		goto out;
-
-	return mpp;
-out:
-	remove_map(mpp, vecs, PURGE_VEC);
-	return NULL;
-}
-
 static void
 find_existing_alias (struct multipath * mpp,
 		     struct vectors *vecs)
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index d6e17bb..ceab6d9 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -26,12 +26,12 @@ int update_multipath_strings (struct multipath *mpp, vector pathvec,
 			      int is_daemon);
 void extract_hwe_from_path(struct multipath * mpp);
 
+#define PURGE_VEC 1
+
 void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
 void remove_maps (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
-int update_map (struct multipath *mpp, struct vectors *vecs);
-struct multipath * add_map_without_path (struct vectors * vecs, char * alias);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
deleted file mode 100644
index cb9708b..0000000
--- a/libmultipath/waiter.c
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * Copyright (c) 2004, 2005 Christophe Varoqui
- * Copyright (c) 2005 Kiyoshi Ueda, NEC
- * Copyright (c) 2005 Benjamin Marzinski, Redhat
- * Copyright (c) 2005 Edward Goggin, EMC
- */
-#include <unistd.h>
-#include <libdevmapper.h>
-#include <sys/mman.h>
-#include <pthread.h>
-#include <signal.h>
-#include <urcu.h>
-
-#include "vector.h"
-#include "memory.h"
-#include "checkers.h"
-#include "config.h"
-#include "structs.h"
-#include "structs_vec.h"
-#include "devmapper.h"
-#include "debug.h"
-#include "lock.h"
-#include "waiter.h"
-
-pthread_attr_t waiter_attr;
-
-static struct event_thread *alloc_waiter (void)
-{
-
-	struct event_thread *wp;
-
-	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
-	memset(wp, 0, sizeof(struct event_thread));
-
-	return wp;
-}
-
-static void free_waiter (void *data)
-{
-	struct event_thread *wp = (struct event_thread *)data;
-
-	if (wp->dmt)
-		dm_task_destroy(wp->dmt);
-
-	rcu_unregister_thread();
-	FREE(wp);
-}
-
-void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
-{
-	pthread_t thread;
-
-	if (mpp->waiter == (pthread_t)0) {
-		condlog(3, "%s: event checker thread already stopped",
-			mpp->alias);
-		return;
-	}
-	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
-		mpp->waiter);
-	thread = mpp->waiter;
-	mpp->waiter = (pthread_t)0;
-	pthread_cancel(thread);
-	pthread_kill(thread, SIGUSR2);
-}
-
-/*
- * returns the reschedule delay
- * negative means *stop*
- */
-static int waiteventloop (struct event_thread *waiter)
-{
-	sigset_t set, oldset;
-	int event_nr;
-	int r;
-
-	if (!waiter->event_nr)
-		waiter->event_nr = dm_geteventnr(waiter->mapname);
-
-	if (!(waiter->dmt = libmp_dm_task_create(DM_DEVICE_WAITEVENT))) {
-		condlog(0, "%s: devmap event #%i dm_task_create error",
-				waiter->mapname, waiter->event_nr);
-		return 1;
-	}
-
-	if (!dm_task_set_name(waiter->dmt, waiter->mapname)) {
-		condlog(0, "%s: devmap event #%i dm_task_set_name error",
-				waiter->mapname, waiter->event_nr);
-		dm_task_destroy(waiter->dmt);
-		waiter->dmt = NULL;
-		return 1;
-	}
-
-	if (waiter->event_nr && !dm_task_set_event_nr(waiter->dmt,
-						      waiter->event_nr)) {
-		condlog(0, "%s: devmap event #%i dm_task_set_event_nr error",
-				waiter->mapname, waiter->event_nr);
-		dm_task_destroy(waiter->dmt);
-		waiter->dmt = NULL;
-		return 1;
-	}
-
-	dm_task_no_open_count(waiter->dmt);
-
-	/* wait */
-	sigemptyset(&set);
-	sigaddset(&set, SIGUSR2);
-	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
-
-	pthread_testcancel();
-	r = dm_task_run(waiter->dmt);
-	pthread_testcancel();
-
-	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
-	dm_task_destroy(waiter->dmt);
-	waiter->dmt = NULL;
-
-	if (!r)	/* wait interrupted by signal */
-		return -1;
-
-	waiter->event_nr++;
-
-	/*
-	 * upon event ...
-	 */
-	while (1) {
-		condlog(3, "%s: devmap event #%i",
-				waiter->mapname, waiter->event_nr);
-
-		/*
-		 * event might be :
-		 *
-		 * 1) a table reload, which means our mpp structure is
-		 *    obsolete : refresh it through update_multipath()
-		 * 2) a path failed by DM : mark as such through
-		 *    update_multipath()
-		 * 3) map has gone away : stop the thread.
-		 * 4) a path reinstate : nothing to do
-		 * 5) a switch group : nothing to do
-		 */
-		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
-		lock(&waiter->vecs->lock);
-		pthread_testcancel();
-		r = update_multipath(waiter->vecs, waiter->mapname, 1);
-		lock_cleanup_pop(waiter->vecs->lock);
-
-		if (r) {
-			condlog(2, "%s: event checker exit",
-				waiter->mapname);
-			return -1; /* stop the thread */
-		}
-
-		event_nr = dm_geteventnr(waiter->mapname);
-
-		if (waiter->event_nr == event_nr)
-			return 1; /* upon problem reschedule 1s later */
-
-		waiter->event_nr = event_nr;
-	}
-	return -1; /* never reach there */
-}
-
-static void *waitevent (void *et)
-{
-	int r;
-	struct event_thread *waiter;
-
-	mlockall(MCL_CURRENT | MCL_FUTURE);
-
-	waiter = (struct event_thread *)et;
-	pthread_cleanup_push(free_waiter, et);
-
-	rcu_register_thread();
-	while (1) {
-		r = waiteventloop(waiter);
-
-		if (r < 0)
-			break;
-
-		sleep(r);
-	}
-
-	pthread_cleanup_pop(1);
-	return NULL;
-}
-
-int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
-{
-	struct event_thread *wp;
-
-	if (!mpp)
-		return 0;
-
-	wp = alloc_waiter();
-
-	if (!wp)
-		goto out;
-
-	strncpy(wp->mapname, mpp->alias, WWID_SIZE - 1);
-	wp->vecs = vecs;
-
-	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
-		condlog(0, "%s: cannot create event checker", wp->mapname);
-		goto out1;
-	}
-	mpp->waiter = wp->thread;
-	condlog(2, "%s: event checker started", wp->mapname);
-
-	return 0;
-out1:
-	free_waiter(wp);
-	mpp->waiter = (pthread_t)0;
-out:
-	condlog(0, "failed to start waiter thread");
-	return 1;
-}
diff --git a/libmultipath/waiter.h b/libmultipath/waiter.h
deleted file mode 100644
index 0cfae46..0000000
--- a/libmultipath/waiter.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _WAITER_H
-#define _WAITER_H
-
-extern pthread_attr_t waiter_attr;
-
-struct event_thread {
-	struct dm_task *dmt;
-	pthread_t thread;
-	int event_nr;
-	char mapname[WWID_SIZE];
-	struct vectors *vecs;
-};
-
-void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs);
-int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
-
-#endif /* _WAITER_H */
diff --git a/multipathd/Makefile b/multipathd/Makefile
index e6f140b..85f29a7 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -22,7 +22,7 @@ ifdef SYSTEMD
 	endif
 endif
 
-OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
+OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o waiter.o
 
 EXEC = multipathd
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 72c3c2f..94b2406 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -311,6 +311,102 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 	remove_maps(vecs);
 }
 
+static void
+set_multipath_wwid (struct multipath * mpp)
+{
+	if (strlen(mpp->wwid))
+		return;
+
+	dm_get_uuid(mpp->alias, mpp->wwid);
+}
+
+static int
+update_map (struct multipath *mpp, struct vectors *vecs)
+{
+	int retries = 3;
+	char params[PARAMS_SIZE] = {0};
+
+retry:
+	condlog(4, "%s: updating new map", mpp->alias);
+	if (adopt_paths(vecs->pathvec, mpp)) {
+		condlog(0, "%s: failed to adopt paths for new map update",
+			mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	verify_paths(mpp, vecs);
+	mpp->action = ACT_RELOAD;
+
+	extract_hwe_from_path(mpp);
+	if (setup_map(mpp, params, PARAMS_SIZE)) {
+		condlog(0, "%s: failed to setup new map in update", mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
+		condlog(0, "%s: map_udate sleep", mpp->alias);
+		sleep(1);
+		goto retry;
+	}
+	dm_lib_release();
+
+fail:
+	if (setup_multipath(vecs, mpp))
+		return 1;
+
+	sync_map_state(mpp);
+
+	if (retries < 0)
+		condlog(0, "%s: failed reload in new map update", mpp->alias);
+	return 0;
+}
+
+static struct multipath *
+add_map_without_path (struct vectors *vecs, char *alias)
+{
+	struct multipath * mpp = alloc_multipath();
+	struct config *conf;
+
+	if (!mpp)
+		return NULL;
+	if (!alias) {
+		FREE(mpp);
+		return NULL;
+	}
+
+	mpp->alias = STRDUP(alias);
+
+	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+		condlog(3, "%s: cannot access table", mpp->alias);
+		goto out;
+	}
+	set_multipath_wwid(mpp);
+	conf = get_multipath_config();
+	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
+	put_multipath_config(conf);
+
+	if (update_multipath_table(mpp, vecs->pathvec, 1))
+		goto out;
+	if (update_multipath_status(mpp))
+		goto out;
+
+	if (!vector_alloc_slot(vecs->mpvec))
+		goto out;
+
+	vector_set_slot(vecs->mpvec, mpp);
+
+	if (update_map(mpp, vecs) != 0) /* map removed */
+		return NULL;
+
+	if (start_waiter_thread(mpp, vecs))
+		goto out;
+
+	return mpp;
+out:
+	remove_map(mpp, vecs, PURGE_VEC);
+	return NULL;
+}
+
 static int
 coalesce_maps(struct vectors *vecs, vector nmpv)
 {
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
new file mode 100644
index 0000000..cb9708b
--- /dev/null
+++ b/multipathd/waiter.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2004, 2005 Christophe Varoqui
+ * Copyright (c) 2005 Kiyoshi Ueda, NEC
+ * Copyright (c) 2005 Benjamin Marzinski, Redhat
+ * Copyright (c) 2005 Edward Goggin, EMC
+ */
+#include <unistd.h>
+#include <libdevmapper.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <signal.h>
+#include <urcu.h>
+
+#include "vector.h"
+#include "memory.h"
+#include "checkers.h"
+#include "config.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "devmapper.h"
+#include "debug.h"
+#include "lock.h"
+#include "waiter.h"
+
+pthread_attr_t waiter_attr;
+
+static struct event_thread *alloc_waiter (void)
+{
+
+	struct event_thread *wp;
+
+	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
+	memset(wp, 0, sizeof(struct event_thread));
+
+	return wp;
+}
+
+static void free_waiter (void *data)
+{
+	struct event_thread *wp = (struct event_thread *)data;
+
+	if (wp->dmt)
+		dm_task_destroy(wp->dmt);
+
+	rcu_unregister_thread();
+	FREE(wp);
+}
+
+void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
+{
+	pthread_t thread;
+
+	if (mpp->waiter == (pthread_t)0) {
+		condlog(3, "%s: event checker thread already stopped",
+			mpp->alias);
+		return;
+	}
+	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
+		mpp->waiter);
+	thread = mpp->waiter;
+	mpp->waiter = (pthread_t)0;
+	pthread_cancel(thread);
+	pthread_kill(thread, SIGUSR2);
+}
+
+/*
+ * returns the reschedule delay
+ * negative means *stop*
+ */
+static int waiteventloop (struct event_thread *waiter)
+{
+	sigset_t set, oldset;
+	int event_nr;
+	int r;
+
+	if (!waiter->event_nr)
+		waiter->event_nr = dm_geteventnr(waiter->mapname);
+
+	if (!(waiter->dmt = libmp_dm_task_create(DM_DEVICE_WAITEVENT))) {
+		condlog(0, "%s: devmap event #%i dm_task_create error",
+				waiter->mapname, waiter->event_nr);
+		return 1;
+	}
+
+	if (!dm_task_set_name(waiter->dmt, waiter->mapname)) {
+		condlog(0, "%s: devmap event #%i dm_task_set_name error",
+				waiter->mapname, waiter->event_nr);
+		dm_task_destroy(waiter->dmt);
+		waiter->dmt = NULL;
+		return 1;
+	}
+
+	if (waiter->event_nr && !dm_task_set_event_nr(waiter->dmt,
+						      waiter->event_nr)) {
+		condlog(0, "%s: devmap event #%i dm_task_set_event_nr error",
+				waiter->mapname, waiter->event_nr);
+		dm_task_destroy(waiter->dmt);
+		waiter->dmt = NULL;
+		return 1;
+	}
+
+	dm_task_no_open_count(waiter->dmt);
+
+	/* wait */
+	sigemptyset(&set);
+	sigaddset(&set, SIGUSR2);
+	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
+
+	pthread_testcancel();
+	r = dm_task_run(waiter->dmt);
+	pthread_testcancel();
+
+	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+	dm_task_destroy(waiter->dmt);
+	waiter->dmt = NULL;
+
+	if (!r)	/* wait interrupted by signal */
+		return -1;
+
+	waiter->event_nr++;
+
+	/*
+	 * upon event ...
+	 */
+	while (1) {
+		condlog(3, "%s: devmap event #%i",
+				waiter->mapname, waiter->event_nr);
+
+		/*
+		 * event might be :
+		 *
+		 * 1) a table reload, which means our mpp structure is
+		 *    obsolete : refresh it through update_multipath()
+		 * 2) a path failed by DM : mark as such through
+		 *    update_multipath()
+		 * 3) map has gone away : stop the thread.
+		 * 4) a path reinstate : nothing to do
+		 * 5) a switch group : nothing to do
+		 */
+		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
+		lock(&waiter->vecs->lock);
+		pthread_testcancel();
+		r = update_multipath(waiter->vecs, waiter->mapname, 1);
+		lock_cleanup_pop(waiter->vecs->lock);
+
+		if (r) {
+			condlog(2, "%s: event checker exit",
+				waiter->mapname);
+			return -1; /* stop the thread */
+		}
+
+		event_nr = dm_geteventnr(waiter->mapname);
+
+		if (waiter->event_nr == event_nr)
+			return 1; /* upon problem reschedule 1s later */
+
+		waiter->event_nr = event_nr;
+	}
+	return -1; /* never reach there */
+}
+
+static void *waitevent (void *et)
+{
+	int r;
+	struct event_thread *waiter;
+
+	mlockall(MCL_CURRENT | MCL_FUTURE);
+
+	waiter = (struct event_thread *)et;
+	pthread_cleanup_push(free_waiter, et);
+
+	rcu_register_thread();
+	while (1) {
+		r = waiteventloop(waiter);
+
+		if (r < 0)
+			break;
+
+		sleep(r);
+	}
+
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
+int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
+{
+	struct event_thread *wp;
+
+	if (!mpp)
+		return 0;
+
+	wp = alloc_waiter();
+
+	if (!wp)
+		goto out;
+
+	strncpy(wp->mapname, mpp->alias, WWID_SIZE - 1);
+	wp->vecs = vecs;
+
+	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
+		condlog(0, "%s: cannot create event checker", wp->mapname);
+		goto out1;
+	}
+	mpp->waiter = wp->thread;
+	condlog(2, "%s: event checker started", wp->mapname);
+
+	return 0;
+out1:
+	free_waiter(wp);
+	mpp->waiter = (pthread_t)0;
+out:
+	condlog(0, "failed to start waiter thread");
+	return 1;
+}
diff --git a/multipathd/waiter.h b/multipathd/waiter.h
new file mode 100644
index 0000000..0cfae46
--- /dev/null
+++ b/multipathd/waiter.h
@@ -0,0 +1,17 @@
+#ifndef _WAITER_H
+#define _WAITER_H
+
+extern pthread_attr_t waiter_attr;
+
+struct event_thread {
+	struct dm_task *dmt;
+	pthread_t thread;
+	int event_nr;
+	char mapname[WWID_SIZE];
+	struct vectors *vecs;
+};
+
+void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs);
+int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
+
+#endif /* _WAITER_H */
-- 
2.7.4
