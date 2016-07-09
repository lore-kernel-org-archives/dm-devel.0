From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: delete retain_hwhandler and
	detect_prio attributes when they are equal to default values
Date: Sat,  9 Jul 2016 02:48:47 +0200
Message-ID: <1468025327-9625-2-git-send-email-xose.vazquez@gmail.com>
References: <1468025327-9625-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468025327-9625-1-git-send-email-xose.vazquez@gmail.com>
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

    3          .retain_hwhandler = RETAIN_HWHANDLER_ON,
    3          .detect_prio   = DETECT_PRIO_ON,

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e5c3fef..b4656c7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -212,8 +212,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
-		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-		.detect_prio   = DETECT_PRIO_ON,
 	},
 	{
 		.vendor        = "EMC",
@@ -611,8 +609,6 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
-		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-		.detect_prio   = DETECT_PRIO_ON,
 	},
 	{
 		/* IBM NSeries */
@@ -815,8 +811,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.detect_prio   = DETECT_PRIO_ON,
-		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 	},
 	{
 		.vendor        = "STK",
-- 
2.7.4
