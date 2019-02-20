From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 5/9] dm: improve noclone bio support
Date: Wed, 20 Feb 2019 16:44:32 -0500
Message-ID: <20190220214436.38476-6-snitzer@redhat.com>
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

Leverage fact that dm_queue_split() enables use of noclone support even
for targets that require additional splitting (via ti->max_io_len).

To achieve this move noclone processing from dm_make_request() to
dm_process_bio() and check if bio->bi_end_io is already set to
noclone_endio.  This also fixes dm_wq_work() to be able to support
noclone bios (because it calls dm_process_bio()).

While at it, clean up ->map() return processing to be comparable to
__map_bio() and add some code comments that explain why certain
conditionals exist to prevent the use of noclone.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 103 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 57919f211acc..d84735be6927 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1764,14 +1764,75 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 	 * If in ->make_request_fn we need to use blk_queue_split(), otherwise
 	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
 	 * won't be imposed.
+	 *
+	 * For normal READ and WRITE requests we benefit from upfront splitting
+	 * via dm_queue_split() because we can then leverage noclone support below.
 	 */
-	if (current->bio_list) {
+	if (current->bio_list && (bio->bi_end_io != noclone_endio)) {
+		/*
+		 * It is fine to use {blk,dm}_queue_split() before opting to use noclone
+		 * because any ->bi_private and ->bi_end_io will get saved off below.
+		 * Once noclone_endio() is called the bio_chain's endio will kick in.
+		 * - __split_and_process_bio() can split further, but any targets that
+		 *   require late _DM_ initiated splitting (e.g. dm_accept_partial_bio()
+		 *   callers) shouldn't set ti->no_clone.
+		 */
 		if (is_abnormal_io(bio))
 			blk_queue_split(md->queue, &bio);
 		else
 			dm_queue_split(md, ti, &bio);
 	}
 
+	if (dm_table_supports_noclone(map) &&
+	    (bio_op(bio) == REQ_OP_READ || bio_op(bio) == REQ_OP_WRITE) &&
+	    likely(!(bio->bi_opf & REQ_PREFLUSH)) &&
+	    likely(!bio_integrity(bio)) && /* integrity requires specialized processing */
+	    likely(!dm_stats_used(&md->stats))) { /* noclone doesn't support dm-stats */
+		int r;
+		struct dm_noclone *noclone;
+
+		/* Already been here if bio->bi_end_io is noclone_endio, reentered via dm_wq_work() */
+		if (bio->bi_end_io != noclone_endio) {
+			noclone = kmalloc_node(sizeof(*noclone), GFP_NOWAIT, md->numa_node_id);
+			if (unlikely(!noclone))
+				goto no_fast_path;
+
+			noclone->md = md;
+			noclone->start_time = jiffies;
+			noclone->orig_bi_end_io = bio->bi_end_io;
+			noclone->orig_bi_private = bio->bi_private;
+			bio->bi_end_io = noclone_endio;
+			bio->bi_private = noclone;
+		} else
+			noclone = bio->bi_private;
+
+		start_io_acct(md, bio);
+		r = ti->type->map(ti, bio);
+		switch (r) {
+		case DM_MAPIO_SUBMITTED:
+			break;
+		case DM_MAPIO_REMAPPED:
+			/* the bio has been remapped so dispatch it */
+			if (md->type == DM_TYPE_NVME_BIO_BASED)
+				ret = direct_make_request(bio);
+			else
+				ret = generic_make_request(bio);
+			break;
+		case DM_MAPIO_KILL:
+			bio_io_error(bio);
+			break;
+		case DM_MAPIO_REQUEUE:
+			bio->bi_status = BLK_STS_DM_REQUEUE;
+			noclone_endio(bio);
+			break;
+		default:
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		return ret;
+	}
+no_fast_path:
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
 	else
@@ -1798,48 +1859,8 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 		return ret;
 	}
 
-	if (dm_table_supports_noclone(map) &&
-	    (bio_op(bio) == REQ_OP_READ || bio_op(bio) == REQ_OP_WRITE) &&
-	    likely(!(bio->bi_opf & REQ_PREFLUSH)) &&
-	    !bio_flagged(bio, BIO_CHAIN) &&
-	    likely(!bio_integrity(bio)) &&
-	    likely(!dm_stats_used(&md->stats))) {
-		int r;
-		struct dm_noclone *noclone;
-		struct dm_target *ti = dm_table_find_target(map, bio->bi_iter.bi_sector);
-		if (unlikely(!dm_target_is_valid(ti)))
-			goto no_fast_path;
-		if (unlikely(bio_sectors(bio) > max_io_len(bio->bi_iter.bi_sector, ti)))
-			goto no_fast_path;
-		noclone = kmalloc_node(sizeof(*noclone), GFP_NOWAIT, md->numa_node_id);
-		if (unlikely(!noclone))
-			goto no_fast_path;
-		noclone->md = md;
-		noclone->start_time = jiffies;
-		noclone->orig_bi_end_io = bio->bi_end_io;
-		noclone->orig_bi_private = bio->bi_private;
-		bio->bi_end_io = noclone_endio;
-		bio->bi_private = noclone;
-		start_io_acct(md, bio);
-		r = ti->type->map(ti, bio);
-		ret = BLK_QC_T_NONE;
-		if (likely(r == DM_MAPIO_REMAPPED)) {
-			ret = generic_make_request(bio);
-		} else if (likely(r == DM_MAPIO_SUBMITTED)) {
-		} else if (r == DM_MAPIO_KILL) {
-			bio->bi_status = BLK_STS_IOERR;
-			noclone_endio(bio);
-		} else {
-			DMWARN("unimplemented target map return value: %d", r);
-			BUG();
-		}
-		goto put_table_ret;
-	}
-
-no_fast_path:
 	ret = dm_process_bio(md, map, bio);
 
-put_table_ret:
 	dm_put_live_table(md, srcu_idx);
 	return ret;
 }
-- 
2.15.0
