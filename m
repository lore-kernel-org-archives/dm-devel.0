From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c
Date: 5 Jun 2008 19:10:36 -0000
Message-ID: <20080605191036.1608.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-05 19:10:35

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	Initialise params buffer to empty string in _emit_segment.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.232&r2=1.233
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.37&r2=1.38

--- device-mapper/WHATS_NEW	2008/05/21 16:14:44	1.232
+++ device-mapper/WHATS_NEW	2008/06/05 19:10:35	1.233
@@ -1,5 +1,6 @@
 Version 1.02.26 - 
 =================================
+  Initialise params buffer to empty string in _emit_segment.
   Skip add_dev_node when ioctls disabled.
   Make dm_hash_iter safe against deletion.
   Accept a NULL pointer to dm_free silently.
--- device-mapper/lib/libdm-deptree.c	2008/01/15 22:48:11	1.37
+++ device-mapper/lib/libdm-deptree.c	2008/06/05 19:10:35	1.38
@@ -1276,7 +1276,6 @@
 	switch(seg->type) {
 	case SEG_ERROR:
 	case SEG_ZERO:
-		params[0] = '\0';
 	case SEG_LINEAR:
 		break;
 	case SEG_MIRRORED:
@@ -1434,6 +1433,7 @@
 			return 0;
 		}
 
+		params[0] = '\0';
 		ret = _emit_segment_line(dmt, seg, seg_start, params, paramsize);
 		dm_free(params);
 
