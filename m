From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h
Date: 9 Nov 2007 16:52:36 -0000
Message-ID: <20071109165236.2861.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-09 16:52:36

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h 

Log message:
	Define DM_READ_AHEAD_AUTO and DM_READ_AHEAD_NONE.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.207&r2=1.208
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.74&r2=1.75

--- device-mapper/WHATS_NEW	2007/10/10 00:02:03	1.207
+++ device-mapper/WHATS_NEW	2007/11/09 16:52:36	1.208
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Define DM_READ_AHEAD_AUTO and DM_READ_AHEAD_NONE.
   Fix configure --with-dmeventd-path substitution.
   Allow $DM_DEV_DIR envvar to override default of "/dev".
   Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
--- device-mapper/lib/libdevmapper.h	2007/08/21 16:26:06	1.74
+++ device-mapper/lib/libdevmapper.h	2007/11/09 16:52:36	1.75
@@ -141,6 +141,9 @@
 struct dm_names *dm_task_get_names(struct dm_task *dmt);
 struct dm_versions *dm_task_get_versions(struct dm_task *dmt);
 
+#define DM_READ_AHEAD_AUTO UINT32_MAX	/* Use kernel default readahead */
+#define DM_READ_AHEAD_NONE 0		/* Disable readahead */
+
 int dm_task_set_ro(struct dm_task *dmt);
 int dm_task_set_newname(struct dm_task *dmt, const char *newname);
 int dm_task_set_minor(struct dm_task *dmt, int minor);
