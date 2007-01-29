From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 29 Jan 2007 17:45:32 -0000
Message-ID: <20070129174532.26985.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 17:45:32

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	reorder report field definitions

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.163&r2=1.164
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.80&r2=1.81

--- device-mapper/WHATS_NEW	2007/01/29 17:23:54	1.163
+++ device-mapper/WHATS_NEW	2007/01/29 17:45:32	1.164
@@ -1,6 +1,6 @@
 Version 1.02.17 -
 ===================================
-  Use fixed-size fields in report interface.
+  Use fixed-size fields in report interface and reorder.
 
 Version 1.02.16 - 25th January 2007
 ===================================
--- device-mapper/dmsetup/dmsetup.c	2007/01/25 14:16:20	1.80
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 17:45:32	1.81
@@ -1561,8 +1561,8 @@
 #define OFFSET_OF(strct, field) ((unsigned int) &((struct strct *)NULL)->field)
 #define STR (DM_REPORT_FIELD_TYPE_STRING)
 #define NUM (DM_REPORT_FIELD_TYPE_NUMBER)
-#define FIELD_O(type, strct, sorttype, head, field, width, func, id, desc) {DR_ ## type, id, OFFSET_OF(strct, field), head, width, sorttype, &_ ## func ## _disp, desc},
-#define FIELD_F(type, sorttype, head, width, func, id, desc) {DR_ ## type, id, 0, head, width, sorttype, &_ ## func ## _disp, desc},
+#define FIELD_O(type, strct, sorttype, head, field, width, func, id, desc) {DR_ ## type, sorttype, OFFSET_OF(strct, field), width, id, head, &_ ## func ## _disp, desc},
+#define FIELD_F(type, sorttype, head, width, func, id, desc) {DR_ ## type, sorttype, 0, width, id, head, &_ ## func ## _disp, desc},
 
 static const struct dm_report_field_type _report_fields[] = {
 /* *INDENT-OFF* */
@@ -1574,7 +1574,7 @@
 FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open_count", "Number of references to open device, if requested.")
 FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "target_count", "Number of segments in live table, if present.")
 FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "event_nr", "Current event number.")
-{0, "", 0, "", 0, 0, NULL, NULL},
+{0, 0, 0, 0, "", "", NULL, NULL},
 /* *INDENT-ON* */
 };
 
