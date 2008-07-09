From: mornfall@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 9 Jul 2008 13:26:09 -0000
Message-ID: <20080709132609.20517.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2008-07-09 13:26:08

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	Add #include <signal.h> to dmeventd.c, fixes compilation on NetBSD.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.50&r2=1.51

--- device-mapper/dmeventd/dmeventd.c	2007/07/24 14:16:48	1.50
+++ device-mapper/dmeventd/dmeventd.c	2008/07/09 13:26:07	1.51
@@ -36,6 +36,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <unistd.h>
+#include <signal.h>
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
 #ifdef linux
