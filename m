From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 01/18] multipath-tools: add KOVE/XPD to hwtable
Date: Sat, 30 Jul 2016 02:28:09 +0200
Message-ID: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Nick Russo <nick.russo@kove.net>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Info provided directly by the manufacturer - http://kove.net/xpd :

.vendor        = "KOVE",
.product       = "XPD",
.features      = DEFAULT_FEATURES,
.hwhandler     = DEFAULT_HWHANDLER,
.selector      = "round-robin 0",
.pgpolicy      = MULTIBUS,
.pgfailback    = -FAILBACK_IMMEDIATE,
.rr_weight     = RR_WEIGHT_NONE,
.no_path_retry = DEFAULT_NO_PATH_RETRY,
.minio         = DEFAULT_MINIO,
.minio_rq      = DEFAULT_MINIO_RQ,
.checker_name  = DIRECTIO,
.prio_name     = DEFAULT_PRIO,
.prio_args     = NULL,

Cc: Nick Russo <nick.russo@kove.net>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1efaeee..3e22714 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -771,6 +771,16 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = 30,
 		.minio         = 128,
 	},
+	/*
+	 * Kove
+	 */
+	{
+		.vendor        = "KOVE",
+		.product       = "XPD",
+		.selector      = "round-robin 0",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = DEFAULT_NO_PATH_RETRY,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
