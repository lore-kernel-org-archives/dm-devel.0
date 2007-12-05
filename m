From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-common.c
Date: 5 Dec 2007 18:57:38 -0000
Message-ID: <20071205185738.16401.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 18:57:34

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-common.c 

Log message:
	Fix minimum readahead debug message.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.214&r2=1.215
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.54&r2=1.55

--- device-mapper/WHATS_NEW	2007/12/05 17:14:30	1.214
+++ device-mapper/WHATS_NEW	2007/12/05 18:57:33	1.215
@@ -1,5 +1,6 @@
 Version 1.02.24 -
 ===================================
+  Fix minimum readahead debug message.
 
 Version 1.02.23 - 5th December 2007
 ===================================
--- device-mapper/lib/libdm-common.c	2007/12/05 14:11:26	1.54
+++ device-mapper/lib/libdm-common.c	2007/12/05 18:57:34	1.55
@@ -438,8 +438,8 @@
 			return_0;
 
 		if (current_read_ahead > read_ahead) {
-			log_debug("%s: read ahead %" PRIu32
-				  " below minimum of %" PRIu32,
+			log_debug("%s: retaining kernel read ahead of %" PRIu32
+				  " (requested %" PRIu32 ")",           
 				  dev_name, current_read_ahead, read_ahead);
 			return 1;
 		}
