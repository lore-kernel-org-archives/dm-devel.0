From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 05/15] multipath-tools: replace "." for real
	values in (COMPAQ|HP)/"(MSA|HSV)1.0"
Date: Wed, 10 Aug 2016 18:20:28 +0200
Message-ID: <1470846038-6590-5-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

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
index e0c33dc..c101b02 100644
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
2.7.4
