From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 01/12] dm: rename map_info flush_request to
	target_request_nr
Date: Sat, 24 Jul 2010 12:09:17 -0400
Message-ID: <1279987768-13275-2-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
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

'target_request_nr' is a more generic name that reflects the fact that
it will be used for both flush and discard support.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c          |    2 +-
 drivers/md/dm-stripe.c        |    6 ++++--
 drivers/md/dm.c               |   18 +++++++++---------
 include/linux/device-mapper.h |    4 ++--
 4 files changed, 16 insertions(+), 14 deletions(-)

Index: linux-2.6-block/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-snap.c
+++ linux-2.6-block/drivers/md/dm-snap.c
@@ -1692,7 +1692,7 @@ static int snapshot_merge_map(struct dm_
 	chunk_t chunk;
 
 	if (unlikely(bio_empty_barrier(bio))) {
-		if (!map_context->flush_request)
+		if (!map_context->target_request_nr)
 			bio->bi_bdev = s->origin->bdev;
 		else
 			bio->bi_bdev = s->cow->bdev;
Index: linux-2.6-block/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-stripe.c
+++ linux-2.6-block/drivers/md/dm-stripe.c
@@ -213,10 +213,12 @@ static int stripe_map(struct dm_target *
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
 	sector_t offset, chunk;
 	uint32_t stripe;
+	unsigned target_request_nr;
 
 	if (unlikely(bio_empty_barrier(bio))) {
-		BUG_ON(map_context->flush_request >= sc->stripes);
-		bio->bi_bdev = sc->stripe[map_context->flush_request].dev->bdev;
+		target_request_nr = map_context->target_request_nr;
+		BUG_ON(target_request_nr >= sc->stripes);
+		bio->bi_bdev = sc->stripe[target_request_nr].dev->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
 
Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1182,12 +1182,12 @@ static struct dm_target_io *alloc_tio(st
 }
 
 static void __flush_target(struct clone_info *ci, struct dm_target *ti,
-			  unsigned flush_nr)
+			  unsigned request_nr)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti);
 	struct bio *clone;
 
-	tio->info.flush_request = flush_nr;
+	tio->info.target_request_nr = request_nr;
 
 	clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
 	__bio_clone(clone, ci->bio);
@@ -1198,13 +1198,13 @@ static void __flush_target(struct clone_
 
 static int __clone_and_map_empty_barrier(struct clone_info *ci)
 {
-	unsigned target_nr = 0, flush_nr;
+	unsigned target_nr = 0, request_nr;
 	struct dm_target *ti;
 
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		for (flush_nr = 0; flush_nr < ti->num_flush_requests;
-		     flush_nr++)
-			__flush_target(ci, ti, flush_nr);
+		for (request_nr = 0; request_nr < ti->num_flush_requests;
+		     request_nr++)
+			__flush_target(ci, ti, request_nr);
 
 	ci->sector_count = 0;
 
@@ -2435,11 +2435,11 @@ static void dm_queue_flush(struct mapped
 	queue_work(md->wq, &md->work);
 }
 
-static void dm_rq_set_flush_nr(struct request *clone, unsigned flush_nr)
+static void dm_rq_set_target_request_nr(struct request *clone, unsigned request_nr)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	tio->info.flush_request = flush_nr;
+	tio->info.target_request_nr = request_nr;
 }
 
 /* Issue barrier requests to targets and wait for their completion. */
@@ -2457,7 +2457,7 @@ static int dm_rq_barrier(struct mapped_d
 		ti = dm_table_get_target(map, i);
 		for (j = 0; j < ti->num_flush_requests; j++) {
 			clone = clone_rq(md->flush_request, md, GFP_NOIO);
-			dm_rq_set_flush_nr(clone, j);
+			dm_rq_set_target_request_nr(clone, j);
 			atomic_inc(&md->pending[rq_data_dir(clone)]);
 			map_request(ti, clone, md);
 		}
Index: linux-2.6-block/include/linux/device-mapper.h
===================================================================
--- linux-2.6-block.orig/include/linux/device-mapper.h
+++ linux-2.6-block/include/linux/device-mapper.h
@@ -22,7 +22,7 @@ typedef enum { STATUSTYPE_INFO, STATUSTY
 union map_info {
 	void *ptr;
 	unsigned long long ll;
-	unsigned flush_request;
+	unsigned target_request_nr;
 };
 
 /*
@@ -175,7 +175,7 @@ struct dm_target {
 	 * A number of zero-length barrier requests that will be submitted
 	 * to the target for the purpose of flushing cache.
 	 *
-	 * The request number will be placed in union map_info->flush_request.
+	 * The request number will be placed in union map_info->target_request_nr.
 	 * It is a responsibility of the target driver to remap these requests
 	 * to the real underlying devices.
 	 */
