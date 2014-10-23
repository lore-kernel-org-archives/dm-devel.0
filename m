From: Jose Castillo <jcastillo@redhat.com>
Subject: [PATCH] libmultipath: Add Dell 36xxi/f support to
	internal hardware table
Date: Thu, 23 Oct 2014 16:10:30 +0200
Message-ID: <1414073430-5495-1-git-send-email-jcastillo@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Yanqing Liu <Yanqing_Liu@Dell.com>
List-Id: dm-devel.ids

This patch adds support for Dell 36xxi and 36xxf arrays.

Signed-off-by: Jose Castillo <jcastillo@redhat.com>
---
 libmultipath/hwtable.c  | 30 ++++++++++++++++++++++++++++++
 multipath.conf.defaults | 26 ++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a9dde7f..bf2c2ca 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -772,6 +772,36 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
 	},
+	{
+		/* DELL MD36xxi */
+		.vendor        = "DELL",
+		.product       = "MD36xxi",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+		.prio_args     = NULL,
+	},
+	{
+		/* DELL MD36xxf */
+		.vendor        = "DELL",
+		.product       = "MD36xxf",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+		.prio_args     = NULL,
+	},
 	/*
 	 * NETAPP controller family
 	 *
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 654be97..f838f02 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -654,6 +654,32 @@
 #		no_path_retry 15
 #	}
 #	device {
+#		vendor "DELL"
+#		product "MD36xxi"
+#		product_blacklist "Universal Xport"
+#		path_grouping_policy "group_by_prio"
+#		path_checker "rdac"
+#		features "2 pg_init_retries 50"
+#		hardware_handler "1 rdac"
+#		prio "rdac"
+#		failback "immediate"
+#		rr_weight "uniform"
+#		no_path_retry 15
+#	}
+#	device {
+#		vendor "DELL"
+#		product "MD36xxf"
+#		product_blacklist "Universal Xport"
+#		path_grouping_policy "group_by_prio"
+#		path_checker "rdac"
+#		features "2 pg_init_retries 50"
+#		hardware_handler "1 rdac"
+#		prio "rdac"
+#		failback "immediate"
+#		rr_weight "uniform"
+#		no_path_retry 15
+#	}
+#	device {
 #		vendor "NETAPP"
 #		product "LUN.*"
 #		path_grouping_policy "group_by_prio"
-- 
1.9.3
