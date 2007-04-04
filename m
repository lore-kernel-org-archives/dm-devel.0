From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 4 Apr 2007 22:28:31 -0000
Message-ID: <20070404222831.20564.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-04-04 23:28:30

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #233629. Change pgpolicy from DS8000 from GROUP_BY_SERIAL to
	MULTIBUS.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.8&r2=1.16.2.9

--- multipath-tools/libmultipath/hwtable.c	2007/03/07 16:12:46	1.16.2.8
+++ multipath-tools/libmultipath/hwtable.c	2007/04/04 22:28:30	1.16.2.9
@@ -62,7 +62,7 @@
 		   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n", "0",
 		   "1 queue_if_no_path", "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0,
 		   0);
-	r += store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL,
+	r += store_hwe_ext(hw, "IBM", "2107900", MULTIBUS,
 		   DEFAULT_GETUID, NULL, "0", "1 queue_if_no_path", "tur",
 		   FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "2145", GROUP_BY_PRIO, DEFAULT_GETUID,
