From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 16 Aug 2007 16:30:12 -0000
Message-ID: <20070816163012.6166.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-08-16 16:30:12

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix for bz 245019. The alua  callout for the IBM 2145 now has a fully qualified
	path name.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.5&r2=1.20.2.6

--- multipath-tools/libmultipath/hwtable.c	2007/08/14 18:08:54	1.20.2.5
+++ multipath-tools/libmultipath/hwtable.c	2007/08/16 16:30:11	1.20.2.6
@@ -356,7 +356,7 @@
 		.vendor        = "IBM",
 		.product       = "2145",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "mpath_prio_alua /dev/%n",
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
