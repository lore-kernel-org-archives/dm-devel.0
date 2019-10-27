From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 7/8] dm: add zone open, close and finish support
Date: Sun, 27 Oct 2019 23:05:48 +0900
Message-ID: <20191027140549.26272-8-damien.lemoal@wdc.com>
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

Contains contributions from Matias Bjorling, Hans Holmberg and
Damien Le Moal.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-flakey.c | 7 +++----
 drivers/md/dm-linear.c | 2 +-
 drivers/md/dm.c        | 5 +++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 2900fbde89b3..76587e9af0ef 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -280,7 +280,7 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 
 	bio_set_dev(bio, fc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
 		bio->bi_iter.bi_sector =
 			flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -322,8 +322,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 	pb->bio_submitted = false;
 
-	/* Do not fail reset zone */
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (op_is_zone_mgmt(bio_op(bio)))
 		goto map_bio;
 
 	/* Are we alive ? */
@@ -384,7 +383,7 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (op_is_zone_mgmt(bio_op(bio)))
 		return DM_ENDIO_DONE;
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index ecefe6703736..97acafd48c85 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -90,7 +90,7 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio_set_dev(bio, lc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1a5e328c443a..bc143c1b2333 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1174,7 +1174,8 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
+ * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
+ * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1627,7 +1628,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
 		/* dec_pending submits any data associated with flush */
-	} else if (bio_op(bio) == REQ_OP_ZONE_RESET) {
+	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
 		ci.sector_count = 0;
 		error = __split_and_process_non_flush(&ci);
-- 
2.21.0
