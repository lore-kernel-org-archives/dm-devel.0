From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v5 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for
	nullblk zoned disks
Date: Thu,  5 Sep 2019 18:51:34 +0900
Message-ID: <20190905095135.26026-7-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
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
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Using the helper blk_queue_required_elevator_features(), set the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
queue of null_blk devices created with zoned mode enabled.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index b26a178d064d..b29b273690b0 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1695,6 +1695,8 @@ static int null_add_dev(struct nullb_device *dev)
 		blk_queue_chunk_sectors(nullb->q, dev->zone_size_sects);
 		nullb->q->limits.zoned = BLK_ZONED_HM;
 		blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, nullb->q);
+		blk_queue_required_elevator_features(nullb->q,
+						ELEVATOR_F_ZBD_SEQ_WRITE);
 	}
 
 	nullb->q->queuedata = nullb;
-- 
2.21.0
