From: agk@sourceware.org
Subject: device-mapper/lib libdevmapper.h
Date: 5 Dec 2007 16:28:20 -0000
Message-ID: <20071205162820.28608.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 16:28:19

Modified files:
	lib            : libdevmapper.h 

Log message:
	clarify when read_ahead may be set

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.78&r2=1.79

--- device-mapper/lib/libdevmapper.h	2007/11/30 14:59:57	1.78
+++ device-mapper/lib/libdevmapper.h	2007/12/05 16:28:19	1.79
@@ -165,6 +165,9 @@
 
 #define DM_READ_AHEAD_MINIMUM_FLAG	0x1	/* Value supplied is minimum */
 
+/*
+ * Read ahead is set with DM_DEVICE_CREATE with a table or DM_DEVICE_RESUME.
+ */
 int dm_task_set_read_ahead(struct dm_task *dmt, uint32_t read_ahead,
 			   uint32_t read_ahead_flags);
 uint32_t dm_task_get_read_ahead(const struct dm_task *dmt,
