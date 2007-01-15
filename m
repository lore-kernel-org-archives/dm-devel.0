From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c libdevmapper ...
Date: 15 Jan 2007 19:47:51 -0000
Message-ID: <20070115194751.1925.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 19:47:49

Modified files:
	dmeventd       : dmeventd.c libdevmapper-event.c 

Log message:
	fix recent checkins

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.31&r2=1.32
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.14&r2=1.15

--- device-mapper/dmeventd/dmeventd.c	2007/01/15 19:19:31	1.31
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 19:47:48	1.32
@@ -855,7 +855,7 @@
 	   events. However, if timeout thread cannot be started, it
 	   usually means we are so starved on resources that we are
 	   almost as good as dead already... */
-	if (thread->events & DM_EVENT_TIMEOUT) {
+	if (thread_new->events & DM_EVENT_TIMEOUT) {
 		ret = -_register_for_timeout(thread);
                 if (ret) {
                     _unlock_mutex();
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 19:11:58	1.14
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/15 19:47:49	1.15
@@ -426,6 +426,7 @@
 	else if (dmevh->major && dmevh->minor) {
 		dm_task_set_major(dmt, dmevh->major);
 		dm_task_set_minor(dmt, dmevh->minor);
+        }
 
 	/* FIXME Add name or uuid or devno to messages */
 	if (!dm_task_run(dmt)) {
@@ -433,7 +434,7 @@
 		goto failed;
 	}
 
-	if (!dm_task_get_info(dmt, &info))
+	if (!dm_task_get_info(dmt, &info)) {
 		log_error("_get_device_info: failed to get info for device");
 		goto failed;
 	}
