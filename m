From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 23 Jan 2007 17:38:40 -0000
Message-ID: <20070123173840.27271.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-23 17:38:39

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c libdevmapper-event.h 
	lib            : libdm-report.c 

Log message:
	add a dso-private variable to dmeventd interface
	more inline docn

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.156&r2=1.157
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.43&r2=1.44
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.6&r2=1.7

--- device-mapper/WHATS_NEW	2007/01/22 15:03:56	1.156
+++ device-mapper/WHATS_NEW	2007/01/23 17:38:38	1.157
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Add a dso-private variable to dmeventd dso interface.
   Add dm_event_handler_[gs]et_timeout functions.
   Streamline dm_report_field_* interface.
   Add cmdline debug & version options to dmeventd.
--- device-mapper/dmeventd/dmeventd.c	2007/01/22 15:03:57	1.43
+++ device-mapper/dmeventd/dmeventd.c	2007/01/23 17:38:39	1.44
@@ -77,6 +77,19 @@
 */
 static pthread_mutex_t _global_mutex;
 
+/*
+  There are three states a thread can attain (see struct
+  thread_status, field int status):
+
+  - DM_THREAD_RUNNING: thread has started up and is either working or
+  waiting for events... transitions to either SHUTDOWN or DONE
+  - DM_THREAD_SHUTDOWN: thread is still doing something, but it is
+  supposed to terminate (and transition to DONE) as soon as it
+  finishes whatever it was doing at the point of flipping state to
+  SHUTDOWN... the thread is still on the thread list
+  - DM_THREAD_DONE: thread has terminated and has been moved over to
+  unused thread list, cleanup pending
+ */
 #define DM_THREAD_RUNNING  0
 #define DM_THREAD_SHUTDOWN 1
 #define DM_THREAD_DONE     2
@@ -106,7 +119,7 @@
 	 * DM_DEVICE_STATUS). It should not destroy it.
 	 * The caller must dispose of the task.
 	 */
-	void (*process_event)(struct dm_task *dmt, enum dm_event_mask event);
+	void (*process_event)(struct dm_task *dmt, enum dm_event_mask event, void **user);
 
 	/*
 	 * Device registration.
@@ -117,7 +130,7 @@
 	 * and activate a mapping).
 	 */
 	int (*register_device)(const char *device, const char *uuid, int major,
-			       int minor);
+			       int minor, void **user);
 
 	/*
 	 * Device unregistration.
@@ -127,7 +140,7 @@
 	 * steps (eg, deactivate mapping, metadata update).
 	 */
 	int (*unregister_device)(const char *device, const char *uuid,
-				 int major, int minor);
+				 int major, int minor, void **user);
 };
 static LIST_INIT(_dso_registry);
 
@@ -166,13 +179,16 @@
 	} device;
 	uint32_t event_nr;	/* event number */
 	int processing;		/* Set when event is being processed */
-	int status;		/* running/shutdown/done */
+
+	int status;		/* see DM_THREAD_{RUNNING,SHUTDOWN,DONE}
+				   constants above */
 	enum dm_event_mask events;	/* bitfield for event filter. */
 	enum dm_event_mask current_events;	/* bitfield for occured events. */
 	struct dm_task *current_task;
 	time_t next_time;
 	uint32_t timeout;
 	struct list timeout_list;
+	void *dso_private; /* dso per-thread status variable */
 };
 static LIST_INIT(_thread_registry);
 static LIST_INIT(_thread_registry_unused);
@@ -630,7 +646,8 @@
 	return thread->dso_data->register_device(thread->device.name,
 						 thread->device.uuid,
 						 thread->device.major,
-						 thread->device.minor);
+						 thread->device.minor,
+						 &(thread->dso_private));
 }
 
 /* Unregister a device with the DSO. */
@@ -639,13 +656,14 @@
 	return thread->dso_data->unregister_device(thread->device.name,
 						   thread->device.uuid,
 						   thread->device.major,
-						   thread->device.minor);
+						   thread->device.minor,
+						   &(thread->dso_private));
 }
 
 /* Process an event in the DSO. */
 static void _do_process_event(struct thread_status *thread, struct dm_task *task)
 {
-	thread->dso_data->process_event(task, thread->current_events);
+	thread->dso_data->process_event(task, thread->current_events, &(thread->dso_private));
 }
 
 /* Thread cleanup handler to unregister device. */
@@ -1107,22 +1125,25 @@
 	if (!hit)
 		goto out;
 
-	goto out; /* FIXME the next == 1 thing is currently horridly
-		     broken, do something about it... */
+	thread = hit;
 
-	do {
+	while (1) {
 		if (list_end(&_thread_registry, &thread->list))
 			goto out;
 
 		thread = list_item(thread->list.n, struct thread_status);
-	} while (!_want_registered_device(message_data->dso_name, NULL, thread));
+		if (_want_registered_device(message_data->dso_name, NULL, thread)) {
+			hit = thread;
+			break;
+		}
+	}
 
 	_unlock_mutex();
-	return _registered_device(message_data, thread);
+	return _registered_device(message_data, hit);
 
       out:
 	_unlock_mutex();
-
+	
 	return -ENOENT;
 }
 
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/22 15:03:57	1.12
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/23 17:38:39	1.13
@@ -98,9 +98,9 @@
 
 /* Prototypes for DSO interface, see dmeventd.c, struct dso_data for
    detailed descriptions. */
-void process_event(struct dm_task *dmt, enum dm_event_mask evmask);
-int register_device(const char *device_name, const char *uuid, int major, int minor);
+void process_event(struct dm_task *dmt, enum dm_event_mask evmask, void **user);
+int register_device(const char *device_name, const char *uuid, int major, int minor, void **user);
 int unregister_device(const char *device_name, const char *uuid, int major,
-		      int minor);
+		      int minor, void **user);
 
 #endif
--- device-mapper/lib/libdm-report.c	2007/01/22 15:03:57	1.6
+++ device-mapper/lib/libdm-report.c	2007/01/23 17:38:39	1.7
@@ -757,8 +757,7 @@
 	/* Print and clear buffer */
 	list_iterate_safe(rowh, rtmp, &rh->rows) {
 		if (!dm_pool_begin_object(rh->mem, 512)) {
-			log_error("dm_report: "
-				  "dm_pool_begin_object failed for row");
+			log_error("dm_report: Unable to allocate output line");
 			return 0;
 		}
 		row = list_item(rowh, struct row);
@@ -771,35 +770,48 @@
 			width = field->props->width;
 			if (!(rh->flags & DM_REPORT_OUTPUT_ALIGNED)) {
 				if (!dm_pool_grow_object(rh->mem, repstr,
-						      strlen(repstr)))
-					goto bad_grow;
+						      strlen(repstr))) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
 			} else {
 				if (!(align = field->props->flags & DM_REPORT_FIELD_ALIGN_MASK))
 					align = (field->props->flags & DM_REPORT_FIELD_TYPE_NUMBER) ? 
 						DM_REPORT_FIELD_ALIGN_RIGHT : DM_REPORT_FIELD_ALIGN_LEFT;
 				if (align & DM_REPORT_FIELD_ALIGN_LEFT) {
 					if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
-							 width, width, repstr) < 0)
-						goto bad_snprintf;
-					if (!dm_pool_grow_object(rh->mem, buf, width))
-						goto bad_grow;
+							 width, width, repstr) < 0) {
+						log_error("dm_report: left-aligned snprintf() failed");
+						goto bad;
+					}
+					if (!dm_pool_grow_object(rh->mem, buf, width)) {
+						log_error("dm_report: Unable to extend output line");
+						goto bad;
+					}
 				} else if (align & DM_REPORT_FIELD_ALIGN_RIGHT) {
 					if (dm_snprintf(buf, sizeof(buf), "%*.*s",
-							 width, width, repstr) < 0)
-						goto bad_snprintf;
+							 width, width, repstr) < 0) {
+						log_error("dm_report: right-aligned snprintf() failed");
+						goto bad;
+					}
 					if (!dm_pool_grow_object(rh->mem, buf, width))
-						goto bad_grow;
+						log_error("dm_report: Unable to extend output line");
+						goto bad;
 				}
 			}
 
 			if (!list_end(&row->fields, fh))
 				if (!dm_pool_grow_object(rh->mem, rh->separator,
-						      strlen(rh->separator)))
-					goto bad_grow;
+						      strlen(rh->separator))) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
 			list_del(&field->list);
 		}
-		if (!dm_pool_grow_object(rh->mem, "\0", 1))
-			goto bad_grow;
+		if (!dm_pool_grow_object(rh->mem, "\0", 1)) {
+			log_error("dm_report: Unable to terminate output line");
+			goto bad;
+		}
 		log_print("%s", (char *) dm_pool_end_object(rh->mem));
 		list_del(&row->list);
 	}
@@ -809,10 +821,7 @@
 
 	return 1;
 
-      bad_snprintf:
-	log_error("dm_report: snprintf row failed");
-      bad_grow:
-	log_error("dm_report: Failed to generate row for printing");
+      bad:
 	dm_pool_abandon_object(rh->mem);
 	return 0;
 }
