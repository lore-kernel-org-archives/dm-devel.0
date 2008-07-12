From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 12 Jul 2008 00:07:36 -0000
Message-ID: <20080712000736.540.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-07-12 00:07:33

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz 434588. dasd storage now defaults to queue_if_no_path.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.9&r2=1.5.4.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.11&r2=1.20.2.12

--- multipath-tools/multipath.conf.defaults	2008/01/07 22:22:53	1.5.4.9
+++ multipath-tools/multipath.conf.defaults	2008/07/12 00:07:33	1.5.4.10
@@ -277,7 +277,7 @@
 #		product			"S/390 DASD ECKD"
 #		product_blacklist	"S/390.*"
 #		getuid_callout		"/sbin/dasd_id /dev/%n"
-#		features		"0"
+#		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
 #		rr_weight		uniform
--- multipath-tools/libmultipath/hwtable.c	2008/01/03 20:16:06	1.20.2.11
+++ multipath-tools/libmultipath/hwtable.c	2008/07/12 00:07:33	1.20.2.12
@@ -374,7 +374,7 @@
 		.bl_product    = "S/390.*",
 		.getuid        = "/sbin/dasd_id /dev/%n",
 		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
+		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
