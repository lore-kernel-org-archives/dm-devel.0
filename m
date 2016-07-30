From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 02/18] multipath-tools: Remove ONTAP IBM Nseries
	from hwtable
Date: Sat, 30 Jul 2016 02:28:10 +0200
Message-ID: <1469838506-15689-2-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 3e22714..73ba4ee 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -508,14 +508,6 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
 	},
-	{
-		/* IBM NSeries */
-		.vendor        = "IBM",
-		.product       = "Nseries.*",
-		.features      = "1 queue_if_no_path",
-		.minio         = 128,
-		.prio_name     = PRIO_ONTAP,
-	},
 	/* LSI/Engenio/NetApp RDAC family
 	 *
 	 * Maintainer : Sean Stewart
-- 
2.7.4
