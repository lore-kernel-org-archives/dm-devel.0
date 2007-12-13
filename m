From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-common.c
Date: 13 Dec 2007 02:25:46 -0000
Message-ID: <20071213022546.9104.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-13 02:25:45

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-common.c 

Log message:
	Report error when empty device name passed to readahead functions.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.216&r2=1.217
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.55&r2=1.56

--- device-mapper/WHATS_NEW	2007/12/05 22:45:56	1.216
+++ device-mapper/WHATS_NEW	2007/12/13 02:25:45	1.217
@@ -1,5 +1,6 @@
 Version 1.02.24 -
 ===================================
+  Report error when empty device name passed to readahead functions.
   Fix minimum readahead debug message.
 
 Version 1.02.23 - 5th December 2007
--- device-mapper/lib/libdm-common.c	2007/12/05 18:57:34	1.55
+++ device-mapper/lib/libdm-common.c	2007/12/13 02:25:45	1.56
@@ -382,6 +382,11 @@
 	int fd;
 	long read_ahead_long;
 
+	if (!*dev_name) {
+		log_error("Empty device name passed to BLKRAGET");
+		return 0;
+	}
+
 	if ((fd = _open_dev_node(dev_name)) < 0)
 		return_0;
 
@@ -406,6 +411,11 @@
 	int fd;
 	long read_ahead_long = (long) read_ahead;
 
+	if (!*dev_name) {
+		log_error("Empty device name passed to BLKRAGET");
+		return 0;
+	}
+
 	if ((fd = _open_dev_node(dev_name)) < 0)
 		return_0;
 
