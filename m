From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c libdevmapper ...
Date: 16 Jan 2007 23:03:14 -0000
Message-ID: <20070116230314.12646.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-16 23:03:13

Modified files:
	dmeventd       : dmeventd.c libdevmapper-event.c 
	                 libdevmapper-event.h 

Log message:
	more fixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.38&r2=1.39
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.17&r2=1.18
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.8&r2=1.9

--- device-mapper/dmeventd/dmeventd.c	2007/01/16 21:13:07	1.38
+++ device-mapper/dmeventd/dmeventd.c	2007/01/16 23:03:13	1.39
@@ -1005,40 +1005,55 @@
 	/* If DSO names and device paths are equal. */
 	if (dso_name && device_uuid)
 		return !strcmp(dso_name, thread->dso_data->dso_name) &&
-		    !strcmp(device_uuid, thread->device.uuid);
+		    !strcmp(device_uuid, thread->device.uuid) &&
+			(thread->status == DM_THREAD_RUNNING ||
+			 (thread->events & DM_EVENT_REGISTRATION_PENDING));
 
 	/* If DSO names are equal. */
 	if (dso_name)
-		return !strcmp(dso_name, thread->dso_data->dso_name);
+		return !strcmp(dso_name, thread->dso_data->dso_name) &&
+			(thread->status == DM_THREAD_RUNNING ||
+			 (thread->events & DM_EVENT_REGISTRATION_PENDING));
 
 	/* If device paths are equal. */
 	if (device_uuid)
-		return !strcmp(device_uuid, thread->device.uuid);
+		return !strcmp(device_uuid, thread->device.uuid) &&
+			(thread->status == DM_THREAD_RUNNING ||
+			 (thread->events & DM_EVENT_REGISTRATION_PENDING));
 
 	return 1;
 }
 
 static int _get_registered_dev(struct message_data *message_data, int next)
 {
-	int hit = 0;
-	struct thread_status *thread;
+	struct thread_status *thread, *hit = NULL;
 
 	_lock_mutex();
 
 	/* Iterate list of threads checking if we want a particular one. */
 	list_iterate_items(thread, &_thread_registry)
-	    if ((hit = _want_registered_device(message_data->dso_name,
-					      message_data->device_uuid,
-					      thread)))
-		break;
+		if (_want_registered_device(message_data->dso_name,
+					    message_data->device_uuid,
+					    thread)) {
+			hit = thread;
+			break;
+		}
 
 	/*
 	 * If we got a registered device and want the next one ->
 	 * fetch next conforming element off the list.
 	 */
-	if (!hit || !next)
+	if (hit && !next) {
+		_unlock_mutex();
+		return _registered_device(message_data, hit);
+	}
+
+	if (!hit)
 		goto out;
 
+	goto out; /* FIXME the next == 1 thing is currently horridly
+		     broken, do something about it... */
+
 	do {
 		if (list_end(&_thread_registry, &thread->list))
 			goto out;
@@ -1046,6 +1061,7 @@
 		thread = list_item(thread->list.n, struct thread_status);
 	} while (!_want_registered_device(message_data->dso_name, NULL, thread));
 
+	_unlock_mutex();
 	return _registered_device(message_data, thread);
 
       out:
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 21:13:07	1.17
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 23:03:13	1.18
@@ -556,12 +556,12 @@
 
 /* Parse a device message from the daemon. */
 static int _parse_message(struct dm_event_daemon_message *msg, char **dso_name,
-			 char **dev_name, enum dm_event_mask *evmask)
+			 char **uuid, enum dm_event_mask *evmask)
 {
 	char *p = msg->data;
 
 	if ((*dso_name = _fetch_string(&p, ' ')) &&
-	    (*dev_name = _fetch_string(&p, ' '))) {
+	    (*uuid = _fetch_string(&p, ' '))) {
 		*evmask = atoi(p);
 
 		return 0;
@@ -577,41 +577,45 @@
  * @mask
  * @next
  *
- * FIXME: This function sucks.
- *
- * Returns: 1 if device found, 0 otherwise (even on error)
+ * Returns: 0 if handler found, error (-ENOMEM, -ENOENT) otherwise
  */
-int dm_event_get_registered_device(char **dso_name, char **device_path,
-				   enum dm_event_mask *mask, int next)
+int dm_event_get_registered_device(struct dm_event_handler *dmevh, int next)
 {
 	int ret;
-	char *dso_name_arg = NULL, *device_path_arg = NULL;
+	char *uuid = NULL;
+	char *reply_dso = NULL, *reply_uuid = NULL;
+	enum dm_event_mask reply_mask;
+	struct dm_task *dmt;
 	struct dm_event_daemon_message msg;
 
+	if (!(dmt = _get_device_info(dmevh))) {
+		stack;
+		return 0;
+	}
+
+	uuid = dm_task_get_uuid(dmt);
+
 	if (!(ret = _do_event(next ? DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE :
 			     DM_EVENT_CMD_GET_REGISTERED_DEVICE,
-			     &msg, *dso_name, *device_path, *mask, 0))) {
-		ret = !_parse_message(&msg, &dso_name_arg, &device_path_arg,
-				     mask);
-	} else			/* FIXME: Make sure this is ENOENT */
-		ret = 0;
+			      &msg, dmevh->dso, uuid, dmevh->mask, 0))) {
+		/* FIXME this will probably horribly break if we get
+		   ill-formatted reply */
+		ret = _parse_message(&msg, &reply_dso, &reply_uuid, &reply_mask);
+	} else
+		ret = -ENOENT;
 
 	if (msg.data)
 		dm_free(msg.data);
 
-	if (next) {
-		if (*dso_name)
-			dm_free(*dso_name);
-		if (*device_path)
-			dm_free(*device_path);
-		*dso_name = dso_name_arg;
-		*device_path = device_path_arg;
-	} else {
-		if (!(*dso_name))
-			*dso_name = dso_name_arg;
-		if (!(*device_path))
-			*device_path = device_path_arg;
-	}
+	dm_event_handler_set_uuid(dmevh, reply_uuid);
+	dm_event_handler_set_dso(dmevh, reply_dso);
+	dm_event_handler_set_event_mask(dmevh, reply_mask);
+	/* FIXME also fill in name and device number */
+	/* FIXME this probably leaks memory, since noone is going to
+	   dm_free the bits in dmevh -- needs changes to
+	   dm_event_handle_set behaviour */
+
+	dm_task_destroy(dmt);
 
 	return ret;
 }
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/16 18:03:40	1.8
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/16 23:03:13	1.9
@@ -60,6 +60,8 @@
 /*
  * Identify the device to monitor by exactly one of
  * dev_name, uuid or device number.
+ * FIXME we should give guarantees about how dev_name and uuid
+ * pontiers are handled, eg dm_strdup them
  */
 void dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name);
 
@@ -81,9 +83,8 @@
 int dm_event_handler_get_minor(const struct dm_event_handler *dmevh);
 enum dm_event_mask dm_event_handler_get_event_mask(const struct dm_event_handler *dmevh);
 
-/* FIXME Review interface */
-int dm_event_get_registered_device(char **dso_name, char **device_path,
-				   enum dm_event_mask *evmask, int next);
+/* FIXME Review interface (what about this next thing?) */
+int dm_event_get_registered_device(struct dm_event_handler *dmevh, int next);
 
 /*
  * Initiate monitoring using dmeventd.
