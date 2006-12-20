From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c
Date: 20 Dec 2006 14:35:02 -0000
Message-ID: <20061220143502.13431.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-12-20 14:35:02

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 

Log message:
	Fix dmeventd mirror to cope if monitored device disappears.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.137&r2=1.138
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.24&r2=1.25

--- device-mapper/WHATS_NEW	2006/11/28 22:51:01	1.137
+++ device-mapper/WHATS_NEW	2006/12/20 14:35:02	1.138
@@ -1,5 +1,7 @@
 Version 1.02.14 - 
 =============================
+  Some dmevent cleanups.
+  Fix dmeventd to cope if monitored device disappears.
 
 Version 1.02.13 - 28 Nov 2006
 =============================
--- device-mapper/dmeventd/dmeventd.c	2006/05/11 19:08:02	1.24
+++ device-mapper/dmeventd/dmeventd.c	2006/12/20 14:35:02	1.25
@@ -129,8 +129,8 @@
 	struct dso_data *dso_data;/* DSO this thread accesses. */
 	
 	char *device_path;	/* Mapped device path. */
-	uint32_t event_nr;           /* event number */
-	int processing;         /* Set when event is being processed */
+	uint32_t event_nr;	/* event number */
+	int processing;		/* Set when event is being processed */
 	enum dm_event_type events;	/* bitfield for event filter. */
 	enum dm_event_type current_events;/* bitfield for occured events. */
 	enum dm_event_type processed_events;/* bitfield for processed events. */
@@ -179,12 +179,13 @@
 {
 	struct dso_data *ret = (typeof(ret)) dm_malloc(sizeof(*ret));
 
-	if (ret) {
-		if (!memset(ret, 0, sizeof(*ret)) ||
-		    !(ret->dso_name = dm_strdup(data->dso_name))) {
-			dm_free(ret);
-			ret = NULL;
-		}
+	if (!ret)
+		return NULL;
+
+	if (!memset(ret, 0, sizeof(*ret)) ||
+	    !(ret->dso_name = dm_strdup(data->dso_name))) {
+		dm_free(ret);
+		return NULL;
 	}
 
 	return ret;
@@ -342,10 +343,9 @@
 {
 	struct thread_status *thread;
 
-	list_iterate_items(thread, &thread_registry) {
+	list_iterate_items(thread, &thread_registry)
 		if (!strcmp(data->device_path, thread->device_path))
 			return thread;
-	}
 
 	return NULL;
 }
@@ -546,6 +546,15 @@
 		thread->current_events |= DM_EVENT_TIMEOUT;
 		ret = 1;
 		thread->processed_events = 0;
+	} else {
+		/* FIXME replace with log_* macro */
+		syslog(LOG_NOTICE, "dm_task_run failed, errno = %d, %s",
+		       errno, strerror(errno));
+		if (errno == ENXIO) {
+			/* FIXME replace with log_* macro */
+			syslog(LOG_ERR, "%s disappeared, detaching", thread->device_path);
+			ret = 2;	/* FIXME What does 2 mean?  Use macro. */
+		}
 	}
 
 	pthread_sigmask(SIG_SETMASK, &set, NULL);
@@ -592,6 +601,7 @@
 static void *monitor_thread(void *arg)
 {
 	struct thread_status *thread = arg;
+	int wait_error = 0;
 
 	pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
 	pthread_cleanup_push(monitor_unregister, thread);
@@ -605,13 +615,18 @@
 		thread->current_events = 0;
 
 		/*
-		 * FIXME: if unrecoverable error (ENODEV) happens,
+		 * FIXME If unrecoverable error (ENODEV) happens
 		 * we loop indefinitely.  event_wait should return
 		 * more than 0/1.
 		 */
-		if (!event_wait(thread))
+		wait_error = event_wait(thread);
+		if (!wait_error)
 			continue;
 
+		/* FIXME Give a DSO a chance to clean up. */
+		if (wait_error == 2)
+			break;
+
 		/*
 		 * Check against filter.
 		 *
@@ -680,13 +695,12 @@
 
 	lock_mutex();
 
-	list_iterate_items(dso_data, &dso_registry) {
+	list_iterate_items(dso_data, &dso_registry)
 		if (!strcmp(data->dso_name, dso_data->dso_name)) {
 			lib_get(dso_data);
 			ret = dso_data;
 			break;
 		}
-	}
 
 	unlock_mutex();
 
@@ -935,31 +949,29 @@
 	lock_mutex();
 
 	/* Iterate list of threads checking if we want a particular one. */
-	list_iterate_items(thread, &thread_registry) {
+	list_iterate_items(thread, &thread_registry)
 		if ((hit = want_registered_device(message_data->dso_name,
 						  message_data->device_path,
 						  thread)))
 			break;
-	}
 
 	/*
 	 * If we got a registered device and want the next one ->
 	 * fetch next conforming element off the list.
 	 */
-	if (hit) {
-		if (next) {
-			do {
-				if (list_end(&thread_registry, &thread->list))
-					goto out;
-				
-				thread = list_item(thread->list.n,
-						   struct thread_status);
-			} while (!want_registered_device(message_data->dso_name,
-							 NULL, thread));
-		}
+	if (!hit || !next)
+		goto out;
 
-		return registered_device(message_data, thread);
-	}
+	do {
+		if (list_end(&thread_registry, &thread->list))
+			goto out;
+		
+		thread = list_item(thread->list.n,
+				   struct thread_status);
+	} while (!want_registered_device(message_data->dso_name,
+					 NULL, thread));
+
+	return registered_device(message_data, thread);
 
    out:
 	unlock_mutex();
@@ -1118,10 +1130,9 @@
 		{ DM_EVENT_CMD_ACTIVE,                     active },
 	}, *req;
 
-	for (req = requests; req < requests + sizeof(requests); req++) {
+	for (req = requests; req < requests + sizeof(requests); req++)
 		if (req->cmd == msg->opcode.cmd)
 			return req->f(message_data);
-	}
 
 	return -EINVAL;
 }
@@ -1139,9 +1150,8 @@
 	    !parse_message(&message_data)) {
 		stack;
 		ret = -EINVAL;
-	} else {
+	} else
 		ret = handle_request(msg, &message_data);
-	}
 
 	free_message(&message_data);
 
@@ -1242,7 +1252,7 @@
 static int lock_pidfile(void)
 {
 	int lf;
-	char pidfile[] = "/var/run/dmeventd.pid";
+	char pidfile[] = "/var/run/dmeventd.pid"; /* FIXME Must be configurable at compile-time! */
 
 	if ((lf = open(pidfile, O_CREAT | O_RDWR, 0644)) < 0)
 		return -EXIT_OPEN_PID_FAILURE;
@@ -1326,14 +1336,3 @@
 
 	exit(EXIT_SUCCESS);
 }
-
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
