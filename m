From: agk@sourceware.org
Subject: device-mapper/dmeventd libdevmapper-event.h
Date: 19 Jan 2007 20:42:10 -0000
Message-ID: <20070119204210.6294.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-19 20:42:09

Modified files:
	dmeventd       : libdevmapper-event.h 

Log message:
	var dev_name->device_name (lvm2 has dev_name())

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.10&r2=1.11

--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/17 14:45:10	1.10
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/01/19 20:42:09	1.11
@@ -55,17 +55,17 @@
 /*
  * Path of shared library to handle events.
  *
- * All of dso, dev_name and uuid strings are duplicated, you do not
+ * All of dso, device_name and uuid strings are duplicated, you do not
  * need to keep the pointers valid after the call succeeds. Thes may
  * return -ENOMEM though.
  */
 int dm_event_handler_set_dso(struct dm_event_handler *dmevh, const char *path);
 
 /*
- * Identify the device to monitor by exactly one of dev_name, uuid or
+ * Identify the device to monitor by exactly one of device_name, uuid or
  * device number. String arguments are duplicated, see above.
  */
-int dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *dev_name);
+int dm_event_handler_set_dev_name(struct dm_event_handler *dmevh, const char *device_name);
 
 int dm_event_handler_set_uuid(struct dm_event_handler *dmevh, const char *uuid);
 
@@ -97,8 +97,8 @@
 /* Prototypes for DSO interface, see dmeventd.c, struct dso_data for
    detailed descriptions. */
 void process_event(struct dm_task *dmt, enum dm_event_mask evmask);
-int register_device(const char *dev_name, const char *uuid, int major, int minor);
-int unregister_device(const char *dev_name, const char *uuid, int major,
+int register_device(const char *device_name, const char *uuid, int major, int minor);
+int unregister_device(const char *device_name, const char *uuid, int major,
 		      int minor);
 
 #endif
