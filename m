From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/5] blk: Ensure users for current->bio_list can see the
 full list.
Date: Fri, 10 Mar 2017 17:00:47 +1100
Message-ID: <148912564686.4002.16905512808005503136.stgit@noble>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

Commit 79bd99596b73 ("blk: improve order of bio handling in generic_make_request()")
changed current->bio_list so that it did not contain *all* of the
queued bios, but only those submitted by the currently running
make_request_fn.

There are two places which walk the list and requeue selected bios,
and others that check if the list is empty.  These are no longer
correct.

So redefine current->bio_list to point to an array of two lists, which
contain all queued bios, and adjust various code to test or walk both
lists.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/bio.c         |   12 +++++++++---
 block/blk-core.c    |   30 ++++++++++++++++++------------
 drivers/md/dm.c     |   29 ++++++++++++++++-------------
 drivers/md/raid10.c |    3 ++-
 4 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5eec5e08417f..e75878f8b14a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -376,10 +376,14 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	bio_list_init(&punt);
 	bio_list_init(&nopunt);
 
-	while ((bio = bio_list_pop(current->bio_list)))
+	while ((bio = bio_list_pop(&current->bio_list[0])))
 		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
+	current->bio_list[0] = nopunt;
 
-	*current->bio_list = nopunt;
+	bio_list_init(&nopunt);
+	while ((bio = bio_list_pop(&current->bio_list[1])))
+		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
+	current->bio_list[1] = nopunt;
 
 	spin_lock(&bs->rescue_lock);
 	bio_list_merge(&bs->rescue_list, &punt);
@@ -466,7 +470,9 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		 * we retry with the original gfp_flags.
 		 */
 
-		if (current->bio_list && !bio_list_empty(current->bio_list))
+		if (current->bio_list &&
+		    (!bio_list_empty(&current->bio_list[0]) ||
+		     !bio_list_empty(&current->bio_list[1])))
 			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
diff --git a/block/blk-core.c b/block/blk-core.c
index 0eeb99ef654f..d772c221cc17 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1973,7 +1973,14 @@ generic_make_request_checks(struct bio *bio)
  */
 blk_qc_t generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	/*
+	 * bio_list_on_stack[0] contains bios submitted by the current
+	 * make_request_fn.
+	 * bio_list_on_stack[1] contains bios that were submitted before
+	 * the current make_request_fn, but that haven't been processed
+	 * yet.
+	 */
+	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (!generic_make_request_checks(bio))
@@ -1990,7 +1997,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * should be added at the tail
 	 */
 	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+		bio_list_add(&current->bio_list[0], bio);
 		goto out;
 	}
 
@@ -2009,18 +2016,17 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
+	bio_list_init(&bio_list_on_stack[0]);
+	current->bio_list = bio_list_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
 		if (likely(blk_queue_enter(q, false) == 0)) {
-			struct bio_list hold;
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
-			hold = bio_list_on_stack;
-			bio_list_init(&bio_list_on_stack);
+			bio_list_on_stack[1] = bio_list_on_stack[0];
+			bio_list_init(&bio_list_on_stack[0]);
 			ret = q->make_request_fn(q, bio);
 
 			blk_queue_exit(q);
@@ -2030,19 +2036,19 @@ blk_qc_t generic_make_request(struct bio *bio)
 			 */
 			bio_list_init(&lower);
 			bio_list_init(&same);
-			while ((bio = bio_list_pop(&bio_list_on_stack)) != NULL)
+			while ((bio = bio_list_pop(&bio_list_on_stack[0])) != NULL)
 				if (q == bdev_get_queue(bio->bi_bdev))
 					bio_list_add(&same, bio);
 				else
 					bio_list_add(&lower, bio);
 			/* now assemble so we handle the lowest level first */
-			bio_list_merge(&bio_list_on_stack, &lower);
-			bio_list_merge(&bio_list_on_stack, &same);
-			bio_list_merge(&bio_list_on_stack, &hold);
+			bio_list_merge(&bio_list_on_stack[0], &lower);
+			bio_list_merge(&bio_list_on_stack[0], &same);
+			bio_list_merge(&bio_list_on_stack[0], &bio_list_on_stack[1]);
 		} else {
 			bio_io_error(bio);
 		}
-		bio = bio_list_pop(current->bio_list);
+		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
 	current->bio_list = NULL; /* deactivate */
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f4ffd1eb8f44..dfb75979e455 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -989,26 +989,29 @@ static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_schedule)
 	struct dm_offload *o = container_of(cb, struct dm_offload, cb);
 	struct bio_list list;
 	struct bio *bio;
+	int i;
 
 	INIT_LIST_HEAD(&o->cb.list);
 
 	if (unlikely(!current->bio_list))
 		return;
 
-	list = *current->bio_list;
-	bio_list_init(current->bio_list);
-
-	while ((bio = bio_list_pop(&list))) {
-		struct bio_set *bs = bio->bi_pool;
-		if (unlikely(!bs) || bs == fs_bio_set) {
-			bio_list_add(current->bio_list, bio);
-			continue;
+	for (i = 0; i < 2; i++) {
+		list = current->bio_list[i];
+		bio_list_init(&current->bio_list[i]);
+
+		while ((bio = bio_list_pop(&list))) {
+			struct bio_set *bs = bio->bi_pool;
+			if (unlikely(!bs) || bs == fs_bio_set) {
+				bio_list_add(&current->bio_list[i], bio);
+				continue;
+			}
+
+			spin_lock(&bs->rescue_lock);
+			bio_list_add(&bs->rescue_list, bio);
+			queue_work(bs->rescue_workqueue, &bs->rescue_work);
+			spin_unlock(&bs->rescue_lock);
 		}
-
-		spin_lock(&bs->rescue_lock);
-		bio_list_add(&bs->rescue_list, bio);
-		queue_work(bs->rescue_workqueue, &bs->rescue_work);
-		spin_unlock(&bs->rescue_lock);
 	}
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 063c43d83b72..0536658c9d40 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -974,7 +974,8 @@ static void wait_barrier(struct r10conf *conf)
 				    !conf->barrier ||
 				    (atomic_read(&conf->nr_pending) &&
 				     current->bio_list &&
-				     !bio_list_empty(current->bio_list)),
+				     (!bio_list_empty(&current->bio_list[0]) ||
+				      !bio_list_empty(&current->bio_list[1]))),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)
