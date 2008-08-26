From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx kpartx.c lopart.c
Date: 26 Aug 2008 03:50:28 -0000
Message-ID: <20080826035028.32686.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-08-26 03:50:28

Modified files:
	kpartx         : kpartx.c lopart.c 

Log message:
	Fix for 454928. Set kpartx to use 64bit versions of file operation functions.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.1&r2=1.9.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/lopart.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.4.1

--- multipath-tools/kpartx/kpartx.c	2008/08/25 20:59:06	1.9.2.1
+++ multipath-tools/kpartx/kpartx.c	2008/08/26 03:50:28	1.9.2.2
@@ -18,7 +18,7 @@
  * aeb, 2000-03-21
  * cva, 2002-10-26
  */
-
+#define _FILE_OFFSET_BITS 64
 #include <stdio.h>
 #include <fcntl.h>
 #include <errno.h>
--- multipath-tools/kpartx/lopart.c	2005/06/08 19:33:30	1.2
+++ multipath-tools/kpartx/lopart.c	2008/08/26 03:50:28	1.2.4.1
@@ -13,7 +13,7 @@
 /*
  * losetup.c - setup and control loop devices
  */
-
+#define _FILE_OFFSET_BITS 64
 #include "kpartx.h"
 #include <stdio.h>
 #include <string.h>
