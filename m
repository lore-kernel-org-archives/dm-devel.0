From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 19 Jun 2009 22:10:54 -0000
Message-ID: <20090619221054.2918.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-06-19 22:10:53

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix for 475967.  Fixed config defaults for hp storageworks devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.18&r2=1.20.2.19

--- multipath-tools/libmultipath/hwtable.c	2009/05/05 22:02:31	1.20.2.18
+++ multipath-tools/libmultipath/hwtable.c	2009/06/19 22:10:53	1.20.2.19
@@ -64,8 +64,8 @@
 		.product       = "HSG80",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 hp_sw",
+		.features      = "2 pg_init_retries 10",
+		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -80,8 +80,8 @@
 		.product       = "MSA|HSV1.0.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 hp_sw",
+		.features      = "2 pg_init_retries 10",
+		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
