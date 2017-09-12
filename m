From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Do not use bio_set_op_attrs()
Date: Tue, 12 Sep 2017 17:40:55 +0900
Message-ID: <20170912084055.11558-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This function is deprecated. Directly assign BIOs bi_opf field.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 70485de37b66..401c53e8195b 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -412,7 +412,7 @@ static struct dmz_mblock *dmz_fetch_mblock(struct dmz_metadata *zmd,
 	bio_set_dev(bio, zmd->dev->bdev);
 	bio->bi_private = mblk;
 	bio->bi_end_io = dmz_mblock_bio_end_io;
-	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);
+	bio->bi_opf = REQ_OP_READ | REQ_META | REQ_PRIO;
 	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
 	submit_bio(bio);
 
@@ -567,7 +567,7 @@ static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
 	bio_set_dev(bio, zmd->dev->bdev);
 	bio->bi_private = mblk;
 	bio->bi_end_io = dmz_mblock_bio_end_io;
-	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
+	bio->bi_opf = REQ_OP_WRITE | REQ_META | REQ_PRIO;
 	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
 	submit_bio(bio);
 }
@@ -587,7 +587,7 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, int op, sector_t block,
 
 	bio->bi_iter.bi_sector = dmz_blk2sect(block);
 	bio_set_dev(bio, zmd->dev->bdev);
-	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);
+	bio->bi_opf = op | REQ_META | REQ_PRIO | REQ_SYNC;
 	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
-- 
2.13.5
