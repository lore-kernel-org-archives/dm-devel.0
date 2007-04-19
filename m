From: mbroz@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/libdevmappe ...
Date: 19 Apr 2007 19:10:21 -0000
Message-ID: <20070419191021.616.qmail@sourceware.org>
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
Changes by:	mbroz@sourceware.org	2007-04-19 20:10:19

Modified files:
	.              : WHATS_NEW 
	dmeventd       : libdevmapper-event.c 

Log message:
	Fix libdevmapper-event memory leaks

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.173&r2=1.174
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.21&r2=1.22

--- device-mapper/WHATS_NEW	2007/03/16 14:36:14	1.173
+++ device-mapper/WHATS_NEW	2007/04/19 19:10:19	1.174
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Fix libdevmapper-event memory leaks
   Remove unnecessary memset() return value checks.
   Fix a few leaks in reporting error paths. [1.02.15+]
 
--- device-mapper/dmeventd/libdevmapper-event.c	2007/02/02 17:08:51	1.21
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/04/19 19:10:19	1.22
@@ -359,10 +359,17 @@
 	 */
 	if (!_daemon_write(fifos, msg)) {
 		stack;
+		dm_free(msg->data);
+		msg->data = 0;
 		return -EIO;
 	}
 
 	do {
+
+		if (msg->data)
+			dm_free(msg->data);
+		msg->data = 0;
+
 		if (!_daemon_read(fifos, msg)) {
 			stack;
 			return -EIO;
@@ -548,6 +555,11 @@
 	}
 
 	ret = _daemon_talk(&fifos, msg, DM_EVENT_CMD_HELLO, 0, 0, 0, 0);
+
+	if (msg->data)
+		dm_free(msg->data);
+	msg->data = 0;
+
 	if (!ret)
 		ret = _daemon_talk(&fifos, msg, cmd, dso_name, dev_name, evmask, timeout);
 
@@ -714,6 +726,12 @@
 
 	dm_event_handler_set_dso(dmevh, reply_dso);
 	dm_event_handler_set_event_mask(dmevh, reply_mask);
+
+	if (reply_dso)
+		dm_free(reply_dso);
+	if (reply_uuid)
+		dm_free(reply_uuid);
+
 	dmevh->dev_name = dm_strdup(dm_task_get_name(dmt));
 	if (!dmevh->dev_name) {
 		ret = -ENOMEM;
@@ -736,6 +754,10 @@
  fail:
 	if (msg.data)
 		dm_free(msg.data);
+	if (reply_dso)
+		dm_free(reply_dso);
+	if (reply_uuid)
+		dm_free(reply_uuid);
 	_dm_event_handler_clear_dev_info(dmevh);
 	dm_task_destroy(dmt);
 	return ret;
