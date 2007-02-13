From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 13 Feb 2007 18:50:37 -0000
Message-ID: <20070213185037.21042.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-02-13 18:50:37

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Typo in the configurations for a couple IBM devices, causing them not to be
	correctly configured by default. BZ #226805

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.6&r2=1.16.2.7

--- multipath-tools/libmultipath/hwtable.c	2007/01/10 21:56:17	1.16.2.6
+++ multipath-tools/libmultipath/hwtable.c	2007/02/13 18:50:37	1.16.2.7
@@ -56,17 +56,17 @@
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "2105*", GROUP_BY_SERIAL, DEFAULT_GETUID,
-		   NULL, "0", "1 queue_in_no_path", "tur", FAILBACK_UNDEF, NULL,
+		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF, NULL,
 		   0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO,
 		   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n", "0",
-		   "1 queue_in_no_path", "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0,
+		   "1 queue_if_no_path", "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0,
 		   0);
 	r += store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL,
-		   DEFAULT_GETUID, NULL, "0", "1 queue_in_no_path", "tur",
+		   DEFAULT_GETUID, NULL, "0", "1 queue_if_no_path", "tur",
 		   FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "2145", GROUP_BY_PRIO, DEFAULT_GETUID,
-		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_in_no_path",
+		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
 		   "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
 		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
