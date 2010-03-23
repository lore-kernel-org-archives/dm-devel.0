From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add some default configurations.
Date: Tue, 23 Mar 2010 14:48:43 -0500
Message-ID: <20100323194843.GD23952@ether.msp.redhat.com>
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

This patch adds some default configurations that have been requested.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++++--
 multipath.conf.defaults |   46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 2 deletions(-)

Index: multipath-tools-100322/libmultipath/hwtable.c
===================================================================
--- multipath-tools-100322.orig/libmultipath/hwtable.c
+++ multipath-tools-100322/libmultipath/hwtable.c
@@ -282,6 +282,21 @@ static struct hwentry default_hw[] = {
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
 	},
+	{
+		.vendor        = "EMC",
+		.product       = "Invista",
+		.bl_product    = "LUNZ",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 5,
+		.minio         = DEFAULT_MINIO,
+		.prio_name     = DEFAULT_PRIO,
+	},
 	/*
 	 * Fujitsu controller family
 	 *
@@ -441,6 +456,21 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+		.vendor        = "IBM",
+		.product       = "1745|1746",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
 	    /* IBM DS4700 */
 		.vendor        = "IBM",
 		.product       = "1814",
@@ -677,12 +707,13 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.getuid        = DEFAULT_GETUID,
-		.features      = "1 queue_if_no_path",
+		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -692,12 +723,13 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD3000i",
 		.getuid        = DEFAULT_GETUID,
-		.features      = "1 queue_if_no_path",
+		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -979,6 +1011,22 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
+	{
+		.vendor        = "STK",
+		.product       = "FLEXLINE 380",
+		.bl_product    = "Universal Xport",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
 	/*
 	 * EOL
 	 */
Index: multipath-tools-100322/multipath.conf.defaults
===================================================================
--- multipath-tools-100322.orig/multipath.conf.defaults
+++ multipath-tools-100322/multipath.conf.defaults
@@ -223,6 +223,21 @@
 #		path_checker            tur
 #	}
 #	device {
+#		vendor			"EMC"
+#		product			"Invista"
+#		product_blacklist	"LUNZ"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --page=pre-spc3-83 --device=/dev/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		no_path_retry		5
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
 #		vendor			"FSC"
 #		product			"CentricStor"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
@@ -307,6 +322,21 @@
 #	}
 #	device {
 #		vendor			"IBM"
+#		product			"1745|1746"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
+#		features		"2 pg_init_retries 50"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
 #		product			"1814"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
@@ -600,4 +630,20 @@
 #		path_checker		rdac
 #		prio			rdac
 #	}
+#	device {
+#		vendor			"STK"
+#		product			"FLEXLINE 380"
+#		product_blacklist	"Universal Xport"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
 #}
