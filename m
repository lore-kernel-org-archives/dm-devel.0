From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.defaults
Date: 7 Dec 2006 15:53:45 -0000
Message-ID: <20061207155345.23810.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-12-07 15:53:44

Modified files:
	.              : multipath.conf.defaults 

Log message:
	Updated multipath.conf.defaults to match hwtable.c

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5&r2=1.5.2.1

--- multipath-tools/multipath.conf.defaults	2006/05/12 02:03:59	1.5
+++ multipath-tools/multipath.conf.defaults	2006/12/07 15:53:44	1.5.2.1
@@ -30,46 +30,40 @@
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
 #	}
 #       device {
+#		vendor			"APPLE*"
+#		product			"Xserve RAID "
+#               path_grouping_policy    multibus
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#	}
+#       device {
 #               vendor                  "COMPAQ"
 #               product                 "HSV110 \(C\)COMPAQ"
 #               path_grouping_policy    group_by_serial
 #               getuid_callout          "/sbin/scsi_id -g -u -s"
 #       }
 #       device {
-#               vendor                  "HP"
-#               product                 "HSV101"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"	
-#               path_checker            tur
-#               no_path_retry		60 
-#        }
-#       device {
 #               vendor                  "COMPAQ"
 #               product                 "HSV111 \(C\)COMPAQ"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_alua %d"      
 #               path_checker            tur
+#		failback		immediate
 #               no_path_retry           60 
+#		rr_min_io		100
 #       }
 #       device {
 #               vendor                  "HP"
-#               product                 "HSV200"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
-#               path_checker            tur
-#               no_path_retry           60 
-#        }
-#       device {
-#               vendor                  "HP"
-#               product                 "HSV210"
+#               product                 "HSV2[10]0"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_alua %d"      
 #               path_checker            tur
+#		failback		immediate
 #               no_path_retry           60 
+#		rr_min_io		100
 #        }
 #       device {
-#                vendor                 "HP"
-#                product                "OPEN-."
+#                vendor                 "{HITACHI|HP}"
+#                product                "OPEN-*"
 #                path_grouping_policy   multibus
 #                path_checker           tur
 #        }
@@ -86,6 +80,16 @@
 #               prio_callout            "/sbin/mpath_prio_alua %d"      
 #               path_checker            tur
 #       }
+#      device {
+#               vendor                  "HP"
+#               product                 "HSV101"
+#               path_grouping_policy    group_by_prio
+#               prio_callout            "/sbin/mpath_prio_alua %n"      
+#               path_checker            tur
+#		failback		immediate
+#               no_path_retry           60 
+#		rr_min_io		100
+#       }
 #       device {
 #               vendor                  "COMPAQ"
 #               product                 "MSA1000"
@@ -128,27 +132,9 @@
 #               path_grouping_policy    group_by_serial
 #               getuid_callout          "/sbin/scsi_id -g -u -s"
 #       }
-#       device {
-#               vendor                  "HITACHI"
-#               product                 "DF400"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "HITACHI"
-#               product                 "DF500"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "HITACHI"
-#               product                 "DF600"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
 #	device {
 #		vendor			"HITACHI"
-#		product			"CF600F*"
+#		product			"DF*"
 #		path_grouping_policy	group_by_prio
 #		prio_callout		"/sbin/mpath_prio_hds_modular %d"
 #		path_checker		"readsector0"
@@ -181,6 +167,48 @@
 #		path_checker		tur
 #	}
 #	device {
+#		vendor			"IBM"
+#		product			"2105*"
+#		path_grouping_policy	group_by_serial
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"1 queue_if_no_path"
+#		path_checker		tur
+#	}
+#      device {
+#               vendor                  "IBM"
+#               product                 "1750500"
+#               path_grouping_policy    group_by_prio
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_alua %d"      
+#		features		"1 queue_if_no_path"
+#               path_checker            tur
+#       }
+#	device {
+#		vendor			"IBM"
+#		product			"2107900"
+#		path_grouping_policy	group_by_serial
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"1 queue_if_no_path"
+#		path_checker		tur
+#	}
+#      device {
+#               vendor                  "IBM"
+#               product                 "2145"
+#               path_grouping_policy    group_by_prio
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_alua %d"      
+#		features		"1 queue_if_no_path"
+#               path_checker            tur
+#		failback		immediate
+#       }
+#	device {
+#		vendor			"IBM"
+#		product			"S/390 DASD ECKD"
+#		path_grouping_policy	multibus
+#		getuid_callout		"/sbin/dasdview -j /dev/%n"
+#		path_checker		directio
+#	}
+#	device {
 #		vendor			"NETAPP"
 #		product			"LUN"
 #		path_grouping_policy	group_by_prio
@@ -190,6 +218,17 @@
 #		path_checker		readsector0
 #	}
 #	device {
+#		vendor			"IBM"
+#		product			"Nseries"
+#		path_grouping_policy	group_by_prio
+#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		features		"1 queue_if_no_path"
+#		path_checker		readsector0
+#		failback		immediate
+#		rr_min_io		100
+#	}
+#	device {
 #		vendor			"Pillar"
 #		product			"Axiom 500"
 #		path_grouping_policy    group_by_prio
@@ -245,7 +284,7 @@
 #		vendor			"GNBD"
 #		product			"GNBD"
 #		path_grouping_policy	multibus
-#		getuid_callout		"/sbin/gnbd_import -U /block/%n"
+#		getuid_callout		"/sbin/gnbd_import -q -U /block/%n"
 #		path_checker		directio
 #	}
 #}
