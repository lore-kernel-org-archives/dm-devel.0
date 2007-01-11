From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW ./configure ./config ...
Date: 11 Jan 2007 21:54:54 -0000
Message-ID: <20070111215454.12285.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-11 21:54:53

Modified files:
	.              : WHATS_NEW configure configure.in 
	dmeventd       : .exported_symbols dmeventd.c 
	                 libdevmapper-event.c libdevmapper-event.h 
	include        : configure.h.in 
	lib            : .exported_symbols libdevmapper.h libdm-string.c 

Log message:
	Lots of dmeventd-related changes.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.141&r2=1.142
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.38&r2=1.39
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.39&r2=1.40
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/.exported_symbols.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.27&r2=1.28
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/configure.h.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.25&r2=1.26
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.61&r2=1.62
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- device-mapper/WHATS_NEW	2007/01/11 16:23:21	1.141
+++ device-mapper/WHATS_NEW	2007/01/11 21:54:51	1.142
@@ -1,8 +1,9 @@
 Version 1.02.14 - 
 =============================
+  Add dm_saprintf().
   Use CFLAGS when linking so mixed sparc builds can supply -m64.
   Add dm_tree_use_no_flush_suspend().
-  Lots of dmevent changes.
+  Lots of dmevent changes including revised interface.
   Export dm_basename().
   Cope with a trailing space when comparing tables prior to possible reload.
   Fix dmeventd to cope if monitored device disappears.
--- device-mapper/configure	2006/10/12 15:42:24	1.38
+++ device-mapper/configure	2007/01/11 21:54:51	1.39
@@ -865,12 +865,13 @@
   --with-device-uid=UID   Set the owner used for new device nodes [UID=0]
   --with-device-gid=UID   Set the group used for new device nodes [GID=0]
   --with-device-mode=MODE Set the mode used for new device nodes [MODE=0600]
-  --with-optimisation=OPT C optimisation flag OPT=-O2
-  --with-localedir=DIR    Translation files in DIR PREFIX/share/locale
+  --with-optimisation=OPT C optimisation flag [OPT=-O2]
+  --with-localedir=DIR    Translation files in DIR [PREFIX/share/locale]
   --with-kernel-dir=DIR   linux kernel source in DIR
   --with-kernel-version=VERSION   linux kernel version
-  --with-tmp-dir=DIR      temp directory to make kernel patches /tmp/kerndiff
-  --with-interface=IFACE  Choose kernel interface (ioctl or fs) ioctl
+  --with-tmp-dir=DIR      temp dir to make kernel patches [/tmp/kerndiff]
+  --with-interface=IFACE  Choose kernel interface (ioctl or fs) [ioctl]
+  --with-dmeventd-pidfile=PATH    dmeventd pidfile [/var/run/dmeventd.pid]
 
 Some influential environment variables:
   CC          C compiler command
@@ -6039,6 +6040,25 @@
 ################################################################################
 
 
+if test "$DMEVENTD" = yes; then
+
+# Check whether --with-dmeventd-pidfile or --without-dmeventd-pidfile was given.
+if test "${with_dmeventd_pidfile+set}" = set; then
+  withval="$with_dmeventd_pidfile"
+   cat >>confdefs.h <<_ACEOF
+#define DMEVENTD_PIDFILE "$withval"
+_ACEOF
+
+else
+   cat >>confdefs.h <<_ACEOF
+#define DMEVENTD_PIDFILE "/var/run/dmeventd.pid"
+_ACEOF
+
+fi;
+fi
+################################################################################
+
+
 
 
 
--- device-mapper/configure.in	2006/10/12 15:42:24	1.39
+++ device-mapper/configure.in	2007/01/11 21:54:51	1.40
@@ -168,7 +168,7 @@
 dnl -- Override optimisation
 AC_MSG_CHECKING(for C optimisation flag)
 AC_ARG_WITH(optimisation,
-  [  --with-optimisation=OPT C optimisation flag [OPT=-O2] ],
+  [  --with-optimisation=OPT C optimisation flag [[OPT=-O2]] ],
   [ COPTIMISE_FLAG="$withval" ])
 AC_MSG_RESULT($COPTIMISE_FLAG)
 
@@ -262,7 +262,7 @@
 	fi;
 
 	AC_ARG_WITH(localedir,
-  		    [  --with-localedir=DIR    Translation files in DIR [PREFIX/share/locale]],
+  		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
   		    [ LOCALEDIR="$withval" ],
   		    [ LOCALEDIR='${prefix}/share/locale' ])
 fi
@@ -328,7 +328,7 @@
 ################################################################################
 dnl -- Temporary directory for kernel diffs
 AC_ARG_WITH(tmp-dir,
-  [  --with-tmp-dir=DIR      temp directory to make kernel patches [/tmp/kerndiff]],
+  [  --with-tmp-dir=DIR      temp dir to make kernel patches [[/tmp/kerndiff]] ],
   [ tmpdir="$withval" ],
   [ tmpdir=/tmp/kerndiff ])
 if test "${with_tmp_dir+set}" = set; then
@@ -342,7 +342,7 @@
 dnl -- which kernel interface to use (ioctl or fs)
 AC_MSG_CHECKING(for kernel interface choice)
 AC_ARG_WITH(interface,
-  [  --with-interface=IFACE  Choose kernel interface (ioctl or fs) [ioctl]],
+  [  --with-interface=IFACE  Choose kernel interface (ioctl or fs) [[ioctl]] ],
   [ interface="$withval" ],
   [ interface=ioctl ])
 if [[ "x$interface" != xfs -a "x$interface" != xioctl ]];
@@ -359,6 +359,15 @@
 
 
 ################################################################################
+dnl -- dmeventd pidfile path
+AH_TEMPLATE(DMEVENTD_PIDFILE, [Path to dmeventd pidfile.])
+if test "$DMEVENTD" = yes; then
+	AC_ARG_WITH(dmeventd-pidfile,
+  		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
+fi
+################################################################################
 AC_SUBST(usrlibdir)
 AC_SUBST(JOBS)
 AC_SUBST(STATIC_LINK)
--- device-mapper/dmeventd/.exported_symbols	2005/12/02 21:00:33	1.4
+++ device-mapper/dmeventd/.exported_symbols	2007/01/11 21:54:52	1.5
@@ -1,5 +1,16 @@
+dm_event_handler_create
+dm_event_handler_destroy
+dm_event_handler_set_dso
+dm_event_handler_set_name
+dm_event_handler_set_uuid
+dm_event_handler_set_major
+dm_event_handler_set_minor
+dm_event_handler_set_events
+dm_event_handler_get_dso
+dm_event_handler_get_name
+dm_event_handler_get_uuid
+dm_event_handler_get_major
+dm_event_handler_get_minor
+dm_event_handler_get_events
 dm_event_register
 dm_event_unregister
-dm_event_get_registered_device
-dm_event_set_timeout
-dm_event_get_timeout
--- device-mapper/dmeventd/dmeventd.c	2007/01/08 15:35:08	1.27
+++ device-mapper/dmeventd/dmeventd.c	2007/01/11 21:54:52	1.28
@@ -19,6 +19,7 @@
 #define _GNU_SOURCE
 #define _FILE_OFFSET_BITS 64
 
+#include "configure.h"
 #include "libdevmapper.h"
 #include "libdevmapper-event.h"
 #include "list.h"
@@ -44,17 +45,17 @@
 #include <sys/resource.h>
 #include <unistd.h>
 #include <stdarg.h>
-#include <arpa/inet.h> /* for htonl, ntohl */
+#include <arpa/inet.h>		/* for htonl, ntohl */
 
 #ifdef linux
 #include <malloc.h>
 #endif
 
-/* We must use syslog for now, because multilog is not yet implemented */
+/* FIXME We use syslog for now, because multilog is not yet implemented */
 #include <syslog.h>
 
-static volatile sig_atomic_t _exit_now = 0; /* set to '1' when signal is given to exit */
-static volatile sig_atomic_t _thread_registries_empty = 1; /* registries are empty initially */
+static volatile sig_atomic_t _exit_now = 0;	/* set to '1' when signal is given to exit */
+static volatile sig_atomic_t _thread_registries_empty = 1;	/* registries are empty initially */
 
 /* List (un)link macros. */
 #define	LINK(x, head)		list_add(head, &(x)->list)
@@ -78,19 +79,24 @@
 struct dso_data {
 	struct list list;
 
-	char *dso_name; /* DSO name (eg, "evms", "dmraid", "lvm2"). */
+	char *dso_name;		/* DSO name (eg, "evms", "dmraid", "lvm2"). */
 
-	void *dso_handle; /* Opaque handle as returned from dlopen(). */
-	unsigned int ref_count; /* Library reference count. */
+	void *dso_handle;	/* Opaque handle as returned from dlopen(). */
+	unsigned int ref_count;	/* Library reference count. */
 
 	/*
 	 * Event processing.
 	 *
-	 * The DSO can do whatever appropriate steps if an event happens
-	 * such as changing the mapping in case a mirror fails, update
-	 * the application metadata etc.
+	 * The DSO can do whatever appropriate steps if an event
+	 * happens such as changing the mapping in case a mirror
+	 * fails, update the application metadata etc.
+	 *
+	 * This function gets a dm_task that is a result of
+	 * DM_DEVICE_WAITEVENT ioctl (results equivalent to
+	 * DM_DEVICE_STATUS). It should not destroy it.
+	 * The caller must dispose of the task.
 	 */
-	void (*process_event)(const char *device, enum dm_event_type event);
+	void (*process_event)(struct dm_task *dmt, enum dm_event_type event);
 
 	/*
 	 * Device registration.
@@ -100,7 +106,8 @@
 	 * the process_event() function is sane (eg, read metadata
 	 * and activate a mapping).
 	 */
-	int (*register_device)(const char *device);
+	int (*register_device)(const char *device, const char *uuid, int major,
+			       int minor);
 
 	/*
 	 * Device unregistration.
@@ -109,14 +116,15 @@
 	 * for events, the DSO can recognize this and carry out appropriate
 	 * steps (eg, deactivate mapping, metadata update).
 	 */
-	int (*unregister_device)(const char *device);
+	int (*unregister_device)(const char *device, const char *uuid,
+				 int major, int minor);
 };
 static LIST_INIT(_dso_registry);
 
 /* Structure to keep parsed register variables from client message. */
 struct message_data {
 	char *dso_name;		/* Name of DSO. */
-	char *device_path;	/* Mapped device path. */
+	char *device_uuid;	/* Mapped device path. */
 	union {
 		char *str;	/* Events string as fetched from message. */
 		enum dm_event_type field;	/* Events bitfield. */
@@ -139,15 +147,19 @@
 
 	pthread_t thread;
 
-	struct dso_data *dso_data;/* DSO this thread accesses. */
-	
-	char *device_path;	/* Mapped device path. */
+	struct dso_data *dso_data;	/* DSO this thread accesses. */
+
+	struct {
+		char *uuid;
+		char *name;
+		int major, minor;
+	} device;
 	uint32_t event_nr;	/* event number */
 	int processing;		/* Set when event is being processed */
 	int status;		/* running/shutdown/done */
 	enum dm_event_type events;	/* bitfield for event filter. */
-	enum dm_event_type current_events;/* bitfield for occured events. */
-	enum dm_event_type processed_events;/* bitfield for processed events. */
+	enum dm_event_type current_events;	/* bitfield for occured events. */
+	struct dm_task *current_task;
 	time_t next_time;
 	uint32_t timeout;
 	struct list timeout_list;
@@ -168,13 +180,16 @@
 
 	if (ret) {
 		if (!memset(ret, 0, sizeof(*ret)) ||
-		    !(ret->device_path = dm_strdup(data->device_path))) {
+		    !(ret->device.uuid = dm_strdup(data->device_uuid))) {
 			dm_free(ret);
 			ret = NULL;
 		} else {
+			ret->current_task = NULL;
+			ret->device.name = NULL;
+			ret->device.major = ret->device.minor = 0;
 			ret->dso_data = dso_data;
-			ret->events   = data->events.field;
-			ret->timeout  = data->timeout.secs;
+			ret->events = data->events.field;
+			ret->timeout = data->timeout.secs;
 			list_init(&ret->timeout_list);
 		}
 	}
@@ -184,7 +199,8 @@
 
 static void free_thread_status(struct thread_status *thread)
 {
-	dm_free(thread->device_path);
+	dm_free(thread->device.uuid);
+	dm_free(thread->device.name);
 	dm_free(thread);
 }
 
@@ -213,9 +229,10 @@
 
 /*
  * Fetch a string off src and duplicate it into *ptr.
- * Pay attention to 0 lenght strings.
+ * Pay attention to zero-length strings.
  */
-/* FIXME: move to separate module to share with the client lib. */
+/* FIXME? move to libdevmapper to share with the client lib (need to
+   make delimiter a parameter then) */
 static const char delimiter = ' ';
 static int fetch_string(char **ptr, char **src)
 {
@@ -250,8 +267,8 @@
 	if (message_data->dso_name)
 		dm_free(message_data->dso_name);
 
-	if (message_data->device_path)
-		dm_free(message_data->device_path);
+	if (message_data->device_uuid)
+		dm_free(message_data->device_uuid);
 
 }
 
@@ -270,7 +287,7 @@
 	 * path and events # string from message.
 	 */
 	if (fetch_string(&message_data->dso_name, &p) &&
-	    fetch_string(&message_data->device_path, &p) &&
+	    fetch_string(&message_data->device_uuid, &p) &&
 	    fetch_string(&message_data->events.str, &p) &&
 	    fetch_string(&message_data->timeout.str, &p)) {
 		if (message_data->events.str) {
@@ -287,7 +304,7 @@
 			uint32_t secs = atoi(message_data->timeout.str);
 			dm_free(message_data->timeout.str);
 			message_data->timeout.secs = secs ? secs :
-							    DM_EVENT_DEFAULT_TIMEOUT;
+			    DM_EVENT_DEFAULT_TIMEOUT;
 		}
 
 		ret = 1;
@@ -330,23 +347,43 @@
 	return 1;
 }
 
-/* FIXME This is unreliable: should use DM_DEVICE_INFO ioctl instead. */
 /* Check, if a device exists. */
-static int device_exists(char *device)
+static int fill_device_data(struct thread_status *ts)
 {
-	struct stat st_buf;
-	char path2[PATH_MAX];
+	struct dm_task *dmt;
+	struct dm_info dmi;
 
-	if (!device || !*device)
+	if (!ts->device.uuid)
 		return 0;
 
-	if (device[0] == '/') /* absolute path */
-		return !stat(device, &st_buf) && S_ISBLK(st_buf.st_mode);
+	ts->device.name = NULL;
+	ts->device.major = ts->device.minor = 0;
 
-	if (PATH_MAX <= snprintf(path2, PATH_MAX, "%s/%s", dm_dir(), device))
+	dmt = dm_task_create(DM_DEVICE_INFO);
+	if (!dmt)
 		return 0;
 
-	return !stat(path2, &st_buf) && S_ISBLK(st_buf.st_mode);
+	dm_task_set_uuid(dmt, ts->device.uuid);
+	if (!dm_task_run(dmt))
+		goto fail;
+
+	ts->device.name = dm_strdup(dm_task_get_name(dmt));
+	if (!ts->device.name)
+		goto fail;
+
+	if (!dm_task_get_info(dmt, &dmi))
+		goto fail;
+
+	ts->device.major = dmi.major;
+	ts->device.minor = dmi.minor;
+
+	dm_task_destroy(dmt);
+	return 1;
+
+      fail:
+	dm_task_destroy(dmt);
+	dm_free(ts->device.name);
+	return 0;
 }
 
 /*
@@ -359,13 +396,12 @@
 	struct thread_status *thread;
 
 	list_iterate_items(thread, &_thread_registry)
-		if (!strcmp(data->device_path, thread->device_path))
-			return thread;
+	    if (!strcmp(data->device_uuid, thread->device.uuid))
+		return thread;
 
 	return NULL;
 }
 
-
 /* Cleanup at exit. */
 static void exit_dm_lib(void)
 {
@@ -392,11 +428,10 @@
 	while (!list_empty(&timeout_registry)) {
 		struct thread_status *thread;
 
-		timeout.tv_sec = (time_t)-1;
+		timeout.tv_sec = (time_t) -1;
 		curr_time = time(NULL);
 
-		list_iterate_items_gen(thread, &timeout_registry,
-				       timeout_list) {
+		list_iterate_items_gen(thread, &timeout_registry, timeout_list) {
 			if (thread->next_time < curr_time) {
 				thread->next_time = curr_time + thread->timeout;
 				pthread_kill(thread->thread, SIGALRM);
@@ -406,7 +441,8 @@
 				timeout.tv_sec = thread->next_time;
 		}
 
-		pthread_cond_timedwait(&_timeout_cond, &_timeout_mutex, &timeout);
+		pthread_cond_timedwait(&_timeout_cond, &_timeout_mutex,
+				       &timeout);
 	}
 
 	pthread_cleanup_pop(1);
@@ -452,7 +488,7 @@
 }
 
 static void no_intr_log(int level, const char *file, int line,
-		       const char *f, ...)
+			const char *f, ...)
 {
 	va_list ap;
 
@@ -491,23 +527,22 @@
 #define DM_WAIT_FATAL 2
 
 /* Wait on a device until an event occurs. */
-static int event_wait(struct thread_status *thread)
+static int event_wait(struct thread_status *thread, struct dm_task **task)
 {
 	sigset_t set;
 	int ret = DM_WAIT_RETRY;
-/*
-	void *next = NULL;
-	char *params, *target_type;
-	uint64_t start, length;
-*/
 	struct dm_task *dmt;
 	struct dm_info info;
 
+	*task = 0;
+
 	if (!(dmt = dm_task_create(DM_DEVICE_WAITEVENT)))
 		return DM_WAIT_RETRY;
 
-	if (!(ret = dm_task_set_name(dmt, dm_basename(thread->device_path))) ||
-	    !(ret = dm_task_set_event_nr(dmt, thread->event_nr)))
+	thread->current_task = dmt;
+
+	if (!dm_task_set_uuid(dmt, thread->device.uuid) ||
+	    !dm_task_set_event_nr(dmt, thread->event_nr))
 		goto out;
 
 	/*
@@ -517,31 +552,21 @@
 	set = unblock_sigalrm();
 	dm_log_init(no_intr_log);
 	errno = 0;
-	if ((ret = dm_task_run(dmt))) {
+	if (dm_task_run(dmt)) {
 		thread->current_events |= DM_EVENT_DEVICE_ERROR;
 		ret = DM_WAIT_INTR;
 
-		/*
-		 * FIXME:  I am setting processed_events to zero here
-		 * because it is causing problems.  for example, the
-		 * mirror target emits a signal for INSYNC, then
-		 * subsequent events (device failures) are not handled
-		 */
-		thread->processed_events = 0;
-
 		if ((ret = dm_task_get_info(dmt, &info)))
 			thread->event_nr = info.event_nr;
 	} else if (thread->events & DM_EVENT_TIMEOUT && errno == EINTR) {
 		thread->current_events |= DM_EVENT_TIMEOUT;
 		ret = DM_WAIT_INTR;
-		thread->processed_events = 0;
 	} else {
-		/* FIXME replace with log_* macro */
 		syslog(LOG_NOTICE, "dm_task_run failed, errno = %d, %s",
 		       errno, strerror(errno));
 		if (errno == ENXIO) {
-			/* FIXME replace with log_* macro */
-			syslog(LOG_ERR, "%s disappeared, detaching", thread->device_path);
+			syslog(LOG_ERR, "%s disappeared, detaching",
+			       thread->device.name);
 			ret = DM_WAIT_FATAL;
 		}
 	}
@@ -549,8 +574,12 @@
 	pthread_sigmask(SIG_SETMASK, &set, NULL);
 	dm_log_init(NULL);
 
-   out:
-	dm_task_destroy(dmt);
+      out:
+	if (ret == DM_WAIT_FATAL || ret == DM_WAIT_RETRY) {
+		dm_task_destroy(dmt);
+		thread->current_task = NULL;
+	} else
+		*task = dmt;
 
 	return ret;
 }
@@ -558,20 +587,25 @@
 /* Register a device with the DSO. */
 static int do_register_device(struct thread_status *thread)
 {
-	return thread->dso_data->register_device(thread->device_path);
+	return thread->dso_data->register_device(thread->device.name,
+						 thread->device.uuid,
+						 thread->device.major,
+						 thread->device.minor);
 }
 
 /* Unregister a device with the DSO. */
 static int do_unregister_device(struct thread_status *thread)
 {
-	return thread->dso_data->unregister_device(thread->device_path);
+	return thread->dso_data->unregister_device(thread->device.name,
+						   thread->device.uuid,
+						   thread->device.major,
+						   thread->device.minor);
 }
 
 /* Process an event in the DSO. */
-static void do_process_event(struct thread_status *thread)
+static void do_process_event(struct thread_status *thread, struct dm_task *task)
 {
-	thread->dso_data->process_event(thread->device_path,
-					thread->current_events);
+	thread->dso_data->process_event(task, thread->current_events);
 }
 
 /* Thread cleanup handler to unregister device. */
@@ -581,7 +615,10 @@
 
 	if (!do_unregister_device(thread))
 		syslog(LOG_ERR, "%s: %s unregister failed\n", __func__,
-			thread->device_path);
+		       thread->device.name);
+	if (thread->current_task)
+		dm_task_destroy(thread->current_task);
+	thread->current_task = NULL;
 }
 
 /* Device monitoring thread. */
@@ -589,6 +626,7 @@
 {
 	struct thread_status *thread = arg;
 	int wait_error = 0;
+	struct dm_task *task;
 
 	pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
 	pthread_cleanup_push(monitor_unregister, thread);
@@ -602,25 +640,25 @@
 	while (1) {
 		thread->current_events = 0;
 
-		wait_error = event_wait(thread);
+		wait_error = event_wait(thread, &task);
 		if (wait_error == DM_WAIT_RETRY)
 			continue;
 
-		/* FIXME Give a DSO a chance to clean up. */
 		if (wait_error == DM_WAIT_FATAL)
 			break;
 
 		/*
+		 * We know that wait succeeded and stored a
+		 * pointer to dm_task with device status into task.
+		 */
+
+		/*
 		 * Check against filter.
 		 *
 		 * If there's current events delivered from event_wait() AND
 		 * the device got registered for those events AND
 		 * those events haven't been processed yet, call
 		 * the DSO's process_event() handler.
-		 *
-		 * FIXME: when does processed_events get cleared?  What if
-		 * the same type of event happens later... after the first
-		 * was handled properly?
 		 */
 		lock_mutex();
 		if (thread->status == DM_THREAD_SHUTDOWN) {
@@ -629,17 +667,21 @@
 		}
 		unlock_mutex();
 
-		if (thread->events &
-		    thread->current_events &
-		    ~thread->processed_events) {
+		if (thread->events & thread->current_events) {
 			lock_mutex();
 			thread->processing = 1;
 			unlock_mutex();
-			do_process_event(thread);
-			thread->processed_events |= thread->current_events;
+
+			do_process_event(thread, task);
+			dm_task_destroy(task);
+			thread->current_task = NULL;
+
 			lock_mutex();
 			thread->processing = 0;
 			unlock_mutex();
+		} else {
+			dm_task_destroy(task);
+			thread->current_task = NULL;
 		}
 	}
 
@@ -647,12 +689,12 @@
 	thread->status = DM_THREAD_DONE;
 	unlock_mutex();
 
-	pthread_cleanup_pop(0);
+	pthread_cleanup_pop(1);
+
 	return NULL;
 }
 
 /* Create a device monitoring thread. */
-/* FIXME: call this with mutex hold ? */
 static int create_thread(struct thread_status *thread)
 {
 	return pthread_create(&thread->thread, NULL, monitor_thread, thread);
@@ -691,11 +733,11 @@
 	lock_mutex();
 
 	list_iterate_items(dso_data, &_dso_registry)
-		if (!strcmp(data->dso_name, dso_data->dso_name)) {
-			lib_get(dso_data);
-			ret = dso_data;
-			break;
-		}
+	    if (!strcmp(data->dso_name, dso_data->dso_name)) {
+		lib_get(dso_data);
+		ret = dso_data;
+		break;
+	}
 
 	unlock_mutex();
 
@@ -714,12 +756,12 @@
 
 static int lookup_symbols(void *dl, struct dso_data *data)
 {
-	return lookup_symbol(dl, data, (void*) &data->process_event,
+	return lookup_symbol(dl, data, (void *) &data->process_event,
 			     "process_event") &&
-	       lookup_symbol(dl, data, (void*) &data->register_device,
-			     "register_device") &&
-	       lookup_symbol(dl, data, (void*) &data->unregister_device,
-			     "unregister_device");
+	    lookup_symbol(dl, data, (void *) &data->register_device,
+			  "register_device") &&
+	    lookup_symbol(dl, data, (void *) &data->unregister_device,
+			  "unregister_device");
 }
 
 /* Load an application specific DSO. */
@@ -728,13 +770,13 @@
 	void *dl;
 	struct dso_data *ret = NULL;
 
-	if (!(dl = dlopen(data->dso_name, RTLD_NOW))){
+	if (!(dl = dlopen(data->dso_name, RTLD_NOW))) {
 		const char *dlerr = dlerror();
-		syslog(LOG_ERR, "dmeventd %s dlopen failed: %s", data->dso_name, dlerr);
-		char buf[1024]; /* FIXME */
-		snprintf(buf, 1024, "%s dlopen failed: %s", data->dso_name, dlerr);
-		data->msg->size = strlen(buf) + 1;
-		data->msg->data = dm_strdup(buf);
+		syslog(LOG_ERR, "dmeventd %s dlopen failed: %s", data->dso_name,
+		       dlerr);
+		data->msg->size =
+		    dm_saprintf(&(data->msg->data), "%s dlopen failed: %s",
+				data->dso_name, dlerr);
 		return NULL;
 	}
 
@@ -763,7 +805,6 @@
 	return ret;
 }
 
-
 /* Return success on daemon active check. */
 static int active(struct message_data *message_data)
 {
@@ -782,16 +823,9 @@
 	struct thread_status *thread, *thread_new = NULL;
 	struct dso_data *dso_data;
 
-	if (!device_exists(message_data->device_path)) {
-		stack;
-		ret = -ENODEV;
-		goto out;
-	}
-
 	if (!(dso_data = lookup_dso(message_data)) &&
 	    !(dso_data = load_dso(message_data))) {
 		stack;
-/* FIXME */
 #ifdef ELIBACC
 		ret = -ELIBACC;
 #else
@@ -799,7 +833,7 @@
 #endif
 		goto out;
 	}
-		
+
 	/* Preallocate thread status struct to avoid deadlock. */
 	if (!(thread_new = alloc_thread_status(message_data, dso_data))) {
 		stack;
@@ -807,15 +841,17 @@
 		goto out;
 	}
 
+	if (!fill_device_data(thread_new)) {
+		stack;
+		ret = -ENODEV;
+		goto out;
+	}
+
 	lock_mutex();
 
 	if (!(thread = lookup_thread_status(message_data))) {
 		unlock_mutex();
 
-		/*
-		 * FIXME: better do this asynchronously in the
-		 *        monitoring thread ?
-		 */
 		if (!(ret = do_register_device(thread_new)))
 			goto out;
 
@@ -836,7 +872,7 @@
 	/* Or event # into events bitfield. */
 	thread->events |= message_data->events.field;
 
-	unlock_mutex(); 
+	unlock_mutex();
 
 	/* FIXME - If you fail to register for timeout events, you
 	   still monitor all the other events. Is this the right
@@ -847,7 +883,7 @@
 	if (thread->events & DM_EVENT_TIMEOUT)
 		ret = -register_for_timeout(thread);
 
-   out:
+      out:
 	/*
 	 * Deallocate thread status after releasing
 	 * the lock in case we haven't used it.
@@ -894,7 +930,7 @@
 	}
 	unlock_mutex();
 
-   out:
+      out:
 	return ret;
 }
 
@@ -906,42 +942,40 @@
 static int registered_device(struct message_data *message_data,
 			     struct thread_status *thread)
 {
-	char test[1];
 	struct dm_event_daemon_message *msg = message_data->msg;
 
 	const char *fmt = "%s %s %u";
 	const char *dso = thread->dso_data->dso_name;
-	const char *dev = thread->device_path;
-	unsigned events = ((thread->status == DM_THREAD_RUNNING) && (thread->events)) ?
-			  thread->events : thread->events | DM_EVENT_REGISTRATION_PENDING;
+	const char *dev = thread->device.uuid;
+	unsigned events = ((thread->status == DM_THREAD_RUNNING)
+			   && (thread->events)) ? thread->events : thread->
+	    events | DM_EVENT_REGISTRATION_PENDING;
 
 	if (msg->data)
 		dm_free(msg->data);
 
-	msg->size = snprintf(test, 1, fmt, dso, dev, events);
-	msg->data = dm_malloc(msg->size);
-	snprintf(msg->data, msg->size, fmt, dso, dev, events);
+	msg->size = dm_saprintf(&(msg->data), fmt, dso, dev, events);
 
 	unlock_mutex();
 
 	return 0;
 }
 
-static int want_registered_device(char *dso_name, char *device_path,
+static int want_registered_device(char *dso_name, char *device_uuid,
 				  struct thread_status *thread)
 {
 	/* If DSO names and device paths are equal. */
-	if (dso_name && device_path)
+	if (dso_name && device_uuid)
 		return !strcmp(dso_name, thread->dso_data->dso_name) &&
-		       !strcmp(device_path, thread->device_path);
+		    !strcmp(device_uuid, thread->device.uuid);
 
 	/* If DSO names are equal. */
 	if (dso_name)
 		return !strcmp(dso_name, thread->dso_data->dso_name);
-		
+
 	/* If device paths are equal. */
-	if (device_path)
-		return !strcmp(device_path, thread->device_path);
+	if (device_uuid)
+		return !strcmp(device_uuid, thread->device.uuid);
 
 	return 1;
 }
@@ -955,10 +989,10 @@
 
 	/* Iterate list of threads checking if we want a particular one. */
 	list_iterate_items(thread, &_thread_registry)
-		if ((hit = want_registered_device(message_data->dso_name,
-						  message_data->device_path,
-						  thread)))
-			break;
+	    if ((hit = want_registered_device(message_data->dso_name,
+					      message_data->device_uuid,
+					      thread)))
+		break;
 
 	/*
 	 * If we got a registered device and want the next one ->
@@ -970,15 +1004,13 @@
 	do {
 		if (list_end(&_thread_registry, &thread->list))
 			goto out;
-		
-		thread = list_item(thread->list.n,
-				   struct thread_status);
-	} while (!want_registered_device(message_data->dso_name,
-					 NULL, thread));
+
+		thread = list_item(thread->list.n, struct thread_status);
+	} while (!want_registered_device(message_data->dso_name, NULL, thread));
 
 	return registered_device(message_data, thread);
 
-   out:
+      out:
 	unlock_mutex();
 
 	return -ENOENT;
@@ -1000,7 +1032,7 @@
 
 	lock_mutex();
 	if ((thread = lookup_thread_status(message_data)))
-		thread->timeout = message_data->timeout.secs; 
+		thread->timeout = message_data->timeout.secs;
 	unlock_mutex();
 
 	return thread ? 0 : -ENODEV;
@@ -1016,9 +1048,8 @@
 
 	lock_mutex();
 	if ((thread = lookup_thread_status(message_data))) {
-		msg->data = dm_malloc(8*sizeof(uint32_t)); /* FIXME */
-		msg->size = snprintf(msg->data, 8*sizeof(uint32_t),
-				     "%"PRIu32, thread->timeout);
+		msg->size =
+		    dm_saprintf(&(msg->data), "%" PRIu32, thread->timeout);
 	} else {
 		msg->data = NULL;
 		msg->size = 0;
@@ -1027,7 +1058,6 @@
 
 	return thread ? 0 : -ENODEV;
 }
-	
 
 /* Initialize a fifos structure with path names. */
 static void init_fifos(struct dm_event_fifos *fifos)
@@ -1049,17 +1079,27 @@
 		return -errno;
 	}
 
-	/* FIXME Warn/abort if perms are wrong - not something to fix silently. */
+	struct stat st;
+
+	/* Warn about wrong permissions if applicable */
+	if ((!stat(fifos->client_path, &st)) && (st.st_mode & 0777) != 0600)
+		syslog(LOG_WARNING, "Fixing wrong permissions on %s",
+		       fifos->client_path);
+
+	if ((!stat(fifos->server_path, &st)) && (st.st_mode & 0777) != 0600)
+		syslog(LOG_WARNING, "Fixing wrong permissions on %s",
+		       fifos->server_path);
+
 	/* If they were already there, make sure permissions are ok. */
 	if (chmod(fifos->client_path, 0600)) {
 		syslog(LOG_ERR, "Unable to set correct file permissions on %s",
-			  fifos->client_path);
+		       fifos->client_path);
 		return -errno;
 	}
 
 	if (chmod(fifos->server_path, 0600)) {
 		syslog(LOG_ERR, "Unable to set correct file permissions on %s",
-			  fifos->server_path);
+		       fifos->server_path);
 		return -errno;
 	}
 
@@ -1083,7 +1123,8 @@
  * Read message from client making sure that data is available
  * and a complete message is read.  Must not block indefinitely.
  */
-static int client_read(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg)
+static int client_read(struct dm_event_fifos *fifos,
+		       struct dm_event_daemon_message *msg)
 {
 	struct timeval t;
 	unsigned bytes = 0;
@@ -1102,22 +1143,22 @@
 		FD_SET(fifos->client, &fds);
 		t.tv_sec = 1;
 		t.tv_usec = 0;
-		ret = select(fifos->client+1, &fds, NULL, NULL, &t);
+		ret = select(fifos->client + 1, &fds, NULL, NULL, &t);
 
-		if (!ret && !bytes) /* nothing to read */
+		if (!ret && !bytes)	/* nothing to read */
 			return 0;
 
-		if (!ret)     /* trying to finish read */
+		if (!ret)	/* trying to finish read */
 			continue;
 
-		if (ret < 0)  /* error */
+		if (ret < 0)	/* error */
 			return 0;
 
 		ret = read(fifos->client, buf + bytes, size - bytes);
 		bytes += ret > 0 ? ret : 0;
-		if (bytes == 2*sizeof(uint32_t) && header) {
-			msg->cmd = ntohl(*((uint32_t *)buf));
-			msg->size = ntohl(*((uint32_t *)buf + 1));
+		if (bytes == 2 * sizeof(uint32_t) && header) {
+			msg->cmd = ntohl(*((uint32_t *) buf));
+			msg->size = ntohl(*((uint32_t *) buf + 1));
 			buf = msg->data = dm_malloc(msg->size);
 			size = msg->size;
 			bytes = 0;
@@ -1129,6 +1170,7 @@
 		if (msg->data)
 			dm_free(msg->data);
 		msg->data = NULL;
+		msg->size = 0;
 	}
 
 	return bytes == size;
@@ -1137,18 +1179,20 @@
 /*
  * Write a message to the client making sure that it is ready to write.
  */
-static int client_write(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg)
+static int client_write(struct dm_event_fifos *fifos,
+			struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
 	int ret = 0;
 	fd_set fds;
 
-	size_t size = 2*sizeof(uint32_t) + msg->size;
+	size_t size = 2 * sizeof(uint32_t) + msg->size;
 	char *buf = alloca(size);
 
 	*((uint32_t *)buf) = htonl(msg->cmd);
 	*((uint32_t *)buf + 1) = htonl(msg->size);
-	memcpy(buf + 2*sizeof(uint32_t), msg->data, msg->size);
+	if (msg->data)
+		memcpy(buf + 2 * sizeof(uint32_t), msg->data, msg->size);
 
 	errno = 0;
 	while (bytes < size && errno != EIO) {
@@ -1156,7 +1200,8 @@
 			/* Watch client write FIFO to be ready for output. */
 			FD_ZERO(&fds);
 			FD_SET(fifos->server, &fds);
-		} while (select(fifos->server +1, NULL, &fds, NULL, NULL) != 1);
+		} while (select(fifos->server + 1, NULL, &fds, NULL, NULL) !=
+			 1);
 
 		ret = write(fifos->server, buf + bytes, size - bytes);
 		bytes += ret > 0 ? ret : 0;
@@ -1176,15 +1221,16 @@
 {
 	static struct {
 		unsigned int cmd;
-		int (*f)(struct message_data*);
+		int (*f)(struct message_data *);
 	} requests[] = {
-		{ DM_EVENT_CMD_REGISTER_FOR_EVENT,	   register_for_event },
-		{ DM_EVENT_CMD_UNREGISTER_FOR_EVENT,       unregister_for_event },
-		{ DM_EVENT_CMD_GET_REGISTERED_DEVICE,      get_registered_device },
-		{ DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE, get_next_registered_device },
-		{ DM_EVENT_CMD_SET_TIMEOUT,		   set_timeout },
-		{ DM_EVENT_CMD_GET_TIMEOUT,		   get_timeout },
-		{ DM_EVENT_CMD_ACTIVE,			   active },
+		{ DM_EVENT_CMD_REGISTER_FOR_EVENT, register_for_event},
+		{ DM_EVENT_CMD_UNREGISTER_FOR_EVENT, unregister_for_event},
+		{ DM_EVENT_CMD_GET_REGISTERED_DEVICE, get_registered_device},
+		{ DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE,
+			get_next_registered_device},
+		{ DM_EVENT_CMD_SET_TIMEOUT, set_timeout},
+		{ DM_EVENT_CMD_GET_TIMEOUT, get_timeout},
+		{ DM_EVENT_CMD_ACTIVE, active},
 	}, *req;
 
 	for (req = requests; req < requests + sizeof(requests); req++)
@@ -1203,8 +1249,7 @@
 	/* Parse the message. */
 	memset(&message_data, 0, sizeof(message_data));
 	message_data.msg = msg;
-	if (msg->cmd != DM_EVENT_CMD_ACTIVE &&
-	    !parse_message(&message_data)) {
+	if (msg->cmd != DM_EVENT_CMD_ACTIVE && !parse_message(&message_data)) {
 		stack;
 		ret = -EINVAL;
 	} else
@@ -1220,15 +1265,11 @@
 {
 	struct dm_event_daemon_message msg;
 
-	/* FIXME: better error handling */
-
 	memset(&msg, 0, sizeof(msg));
 
 	/*
-	 * Read the request from the client.
-	 * Of course, it's tough to tell what to do when
-	 * we use fucking retarded return codes like
-	 * 0 for error.
+	 * Read the request from the client (client_read, client_write
+	 * give true on success and false on failure).
 	 */
 	if (!client_read(fifos, &msg))
 		return;
@@ -1236,7 +1277,12 @@
 	msg.cmd = do_process_request(&msg);
 	if (!msg.data) {
 		msg.data = dm_strdup(strerror(-msg.cmd));
-		msg.size = strlen(msg.data) + 1;
+		if (msg.data)
+			msg.size = strlen(msg.data) + 1;
+		else {
+			msg.size = 0;
+			stack;
+		}
 	}
 
 	if (!client_write(fifos, &msg))
@@ -1256,7 +1302,7 @@
 	while ((l = list_first(&_thread_registry_unused))) {
 		thread = list_item(l, struct thread_status);
 		if (thread->processing) {
-			goto out;  /* cleanup on the next round */
+			goto out;	/* cleanup on the next round */
 		}
 
 		if (thread->status == DM_THREAD_RUNNING) {
@@ -1270,14 +1316,16 @@
 				if (ret == ESRCH) {
 					thread->status = DM_THREAD_DONE;
 				} else if (ret) {
-					syslog(LOG_ERR, "Unable to terminate thread: %s\n",
+					syslog(LOG_ERR,
+					       "Unable to terminate thread: %s\n",
 					       strerror(-ret));
 					stack;
 				}
 				goto out;
 			} else {
 				list_del(l);
-				syslog(LOG_ERR, "thread can't be on unused list unless !thread->events");
+				syslog(LOG_ERR,
+				       "thread can't be on unused list unless !thread->events");
 				thread->status = DM_THREAD_RUNNING;
 				LINK_THREAD(thread);
 			}
@@ -1288,7 +1336,7 @@
 			free_thread_status(thread);
 		}
 	}
-out:
+      out:
 	unlock_mutex();
 }
 
@@ -1302,7 +1350,7 @@
 {
 	sigset_t my_sigset;
 	struct sigaction act;
-	
+
 	memset(&act, 0, sizeof(act));
 	act.sa_handler = sig_alarm;
 	sigaction(SIGALRM, &act, NULL);
@@ -1344,7 +1392,7 @@
 static int lock_pidfile(void)
 {
 	int lf;
-	char pidfile[] = "/var/run/dmeventd.pid"; /* FIXME Must be configurable at compile-time! */
+	char pidfile[] = DMEVENTD_PIDFILE;
 
 	if ((lf = open(pidfile, O_CREAT | O_RDWR, 0644)) < 0)
 		exit(EXIT_OPEN_PID_FAILURE);
@@ -1383,11 +1431,11 @@
 		/* Wait for response from child */
 		while (!waitpid(pid, &status, WNOHANG) && !_exit_now) {
 			tval.tv_sec = 0;
-			tval.tv_usec = 250000; /* .25 sec */
+			tval.tv_usec = 250000;	/* .25 sec */
 			select(0, NULL, NULL, NULL, &tval);
 		}
 
-		if (_exit_now) /* Child has signaled it is ok - we can exit now */
+		if (_exit_now)	/* Child has signaled it is ok - we can exit now */
 			exit(EXIT_SUCCESS);
 
 		/* Problem with child.  Determine what it is by exit code */
@@ -1408,7 +1456,7 @@
 			break;
 		}
 
-		exit(EXIT_FAILURE);  /* Redundant */
+		exit(EXIT_FAILURE);	/* Redundant */
 	}
 
 	setsid();
@@ -1416,7 +1464,7 @@
 		exit(EXIT_CHDIR_FAILURE);
 
 	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
-		fd = 256;  /* just have to guess */
+		fd = 256;	/* just have to guess */
 	else
 		fd = rlim.rlim_cur;
 
@@ -1430,7 +1478,7 @@
 
 	openlog("dmeventd", LOG_PID, LOG_DAEMON);
 
-	lock_pidfile();  /* exits if failure */
+	lock_pidfile();		/* exits if failure */
 
 	/* Set the rest of the signals to cause '_exit_now' to be set */
 	signal(SIGINT, &exit_handler);
@@ -1472,7 +1520,8 @@
 	while (!_exit_now) {
 		process_request(&fifos);
 		cleanup_unused_threads();
-		if (!list_empty(&_thread_registry) || !list_empty(&_thread_registry_unused))
+		if (!list_empty(&_thread_registry)
+		    || !list_empty(&_thread_registry_unused))
 			_thread_registries_empty = 0;
 		else
 			_thread_registries_empty = 1;
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/08 15:18:52	1.10
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/11 21:54:52	1.11
@@ -28,45 +28,112 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <sys/wait.h>
-#include <arpa/inet.h> /* for htonl, ntohl */
+#include <arpa/inet.h>		/* for htonl, ntohl */
 
-/* Set by any of the external fxns the first time one of them is called */
-/* FIXME Unused */
-// static int _logging = 0;
+struct dm_event_handler {
+	const char *dso;
+	const char *device;
+	const char *uuid;
+	int major;
+	int minor;
+	enum dm_event_type events;
+};
 
-/* Fetch a string off src and duplicate it into *dest. */
-/* FIXME: move to seperate module to share with the daemon. */
-static const char delimiter = ' ';
-static char *fetch_string(char **src)
+static void dm_event_handler_clear_device(struct dm_event_handler *h)
 {
-	char *p, *ret;
+	h->device = h->uuid = NULL;
+	h->major = h->minor = 0;
+}
 
-	if ((p = strchr(*src, delimiter)))
-		*p = 0;
+struct dm_event_handler *dm_event_handler_create(void)
+{
+	struct dm_event_handler *ret = 0;
 
-	if ((ret = dm_strdup(*src)))
-		*src += strlen(ret) + 1;
+	if (!(ret = dm_malloc(sizeof(*ret))))
+		return NULL;
 
-	if (p)
-		*p = delimiter;
+	ret->dso = ret->device = ret->uuid = NULL;
+	ret->major = ret->minor = 0;
+	ret->events = 0;
 
 	return ret;
 }
 
-/* Parse a device message from the daemon. */
-static int parse_message(struct dm_event_daemon_message *msg, char **dso_name,
-			 char **device, enum dm_event_type *events)
+void dm_event_handler_destroy(struct dm_event_handler *h)
 {
-	char *p = msg->data;
+	dm_free(h);
+}
 
-	if ((*dso_name = fetch_string(&p)) &&
-	    (*device   = fetch_string(&p))) {
-		*events = atoi(p);
+void dm_event_handler_set_dso(struct dm_event_handler *h, const char *path)
+{
+	h->dso = path;
+}
 
-		return 0;
-	}
+void dm_event_handler_set_name(struct dm_event_handler *h, const char *name)
+{
+	dm_event_handler_clear_device(h);
+	h->device = name;
+}
 
-	return -ENOMEM;
+void dm_event_handler_set_uuid(struct dm_event_handler *h, const char *uuid)
+{
+	dm_event_handler_clear_device(h);
+	h->uuid = uuid;
+}
+
+void dm_event_handler_set_major(struct dm_event_handler *h, int major)
+{
+	int minor = h->minor;
+
+	dm_event_handler_clear_device(h);
+	h->major = major;
+	h->minor = minor;
+}
+
+void dm_event_handler_set_minor(struct dm_event_handler *h, int minor)
+{
+	int major = h->major;
+
+	dm_event_handler_clear_device(h);
+
+	h->major = major;
+	h->minor = minor;
+}
+
+void dm_event_handler_set_events(struct dm_event_handler *h,
+				 enum dm_event_type event)
+{
+	h->events = event;
+}
+
+const char *dm_event_handler_get_dso(const struct dm_event_handler *h)
+{
+	return h->dso;
+}
+
+const char *dm_event_handler_get_name(const struct dm_event_handler *h)
+{
+	return h->device;
+}
+
+const char *dm_event_handler_get_uuid(const struct dm_event_handler *h)
+{
+	return h->uuid;
+}
+
+int dm_event_handler_get_major(const struct dm_event_handler *h)
+{
+	return h->major;
+}
+
+int dm_event_handler_get_minor(const struct dm_event_handler *h)
+{
+	return h->minor;
+}
+
+enum dm_event_type dm_event_handler_get_events(const struct dm_event_handler *h)
+{
+	return h->events;
 }
 
 /*
@@ -78,13 +145,14 @@
  *
  * Returns: 0 on failure, 1 on success
  */
-static int daemon_read(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg)
+static int daemon_read(struct dm_event_fifos *fifos,
+		       struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
 	int ret, i;
 	fd_set fds;
-	struct timeval tval = {0, 0};
-	size_t size = 2 * sizeof(uint32_t); // status + size
+	struct timeval tval = { 0, 0 };
+	size_t size = 2 * sizeof(uint32_t);	/* status + size */
 	char *buf = alloca(size);
 	int header = 1;
 
@@ -94,7 +162,8 @@
 			FD_ZERO(&fds);
 			FD_SET(fifos->server, &fds);
 			tval.tv_sec = 1;
-			ret = select(fifos->server+1, &fds, NULL, NULL, &tval);
+			ret = select(fifos->server + 1, &fds, NULL, NULL,
+				     &tval);
 			if (ret < 0 && errno != EINTR) {
 				log_error("Unable to read from event server");
 				return 0;
@@ -116,7 +185,7 @@
 		}
 
 		bytes += ret;
-		if (bytes == 2*sizeof(uint32_t) && header) {
+		if (bytes == 2 * sizeof(uint32_t) && header) {
 			msg->cmd = ntohl(*((uint32_t *)buf));
 			msg->size = ntohl(*((uint32_t *)buf + 1));
 			buf = msg->data = dm_malloc(msg->size);
@@ -136,32 +205,34 @@
 }
 
 /* Write message to daemon. */
-static int daemon_write(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg)
+static int daemon_write(struct dm_event_fifos *fifos,
+			struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
 	int ret = 0;
 	fd_set fds;
 
-	size_t size = 2*sizeof(uint32_t) + msg->size;
+	size_t size = 2 * sizeof(uint32_t) + msg->size;
 	char *buf = alloca(size);
 
 	*((uint32_t *)buf) = htonl(msg->cmd);
 	*((uint32_t *)buf + 1) = htonl(msg->size);
-	memcpy(buf + 2*sizeof(uint32_t), msg->data, msg->size);
+	memcpy(buf + 2 * sizeof(uint32_t), msg->data, msg->size);
 
 	while (bytes < size) {
 		do {
 			/* Watch daemon write FIFO to be ready for output. */
 			FD_ZERO(&fds);
 			FD_SET(fifos->client, &fds);
-			ret = select(fifos->client +1, NULL, &fds, NULL, NULL);
+			ret = select(fifos->client + 1, NULL, &fds, NULL, NULL);
 			if ((ret < 0) && (errno != EINTR)) {
 				log_error("Unable to talk to event daemon");
 				return 0;
 			}
 		} while (ret < 1);
 
-		ret = write(fifos->client, ((char *) buf) + bytes, size - bytes);
+		ret = write(fifos->client, ((char *) buf) + bytes,
+			    size - bytes);
 		if (ret < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
@@ -177,14 +248,14 @@
 	return bytes == size;
 }
 
-static int daemon_talk(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg,
-		       int cmd, const char *dso_name, const char *device,
+static int daemon_talk(struct dm_event_fifos *fifos,
+		       struct dm_event_daemon_message *msg, int cmd,
+		       const char *dso_name, const char *device,
 		       enum dm_event_type events, uint32_t timeout)
 {
-	char test[1];
 	const char *dso = dso_name ? dso_name : "";
 	const char *dev = device ? device : "";
-	const char *fmt = "%s %s %u %"PRIu32;
+	const char *fmt = "%s %s %u %" PRIu32;
 	memset(msg, 0, sizeof(*msg));
 
 	/*
@@ -192,10 +263,7 @@
 	 * into ASCII message string.
 	 */
 	msg->cmd = cmd;
-	/* FIXME depends on glibc 2.1+ */
-	msg->size = snprintf(test, 1, fmt, dso, dev, events, timeout);
-	msg->data = alloca(msg->size);
-	snprintf(msg->data, msg->size, fmt, dso, dev, events, timeout);
+	msg->size = dm_saprintf(&(msg->data), fmt, dso, dev, events, timeout);
 
 	/*
 	 * Write command and message to and
@@ -256,7 +324,7 @@
 		return 0;
 	}
 
-start_server:
+      start_server:
 	/* server is not running */
 	pid = fork();
 
@@ -264,11 +332,13 @@
 		log_error("Unable to fork.");
 
 	else if (!pid) {
-		execvp("dmeventd", NULL); /* security risk if admin has bad PATH */
+		/* FIXME configure path (cf. lvm2 modprobe) */
+		execvp("dmeventd", NULL);
 		exit(EXIT_FAILURE);
 	} else {
 		if (waitpid(pid, &status, 0) < 0)
-			log_error("Unable to start dmeventd: %s", strerror(errno));
+			log_error("Unable to start dmeventd: %s",
+				  strerror(errno));
 		else if (WEXITSTATUS(status))
 			log_error("Unable to start dmeventd.");
 		else
@@ -281,8 +351,8 @@
 /* Initialize client. */
 static int init_client(struct dm_event_fifos *fifos)
 {
-	/* FIXME Is fifo the most suitable method? */
-	/* FIXME Why not share comms/daemon code with something else e.g. multipath? */
+	/* FIXME? Is fifo the most suitable method? Why not share
+	   comms/daemon code with something else e.g. multipath? */
 
 	/* init fifos */
 	memset(fifos, 0, sizeof(*fifos));
@@ -297,20 +367,19 @@
 	/* Open the fifo used to read from the daemon. */
 	if ((fifos->server = open(fifos->server_path, O_RDWR)) < 0) {
 		log_error("%s: open server fifo %s",
-			__func__, fifos->server_path);
+			  __func__, fifos->server_path);
 		stack;
 		return 0;
 	}
 
 	/* Lock out anyone else trying to do communication with the daemon. */
-	if (flock(fifos->server, LOCK_EX) < 0){
+	if (flock(fifos->server, LOCK_EX) < 0) {
 		log_error("%s: flock %s", __func__, fifos->server_path);
 		close(fifos->server);
 		return 0;
 	}
 
-/*	if ((fifos->client = open(fifos->client_path,
-  O_WRONLY | O_NONBLOCK)) < 0) {*/
+/*	if ((fifos->client = open(fifos->client_path, O_WRONLY | O_NONBLOCK)) < 0) {*/
 	if ((fifos->client = open(fifos->client_path, O_RDWR | O_NONBLOCK)) < 0) {
 		log_error("%s: Can't open client fifo %s: %s",
 			  __func__, fifos->client_path, strerror(errno));
@@ -318,7 +387,7 @@
 		stack;
 		return 0;
 	}
-	
+
 	return 1;
 }
 
@@ -331,65 +400,72 @@
 	close(fifos->server);
 }
 
-/* Check, if a block device exists. */
-static int device_exists(const char *device)
+/* Get uuid of a device, if it exists (otherwise NULL). */
+static struct dm_task *get_device_info(const struct dm_event_handler *h)
 {
-	struct stat st_buf;
-	char path2[PATH_MAX];
+	struct dm_task *dmt = dm_task_create(DM_DEVICE_INFO);
+	struct dm_task *ret;
 
-	if (!device)
-		return 0;
-
-	if (device[0] == '/') /* absolute path */
-		return !stat(device, &st_buf) && S_ISBLK(st_buf.st_mode);
+	if (!dmt)
+		return NULL;
 
-	if (PATH_MAX <= snprintf(path2, PATH_MAX, "%s/%s", dm_dir(), device))
-		return 0;
+	if (h->uuid)
+		dm_task_set_uuid(dmt, h->uuid);
+	else if (h->device)
+		dm_task_set_name(dmt, h->device);
+	else if (h->major && h->minor) {
+		dm_task_set_major(dmt, h->major);
+		dm_task_set_minor(dmt, h->minor);
+	}
+
+	if (!dm_task_run(dmt))
+		ret = NULL;
+	else
+		ret = dmt;
 
-	return !stat(path2, &st_buf) && S_ISBLK(st_buf.st_mode);
+	return ret;
 }
 
 /* Handle the event (de)registration call and return negative error codes. */
 static int do_event(int cmd, struct dm_event_daemon_message *msg,
-		    const char *dso_name, const char *device, enum dm_event_type events,
-		    uint32_t timeout)
+		    const char *dso_name, const char *device,
+		    enum dm_event_type events, uint32_t timeout)
 {
 	int ret;
 	struct dm_event_fifos fifos;
 
-	/* FIXME Start the daemon here if it's not running e.g. exclusive lock file */
-	/* FIXME Move this to separate 'dm_event_register_handler' - if no daemon here, fail */
 	if (!init_client(&fifos)) {
 		stack;
 		return -ESRCH;
 	}
 
-	/* FIXME Use separate 'dm_event_register_handler' function to pass in dso? */
 	ret = daemon_talk(&fifos, msg, cmd, dso_name, device, events, timeout);
 
 	/* what is the opposite of init? */
 	dtr_client(&fifos);
-	
+
 	return ret;
 }
 
-/* FIXME remove dso_name - use handle instead */
-/* FIXME Use uuid not path! */
 /* External library interface. */
-int dm_event_register(const char *dso_name, const char *device_path,
-		      enum dm_event_type events)
+int dm_event_register(const struct dm_event_handler *h)
 {
 	int ret, err;
+	const char *uuid;
+	struct dm_task *dmt;
 	struct dm_event_daemon_message msg;
 
-	if (!device_exists(device_path)) {
-		log_error("%s: device not found", device_path);
+	if (!(dmt = get_device_info(h))) {
+		log_error("%s: device not found", h->device);
 		return 0;
 	}
 
+	uuid = dm_task_get_uuid(dmt);
+
 	if ((err = do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
-			    dso_name, device_path, events, 0)) < 0) {
-		log_error("%s: event registration failed: %s", device_path,
+			    h->dso, uuid, h->events, 0)) < 0) {
+		log_error("%s: event registration failed: %s",
+			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
 		ret = 0;
 	} else
@@ -398,23 +474,29 @@
 	if (msg.data)
 		dm_free(msg.data);
 
+	dm_task_destroy(dmt);
+
 	return ret;
 }
 
-int dm_event_unregister(const char *dso_name, const char *device_path,
-			enum dm_event_type events)
+int dm_event_unregister(const struct dm_event_handler *h)
 {
 	int ret, err;
+	const char *uuid;
+	struct dm_task *dmt;
 	struct dm_event_daemon_message msg;
 
-	if (!device_exists(device_path)) {
-		log_error("%s: device not found", device_path);
+	if (!(dmt = get_device_info(h))) {
+		log_error("%s: device not found", dm_task_get_name(dmt));
 		return 0;
 	}
 
+	uuid = dm_task_get_uuid(dmt);
+
 	if ((err = do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
-			    dso_name, device_path, events, 0)) < 0) {
-		log_error("%s: event deregistration failed: %s", device_path,
+			    h->dso, uuid, h->events, 0)) < 0) {
+		log_error("%s: event deregistration failed: %s",
+			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
 		ret = 0;
 	} else
@@ -422,9 +504,48 @@
 
 	if (msg.data)
 		dm_free(msg.data);
+
+	dm_task_destroy(dmt);
+
 	return ret;
 }
 
+#if 0				/* left out for now */
+
+/* Fetch a string off src and duplicate it into *dest. */
+/* FIXME: move to seperate module to share with the daemon. */
+static const char delimiter = ' ';
+static char *fetch_string(char **src)
+{
+	char *p, *ret;
+
+	if ((p = strchr(*src, delimiter)))
+		*p = 0;
+
+	if ((ret = dm_strdup(*src)))
+		*src += strlen(ret) + 1;
+
+	if (p)
+		*p = delimiter;
+
+	return ret;
+}
+
+/* Parse a device message from the daemon. */
+static int parse_message(struct dm_event_daemon_message *msg, char **dso_name,
+			 char **device, enum dm_event_type *events)
+{
+	char *p = msg->data;
+
+	if ((*dso_name = fetch_string(&p)) && (*device = fetch_string(&p))) {
+		*events = atoi(p);
+
+		return 0;
+	}
+
+	return -ENOMEM;
+}
+
 /*
  * dm_event_get_registered_device
  * @dso_name
@@ -437,18 +558,18 @@
  * Returns: 1 if device found, 0 otherwise (even on error)
  */
 int dm_event_get_registered_device(char **dso_name, char **device_path,
-			     enum dm_event_type *events, int next)
+				   enum dm_event_type *events, int next)
 {
 	int ret;
 	char *dso_name_arg = NULL, *device_path_arg = NULL;
 	struct dm_event_daemon_message msg;
 
 	if (!(ret = do_event(next ? DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE :
-				    DM_EVENT_CMD_GET_REGISTERED_DEVICE,
+			     DM_EVENT_CMD_GET_REGISTERED_DEVICE,
 			     &msg, *dso_name, *device_path, *events, 0))) {
 		ret = !parse_message(&msg, &dso_name_arg, &device_path_arg,
 				     events);
-	} else /* FIXME: Make sure this is ENOENT */
+	} else			/* FIXME: Make sure this is ENOENT */
 		ret = 0;
 
 	if (msg.data)
@@ -488,9 +609,11 @@
 
 	if (!device_exists(device_path))
 		return -ENODEV;
-	if (!(ret = do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path, 0, 0)))
+	if (!(ret = do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path,
+			     0, 0)))
 		*timeout = atoi(msg.data);
 	if (msg.data)
 		dm_free(msg.data);
 	return ret;
 }
+#endif
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/08 15:18:52	1.4
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/11 21:54:52	1.5
@@ -24,50 +24,70 @@
 #include <stdint.h>
 
 /* Event type definitions. */
-/* FIXME Use masks to separate the types and provide for extension. */
 enum dm_event_type {
-	DM_EVENT_SINGLE		= 0x01, /* Report multiple errors just once. */
-	DM_EVENT_MULTI		= 0x02, /* Report all of them. */
+	DM_EVENT_SETTINGS_MASK  = 0x0000FF,
+	DM_EVENT_SINGLE		= 0x000001, /* Report multiple errors just once. */
+	DM_EVENT_MULTI		= 0x000002, /* Report all of them. */
+
+	DM_EVENT_ERROR_MASK     = 0x00FF00,
+	DM_EVENT_SECTOR_ERROR	= 0x000100, /* Failure on a particular sector. */
+	DM_EVENT_DEVICE_ERROR	= 0x000200, /* Device failure. */
+	DM_EVENT_PATH_ERROR	= 0x000400, /* Failure on an io path. */
+	DM_EVENT_ADAPTOR_ERROR	= 0x000800, /* Failure off a host adaptor. */
+
+	DM_EVENT_STATUS_MASK    = 0xFF0000,
+	DM_EVENT_SYNC_STATUS	= 0x010000, /* Mirror synchronization completed/failed. */
+	DM_EVENT_TIMEOUT	= 0x020000, /* Timeout has occured */
 
-	DM_EVENT_SECTOR_ERROR	= 0x04, /* Failure on a particular sector. */
-	DM_EVENT_DEVICE_ERROR	= 0x08, /* Device failure. */
-	DM_EVENT_PATH_ERROR	= 0x10, /* Failure on an io path. */
-	DM_EVENT_ADAPTOR_ERROR	= 0x20, /* Failure off a host adaptor. */
-
-	DM_EVENT_SYNC_STATUS	= 0x40, /* Mirror synchronization completed/failed. */
-	DM_EVENT_TIMEOUT	= 0x80, /* Timeout has occured */
-	DM_EVENT_REGISTRATION_PENDING        = 0X100, /* Monitor thread is setting-up/shutting-down */
+	DM_EVENT_REGISTRATION_PENDING = 0x1000000, /* Monitor thread is setting-up/shutting-down */
 };
 
-/* FIXME Use a mask. */
-#define	DM_EVENT_ALL_ERRORS (DM_EVENT_SECTOR_ERROR | DM_EVENT_DEVICE_ERROR | \
-			     DM_EVENT_PATH_ERROR | DM_EVENT_ADAPTOR_ERROR)
+#define DM_EVENT_ALL_ERRORS DM_EVENT_ERROR_MASK
 
 /* Prototypes for event lib interface. */
 
-/* FIXME Replace device with standard name/uuid/devno choice */
-/* Interface changes: 
-   First register a handler, passing in a unique ref for the device. */
-
-//  int dm_event_register_handler(const char *dso_name, const char *device);
-//  int dm_event_register(const char *dso_name, const char *name, const char *uuid, uint32_t major, uint32_t minor, enum dm_event_type events);
-
-/* Or (better?) add to task structure and use existing functions - run
-   a task to register/unregister events - we may need to run task
-   withe that with the new event mechanism anyway, then the dso calls
-   just hook in. */
- 
-int dm_event_register(const char *dso_name, const char *device, enum dm_event_type events);
-int dm_event_unregister(const char *dso_name, const char *device,
-			enum dm_event_type events);
-int dm_event_get_registered_device(char **dso_name, char **device,
-				   enum dm_event_type *events, int next);
-int dm_event_set_timeout(const char *device, uint32_t timeout);
-int dm_event_get_timeout(const char *device, uint32_t *timeout);
-
-/* Prototypes for DSO interface. */
-void process_event(const char *device, enum dm_event_type event);
-int register_device(const char *device);
-int unregister_device(const char *device);
+struct dm_event_handler;
+
+/* Create and destroy dm_event_handler struct, which is passed to
+   register/unregister functions below */
+struct dm_event_handler *dm_event_handler_create(void);
+void dm_event_handler_destroy(struct dm_event_handler *h);
+
+/* Set parameters of a handler:
+   - dso - shared library path to handle the events
+   (only one of the following three needs to be set)
+   - name - device name or path
+   - uuid - device uuid
+   - major and minor - device major/minor numbers
+   - events - a bitfield defining which events to handle (see
+              enum dm_event_type above)
+*/
+void dm_event_handler_set_dso(struct dm_event_handler *h, const char *path);
+void dm_event_handler_set_name(struct dm_event_handler *h, const char *name);
+void dm_event_handler_set_uuid(struct dm_event_handler *h, const char *uuid);
+void dm_event_handler_set_major(struct dm_event_handler *h, int major);
+void dm_event_handler_set_minor(struct dm_event_handler *h, int minor);
+void dm_event_handler_set_events(struct dm_event_handler *h,
+				 enum dm_event_type event);
+
+/* Get parameters of a handler, same as above */
+const char *dm_event_handler_get_dso(const struct dm_event_handler *h);
+const char *dm_event_handler_get_name(const struct dm_event_handler *h);
+const char *dm_event_handler_get_uuid(const struct dm_event_handler *h);
+int dm_event_handler_get_major(const struct dm_event_handler *h);
+int dm_event_handler_get_minor(const struct dm_event_handler *h);
+enum dm_event_type dm_event_handler_get_events(const struct dm_event_handler *h);
+
+/* Call out to dmeventd to register or unregister a handler. If
+   dmeventd is not running, it is spawned first. */
+int dm_event_register(const struct dm_event_handler *h);
+int dm_event_unregister(const struct dm_event_handler *h);
+
+/* Prototypes for DSO interface, see dmeventd.c, struct dso_data for
+   detailed descriptions. */
+void process_event(struct dm_task *dmt, enum dm_event_type event);
+int register_device(const char *device, const char *uuid, int major, int minor);
+int unregister_device(const char *device, const char *uuid, int major,
+		      int minor);
 
 #endif
--- device-mapper/include/configure.h.in	2006/10/12 15:42:24	1.2
+++ device-mapper/include/configure.h.in	2007/01/11 21:54:52	1.3
@@ -3,6 +3,9 @@
 /* Define to 1 if the `closedir' function returns void instead of `int'. */
 #undef CLOSEDIR_VOID
 
+/* Path to dmeventd pidfile. */
+#undef DMEVENTD_PIDFILE
+
 /* Define to 1 if canonicalize_file_name is available. */
 #undef HAVE_CANONICALIZE_FILE_NAME
 
@@ -168,11 +171,9 @@
 /* Define to empty if `const' does not conform to ANSI C. */
 #undef const
 
-/* Define to `__inline__' or `__inline' if that's what the C compiler
-   calls it, or to nothing if 'inline' is not supported under any name.  */
-#ifndef __cplusplus
+/* Define as `__inline' if that's what the C compiler calls it, or to nothing
+   if it is not supported. */
 #undef inline
-#endif
 
 /* Define to rpl_malloc if the replacement function should be used. */
 #undef malloc
--- device-mapper/lib/.exported_symbols	2007/01/09 19:44:07	1.25
+++ device-mapper/lib/.exported_symbols	2007/01/11 21:54:53	1.26
@@ -115,3 +115,4 @@
 dm_split_words
 dm_snprintf
 dm_basename
+dm_saprintf
--- device-mapper/lib/libdevmapper.h	2007/01/09 19:44:07	1.61
+++ device-mapper/lib/libdevmapper.h	2007/01/11 21:54:53	1.62
@@ -623,4 +623,10 @@
  */
 char *dm_basename(const char *path);
 
+/*
+ * Returns size of a buffer which is allocated with dm_malloc.
+ * Pointer to the buffer is stored in *buf.
+ */
+int dm_saprintf(char **buf, const char *format, ...);
+
 #endif				/* LIB_DEVICE_MAPPER_H */
--- device-mapper/lib/libdm-string.c	2007/01/08 15:35:08	1.4
+++ device-mapper/lib/libdm-string.c	2007/01/11 21:54:53	1.5
@@ -129,3 +129,33 @@
 	return p ? p + 1 : (char *) path;
 }
 
+int dm_saprintf(char **result, const char *format, ...)
+{
+	int n, ok = 0, size = 32;
+	va_list ap;
+	char *buf = dm_malloc(size);
+
+	*result = 0;
+
+	if (!buf)
+		return -1;
+
+	while (!ok) {
+		va_start(ap, format);
+		n = vsnprintf(buf, size, format, ap);
+		if (0 <= n && n < size)
+			ok = 1;
+		else {
+			dm_free(buf);
+			size *= 2;
+			buf = dm_malloc(size);
+			if (!buf)
+				return -1;
+		};
+		va_end(ap);
+	}
+
+	*result = dm_strdup(buf);
+	dm_free(buf);
+	return n + 1;
+}
