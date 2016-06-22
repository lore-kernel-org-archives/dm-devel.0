From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Wed, 22 Jun 2016 10:22:10 +0200
Message-ID: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, NeilBrown <neilb@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

For a long time, generic_make_request() converts recursion into
iteration by queuing recursive arguments on current->bio_list.

This is convenient for stacking drivers,
the top-most driver would take the originally submitted bio,
and re-submit a re-mapped version of it, or one or more clones,
or one or more new allocated bios to its backend(s). Which
are then simply processed in turn, and each can again queue
more "backend-bios" until we reach the bottom of the driver stack,
and actually dispatch to the real backend device.

Any stacking driver ->make_request_fn() could expect that,
once it returns, any backend-bios it submitted via recursive calls
to generic_make_request() would now be processed and dispatched, before
the current task would call into this driver again.

This is changed by commit
  54efd50 block: make generic_make_request handle arbitrarily sized bios

Drivers may call blk_queue_split() inside their ->make_request_fn(),
which may split the current bio into a front-part to be dealt with
immediately, and a remainder-part, which may need to be split even
further. That remainder-part will simply also be pushed to
current->bio_list, and would end up being head-of-queue, in front
of any backend-bios the current make_request_fn() might submit during
processing of the fron-part.

Which means the current task would immediately end up back in the same
make_request_fn() of the same driver again, before any of its backend
bios have even been processed.

This can lead to resource starvation deadlock.
Drivers could avoid this by learning to not need blk_queue_split(),
or by submitting their backend bios in a different context (dedicated
kernel thread, work_queue context, ...). Or by playing funny re-ordering
games with entries on current->bio_list.

Instead, I suggest to distinguish between recursive calls to
generic_make_request(), and pushing back the remainder part in
blk_queue_split(), by pointing current->bio_lists to a
	struct recursion_to_iteration_bio_lists {
		struct bio_list recursion;
		struct bio_list remainder;
	}

To have all bios targeted to drivers lower in the stack processed before
processing the next piece of a bio targeted at the higher levels,
as long as queued bios resulting from recursion are available,
they will continue to be processed in FIFO order.
Pushed back bio-parts resulting from blk_queue_split() will be processed
in LIFO order, one-by-one, whenever the recursion list becomes empty.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>
---

This is not a theoretical problem.
At least int DRBD, and an unfortunately high IO concurrency wrt. the
"max-buffers" setting, without this patch we have a reproducible deadlock.

I'm unsure if it could cause problems in md raid in some corner cases
or when a rebuild/scrub/... starts in a "bad" moment.

It also may increase "stress" on any involved bio_set,
because it may increase the number of bios that are allocated
before the first of them is actually processed, causing more
frequent calls of punt_bios_to_rescuer().

Alternatively,
a simple one-line change to generic_make_request() would also "fix" it,
by processing all recursive bios in LIFO order.
But that may change the order in which bios reach the "physical" layer,
in case they are in fact split into many smaller pieces, for example in
a striping setup, which may have other performance implications.

 | diff --git a/block/blk-core.c b/block/blk-core.c
 | index 2475b1c7..a5623f6 100644
 | --- a/block/blk-core.c
 | +++ b/block/blk-core.c
 | @@ -2048,7 +2048,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 |  	 * should be added at the tail
 |  	 */
 |  	if (current->bio_list) {
 | -		bio_list_add(current->bio_list, bio);
 | +		bio_list_add_head(current->bio_list, bio);
 |  		goto out;
 |  	}

Any fix would need to go to stable 4.3.x and up.
This patch does apply as is to 4.5 and up,
with a trivial fixup (or a cherry-pick of cda2264) to 4.4,
and with some more (also trivial) fixup to 4.3 because of
GFP_WAIT -> GFP_RECLAIM and comment rewrap.

Any input?
How should I proceed?

---
 block/bio.c               | 14 +++++++-------
 block/blk-core.c          | 32 +++++++++++++++++---------------
 block/blk-merge.c         |  3 ++-
 drivers/md/bcache/btree.c | 12 ++++++------
 drivers/md/dm-bufio.c     |  2 +-
 drivers/md/md.h           |  7 +++++++
 drivers/md/raid1.c        |  5 ++---
 drivers/md/raid10.c       |  5 ++---
 include/linux/bio.h       | 11 +++++++++++
 include/linux/sched.h     |  4 ++--
 10 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0e4aa42..2ffcea0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -368,10 +368,10 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	bio_list_init(&punt);
 	bio_list_init(&nopunt);
 
-	while ((bio = bio_list_pop(current->bio_list)))
+	while ((bio = bio_list_pop(&current->bio_lists->recursion)))
 		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
 
-	*current->bio_list = nopunt;
+	current->bio_lists->recursion = nopunt;
 
 	spin_lock(&bs->rescue_lock);
 	bio_list_merge(&bs->rescue_list, &punt);
@@ -453,13 +453,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		 *
 		 * We solve this, and guarantee forward progress, with a rescuer
 		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
-		 * bios we would be blocking to the rescuer workqueue before
-		 * we retry with the original gfp_flags.
+		 * bios on current->bio_lists->recursion, we first try the
+		 * allocation without __GFP_DIRECT_RECLAIM; if that fails, we
+		 * punt those bios we would be blocking to the rescuer
+		 * workqueue before we retry with the original gfp_flags.
 		 */
 
-		if (current->bio_list && !bio_list_empty(current->bio_list))
+		if (current->bio_lists && !bio_list_empty(&current->bio_lists->recursion))
 			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
diff --git a/block/blk-core.c b/block/blk-core.c
index 2475b1c7..f03ff4c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2031,7 +2031,7 @@ end_io:
  */
 blk_qc_t generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	struct recursion_to_iteration_bio_lists bio_lists_on_stack;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (!generic_make_request_checks(bio))
@@ -2040,15 +2040,18 @@ blk_qc_t generic_make_request(struct bio *bio)
 	/*
 	 * We only want one ->make_request_fn to be active at a time, else
 	 * stack usage with stacked devices could be a problem.  So use
-	 * current->bio_list to keep a list of requests submited by a
-	 * make_request_fn function.  current->bio_list is also used as a
+	 * current->bio_lists to keep a list of requests submited by a
+	 * make_request_fn function.  current->bio_lists is also used as a
 	 * flag to say if generic_make_request is currently active in this
 	 * task or not.  If it is NULL, then no make_request is active.  If
 	 * it is non-NULL, then a make_request is active, and new requests
-	 * should be added at the tail
+	 * should be added at the tail of current->bio_lists->recursion;
+	 * remainder bios resulting from a call to bio_queue_split() from
+	 * within ->make_request_fn() should be added to the head of
+	 * current->bio_lists->remainder.
 	 */
-	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+	if (current->bio_lists) {
+		bio_list_add(&current->bio_lists->recursion, bio);
 		goto out;
 	}
 
@@ -2057,7 +2060,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * Before entering the loop, bio->bi_next is NULL (as all callers
 	 * ensure that) so we have a list with a single bio.
 	 * We pretend that we have just taken it off a longer list, so
-	 * we assign bio_list to a pointer to the bio_list_on_stack,
+	 * we assign bio_list to a pointer to the bio_lists_on_stack,
 	 * thus initialising the bio_list of new bios to be
 	 * added.  ->make_request() may indeed add some more bios
 	 * through a recursive call to generic_make_request.  If it
@@ -2067,8 +2070,9 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
+	bio_list_init(&bio_lists_on_stack.recursion);
+	bio_list_init(&bio_lists_on_stack.remainder);
+	current->bio_lists = &bio_lists_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
@@ -2076,16 +2080,14 @@ blk_qc_t generic_make_request(struct bio *bio)
 			ret = q->make_request_fn(q, bio);
 
 			blk_queue_exit(q);
-
-			bio = bio_list_pop(current->bio_list);
 		} else {
-			struct bio *bio_next = bio_list_pop(current->bio_list);
-
 			bio_io_error(bio);
-			bio = bio_next;
 		}
+		bio = bio_list_pop(&current->bio_lists->recursion);
+		if (!bio)
+			bio = bio_list_pop(&current->bio_lists->remainder);
 	} while (bio);
-	current->bio_list = NULL; /* deactivate */
+	current->bio_lists = NULL; /* deactivate */
 
 out:
 	return ret;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..8da0c22 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -172,6 +172,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 	struct bio *split, *res;
 	unsigned nsegs;
 
+	BUG_ON(!current->bio_lists);
 	if ((*bio)->bi_rw & REQ_DISCARD)
 		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
 	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
@@ -190,7 +191,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 
 		bio_chain(split, *bio);
 		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
-		generic_make_request(*bio);
+		bio_list_add_head(&current->bio_lists->remainder, *bio);
 		*bio = split;
 	}
 }
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index eab505e..eb0b41a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -450,7 +450,7 @@ void __bch_btree_node_write(struct btree *b, struct closure *parent)
 
 	trace_bcache_btree_write(b);
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->bio_lists);
 	BUG_ON(b->written >= btree_blocks(b));
 	BUG_ON(b->written && !i->keys);
 	BUG_ON(btree_bset_first(b)->seq != i->seq);
@@ -544,7 +544,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
 
 	/* Force write if set is too big */
 	if (set_bytes(i) > PAGE_SIZE - 48 &&
-	    !current->bio_list)
+	    !current->bio_lists)
 		bch_btree_node_write(b, NULL);
 }
 
@@ -889,7 +889,7 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
 {
 	struct btree *b;
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->bio_lists);
 
 	lockdep_assert_held(&c->bucket_lock);
 
@@ -976,7 +976,7 @@ retry:
 	b = mca_find(c, k);
 
 	if (!b) {
-		if (current->bio_list)
+		if (current->bio_lists)
 			return ERR_PTR(-EAGAIN);
 
 		mutex_lock(&c->bucket_lock);
@@ -2127,7 +2127,7 @@ static int bch_btree_insert_node(struct btree *b, struct btree_op *op,
 
 	return 0;
 split:
-	if (current->bio_list) {
+	if (current->bio_lists) {
 		op->lock = b->c->root->level + 1;
 		return -EAGAIN;
 	} else if (op->lock <= b->c->root->level) {
@@ -2209,7 +2209,7 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
 	struct btree_insert_op op;
 	int ret = 0;
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->bio_lists);
 	BUG_ON(bch_keylist_empty(keys));
 
 	bch_btree_op_init(&op.op, 0);
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cd77216..b64d4f0 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -174,7 +174,7 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
 #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
 #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
 
-#define dm_bufio_in_request()	(!!current->bio_list)
+#define dm_bufio_in_request()	(!!current->bio_lists)
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b5c4be7..7afc71c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -663,6 +663,13 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 	}
 }
 
+static inline bool current_has_pending_bios(void)
+{
+	return current->bio_lists && (
+	      !bio_list_empty(&current->bio_lists->recursion) ||
+	      !bio_list_empty(&current->bio_lists->remainder));
+}
+
 extern struct md_cluster_operations *md_cluster_ops;
 static inline int mddev_is_clustered(struct mddev *mddev)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c7c8cde..811f2c0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -876,8 +876,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 				    (!conf->barrier ||
 				     ((conf->start_next_window <
 				       conf->next_resync + RESYNC_SECTORS) &&
-				      current->bio_list &&
-				      !bio_list_empty(current->bio_list))),
+				      current_has_pending_bios())),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1014,7 +1013,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	struct r1conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || current->bio_lists) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c7de2a5..2c70717 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -945,8 +945,7 @@ static void wait_barrier(struct r10conf *conf)
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
 				    (conf->nr_pending &&
-				     current->bio_list &&
-				     !bio_list_empty(current->bio_list)),
+				     current_has_pending_bios()),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1022,7 +1021,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	struct r10conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || current->bio_lists) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9faebf7..57e45a0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -598,6 +598,17 @@ struct bio_list {
 	struct bio *tail;
 };
 
+/* for generic_make_request() */
+struct recursion_to_iteration_bio_lists {
+	/* For stacking drivers submitting to their respective backend.
+	 * Added to tail, processed in FIFO order. */
+	struct bio_list recursion;
+	/* For pushing back the "remainder" part resulting from calling
+	 * blk_queue_split(). Added to head, processed in LIFO order,
+	 * once the "recursion" list has been drained. */
+	struct bio_list remainder;
+};
+
 static inline int bio_list_empty(const struct bio_list *bl)
 {
 	return bl->head == NULL;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e42ada..146eedc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -128,7 +128,7 @@ struct sched_attr {
 
 struct futex_pi_state;
 struct robust_list_head;
-struct bio_list;
+struct recursion_to_iteration_bio_lists;
 struct fs_struct;
 struct perf_event_context;
 struct blk_plug;
@@ -1727,7 +1727,7 @@ struct task_struct {
 	void *journal_info;
 
 /* stacked block device info */
-	struct bio_list *bio_list;
+	struct recursion_to_iteration_bio_lists *bio_lists;
 
 #ifdef CONFIG_BLOCK
 /* stack plugging */
-- 
1.9.1
