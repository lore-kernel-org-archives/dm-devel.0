From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 7 Mar 2007 16:12:46 -0000
Message-ID: <20070307161246.26226.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-03-07 16:12:46

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Changed the bl_product string back to LUNZ as per Ed Goggins comments in
	BZ#174441

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.7&r2=1.16.2.8

--- multipath-tools/libmultipath/hwtable.c	2007/02/13 18:50:37	1.16.2.7
+++ multipath-tools/libmultipath/hwtable.c	2007/03/07 16:12:46	1.16.2.8
@@ -51,7 +51,7 @@
 		    "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO,
                    DEFAULT_GETUID, "/sbin/mpath_prio_emc /dev/%n", "1 emc",
-		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE, "LUN_Z",
+		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE, "LUNZ",
 		   0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
