From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 2 Jan 2008 23:38:44 -0000
Message-ID: <20080102233844.23951.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-02 23:38:43

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Use the hp_sw hardware handler. Fixes bz #226791

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.9&r2=1.20.2.10

--- multipath-tools/libmultipath/hwtable.c	2007/10/29 20:03:08	1.20.2.9
+++ multipath-tools/libmultipath/hwtable.c	2008/01/02 23:38:43	1.20.2.10
@@ -76,7 +76,7 @@
 	},
 	{
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "MSA1.*",
+		.product       = "(MSA|HSV)1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -91,7 +91,7 @@
 	},
 	{
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV(1|2).*",
+		.product       = "HSV2.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua %n",
 		.features      = DEFAULT_FEATURES,
