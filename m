From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 8/8] null_blk: add zone open, close,
	and finish support
Date: Sun, 27 Oct 2019 23:05:49 +0900
Message-ID: <20191027140549.26272-9-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Keith Busch <kbusch@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Ajay Joshi <ajay.joshi@wdc.com>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

From: Ajay Joshi <ajay.joshi@wdc.com>

Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
support to allow explicit control of zone states.

Contains contributions from Matias Bjorling, Hans Holmberg,
Keith Busch and Damien Le Moal.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 4e56b17ed3ef..02f41a3bc4cb 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -136,13 +136,14 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	return BLK_STS_OK;
 }
 
-static blk_status_t null_zone_reset(struct nullb_cmd *cmd, sector_t sector)
+static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
+				   sector_t sector)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	struct blk_zone *zone = &dev->zones[null_zone_no(dev, sector)];
 	size_t i;
 
-	switch (req_op(cmd->rq)) {
+	switch (op) {
 	case REQ_OP_ZONE_RESET_ALL:
 		for (i = 0; i < dev->nr_zones; i++) {
 			if (zone[i].type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -158,6 +159,29 @@ static blk_status_t null_zone_reset(struct nullb_cmd *cmd, sector_t sector)
 		zone->cond = BLK_ZONE_COND_EMPTY;
 		zone->wp = zone->start;
 		break;
+	case REQ_OP_ZONE_OPEN:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_EXP_OPEN;
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_CLOSED;
+		break;
+	case REQ_OP_ZONE_FINISH:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_FULL;
+		zone->wp = zone->start + zone->len;
+		break;
 	default:
 		return BLK_STS_NOTSUPP;
 	}
@@ -172,7 +196,10 @@ blk_status_t null_handle_zoned(struct nullb_cmd *cmd, enum req_opf op,
 		return null_zone_write(cmd, sector, nr_sectors);
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
-		return null_zone_reset(cmd, sector);
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		return null_zone_mgmt(cmd, op, sector);
 	default:
 		return BLK_STS_OK;
 	}
-- 
2.21.0
