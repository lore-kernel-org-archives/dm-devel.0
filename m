From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Remove ONTAP IBM Nseries from
	hwtable
Date: Mon,  1 Aug 2016 22:09:37 +0200
Message-ID: <1470082177-3938-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Originally from Martin George <marting@netapp.com>

He wrote:
"Even earlier, the NetApp IBM Nseries product line never used a
VID/PID of "IBM" & "Nseries" respectively. Instead, it always
used the same VID/PID of "NETAPP" & "LUN" itself, similar to the
ONTAP product line. So this piece of code was redundant from the
beginning itself."

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin George <marting@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 837fa3f..81ed437 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -576,16 +576,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ONTAP,
 	},
 	{
-		/* IBM NSeries */
-		.vendor        = "IBM",
-		.product       = "Nseries.*",
-		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.minio         = 128,
-		.prio_name     = PRIO_ONTAP,
-	},
-	{
 		/*
 		 * RDAC family
 		 *
-- 
2.7.4
