From: agk@sourceware.org
Subject: device-mapper/lib libdm-common.c
Date: 3 Dec 2007 17:56:37 -0000
Message-ID: <20071203175637.2298.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-03 17:56:37

Modified files:
	lib            : libdm-common.c 

Log message:
	missing #include

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.51&r2=1.52

--- device-mapper/lib/libdm-common.c	2007/11/30 16:44:42	1.51
+++ device-mapper/lib/libdm-common.c	2007/12/03 17:56:36	1.52
@@ -21,6 +21,7 @@
 
 #include <stdarg.h>
 #include <sys/param.h>
+#include <sys/ioctl.h>
 #include <fcntl.h>
 
 #include <linux/dm-ioctl.h>
