From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/9] dm: update dm_process_bio() to split bio
	if in ->make_request_fn()
Date: Wed, 20 Feb 2019 16:44:28 -0500
Message-ID: <20190220214436.38476-2-snitzer@redhat.com>
References: <20190220214436.38476-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190220214436.38476-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Must call blk_queue_split() otherwise queue_limits for abnormal requests
(e.g. discard, writesame, etc) won't be imposed.

In addition, add dm_queue_split() to simplify DM specific splitting that
is needed for targets that impose ti->max_io_len.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 93 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 515e6af9bed2..7a774fcd0194 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1533,6 +1533,22 @@ static int __send_write_zeroes(struct clone_info *ci, struct dm_target *ti)
 	return __send_changing_extent_only(ci, ti, get_num_write_zeroes_bios(ti), false);
 }
 
+static bool is_abnormal_io(struct bio *bio)
+{
+	bool r = false;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_WRITE_ZEROES:
+		r = true;
+		break;
+	}
+
+	return r;
+}
+
 static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 				  int *result)
 {
@@ -1565,7 +1581,7 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	if (unlikely(__process_abnormal_io(ci, ti, &r)))
+	if (__process_abnormal_io(ci, ti, &r))
 		return r;
 
 	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
@@ -1601,13 +1617,6 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int error = 0;
 
-	if (unlikely(!map)) {
-		bio_io_error(bio);
-		return ret;
-	}
-
-	blk_queue_split(md->queue, &bio);
-
 	init_clone_info(&ci, md, map, bio);
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
@@ -1675,18 +1684,13 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
  * Optimized variant of __split_and_process_bio that leverages the
  * fact that targets that use it do _not_ have a need to split bios.
  */
-static blk_qc_t __process_bio(struct mapped_device *md,
-			      struct dm_table *map, struct bio *bio)
+static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
+			      struct bio *bio, struct dm_target *ti)
 {
 	struct clone_info ci;
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int error = 0;
 
-	if (unlikely(!map)) {
-		bio_io_error(bio);
-		return ret;
-	}
-
 	init_clone_info(&ci, md, map, bio);
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
@@ -1704,21 +1708,11 @@ static blk_qc_t __process_bio(struct mapped_device *md,
 		error = __send_empty_flush(&ci);
 		/* dec_pending submits any data associated with flush */
 	} else {
-		struct dm_target *ti = md->immutable_target;
 		struct dm_target_io *tio;
 
-		/*
-		 * Defend against IO still getting in during teardown
-		 * - as was seen for a time with nvme-fcloop
-		 */
-		if (WARN_ON_ONCE(!ti || !dm_target_is_valid(ti))) {
-			error = -EIO;
-			goto out;
-		}
-
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-		if (unlikely(__process_abnormal_io(&ci, ti, &error)))
+		if (__process_abnormal_io(&ci, ti, &error))
 			goto out;
 
 		tio = alloc_tio(&ci, ti, 0, GFP_NOIO);
@@ -1730,11 +1724,56 @@ static blk_qc_t __process_bio(struct mapped_device *md,
 	return ret;
 }
 
+static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struct bio **bio)
+{
+	unsigned len, sector_count;
+
+	sector_count = bio_sectors(*bio);
+	len = min_t(sector_t, max_io_len((*bio)->bi_iter.bi_sector, ti), sector_count);
+
+	if (sector_count > len) {
+		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
+
+		bio_chain(split, *bio);
+		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
+		generic_make_request(*bio);
+		*bio = split;
+	}
+}
+
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
+	blk_qc_t ret = BLK_QC_T_NONE;
+	struct dm_target *ti = md->immutable_target;
+
+	if (unlikely(!map)) {
+		bio_io_error(bio);
+		return ret;
+	}
+
+	if (!ti) {
+		ti = dm_table_find_target(map, bio->bi_iter.bi_sector);
+		if (unlikely(!ti || !dm_target_is_valid(ti))) {
+			bio_io_error(bio);
+			return ret;
+		}
+	}
+
+	/*
+	 * If in ->make_request_fn we need to use blk_queue_split(), otherwise
+	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
+	 * won't be imposed.
+	 */
+	if (current->bio_list) {
+		if (is_abnormal_io(bio))
+			blk_queue_split(md->queue, &bio);
+		else
+			dm_queue_split(md, ti, &bio);
+	}
+
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
-		return __process_bio(md, map, bio);
+		return __process_bio(md, map, bio, ti);
 	else
 		return __split_and_process_bio(md, map, bio);
 }
-- 
2.15.0
