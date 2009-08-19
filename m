From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 19 Aug 2009 21:52:41 -0000
Message-ID: <20090819215241.13292.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-08-19 21:52:40

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipathd     : copy.c main.c 

Log message:
	added configuration for SUN 6540 storage arrays, and fixed missing arguments
	from condlog lines.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.14&r2=1.5.4.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.19&r2=1.20.2.20
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/copy.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.22&r2=1.69.2.23

--- multipath-tools/multipath.conf.defaults	2008/12/02 20:24:24	1.5.4.14
+++ multipath-tools/multipath.conf.defaults	2009/08/19 21:52:40	1.5.4.15
@@ -483,6 +483,21 @@
 #		rr_min_io		1000
 #               path_checker            tur
 #       }
+#	device {
+#		vendor                  "STK"
+#		product                 "FLEXLINE 380"
+#		product_blacklist       "Universal Xport"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
+#		features                "0"
+#		hardware_handler        "1 rdac"
+#		path_grouping_policy    group_by_prio
+#		failback                immediate
+#		rr_weight               uniform
+#		no_path_retry           queue
+#		rr_min_io               1000
+#		path_checker            rdac
+#	}
 #       device {
 #               vendor                  "SUN"
 #               product                 "(StorEdge 3510|T4)"
--- multipath-tools/libmultipath/hwtable.c	2009/06/19 22:10:53	1.20.2.19
+++ multipath-tools/libmultipath/hwtable.c	2009/08/19 21:52:40	1.20.2.20
@@ -698,6 +698,23 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 	},
+	{
+		/* SUN 6540 */
+		.vendor        = "STK",
+		.product       = "FLEXLINE 380",
+		.bl_product    = "Universal Xport",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
 	/*
 	 * SUN arrays
 	 *
--- multipath-tools/multipathd/Attic/copy.c	2009/08/18 21:12:01	1.5.2.2
+++ multipath-tools/multipathd/Attic/copy.c	2009/08/19 21:52:40	1.5.2.3
@@ -25,7 +25,7 @@
 
 	if (fdin < 0) {
 		if (errno == ENOENT)
-			condlog(3, "callout %s does not exist, ignoring");
+			condlog(3, "callout %s does not exist, ignoring", src);
 		else
 			condlog(0, "[copy.c] cannot open %s", src);
 		return -1;
--- multipath-tools/multipathd/main.c	2009/08/18 21:12:01	1.69.2.22
+++ multipath-tools/multipathd/main.c	2009/08/19 21:52:40	1.69.2.23
@@ -1339,7 +1339,7 @@
 	vector_foreach_slot (conf->binvec, bin,i) {
 		if ((fd = open(bin, O_RDONLY)) < 0) {
 			if (errno == ENOENT)
-				condlog(3, "callout %s does not exist, ignoring");
+				condlog(3, "callout %s does not exist, ignoring", bin);
 			else
 				condlog(0, "cannot open %s : %s", bin,
 					strerror(errno));
