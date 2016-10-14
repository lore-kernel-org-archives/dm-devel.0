From: tang.wenjun3@zte.com.cn
Subject: [PATCH 22/94] multipath-tools: add IBM/1813 - DCS3860 to
	hwtable
Date: Fri, 14 Oct 2016 09:56:04 +0800
Message-ID: <1476410236-9368-22-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

It's a RDAC device, confirmed by the original manufacturer(NetApp).

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6ab0ed6..55ffc56 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -381,6 +381,19 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* DCS3860 */
+		.vendor        = "IBM",
+		.product       = "^1813",
+		.bl_product    = "Universal Xport",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.checker_name  = RDAC,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.prio_name     = PRIO_RDAC,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
+	{
 		/* DS3950 / DS4200 / DS4700 / DS5020 */
 		.vendor        = "IBM",
 		.product       = "^1814",
-- 
2.8.1.windows.1
