From: mornfall@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/libdevmappe ...
Date: 27 Nov 2007 12:26:07 -0000
Message-ID: <20071127122607.10574.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2007-11-27 12:26:06

Modified files:
	.              : WHATS_NEW 
	dmeventd       : libdevmapper-event.c 

Log message:
	Fix a possible double-free in libdevmapper-event.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.209&r2=1.210
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.25&r2=1.26

--- device-mapper/WHATS_NEW	2007/11/12 20:47:17	1.209
+++ device-mapper/WHATS_NEW	2007/11/27 12:26:06	1.210
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Fix possible double-free in libdevmapper-event.
   Define DM_READ_AHEAD_* values and flags.
   Fix configure --with-dmeventd-path substitution.
   Allow $DM_DEV_DIR envvar to override default of "/dev".
--- device-mapper/dmeventd/libdevmapper-event.c	2007/08/21 16:26:06	1.25
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/11/27 12:26:06	1.26
@@ -722,10 +722,15 @@
 	dm_event_handler_set_dso(dmevh, reply_dso);
 	dm_event_handler_set_event_mask(dmevh, reply_mask);
 
-	if (reply_dso)
+	if (reply_dso) {
 		dm_free(reply_dso);
-	if (reply_uuid)
+		reply_dso = NULL;
+	}
+
+	if (reply_uuid) {
 		dm_free(reply_uuid);
+		reply_uuid = NULL;
+	}
 
 	dmevh->dev_name = dm_strdup(dm_task_get_name(dmt));
 	if (!dmevh->dev_name) {
