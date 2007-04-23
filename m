From: mornfall@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c
Date: 23 Apr 2007 15:06:04 -0000
Message-ID: <20070423150604.1505.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2007-04-23 16:06:03

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 

Log message:
	Fix some memory leaks in dmeventd.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.175&r2=1.176
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.47&r2=1.48

--- device-mapper/WHATS_NEW	2007/04/19 20:24:00	1.175
+++ device-mapper/WHATS_NEW	2007/04/23 15:06:03	1.176
@@ -1,7 +1,7 @@
 Version 1.02.19 -
 ====================================
   Introduce _add_field() and _is_same_field() to libdm-report.c.
-  Fix some libdevmapper-event memory leaks.
+  Fix some libdevmapper-event and dmeventd memory leaks.
   Remove unnecessary memset() return value checks.
   Fix a few leaks in reporting error paths. [1.02.15+]
 
--- device-mapper/dmeventd/dmeventd.c	2007/03/16 14:36:14	1.47
+++ device-mapper/dmeventd/dmeventd.c	2007/04/23 15:06:03	1.48
@@ -245,6 +245,8 @@
 
 static void _free_thread_status(struct thread_status *thread)
 {
+	if (thread->current_task)
+		dm_task_destroy(thread->current_task);
 	dm_free(thread->device.uuid);
 	dm_free(thread->device.name);
 	dm_free(thread);
@@ -811,11 +813,6 @@
 
 static int _terminate_thread(struct thread_status *thread)
 {
-	int ret;
-
-	if ((ret = pthread_cancel(thread->thread)))
-		return ret;
-
 	return pthread_kill(thread->thread, SIGALRM);
 }
 
@@ -1389,7 +1386,7 @@
 	message_data.msg = msg;
 	if (msg->cmd == DM_EVENT_CMD_HELLO)  {
 		ret = 0;
-		answer = dm_strdup(msg->data);
+		answer = msg->data;
 		if (answer) {
 			msg->size = dm_asprintf(&(msg->data), "%s HELLO", answer);
 			dm_free(answer);
