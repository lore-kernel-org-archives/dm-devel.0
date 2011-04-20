From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] multipath-tools: Add new NEC diskarray to
 internal hardware table
Date: Wed, 20 Apr 2011 18:20:09 +0900
Message-ID: <4DAEA549.70702@ce.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Hi Christophe,

This patch adds an entry for new NEC Storage M series to internal hwtable.

Could you include this change in your tree?
    
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 libmultipath/hwtable.c  |   18 ++++++++++++++++++
 multipath.conf.defaults |   14 ++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e6888e..c02caa8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1031,6 +1031,24 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
 	},
+	/* NEC Storage M Series */
+	{
+		.vendor        = "NEC",
+		.product       = "DISK ARRAY",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 alua",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.minio_rq      = DEFAULT_MINIO_RQ,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+		.prio_args     = NULL,
+	},
 	/*
 	 * STK arrays
 	 *
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index f8ca0a2..6daf812 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -743,4 +743,18 @@
 #		path_checker		directio
 #		prio			const
 #	}
+#	device {
+#		vendor                  "NEC"
+#		product                 "DISK ARRAY"
+#		getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
+#		features                "0"
+#		hardware_handler        "1 alua"
+#		path_selector           "round-robin 0"
+#		path_grouping_policy    group_by_prio
+#		failback                immediate
+#		rr_weight               uniform
+#		rr_min_io               1000
+#		path_checker            tur
+#		prio                    alua
+#	}
 #}
