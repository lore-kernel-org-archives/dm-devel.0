From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 2 Feb 2007 17:08:52 -0000
Message-ID: <20070202170852.22514.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-02-02 17:08:51

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c dmeventd.h libdevmapper-event.c 

Log message:
	Improve dmeventd messaging protocol: drain pipe and tag messages.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.168&r2=1.169
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.45&r2=1.46
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.20&r2=1.21

--- device-mapper/WHATS_NEW	2007/01/29 20:25:19	1.168
+++ device-mapper/WHATS_NEW	2007/02/02 17:08:51	1.169
@@ -1,5 +1,6 @@
 Version 1.02.18 -
 ===================================
+  Improve dmeventd messaging protocol: drain pipe and tag messages.
 
 Version 1.02.17 - 29th January 2007
 ===================================
--- device-mapper/dmeventd/dmeventd.c	2007/01/25 14:16:20	1.45
+++ device-mapper/dmeventd/dmeventd.c	2007/02/02 17:08:51	1.46
@@ -146,6 +146,7 @@
 
 /* Structure to keep parsed register variables from client message. */
 struct message_data {
+	char *id;
 	char *dso_name;		/* Name of DSO. */
 	char *device_uuid;	/* Mapped device path. */
 	union {
@@ -320,6 +321,8 @@
 /* Free message memory. */
 static void _free_message(struct message_data *message_data)
 {
+	if (message_data->id)
+		dm_free(message_data->id);
 	if (message_data->dso_name)
 		dm_free(message_data->dso_name);
 
@@ -342,7 +345,8 @@
 	 * Retrieve application identifier, mapped device
 	 * path and events # string from message.
 	 */
-	if (_fetch_string(&message_data->dso_name, &p, ' ') &&
+	if (_fetch_string(&message_data->id, &p, ' ') &&
+	    _fetch_string(&message_data->dso_name, &p, ' ') &&
 	    _fetch_string(&message_data->device_uuid, &p, ' ') &&
 	    _fetch_string(&message_data->events.str, &p, ' ') &&
 	    _fetch_string(&message_data->timeout.str, &p, ' ')) {
@@ -875,8 +879,8 @@
 		syslog(LOG_ERR, "dmeventd %s dlopen failed: %s", data->dso_name,
 		       dlerr);
 		data->msg->size =
-		    dm_asprintf(&(data->msg->data), "%s dlopen failed: %s",
-				data->dso_name, dlerr);
+		    dm_asprintf(&(data->msg->data), "%s %s dlopen failed: %s",
+				data->id, data->dso_name, dlerr);
 		return NULL;
 	}
 
@@ -1056,7 +1060,8 @@
 {
 	struct dm_event_daemon_message *msg = message_data->msg;
 
-	const char *fmt = "%s %s %u";
+	const char *fmt = "%s %s %s %u";
+	const char *id = message_data->id;
 	const char *dso = thread->dso_data->dso_name;
 	const char *dev = thread->device.uuid;
 	unsigned events = ((thread->status == DM_THREAD_RUNNING)
@@ -1066,7 +1071,7 @@
 	if (msg->data)
 		dm_free(msg->data);
 
-	msg->size = dm_asprintf(&(msg->data), fmt, dso, dev, events);
+	msg->size = dm_asprintf(&(msg->data), fmt, id, dso, dev, events);
 
 	_unlock_mutex();
 
@@ -1180,7 +1185,8 @@
 	_lock_mutex();
 	if ((thread = _lookup_thread_status(message_data))) {
 		msg->size =
-		    dm_asprintf(&(msg->data), "%" PRIu32, thread->timeout);
+		    dm_asprintf(&(msg->data), "%s %" PRIu32, message_data->id,
+				thread->timeout);
 	} else {
 		msg->data = NULL;
 		msg->size = 0;
@@ -1375,17 +1381,32 @@
 static int _do_process_request(struct dm_event_daemon_message *msg)
 {
 	int ret;
+	char *answer;
 	static struct message_data message_data;
 
 	/* Parse the message. */
 	memset(&message_data, 0, sizeof(message_data));
 	message_data.msg = msg;
-	if (msg->cmd != DM_EVENT_CMD_ACTIVE && !_parse_message(&message_data)) {
+	if (msg->cmd == DM_EVENT_CMD_HELLO)  {
+		ret = 0;
+		answer = dm_strdup(msg->data);
+		if (answer) {
+			msg->size = dm_asprintf(&(msg->data), "%s HELLO", answer);
+			dm_free(answer);
+		} else {
+			msg->size = 0;
+			msg->data = NULL;
+		}
+	} else if (msg->cmd != DM_EVENT_CMD_ACTIVE && !_parse_message(&message_data)) {
 		stack;
 		ret = -EINVAL;
 	} else
 		ret = _handle_request(msg, &message_data);
 
+	msg->cmd = ret;
+	if (!msg->data)
+		msg->size = dm_asprintf(&(msg->data), "%s %s", message_data.id, strerror(-ret));
+
 	_free_message(&message_data);
 
 	return ret;
@@ -1405,16 +1426,9 @@
 	if (!_client_read(fifos, &msg))
 		return;
 
-	msg.cmd = _do_process_request(&msg);
-	if (!msg.data) {
-		msg.data = dm_strdup(strerror(-msg.cmd));
-		if (msg.data)
-			msg.size = strlen(msg.data) + 1;
-		else {
-			msg.size = 0;
-			stack;
-		}
-	}
+	/* _do_process_request fills in msg (if memory allows for
+	   data, otherwise just cmd and size = 0) */
+	_do_process_request(&msg);
 
 	if (!_client_write(fifos, &msg))
 		stack;
--- device-mapper/dmeventd/dmeventd.h	2007/01/08 15:18:52	1.3
+++ device-mapper/dmeventd/dmeventd.h	2007/02/02 17:08:51	1.4
@@ -20,6 +20,7 @@
 	DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE,
 	DM_EVENT_CMD_SET_TIMEOUT,
 	DM_EVENT_CMD_GET_TIMEOUT,
+	DM_EVENT_CMD_HELLO,
 };
 
 /* Message passed between client and daemon. */
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/22 15:03:57	1.20
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/02/02 17:08:51	1.21
@@ -30,6 +30,8 @@
 #include <sys/wait.h>
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
+static int _sequence_nr = 0;
+
 struct dm_event_handler {
 	char *dso;
 
@@ -182,6 +184,21 @@
 	return dmevh->mask;
 }
 
+static int _check_message_id(struct dm_event_daemon_message *msg)
+{
+	int pid, seq_nr;
+
+	if ((sscanf(msg->data, "%d:%d", &pid, &seq_nr) != 2) ||
+	    (pid != getpid()) || (seq_nr != _sequence_nr)) {
+		log_error("Ignoring out-of-sequence reply from dmeventd. "
+			  "Expected %d:%d but received %s", getpid(),
+			  _sequence_nr, msg->data);
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * daemon_read
  * @fifos
@@ -260,11 +277,28 @@
 
 	size_t size = 2 * sizeof(uint32_t) + msg->size;
 	char *buf = alloca(size);
+	char drainbuf[128];
+	struct timeval tval = { 0, 0 };
 
 	*((uint32_t *)buf) = htonl(msg->cmd);
 	*((uint32_t *)buf + 1) = htonl(msg->size);
 	memcpy(buf + 2 * sizeof(uint32_t), msg->data, msg->size);
 
+	/* drain the answer fifo */
+	while (1) {
+		FD_ZERO(&fds);
+		FD_SET(fifos->server, &fds);
+		tval.tv_usec = 100;
+		ret = select(fifos->server + 1, &fds, NULL, NULL, &tval);
+		if ((ret < 0) && (errno != EINTR)) {
+			log_error("Unable to talk to event daemon");
+			return 0;
+		}
+		if (ret == 0)
+			break;
+		read(fifos->server, drainbuf, 127);
+	}
+
 	while (bytes < size) {
 		do {
 			/* Watch daemon write FIFO to be ready for output. */
@@ -301,7 +335,7 @@
 {
 	const char *dso = dso_name ? dso_name : "";
 	const char *dev = dev_name ? dev_name : "";
-	const char *fmt = "%s %s %u %" PRIu32;
+	const char *fmt = "%d:%d %s %s %u %" PRIu32;
 	int msg_size;
 	memset(msg, 0, sizeof(*msg));
 
@@ -310,8 +344,10 @@
 	 * into ASCII message string.
 	 */
 	msg->cmd = cmd;
-	if ((msg_size = dm_asprintf(&(msg->data), fmt, dso, dev, evmask,
-				     timeout)) < 0) {
+	if (cmd == DM_EVENT_CMD_HELLO)
+		fmt = "%d:%d HELLO";
+	if ((msg_size = dm_asprintf(&(msg->data), fmt, getpid(), _sequence_nr,
+				    dso, dev, evmask, timeout)) < 0) {
 		log_error("_daemon_talk: message allocation failed");
 		return -ENOMEM;
 	}
@@ -326,10 +362,14 @@
 		return -EIO;
 	}
 
-	if (!_daemon_read(fifos, msg)) {
-		stack;
-		return -EIO;
-	}
+	do {
+		if (!_daemon_read(fifos, msg)) {
+			stack;
+			return -EIO;
+		}
+	} while (!_check_message_id(msg));
+
+	_sequence_nr++;
 
 	return (int32_t) msg->cmd;
 }
@@ -507,7 +547,9 @@
 		return -ESRCH;
 	}
 
-	ret = _daemon_talk(&fifos, msg, cmd, dso_name, dev_name, evmask, timeout);
+	ret = _daemon_talk(&fifos, msg, DM_EVENT_CMD_HELLO, 0, 0, 0, 0);
+	if (!ret)
+		ret = _daemon_talk(&fifos, msg, cmd, dso_name, dev_name, evmask, timeout);
 
 	/* what is the opposite of init? */
 	_dtr_client(&fifos);
@@ -521,7 +563,7 @@
 	int ret = 1, err;
 	const char *uuid;
 	struct dm_task *dmt;
-	struct dm_event_daemon_message msg;
+	struct dm_event_daemon_message msg = { 0, 0, NULL };
 
 	if (!(dmt = _get_device_info(dmevh))) {
 		stack;
@@ -551,7 +593,7 @@
 	int ret = 1, err;
 	const char *uuid;
 	struct dm_task *dmt;
-	struct dm_event_daemon_message msg;
+	struct dm_event_daemon_message msg = { 0, 0, NULL };
 
 	if (!(dmt = _get_device_info(dmevh))) {
 		stack;
@@ -598,15 +640,20 @@
 static int _parse_message(struct dm_event_daemon_message *msg, char **dso_name,
 			 char **uuid, enum dm_event_mask *evmask)
 {
+	char *id = NULL;
 	char *p = msg->data;
 
-	if ((*dso_name = _fetch_string(&p, ' ')) &&
+	if ((id = _fetch_string(&p, ' ')) &&
+	    (*dso_name = _fetch_string(&p, ' ')) &&
 	    (*uuid = _fetch_string(&p, ' '))) {
 		*evmask = atoi(p);
 
+		dm_free(id);
 		return 0;
 	}
 
+	if (id)
+		dm_free(id);
 	return -ENOMEM;
 }
 
@@ -621,12 +668,12 @@
  */
 int dm_event_get_registered_device(struct dm_event_handler *dmevh, int next)
 {
-	int ret;
+	int ret = 0;
 	const char *uuid = NULL;
 	char *reply_dso = NULL, *reply_uuid = NULL;
-	enum dm_event_mask reply_mask;
-	struct dm_task *dmt;
-	struct dm_event_daemon_message msg;
+	enum dm_event_mask reply_mask = 0;
+	struct dm_task *dmt = NULL;
+	struct dm_event_daemon_message msg = { 0, 0, NULL };
 
 	if (!(dmt = _get_device_info(dmevh))) {
 		stack;
@@ -696,9 +743,17 @@
 
 #if 0				/* left out for now */
 
+static char *_skip_string(char *src, const int delimiter)
+{
+	src = srtchr(src, delimiter);
+	if (src && *(src + 1))
+		return src + 1;
+	return NULL;
+}
+
 int dm_event_set_timeout(const char *device_path, uint32_t timeout)
 {
-	struct dm_event_daemon_message msg;
+	struct dm_event_daemon_message msg = { 0, 0, NULL };
 
 	if (!device_exists(device_path))
 		return -ENODEV;
@@ -710,13 +765,20 @@
 int dm_event_get_timeout(const char *device_path, uint32_t *timeout)
 {
 	int ret;
-	struct dm_event_daemon_message msg;
+	struct dm_event_daemon_message msg = { 0, 0, NULL };
 
 	if (!device_exists(device_path))
 		return -ENODEV;
 	if (!(ret = _do_event(DM_EVENT_CMD_GET_TIMEOUT, &msg, NULL, device_path,
-			     0, 0)))
-		*timeout = atoi(msg.data);
+			     0, 0))) {
+		char *p = _skip_string(msg.data, ' ');
+		if (!p) {
+			log_error("malformed reply from dmeventd '%s'\n",
+				  msg.data);
+			return -EIO;
+		}
+		*timeout = atoi(p);
+	}
 	if (msg.data)
 		dm_free(msg.data);
 	return ret;
