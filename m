From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 15 Jan 2009 22:47:37 -0000
Message-ID: <20090115224737.22793.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-15 22:47:36

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #452340
	Added default configurations for HP devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.10&r2=1.5.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.14&r2=1.16.2.15

--- multipath-tools/multipath.conf.defaults	2009/01/13 22:26:36	1.5.2.10
+++ multipath-tools/multipath.conf.defaults	2009/01/15 22:47:36	1.5.2.11
@@ -45,15 +45,55 @@
 #               no_path_retry           12
 #	}
 #       device {
+#               vendor                  "COMPAQ"
+#               product                 "MSA|HSV1.0.*"
+#               path_grouping_policy    group_by_prio
+#               prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
+#               hardware_handler        "1 hp_sw"
+#               path_checker            "hp_sw"
+#               no_path_retry           12
+#		rr_min_io		100
+#       }
+#       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV(1|2).*"
+#               product                 "HSV1[01]1|HSV2[01]0|HSV300"
 #               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               path_checker            "tur"
+#		failback		immediate
+#               no_path_retry           12
+#		rr_min_io		100
+#       }
+#       device {
+#		vendor			"HP"
+#		product			"MSA2[02]12fc|MSA2012i"
+#		path_grouping_policy	multibus
+#		path_checker		tur
+#		failback		immediate
+#               no_path_retry           18
+#		rr_min_io		100
+#	}
+#       device {
+#               vendor                  "HP"
+#               product                 "MSA2012sa|MSA23(12|24)(fc|i|sa)"
+#               path_grouping_policy    group_by_prio
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               path_checker            tur
+#		failback		immediate
+#               no_path_retry           18
+#		rr_min_io		100
+#       }
+#       device {
+#               vendor                  "HP"
+#               product                 "HSVX700"
+#               path_grouping_policy    group_by_prio
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#		hardware_handler	"1 alua"
 #               path_checker            tur
 #		failback		immediate
 #               no_path_retry           12
 #		rr_min_io		100
-#        }
+#       }
 #       device {
 #		vendor			"(HITACHI|HP)"
 #		product			"OPEN-.*"
@@ -61,7 +101,6 @@
 #		path_checker		tur
 #		failback		immediate
 #               no_path_retry           12
-#		rr_min_io		100
 #	}
 #       device {
 #                vendor                 "HP"
@@ -80,12 +119,6 @@
 #		rr_min_io		100
 #       }
 #       device {
-#               vendor                  "COMPAQ"
-#               product                 "MSA1000"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
 #               vendor                  "DDN"
 #               product                 "SAN DataDirector"
 #               path_grouping_policy    multibus
--- multipath-tools/libmultipath/hwtable.c	2009/01/13 22:26:37	1.16.2.14
+++ multipath-tools/libmultipath/hwtable.c	2009/01/15 22:47:36	1.16.2.15
@@ -13,8 +13,6 @@
 
 	r += store_hwe(hw, "3PARdata", "VV", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "APPLE*", "Xserve RAID ", MULTIBUS, DEFAULT_GETUID);
-	r += store_hwe(hw, "COMPAQ", "HSV110.*", GROUP_BY_SERIAL, DEFAULT_GETUID);
-	r += store_hwe(hw, "COMPAQ", "MSA1000", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "DDN", "SAN DataDirector", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "DEC", "HSG80", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "EMC", "SYMMETRIX", MULTIBUS,
@@ -35,16 +33,31 @@
 	                   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n",
 	                   "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0,
 	                   100);
-	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV(1|2).*", GROUP_BY_PRIO,
-	                   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n",
-	                   "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0,
+	r += store_hwe_ext(hw, "COMPAQ", "MSA|HSV1.0.*", GROUP_BY_PRIO,
+	                   DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
+	                   "1 hp_sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
 	                   100);
+	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV1[01]1|HSV2[01]0|HSV300",
+			   GROUP_BY_PRIO, DEFAULT_GETUID,
+			   "/sbin/mpath_prio_alua /dev/%n", "0", "0", "tur",
+			   -FAILBACK_IMMEDIATE, NULL, 12, 0, 100);
+	r += store_hwe_ext(hw, "HP", "MSA2[02]12fc|MSA2012i", MULTIBUS, DEFAULT_GETUID,
+			   NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 18,
+			   0, 100);
+        r += store_hwe_ext(hw, "HP", "MSA2012sa|MSA23(12|24)(fc|i|sa)",
+			   GROUP_BY_PRIO, DEFAULT_GETUID,
+			   "/sbin/mpath_prio_alua /dev/%n", "0", "0", "tur",
+			   -FAILBACK_IMMEDIATE, NULL, 18, 0, 100);
+        r += store_hwe_ext(hw, "HP", "HSVX700",
+			   GROUP_BY_PRIO, DEFAULT_GETUID,
+			   "/sbin/mpath_prio_alua /dev/%n", "1 alua", "0",
+			   "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0, 100);
 	r += store_hwe_ext(hw, "HP", "MSA2000s*", MULTIBUS, "/sbin/cciss_id %n",
 	                   NULL, "0", "0", "cciss_tur", FAILBACK_UNDEF, NULL,
 	                   12, 0, 0);
 	r += store_hwe_ext(hw, "(HITACHI|HP)", "OPEN-.*", MULTIBUS,
 		DEFAULT_GETUID, NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE,
-		NULL, 12, 0, 100);
+		NULL, 12, 0, 0);
         r += store_hwe_ext(hw, "HP", "*33[89]0*", MULTIBUS, DEFAULT_GETUID, NULL, "0", "0",
 		    "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO,
