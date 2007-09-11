From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 11 Sep 2007 18:06:04 -0000
Message-ID: <20070911180604.7142.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-09-11 18:06:02

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Changed "foo*" regular expressions to "foo.*". Pulled from upstream
	Resolves: bz 233629

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.5&r2=1.5.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.11&r2=1.16.2.12

--- multipath-tools/multipath.conf.defaults	2007/08/02 23:00:52	1.5.2.5
+++ multipath-tools/multipath.conf.defaults	2007/09/11 18:06:01	1.5.2.6
@@ -62,7 +62,7 @@
 #        }
 #       device {
 #                vendor                 "{HITACHI|HP}"
-#                product                "OPEN-*"
+#                product                "OPEN-.*"
 #                path_grouping_policy   multibus
 #                path_checker           tur
 #        }
@@ -133,7 +133,7 @@
 #       }
 #	device {
 #		vendor			"HITACHI"
-#		product			"DF*"
+#		product			"DF.*"
 #		path_grouping_policy	group_by_prio
 #		prio_callout		"/sbin/mpath_prio_hds_modular %d"
 #		path_checker		"readsector0"
@@ -167,7 +167,7 @@
 #	}
 #	device {
 #		vendor			"IBM"
-#		product			"2105*"
+#		product			"2105.*"
 #		path_grouping_policy	group_by_serial
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
 #		features		"1 queue_if_no_path"
--- multipath-tools/libmultipath/hwtable.c	2007/05/15 16:42:26	1.16.2.11
+++ multipath-tools/libmultipath/hwtable.c	2007/09/11 18:06:01	1.16.2.12
@@ -13,7 +13,7 @@
 
 	r += store_hwe(hw, "3PARdata", "VV", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "APPLE*", "Xserve RAID ", MULTIBUS, DEFAULT_GETUID);
-	r += store_hwe(hw, "COMPAQ", "HSV110*", GROUP_BY_SERIAL, DEFAULT_GETUID);
+	r += store_hwe(hw, "COMPAQ", "HSV110.*", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "COMPAQ", "MSA1000", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "DDN", "SAN DataDirector", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "DEC", "HSG80", GROUP_BY_SERIAL, DEFAULT_GETUID);
@@ -44,7 +44,7 @@
 	r += store_hwe_ext(hw, "COMPAQ", "HSV111", GROUP_BY_PRIO,
 		DEFAULT_GETUID, "/sbin/mpath_prio_alua %n", "0", "0", "tur",
 		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
-	r += store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-*", MULTIBUS,
+	r += store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-.*", MULTIBUS,
 		DEFAULT_GETUID, NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE,
 		NULL, 60, 0, 100);
         r += store_hwe_ext(hw, "HP", "*33[89]0*", MULTIBUS, DEFAULT_GETUID, NULL, "0", "0",
@@ -55,7 +55,7 @@
 		   0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
-	r += store_hwe_ext(hw, "IBM", "2105*", GROUP_BY_SERIAL, DEFAULT_GETUID,
+	r += store_hwe_ext(hw, "IBM", "2105.*", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF, NULL,
 		   0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO,
@@ -85,7 +85,7 @@
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
-	r += store_hwe_ext(hw, "HITACHI", "DF*", GROUP_BY_PRIO,
+	r += store_hwe_ext(hw, "HITACHI", "DF.*", GROUP_BY_PRIO,
 		   DEFAULT_GETUID, "/sbin/mpath_prio_hds_modular %d", "0", "0",
 		   "readsector0", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 
