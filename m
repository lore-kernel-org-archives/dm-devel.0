From: agk@sourceware.org
Subject: device-mapper/lib libdm-common.c
Date: 30 Nov 2007 16:44:42 -0000
Message-ID: <20071130164442.11964.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-30 16:44:42

Modified files:
	lib            : libdm-common.c 

Log message:
	fix

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.50&r2=1.51

--- device-mapper/lib/libdm-common.c	2007/11/30 16:42:26	1.50
+++ device-mapper/lib/libdm-common.c	2007/11/30 16:44:42	1.51
@@ -381,7 +381,7 @@
 	int fd;
 
 	if ((fd = _open_dev_node(dev_name)) < 0)
-		; // return_0;
+		return_0;
 
 	*read_ahead = 0;
 
