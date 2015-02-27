From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] dm-io: deal with wandering queue limits when
 handling REQ_DISCARD and REQ_WRITE_SAME
Date: Fri, 27 Feb 2015 10:44:38 -0800
Message-ID: <20150227184438.GF5519@birch.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, agk@redhat.com, Srinivas Eeda <srinivas.eeda@oracle.com>
List-Id: dm-devel.ids

Since it's apparently possible that the queue limits for discard and
write same can change while the upper level command is being sliced
and diced, fix up both of them (a) to reject IO if the special command
is unsupported at the start of the function and (b) read the limits
once and let the commands error out on their own if the status happens
to change.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-io.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 37de017..d66cfb2 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -289,9 +289,15 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	struct request_queue *q = bdev_get_queue(where->bdev);
 	unsigned short logical_block_size = queue_logical_block_size(q);
 	sector_t num_sectors;
-
-	/* Reject unsupported discard requests */
-	if ((rw & REQ_DISCARD) && !blk_queue_discard(q)) {
+	unsigned int special_cmd_max_sectors;
+
+	/* Reject unsupported discard and write same requests */
+	if (rw & REQ_DISCARD)
+		special_cmd_max_sectors = q->limits.max_discard_sectors;
+	else if (rw & REQ_WRITE_SAME)
+		special_cmd_max_sectors = q->limits.max_write_same_sectors;
+	if ((rw & (REQ_DISCARD | REQ_WRITE_SAME)) &&
+	    special_cmd_max_sectors == 0) {
 		dec_count(io, region, -EOPNOTSUPP);
 		return;
 	}
@@ -317,7 +323,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (rw & REQ_DISCARD) {
-			num_sectors = min_t(sector_t, q->limits.max_discard_sectors, remaining);
+			num_sectors = min_t(sector_t, special_cmd_max_sectors,
+					    remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
 		} else if (rw & REQ_WRITE_SAME) {
@@ -326,7 +333,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 			 */
 			dp->get_page(dp, &page, &len, &offset);
 			bio_add_page(bio, page, logical_block_size, offset);
-			num_sectors = min_t(sector_t, q->limits.max_write_same_sectors, remaining);
+			num_sectors = min_t(sector_t, special_cmd_max_sectors,
+					    remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 
 			offset = 0;
