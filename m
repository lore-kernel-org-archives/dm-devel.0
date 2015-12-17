From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/6] block: Introduce blk_round_sect_down()
Date: Thu, 17 Dec 2015 12:39:40 +0100
Message-ID: <56729EFC.1030400@sandisk.com>
References: <56729ECF.50906@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56729ECF.50906@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Move the code for rounding down a sector into a new function.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..2f4c6b2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -26,6 +26,26 @@ static void bio_batch_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+/*
+ * Return the largest number that is less than or equal to @s and for which
+ * the remainder of the division by @granularity is @alignment.
+ */
+static sector_t blk_round_sect_down(sector_t s, u32 granularity, u32 alignment)
+{
+	sector_t tmp = s, res = s;
+	u32 remainder;
+
+	WARN_ON_ONCE(alignment >= granularity);
+
+	remainder = sector_div(tmp, granularity);
+	if (remainder == alignment)
+		return res;
+	res -= remainder - alignment;
+	if (remainder < alignment)
+		res -= granularity;
+	return min(res, s);
+}
+
 /**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
@@ -73,7 +93,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	blk_start_plug(&plug);
 	while (nr_sects) {
 		unsigned int req_sects;
-		sector_t end_sect, tmp;
+		sector_t end_sect;
 
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
@@ -89,12 +109,10 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		 * misaligned, stop the discard at the previous aligned sector.
 		 */
 		end_sect = sector + req_sects;
-		tmp = end_sect;
-		if (req_sects < nr_sects &&
-		    sector_div(tmp, granularity) != alignment) {
-			end_sect = end_sect - alignment;
-			sector_div(end_sect, granularity);
-			end_sect = end_sect * granularity + alignment;
+		if (req_sects < nr_sects) {
+			end_sect = blk_round_sect_down(end_sect, granularity,
+						       alignment);
+			WARN_ON_ONCE(end_sect < sector);
 			req_sects = end_sect - sector;
 		}
 
-- 
2.1.4
