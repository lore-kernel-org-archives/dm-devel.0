From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c ma ...
Date: 29 Jan 2007 19:35:24 -0000
Message-ID: <20070129193524.6864.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 19:35:24

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	man            : dmsetup.8 

Log message:
	Add recent reporting options to dmsetup man page.
	Revise some report fields names.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.165&r2=1.166
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.85&r2=1.86
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.16&r2=1.17

--- device-mapper/WHATS_NEW	2007/01/29 18:18:40	1.165
+++ device-mapper/WHATS_NEW	2007/01/29 19:35:23	1.166
@@ -1,5 +1,7 @@
 Version 1.02.17 -
 ===================================
+  Add recent reporting options to dmsetup man page.
+  Revise some report fields names.
   Add dmsetup 'help' command and update usage text.
   Use fixed-size fields in report interface and reorder.
 
--- device-mapper/dmsetup/dmsetup.c	2007/01/29 18:45:08	1.85
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 19:35:24	1.86
@@ -1568,12 +1568,12 @@
 /* *INDENT-OFF* */
 FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
 FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
-FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "status", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
+FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
 FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
 FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Block device minor number.")
-FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open_count", "Number of references to open device, if requested.")
-FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "target_count", "Number of segments in live table, if present.")
-FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "event_nr", "Current event number.")
+FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open", "Number of references to open device, if requested.")
+FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "segments", "Number of segments in live table, if present.")
+FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "events", "Number of most recent event.")
 {0, 0, 0, 0, "", "", NULL, NULL},
 /* *INDENT-ON* */
 };
@@ -1583,7 +1583,7 @@
 #undef FIELD_O
 #undef FIELD_F
 
-static const char *default_report_options = "name,major,minor,status,open_count,target_count,event_nr,uuid";
+static const char *default_report_options = "name,major,minor,attr,open,segments,events,uuid";
 
 static int _report_init(struct command *c)
 {
--- device-mapper/man/dmsetup.8	2006/11/23 20:34:16	1.16
+++ device-mapper/man/dmsetup.8	2007/01/29 19:35:24	1.17
@@ -3,6 +3,9 @@
 dmsetup \- low level logical volume management
 .SH SYNOPSIS
 .ad l
+.B dmsetup help
+.I [-c|-C|--columns]
+.br
 .B dmsetup create 
 .I device_name [-u uuid] [--notable | --table <table> | table_file]
 .br
@@ -33,21 +36,25 @@
 .B dmsetup message
 .I device_name sector message
 .br
-.B dmsetup ls [--target target_type] [--exec command] [--tree [-o options]]
+.B dmsetup ls
+.I [--target target_type] [--exec command] [--tree [-o options]]
 .br
 .B dmsetup info 
 .I [device_name]
 .br
-.B dmsetup info -c|-C|--columns [--noheadings] [-o name]
+.B dmsetup info -c|-C|--columns
+.I [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields]
 .I [device_name]
 .br
 .B dmsetup deps
 .I [device_name]
 .br
-.B dmsetup status [--target target_type]
+.B dmsetup status
+.I [--target target_type]
 .I [device_name]
 .br
-.B dmsetup table [--target target_type]
+.B dmsetup table
+.I [--target target_type]
 .I [device_name]
 .br
 .B dmsetup wait
@@ -103,7 +110,7 @@
 When creating a device, don't load any table.
 .IP \fB-o|--options
 .br
-Specify which fields to display.  Only \fB-o\ name\fP is supported.
+Specify which fields to display.
 .IP \fB-r|--readonly
 .br
 Set the table being loaded read-only.
@@ -136,6 +143,11 @@
 .br
 Outputs a list of (major, minor) pairs for devices referenced by the
 live table for the specified device.
+.IP \fBhelp
+.I [-c|-C|--columns]
+.br
+Outputs a summary of the commands available, optionally including
+the list of report fields.
 .IP \fBinfo
 .I [device_name]
 .br
@@ -154,6 +166,17 @@
     Number of targets in the live table
 .br
     UUID
+.IP \fBinfo -c|-C|--columns
+.I [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields]
+.I [device_name]
+.br
+Output you can customise.
+Fields are comma-separated and chosen from the following list:
+name, major, minor, attr, open, segments, events, uuid.
+Attributes are: (L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.
+Precede the list with '+' to append
+to the default selection of columns instead of replacing it.
+Precede any sort_field with - for a reverse sort on that column.
 .IP \fBls
 .I [--target target_type]
 .I [--exec command]
