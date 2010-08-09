From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 9 Aug 2010 18:38:22 -0000
Message-ID: <20100809183822.11463.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Changes by:	bmarzins@sourceware.org	2010-08-09 18:38:21

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #562967
	
	It is now possible for all Symmetrix paths to go down on a NDU, so the config
	needs to set no_path_retry.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.20&r2=1.5.4.21
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.27&r2=1.20.2.28

--- multipath-tools/multipath.conf.defaults	2010/02/10 04:11:18	1.5.4.20
+++ multipath-tools/multipath.conf.defaults	2010/08/09 18:38:21	1.5.4.21
@@ -233,9 +233,10 @@
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    multibus
+#		no_path_retry		6
 #		rr_weight		uniform
 #		rr_min_io		1000
-#		path_checker		readsector0
+#		path_checker		tur
 #       }
 #      device {
 #               vendor                  "EMC"
--- multipath-tools/libmultipath/hwtable.c	2010/02/10 04:11:18	1.20.2.27
+++ multipath-tools/libmultipath/hwtable.c	2010/08/09 18:38:21	1.20.2.28
@@ -223,9 +223,9 @@
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 6,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = TUR,
 	},
 	{
 		.vendor        = "DGC",
