From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 30 Oct 2008 17:52:07 -0000
Message-ID: <20081030175207.31087.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-10-30 17:52:07

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	drop explicit libdevmapper.h

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.112&r2=1.113

--- device-mapper/dmsetup/dmsetup.c	2008/10/30 17:24:03	1.112
+++ device-mapper/dmsetup/dmsetup.c	2008/10/30 17:52:06	1.113
@@ -21,7 +21,6 @@
 
 #include "configure.h"
 
-#include "libdevmapper.h"
 #include "dm-logging.h"
 
 #include <stdio.h>
