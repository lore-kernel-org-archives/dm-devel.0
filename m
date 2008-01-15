From: jbrassow@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c
Date: 15 Jan 2008 22:48:12 -0000
Message-ID: <20080115224812.19250.qmail@sourceware.org>
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
Changes by:	jbrassow@sourceware.org	2008-01-15 22:48:11

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	- The automatic log module loading patch proposed for the upstream kernel
	works on '-'s, not '_'s.  This is due to the preference to have log
	module file names that do not mix '_'s and '-'s.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.222&r2=1.223
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.36&r2=1.37

--- device-mapper/WHATS_NEW	2007/12/20 15:16:14	1.222
+++ device-mapper/WHATS_NEW	2008/01/15 22:48:11	1.223
@@ -1,5 +1,6 @@
 Version 1.02.25 - 
 ====================================
+  Change cluster mirror log type name (s/clustered_/clustered-/)
 
 Version 1.02.24 - 20th December 2007
 ====================================
--- device-mapper/lib/libdm-deptree.c	2007/12/14 19:49:27	1.36
+++ device-mapper/lib/libdm-deptree.c	2008/01/15 22:48:11	1.37
@@ -1289,7 +1289,7 @@
 		if (seg->clustered) {
 			if (seg->uuid)
 				log_parm_count++;
-			if ((tw = _dm_snprintf(params + pos, paramsize - pos, "clustered_")) < 0) {
+			if ((tw = _dm_snprintf(params + pos, paramsize - pos, "clustered-")) < 0) {
                         	stack;	/* Out of space */
                         	return -1;
                 	}
