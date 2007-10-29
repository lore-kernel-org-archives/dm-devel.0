From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 29 Oct 2007 20:03:09 -0000
Message-ID: <20071029200309.16270.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-10-29 20:03:08

Modified files:
	libmultipath   : hwtable.c 

Log message:
	use fully qualified path name for mpath_prio_hds_modular.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.8&r2=1.20.2.9

--- multipath-tools/libmultipath/hwtable.c	2007/10/09 21:48:19	1.20.2.8
+++ multipath-tools/libmultipath/hwtable.c	2007/10/29 20:03:08	1.20.2.9
@@ -223,7 +223,7 @@
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "mpath_prio_hds_modular %d",
+		.getprio       = "/sbin/mpath_prio_hds_modular %d",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
