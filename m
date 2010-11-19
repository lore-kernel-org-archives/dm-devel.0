From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: update default configurations
Date: Thu, 18 Nov 2010 21:33:18 -0600
Message-ID: <20101119033318.GB13763@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here are some default configuration changes that I've been sent.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c  |   21 ++++++++++++++++++---
 multipath.conf.defaults |   17 +++++++++++++++--
 2 files changed, 33 insertions(+), 5 deletions(-)

Index: multipath-tools-101104/libmultipath/hwtable.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/hwtable.c
+++ multipath-tools-101104/libmultipath/hwtable.c
@@ -232,7 +232,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = CCISS_TUR,
+		.checker_name  = TUR,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -975,13 +975,13 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SGI",
 		.product       = "IS.*",
 		.getuid        = DEFAULT_GETUID,
-		.features      = DEFAULT_FEATURES,
+		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.no_path_retry = 15,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -1031,6 +1031,21 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor        = "EUROLOGC",
+		.product       = "FC2502",
+		.getuid        ="/lib/udev/scsi_id --page=0x80 --whitelisted --device=/dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DEFAULT_CHECKER,
+		.prio_name     = DEFAULT_PRIO,
+	},
 	/*
 	 * Pivot3 RAIGE
 	 *
Index: multipath-tools-101104/multipath.conf.defaults
===================================================================
--- multipath-tools-101104.orig/multipath.conf.defaults
+++ multipath-tools-101104/multipath.conf.defaults
@@ -626,13 +626,13 @@
 #		vendor			"SGI"
 #		product			"IS.*"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
-#		features		"0"
+#		features		"2 pg_init_retries 50"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
 #		path_grouping_policy	group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
-#		no_path_retry		queue
+#		no_path_retry		15
 #		rr_min_io		1000
 #		path_checker		rdac
 #		prio			rdac
@@ -730,4 +730,17 @@
 #		prio			rdac
 #		prio_args		""
 #	}
+#	device {
+#		vendor			"EUROLOGC"
+#		product			"FC2502"
+#		getuid_callout		"/lib/udev/scsi_id --page=0x80 --whitelisted --device=/dev/%n"
+#		features                "0"
+#		hardware_handler        "0"
+#		path_selector           "round-robin 0"
+#		path_grouping_policy    group_by_prio
+#		rr_weight               uniform
+#		rr_min_io               1000
+#		path_checker		directio
+#		prio			const
+#	}
 #}
