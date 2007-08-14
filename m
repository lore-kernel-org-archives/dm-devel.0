From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 14 Aug 2007 18:08:55 -0000
Message-ID: <20070814180855.5864.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-08-14 18:08:55

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : devmapper.c hwtable.c 

Log message:
	Fixed typos in the Multipath.conf.defaults file. Added some error messages, and
	added a default configuration for the DELL MD3000.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.4&r2=1.5.4.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.1&r2=1.22.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.4&r2=1.20.2.5

--- multipath-tools/multipath.conf.defaults	2007/06/19 18:12:15	1.5.4.4
+++ multipath-tools/multipath.conf.defaults	2007/08/14 18:08:54	1.5.4.5
@@ -6,7 +6,7 @@
 #	polling_interval 	5
 #	selector		"round-robin 0"
 #	path_grouping_policy	failover
-#	getuid_callout		"/sbin/scsi_id -g -u -s"
+#	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #	prio_callout		none
 #	path_checker		readsector0
 #	rr_min_io		1000
@@ -25,7 +25,7 @@
 #       device {
 #		vendor			"APPLE.*"
 #		product			"Xserve RAID"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -36,7 +36,7 @@
 #       device {
 #		vendor			"3PARdata"
 #		product			"VV"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -47,7 +47,7 @@
 #       device {
 #               vendor                  "(COMPAQ|HP)"
 #               product                 "MSA1.*"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"1 hp_sw"
 #               path_grouping_policy    multibus
@@ -58,7 +58,7 @@
 #       device {
 #               vendor                  "(COMPAQ|HP)"
 #               product                 "HSV(1|2).*"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %n"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -72,7 +72,7 @@
 #       device {
 #		vendor			"HP"
 #		product			"A6189A"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -83,7 +83,7 @@
 #       device {
 #		vendor			"(HITACHI|HP)"
 #		product			"OPEN-.*"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -95,7 +95,7 @@
 #       device {
 #               vendor                  "DDN"
 #               product                 "SAN DataDirector"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -106,7 +106,7 @@
 #       device {
 #               vendor                  "DEC"
 #               product                 "HSG80"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"1 hp_sw"
 #               path_grouping_policy    multibus
@@ -118,7 +118,7 @@
 #               vendor                  "DGC"
 #		product			".*"
 #		product_blacklist	"LUN_Z"
-#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"1 emc"
@@ -129,6 +129,17 @@
 #		rr_min_io		1000
 #		path_checker		emc_clariion
 #	}
+#	device {
+#		vendor                  "DELL"
+#               product                 "MD3000"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
+#		features		"0"
+#               hardware_handler        "1 rdac"
+#		path_grouping_policy	group_by_prio
+#               failback                manual
+#               path_checker            rdac
+#       }
 #       device {
 #               vendor                  "EMC"
 #               product                 "SYMMETRIX"
@@ -143,7 +154,7 @@
 #       device {
 #               vendor                  "FSC"
 #               product                 "CentricStor"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_serial
@@ -154,7 +165,7 @@
 #       device {
 #               vendor                  "HITACHI"
 #               product                 "DF.*"
-#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/sbin/mpath_prio_hds_modular %d"
 #		features		"0"
 #		hardware_handler	"0"
@@ -167,7 +178,7 @@
 #       device {
 #               vendor                  "IBM"
 #               product                 "ProFibre 4000R"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -178,7 +189,7 @@
 #       device {
 #               vendor                  "IBM"
 #               product                 "1742"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -191,7 +202,7 @@
 #       device {
 #               vendor                  "IBM"
 #               product                 "3526"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -204,7 +215,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"3542"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_serial
@@ -215,7 +226,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"2105(800|F20)"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_serial
@@ -226,7 +237,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1750500"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %d"	
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
@@ -239,7 +250,7 @@
 #       device {
 #               vendor                  "IBM"
 #               product                 "2107900"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -250,7 +261,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"2145"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"	
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
@@ -275,7 +286,7 @@
 #	device {
 #		vendor			"NETAPP"
 #		product			"LUN"
-#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
@@ -288,7 +299,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"Nseries.*"
-#		getuid_callout          "/sbin/scsi_id -g -u -s"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
@@ -301,7 +312,7 @@
 #	device {
 #		vendor			"Pillar"
 #		product			"Axiom 500"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %d"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -313,7 +324,7 @@
 #       device {
 #               vendor                  "SGI"
 #               product                 "TP9[13]00"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
@@ -324,7 +335,7 @@
 #       device {
 #               vendor                  "SGI"
 #               product                 "TP9[45]00"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -337,7 +348,7 @@
 #       device {
 #               vendor                  "STK"
 #               product                 "OPENstorage D280"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
 #		features		"0"
 #		hardware_handler	"0"
@@ -349,7 +360,7 @@
 #       device {
 #               vendor                  "SUN"
 #               product                 "(StorEdge 3510|T4)"
-#		getuid_callout		"/sbin/scsi_id -g -u -s"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
--- multipath-tools/libmultipath/devmapper.c	2007/06/15 19:03:02	1.22.2.1
+++ multipath-tools/libmultipath/devmapper.c	2007/08/14 18:08:54	1.22.2.2
@@ -627,11 +627,15 @@
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		condlog(0, "can't get dm device list");
 		goto out;
+	}
 
-	if (!(names = dm_task_get_names(dmt)))
+	if (!(names = dm_task_get_names(dmt))){ 
+		condlog(0, "can't get dm device names\n");
 		goto out;
+	}
 
 	if (!names->dev) {
 		r = 0; /* this is perfectly valid */
@@ -646,8 +650,10 @@
 
 		mpp = alloc_multipath();
 
-		if (!mpp)
+		if (!mpp) {
+			condlog(0, "can't allocate multipath device\n");
 			goto out;
+		}
 
 		mpp->alias = STRDUP(names->name);
 
@@ -655,18 +661,25 @@
 			goto out1;
 
 		if (info > 0) {
-			if (dm_get_map(names->name, &mpp->size, mpp->params))
+			if (dm_get_map(names->name, &mpp->size, mpp->params)) {
+				condlog(0, "can't get multipath params\n");
 				goto out1;
+			}
 
-			if (dm_get_status(names->name, mpp->status))
+			if (dm_get_status(names->name, mpp->status)) {
+				condlog(0, "can't get multipath status\n");
 				goto out1;
+			}
 
 			dm_get_uuid(names->name, mpp->wwid);
 			dm_get_info(names->name, &mpp->dmi);
 		}
 
-		if (!vector_alloc_slot(mp))
+		if (!vector_alloc_slot(mp)) {
+			condlog(0, "can't allocate slot for multipath
+				    device\n");
 			goto out1;
+		}
 
 		vector_set_slot(mp, mpp);
 		mpp = NULL;
--- multipath-tools/libmultipath/hwtable.c	2007/05/08 20:15:58	1.20.2.4
+++ multipath-tools/libmultipath/hwtable.c	2007/08/14 18:08:54	1.20.2.5
@@ -525,6 +525,24 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	/*
+	 * DELL arrays
+	 */
+	{
+		.vendor        = "DELL",
+		.product       = "MD3000",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_MANUAL,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = READSECTOR0,
+	},
 	/* 
 	 * GNBD devices
 	 *
