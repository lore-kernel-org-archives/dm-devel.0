From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 4/5] dm mpath: use NVMe error handling to know when an error is retryable
Date: Tue, 19 Dec 2017 16:05:45 -0500
Message-ID: <20171219210546.65928-5-snitzer@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Like NVMe's native multipath support, DM multipath's NVMe bio-based
support now allows NVMe core's error handling to requeue an NVMe blk-mq
request's bios onto DM multipath's queued_bios list for resubmission
once fail_path() occurs.  multipath_failover_rq() serves as a
replacement for the traditional multipath_end_io_bio().

DM multipath's bio submission to NVMe must be done in terms that allow
the reuse of NVMe core's error handling.  The following care is taken to
realize this reuse:

- NVMe core won't attempt to retry an IO if it has
  REQ_FAILFAST_TRANSPORT set; so only set it in __map_bio().

- Setup bio's bi_failover_rq hook, to use multipath_failover_rq, so that
  NVMe blk-mq requests inherit it for use as the failover_rq callback
  if/when NVMe core determines a request must be retried.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3198093006e4..0ed407e150f5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -584,9 +584,13 @@ static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
 		return ERR_PTR(-EAGAIN);
 	}
 
+	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
+
 	return pgpath;
 }
 
+static void multipath_failover_rq(struct request *rq);
+
 static struct pgpath *__map_bio_nvme(struct multipath *m, struct bio *bio)
 {
 	struct pgpath *pgpath;
@@ -614,6 +618,8 @@ static struct pgpath *__map_bio_nvme(struct multipath *m, struct bio *bio)
 		return NULL;
 	}
 
+	bio->bi_failover_rq = multipath_failover_rq;
+
 	return pgpath;
 }
 
@@ -641,7 +647,6 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 
 	bio->bi_status = 0;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
-	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
 
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
@@ -1610,6 +1615,14 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
+	/*
+	 * NVMe bio-based only needs to update path selector (on
+	 * success or errors that NVMe deemed non-retryable)
+	 * - retryable errors are handled by multipath_failover_rq
+	 */
+	if (clone->bi_failover_rq)
+		goto done;
+
 	if (!*error || !retry_error(*error))
 		goto done;
 
@@ -1645,6 +1658,43 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	return r;
 }
 
+/*
+ * multipath_failover_rq serves as a replacement for multipath_end_io_bio
+ * for all bios in a request with a retryable error.
+ */
+static void multipath_failover_rq(struct request *rq)
+{
+	struct dm_target *ti = dm_bio_get_target(rq->bio);
+	struct multipath *m = ti->private;
+	struct dm_mpath_io *mpio = get_mpio_from_bio(rq->bio);
+	struct pgpath *pgpath = mpio->pgpath;
+	unsigned long flags;
+
+	if (pgpath) {
+		struct path_selector *ps = &pgpath->pg->ps;
+
+		if (ps->type->end_io)
+			ps->type->end_io(ps, &pgpath->path, blk_rq_bytes(rq));
+
+		fail_path(pgpath);
+	}
+
+	if (atomic_read(&m->nr_valid_paths) == 0 &&
+	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) &&
+	    !must_push_back_bio(m)) {
+		dm_report_EIO(m);
+		blk_mq_end_request(rq, BLK_STS_IOERR);
+		return;
+	}
+
+	spin_lock_irqsave(&m->lock, flags);
+	blk_steal_bios(&m->queued_bios, rq);
+	spin_unlock_irqrestore(&m->lock, flags);
+	queue_work(kmultipathd, &m->process_queued_bios);
+
+	blk_mq_end_request(rq, 0);
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
-- 
2.15.0
