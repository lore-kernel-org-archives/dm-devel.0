From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW man/dmsetup.8
Date: 23 Nov 2006 20:34:16 -0000
Message-ID: <20061123203416.29198.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-11-23 20:34:16

Modified files:
	.              : WHATS_NEW 
	man            : dmsetup.8 

Log message:
	Update dmsetup man page (setgeometry & message)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.134&r2=1.135
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.15&r2=1.16

--- device-mapper/WHATS_NEW	2006/10/19 16:50:05	1.134
+++ device-mapper/WHATS_NEW	2006/11/23 20:34:16	1.135
@@ -1,5 +1,6 @@
 Version 1.02.13 - 
 =============================
+  Update dmsetup man page (setgeometry & message).
   Fix dmsetup free after getline with debug.
   Suppress encryption key in 'dmsetup table' output unless --showkeys supplied.
 
--- device-mapper/man/dmsetup.8	2006/10/12 15:42:25	1.15
+++ device-mapper/man/dmsetup.8	2006/11/23 20:34:16	1.16
@@ -30,6 +30,9 @@
 .B dmsetup rename
 .I device_name new_name
 .br
+.B dmsetup message
+.I device_name sector message
+.br
 .B dmsetup ls [--target target_type] [--exec command] [--tree [-o options]]
 .br
 .B dmsetup info 
@@ -58,6 +61,9 @@
 .br
 .B dmsetup version
 .br
+.B dmsetup setgeometry
+.I device_name cyl head sect start
+.br
 
 .B devmap_name
 .I major minor
@@ -167,6 +173,10 @@
 .br
 Loads <table> or table_file into the inactive table slot for device_name.
 If neither is supplied, reads a table from standard input.
+.IP \fBmessage
+.I device_name sector message
+.br
+Send message to target. If sector not needed use 0.
 .IP \fBmknodes
 .I [device_name]
 .br
@@ -205,6 +215,10 @@
 Un-suspends a device.  
 If an inactive table has been loaded, it becomes live.
 Postponed I/O then gets re-queued for processing.
+.IP \fBsetgeometry
+.I device_name cyl head sect start
+.br
+Sets the device geometry to C/H/S.
 .IP \fBstatus
 .I [--target target_type]
 .I [device_name]
