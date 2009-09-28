From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 28 Sep 2009 18:41:20 -0000
Message-ID: <20090928184120.22090.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-09-28 18:41:20

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #517896. Add default configurations for HP devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.16&r2=1.5.4.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.22&r2=1.20.2.23

--- multipath-tools/multipath.conf.defaults	2009/09/28 18:28:48	1.5.4.16
+++ multipath-tools/multipath.conf.defaults	2009/09/28 18:41:20	1.5.4.17
@@ -58,7 +58,7 @@
 #       }
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV1[01]1|HSV2[01]0|HSV300"
+#               product                 "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"	
 #		features		"0"
@@ -100,7 +100,7 @@
 #        }
 #       device {
 #               vendor                  "HP"
-#               product                 "MSA2012sa|MSA23(12|24)(fc|i|sa)"
+#               product                 "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME"
 #               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
 #               features                "0"
--- multipath-tools/libmultipath/hwtable.c	2009/09/28 18:28:48	1.20.2.22
+++ multipath-tools/libmultipath/hwtable.c	2009/09/28 18:41:20	1.20.2.23
@@ -93,7 +93,7 @@
 	{
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000, EVA 4400 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV1[01]1|HSV2[01]0|HSV300",
+		.product       = "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]|HSV4[05]0",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
@@ -141,7 +141,7 @@
 	{
                  /* HP MSA2000 product family with new firmware */
                 .vendor        = "HP",
-                .product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)",
+                .product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
                 .getuid        = DEFAULT_GETUID,
                 .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                 .features      = DEFAULT_FEATURES,
