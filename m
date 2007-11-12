From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h
Date: 12 Nov 2007 20:47:18 -0000
Message-ID: <20071112204718.19796.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-12 20:47:18

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h 

Log message:
	Add DM_READ_AHEAD_MINIMUM_FLAG

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.208&r2=1.209
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.75&r2=1.76

--- device-mapper/WHATS_NEW	2007/11/09 16:52:36	1.208
+++ device-mapper/WHATS_NEW	2007/11/12 20:47:17	1.209
@@ -1,6 +1,6 @@
 Version 1.02.23 - 
 ==================================
-  Define DM_READ_AHEAD_AUTO and DM_READ_AHEAD_NONE.
+  Define DM_READ_AHEAD_* values and flags.
   Fix configure --with-dmeventd-path substitution.
   Allow $DM_DEV_DIR envvar to override default of "/dev".
   Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
--- device-mapper/lib/libdevmapper.h	2007/11/09 16:52:36	1.75
+++ device-mapper/lib/libdevmapper.h	2007/11/12 20:47:18	1.76
@@ -144,6 +144,8 @@
 #define DM_READ_AHEAD_AUTO UINT32_MAX	/* Use kernel default readahead */
 #define DM_READ_AHEAD_NONE 0		/* Disable readahead */
 
+#define DM_READ_AHEAD_MINIMUM_FLAG	0x1	/* Value supplied is minimum */
+
 int dm_task_set_ro(struct dm_task *dmt);
 int dm_task_set_newname(struct dm_task *dmt, const char *newname);
 int dm_task_set_minor(struct dm_task *dmt, int minor);
