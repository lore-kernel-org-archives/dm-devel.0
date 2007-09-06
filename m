From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 6 Sep 2007 16:21:39 -0000
Message-ID: <20070906162139.21322.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-09-06 16:21:38

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Changed the default checker function for NETAPP devices from readsector0 to
	directio.
	Resolves: bz #247443

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.6&r2=1.20.2.7

--- multipath-tools/libmultipath/hwtable.c	2007/08/16 16:30:11	1.20.2.6
+++ multipath-tools/libmultipath/hwtable.c	2007/09/06 16:21:38	1.20.2.7
@@ -403,7 +403,7 @@
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
 	},
  	/*
 	 * IBM NSeries (NETAPP) controller family
