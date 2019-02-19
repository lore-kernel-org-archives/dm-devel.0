From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/8] dm: improve noclone_endio() to support
	multipath target
Date: Tue, 19 Feb 2019 17:17:20 -0500
Message-ID: <20190219221721.29830-8-snitzer@redhat.com>
References: <20190219221721.29830-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190219221721.29830-1-snitzer@redhat.com>
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

noclone_endio() must call the target's ->endio method if it exists.
Also must handle the various DM_ENDIO_* returns that are possible.

Factor out dm_bio_pushback_needed() for both dec_pending() and
noclone_endio() to use when handling BLK_STS_DM_REQUEUE.

Lastly, there is no need to conditionally set md->immutable_target in
__bind().  If the device only uses a single immutable target then it
should always be reflected in md->immutable_target.  This is important
because noclone_endio() benefits from this to get access to the
multipath dm_target without needing to add another member to the
'dm_noclone' structure.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 77 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8ff0ced278d7..2299f946c175 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -897,6 +897,28 @@ static int __noflush_suspending(struct mapped_device *md)
 	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 }
 
+static bool dm_bio_pushback_needed(struct mapped_device *md,
+				   struct bio *bio, blk_status_t *error)
+{
+	unsigned long flags;
+
+	/*
+	 * Target requested pushing back the I/O.
+	 */
+	if (__noflush_suspending(md)) {
+		spin_lock_irqsave(&md->deferred_lock, flags);
+		// FIXME: using bio_list_add_head() creates LIFO
+		bio_list_add_head(&md->deferred, bio);
+		spin_unlock_irqrestore(&md->deferred_lock, flags);
+		return true;
+	} else {
+		/* noflush suspend was interrupted. */
+		*error = BLK_STS_IOERR;
+	}
+
+	return false;
+}
+
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
@@ -917,19 +939,8 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 	}
 
 	if (atomic_dec_and_test(&io->io_count)) {
-		if (io->status == BLK_STS_DM_REQUEUE) {
-			/*
-			 * Target requested pushing back the I/O.
-			 */
-			spin_lock_irqsave(&md->deferred_lock, flags);
-			if (__noflush_suspending(md))
-				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
-				bio_list_add_head(&md->deferred, io->orig_bio);
-			else
-				/* noflush suspend was interrupted. */
-				io->status = BLK_STS_IOERR;
-			spin_unlock_irqrestore(&md->deferred_lock, flags);
-		}
+		if (unlikely(io->status == BLK_STS_DM_REQUEUE))
+			(void) dm_bio_pushback_needed(md, bio, &io->status);
 
 		io_error = io->status;
 		bio = io->orig_bio;
@@ -1019,8 +1030,33 @@ static void clone_endio(struct bio *bio)
 
 static void noclone_endio(struct bio *bio)
 {
+	blk_status_t error = bio->bi_status;
 	struct dm_noclone *noclone = bio->bi_private;
 	struct mapped_device *md = noclone->md;
+	struct dm_target *ti = NULL;
+	dm_endio_fn endio = NULL;
+
+	if (md->immutable_target) {
+		ti = md->immutable_target;
+		endio = ti->type->end_io;
+	}
+
+	if (endio) {
+		int r = endio(ti, bio, &error);
+		switch (r) {
+		case DM_ENDIO_REQUEUE:
+			error = BLK_STS_DM_REQUEUE;
+			/*FALLTHRU*/
+		case DM_ENDIO_DONE:
+			break;
+		case DM_ENDIO_INCOMPLETE:
+			/* The target will handle the io */
+			return;
+		default:
+			DMWARN("unimplemented target endio return value: %d", r);
+			BUG();
+		}
+	}
 
 	end_io_acct(md, bio, noclone->start_time);
 
@@ -1028,6 +1064,11 @@ static void noclone_endio(struct bio *bio)
 	bio->bi_private = noclone->orig_bi_private;
 	kmem_cache_free(_noclone_cache, noclone);
 
+	if (unlikely(error == BLK_STS_DM_REQUEUE)) {
+		if (dm_bio_pushback_needed(md, bio, &bio->bi_status))
+			return;
+	}
+
 	bio_endio(bio);
 }
 
@@ -2229,15 +2270,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (request_based)
 		dm_stop_queue(q);
 
-	if (request_based || md->type == DM_TYPE_NVME_BIO_BASED) {
-		/*
-		 * Leverage the fact that request-based DM targets and
-		 * NVMe bio based targets are immutable singletons
-		 * - used to optimize both dm_request_fn and dm_mq_queue_rq;
-		 *   and __process_bio.
-		 */
-		md->immutable_target = dm_table_get_immutable_target(t);
-	}
+	md->immutable_target = dm_table_get_immutable_target(t);
 
 	ret = __bind_mempools(md, t);
 	if (ret) {
-- 
2.15.0
