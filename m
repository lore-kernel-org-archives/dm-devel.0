From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/9] multipath-tools: reduce regex for DGC
	CLARiiON CX/AX and EMC VNX
Date: Tue, 21 Jun 2016 02:35:58 +0200
Message-ID: <1466469364-14446-3-git-send-email-xose.vazquez@gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
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

vendor="DGC" and product=".*" is tooooo broad.
Using same product labels as in drivers/scsi/scsi_dh.c

Field-tested with Clariion VNX7500.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 206d1fd..a8dc0de 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -267,8 +267,8 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* DGC CLARiiON CX/AX and EMC VNX */
-		.vendor        = "DGC",
-		.product       = ".*",
+		.vendor        = "^DGC",
+		.product       = "^RAID|^DISK|^VRAID",
 		.bl_product    = "LUNZ",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
-- 
2.5.5
