From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] multipath: storagetek 6180 config
Date: Thu, 10 Jan 2013 14:54:32 -0600
Message-ID: <20130110205432.GZ19059@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

New StorageTek default config.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: multipath-tools-120821/libmultipath/hwtable.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/hwtable.c
+++ multipath-tools-120821/libmultipath/hwtable.c
@@ -1120,6 +1120,21 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
 	},
+	/* StorageTek 6180 */
+	{
+		.vendor        = "SUN",
+		.product       = "SUN_6180",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.minio_rq      = DEFAULT_MINIO_RQ,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
 	/* LSI/Engenio/NetApp E-Series RDAC storage */
 	{
 		.vendor        = "(LSI|ENGENIO)",
