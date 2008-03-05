From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 5 Mar 2008 20:53:18 -0000
Message-ID: <20080305205318.18773.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-03-05 20:53:16

Modified files:
	libmultipath   : discovery.c 

Log message:
	multipath wasn't waiting for the devices to get initialized.  This was causing
	it to fail during boot.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.5&r2=1.28.2.6

--- multipath-tools/libmultipath/discovery.c	2008/01/25 22:30:00	1.28.2.5
+++ multipath-tools/libmultipath/discovery.c	2008/03/05 20:53:14	1.28.2.6
@@ -170,11 +170,6 @@
 	return r;
 }
 
-/*
- * the daemon can race udev upon path add,
- * not multipath(8), ran by udev
- */
-#if DAEMON
 #define WAIT_MAX_SECONDS 5
 #define WAIT_LOOP_PER_SECOND 5
 
@@ -197,13 +192,6 @@
 	}
 	return 1;
 }
-#else
-static int
-wait_for_file (char * filename)
-{
-	return 0;
-}
-#endif
 
 #define declare_sysfs_get_str(fname, fmt) \
 extern int \
