From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 16 Jan 2007 20:27:08 -0000
Message-ID: <20070116202708.9667.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-16 20:27:08

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	clean up global mutex usage and fix a race in thread finalisation code
	properly clean up thread status when thread terminates from within

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.36&r2=1.37

--- device-mapper/dmeventd/dmeventd.c	2007/01/16 20:13:04	1.36
+++ device-mapper/dmeventd/dmeventd.c	2007/01/16 20:27:07	1.37
@@ -59,14 +59,21 @@
 
 #define DAEMON_NAME "dmeventd"
 
-/* Global mutex for list accesses. */
+/*
+  Global mutex for thread list access. Has to be held when: 
+  - iterating thread list
+  - adding or removing elements from thread list
+  - changing or reading thread_status's fields:
+    processing, status, events
+  Use _lock_mutex() and _unlock_mutex() to hold/release it
+*/
 static pthread_mutex_t _global_mutex;
 
 #define DM_THREAD_RUNNING  0
 #define DM_THREAD_SHUTDOWN 1
 #define DM_THREAD_DONE     2
 
-#define THREAD_STACK_SIZE 300*1024
+#define THREAD_STACK_SIZE (300*1024)
 
 /* Data kept about a DSO. */
 struct dso_data {
@@ -220,6 +227,9 @@
 {
 	pthread_attr_t attr;
 	pthread_attr_init(&attr);
+	/*
+	 * We use a smaller stack since it gets preallocated in its entirety
+	 */
 	pthread_attr_setstacksize(&attr, THREAD_STACK_SIZE);
 	return pthread_create(t, &attr, fun, arg);
 }
@@ -318,7 +328,8 @@
 	return ret;
 };
 
-/* Global mutex to lock access to lists et al. */
+/* Global mutex to lock access to lists et al. See _global_mutex
+   above. */
 static int _lock_mutex(void)
 {
 	return pthread_mutex_lock(&_global_mutex);
@@ -612,7 +623,7 @@
 /* Thread cleanup handler to unregister device. */
 static void _monitor_unregister(void *arg)
 {
-	struct thread_status *thread = arg;
+	struct thread_status *thread = arg, *thread_iter;
 
 	if (!_do_unregister_device(thread))
 		syslog(LOG_ERR, "%s: %s unregister failed\n", __func__,
@@ -620,6 +631,28 @@
 	if (thread->current_task)
 		dm_task_destroy(thread->current_task);
 	thread->current_task = NULL;
+
+	_lock_mutex();
+	if (thread->events & DM_EVENT_TIMEOUT) {
+		/* _unregister_for_timeout locks another mutex, we
+		   don't want to deadlock so we release our mutex for
+		   a bit */
+		_unlock_mutex();
+		_unregister_for_timeout(thread);
+		_lock_mutex();
+	}
+	/* we may have been relinked to unused registry since we were
+	   called, so check that */
+	list_iterate_items(thread_iter, &_thread_registry_unused)
+		if (thread_iter == thread) {
+			thread->status = DM_THREAD_DONE;
+			_unlock_mutex();
+			return;
+		}
+	thread->status = DM_THREAD_DONE;
+	UNLINK_THREAD(thread);
+	LINK(thread, &_thread_registry_unused);
+	_unlock_mutex();
 }
 
 /* Device monitoring thread. */
@@ -686,10 +719,6 @@
 		}
 	}
 
-	_lock_mutex();
-	thread->status = DM_THREAD_DONE;
-	_unlock_mutex();
-
 	pthread_cleanup_pop(1);
 
 	return NULL;
@@ -711,7 +740,7 @@
 	return pthread_kill(thread->thread, SIGALRM);
 }
 
-/* DSO reference counting. */
+/* DSO reference counting. Call with _global_mutex locked! */
 static void _lib_get(struct dso_data *data)
 {
 	data->ref_count++;
@@ -731,8 +760,6 @@
 {
 	struct dso_data *dso_data, *ret = NULL;
 
-	_lock_mutex();
-
 	list_iterate_items(dso_data, &_dso_registry)
 	    if (!strcmp(data->dso_name, dso_data->dso_name)) {
 		_lib_get(dso_data);
@@ -740,8 +767,6 @@
 		break;
 	}
 
-	_unlock_mutex();
-
 	return ret;
 }
 
@@ -922,6 +947,13 @@
 		goto out;
 	}
 
+	if (thread->status == DM_THREAD_DONE) {
+		/* the thread has terminated while we were not
+		   watching */
+		_unlock_mutex();
+		return 0;
+	}
+
 	thread->events &= ~message_data->events.field;
 
 	if (!(thread->events & DM_EVENT_TIMEOUT))
