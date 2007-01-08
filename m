From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/Makefile.in ...
Date: 8 Jan 2007 15:18:54 -0000
Message-ID: <20070108151854.12588.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-08 15:18:53

Modified files:
	.              : WHATS_NEW 
	dmeventd       : Makefile.in dmeventd.c dmeventd.h 
	                 libdevmapper-event.c libdevmapper-event.h 
	lib            : .exported_symbols libdevmapper.h libdm-string.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Lots of dmevent changes.
	Export dm_basename().
	Cope with a trailing space when comparing tables prior to possible reload.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.138&r2=1.139
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/Makefile.in.diff?cvsroot=dm&r1=1.16&r2=1.17
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.25&r2=1.26
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.23&r2=1.24
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.59&r2=1.60
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.39&r2=1.40

--- device-mapper/WHATS_NEW	2006/12/20 14:35:02	1.138
+++ device-mapper/WHATS_NEW	2007/01/08 15:18:52	1.139
@@ -1,6 +1,8 @@
 Version 1.02.14 - 
 =============================
-  Some dmevent cleanups.
+  Lots of dmevent changes.
+  Export dm_basename().
+  Cope with a trailing space when comparing tables prior to possible reload.
   Fix dmeventd to cope if monitored device disappears.
 
 Version 1.02.13 - 28 Nov 2006
--- device-mapper/dmeventd/Makefile.in	2006/04/19 17:32:05	1.16
+++ device-mapper/dmeventd/Makefile.in	2007/01/08 15:18:52	1.17
@@ -15,8 +15,7 @@
 top_srcdir = @top_srcdir@
 VPATH = @srcdir@
 
-SOURCES = libdevmapper-event.c \
-	  dmeventd.c
+SOURCES = libdevmapper-event.c
 
 LIB_STATIC = libdevmapper-event.a
 
@@ -26,12 +25,20 @@
   LIB_SHARED = libdevmapper-event.so
 endif
 
+TARGETS = dmeventd
+CLEAN_TARGETS = dmeventd.o
+
 include ../make.tmpl
 
+LDFLAGS += -ldl -ldevmapper -lpthread
 CLDFLAGS += -ldl -ldevmapper -lpthread
 
+dmeventd: $(LIB_SHARED) dmeventd.o
+	$(CC) -o $@ dmeventd.o $(LDFLAGS) \
+	-L. -ldevmapper-event $(LIBS) -rdynamic
+
 .PHONY: install_dynamic install_static install_include \
-	install_pkgconfig
+	install_pkgconfig install_dmeventd
 
 INSTALL_TYPE = install_dynamic
 
@@ -43,7 +50,7 @@
   INSTALL_TYPE += install_pkgconfig
 endif
 
-install: $(INSTALL_TYPE) install_include
+install: $(INSTALL_TYPE) install_include install_dmeventd
 
 install_include:
 	$(INSTALL) -D $(OWNER) $(GROUP) -m 444 libdevmapper-event.h \
@@ -55,6 +62,9 @@
 	$(LN_S) -f libdevmapper-event.$(LIB_SUFFIX).$(LIB_VERSION) \
 		$(libdir)/libdevmapper-event.$(LIB_SUFFIX)
 
+install_dmeventd: dmeventd
+	$(INSTALL) -D $(OWNER) $(GROUP) -m 555 $(STRIP) $< $(sbindir)/$<
+
 install_pkgconfig:
 	$(INSTALL) -D $(OWNER) $(GROUP) -m 444 libdevmapper-event.pc \
 		$(usrlibdir)/pkgconfig/devmapper-event.pc
--- device-mapper/dmeventd/dmeventd.c	2006/12/20 14:35:02	1.25
+++ device-mapper/dmeventd/dmeventd.c	2007/01/08 15:18:52	1.26
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -42,15 +42,22 @@
 #include <sys/wait.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <arpa/inet.h> /* for htonl, ntohl */
 
 #ifdef linux
 #include <malloc.h>
 #endif
 
+/* We must use syslog for now, because multilog is not yet implemented */
+#include <syslog.h>
+
+static volatile sig_atomic_t _exit_now = 0; /* set to '1' when signal is given to exit */
+static volatile sig_atomic_t _thread_registries_empty = 1; /* registries are empty initially */
+
 /* List (un)link macros. */
 #define	LINK(x, head)		list_add(head, &(x)->list)
-#define	LINK_DSO(dso)		LINK(dso, &dso_registry)
-#define	LINK_THREAD(thread)	LINK(thread, &thread_registry)
+#define	LINK_DSO(dso)		LINK(dso, &_dso_registry)
+#define	LINK_THREAD(thread)	LINK(thread, &_thread_registry)
 
 #define	UNLINK(x)		list_del(&(x)->list)
 #define	UNLINK_DSO(x)		UNLINK(x)
@@ -59,7 +66,11 @@
 #define DAEMON_NAME "dmeventd"
 
 /* Global mutex for list accesses. */
-static pthread_mutex_t mutex;
+static pthread_mutex_t _global_mutex;
+
+#define DM_THREAD_RUNNING  0
+#define DM_THREAD_SHUTDOWN 1
+#define DM_THREAD_DONE     2
 
 /* Data kept about a DSO. */
 struct dso_data {
@@ -98,7 +109,7 @@
 	 */
 	int (*unregister_device)(const char *device);
 };
-static LIST_INIT(dso_registry);
+static LIST_INIT(_dso_registry);
 
 /* Structure to keep parsed register variables from client message. */
 struct message_data {
@@ -122,15 +133,16 @@
  * occurs and the event processing function of the DSO gets called.
  */
 struct thread_status {
-	struct list	list;
+	struct list list;
 
-	pthread_t		thread;
+	pthread_t thread;
 
 	struct dso_data *dso_data;/* DSO this thread accesses. */
 	
 	char *device_path;	/* Mapped device path. */
 	uint32_t event_nr;	/* event number */
 	int processing;		/* Set when event is being processed */
+	int status;		/* running/shutdown/done */
 	enum dm_event_type events;	/* bitfield for event filter. */
 	enum dm_event_type current_events;/* bitfield for occured events. */
 	enum dm_event_type processed_events;/* bitfield for processed events. */
@@ -138,13 +150,13 @@
 	uint32_t timeout;
 	struct list timeout_list;
 };
-static LIST_INIT(thread_registry);
-static LIST_INIT(thread_registry_unused);
+static LIST_INIT(_thread_registry);
+static LIST_INIT(_thread_registry_unused);
 
-static int timeout_running;
+static int _timeout_running;
 static LIST_INIT(timeout_registry);
-static pthread_mutex_t timeout_mutex = PTHREAD_MUTEX_INITIALIZER;
-static pthread_cond_t timeout_cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t _timeout_mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t _timeout_cond = PTHREAD_COND_INITIALIZER;
 
 /* Allocate/free the status structure for a monitoring thread. */
 static struct thread_status *alloc_thread_status(struct message_data *data,
@@ -197,14 +209,6 @@
 	dm_free(data);
 }
 
-/* FIXME: Factor out. */
-static char *dm_basename(char *str)
-{
-	char *p = strrchr(str, '/');
-
-	return p ? p + 1 : str;
-}
-
 /*
  * Fetch a string off src and duplicate it into *ptr.
  * Pay attention to 0 lenght strings.
@@ -246,12 +250,18 @@
 
 	if (message_data->device_path)
 		dm_free(message_data->device_path);
+
 }
 
 /* Parse a register message from the client. */
 static int parse_message(struct message_data *message_data)
 {
-	char *p = message_data->msg->msg;
+	int ret = 0;
+	char *p = message_data->msg->data;
+	struct dm_event_daemon_message *msg = message_data->msg;
+
+	if (!msg->data)
+		return 0;
 
 	/*
 	 * Retrieve application identifier, mapped device
@@ -278,21 +288,24 @@
 							    DM_EVENT_DEFAULT_TIMEOUT;
 		}
 
-		return 1;
+		ret = 1;
 	}
 
-	return 0;
+	dm_free(msg->data);
+	msg->data = NULL;
+	msg->size = 0;
+	return ret;
 };
 
 /* Global mutex to lock access to lists et al. */
 static int lock_mutex(void)
 {
-	return pthread_mutex_lock(&mutex);
+	return pthread_mutex_lock(&_global_mutex);
 }
 
 static int unlock_mutex(void)
 {
-	return pthread_mutex_unlock(&mutex);
+	return pthread_mutex_unlock(&_global_mutex);
 }
 
 /* Store pid in pidfile. */
@@ -343,7 +356,7 @@
 {
 	struct thread_status *thread;
 
-	list_iterate_items(thread, &thread_registry)
+	list_iterate_items(thread, &_thread_registry)
 		if (!strcmp(data->device_path, thread->device_path))
 			return thread;
 
@@ -358,29 +371,10 @@
 	dm_lib_exit();
 }
 
-/* Derive error case from target parameter string. */
-/* FIXME Remove? */
-static int error_detected(struct thread_status *thread, char *params) __attribute__ ((unused));
-static int error_detected(struct thread_status *thread, char *params)
-{
-	size_t len;
-/*
-  Leave it to the DSO to decide how to interpret the status info
-	if ((len = strlen(params)) &&
-	    params[len - 1] == 'F') {
-*/
-	if (params && (len = strlen(params))) {
-		thread->current_events |= DM_EVENT_DEVICE_ERROR;
-		return 1;
-	}
-
-	return 0;
-}
-
 static void exit_timeout(void *unused)
 {
-	timeout_running = 0;
-	pthread_mutex_unlock(&timeout_mutex);
+	_timeout_running = 0;
+	pthread_mutex_unlock(&_timeout_mutex);
 }
 
 /* Wake up monitor threads every so often. */
@@ -391,7 +385,7 @@
 
 	timeout.tv_nsec = 0;
 	pthread_cleanup_push(exit_timeout, NULL);
-	pthread_mutex_lock(&timeout_mutex);
+	pthread_mutex_lock(&_timeout_mutex);
 
 	while (!list_empty(&timeout_registry)) {
 		struct thread_status *thread;
@@ -410,7 +404,7 @@
 				timeout.tv_sec = thread->next_time;
 		}
 
-		pthread_cond_timedwait(&timeout_cond, &timeout_mutex, &timeout);
+		pthread_cond_timedwait(&_timeout_cond, &_timeout_mutex, &timeout);
 	}
 
 	pthread_cleanup_pop(1);
@@ -422,37 +416,37 @@
 {
 	int ret = 0;
 
-	pthread_mutex_lock(&timeout_mutex);
+	pthread_mutex_lock(&_timeout_mutex);
 
 	thread->next_time = time(NULL) + thread->timeout;
 
 	if (list_empty(&thread->timeout_list)) {
 		list_add(&timeout_registry, &thread->timeout_list);
-		if (timeout_running)
-			pthread_cond_signal(&timeout_cond);
+		if (_timeout_running)
+			pthread_cond_signal(&_timeout_cond);
 	}
 
-	if (!timeout_running) {
+	if (!_timeout_running) {
 		pthread_t timeout_id;
 
 		if (!(ret = -pthread_create(&timeout_id, NULL,
 					    timeout_thread, NULL)))
-			timeout_running = 1;
+			_timeout_running = 1;
 	}
 
-	pthread_mutex_unlock(&timeout_mutex);
+	pthread_mutex_unlock(&_timeout_mutex);
 
 	return ret;
 }
 
 static void unregister_for_timeout(struct thread_status *thread)
 {
-	pthread_mutex_lock(&timeout_mutex);
+	pthread_mutex_lock(&_timeout_mutex);
 	if (!list_empty(&thread->timeout_list)) {
 		list_del(&thread->timeout_list);
 		list_init(&thread->timeout_list);
 	}
-	pthread_mutex_unlock(&timeout_mutex);
+	pthread_mutex_unlock(&_timeout_mutex);
 }
 
 static void no_intr_log(int level, const char *file, int line,
@@ -490,11 +484,15 @@
 	return old;
 }
 
+#define DM_WAIT_RETRY 0
+#define DM_WAIT_INTR 1
+#define DM_WAIT_FATAL 2
+
 /* Wait on a device until an event occurs. */
 static int event_wait(struct thread_status *thread)
 {
 	sigset_t set;
-	int ret = 0;
+	int ret = DM_WAIT_RETRY;
 /*
 	void *next = NULL;
 	char *params, *target_type;
@@ -504,7 +502,7 @@
 	struct dm_info info;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_WAITEVENT)))
-		return 0;
+		return DM_WAIT_RETRY;
 
 	if (!(ret = dm_task_set_name(dmt, dm_basename(thread->device_path))) ||
 	    !(ret = dm_task_set_event_nr(dmt, thread->event_nr)))
@@ -518,19 +516,8 @@
 	dm_log_init(no_intr_log);
 	errno = 0;
 	if ((ret = dm_task_run(dmt))) {
-/*
-		do {
-			params = NULL;
-			next = dm_get_next_target(dmt, next, &start, &length,
-						  &target_type, &params);
-
-			log_error("%s: %s\n", __func__, params);
-			if ((ret = error_detected(thread, params)))
-				break;
-		} while(next);
-*/
 		thread->current_events |= DM_EVENT_DEVICE_ERROR;
-		ret = 1;
+		ret = DM_WAIT_INTR;
 
 		/*
 		 * FIXME:  I am setting processed_events to zero here
@@ -544,7 +531,7 @@
 			thread->event_nr = info.event_nr;
 	} else if (thread->events & DM_EVENT_TIMEOUT && errno == EINTR) {
 		thread->current_events |= DM_EVENT_TIMEOUT;
-		ret = 1;
+		ret = DM_WAIT_INTR;
 		thread->processed_events = 0;
 	} else {
 		/* FIXME replace with log_* macro */
@@ -553,7 +540,7 @@
 		if (errno == ENXIO) {
 			/* FIXME replace with log_* macro */
 			syslog(LOG_ERR, "%s disappeared, detaching", thread->device_path);
-			ret = 2;	/* FIXME What does 2 mean?  Use macro. */
+			ret = DM_WAIT_FATAL;
 		}
 	}
 
@@ -591,14 +578,12 @@
 	struct thread_status *thread = arg;
 
 	if (!do_unregister_device(thread))
-		log_error("%s: %s unregister failed\n", __func__,
+		syslog(LOG_ERR, "%s: %s unregister failed\n", __func__,
 			thread->device_path);
 }
 
 /* Device monitoring thread. */
 static void *monitor_thread(void *arg)
-    __attribute((noreturn));
-static void *monitor_thread(void *arg)
 {
 	struct thread_status *thread = arg;
 	int wait_error = 0;
@@ -608,23 +593,19 @@
 
 	/* Wait for do_process_request() to finish its task. */
 	lock_mutex();
+	thread->status = DM_THREAD_RUNNING;
 	unlock_mutex();
 
 	/* Loop forever awaiting/analyzing device events. */
 	while (1) {
 		thread->current_events = 0;
 
-		/*
-		 * FIXME If unrecoverable error (ENODEV) happens
-		 * we loop indefinitely.  event_wait should return
-		 * more than 0/1.
-		 */
 		wait_error = event_wait(thread);
-		if (!wait_error)
+		if (wait_error == DM_WAIT_RETRY)
 			continue;
 
 		/* FIXME Give a DSO a chance to clean up. */
-		if (wait_error == 2)
+		if (wait_error == DM_WAIT_FATAL)
 			break;
 
 		/*
@@ -639,6 +620,13 @@
 		 * the same type of event happens later... after the first
 		 * was handled properly?
 		 */
+		lock_mutex();
+		if (thread->status == DM_THREAD_SHUTDOWN) {
+			unlock_mutex();
+			break;
+		}
+		unlock_mutex();
+
 		if (thread->events &
 		    thread->current_events &
 		    ~thread->processed_events) {
@@ -653,7 +641,12 @@
 		}
 	}
 
+	lock_mutex();
+	thread->status = DM_THREAD_DONE;
+	unlock_mutex();
+
 	pthread_cleanup_pop(0);
+	return NULL;
 }
 
 /* Create a device monitoring thread. */
@@ -695,7 +688,7 @@
 
 	lock_mutex();
 
-	list_iterate_items(dso_data, &dso_registry)
+	list_iterate_items(dso_data, &_dso_registry)
 		if (!strcmp(data->dso_name, dso_data->dso_name)) {
 			lib_get(dso_data);
 			ret = dso_data;
@@ -714,8 +707,6 @@
 	if ((*symbol = dlsym(dl, name)))
 		return 1;
 
-	log_error("looking up %s symbol in %s\n", name, data->dso_name);
-
 	return 0;
 }
 
@@ -735,11 +726,13 @@
 	void *dl;
 	struct dso_data *ret = NULL;
 
-	log_very_verbose("Opening shared library %s", data->dso_name);
-
 	if (!(dl = dlopen(data->dso_name, RTLD_NOW))){
-		log_error("dmeventd %s dlopen failed: %s", data->dso_name,
-			  dlerror());
+		const char *dlerr = dlerror();
+		syslog(LOG_ERR, "dmeventd %s dlopen failed: %s", data->dso_name, dlerr);
+		char buf[1024]; /* FIXME */
+		snprintf(buf, 1024, "%s dlopen failed: %s", data->dso_name, dlerr);
+		data->msg->size = strlen(buf) + 1;
+		data->msg->data = dm_strdup(buf);
 		return NULL;
 	}
 
@@ -895,7 +888,7 @@
 	 */
 	if (!thread->events) {
 		UNLINK_THREAD(thread);
-		LINK(thread, &thread_registry_unused);
+		LINK(thread, &_thread_registry_unused);
 	}
 	unlock_mutex();
 
@@ -911,11 +904,21 @@
 static int registered_device(struct message_data *message_data,
 			     struct thread_status *thread)
 {
+	char test[1];
 	struct dm_event_daemon_message *msg = message_data->msg;
 
-	snprintf(msg->msg, sizeof(msg->msg), "%s %s %u", 
-		 thread->dso_data->dso_name, thread->device_path,
-		 thread->events);
+	const char *fmt = "%s %s %u";
+	const char *dso = thread->dso_data->dso_name;
+	const char *dev = thread->device_path;
+	unsigned events = ((thread->status == DM_THREAD_RUNNING) && (thread->events)) ?
+			  thread->events : thread->events | DM_EVENT_REGISTRATION_PENDING;
+
+	if (msg->data)
+		dm_free(msg->data);
+
+	msg->size = snprintf(test, 1, fmt, dso, dev, events);
+	msg->data = dm_malloc(msg->size);
+	snprintf(msg->data, msg->size, fmt, dso, dev, events);
 
 	unlock_mutex();
 
@@ -949,7 +952,7 @@
 	lock_mutex();
 
 	/* Iterate list of threads checking if we want a particular one. */
-	list_iterate_items(thread, &thread_registry)
+	list_iterate_items(thread, &_thread_registry)
 		if ((hit = want_registered_device(message_data->dso_name,
 						  message_data->device_path,
 						  thread)))
@@ -963,7 +966,7 @@
 		goto out;
 
 	do {
-		if (list_end(&thread_registry, &thread->list))
+		if (list_end(&_thread_registry, &thread->list))
 			goto out;
 		
 		thread = list_item(thread->list.n,
@@ -1006,10 +1009,18 @@
 	struct thread_status *thread;
 	struct dm_event_daemon_message *msg = message_data->msg;
 
+	if (msg->data)
+		dm_free(msg->data);
+
 	lock_mutex();
-	if ((thread = lookup_thread_status(message_data)))
-		snprintf(msg->msg, sizeof(msg->msg),
-			 "%"PRIu32, thread->timeout);
+	if ((thread = lookup_thread_status(message_data))) {
+		msg->data = dm_malloc(8*sizeof(uint32_t)); /* FIXME */
+		msg->size = snprintf(msg->data, 8*sizeof(uint32_t),
+				     "%"PRIu32, thread->timeout);
+	} else {
+		msg->data = NULL;
+		msg->size = 0;
+	}
 	unlock_mutex();
 
 	return thread ? 0 : -ENODEV;
@@ -1017,32 +1028,50 @@
 	
 
 /* Initialize a fifos structure with path names. */
-static int init_fifos(struct dm_event_fifos *fifos)
+static void init_fifos(struct dm_event_fifos *fifos)
 {
-	if (memset(fifos, 0, sizeof(*fifos))) {
-		fifos->client_path = DM_EVENT_FIFO_CLIENT;
-		fifos->server_path = DM_EVENT_FIFO_SERVER;
+	memset(fifos, 0, sizeof(*fifos));
 
-		return 0;
-	}
-
-	return -ENOMEM;
+	fifos->client_path = DM_EVENT_FIFO_CLIENT;
+	fifos->server_path = DM_EVENT_FIFO_SERVER;
 }
 
 /* Open fifos used for client communication. */
 static int open_fifos(struct dm_event_fifos *fifos)
 {
-	/* Blocks until client is ready to write. */
-	if ((fifos->server = open(fifos->server_path, O_WRONLY)) < 0) {
+	/* Create fifos */
+	if (((mkfifo(fifos->client_path, 0600) == -1) && errno != EEXIST) ||
+	    ((mkfifo(fifos->server_path, 0600) == -1) && errno != EEXIST)) {
+		syslog(LOG_ERR, "%s: Failed to create a fifo.\n", __func__);
 		stack;
-		return -EXIT_FIFO_FAILURE;
+		return -errno;
+	}
+
+	/* FIXME Warn/abort if perms are wrong - not something to fix silently. */
+	/* If they were already there, make sure permissions are ok. */
+	if (chmod(fifos->client_path, 0600)) {
+		syslog(LOG_ERR, "Unable to set correct file permissions on %s",
+			  fifos->client_path);
+		return -errno;
+	}
+
+	if (chmod(fifos->server_path, 0600)) {
+		syslog(LOG_ERR, "Unable to set correct file permissions on %s",
+			  fifos->server_path);
+		return -errno;
+	}
+
+	/* Need to open read+write or we will block or fail */
+	if ((fifos->server = open(fifos->server_path, O_RDWR)) < 0) {
+		stack;
+		return -errno;
 	}
 
 	/* Need to open read+write for select() to work. */
-        if ((fifos->client = open(fifos->client_path, O_RDWR)) < 0) {
+	if ((fifos->client = open(fifos->client_path, O_RDWR)) < 0) {
 		stack;
 		close(fifos->server);
-		return -EXIT_FIFO_FAILURE;
+		return -errno;
 	}
 
 	return 0;
@@ -1058,9 +1087,14 @@
 	unsigned bytes = 0;
 	int ret = 0;
 	fd_set fds;
+	int header = 1;
+	size_t size = 2 * sizeof(uint32_t);	/* status + size */
+	char *buf = alloca(size);
+
+	msg->data = NULL;
 
 	errno = 0;
-	while (bytes < sizeof(*msg) && errno != EOF) {
+	while (bytes < size && errno != EOF) {
 		/* Watch client read FIFO for input. */
 		FD_ZERO(&fds);
 		FD_SET(fifos->client, &fds);
@@ -1077,11 +1111,25 @@
 		if (ret < 0)  /* error */
 			return 0;
 
-		ret = read(fifos->client, msg, sizeof(*msg) - bytes);
+		ret = read(fifos->client, buf + bytes, size - bytes);
 		bytes += ret > 0 ? ret : 0;
+		if (bytes == 2*sizeof(uint32_t) && header) {
+			msg->cmd = ntohl(*((uint32_t *)buf));
+			msg->size = ntohl(*((uint32_t *)buf + 1));
+			buf = msg->data = dm_malloc(msg->size);
+			size = msg->size;
+			bytes = 0;
+			header = 0;
+		}
 	}
 
-	return bytes == sizeof(*msg);
+	if (bytes != size) {
+		if (msg->data)
+			dm_free(msg->data);
+		msg->data = NULL;
+	}
+
+	return bytes == size;
 }
 
 /*
@@ -1093,19 +1141,26 @@
 	int ret = 0;
 	fd_set fds;
 
+	size_t size = 2*sizeof(uint32_t) + msg->size;
+	char *buf = alloca(size);
+
+	*((uint32_t *)buf) = htonl(msg->cmd);
+	*((uint32_t *)buf + 1) = htonl(msg->size);
+	memcpy(buf + 2*sizeof(uint32_t), msg->data, msg->size);
+
 	errno = 0;
-	while (bytes < sizeof(*msg) && errno != EIO) {
+	while (bytes < size && errno != EIO) {
 		do {
 			/* Watch client write FIFO to be ready for output. */
 			FD_ZERO(&fds);
 			FD_SET(fifos->server, &fds);
 		} while (select(fifos->server +1, NULL, &fds, NULL, NULL) != 1);
 
-		ret = write(fifos->server, msg, sizeof(*msg) - bytes);
+		ret = write(fifos->server, buf + bytes, size - bytes);
 		bytes += ret > 0 ? ret : 0;
 	}
 
-	return bytes == sizeof(*msg);
+	return bytes == size;
 }
 
 /*
@@ -1121,17 +1176,17 @@
 		unsigned int cmd;
 		int (*f)(struct message_data*);
 	} requests[] = {
-		{ DM_EVENT_CMD_REGISTER_FOR_EVENT,         register_for_event },
+		{ DM_EVENT_CMD_REGISTER_FOR_EVENT,	   register_for_event },
 		{ DM_EVENT_CMD_UNREGISTER_FOR_EVENT,       unregister_for_event },
 		{ DM_EVENT_CMD_GET_REGISTERED_DEVICE,      get_registered_device },
 		{ DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE, get_next_registered_device },
-		{ DM_EVENT_CMD_SET_TIMEOUT,                set_timeout },
-		{ DM_EVENT_CMD_GET_TIMEOUT,                get_timeout },
-		{ DM_EVENT_CMD_ACTIVE,                     active },
+		{ DM_EVENT_CMD_SET_TIMEOUT,		   set_timeout },
+		{ DM_EVENT_CMD_GET_TIMEOUT,		   get_timeout },
+		{ DM_EVENT_CMD_ACTIVE,			   active },
 	}, *req;
 
 	for (req = requests; req < requests + sizeof(requests); req++)
-		if (req->cmd == msg->opcode.cmd)
+		if (req->cmd == msg->cmd)
 			return req->f(message_data);
 
 	return -EINVAL;
@@ -1146,7 +1201,7 @@
 	/* Parse the message. */
 	memset(&message_data, 0, sizeof(message_data));
 	message_data.msg = msg;
-	if (msg->opcode.cmd != DM_EVENT_CMD_ACTIVE &&
+	if (msg->cmd != DM_EVENT_CMD_ACTIVE &&
 	    !parse_message(&message_data)) {
 		stack;
 		ret = -EINVAL;
@@ -1176,10 +1231,17 @@
 	if (!client_read(fifos, &msg))
 		return;
 
-	msg.opcode.status = do_process_request(&msg);
+	msg.cmd = do_process_request(&msg);
+	if (!msg.data) {
+		msg.data = dm_strdup(strerror(-msg.cmd));
+		msg.size = strlen(msg.data) + 1;
+	}
 
 	if (!client_write(fifos, &msg))
 		stack;
+
+	if (msg.data)
+		dm_free(msg.data);
 }
 
 static void cleanup_unused_threads(void)
@@ -1189,27 +1251,40 @@
 	struct thread_status *thread;
 
 	lock_mutex();
-	while ((l = list_first(&thread_registry_unused))) {
+	while ((l = list_first(&_thread_registry_unused))) {
 		thread = list_item(l, struct thread_status);
 		if (thread->processing) {
 			goto out;  /* cleanup on the next round */
 		}
-		list_del(l);
 
-		if (!thread->events) {
-			/* turn codes negative -- should we be returning this? */
-			if ((ret = -terminate_thread(thread)))
-				stack;
-			else {
-				pthread_join(thread->thread, NULL);
-				lib_put(thread->dso_data);
-				free_thread_status(thread);
+		if (thread->status == DM_THREAD_RUNNING) {
+			thread->status = DM_THREAD_SHUTDOWN;
+			goto out;
+		} else if (thread->status == DM_THREAD_SHUTDOWN) {
+			if (!thread->events) {
+				/* turn codes negative -- should we be returning this? */
+				ret = terminate_thread(thread);
+
+				if (ret == ESRCH) {
+					thread->status = DM_THREAD_DONE;
+				} else if (ret) {
+					syslog(LOG_ERR, "Unable to terminate thread: %s\n",
+					       strerror(-ret));
+					stack;
+				}
+				goto out;
+			} else {
+				list_del(l);
+				syslog(LOG_ERR, "thread can't be on unused list unless !thread->events");
+				thread->status = DM_THREAD_RUNNING;
+				LINK_THREAD(thread);
 			}
-		} else {
-			log_error("thread can't be on unused list unless !thread->events");
-			LINK_THREAD(thread);
+		} else if (thread->status == DM_THREAD_DONE) {
+			list_del(l);
+			pthread_join(thread->thread, NULL);
+			lib_put(thread->dso_data);
+			free_thread_status(thread);
 		}
-
 	}
 out:
 	unlock_mutex();
@@ -1230,23 +1305,38 @@
 	act.sa_handler = sig_alarm;
 	sigaction(SIGALRM, &act, NULL);
 	sigfillset(&my_sigset);
+
+	/* These are used for exiting */
+	sigdelset(&my_sigset, SIGTERM);
+	sigdelset(&my_sigset, SIGINT);
+	sigdelset(&my_sigset, SIGHUP);
+	sigdelset(&my_sigset, SIGQUIT);
+
 	pthread_sigmask(SIG_BLOCK, &my_sigset, NULL);
 }
 
-static int daemonize(void)
+/*
+ * exit_handler
+ * @sig
+ *
+ * Set the global variable which the process should
+ * be watching to determine when to exit.
+ */
+static void exit_handler(int sig)
 {
-	setsid();
-	if (chdir("/"))
-		return -EXIT_CHDIR_FAILURE;
-
-/* FIXME: activate again after we're done with tracing.
-	if ((close(STDIN_FILENO) < 0) ||
-	    (close(STDOUT_FILENO) < 0) ||
-	    (close(STDERR_FILENO) < 0))
-		return -EXIT_DESC_CLOSE_FAILURE;
-*/
+	/*
+	 * We exit when '_exit_now' is set.
+	 * That is, when a signal has been received.
+	 *
+	 * We can not simply set '_exit_now' unless all
+	 * threads are done processing.
+	 */
+	if (!_thread_registries_empty) {
+		syslog(LOG_ERR, "There are still devices being monitored.");
+		syslog(LOG_ERR, "Refusing to exit.");
+	} else
+		_exit_now = 1;
 
-	return 0;
 }
 
 static int lock_pidfile(void)
@@ -1255,31 +1345,104 @@
 	char pidfile[] = "/var/run/dmeventd.pid"; /* FIXME Must be configurable at compile-time! */
 
 	if ((lf = open(pidfile, O_CREAT | O_RDWR, 0644)) < 0)
-		return -EXIT_OPEN_PID_FAILURE;
+		exit(EXIT_OPEN_PID_FAILURE);
 
 	if (flock(lf, LOCK_EX | LOCK_NB) < 0)
-		return -EXIT_LOCKFILE_INUSE;
+		exit(EXIT_LOCKFILE_INUSE);
 
 	if (!storepid(lf))
-		return -EXIT_FAILURE;
+		exit(EXIT_FAILURE);
 
 	return 0;
 }
 
-void dmeventd(void)
+static void daemonize(void)
 {
-	int ret;
-	struct dm_event_fifos fifos;
-	// struct sys_log logdata = {DAEMON_NAME, LOG_DAEMON};
+	int status;
+	int pid;
+	int fd;
+	struct rlimit rlim;
+	struct timeval tval;
+	sigset_t my_sigset;
+
+	sigemptyset(&my_sigset);
+	if (sigprocmask(SIG_SETMASK, &my_sigset, NULL) < 0) {
+		fprintf(stderr, "Unable to restore signals.");
+		exit(EXIT_FAILURE);
+	}
+	signal(SIGTERM, &exit_handler);
+
+	pid = fork();
 
-	if ((ret = daemonize()))
-		exit(-ret);
+	if (pid < 0)
+		exit(EXIT_FAILURE);
 
-	/* FIXME: set daemon name. */
-	// set_name();
+	if (pid) {
+		/* Wait for response from child */
+		while (!waitpid(pid, &status, WNOHANG) && !_exit_now) {
+			tval.tv_sec = 0;
+			tval.tv_usec = 250000; /* .25 sec */
+			select(0, NULL, NULL, NULL, &tval);
+		}
 
-	if ((ret = lock_pidfile()))
-		exit(-ret);
+		if (_exit_now) /* Child has signaled it is ok - we can exit now */
+			exit(EXIT_SUCCESS);
+
+		/* Problem with child.  Determine what it is by exit code */
+		switch (WEXITSTATUS(status)) {
+		case EXIT_LOCKFILE_INUSE:
+			break;
+		case EXIT_DESC_CLOSE_FAILURE:
+			break;
+		case EXIT_DESC_OPEN_FAILURE:
+			break;
+		case EXIT_OPEN_PID_FAILURE:
+			break;
+		case EXIT_FIFO_FAILURE:
+			break;
+		case EXIT_CHDIR_FAILURE:
+			break;
+		default:
+			break;
+		}
+
+		exit(EXIT_FAILURE);  /* Redundant */
+	}
+
+	setsid();
+	if (chdir("/"))
+		exit(EXIT_CHDIR_FAILURE);
+
+	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
+		fd = 256;  /* just have to guess */
+	else
+		fd = rlim.rlim_cur;
+
+	for (--fd; fd >= 0; fd--)
+		close(fd);
+
+	if ((open("/dev/null", O_RDONLY) < 0) ||
+	    (open("/dev/null", O_WRONLY) < 0) ||
+	    (open("/dev/null", O_WRONLY) < 0))
+		exit(EXIT_DESC_OPEN_FAILURE);
+
+	openlog("dmeventd", LOG_PID, LOG_DAEMON);
+
+	lock_pidfile();  /* exits if failure */
+
+	/* Set the rest of the signals to cause '_exit_now' to be set */
+	signal(SIGINT, &exit_handler);
+	signal(SIGHUP, &exit_handler);
+	signal(SIGQUIT, &exit_handler);
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	struct dm_event_fifos fifos;
+	//struct sys_log logdata = {DAEMON_NAME, LOG_DAEMON};
+
+	daemonize();
 
 	init_thread_signals();
 
@@ -1288,8 +1451,7 @@
 	//multilog_init_verbose(std_syslog, _LOG_DEBUG);
 	//multilog_async(1);
 
-	if ((ret = init_fifos(&fifos)))
-		exit(-ret);
+	init_fifos(&fifos);
 
 	pthread_mutex_init(&mutex, NULL);
 
@@ -1299,40 +1461,29 @@
 #endif
 
 	if ((ret = open_fifos(&fifos)))
-		exit(-ret);
+		exit(EXIT_FIFO_FAILURE);
 
 	/* Signal parent, letting them know we are ready to go. */
-	kill(getppid(), SIGUSR1);
+	kill(getppid(), SIGTERM);
+	syslog(LOG_INFO, "dmeventd ready for processing.");
 
-	/*
-	 * We exit when there are no more devices to watch.
-	 * That is, when the last unregister happens.
-	 *
-	 * We must be careful though.  One of our threads which is
-	 * watching a device may receive an event and:
-	 * 1) Alter the device and unregister it
-	 * or
-	 * 2) Alter the device, unregister, [alter again,] and reregister
-	 *
-	 * We must be capable of answering a request to unregister
-	 * that comes from the very thread that must be unregistered.
-	 * Additionally, if that thread unregisters itself and it was the
-	 * only thread being monitored, we must also handle the case where
-	 * that thread may perform a register before exiting.  (In other
-	 * words, we can not simply exit if all threads have been unregistered
-	 * unless all threads are done processing.
-	 */
-	do {
+	while (!_exit_now) {
 		process_request(&fifos);
 		cleanup_unused_threads();
-	} while(!list_empty(&thread_registry) || !list_empty(&thread_registry_unused));
+		if (!list_empty(&_thread_registry) || !list_empty(&_thread_registry_unused))
+			_thread_registries_empty = 0;
+		else
+			_thread_registries_empty = 1;
+	}
 
 	exit_dm_lib();
 
 #ifdef MCL_CURRENT
 	munlockall();
 #endif
-	pthread_mutex_destroy(&mutex);
+	pthread_mutex_destroy(&_mutex);
 
+	syslog(LOG_INFO, "dmeventd shutting down.");
+	closelog();
 	exit(EXIT_SUCCESS);
 }
--- device-mapper/dmeventd/dmeventd.h	2006/01/31 14:50:37	1.2
+++ device-mapper/dmeventd/dmeventd.h	2007/01/08 15:18:52	1.3
@@ -1,13 +1,51 @@
 #ifndef __DMEVENTD_DOT_H__
 #define __DMEVENTD_DOT_H__
 
+/* FIXME This stuff must be configurable. */
+
+#define	DM_EVENT_DAEMON		"/sbin/dmeventd"
+#define DM_EVENT_LOCKFILE	"/var/lock/dmeventd"
+#define	DM_EVENT_FIFO_CLIENT	"/var/run/dmeventd-client"
+#define	DM_EVENT_FIFO_SERVER	"/var/run/dmeventd-server"
+#define DM_EVENT_PIDFILE	"/var/run/dmeventd.pid"
+
+#define DM_EVENT_DEFAULT_TIMEOUT 10
+
+/* Commands for the daemon passed in the message below. */
+enum dm_event_command {
+	DM_EVENT_CMD_ACTIVE = 1,
+	DM_EVENT_CMD_REGISTER_FOR_EVENT,
+	DM_EVENT_CMD_UNREGISTER_FOR_EVENT,
+	DM_EVENT_CMD_GET_REGISTERED_DEVICE,
+	DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE,
+	DM_EVENT_CMD_SET_TIMEOUT,
+	DM_EVENT_CMD_GET_TIMEOUT,
+};
+
+/* Message passed between client and daemon. */
+struct dm_event_daemon_message {
+	uint32_t cmd;
+	uint32_t size;
+	char *data;
+};
+
+/* FIXME Is this meant to be exported?  I can't see where the
+   interface uses it. */
+/* Fifos for client/daemon communication. */
+struct dm_event_fifos {
+	int client;
+	int server;
+	const char *client_path;
+	const char *server_path;
+};
+
+/*      EXIT_SUCCESS             0 -- stdlib.h */
+/*      EXIT_FAILURE             1 -- stdlib.h */
 #define EXIT_LOCKFILE_INUSE      2
 #define EXIT_DESC_CLOSE_FAILURE  3
-#define EXIT_OPEN_PID_FAILURE    4
-#define EXIT_FIFO_FAILURE        5
-#define EXIT_CHDIR_FAILURE       6
-
-void dmeventd(void)
-    __attribute((noreturn));
+#define EXIT_DESC_OPEN_FAILURE   4
+#define EXIT_OPEN_PID_FAILURE    5
+#define EXIT_FIFO_FAILURE        6
+#define EXIT_CHDIR_FAILURE       7
 
 #endif /* __DMEVENTD_DOT_H__ */
--- device-mapper/dmeventd/libdevmapper-event.c	2006/01/31 14:50:37	1.9
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/08 15:18:52	1.10
@@ -1,4 +1,4 @@
- /*
+/*
  * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
@@ -27,8 +27,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
-#include <signal.h>
 #include <sys/wait.h>
+#include <arpa/inet.h> /* for htonl, ntohl */
 
 /* Set by any of the external fxns the first time one of them is called */
 /* FIXME Unused */
@@ -57,7 +57,7 @@
 static int parse_message(struct dm_event_daemon_message *msg, char **dso_name,
 			 char **device, enum dm_event_type *events)
 {
-	char *p = msg->msg;
+	char *p = msg->data;
 
 	if ((*dso_name = fetch_string(&p)) &&
 	    (*device   = fetch_string(&p))) {
@@ -81,36 +81,58 @@
 static int daemon_read(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
-	int ret = 0;
+	int ret, i;
 	fd_set fds;
+	struct timeval tval = {0, 0};
+	size_t size = 2 * sizeof(uint32_t); // status + size
+	char *buf = alloca(size);
+	int header = 1;
 
-	memset(msg, 0, sizeof(*msg));
-	while (bytes < sizeof(*msg)) {
-		do {
+	while (bytes < size) {
+		for (i = 0, ret = 0; (i < 20) && (ret < 1); i++) {
 			/* Watch daemon read FIFO for input. */
 			FD_ZERO(&fds);
 			FD_SET(fifos->server, &fds);
-			ret = select(fifos->server+1, &fds, NULL, NULL, NULL);
+			tval.tv_sec = 1;
+			ret = select(fifos->server+1, &fds, NULL, NULL, &tval);
 			if (ret < 0 && errno != EINTR) {
-				/* FIXME Log error */
+				log_error("Unable to read from event server");
 				return 0;
 			}
-		} while (ret < 1);
+		}
+		if (ret < 1) {
+			log_error("Unable to read from event server.");
+			return 0;
+		}
 
-		ret = read(fifos->server, msg, sizeof(*msg) - bytes);
+		ret = read(fifos->server, buf + bytes, size);
 		if (ret < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
 			else {
-				/* FIXME Log error */
+				log_error("Unable to read from event server.");
 				return 0;
 			}
 		}
 
 		bytes += ret;
+		if (bytes == 2*sizeof(uint32_t) && header) {
+			msg->cmd = ntohl(*((uint32_t *)buf));
+			msg->size = ntohl(*((uint32_t *)buf + 1));
+			buf = msg->data = dm_malloc(msg->size);
+			size = msg->size;
+			bytes = 0;
+			header = 0;
+		}
 	}
 
-	return bytes == sizeof(*msg);
+	if (bytes != size) {
+		if (msg->data)
+			dm_free(msg->data);
+		msg->data = NULL;
+	}
+
+	return bytes == size;
 }
 
 /* Write message to daemon. */
@@ -120,24 +142,31 @@
 	int ret = 0;
 	fd_set fds;
 
-	while (bytes < sizeof(*msg)) {
+	size_t size = 2*sizeof(uint32_t) + msg->size;
+	char *buf = alloca(size);
+
+	*((uint32_t *)buf) = htonl(msg->cmd);
+	*((uint32_t *)buf + 1) = htonl(msg->size);
+	memcpy(buf + 2*sizeof(uint32_t), msg->data, msg->size);
+
+	while (bytes < size) {
 		do {
 			/* Watch daemon write FIFO to be ready for output. */
 			FD_ZERO(&fds);
 			FD_SET(fifos->client, &fds);
 			ret = select(fifos->client +1, NULL, &fds, NULL, NULL);
 			if ((ret < 0) && (errno != EINTR)) {
-				/* FIXME Log error */
+				log_error("Unable to talk to event daemon");
 				return 0;
 			}
 		} while (ret < 1);
 
-		ret = write(fifos->client, msg, sizeof(*msg) - bytes);
+		ret = write(fifos->client, ((char *) buf) + bytes, size - bytes);
 		if (ret < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
 			else {
-				/* fixme: log error */
+				log_error("Unable to talk to event daemon");
 				return 0;
 			}
 		}
@@ -145,29 +174,28 @@
 		bytes += ret;
 	}
 
-	return bytes == sizeof(*msg);
+	return bytes == size;
 }
 
 static int daemon_talk(struct dm_event_fifos *fifos, struct dm_event_daemon_message *msg,
-		       int cmd, char *dso_name, char *device,
+		       int cmd, const char *dso_name, const char *device,
 		       enum dm_event_type events, uint32_t timeout)
 {
+	char test[1];
+	const char *dso = dso_name ? dso_name : "";
+	const char *dev = device ? device : "";
+	const char *fmt = "%s %s %u %"PRIu32;
 	memset(msg, 0, sizeof(*msg));
 
 	/*
 	 * Set command and pack the arguments
 	 * into ASCII message string.
 	 */
-	msg->opcode.cmd = cmd;
-
-	if (sizeof(msg->msg) <= (unsigned) snprintf(msg->msg, sizeof(msg->msg),
-						    "%s %s %u %"PRIu32,
-						    dso_name ? dso_name : "",
-						    device ? device : "",
-						    events, timeout)) {
-		stack;
-		return -ENAMETOOLONG;
-	}
+	msg->cmd = cmd;
+	/* FIXME depends on glibc 2.1+ */
+	msg->size = snprintf(test, 1, fmt, dso, dev, events, timeout);
+	msg->data = alloca(msg->size);
+	snprintf(msg->data, msg->size, fmt, dso, dev, events, timeout);
 
 	/*
 	 * Write command and message to and
@@ -183,98 +211,70 @@
 		return -EIO;
 	}
 
-	return msg->opcode.status;
-}
-
-static volatile sig_atomic_t daemon_running = 0;
-
-static void daemon_running_signal_handler(int sig)
-{
-	daemon_running = 1;
+	return (int32_t) msg->cmd;
 }
 
 /*
  * start_daemon
  *
  * This function forks off a process (dmeventd) that will handle
- * the events.  A signal must be returned from the child to
- * indicate when it is ready to handle requests.  The parent
- * (this function) returns 1 if there is a daemon running. 
+ * the events.  I am currently test opening one of the fifos to
+ * ensure that the daemon is running and listening...  I thought
+ * this would be less expensive than fork/exec'ing every time.
+ * Perhaps there is an even quicker/better way (no, checking the
+ * lock file is _not_ a better way).
  *
  * Returns: 1 on success, 0 otherwise
  */
-static int start_daemon(void)
+static int start_daemon(struct dm_event_fifos *fifos)
 {
-	int pid, ret=0;
-	void *old_hand;
-	sigset_t set, oset;
+	int pid, ret = 0;
+	int status;
+	struct stat statbuf;
+
+	if (stat(fifos->client_path, &statbuf))
+		goto start_server;
 
-	/* Must be able to acquire signal */
-	old_hand = signal(SIGUSR1, &daemon_running_signal_handler);
-	if (old_hand == SIG_ERR) {
-		log_error("Unable to setup signal handler.");
+	if (!S_ISFIFO(statbuf.st_mode)) {
+		log_error("%s is not a fifo.", fifos->client_path);
 		return 0;
 	}
 
-	if (sigemptyset(&set) || sigaddset(&set, SIGUSR1)) {
-		log_error("Unable to fill signal set.");
-	} else if (sigprocmask(SIG_UNBLOCK, &set, &oset)) {
-		log_error("Can't unblock the potentially blocked signal SIGUSR1");
+	/* Anyone listening?  If not, errno will be ENXIO */
+	fifos->client = open(fifos->client_path, O_WRONLY | O_NONBLOCK);
+	if (fifos->client >= 0) {
+		/* server is running and listening */
+
+		close(fifos->client);
+		return 1;
+	} else if (errno != ENXIO) {
+		/* problem */
+
+		log_error("%s: Can't open client fifo %s: %s",
+			  __func__, fifos->client_path, strerror(errno));
+		stack;
+		return 0;
 	}
-	
+
+start_server:
+	/* server is not running */
 	pid = fork();
 
 	if (pid < 0)
-		log_error("Unable to fork.\n");
-	else if (pid) { /* parent waits for child to get ready for requests */
-		int status;
-
-		/* FIXME Better way to do this? */
-		while (!waitpid(pid, &status, WNOHANG) && !daemon_running)
-			sleep(1);
+		log_error("Unable to fork.");
 
-		if (daemon_running) {
-			ret = 1;
-		} else {
-			switch (WEXITSTATUS(status)) {
-			case EXIT_LOCKFILE_INUSE:
-				/*
-				 * Note, this is ok... we still have daemon
-				 * that we can communicate with...
-				 */
-				log_print("Starting dmeventd failed: "
-					  "dmeventd already running.\n");
-				ret = 1;
-				break;
-			default:
-				log_error("Unable to start dmeventd.\n");
-				break;
-			}
-		}
-		/*
-		 * Sometimes, a single process may perform multiple calls
-		 * that result in a daemon starting and exiting.  If we
-		 * don't reset this, the second (or greater) time the daemon
-		 * is started will cause this logic not to work.
-		 */
-		daemon_running = 0;
-	} else {
-		signal(SIGUSR1, SIG_IGN); /* don't care about error */
-
-		/* dmeventd function is responsible for properly setting **
-		** itself up.  It must never return - only exit.  This is**
-		** why it is followed by an EXIT_FAILURE                 */
-		dmeventd();
+	else if (!pid) {
+		execvp("dmeventd", NULL); /* security risk if admin has bad PATH */
 		exit(EXIT_FAILURE);
+	} else {
+		if (waitpid(pid, &status, 0) < 0)
+			log_error("Unable to start dmeventd: %s", strerror(errno));
+		else if (WEXITSTATUS(status))
+			log_error("Unable to start dmeventd.");
+		else
+			ret = 1;
 	}
 
-	/* FIXME What if old_hand is SIG_ERR? */
-	if (signal(SIGUSR1, old_hand) == SIG_ERR)
-		log_error("Unable to reset signal handler.");
-
-	if (sigprocmask(SIG_SETMASK, &oset, NULL))
-		log_error("Unable to reset signal mask.");
-
 	return ret;
 }
 
@@ -289,63 +289,34 @@
 	fifos->client_path = DM_EVENT_FIFO_CLIENT;
 	fifos->server_path = DM_EVENT_FIFO_SERVER;
 
-	/* FIXME The server should be responsible for these, not the client. */
-	/* Create fifos */
-	if (((mkfifo(fifos->client_path, 0600) == -1) && errno != EEXIST) ||
-	    ((mkfifo(fifos->server_path, 0600) == -1) && errno != EEXIST)) {
-		log_error("%s: Failed to create a fifo.\n", __func__);
-		return 0;
-	}
-
-	/* FIXME Warn/abort if perms are wrong - not something to fix silently. */
-	/* If they were already there, make sure permissions are ok. */
-	if (chmod(fifos->client_path, 0600)) {
-		log_error("Unable to set correct file permissions on %s",
-			fifos->client_path);
-		return 0;
-	}
-
-	if (chmod(fifos->server_path, 0600)) {
-		log_error("Unable to set correct file permissions on %s",
-			fifos->server_path);
+	if (!start_daemon(fifos)) {
+		stack;
 		return 0;
 	}
 
-	/*
-	 * Open the fifo used to read from the daemon.
-	 * Allows daemon to create its write fifo...
-	 */
+	/* Open the fifo used to read from the daemon. */
 	if ((fifos->server = open(fifos->server_path, O_RDWR)) < 0) {
-		log_error("%s: open server fifo %s\n",
+		log_error("%s: open server fifo %s",
 			__func__, fifos->server_path);
 		stack;
 		return 0;
 	}
 
 	/* Lock out anyone else trying to do communication with the daemon. */
-	/* FIXME Why failure not retry?  How do multiple processes communicate? */
 	if (flock(fifos->server, LOCK_EX) < 0){
-		log_error("%s: flock %s\n", __func__, fifos->server_path);
+		log_error("%s: flock %s", __func__, fifos->server_path);
 		close(fifos->server);
 		return 0;
 	}
 
-	/* Anyone listening?  If not, errno will be ENXIO */
-	while ((fifos->client = open(fifos->client_path,
-				  O_WRONLY | O_NONBLOCK)) < 0) {
-		if (errno != ENXIO) {
-			log_error("%s: Can't open client fifo %s: %s\n",
-				  __func__, fifos->client_path, strerror(errno));
-			close(fifos->server);
-			stack;
-			return 0;
-		}
-		
-		/* FIXME Unnecessary if daemon was started before calling this */
-		if (!start_daemon()) {
-			stack;
-			return 0;
-		}
+/*	if ((fifos->client = open(fifos->client_path,
+  O_WRONLY | O_NONBLOCK)) < 0) {*/
+	if ((fifos->client = open(fifos->client_path, O_RDWR | O_NONBLOCK)) < 0) {
+		log_error("%s: Can't open client fifo %s: %s",
+			  __func__, fifos->client_path, strerror(errno));
+		close(fifos->server);
+		stack;
+		return 0;
 	}
 	
 	return 1;
@@ -354,14 +325,14 @@
 static void dtr_client(struct dm_event_fifos *fifos)
 {
 	if (flock(fifos->server, LOCK_UN))
-		log_error("flock unlock %s\n", fifos->server_path);
+		log_error("flock unlock %s", fifos->server_path);
 
 	close(fifos->client);
 	close(fifos->server);
 }
 
 /* Check, if a block device exists. */
-static int device_exists(char *device)
+static int device_exists(const char *device)
 {
 	struct stat st_buf;
 	char path2[PATH_MAX];
@@ -380,7 +351,7 @@
 
 /* Handle the event (de)registration call and return negative error codes. */
 static int do_event(int cmd, struct dm_event_daemon_message *msg,
-		    char *dso_name, char *device, enum dm_event_type events,
+		    const char *dso_name, const char *device, enum dm_event_type events,
 		    uint32_t timeout)
 {
 	int ret;
@@ -405,10 +376,10 @@
 /* FIXME remove dso_name - use handle instead */
 /* FIXME Use uuid not path! */
 /* External library interface. */
-int dm_event_register(char *dso_name, char *device_path,
+int dm_event_register(const char *dso_name, const char *device_path,
 		      enum dm_event_type events)
 {
-	int ret;
+	int ret, err;
 	struct dm_event_daemon_message msg;
 
 	if (!device_exists(device_path)) {
@@ -416,20 +387,24 @@
 		return 0;
 	}
 
-	if ((ret = do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
+	if ((err = do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
 			    dso_name, device_path, events, 0)) < 0) {
 		log_error("%s: event registration failed: %s", device_path,
-			  strerror(-ret));
-		return 0;
-	}
+			  msg.data ? msg.data : strerror(-err));
+		ret = 0;
+	} else
+		ret = 1;
 
-	return 1;
+	if (msg.data)
+		dm_free(msg.data);
+
+	return ret;
 }
 
-int dm_event_unregister(char *dso_name, char *device_path,
+int dm_event_unregister(const char *dso_name, const char *device_path,
 			enum dm_event_type events)
 {
-	int ret;
+	int ret, err;
 	struct dm_event_daemon_message msg;
 
 	if (!device_exists(device_path)) {
@@ -437,16 +412,30 @@
 		return 0;
 	}
 
-	if ((ret = do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
+	if ((err = do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
 			    dso_name, device_path, events, 0)) < 0) {
 		log_error("%s: event deregistration failed: %s", device_path,
-			  strerror(-ret));
-		return 0;
-	}
+			  msg.data ? msg.data : strerror(-err));
+		ret = 0;
+	} else
+		ret = 1;
 
-	return 1;
+	if (msg.data)
+		dm_free(msg.data);
+	return ret;
 }
 
+/*
+ * dm_event_get_registered_device
+ * @dso_name
+ * @device_path
+ * @events
+ * @next
+ *
+ * FIXME: This function sucks.
+ *
+ * Returns: 1 if device found, 0 otherwise (even on error)
+ */
 int dm_event_get_registered_device(char **dso_name, char **device_path,
 			     enum dm_event_type *events, int next)
 {
@@ -456,11 +445,16 @@
 
 	if (!(ret = do_event(next ? DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE :
 				    DM_EVENT_CMD_GET_REGISTERED_DEVICE,
-			     &msg, *dso_name, *device_path, *events, 0)))
-		ret = parse_message(&msg, &dso_name_arg, &device_path_arg,
-				    events);
+			     &msg, *dso_name, *device_path, *events, 0))) {
+		ret = !parse_message(&msg, &dso_name_arg, &device_path_arg,
+				     events);
+	} else /* FIXME: Make sure this is ENOENT */
+		ret = 0;
+
+	if (msg.data)
+		dm_free(msg.data);
 
-	if (next){
+	if (next) {
 		if (*dso_name)
 			dm_free(*dso_name);
 		if (*device_path)
@@ -477,7 +471,7 @@
 	return ret;
 }
 
-int dm_event_set_timeout(char *device_path, uint32_t timeout)
+int dm_event_set_timeout(const char *device_path, uint32_t timeout)
 {
 	struct dm_event_daemon_message msg;
 
@@ -487,7 +481,7 @@
 			NULL, device_path, 0, timeout);
 }
 
-int dm_event_get_timeout(char *device_path, uint32_t *timeout)
+int dm_event_get_timeout(const char *device_path, uint32_t *timeout)
 {
 	int ret;
 	struct dm_event_daemon_message msg;
@@ -495,16 +489,8 @@
 	if (!device_exists(device_path))
 		return -ENODEV;
 	if (!(ret = do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path, 0, 0)))
-		*timeout = atoi(msg.msg);
+		*timeout = atoi(msg.data);
+	if (msg.data)
+		dm_free(msg.data);
 	return ret;
 }
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
--- device-mapper/dmeventd/libdevmapper-event.h	2005/12/19 21:03:17	1.3
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/08 15:18:52	1.4
@@ -23,45 +23,6 @@
 
 #include <stdint.h>
 
-/* FIXME This stuff must be configurable. */
-
-#define	DM_EVENT_DAEMON		"/sbin/dmeventd"
-#define DM_EVENT_LOCKFILE	"/var/lock/dmeventd"
-#define	DM_EVENT_FIFO_CLIENT	"/var/run/dmeventd-client"
-#define	DM_EVENT_FIFO_SERVER	"/var/run/dmeventd-server"
-#define DM_EVENT_PIDFILE	"/var/run/dmeventd.pid"
-
-#define DM_EVENT_DEFAULT_TIMEOUT 10
-
-/* Commands for the daemon passed in the message below. */
-enum dm_event_command {
-	DM_EVENT_CMD_ACTIVE = 1,
-	DM_EVENT_CMD_REGISTER_FOR_EVENT,
-	DM_EVENT_CMD_UNREGISTER_FOR_EVENT,
-	DM_EVENT_CMD_GET_REGISTERED_DEVICE,
-	DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE,
-	DM_EVENT_CMD_SET_TIMEOUT,
-	DM_EVENT_CMD_GET_TIMEOUT,
-};
-
-/* Message passed between client and daemon. */
-struct dm_event_daemon_message {
-	union {
-		unsigned int cmd;	/* FIXME Use fixed size. */
-		int	 status;	/* FIXME Use fixed size. */
-	} opcode;
-	char msg[252];		/* FIXME Why is this 252 ? */
-} __attribute__((packed));	/* FIXME Do this properly! */
-
-/* FIXME Is this meant to be exported?  I can't see where the interface uses it. */
-/* Fifos for client/daemon communication. */
-struct dm_event_fifos {
-	int client;
-	int server;
-	const char *client_path;
-	const char *server_path;
-};
-
 /* Event type definitions. */
 /* FIXME Use masks to separate the types and provide for extension. */
 enum dm_event_type {
@@ -75,6 +36,7 @@
 
 	DM_EVENT_SYNC_STATUS	= 0x40, /* Mirror synchronization completed/failed. */
 	DM_EVENT_TIMEOUT	= 0x80, /* Timeout has occured */
+	DM_EVENT_REGISTRATION_PENDING        = 0X100, /* Monitor thread is setting-up/shutting-down */
 };
 
 /* FIXME Use a mask. */
@@ -86,19 +48,22 @@
 /* FIXME Replace device with standard name/uuid/devno choice */
 /* Interface changes: 
    First register a handler, passing in a unique ref for the device. */
+
 //  int dm_event_register_handler(const char *dso_name, const char *device);
 //  int dm_event_register(const char *dso_name, const char *name, const char *uuid, uint32_t major, uint32_t minor, enum dm_event_type events);
-/* Or (better?) add to task structure and use existing functions - run a task to register/unregister events - we may need to run task withe that with the new event mechanism anyway, then the dso calls just hook in.
-*/
+
+/* Or (better?) add to task structure and use existing functions - run
+   a task to register/unregister events - we may need to run task
+   withe that with the new event mechanism anyway, then the dso calls
+   just hook in. */
  
-/* FIXME Missing consts? */
-int dm_event_register(char *dso_name, char *device, enum dm_event_type events);
-int dm_event_unregister(char *dso_name, char *device,
+int dm_event_register(const char *dso_name, const char *device, enum dm_event_type events);
+int dm_event_unregister(const char *dso_name, const char *device,
 			enum dm_event_type events);
 int dm_event_get_registered_device(char **dso_name, char **device,
 				   enum dm_event_type *events, int next);
-int dm_event_set_timeout(char *device, uint32_t timeout);
-int dm_event_get_timeout(char *device, uint32_t *timeout);
+int dm_event_set_timeout(const char *device, uint32_t timeout);
+int dm_event_get_timeout(const char *device, uint32_t *timeout);
 
 /* Prototypes for DSO interface. */
 void process_event(const char *device, enum dm_event_type event);
--- device-mapper/lib/.exported_symbols	2006/10/12 15:42:24	1.23
+++ device-mapper/lib/.exported_symbols	2007/01/08 15:18:52	1.24
@@ -113,3 +113,4 @@
 dm_split_lvm_name
 dm_split_words
 dm_snprintf
+dm_basename
--- device-mapper/lib/libdevmapper.h	2006/10/12 15:42:24	1.59
+++ device-mapper/lib/libdevmapper.h	2007/01/08 15:18:52	1.60
@@ -608,4 +608,9 @@
  */
 int dm_snprintf(char *buf, size_t bufsize, const char *format, ...);
 
+/*
+ * Returns pointer to the last component of the path.
+ */
+char *dm_basename(const char *path);
+
 #endif				/* LIB_DEVICE_MAPPER_H */
--- device-mapper/lib/libdm-string.c	2006/08/21 12:52:39	1.2
+++ device-mapper/lib/libdm-string.c	2007/01/08 15:18:52	1.3
@@ -121,3 +121,11 @@
 
 	return n;
 }
+
+char *dm_basename(const char *path)
+{
+	char *p = strrchr(path, '/');
+
+	return p ? p + 1 : path;
+}
+
--- device-mapper/lib/ioctl/libdm-iface.c	2006/10/12 17:29:05	1.39
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/01/08 15:18:52	1.40
@@ -1506,6 +1506,8 @@
 	t2 = task->head;
 
 	while (t1 && t2) {
+		while (t2->params[strlen(t2->params) - 1] == ' ')
+			t2->params[strlen(t2->params) - 1] = '\0';
 		if ((t1->start != t2->start) ||
 		    (t1->length != t2->length) ||
 		    (strcmp(t1->type, t2->type)) ||
