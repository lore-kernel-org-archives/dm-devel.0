From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/.exported_s ...
Date: 22 Jan 2007 15:03:59 -0000
Message-ID: <20070122150359.7329.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-22 15:03:57

Modified files:
	.              : WHATS_NEW 
	dmeventd       : .exported_symbols dmeventd.c 
	                 libdevmapper-event.c libdevmapper-event.h 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-common.c libdm-deptree.c 
	                 libdm-report.c libdm-string.c 
	lib/datastruct : hash.c 
	lib/mm         : dbg_malloc.c 

Log message:
	Add dm_event_handler_[gs]et_timeout functions.
	Streamline dm_report_field_* interface.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.155&r2=1.156
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/.exported_symbols.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.42&r2=1.43
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.19&r2=1.20
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.77&r2=1.78
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.65&r2=1.66
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.42&r2=1.43
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.30&r2=1.31
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.9&r2=1.10

--- device-mapper/WHATS_NEW	2007/01/19 17:22:17	1.155
+++ device-mapper/WHATS_NEW	2007/01/22 15:03:56	1.156
@@ -1,5 +1,7 @@
 Version 1.02.16 -
 ===================================
+  Add dm_event_handler_[gs]et_timeout functions.
+  Streamline dm_report_field_* interface.
   Add cmdline debug & version options to dmeventd.
   Add DM_LIB_VERSION definition to configure.h.
   Suppress 'Unrecognised field' error if report field is 'help'.
--- device-mapper/dmeventd/.exported_symbols	2007/01/16 18:03:40	1.8
+++ device-mapper/dmeventd/.exported_symbols	2007/01/22 15:03:57	1.9
@@ -15,3 +15,5 @@
 dm_event_register_handler
 dm_event_unregister_handler
 dm_event_get_registered_device
+dm_event_handler_set_timeout
+dm_event_handler_get_timeout
--- device-mapper/dmeventd/dmeventd.c	2007/01/19 18:08:36	1.42
+++ device-mapper/dmeventd/dmeventd.c	2007/01/22 15:03:57	1.43
@@ -41,6 +41,8 @@
 #ifdef linux
 #  include <malloc.h>
 
+#  define OOM_ADJ_FILE "/proc/self/oom_adj"
+
 /* From linux/oom.h */
 #  define OOM_DISABLE (-17)
 #  define OOM_ADJUST_MIN (-16)
@@ -64,7 +66,6 @@
 #define	UNLINK_THREAD(x)	UNLINK(x)
 
 #define DAEMON_NAME "dmeventd"
-#define OOM_ADJ_FILE "/proc/self/oom_adj"
 
 /*
   Global mutex for thread list access. Has to be held when:
@@ -192,7 +193,7 @@
         va_start(ap,fmt);
 
         time(&P);
-        fprintf(stderr, "dmeventd[%x]: %.15s ", (int)pthread_self(), ctime(&P)+4 );
+        fprintf(stderr, "dmeventd[%p]: %.15s ", (void *) pthread_self(), ctime(&P)+4 );
         vfprintf(stderr, fmt, ap);
 	fprintf(stderr, "\n");
 
@@ -449,14 +450,14 @@
 	dm_lib_exit();
 }
 
-static void _exit_timeout(void *unused)
+static void _exit_timeout(void *unused __attribute((unused)))
 {
 	_timeout_running = 0;
 	pthread_mutex_unlock(&_timeout_mutex);
 }
 
 /* Wake up monitor threads every so often. */
-static void *_timeout_thread(void *unused)
+static void *_timeout_thread(void *unused __attribute((unused)))
 {
 	struct timespec timeout;
 	time_t curr_time;
@@ -468,16 +469,16 @@
 	while (!list_empty(&_timeout_registry)) {
 		struct thread_status *thread;
 
-		timeout.tv_sec = (time_t) -1;
+		timeout.tv_sec = 0;
 		curr_time = time(NULL);
 
 		list_iterate_items_gen(thread, &_timeout_registry, timeout_list) {
-			if (thread->next_time < curr_time) {
+			if (thread->next_time <= curr_time) {
 				thread->next_time = curr_time + thread->timeout;
 				pthread_kill(thread->thread, SIGALRM);
 			}
 
-			if (thread->next_time < timeout.tv_sec)
+			if (thread->next_time < timeout.tv_sec || !timeout.tv_sec)
 				timeout.tv_sec = thread->next_time;
 		}
 
@@ -682,6 +683,23 @@
 	_unlock_mutex();
 }
 
+static struct dm_task *_get_device_status(struct thread_status *ts)
+{
+	struct dm_task *dmt = dm_task_create(DM_DEVICE_STATUS);
+
+	if (!dmt)
+		return NULL;
+
+	dm_task_set_uuid(dmt, ts->device.uuid);
+
+	if (!dm_task_run(dmt)) {
+		dm_task_destroy(dmt);
+		return NULL;
+	}
+
+	return dmt;
+}
+
 /* Device monitoring thread. */
 static void *_monitor_thread(void *arg)
 {
@@ -708,6 +726,18 @@
 		if (wait_error == DM_WAIT_FATAL)
 			break;
 
+		/* Timeout occurred, task is not filled properly.
+		 * We get device status here for processing it in DSO.
+		 */
+		if (wait_error == DM_WAIT_INTR &&
+		    thread->current_events & DM_EVENT_TIMEOUT) {
+			dm_task_destroy(task);
+			task = _get_device_status(thread);
+			/* FIXME: syslog fail here ? */
+			if (!(thread->current_task = task))
+				continue;
+		}
+
 		/*
 		 * We know that wait succeeded and stored a
 		 * pointer to dm_task with device status into task.
@@ -798,8 +828,7 @@
 }
 
 /* Lookup DSO symbols we need. */
-static int _lookup_symbol(void *dl, struct dso_data *data,
-			 void **symbol, const char *name)
+static int _lookup_symbol(void *dl, void **symbol, const char *name)
 {
 	if ((*symbol = dlsym(dl, name)))
 		return 1;
@@ -809,11 +838,11 @@
 
 static int lookup_symbols(void *dl, struct dso_data *data)
 {
-	return _lookup_symbol(dl, data, (void *) &data->process_event,
+	return _lookup_symbol(dl, (void *) &data->process_event,
 			     "process_event") &&
-	    _lookup_symbol(dl, data, (void *) &data->register_device,
+	    _lookup_symbol(dl, (void *) &data->register_device,
 			  "register_device") &&
-	    _lookup_symbol(dl, data, (void *) &data->unregister_device,
+	    _lookup_symbol(dl, (void *) &data->unregister_device,
 			  "unregister_device");
 }
 
@@ -909,7 +938,7 @@
 	   usually means we are so starved on resources that we are
 	   almost as good as dead already... */
 	if (thread_new->events & DM_EVENT_TIMEOUT) {
-		ret = -_register_for_timeout(thread);
+		ret = -_register_for_timeout(thread_new);
 		if (ret) {
 		    _unlock_mutex();
 		    goto out;
@@ -1426,7 +1455,7 @@
 	_unlock_mutex();
 }
 
-static void _sig_alarm(int signum)
+static void _sig_alarm(int signum __attribute((unused)))
 {
 	pthread_testcancel();
 }
@@ -1458,7 +1487,7 @@
  * Set the global variable which the process should
  * be watching to determine when to exit.
  */
-static void _exit_handler(int sig)
+static void _exit_handler(int sig __attribute((unused)))
 {
 	/*
 	 * We exit when '_exit_now' is set.
@@ -1492,6 +1521,7 @@
 	return 0;
 }
 
+#ifdef linux
 /*
  * Protection against OOM killer if kernel supports it
  */
@@ -1519,6 +1549,7 @@
 
 	return 1;
 }
+#endif
 
 static void _daemonize(void)
 {
@@ -1643,8 +1674,10 @@
 	signal(SIGHUP, &_exit_handler);
 	signal(SIGQUIT, &_exit_handler);
 
+#ifdef linux
 	if (!_set_oom_adj(OOM_DISABLE) && !_set_oom_adj(OOM_ADJUST_MIN))
 		syslog(LOG_ERR, "Failed to set oom_adj to protect against OOM killer");
+#endif
 
 	_init_thread_signals();
 
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/17 14:45:10	1.19
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/22 15:03:57	1.20
@@ -38,6 +38,7 @@
 	char *uuid;
 	int major;
 	int minor;
+	uint32_t timeout;
 
 	enum dm_event_mask mask;
 };
@@ -62,6 +63,7 @@
 	dmevh->dso = dmevh->dev_name = dmevh->uuid = NULL;
 	dmevh->major = dmevh->minor = 0;
 	dmevh->mask = 0;
+	dmevh->timeout = 0;
 
 	return dmevh;
 }
@@ -140,6 +142,11 @@
 	dmevh->mask = evmask;
 }
 
+void dm_event_handler_set_timeout(struct dm_event_handler *dmevh, int timeout)
+{
+	dmevh->timeout = timeout;
+}
+
 const char *dm_event_handler_get_dso(const struct dm_event_handler *dmevh)
 {
 	return dmevh->dso;
@@ -165,6 +172,11 @@
 	return dmevh->minor;
 }
 
+int dm_event_handler_get_timeout(const struct dm_event_handler *dmevh)
+{
+	return dmevh->timeout;
+}
+
 enum dm_event_mask dm_event_handler_get_event_mask(const struct dm_event_handler *dmevh)
 {
 	return dmevh->mask;
@@ -484,8 +496,8 @@
 
 /* Handle the event (de)registration call and return negative error codes. */
 static int _do_event(int cmd, struct dm_event_daemon_message *msg,
-		    const char *dso_name, const char *dev_name,
-		    enum dm_event_mask evmask, uint32_t timeout)
+		     const char *dso_name, const char *dev_name,
+		     enum dm_event_mask evmask, uint32_t timeout)
 {
 	int ret;
 	struct dm_event_fifos fifos;
@@ -519,7 +531,7 @@
 	uuid = dm_task_get_uuid(dmt);
 
 	if ((err = _do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
-			     dmevh->dso, uuid, dmevh->mask, 0)) < 0) {
+			     dmevh->dso, uuid, dmevh->mask, dmevh->timeout)) < 0) {
 		log_error("%s: event registration failed: %s",
 			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
@@ -549,7 +561,7 @@
 	uuid = dm_task_get_uuid(dmt);
 
 	if ((err = _do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
-			    dmevh->dso, uuid, dmevh->mask, 0)) < 0) {
+			    dmevh->dso, uuid, dmevh->mask, dmevh->timeout)) < 0) {
 		log_error("%s: event deregistration failed: %s",
 			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
@@ -690,8 +702,9 @@
 
 	if (!device_exists(device_path))
 		return -ENODEV;
+
 	return _do_event(DM_EVENT_CMD_SET_TIMEOUT, &msg,
-			NULL, device_path, 0, timeout);
+			 NULL, device_path, 0, timeout);
 }
 
 int dm_event_get_timeout(const char *device_path, uint32_t *timeout)
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/19 20:42:09	1.11
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/22 15:03:57	1.12
@@ -71,6 +71,7 @@
 
 void dm_event_handler_set_major(struct dm_event_handler *dmevh, int major);
 void dm_event_handler_set_minor(struct dm_event_handler *dmevh, int minor);
+void dm_event_handler_set_timeout(struct dm_event_handler *dmevh, int timeout);
 
 /*
  * Specify mask for events to monitor.
@@ -83,6 +84,7 @@
 const char *dm_event_handler_get_uuid(const struct dm_event_handler *dmevh);
 int dm_event_handler_get_major(const struct dm_event_handler *dmevh);
 int dm_event_handler_get_minor(const struct dm_event_handler *dmevh);
+int dm_event_handler_get_timeout(const struct dm_event_handler *dmevh);
 enum dm_event_mask dm_event_handler_get_event_mask(const struct dm_event_handler *dmevh);
 
 /* FIXME Review interface (what about this next thing?) */
--- device-mapper/dmsetup/dmsetup.c	2007/01/18 17:47:57	1.77
+++ device-mapper/dmsetup/dmsetup.c	2007/01/22 15:03:57	1.78
@@ -1705,7 +1705,8 @@
 /*
  *  create a table for a mapped device using the loop target.
  */
-static int _loop_table(char *table, size_t tlen, char *file, char *dev, off_t off)
+static int _loop_table(char *table, size_t tlen, char *file,
+		       char *dev __attribute((unused)), off_t off)
 {
 	struct stat fbuf;
 	off_t size, sectors;
--- device-mapper/lib/libdevmapper.h	2007/01/18 17:47:58	1.65
+++ device-mapper/lib/libdevmapper.h	2007/01/22 15:03:57	1.66
@@ -687,26 +687,27 @@
 int dm_report_output(struct dm_report *rh);
 void dm_report_free(struct dm_report *rh);
 
-/* report functions for common types */
-int dm_report_field_string(struct dm_report *rh, struct dm_pool *mem,
-			   struct dm_report_field *field, const void *data);
-int dm_report_field_int32(struct dm_report *rh, struct dm_pool *mem,
-			  struct dm_report_field *field, const void *data);
-int dm_report_field_uint32(struct dm_report *rh, struct dm_pool *mem,
-			   struct dm_report_field *field, const void *data);
-int dm_report_field_int(struct dm_report *rh, struct dm_pool *mem,
-			struct dm_report_field *field, const void *data);
-int dm_report_field_uint64(struct dm_report *rh, struct dm_pool *mem,
-			struct dm_report_field *field, const void *data);
-
 /*
- * Helper function for custom reporting functions
+ * Report functions are provided for simple data types.
+ * They take care of allocating copies of the data.
  */
+int dm_report_field_string(struct dm_report *rh, struct dm_report_field *field,
+			   const char **data);
+int dm_report_field_int32(struct dm_report *rh, struct dm_report_field *field,
+			  const int32_t *data);
+int dm_report_field_uint32(struct dm_report *rh, struct dm_report_field *field,
+			   const uint32_t *data);
+int dm_report_field_int(struct dm_report *rh, struct dm_report_field *field,
+			const int *data);
+int dm_report_field_uint64(struct dm_report *rh, struct dm_report_field *field,
+			   const uint64_t *data);
 
 /*
- * sortvalue may be NULL if it's the same as value
+ * For custom fields, allocate the data in 'mem' and use
+ * dm_report_field_set_value().
+ * 'sortvalue' may be NULL if it matches 'value'
  */
-void dm_report_field_set_value(struct dm_report_field *field,
-			       const void *value, const void *sortvalue);
+void dm_report_field_set_value(struct dm_report_field *field, const void *value,
+			       const void *sortvalue);
 
 #endif				/* LIB_DEVICE_MAPPER_H */
--- device-mapper/lib/libdm-common.c	2006/05/10 16:23:41	1.42
+++ device-mapper/lib/libdm-common.c	2007/01/22 15:03:57	1.43
@@ -38,8 +38,8 @@
  * Library users can provide their own logging
  * function.
  */
-static void _default_log(int level, const char *file, int line,
-			 const char *f, ...)
+static void _default_log(int level, const char *file __attribute((unused)),
+			 int line __attribute((unused)), const char *f, ...)
 {
 	va_list ap;
 
--- device-mapper/lib/libdm-deptree.c	2007/01/09 19:44:07	1.30
+++ device-mapper/lib/libdm-deptree.c	2007/01/22 15:03:57	1.31
@@ -1212,7 +1212,9 @@
 	return 1;
 }
 
-static int _emit_areas_line(struct dm_task *dmt, struct load_segment *seg, char *params, size_t paramsize, int *pos)
+static int _emit_areas_line(struct dm_task *dmt __attribute((unused)),
+			    struct load_segment *seg, char *params,
+			    size_t paramsize, int *pos)
 {
 	struct seg_area *area;
 	char devbuf[10];
--- device-mapper/lib/libdm-report.c	2007/01/18 22:15:04	1.5
+++ device-mapper/lib/libdm-report.c	2007/01/22 15:03:57	1.6
@@ -99,12 +99,12 @@
  * Data-munging functions to prepare each data type for display and sorting
  */
 
-int dm_report_field_string(struct dm_report *rh, struct dm_pool *mem,
-			   struct dm_report_field *field, const void *data)
+int dm_report_field_string(struct dm_report *rh,
+			   struct dm_report_field *field, const char **data)
 {
 	char *repstr;
 
-	if (!(repstr = dm_pool_strdup(rh->mem, *(const char **) data))) {
+	if (!(repstr = dm_pool_strdup(rh->mem, *data))) {
 		log_error("dm_report_field_string: dm_pool_strdup failed");
 		return 0;
 	}
@@ -115,10 +115,10 @@
 	return 1;
 }
 
-int dm_report_field_int(struct dm_report *rh, struct dm_pool *mem,
-			struct dm_report_field *field, const void *data)
+int dm_report_field_int(struct dm_report *rh,
+			struct dm_report_field *field, const int *data)
 {
-	const int value = *(const int *) data;
+	const int value = *data;
 	uint64_t *sortval;
 	char *repstr;
 
@@ -144,10 +144,10 @@
 	return 1;
 }
 
-int dm_report_field_uint32(struct dm_report *rh, struct dm_pool *mem,
-			   struct dm_report_field *field, const void *data)
+int dm_report_field_uint32(struct dm_report *rh,
+			   struct dm_report_field *field, const uint32_t *data)
 {
-	const uint32_t value = *(const uint32_t *) data;
+	const uint32_t value = *data;
 	uint64_t *sortval;
 	char *repstr;
 
@@ -173,10 +173,10 @@
 	return 1;
 }
 
-int dm_report_field_int32(struct dm_report *rh, struct dm_pool *mem,
-			  struct dm_report_field *field, const void *data)
+int dm_report_field_int32(struct dm_report *rh,
+			  struct dm_report_field *field, const int32_t *data)
 {
-	const int32_t value = *(const int32_t *) data;
+	const int32_t value = *data;
 	uint64_t *sortval;
 	char *repstr;
 
@@ -202,10 +202,10 @@
 	return 1;
 }
 
-int dm_report_field_uint64(struct dm_report *rh, struct dm_pool *mem,
-			   struct dm_report_field *field, const void *data)
+int dm_report_field_uint64(struct dm_report *rh,
+			   struct dm_report_field *field, const uint64_t *data)
 {
-	const int value = *(const uint64_t *) data;
+	const int value = *data;
 	uint64_t *sortval;
 	char *repstr;
 
--- device-mapper/lib/libdm-string.c	2007/01/15 18:21:01	1.6
+++ device-mapper/lib/libdm-string.c	2007/01/22 15:03:57	1.7
@@ -37,7 +37,8 @@
  * Split buffer into NULL-separated words in argv.
  * Returns number of words.
  */
-int dm_split_words(char *buffer, unsigned max, unsigned ignore_comments,
+int dm_split_words(char *buffer, unsigned max,
+		   unsigned ignore_comments __attribute((unused)),
 		   char **argv)
 {
 	unsigned arg;
--- device-mapper/lib/datastruct/hash.c	2006/01/09 20:35:24	1.4
+++ device-mapper/lib/datastruct/hash.c	2007/01/22 15:03:57	1.5
@@ -230,12 +230,14 @@
 	t->num_nodes = 0u;
 }
 
-char *dm_hash_get_key(struct dm_hash_table *t, struct dm_hash_node *n)
+char *dm_hash_get_key(struct dm_hash_table *t __attribute((unused)),
+		      struct dm_hash_node *n)
 {
 	return n->key;
 }
 
-void *dm_hash_get_data(struct dm_hash_table *t, struct dm_hash_node *n)
+void *dm_hash_get_data(struct dm_hash_table *t __attribute((unused)),
+		       struct dm_hash_node *n)
 {
 	return n->data;
 }
--- device-mapper/lib/mm/dbg_malloc.c	2007/01/15 14:39:12	1.9
+++ device-mapper/lib/mm/dbg_malloc.c	2007/01/22 15:03:57	1.10
@@ -231,7 +231,8 @@
 	}
 }
 
-void *dm_malloc_aux(size_t s, const char *file, int line)
+void *dm_malloc_aux(size_t s, const char *file __attribute((unused)),
+		    int line __attribute((unused)))
 {
 	if (s > 50000000) {
 		log_error("Huge memory allocation (size %" PRIsize_t
