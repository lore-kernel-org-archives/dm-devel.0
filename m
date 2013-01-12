From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 14/18] multipath: storagetek 6180 config
Date: Sat, 12 Jan 2013 00:04:51 -0600
Message-ID: <1357970695-3396-14-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6a8dfe3..6924a61 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1018,6 +1018,21 @@ static struct hwentry default_hw[] = {
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
-- 
1.8.0
