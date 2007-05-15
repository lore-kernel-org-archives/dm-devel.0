From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 15 May 2007 16:42:27 -0000
Message-ID: <20070515164227.10446.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-05-15 16:42:27

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #240075. prioritizer typo fixed.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.10&r2=1.16.2.11

--- multipath-tools/libmultipath/hwtable.c	2007/05/07 17:59:46	1.16.2.10
+++ multipath-tools/libmultipath/hwtable.c	2007/05/15 16:42:26	1.16.2.11
@@ -86,7 +86,7 @@
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "HITACHI", "DF*", GROUP_BY_PRIO,
-		   DEFAULT_GETUID, "/sbin/mpath/prio_hds_modular %d", "0", "0",
+		   DEFAULT_GETUID, "/sbin/mpath_prio_hds_modular %d", "0", "0",
 		   "readsector0", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 
 	return r;
