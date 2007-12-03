From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 3 Dec 2007 18:42:16 -0000
Message-ID: <20071203184216.5829.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-12-03 18:42:15

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #304481. Update hardware table with latest HP StorageWorks
	parameters for RHEL4.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.2&r2=1.16.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.8&r2=1.5.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.12&r2=1.16.2.13

--- multipath-tools/multipath.conf.annotated	2007/10/19 21:41:56	1.16.2.2
+++ multipath-tools/multipath.conf.annotated	2007/12/03 18:42:15	1.16.2.3
@@ -11,7 +11,7 @@
 #	#
 #	# name    : udev_dir
 #	# desc    : directory where udev creates its device nodes
-#	# default : /udev
+#	# default : /dev
 #	#
 #	udev_dir	/dev
 #
@@ -67,7 +67,17 @@
 #	#           exploitable prio value for example. "none" is a valid value
 #	# default : (null)
 #	#
-#	#prio_callout	"/bin/true"
+#	prio_callout	"/bin/true"
+#
+#	#
+#	# name    : features
+#	# scope   : multipath
+#	# desc    : The default extra features of multipath devices. The
+#	#           only existing feature currently is queue_if_no_path.
+#	# values  : "1 queue_if_no_path"
+#	# default : (null)
+#	#
+#	features	"1 queue_if_no_path"
 #
 #	#
 #	# name    : path_checker
@@ -79,6 +89,17 @@
 #	path_checker	readsector0
 #
 #	#
+#	# name    : failback
+#	# scope   : multipathd
+#	# desc    : tell the daemon to manage path group failback, or not to.
+#	#	    0 means immediate failback, values >0 means deffered
+#	#	    failback expressed in seconds.
+#	# values  : manual|immediate|n > 0
+#	# default : immediate
+#	#
+#	failback	manual
+#
+#	#
 #	# name    : rr_min_io
 #	# scope   : multipath
 #	# desc    : the number of IO to route to a path before switching
@@ -98,17 +119,6 @@
 #	rr_weight	priorities
 #
 #	#
-#	# name    : failback
-#	# scope   : multipathd
-#	# desc    : tell the daemon to manage path group failback, or not to.
-#	#	    0 means immediate failback, values >0 means deffered
-#	#	    failback expressed in seconds.
-#	# values  : manual|immediate|n > 0
-#	# default : immediate
-#	#
-#	failback	manual
-#
-#	#
 #	# name    : no_path_retry
 #	# scope   : multipath & multipathd
 #	# desc    : tell the number of retries until disable queueing, or
@@ -197,17 +207,14 @@
 #		#				 priority value
 #		#	    group_by_node_name = 1 priority group per target
 #		#				 node name
-#		# default : failover
 #		#
 #		path_grouping_policy	multibus
 #
 #		#
-#		#
 #		# name    : path_selector
 #		# desc    : the path selector algorithm to use for this mpath
 #		#           these algo are offered by the kernel mpath target
 #		# values  : "round-robin 0"
-#		# default : "round-robin 0"
 #		#
 #		path_selector		"round-robin 0"
 #
@@ -218,7 +225,6 @@
 #		#	    not to. 0 means immediate failback, values >0 means
 #		#	    deffered failback expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : immediate
 #		#
 #		failback		manual
 #
@@ -228,7 +234,6 @@
 #		# desc    : if set to priorities the multipath configurator will
 #		#	    assign path weights as "path prio * rr_min_io"
 #		# values  : priorities|uniform
-#		# default : uniform
 #		#
 #		rr_weight	priorities
 #
@@ -239,7 +244,6 @@
 #		#           or "fail" means immediate failure (no queueing),
 #		#           "queue" means never stop queueing
 #		# values  : queue|fail|n (>0)
-#		# default : (null)
 #		#
 #		no_path_retry  queue
 #	}
@@ -253,7 +257,7 @@
 ##
 ## name  : devices
 ## scope : multipath & multipathd
-## desc  : list of per storage controler settings
+## desc  : list of per storage controller settings
 ##	  overrides default settings (device_maps block)
 ##         overriden by per multipath settings (multipaths block)
 ##
@@ -261,7 +265,7 @@
 #	#
 #	# name  : device
 #	# scope : multipath & multipathd
-#	# desc  : settings for this specific storage controler
+#	# desc  : settings for this specific storage controller
 #	#
 #	device {
 #		#
@@ -280,14 +284,13 @@
 #		#	    blacklisted, the vendor, product, and bl_product
 #		#	    strings must all match, not just the vendor and
 #		#	    bl_product strings as in the upstream version.
-#		# default : (null)
 #		bl_product		"LUN_Z"
 #
 #		#
 #		# name    : path_grouping_policy
 #		# scope   : multipath
 #		# desc    : path grouping policy to apply to multipath hosted
-#		#           by this storage controler
+#		#           by this storage controller
 #		# values  : failover           = 1 path per priority group
 #		#           multibus           = all valid paths in 1 priority
 #		#				 group
@@ -297,7 +300,6 @@
 #		#				 priority value
 #		#	    group_by_node_name = 1 priority group per target
 #		#				 node name
-#		# default : failover
 #		#
 #		path_grouping_policy	multibus
 #
@@ -306,49 +308,33 @@
 #		# scope   : multipath
 #		# desc    : the program and args to callout to obtain a unique 
 #		#           path identifier. Absolute path required
-#		# default : /sbin/scsi_id -g -u -s
 #		#
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #
 #		#
-#		# name    : prio_callout
-#		# scope   : multipath
-#		# desc    : the program and args to callout to obtain a path 
-#		#           weight. Weights are summed for each path group to
-#		#	    determine the next PG to use case of failure.
-#		#	    "none" is a valid value.
-#		# default : no callout, all paths equals
+#		# name    : path_selector
+#		# desc    : the path selector algorithm to use for this mpath
+#		#           these algo are offered by the kernel mpath target
+#		# values  : "round-robin 0"
 #		#
-#		prio_callout          "/sbin/mpath_prio_balance_units %d"
+#		path_selector		"round-robin 0"
 #
 #		#
 #		# name    : path_checker
 #		# scope   : multipathd
 #		# desc    : path checking alorithm to use to check path state
-#		# values  : readsector0, tur
-#		# default : readsector0
+#		# values  : readsector0|tur|emc_clariion|hp_sw|directio
 #		#
 #		path_checker		readsector0
 #
 #		#
-#		# name    : path_selector
-#		# desc    : the path selector algorithm to use for this mpath
-#		#           these algo are offered by the kernel mpath target
-#		# values  : "round-robin 0"
-#		# default : "round-robin 0"
-#		#
-#		path_selector		"round-robin 0"
-#
-#		#
-#		# name    : failback
-#		# scope   : multipathd
-#		# desc    : tell the daemon to manage path group failback, or
-#		#	    not to. 0 means immediate failback, values >0 means
-#		#	    deffered failback expressed in seconds.
-#		# values  : manual|immediate|n > 0
-#		# default : immediate
+#		# name    : features
+#		# scope   : multipath
+#		# desc    : The default extra features of multipath devices. The
+#		#           only existing feature currently is queue_if_no_path.
+#		# values  : "1 queue_if_no_path"
 #		#
-#		failback		30
+#		features	"1 queue_if_no_path"
 #
 #		#
 #		# name    : hardware_handler
@@ -357,17 +343,35 @@
 #		#           perform hardware specific actions when switching
 #		#	    path groups or handling IO errors
 #		# values  : "0"|"1 emc"
-#		# default : "0"
 #		#
 #		hardware_handler "1 emc"
 #
 #		#
+#		# name    : prio_callout
+#		# scope   : multipath
+#		# desc    : the program and args to callout to obtain a path 
+#		#           weight. Weights are summed for each path group to
+#		#	    determine the next PG to use case of failure.
+#		#	    "none" is a valid value.
+#		#
+#		prio_callout          "/sbin/mpath_prio_balance_units %d"
+#
+#		#
+#		# name    : failback
+#		# scope   : multipathd
+#		# desc    : tell the daemon to manage path group failback, or
+#		#	    not to. 0 means immediate failback, values >0 means
+#		#	    deffered failback expressed in seconds.
+#		# values  : manual|immediate|n > 0
+#		#
+#		failback		30
+#
+#		#
 #		# name    : rr_weight
 #		# scope   : multipath
 #		# desc    : if set to priorities the multipath configurator will
 #		#	    assign path weights as "path prio * rr_min_io"
 #		# values  : priorities|uniform
-#		# default : uniform
 #		#
 #		rr_weight	priorities
 #
@@ -378,7 +382,6 @@
 #		#           or "fail" means immediate failure (no queueing),
 #		#           "queue" means never stop queueing
 #		# values  : queue|fail|n (>0)
-#		# default : (null)
 #		#
 #		no_path_retry  queue
 #	}
--- multipath-tools/multipath.conf.defaults	2007/10/19 21:41:56	1.5.2.8
+++ multipath-tools/multipath.conf.defaults	2007/12/03 18:42:15	1.5.2.9
@@ -20,6 +20,7 @@
 #devnode_blacklist {
 #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #       devnode "^hd[a-z]"
+#       devnode "^cciss!c[0-9]d[0-9]*"
 #}
 #
 #devices {
@@ -35,59 +36,47 @@
 #               path_grouping_policy    multibus
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
 #	}
+#	device {
+#		vendor			"HP"
+#		product			"MSA2000s*"
+#		getuid_callout		"/sbin/cciss_id %n"
+#		path_grouping_policy	multibus
+#		path_checker		cciss_tur
+#               no_path_retry           12
+#	}
 #       device {
-#               vendor                  "COMPAQ"
-#               product                 "HSV110 \(C\)COMPAQ"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "COMPAQ"
-#               product                 "HSV111 \(C\)COMPAQ"
+#               vendor                  "(COMPAQ|HP)"
+#               product                 "HSV(1|2).*"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_alua %d"      
 #               path_checker            tur
 #		failback		immediate
-#               no_path_retry           60 
+#               no_path_retry           12
 #		rr_min_io		100
-#       }
+#        }
 #       device {
-#               vendor                  "HP"
-#               product                 "HSV2[10]0"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %d"      
-#               path_checker            tur
+#		vendor			"(HITACHI|HP)"
+#		product			"OPEN-.*"
+#		path_grouping_policy	multibus
+#		path_checker		tur
 #		failback		immediate
-#               no_path_retry           60 
+#               no_path_retry           12
 #		rr_min_io		100
-#        }
-#       device {
-#                vendor                 "{HITACHI|HP}"
-#                product                "OPEN-.*"
-#                path_grouping_policy   multibus
-#                path_checker           tur
-#        }
+#	}
 #       device {
 #                vendor                 "HP"
 #                product                "*33[89]0*"
 #                path_grouping_policy   multibus
 #                path_checker           tur
-#        }
-#      device {
+#	}
+#	device {
 #               vendor                  "HP"
 #               product                 "MSA VOLUME"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_alua %d"      
 #               path_checker            tur
-#       }
-#      device {
-#               vendor                  "HP"
-#               product                 "HSV101"
-#               path_grouping_policy    group_by_prio
-#               prio_callout            "/sbin/mpath_prio_alua %n"      
-#               path_checker            tur
 #		failback		immediate
-#               no_path_retry           60 
+#               no_path_retry           12
 #		rr_min_io		100
 #       }
 #       device {
@@ -143,12 +132,6 @@
 #	}
 #       device {
 #               vendor                  "HP"
-#               product                 "HSV110"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
-#       }
-#       device {
-#               vendor                  "HP"
 #               product                 "A6189A"
 #               path_grouping_policy    multibus
 #               getuid_callout          "/sbin/scsi_id -g -u -s"
--- multipath-tools/libmultipath/hwtable.c	2007/09/11 18:06:01	1.16.2.12
+++ multipath-tools/libmultipath/hwtable.c	2007/12/03 18:42:15	1.16.2.13
@@ -20,7 +20,6 @@
 	r += store_hwe(hw, "EMC", "SYMMETRIX", MULTIBUS,
 		       "/sbin/scsi_id -g -u -ppre-spc3-83 -s /block/%n");
 	r += store_hwe(hw, "FSC", "CentricStor", GROUP_BY_SERIAL, DEFAULT_GETUID);
-	r += store_hwe(hw, "HP", "HSV110", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "HP", "A6189A", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "IBM", "ProFibre 4000R", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SGI", "TP9100", MULTIBUS, DEFAULT_GETUID);
@@ -32,21 +31,20 @@
 	r + store_hwe_ext(hw, "GNBD", "GNBD", MULTIBUS,
         		  "/sbin/gnbd_import -q -U /block/%n", NULL, "0", "0",
 			  "directio", FAILBACK_UNDEF, NULL, 0, 0, 0);
-        r += store_hwe_ext(hw, "HP", "MSA VOLUME", GROUP_BY_PRIO, DEFAULT_GETUID,
-		   "/sbin/mpath_prio_alua %d", "0", "0", "tur", FAILBACK_UNDEF, NULL,
-		   0, 0, 0);
-	r += store_hwe_ext(hw, "HP", "HSV101", GROUP_BY_PRIO, DEFAULT_GETUID,
-		"/sbin/mpath_prio_alua %n", "0", "0", "tur",
-		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
-	r += store_hwe_ext(hw, "HP", "HSV2[10]0", GROUP_BY_PRIO, DEFAULT_GETUID,
-		"/sbin/mpath_prio_alua %n", "0", "0", "tur",
-		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
-	r += store_hwe_ext(hw, "COMPAQ", "HSV111", GROUP_BY_PRIO,
-		DEFAULT_GETUID, "/sbin/mpath_prio_alua %n", "0", "0", "tur",
-		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
-	r += store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-.*", MULTIBUS,
+        r += store_hwe_ext(hw, "HP", "MSA VOLUME", GROUP_BY_PRIO,
+	                   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n",
+	                   "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0,
+	                   100);
+	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV(1|2).*", GROUP_BY_PRIO,
+	                   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n",
+	                   "0", "0", "tur", -FAILBACK_IMMEDIATE, NULL, 12, 0,
+	                   100);
+	r += store_hwe_ext(hw, "HP", "MSA2000s*", MULTIBUS, "/sbin/cciss_id %n",
+	                   NULL, "0", "0", "cciss_tur", FAILBACK_UNDEF, NULL,
+	                   12, 0, 0);
+	r += store_hwe_ext(hw, "(HITACHI|HP)", "OPEN-.*", MULTIBUS,
 		DEFAULT_GETUID, NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE,
-		NULL, 60, 0, 100);
+		NULL, 12, 0, 100);
         r += store_hwe_ext(hw, "HP", "*33[89]0*", MULTIBUS, DEFAULT_GETUID, NULL, "0", "0",
 		    "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO,
