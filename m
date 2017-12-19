From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 5/5] dm mpath: skip calls to end_io_bio if using NVMe bio-based and round-robin
Date: Tue, 19 Dec 2017 16:05:46 -0500
Message-ID: <20171219210546.65928-6-snitzer@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Add a 'skip_endio_hook' flag member to 'struct dm_target' that if set
instructs calls to .end_io (or .rq_end_io) to be skipped.

NVMe bio-based doesn't use multipath_end_io_bio() for anything other
than updating the path-selector.  So it can be avoided completely if the
round-robin path selector is used (because round-robin doesn't have an
end_io hook).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         | 24 ++++++++++++++++++++----
 drivers/md/dm-rq.c            |  8 ++++----
 drivers/md/dm.c               |  7 ++++---
 include/linux/device-mapper.h |  6 ++++++
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0ed407e150f5..5b4c88c1980f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1186,6 +1186,21 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	/*
+	 * If NVMe bio-based and all path selectors don't provide .end_io hook:
+	 * inform DM core that there is no need to call this target's end_io hook.
+	 */
+	if (m->queue_mode == DM_TYPE_NVME_BIO_BASED) {
+		struct priority_group *pg;
+		if (!m->nr_priority_groups)
+			goto finish;
+		list_for_each_entry(pg, &m->priority_groups, list) {
+			if (pg->ps.type->end_io)
+				goto finish;
+		}
+		ti->skip_end_io_hook = true;
+	}
+finish:
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
@@ -1671,11 +1686,12 @@ static void multipath_failover_rq(struct request *rq)
 	unsigned long flags;
 
 	if (pgpath) {
-		struct path_selector *ps = &pgpath->pg->ps;
-
-		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, blk_rq_bytes(rq));
+		if (!ti->skip_end_io_hook) {
+			struct path_selector *ps = &pgpath->pg->ps;
 
+			if (ps->type->end_io)
+				ps->type->end_io(ps, &pgpath->path, blk_rq_bytes(rq));
+		}
 		fail_path(pgpath);
 	}
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9d32f25489c2..64206743da8f 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -285,12 +285,12 @@ static void dm_done(struct request *clone, blk_status_t error, bool mapped)
 {
 	int r = DM_ENDIO_DONE;
 	struct dm_rq_target_io *tio = clone->end_io_data;
-	dm_request_endio_fn rq_end_io = NULL;
+	struct dm_target *ti = tio->ti;
 
-	if (tio->ti) {
-		rq_end_io = tio->ti->type->rq_end_io;
+	if (ti) {
+		dm_request_endio_fn rq_end_io = ti->type->rq_end_io;
 
-		if (mapped && rq_end_io)
+		if (mapped && rq_end_io && !ti->skip_end_io_hook)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9f4c4a7fd40d..5c83d9dcbfe8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -937,7 +937,8 @@ static void clone_endio(struct bio *bio)
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
-	dm_endio_fn endio = tio->ti->type->end_io;
+	struct dm_target *ti = tio->ti;
+	dm_endio_fn endio = ti->type->end_io;
 
 	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
 		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
@@ -948,8 +949,8 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (endio) {
-		int r = endio(tio->ti, bio, &error);
+	if (endio && !ti->skip_end_io_hook) {
+		int r = endio(ti, bio, &error);
 		switch (r) {
 		case DM_ENDIO_REQUEUE:
 			error = BLK_STS_DM_REQUEUE;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e46ad2ada674..1dfb75ca5d09 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -307,6 +307,12 @@ struct dm_target {
 	 * on max_io_len boundary.
 	 */
 	bool split_discard_bios:1;
+
+	/*
+	 * Set if there is no need to call this target's end_io hook
+	 * (be it .end_io or .end_io_rq).
+	 */
+	bool skip_end_io_hook:1;
 };
 
 /* Each target can link one of these into the table */
-- 
2.15.0
