From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 27 Apr 2007 18:01:46 -0000
Message-ID: <20070427180146.23234.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-04-27 19:01:46

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	configure.h isn't a system header

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.89&r2=1.90

--- device-mapper/dmsetup/dmsetup.c	2007/04/27 15:12:26	1.89
+++ device-mapper/dmsetup/dmsetup.c	2007/04/27 18:01:45	1.90
@@ -19,7 +19,7 @@
 #define _GNU_SOURCE
 #define _FILE_OFFSET_BITS 64
 
-#include <configure.h>
+#include "configure.h"
 
 #include "libdevmapper.h"
 #include "log.h"
