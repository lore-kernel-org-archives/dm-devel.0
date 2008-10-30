From: agk@sourceware.org
Subject: device-mapper/include log.h
Date: 30 Oct 2008 17:50:42 -0000
Message-ID: <20081030175042.16770.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-10-30 17:50:42

Modified files:
	include        : log.h 

Log message:
	drop libdevmapper.h

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.12&r2=1.13

--- device-mapper/include/log.h	2008/10/30 17:24:04	1.12
+++ device-mapper/include/log.h	2008/10/30 17:50:41	1.13
@@ -16,8 +16,6 @@
 #ifndef _DM_LOG_H
 #define _DM_LOG_H
 
-#include "libdevmapper.h"
-
 #include <stdio.h>		/* FILE */
 #include <string.h>		/* strerror() */
 #include <errno.h>
