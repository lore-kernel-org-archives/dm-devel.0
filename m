From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/.exported_s ...
Date: 15 Jan 2007 18:21:02 -0000
Message-ID: <20070115182102.8949.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 18:21:02

Modified files:
	.              : WHATS_NEW 
	dmeventd       : .exported_symbols dmeventd.c 
	                 libdevmapper-event.c libdevmapper-event.h 
	lib            : .exported_symbols libdevmapper.h libdm-string.c 

Log message:
	More libdevmapper-event interface changes and fixes.
	Rename dm_saprintf() to dm_asprintf().

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.146&r2=1.147
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/.exported_symbols.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.28&r2=1.29
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.26&r2=1.27
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.62&r2=1.63
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.5&r2=1.6

--- device-mapper/WHATS_NEW	2007/01/15 14:39:11	1.146
+++ device-mapper/WHATS_NEW	2007/01/15 18:21:01	1.147
@@ -1,5 +1,7 @@
 Version 1.02.15 -
 ===================================
+  More libdevmapper-event interface changes and fixes.
+  Rename dm_saprintf() to dm_asprintf().
   Report error if NULL pointer is supplied to dm_strdup_aux().
   Reinstate dm_event_get_registered_device.
 
--- device-mapper/dmeventd/.exported_symbols	2007/01/12 20:22:11	1.6
+++ device-mapper/dmeventd/.exported_symbols	2007/01/15 18:21:01	1.7
@@ -1,17 +1,17 @@
 dm_event_handler_create
 dm_event_handler_destroy
 dm_event_handler_set_dso
-dm_event_handler_set_name
+dm_event_handler_set_devname
 dm_event_handler_set_uuid
 dm_event_handler_set_major
 dm_event_handler_set_minor
-dm_event_handler_set_events
+dm_event_handler_set_event_mask
 dm_event_handler_get_dso
-dm_event_handler_get_name
+dm_event_handler_get_devname
 dm_event_handler_get_uuid
 dm_event_handler_get_major
 dm_event_handler_get_minor
-dm_event_handler_get_events
-dm_event_register
-dm_event_unregister
+dm_event_handler_get_event_mask
+dm_event_register_handler
+dm_event_unregister_handler
 dm_event_get_registered_device
--- device-mapper/dmeventd/dmeventd.c	2007/01/11 21:54:52	1.28
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 18:21:01	1.29
@@ -96,7 +96,7 @@
 	 * DM_DEVICE_STATUS). It should not destroy it.
 	 * The caller must dispose of the task.
 	 */
-	void (*process_event)(struct dm_task *dmt, enum dm_event_type event);
+	void (*process_event)(struct dm_task *dmt, enum dm_event_mask event);
 
 	/*
 	 * Device registration.
@@ -127,7 +127,7 @@
 	char *device_uuid;	/* Mapped device path. */
 	union {
 		char *str;	/* Events string as fetched from message. */
-		enum dm_event_type field;	/* Events bitfield. */
+		enum dm_event_mask field;	/* Events bitfield. */
 	} events;
 	union {
 		char *str;
@@ -157,8 +157,8 @@
 	uint32_t event_nr;	/* event number */
 	int processing;		/* Set when event is being processed */
 	int status;		/* running/shutdown/done */
-	enum dm_event_type events;	/* bitfield for event filter. */
-	enum dm_event_type current_events;	/* bitfield for occured events. */
+	enum dm_event_mask events;	/* bitfield for event filter. */
+	enum dm_event_mask current_events;	/* bitfield for occured events. */
 	struct dm_task *current_task;
 	time_t next_time;
 	uint32_t timeout;
@@ -291,7 +291,7 @@
 	    fetch_string(&message_data->events.str, &p) &&
 	    fetch_string(&message_data->timeout.str, &p)) {
 		if (message_data->events.str) {
-			enum dm_event_type i = atoi(message_data->events.str);
+			enum dm_event_mask i = atoi(message_data->events.str);
 
 			/*
 			 * Free string representaion of events.
@@ -775,7 +775,7 @@
 		syslog(LOG_ERR, "dmeventd %s dlopen failed: %s", data->dso_name,
 		       dlerr);
 		data->msg->size =
-		    dm_saprintf(&(data->msg->data), "%s dlopen failed: %s",
+		    dm_asprintf(&(data->msg->data), "%s dlopen failed: %s",
 				data->dso_name, dlerr);
 		return NULL;
 	}
@@ -954,7 +954,7 @@
 	if (msg->data)
 		dm_free(msg->data);
 
-	msg->size = dm_saprintf(&(msg->data), fmt, dso, dev, events);
+	msg->size = dm_asprintf(&(msg->data), fmt, dso, dev, events);
 
 	unlock_mutex();
 
@@ -1049,7 +1049,7 @@
 	lock_mutex();
 	if ((thread = lookup_thread_status(message_data))) {
 		msg->size =
-		    dm_saprintf(&(msg->data), "%" PRIu32, thread->timeout);
+		    dm_asprintf(&(msg->data), "%" PRIu32, thread->timeout);
 	} else {
 		msg->data = NULL;
 		msg->size = 0;
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/12 20:22:11	1.12
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 18:21:01	1.13
@@ -32,108 +32,114 @@
 
 struct dm_event_handler {
 	const char *dso;
-	const char *device;
+
+	const char *devname;
+
 	const char *uuid;
 	int major;
 	int minor;
-	enum dm_event_type events;
+
+	enum dm_event_mask mask;
 };
 
-static void dm_event_handler_clear_device(struct dm_event_handler *h)
+static void dm_event_handler_clear_devname(struct dm_event_handler *dmevh)
 {
-	h->device = h->uuid = NULL;
-	h->major = h->minor = 0;
+	dmevh->devname = dmevh->uuid = NULL;
+	dmevh->major = dmevh->minor = 0;
 }
 
 struct dm_event_handler *dm_event_handler_create(void)
 {
-	struct dm_event_handler *ret = 0;
+	struct dm_event_handler *dmevh = NULL;
 
-	if (!(ret = dm_malloc(sizeof(*ret))))
+	if (!(dmevh = dm_malloc(sizeof(*dmevh))))
 		return NULL;
 
-	ret->dso = ret->device = ret->uuid = NULL;
-	ret->major = ret->minor = 0;
-	ret->events = 0;
+	dmevh->dso = dmevh->devname = dmevh->uuid = NULL;
+	dmevh->major = dmevh->minor = 0;
+	dmevh->mask = 0;
 
-	return ret;
+	return dmevh;
 }
 
-void dm_event_handler_destroy(struct dm_event_handler *h)
+void dm_event_handler_destroy(struct dm_event_handler *dmevh)
 {
-	dm_free(h);
+	dm_free(dmevh);
 }
 
-void dm_event_handler_set_dso(struct dm_event_handler *h, const char *path)
+void dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path)
 {
-	h->dso = path;
+	dmevh->dso = path;
 }
 
-void dm_event_handler_set_name(struct dm_event_handler *h, const char *name)
+void dm_event_handler_set_devname(struct dm_event_handler *dmevh, const char *devname)
 {
-	dm_event_handler_clear_device(h);
-	h->device = name;
+	dm_event_handler_clear_devname(dmevh);
+
+	dmevh->devname = devname;
 }
 
-void dm_event_handler_set_uuid(struct dm_event_handler *h, const char *uuid)
+void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid)
 {
-	dm_event_handler_clear_device(h);
-	h->uuid = uuid;
+	dm_event_handler_clear_devname(dmevh);
+
+	dmevh->uuid = uuid;
 }
 
-void dm_event_handler_set_major(struct dm_event_handler *h, int major)
+void dm_event_handler_set_major(struct dm_event_handler *dmevh, int major)
 {
-	int minor = h->minor;
+	int minor = dmevh->minor;
 
-	dm_event_handler_clear_device(h);
-	h->major = major;
-	h->minor = minor;
+	dm_event_handler_clear_devname(dmevh);
+
+	dmevh->major = major;
+	dmevh->minor = minor;
 }
 
-void dm_event_handler_set_minor(struct dm_event_handler *h, int minor)
+void dm_event_handler_set_minor(struct dm_event_handler *dmevh, int minor)
 {
-	int major = h->major;
+	int major = dmevh->major;
 
-	dm_event_handler_clear_device(h);
+	dm_event_handler_clear_devname(dmevh);
 
-	h->major = major;
-	h->minor = minor;
+	dmevh->major = major;
+	dmevh->minor = minor;
 }
 
-void dm_event_handler_set_events(struct dm_event_handler *h,
-				 enum dm_event_type event)
+void dm_event_handler_set_event_mask(struct dm_event_handler *dmevh,
+				     enum dm_event_mask evmask)
 {
-	h->events = event;
+	dmevh->mask = evmask;
 }
 
-const char *dm_event_handler_get_dso(const struct dm_event_handler *h)
+const char *dm_event_handler_get_dso(const struct dm_event_handler *dmevh)
 {
-	return h->dso;
+	return dmevh->dso;
 }
 
-const char *dm_event_handler_get_name(const struct dm_event_handler *h)
+const char *dm_event_handler_get_devname(const struct dm_event_handler *dmevh)
 {
-	return h->device;
+	return dmevh->devname;
 }
 
-const char *dm_event_handler_get_uuid(const struct dm_event_handler *h)
+const char *dm_event_handler_get_uuid(const struct dm_event_handler *dmevh)
 {
-	return h->uuid;
+	return dmevh->uuid;
 }
 
-int dm_event_handler_get_major(const struct dm_event_handler *h)
+int dm_event_handler_get_major(const struct dm_event_handler *dmevh)
 {
-	return h->major;
+	return dmevh->major;
 }
 
-int dm_event_handler_get_minor(const struct dm_event_handler *h)
+int dm_event_handler_get_minor(const struct dm_event_handler *dmevh)
 {
-	return h->minor;
+	return dmevh->minor;
 }
 
-enum dm_event_type dm_event_handler_get_events(const struct dm_event_handler *h)
+enum dm_event_mask dm_event_handler_get_event_mask(const struct dm_event_handler *dmevh)
 {
-	return h->events;
+	return dmevh->mask;
 }
 
 /*
@@ -145,8 +151,8 @@
  *
  * Returns: 0 on failure, 1 on success
  */
-static int daemon_read(struct dm_event_fifos *fifos,
-		       struct dm_event_daemon_message *msg)
+static int _daemon_read(struct dm_event_fifos *fifos,
+			struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
 	int ret, i;
@@ -205,8 +211,8 @@
 }
 
 /* Write message to daemon. */
-static int daemon_write(struct dm_event_fifos *fifos,
-			struct dm_event_daemon_message *msg)
+static int _daemon_write(struct dm_event_fifos *fifos,
+			 struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
 	int ret = 0;
@@ -248,13 +254,13 @@
 	return bytes == size;
 }
 
-static int daemon_talk(struct dm_event_fifos *fifos,
-		       struct dm_event_daemon_message *msg, int cmd,
-		       const char *dso_name, const char *device,
-		       enum dm_event_type events, uint32_t timeout)
+static int _daemon_talk(struct dm_event_fifos *fifos,
+			struct dm_event_daemon_message *msg, int cmd,
+			const char *dso_name, const char *devname,
+			enum dm_event_mask evmask, uint32_t timeout)
 {
 	const char *dso = dso_name ? dso_name : "";
-	const char *dev = device ? device : "";
+	const char *dev = devname ? devname : "";
 	const char *fmt = "%s %s %u %" PRIu32;
 	memset(msg, 0, sizeof(*msg));
 
@@ -263,18 +269,21 @@
 	 * into ASCII message string.
 	 */
 	msg->cmd = cmd;
-	msg->size = dm_saprintf(&(msg->data), fmt, dso, dev, events, timeout);
+	if ((msg->size = dm_asprintf(&(msg->data), fmt, dso, dev, evmask,
+				     timeout)) < 0) {
+		log_error("_daemon_talk: message allocation failed");
+	}
 
 	/*
 	 * Write command and message to and
 	 * read status return code from daemon.
 	 */
-	if (!daemon_write(fifos, msg)) {
+	if (!_daemon_write(fifos, msg)) {
 		stack;
 		return -EIO;
 	}
 
-	if (!daemon_read(fifos, msg)) {
+	if (!_daemon_read(fifos, msg)) {
 		stack;
 		return -EIO;
 	}
@@ -294,7 +303,7 @@
  *
  * Returns: 1 on success, 0 otherwise
  */
-static int start_daemon(struct dm_event_fifos *fifos)
+static int _start_daemon(struct dm_event_fifos *fifos)
 {
 	int pid, ret = 0;
 	int status;
@@ -349,7 +358,7 @@
 }
 
 /* Initialize client. */
-static int init_client(struct dm_event_fifos *fifos)
+static int _init_client(struct dm_event_fifos *fifos)
 {
 	/* FIXME? Is fifo the most suitable method? Why not share
 	   comms/daemon code with something else e.g. multipath? */
@@ -359,7 +368,7 @@
 	fifos->client_path = DM_EVENT_FIFO_CLIENT;
 	fifos->server_path = DM_EVENT_FIFO_SERVER;
 
-	if (!start_daemon(fifos)) {
+	if (!_start_daemon(fifos)) {
 		stack;
 		return 0;
 	}
@@ -391,7 +400,7 @@
 	return 1;
 }
 
-static void dtr_client(struct dm_event_fifos *fifos)
+static void _dtr_client(struct dm_event_fifos *fifos)
 {
 	if (flock(fifos->server, LOCK_UN))
 		log_error("flock unlock %s", fifos->server_path);
@@ -400,76 +409,91 @@
 	close(fifos->server);
 }
 
-/* Get uuid of a device, if it exists (otherwise NULL). */
-static struct dm_task *get_device_info(const struct dm_event_handler *h)
+/* Get uuid of a device */
+static struct dm_task *_get_device_info(const struct dm_event_handler *dmevh)
 {
-	struct dm_task *dmt = dm_task_create(DM_DEVICE_INFO);
-	struct dm_task *ret;
+	struct dm_task *dmt;
+	struct dm_info info;
 
-	if (!dmt)
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO))) {
+		log_error("_get_device_info: dm_task creation for info failed");
 		return NULL;
+	}
 
-	if (h->uuid)
-		dm_task_set_uuid(dmt, h->uuid);
-	else if (h->device)
-		dm_task_set_name(dmt, h->device);
-	else if (h->major && h->minor) {
-		dm_task_set_major(dmt, h->major);
-		dm_task_set_minor(dmt, h->minor);
+	if (dmevh->uuid)
+		dm_task_set_uuid(dmt, dmevh->uuid);
+	else if (dmevh->devname)
+		dm_task_set_name(dmt, dmevh->devname);
+	else if (dmevh->major && dmevh->minor) {
+		dm_task_set_major(dmt, dmevh->major);
+		dm_task_set_minor(dmt, dmevh->minor);
+
+	/* FIXME Add name or uuid or devno to messages */
+	if (!dm_task_run(dmt)) {
+		log_error("_get_device_info: dm_task_run() failed");
+		goto failed;
 	}
 
-	if (!dm_task_run(dmt))
-		ret = NULL;
-	else
-		ret = dmt;
+	if (!dm_task_get_info(dmt, &info))
+		log_error("_get_device_info: failed to get info for device");
+		goto failed;
+	}
 
-	return ret;
+	if (!info.exists) {
+		log_error("_get_device_info: device not found");
+		goto failed;
+	}
+
+	return dmt;
+
+failed:
+	dm_task_destroy(dmt);
+	return NULL;
 }
 
 /* Handle the event (de)registration call and return negative error codes. */
-static int do_event(int cmd, struct dm_event_daemon_message *msg,
-		    const char *dso_name, const char *device,
-		    enum dm_event_type events, uint32_t timeout)
+static int _do_event(int cmd, struct dm_event_daemon_message *msg,
+		    const char *dso_name, const char *devname,
+		    enum dm_event_mask evmask, uint32_t timeout)
 {
 	int ret;
 	struct dm_event_fifos fifos;
 
-	if (!init_client(&fifos)) {
+	if (!_init_client(&fifos)) {
 		stack;
 		return -ESRCH;
 	}
 
-	ret = daemon_talk(&fifos, msg, cmd, dso_name, device, events, timeout);
+	ret = _daemon_talk(&fifos, msg, cmd, dso_name, devname, evmask, timeout);
 
 	/* what is the opposite of init? */
-	dtr_client(&fifos);
+	_dtr_client(&fifos);
 
 	return ret;
 }
 
 /* External library interface. */
-int dm_event_register(const struct dm_event_handler *h)
+int dm_event_register_handler(const struct dm_event_handler *dmevh)
 {
-	int ret, err;
+	int ret = 1, err;
 	const char *uuid;
 	struct dm_task *dmt;
 	struct dm_event_daemon_message msg;
 
-	if (!(dmt = get_device_info(h))) {
-		log_error("%s: device not found", h->device);
+	if (!(dmt = _get_device_info(dmevh))) {
+		stack;
 		return 0;
 	}
 
 	uuid = dm_task_get_uuid(dmt);
 
-	if ((err = do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
-			    h->dso, uuid, h->events, 0)) < 0) {
+	if ((err = _do_event(DM_EVENT_CMD_REGISTER_FOR_EVENT, &msg,
+			     dmevh->dso, uuid, dmevh->mask, 0)) < 0) {
 		log_error("%s: event registration failed: %s",
 			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
 		ret = 0;
-	} else
-		ret = 1;
+	}
 
 	if (msg.data)
 		dm_free(msg.data);
@@ -479,28 +503,27 @@
 	return ret;
 }
 
-int dm_event_unregister(const struct dm_event_handler *h)
+int dm_event_unregister_handler(const struct dm_event_handler *dmevh)
 {
-	int ret, err;
+	int ret = 1, err;
 	const char *uuid;
 	struct dm_task *dmt;
 	struct dm_event_daemon_message msg;
 
-	if (!(dmt = get_device_info(h))) {
-		log_error("%s: device not found", dm_task_get_name(dmt));
+	if (!(dmt = _get_device_info(dmevh))) {
+		stack;
 		return 0;
 	}
 
 	uuid = dm_task_get_uuid(dmt);
 
-	if ((err = do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
-			    h->dso, uuid, h->events, 0)) < 0) {
+	if ((err = _do_event(DM_EVENT_CMD_UNREGISTER_FOR_EVENT, &msg,
+			    dmevh->dso, uuid, dmevh->mask, 0)) < 0) {
 		log_error("%s: event deregistration failed: %s",
 			  dm_task_get_name(dmt),
 			  msg.data ? msg.data : strerror(-err));
 		ret = 0;
-	} else
-		ret = 1;
+	}
 
 	if (msg.data)
 		dm_free(msg.data);
@@ -511,9 +534,8 @@
 }
 
 /* Fetch a string off src and duplicate it into *dest. */
-/* FIXME: move to seperate module to share with the daemon. */
-static const char delimiter = ' ';
-static char *fetch_string(char **src)
+/* FIXME: move to separate module to share with the daemon. */
+static char *_fetch_string(char **src, const char delimiter)
 {
 	char *p, *ret;
 
@@ -530,13 +552,14 @@
 }
 
 /* Parse a device message from the daemon. */
-static int parse_message(struct dm_event_daemon_message *msg, char **dso_name,
-			 char **device, enum dm_event_type *events)
+static int _parse_message(struct dm_event_daemon_message *msg, char **dso_name,
+			 char **devname, enum dm_event_mask *evmask)
 {
 	char *p = msg->data;
 
-	if ((*dso_name = fetch_string(&p)) && (*device = fetch_string(&p))) {
-		*events = atoi(p);
+	if ((*dso_name = _fetch_string(&p, ' ')) &&
+	    (*devname = _fetch_string(&p, ' '))) {
+		*evmask = atoi(p);
 
 		return 0;
 	}
@@ -548,7 +571,7 @@
  * dm_event_get_registered_device
  * @dso_name
  * @device_path
- * @events
+ * @mask
  * @next
  *
  * FIXME: This function sucks.
@@ -556,17 +579,17 @@
  * Returns: 1 if device found, 0 otherwise (even on error)
  */
 int dm_event_get_registered_device(char **dso_name, char **device_path,
-				   enum dm_event_type *events, int next)
+				   enum dm_event_mask *mask, int next)
 {
 	int ret;
 	char *dso_name_arg = NULL, *device_path_arg = NULL;
 	struct dm_event_daemon_message msg;
 
-	if (!(ret = do_event(next ? DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE :
+	if (!(ret = _do_event(next ? DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE :
 			     DM_EVENT_CMD_GET_REGISTERED_DEVICE,
-			     &msg, *dso_name, *device_path, *events, 0))) {
-		ret = !parse_message(&msg, &dso_name_arg, &device_path_arg,
-				     events);
+			     &msg, *dso_name, *device_path, *mask, 0))) {
+		ret = !_parse_message(&msg, &dso_name_arg, &device_path_arg,
+				     mask);
 	} else			/* FIXME: Make sure this is ENOENT */
 		ret = 0;
 
@@ -598,7 +621,7 @@
 
 	if (!device_exists(device_path))
 		return -ENODEV;
-	return do_event(DM_EVENT_CMD_SET_TIMEOUT, &msg,
+	return _do_event(DM_EVENT_CMD_SET_TIMEOUT, &msg,
 			NULL, device_path, 0, timeout);
 }
 
@@ -609,7 +632,7 @@
 
 	if (!device_exists(device_path))
 		return -ENODEV;
-	if (!(ret = do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path,
+	if (!(ret = _do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path,
 			     0, 0)))
 		*timeout = atoi(msg.data);
 	if (msg.data)
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/12 20:22:11	1.6
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/15 18:21:01	1.7
@@ -23,8 +23,11 @@
 
 #include <stdint.h>
 
-/* Event type definitions. */
-enum dm_event_type {
+/*
+ * Event library interface.
+ */
+
+enum dm_event_mask {
 	DM_EVENT_SETTINGS_MASK  = 0x0000FF,
 	DM_EVENT_SINGLE		= 0x000001, /* Report multiple errors just once. */
 	DM_EVENT_MULTI		= 0x000002, /* Report all of them. */
@@ -33,7 +36,7 @@
 	DM_EVENT_SECTOR_ERROR	= 0x000100, /* Failure on a particular sector. */
 	DM_EVENT_DEVICE_ERROR	= 0x000200, /* Device failure. */
 	DM_EVENT_PATH_ERROR	= 0x000400, /* Failure on an io path. */
-	DM_EVENT_ADAPTOR_ERROR	= 0x000800, /* Failure off a host adaptor. */
+	DM_EVENT_ADAPTOR_ERROR	= 0x000800, /* Failure of a host adaptor. */
 
 	DM_EVENT_STATUS_MASK    = 0xFF0000,
 	DM_EVENT_SYNC_STATUS	= 0x010000, /* Mirror synchronization completed/failed. */
@@ -44,54 +47,55 @@
 
 #define DM_EVENT_ALL_ERRORS DM_EVENT_ERROR_MASK
 
-/* Prototypes for event lib interface. */
-
 struct dm_event_handler;
 
-/* Create and destroy dm_event_handler struct, which is passed to
-   register/unregister functions below */
 struct dm_event_handler *dm_event_handler_create(void);
-void dm_event_handler_destroy(struct dm_event_handler *h);
+void dm_event_handler_destroy(struct dm_event_handler *dmevh);
 
-/* Set parameters of a handler:
-   - dso - shared library path to handle the events
-   (only one of the following three needs to be set)
-   - name - device name or path
-   - uuid - device uuid
-   - major and minor - device major/minor numbers
-   - events - a bitfield defining which events to handle (see
-              enum dm_event_type above)
-*/
-void dm_event_handler_set_dso(struct dm_event_handler *h, const char *path);
-void dm_event_handler_set_name(struct dm_event_handler *h, const char *name);
-void dm_event_handler_set_uuid(struct dm_event_handler *h, const char *uuid);
-void dm_event_handler_set_major(struct dm_event_handler *h, int major);
-void dm_event_handler_set_minor(struct dm_event_handler *h, int minor);
-void dm_event_handler_set_events(struct dm_event_handler *h,
-				 enum dm_event_type event);
-
-/* Get parameters of a handler, same as above */
-const char *dm_event_handler_get_dso(const struct dm_event_handler *h);
-const char *dm_event_handler_get_name(const struct dm_event_handler *h);
-const char *dm_event_handler_get_uuid(const struct dm_event_handler *h);
-int dm_event_handler_get_major(const struct dm_event_handler *h);
-int dm_event_handler_get_minor(const struct dm_event_handler *h);
-enum dm_event_type dm_event_handler_get_events(const struct dm_event_handler *h);
+/*
+ * Path of shared library to handle events.
+ */
+void dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path);
+
+/*
+ * Identify the device to monitor by exactly one of
+ * devname, uuid or device number.
+ */
+void dm_event_handler_set_devname(struct dm_event_handler *dmevh, const char *devname);
+
+void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid);
+
+void dm_event_handler_set_major(struct dm_event_handler *dmevh, int major);
+void dm_event_handler_set_minor(struct dm_event_handler *dmevh, int minor);
+
+/*
+ * Specify mask for events to monitor.
+ */
+void dm_event_handler_set_event_mask(struct dm_event_handler *dmevh,
+				     enum dm_event_mask evmask);
+
+const char *dm_event_handler_get_dso(const struct dm_event_handler *dmevh);
+const char *dm_event_handler_get_devname(const struct dm_event_handler *dmevh);
+const char *dm_event_handler_get_uuid(const struct dm_event_handler *dmevh);
+int dm_event_handler_get_major(const struct dm_event_handler *dmevh);
+int dm_event_handler_get_minor(const struct dm_event_handler *dmevh);
+enum dm_event_mask dm_event_handler_get_event_mask(const struct dm_event_handler *dmevh);
 
-/* FIXME */
+/* FIXME Review interface */
 int dm_event_get_registered_device(char **dso_name, char **device_path,
-				   enum dm_event_type *events, int next);
+				   enum dm_event_mask *evmask, int next);
 
-/* Call out to dmeventd to register or unregister a handler. If
-   dmeventd is not running, it is spawned first. */
-int dm_event_register(const struct dm_event_handler *h);
-int dm_event_unregister(const struct dm_event_handler *h);
+/*
+ * Initiate monitoring using dmeventd.
+ */
+int dm_event_register_handler(const struct dm_event_handler *dmevh);
+int dm_event_unregister_handler(const struct dm_event_handler *dmevh);
 
 /* Prototypes for DSO interface, see dmeventd.c, struct dso_data for
    detailed descriptions. */
-void process_event(struct dm_task *dmt, enum dm_event_type event);
-int register_device(const char *device, const char *uuid, int major, int minor);
-int unregister_device(const char *device, const char *uuid, int major,
+void process_event(struct dm_task *dmt, enum dm_event_mask evmask);
+int register_device(const char *devname, const char *uuid, int major, int minor);
+int unregister_device(const char *devname, const char *uuid, int major,
 		      int minor);
 
 #endif
--- device-mapper/lib/.exported_symbols	2007/01/11 21:54:53	1.26
+++ device-mapper/lib/.exported_symbols	2007/01/15 18:21:01	1.27
@@ -115,4 +115,4 @@
 dm_split_words
 dm_snprintf
 dm_basename
-dm_saprintf
+dm_asprintf
--- device-mapper/lib/libdevmapper.h	2007/01/11 21:54:53	1.62
+++ device-mapper/lib/libdevmapper.h	2007/01/15 18:21:01	1.63
@@ -626,7 +626,8 @@
 /*
  * Returns size of a buffer which is allocated with dm_malloc.
  * Pointer to the buffer is stored in *buf.
+ * Returns -1 on failure leaving buf undefined.
  */
-int dm_saprintf(char **buf, const char *format, ...);
+int dm_asprintf(char **buf, const char *format, ...);
 
 #endif				/* LIB_DEVICE_MAPPER_H */
--- device-mapper/lib/libdm-string.c	2007/01/11 21:54:53	1.5
+++ device-mapper/lib/libdm-string.c	2007/01/15 18:21:01	1.6
@@ -129,7 +129,7 @@
 	return p ? p + 1 : (char *) path;
 }
 
-int dm_saprintf(char **result, const char *format, ...)
+int dm_asprintf(char **result, const char *format, ...)
 {
 	int n, ok = 0, size = 32;
 	va_list ap;
