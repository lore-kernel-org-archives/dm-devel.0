From: bmarzins@sourceware.org
Subject: multipath-tools ./Multipath-usage.txt ./multip ...
Date: 2 Dec 2008 20:24:25 -0000
Message-ID: <20081202202425.22877.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-12-02 20:24:24

Modified files:
	.              : Multipath-usage.txt multipath.conf.defaults 
	libmultipath   : dict.c hwtable.c 

Log message:
	Fix for a bunch of small bugs, 457776, 470896, and 439366. These are all changes
	to documentation files and default configurations.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Multipath-usage.txt.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.13&r2=1.5.4.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.8&r2=1.17.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.15&r2=1.20.2.16

--- multipath-tools/Multipath-usage.txt	2006/06/06 18:32:43	1.5
+++ multipath-tools/Multipath-usage.txt	2008/12/02 20:24:24	1.5.2.1
@@ -283,7 +283,7 @@
 
 For each path:
 
- \_ host:channel:id:lun devnode major:minor [path_status][dm_status_if_known]
+ \_ host:channel:id:lun devnode major:minor [dm_status_if_known][path_status]
 
 The dm status (dm_status_if_known) is like the path status
 (path_status), but from the kernel's point of view.  The dm status has two
--- multipath-tools/multipath.conf.defaults	2008/08/29 18:30:26	1.5.4.13
+++ multipath-tools/multipath.conf.defaults	2008/12/02 20:24:24	1.5.4.14
@@ -86,7 +86,7 @@
 #	}
 #	device {
 #		vendor			"HP"
-#		product			"MSA2[02]12*"
+#		product			"MSA2[02]12fc|MSA2012i"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/bin/true"    
 #		features		"0"
@@ -94,11 +94,39 @@
 #		path_grouping_policy	multibus 
 #		failback		immediate
 #		rr_weight		uniform
-#		no_path_retry		12
+#		no_path_retry		18
 #		rr_min_io		100
 #               path_checker            tur
 #        }
 #       device {
+#               vendor                  "HP"
+#               product                 "MSA2012sa|MSA23(12|24)(fc|i|sa)"
+#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               features                "0"
+#               hardware_handler        "0"
+#               path_grouping_policy    group_by_prio
+#               failback                immediate
+#               rr_weight               uniform
+#               no_path_retry           18
+#               rr_min_io               100
+#               path_checker            tur
+#        }
+#       device {
+#               vendor                  "HP"
+#               product                 "HSVX700"
+#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#               features                "0"
+#               hardware_handler        "1 alua"
+#               path_grouping_policy    group_by_prio
+#               failback                immediate
+#               rr_weight               uniform
+#               no_path_retry           12
+#               rr_min_io               100
+#               path_checker            tur
+#        }
+#       device {
 #		vendor			"HP"
 #		product			"A6189A"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
@@ -146,7 +174,7 @@
 #       device {
 #               vendor                  "DGC"
 #		product			".*"
-#		product_blacklist	"LUN_Z"
+#		product_blacklist	"LUNZ"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
 #		features		"1 queue_if_no_path"
--- multipath-tools/libmultipath/dict.c	2008/09/08 22:01:20	1.17.2.8
+++ multipath-tools/libmultipath/dict.c	2008/12/02 20:24:24	1.17.2.9
@@ -154,7 +154,7 @@
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 9 &&
+	if (strlen(buff) == 3 &&
 	    !strcmp(buff, "max"))
 		conf->max_fds = MAX_FDS_MAX;
 	else
--- multipath-tools/libmultipath/hwtable.c	2008/08/29 18:30:27	1.20.2.15
+++ multipath-tools/libmultipath/hwtable.c	2008/12/02 20:24:24	1.20.2.16
@@ -123,9 +123,9 @@
 		.checker_name  = TUR,
 	},
 	{
-		 /* HP MSA2000 product family */
+		 /* HP MSA2000 product family with old firmware */
 		.vendor        = "HP",
-		.product       = "MSA2[02]12*",
+		.product       = "MSA2[02]12fc|MSA2012i",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/bin/true",
 		.features      = DEFAULT_FEATURES,
@@ -134,11 +134,43 @@
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 12,
+		.no_path_retry = 18,
 		.minio         = 100,
 		.checker_name  = TUR,
 	},
 	{
+                 /* HP MSA2000 product family with new firmware */
+                .vendor        = "HP",
+                .product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)",
+                .getuid        = DEFAULT_GETUID,
+                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
+                .features      = DEFAULT_FEATURES,
+                .hwhandler     = DEFAULT_HWHANDLER,
+                .selector      = DEFAULT_SELECTOR,
+                .pgpolicy      = GROUP_BY_PRIO,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .rr_weight     = RR_WEIGHT_NONE,
+                .no_path_retry = 18,
+                .minio         = 100,
+                .checker_name  = TUR,
+        },
+	{
+                 /* HP SVSP */
+                .vendor        = "HP",
+                .product       = "HSVX700",
+                .getuid        = DEFAULT_GETUID,
+                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
+                .features      = DEFAULT_FEATURES,
+                .hwhandler     = "1 alua",
+                .selector      = DEFAULT_SELECTOR,
+                .pgpolicy      = GROUP_BY_PRIO,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .rr_weight     = RR_WEIGHT_NONE,
+                .no_path_retry = 12,
+                .minio         = 100,
+                .checker_name  = TUR,
+	}
+	{
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
