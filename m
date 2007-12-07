From: agk@sourceware.org
Subject: device-mapper/kernel/ioctl dm-ioctl.h
Date: 7 Dec 2007 12:57:58 -0000
Message-ID: <20071207125758.11534.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-07 12:57:57

Modified files:
	kernel/ioctl   : dm-ioctl.h 

Log message:
	reinstate linux ifdef

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/kernel/ioctl/dm-ioctl.h.diff?cvsroot=dm&r1=1.45&r2=1.46

--- device-mapper/kernel/ioctl/dm-ioctl.h	2007/12/05 14:11:26	1.45
+++ device-mapper/kernel/ioctl/dm-ioctl.h	2007/12/07 12:57:57	1.46
@@ -8,7 +8,9 @@
 #ifndef _LINUX_DM_IOCTL_V4_H
 #define _LINUX_DM_IOCTL_V4_H
 
-#include <linux/types.h>
+#ifdef linux
+#  include <linux/types.h>
+#endif
 
 #define DM_DIR "mapper"		/* Slashes not supported */
 #define DM_MAX_TYPE_NAME 16
