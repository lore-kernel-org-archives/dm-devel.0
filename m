From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 19 Dec 2006 22:51:32 -0000
Message-ID: <20061219225132.6981.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-12-19 22:51:32

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #219804. multipath no longer blacklists s/390 DASDs by default.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.1&r2=1.20.2.2

--- multipath-tools/multipath.conf.defaults	2006/05/12 02:03:59	1.5
+++ multipath-tools/multipath.conf.defaults	2006/12/19 22:51:31	1.5.4.1
@@ -11,7 +11,7 @@
 #	path_checker		readsector0
 #	rr_min_io		1000
 #	rr_weight		uniform
-#	failback		immediate
+#	failback		manual
 #	no_path_retry		fail
 #	user_friendly_names	no
 #}
@@ -24,228 +24,348 @@
 #
 #devices {
 #       device {
+#		vendor			"APPLE.*"
+#		product			"Xserve RAID"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
+#	}
+#       device {
 #		vendor			"3PARdata"
 #		product			"VV"
-#               path_grouping_policy    multibus
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #	}
 #       device {
-#               vendor                  "COMPAQ"
-#               product                 "HSV110 \(C\)COMPAQ"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#               vendor                  "(COMPAQ|HP)"
+#               product                 "MSA1.*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"1 hp_sw"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		hp_sw
 #       }
 #       device {
-#               vendor                  "HP"
-#               product                 "HSV101"
-#               path_grouping_policy    group_by_prio
+#               vendor                  "(COMPAQ|HP)"
+#               product                 "HSV(1|2).*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
 #               prio_callout            "/sbin/mpath_prio_alua %d"	
-#               path_checker            tur
-#               no_path_retry		60 
-#        }
-#       device {
-#               vendor                  "COMPAQ"
-#               product                 "HSV111 \(C\)COMPAQ"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
-#               path_checker            tur
-#               no_path_retry           60 
-#       }
-#       device {
-#               vendor                  "HP"
-#               product                 "HSV200"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
-#               path_checker            tur
-#               no_path_retry           60 
-#        }
-#       device {
-#               vendor                  "HP"
-#               product                 "HSV210"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
+#		failback		immediate
+#		rr_weight		uniform
+#               no_path_retry		60 
+#		rr_min_io		1000
 #               path_checker            tur
-#               no_path_retry           60 
 #        }
 #       device {
-#                vendor                 "HP"
-#                product                "OPEN-."
-#                path_grouping_policy   multibus
-#                path_checker           tur
-#        }
-#       device {
-#                vendor                 "HP"
-#                product                "*33[89]0*"
-#                path_grouping_policy   multibus
-#                path_checker           tur
-#        }
-#      device {
-#               vendor                  "HP"
-#               product                 "MSA VOLUME"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
-#               path_checker            tur
-#       }
+#		vendor			"HP"
+#		product			"A6189A"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
+#	}
 #       device {
-#               vendor                  "COMPAQ"
-#               product                 "MSA1000"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
+#		vendor			"(HITACHI|HP)"
+#		product			"OPEN-.*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		100
+#		path_checker		tur
+#	}
 #       device {
 #               vendor                  "DDN"
 #               product                 "SAN DataDirector"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
 #               vendor                  "DEC"
 #               product                 "HSG80"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"1 hp_sw"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		hp_sw
 #       }
 #       device {
 #               vendor                  "DGC"
-#		product			"*"
+#		product			".*"
 #		bl_product		"LUN_Z"
-#		path_grouping_policy	group_by_prio
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
-#		hardware_handler	"1 emc"
 #		features		"1 queue_if_no_path"
-#		path_checker		emc_clariion
+#		hardware_handler	"1 emc"
+#		path_grouping_policy	group_by_prio
 #		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		60
+#		rr_min_io		1000
+#		path_checker		emc_clariion
 #	}
 #       device {
 #               vendor                  "EMC"
 #               product                 "SYMMETRIX"
-#               path_grouping_policy    multibus
 #               getuid_callout          "/sbin/scsi_id -g -u -ppre-spc3-83 -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
 #               vendor                  "FSC"
 #               product                 "CentricStor"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
 #               vendor                  "HITACHI"
-#               product                 "DF400"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#               product                 "DF.*"
+#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		prio_callout		"/sbin/mpath_prio_hds_modular %d"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
-#               vendor                  "HITACHI"
-#               product                 "DF500"
+#               vendor                  "IBM"
+#               product                 "ProFibre 4000R"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
-#               vendor                  "HITACHI"
-#               product                 "DF600"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#	device {
-#		vendor			"HITACHI"
-#		product			"CF600F*"
-#		path_grouping_policy	group_by_prio
-#		prio_callout		"/sbin/mpath_prio_hds_modular %d"
-#		path_checker		"readsector0"
+#               vendor                  "IBM"
+#               product                 "1742"
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
 #		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
 #	}
 #       device {
-#               vendor                  "HP"
-#               product                 "HSV110"
+#               vendor                  "IBM"
+#               product                 "3526"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"3542"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "HP"
-#               product                 "A6189A"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"2105(800|F20)"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_serial
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1750500"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_alua %d"	
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
+#	}
 #       device {
 #               vendor                  "IBM"
-#               product                 "ProFibre 4000R"
+#               product                 "2107900"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
 #               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
 #       }
 #	device {
 #		vendor			"IBM"
-#		product			"3542"
-#		path_grouping_policy	group_by_serial
+#		product			"2145"
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
-#		path_checker		tur
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"	
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"S/390 DASD ECKD"
+#		getuid_callout		"/sbin/dasd_id /dev/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            directio
 #	}
 #	device {
 #		vendor			"NETAPP"
 #		product			"LUN"
+#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
 #		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		128
+#		path_checker		readsector0
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"Nseries.*"
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
 #		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
 #		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		128
 #		path_checker		readsector0
 #	}
 #	device {
 #		vendor			"Pillar"
 #		product			"Axiom 500"
-#		path_grouping_policy    group_by_prio
-#		getuid_callout          "/sbin/scsi_id -g -u -s"
-#		prio_callout		"/sbin/mpath_prio_alua %d"
-#		path_checker		tur
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_alua %d"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
 #	}
 #       device {
 #               vendor                  "SGI"
-#               product                 "TP9100"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "SGI"
-#               product                 "TP9300"
+#               product                 "TP9[13]00"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #       device {
 #               vendor                  "SGI"
-#               product                 "TP9400"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#		path_checker		tur
-#	}
-#       device {
-#               vendor                  "SGI"
-#               product                 "TP9500"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#               product                 "TP9[45]00"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
 #               path_checker            tur
-#       }
+#	}
 #       device {
 #               vendor                  "STK"
 #               product                 "OPENstorage D280"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "SUN"
-#               product                 "StorEdge 3510"
-#               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
 #       }
 #       device {
 #               vendor                  "SUN"
-#               product                 "T4"
+#               product                 "(StorEdge 3510|T4)"
+#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		features		"0"
+#		hardware_handler	"0"
 #               path_grouping_policy    multibus
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
 #       }
 #	device {
 #		vendor			"GNBD"
 #		product			"GNBD"
-#		path_grouping_policy	multibus
-#		getuid_callout		"/sbin/gnbd_import -U /block/%n"
+#		getuid_callout		"/sbin/gnbd_import -q -U /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
 #		path_checker		directio
 #	}
 #}
--- multipath-tools/libmultipath/hwtable.c	2006/12/14 23:44:33	1.20.2.1
+++ multipath-tools/libmultipath/hwtable.c	2006/12/19 22:51:32	1.20.2.2
@@ -76,7 +76,7 @@
 	},
 	{
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.*",
+		.product       = "MSA1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -90,8 +90,23 @@
 		.checker_name  = HP_SW,
 	},
 	{
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "HSV(1|2).*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 60,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
+	{
 		.vendor        = "HP",
-		.product       = "(HSV2.*|A6189A)",
+		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -198,11 +213,11 @@
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.minio         = 100,
+		.checker_name  = TUR,
 	},
 	{
 		.vendor        = "HITACHI",
@@ -356,7 +371,6 @@
 		/* IBM S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
-		.bl_product       = "S/390.*",
 		.getuid        = "/sbin/dasd_id /dev/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
