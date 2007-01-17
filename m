From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c libdevmapper ...
Date: 17 Jan 2007 14:45:13 -0000
Message-ID: <20070117144513.10782.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-17 14:45:11

Modified files:
	dmeventd       : dmeventd.c libdevmapper-event.c 
	                 libdevmapper-event.h 

Log message:
	stat oom_adj and stay silent if it doesn't exist
	dm_event_handler now keeps private copies of strings

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.39&r2=1.40
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.9&r2=1.10

--- device-mapper/dmeventd/dmeventd.c	2007/01/16 23:03:13	1.39
+++ device-mapper/dmeventd/dmeventd.c	2007/01/17 14:45:10	1.40
@@ -1469,15 +1469,20 @@
 {
 	FILE *fp;
 
+	struct stat st;
+
+	if (stat("/proc/self/oom_adj", &st) == -1)
+		return -errno;
+
 	fp = fopen("/proc/self/oom_adj", "w");
 
 	if (!fp)
-		return 0;
+		return -1;
 
 	fprintf(fp, "%i", val);
 	fclose(fp);
 
-	return 1;
+	return 0;
 }
 
 static void _daemonize(void)
@@ -1568,7 +1573,10 @@
 
 	_daemonize();
 
-	if (!_set_oom_adj(-16))
+	/*
+	 * ENOENT means the kernel does not support oom_adj
+	 */
+	if (_set_oom_adj(-16) != -ENOENT)
 		syslog(LOG_ERR, "Failed to set oom_adj to protect against OOM killer");
 
 	_init_thread_signals();
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/16 23:03:13	1.18
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/17 14:45:10	1.19
@@ -31,19 +31,23 @@
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
 struct dm_event_handler {
-	const char *dso;
+	char *dso;
 
-	const char *dev_name;
+	char *dev_name;
 
-	const char *uuid;
+	char *uuid;
 	int major;
 	int minor;
 
 	enum dm_event_mask mask;
 };
 
-static void dm_event_handler_clear_dev_name(struct dm_event_handler *dmevh)
+static void _dm_event_handler_clear_dev_info(struct dm_event_handler *dmevh)
 {
+	if (dmevh->dev_name)
+		dm_free(dmevh->dev_name);
+	if (dmevh->uuid)
+		dm_free(dmevh->uuid);
 	dmevh->dev_name = dmevh->uuid = NULL;
 	dmevh->major = dmevh->minor = 0;
 }
@@ -64,33 +68,57 @@
 
 void dm_event_handler_destroy(struct dm_event_handler *dmevh)
 {
+	_dm_event_handler_clear_dev_info(dmevh);
+	if (dmevh->dso)
+		dm_free(dmevh->dso);
 	dm_free(dmevh);
 }
 
-void dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path)
+int dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path)
 {
-	dmevh->dso = path;
+	if (!path) /* noop */
+		return 0;
+	if (dmevh->dso)
+		dm_free(dmevh->dso);
+
+	dmevh->dso = dm_strdup(path);
+	if (!dmevh->dso)
+		return -ENOMEM;
+
+	return 0;
 }
 
-void dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name)
+int dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name)
 {
-	dm_event_handler_clear_dev_name(dmevh);
+	if (!dev_name)
+		return 0;
 
-	dmevh->dev_name = dev_name;
+	_dm_event_handler_clear_dev_info(dmevh);
+
+	dmevh->dev_name = dm_strdup(dev_name);
+	if (!dmevh->dev_name)
+		return -ENOMEM;
+	return 0;
 }
 
-void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid)
+int dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid)
 {
-	dm_event_handler_clear_dev_name(dmevh);
+	if (!uuid)
+		return 0;
+
+	_dm_event_handler_clear_dev_info(dmevh);
 
-	dmevh->uuid = uuid;
+	dmevh->uuid = dm_strdup(uuid);
+	if (!dmevh->dev_name)
+		return -ENOMEM;
+	return 0;
 }
 
 void dm_event_handler_set_major(struct dm_event_handler *dmevh, int major)
 {
 	int minor = dmevh->minor;
 
-	dm_event_handler_clear_dev_name(dmevh);
+	_dm_event_handler_clear_dev_info(dmevh);
 
 	dmevh->major = major;
 	dmevh->minor = minor;
@@ -100,7 +128,7 @@
 {
 	int major = dmevh->major;
 
-	dm_event_handler_clear_dev_name(dmevh);
+	_dm_event_handler_clear_dev_info(dmevh);
 
 	dmevh->major = major;
 	dmevh->minor = minor;
@@ -582,7 +610,7 @@
 int dm_event_get_registered_device(struct dm_event_handler *dmevh, int next)
 {
 	int ret;
-	char *uuid = NULL;
+	const char *uuid = NULL;
 	char *reply_dso = NULL, *reply_uuid = NULL;
 	enum dm_event_mask reply_mask;
 	struct dm_task *dmt;
@@ -601,23 +629,57 @@
 		/* FIXME this will probably horribly break if we get
 		   ill-formatted reply */
 		ret = _parse_message(&msg, &reply_dso, &reply_uuid, &reply_mask);
-	} else
+	} else {
 		ret = -ENOENT;
+		goto fail;
+	}
 
-	if (msg.data)
+	dm_task_destroy(dmt);
+
+	if (msg.data) {
 		dm_free(msg.data);
+		msg.data = NULL;
+	}
+
+	_dm_event_handler_clear_dev_info(dmevh);
+	dmevh->uuid = dm_strdup(reply_uuid);
+	if (!dmevh->uuid) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (!(dmt = _get_device_info(dmevh))) {
+		ret = -ENXIO; /* dmeventd probably gave us bogus uuid back */
+		goto fail;
+	}
 
-	dm_event_handler_set_uuid(dmevh, reply_uuid);
 	dm_event_handler_set_dso(dmevh, reply_dso);
 	dm_event_handler_set_event_mask(dmevh, reply_mask);
-	/* FIXME also fill in name and device number */
-	/* FIXME this probably leaks memory, since noone is going to
-	   dm_free the bits in dmevh -- needs changes to
-	   dm_event_handle_set behaviour */
+	dmevh->dev_name = dm_strdup(dm_task_get_name(dmt));
+	if (!dmevh->dev_name) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	struct dm_info info;
+	if (!dm_task_get_info(dmt, &info)) {
+		ret = -1;
+		goto fail;
+	}
+
+	dmevh->major = info.major;
+	dmevh->minor = info.minor;
 
 	dm_task_destroy(dmt);
 
 	return ret;
+
+ fail:
+	if (msg.data)
+		dm_free(msg.data);
+	_dm_event_handler_clear_dev_info(dmevh);
+	dm_task_destroy(dmt);
+	return ret;
 }
 
 #if 0				/* left out for now */
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/16 23:03:13	1.9
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/17 14:45:10	1.10
@@ -54,18 +54,20 @@
 
 /*
  * Path of shared library to handle events.
+ *
+ * All of dso, dev_name and uuid strings are duplicated, you do not
+ * need to keep the pointers valid after the call succeeds. Thes may
+ * return -ENOMEM though.
  */
-void dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path);
+int dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path);
 
 /*
- * Identify the device to monitor by exactly one of
- * dev_name, uuid or device number.
- * FIXME we should give guarantees about how dev_name and uuid
- * pontiers are handled, eg dm_strdup them
+ * Identify the device to monitor by exactly one of dev_name, uuid or
+ * device number. String arguments are duplicated, see above.
  */
-void dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name);
+int dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name);
 
-void dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid);
+int dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid);
 
 void dm_event_handler_set_major(struct dm_event_handler *dmevh, int major);
 void dm_event_handler_set_minor(struct dm_event_handler *dmevh, int minor);
