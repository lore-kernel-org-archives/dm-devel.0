From: tang.wenjun3@zte.com.cn
Subject: [PATCH 17/94] multipath-tools: replace "." for real
	values in (COMPAQ|HP)/"(MSA|HSV)1.0"
Date: Fri, 14 Oct 2016 09:55:59 +0800
Message-ID: <1476410236-9368-17-git-send-email-tang.wenjun3@zte.com.cn>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

Exact devices are in drivers/scsi/scsi_dh.c

        {"COMPAQ", "MSA1000 VOLUME",    "hp_sw" },
        {"COMPAQ", "HSV110",            "hp_sw" },
        {"HP",     "HSV100",            "hp_sw"},

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9366829..eda30f6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -70,7 +70,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* MSA 1000/1500 and EVA 3000/5000, with old firmware */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.0",
+		.product       = "(MSA|HSV)1[01]0",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.8.1.windows.1
