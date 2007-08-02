From: mornfall@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/libdevmappe ...
Date: 2 Aug 2007 22:31:59 -0000
Message-ID: <20070802223159.24050.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2007-08-02 22:31:59

Modified files:
	.              : WHATS_NEW 
	dmeventd       : libdevmapper-event.c 

Log message:
	Fix a possible segfault in libdevmapper-event. Thanks to Brian J. Wood
	for noticing this.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.196&r2=1.197
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.22&r2=1.23

--- device-mapper/WHATS_NEW	2007/07/28 10:48:36	1.196
+++ device-mapper/WHATS_NEW	2007/08/02 22:31:59	1.197
@@ -1,5 +1,6 @@
 Version 1.02.22 - 
 ================================
+  Fix a possible segfault in libdevmapper-event
   Export dm_create_dir (was create_dir) to help fix LVM2 link error
   Don't log mkdir fail-with-EROFS, to make create_dir equiv to the one in LVM2
   Introduce and use log_sys_* macros from LVM2
--- device-mapper/dmeventd/libdevmapper-event.c	2007/04/19 19:10:19	1.22
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/08/02 22:31:59	1.23
@@ -706,6 +706,7 @@
 	}
 
 	dm_task_destroy(dmt);
+	dmt = 0;
 
 	if (msg.data) {
 		dm_free(msg.data);
@@ -759,7 +760,8 @@
 	if (reply_uuid)
 		dm_free(reply_uuid);
 	_dm_event_handler_clear_dev_info(dmevh);
-	dm_task_destroy(dmt);
+	if (dmt)
+		dm_task_destroy(dmt);
 	return ret;
 }
 
