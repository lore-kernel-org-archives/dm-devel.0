From: agk@sourceware.org
Subject: device-mapper ./VERSION ./WHATS_NEW dmeventd/. ...
Date: 12 Jan 2007 20:22:12 -0000
Message-ID: <20070112202212.16024.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-12 20:22:11

Modified files:
	.              : VERSION WHATS_NEW 
	dmeventd       : .exported_symbols libdevmapper-event.c 
	                 libdevmapper-event.h 

Log message:
	Reinstate dm_event_get_registered_device

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.111&r2=1.112
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.144&r2=1.145
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/.exported_symbols.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.5&r2=1.6

--- device-mapper/VERSION	2007/01/11 23:19:08	1.111
+++ device-mapper/VERSION	2007/01/12 20:22:11	1.112
@@ -1 +1 @@
-1.02.15-cvs (2007-01-07)
+1.02.15-cvs (2007-01-12)
--- device-mapper/WHATS_NEW	2007/01/11 23:19:08	1.144
+++ device-mapper/WHATS_NEW	2007/01/12 20:22:11	1.145
@@ -1,5 +1,6 @@
 Version 1.02.15 -
 ===================================
+  Reinstate dm_event_get_registered_device.
 
 Version 1.02.14 - 11th January 2007
 ===================================
--- device-mapper/dmeventd/.exported_symbols	2007/01/11 21:54:52	1.5
+++ device-mapper/dmeventd/.exported_symbols	2007/01/12 20:22:11	1.6
@@ -14,3 +14,4 @@
 dm_event_handler_get_events
 dm_event_register
 dm_event_unregister
+dm_event_get_registered_device
--- device-mapper/dmeventd/libdevmapper-event.c	2007/01/11 21:54:52	1.11
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/01/12 20:22:11	1.12
@@ -510,8 +510,6 @@
 	return ret;
 }
 
-#if 0				/* left out for now */
-
 /* Fetch a string off src and duplicate it into *dest. */
 /* FIXME: move to seperate module to share with the daemon. */
 static const char delimiter = ' ';
@@ -592,6 +590,8 @@
 	return ret;
 }
 
+#if 0				/* left out for now */
+
 int dm_event_set_timeout(const char *device_path, uint32_t timeout)
 {
 	struct dm_event_daemon_message msg;
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/11 21:54:52	1.5
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/12 20:22:11	1.6
@@ -78,6 +78,10 @@
 int dm_event_handler_get_minor(const struct dm_event_handler *h);
 enum dm_event_type dm_event_handler_get_events(const struct dm_event_handler *h);
 
+/* FIXME */
+int dm_event_get_registered_device(char **dso_name, char **device_path,
+				   enum dm_event_type *events, int next);
+
 /* Call out to dmeventd to register or unregister a handler. If
    dmeventd is not running, it is spawned first. */
 int dm_event_register(const struct dm_event_handler *h);
