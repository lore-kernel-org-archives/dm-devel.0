From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 29 Jan 2007 18:43:28 -0000
Message-ID: <20070129184328.3784.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 18:43:27

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	help unused attr

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.83&r2=1.84

--- device-mapper/dmsetup/dmsetup.c	2007/01/29 18:37:57	1.83
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 18:43:27	1.84
@@ -1735,7 +1735,9 @@
 		     "[-o offset] [-f|loop_device] [file]\n\n");
 }
 
-static int _help(int argc, char **argv, void *data)
+static int _help(int argc __attribute((unused)),
+		 char **argv __attribute((unused)),
+		 void *data __attribute((unused)))
 {
 	_usage(stderr);
 
