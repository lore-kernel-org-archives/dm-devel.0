From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 4 Nov 2009 21:47:06 -0000
Message-ID: <20091104214706.24742.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-11-04 21:47:06

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix fox bz #512243. Add default configuration for IBM Power Virtual SCSI
	devices. Already upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.23&r2=1.20.2.24

--- multipath-tools/libmultipath/hwtable.c	2009/09/28 18:41:20	1.20.2.23
+++ multipath-tools/libmultipath/hwtable.c	2009/11/04 21:47:06	1.20.2.24
@@ -627,6 +627,28 @@
 		.checker_name  = TUR,
 	},
 	/*
+	 * IBM Power Virtual SCSI Devices
+	 *
+	 * Maintainer : Brian King, IBM
+	 * Mail : brking@linux.vnet.ibm.com
+	 */
+	{
+		/* AIX VDASD */
+		.vendor        = "AIX",
+		.product       = "VDASD",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DIRECTIO,
+	},
+	/*
 	 * SGI arrays
 	 *
 	 * Maintainer : Christophe Varoqui
