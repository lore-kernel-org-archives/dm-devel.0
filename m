From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 7 May 2007 17:59:46 -0000
Message-ID: <20070507175946.4918.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-05-07 17:59:46

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipath      : multipath.conf.redhat 

Log message:
	Applied fix for 238983. the dasdview callout now uses the -f option.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.9&r2=1.16.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.2&r2=1.5.2.3

--- multipath-tools/multipath.conf.defaults	2007/05/04 17:13:34	1.5.2.3
+++ multipath-tools/multipath.conf.defaults	2007/05/07 17:59:46	1.5.2.4
@@ -206,7 +206,7 @@
 #		product			"S/390 DASD ECKD"
 #		bl_product		"S/390"
 #		path_grouping_policy	multibus
-#		getuid_callout		"/sbin/dasdview -j /dev/%n"
+#		getuid_callout		"/sbin/dasdview -j -f /dev/%n"
 #		path_checker		directio
 #	}
 #	device {
--- multipath-tools/libmultipath/hwtable.c	2007/04/04 22:28:30	1.16.2.9
+++ multipath-tools/libmultipath/hwtable.c	2007/05/07 17:59:46	1.16.2.10
@@ -69,7 +69,7 @@
 		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
 		   "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
-		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
+		   "/sbin/dasdview -j -f /dev/%n", NULL, "0", "0",
 		   "directio", FAILBACK_UNDEF, "S/390", 0, 0, 0);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
 		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
--- multipath-tools/multipath/multipath.conf.redhat	2007/01/10 21:56:17	1.5.2.2
+++ multipath-tools/multipath/multipath.conf.redhat	2007/05/07 17:59:46	1.5.2.3
@@ -25,7 +25,7 @@
 #		vendor                  "IBM"
 #		product                 "S/390 DASD ECKD"
 #		path_grouping_policy    multibus
-#		getuid_callout          "/sbin/dasdview -j /dev/%n"
+#		getuid_callout          "/sbin/dasdview -j -f /dev/%n"
 #		path_checker            directio
 #	}
 #}
