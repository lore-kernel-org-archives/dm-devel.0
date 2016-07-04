From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] block: prepare for timed bio offload
Date: Mon, 4 Jul 2016 18:58:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607041857040.16388@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Replace the pointer current->bio_list with structure queued_bios.
It is a prerequisite for the following patch that will use the timer
placed in this structure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/bio.c               |    6 +++---
 block/blk-core.c          |   16 ++++++++--------
 drivers/md/bcache/btree.c |   12 ++++++------
 drivers/md/dm-bufio.c     |    2 +-
 drivers/md/raid1.c        |    6 +++---
 drivers/md/raid10.c       |    6 +++---
 include/linux/blkdev.h    |    7 ++++++-
 include/linux/sched.h     |    4 ++--
 8 files changed, 32 insertions(+), 27 deletions(-)

Index: linux-4.7-rc6/include/linux/sched.h
===================================================================
--- linux-4.7-rc6.orig/include/linux/sched.h	2016-07-04 23:58:01.000000000 +0200
+++ linux-4.7-rc6/include/linux/sched.h	2016-07-05 00:02:10.000000000 +0200
@@ -128,7 +128,7 @@ struct sched_attr {
 
 struct futex_pi_state;
 struct robust_list_head;
-struct bio_list;
+struct queued_bios;
 struct fs_struct;
 struct perf_event_context;
 struct blk_plug;
@@ -1727,7 +1727,7 @@ struct task_struct {
 	void *journal_info;
 
 /* stacked block device info */
-	struct bio_list *bio_list;
+	struct queued_bios *queued_bios;
 
 #ifdef CONFIG_BLOCK
 /* stack plugging */
Index: linux-4.7-rc6/block/blk-core.c
===================================================================
--- linux-4.7-rc6.orig/block/blk-core.c	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/block/blk-core.c	2016-07-05 00:02:10.000000000 +0200
@@ -2031,7 +2031,7 @@ end_io:
  */
 blk_qc_t generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	struct queued_bios queued_bios_on_stack;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (!generic_make_request_checks(bio))
@@ -2047,8 +2047,8 @@ blk_qc_t generic_make_request(struct bio
 	 * it is non-NULL, then a make_request is active, and new requests
 	 * should be added at the tail
 	 */
-	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+	if (current->queued_bios) {
+		bio_list_add(&current->queued_bios->bio_list, bio);
 		goto out;
 	}
 
@@ -2067,8 +2067,8 @@ blk_qc_t generic_make_request(struct bio
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
+	bio_list_init(&queued_bios_on_stack.bio_list);
+	current->queued_bios = &queued_bios_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
@@ -2077,15 +2077,15 @@ blk_qc_t generic_make_request(struct bio
 
 			blk_queue_exit(q);
 
-			bio = bio_list_pop(current->bio_list);
+			bio = bio_list_pop(&current->queued_bios->bio_list);
 		} else {
-			struct bio *bio_next = bio_list_pop(current->bio_list);
+			struct bio *bio_next = bio_list_pop(&current->queued_bios->bio_list);
 
 			bio_io_error(bio);
 			bio = bio_next;
 		}
 	} while (bio);
-	current->bio_list = NULL; /* deactivate */
+	current->queued_bios = NULL; /* deactivate */
 
 out:
 	return ret;
Index: linux-4.7-rc6/include/linux/blkdev.h
===================================================================
--- linux-4.7-rc6.orig/include/linux/blkdev.h	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/include/linux/blkdev.h	2016-07-05 00:02:10.000000000 +0200
@@ -1114,6 +1114,11 @@ static inline bool blk_needs_flush_plug(
 		 !list_empty(&plug->cb_list));
 }
 
+struct queued_bios {
+	struct bio_list bio_list;
+	struct timer_list timer;
+};
+
 extern void blk_flush_bio_list(struct task_struct *tsk);
 
 static inline void blk_flush_queued_io(struct task_struct *tsk)
@@ -1121,7 +1126,7 @@ static inline void blk_flush_queued_io(s
 	/*
 	 * Flush any queued bios to corresponding rescue threads.
 	 */
-	if (tsk->bio_list && !bio_list_empty(tsk->bio_list))
+	if (tsk->queued_bios && !bio_list_empty(&tsk->queued_bios->bio_list))
 		blk_flush_bio_list(tsk);
 	/*
 	 * Flush any plugged IO that is queued.
Index: linux-4.7-rc6/block/bio.c
===================================================================
--- linux-4.7-rc6.orig/block/bio.c	2016-07-05 00:02:01.000000000 +0200
+++ linux-4.7-rc6/block/bio.c	2016-07-05 00:02:10.000000000 +0200
@@ -365,13 +365,13 @@ static void bio_alloc_rescue(struct work
 void blk_flush_bio_list(struct task_struct *tsk)
 {
 	struct bio *bio;
-	struct bio_list list = *tsk->bio_list;
-	bio_list_init(tsk->bio_list);
+	struct bio_list list = tsk->queued_bios->bio_list;
+	bio_list_init(&tsk->queued_bios->bio_list);
 
 	while ((bio = bio_list_pop(&list))) {
 		struct bio_set *bs = bio->bi_pool;
 		if (unlikely(!bs) || bs == fs_bio_set) {
-			bio_list_add(tsk->bio_list, bio);
+			bio_list_add(&tsk->queued_bios->bio_list, bio);
 			continue;
 		}
 
Index: linux-4.7-rc6/drivers/md/bcache/btree.c
===================================================================
--- linux-4.7-rc6.orig/drivers/md/bcache/btree.c	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/drivers/md/bcache/btree.c	2016-07-05 00:02:10.000000000 +0200
@@ -450,7 +450,7 @@ void __bch_btree_node_write(struct btree
 
 	trace_bcache_btree_write(b);
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->queued_bios);
 	BUG_ON(b->written >= btree_blocks(b));
 	BUG_ON(b->written && !i->keys);
 	BUG_ON(btree_bset_first(b)->seq != i->seq);
@@ -544,7 +544,7 @@ static void bch_btree_leaf_dirty(struct 
 
 	/* Force write if set is too big */
 	if (set_bytes(i) > PAGE_SIZE - 48 &&
-	    !current->bio_list)
+	    !current->queued_bios)
 		bch_btree_node_write(b, NULL);
 }
 
@@ -889,7 +889,7 @@ static struct btree *mca_alloc(struct ca
 {
 	struct btree *b;
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->queued_bios);
 
 	lockdep_assert_held(&c->bucket_lock);
 
@@ -976,7 +976,7 @@ retry:
 	b = mca_find(c, k);
 
 	if (!b) {
-		if (current->bio_list)
+		if (current->queued_bios)
 			return ERR_PTR(-EAGAIN);
 
 		mutex_lock(&c->bucket_lock);
@@ -2127,7 +2127,7 @@ static int bch_btree_insert_node(struct 
 
 	return 0;
 split:
-	if (current->bio_list) {
+	if (current->queued_bios) {
 		op->lock = b->c->root->level + 1;
 		return -EAGAIN;
 	} else if (op->lock <= b->c->root->level) {
@@ -2209,7 +2209,7 @@ int bch_btree_insert(struct cache_set *c
 	struct btree_insert_op op;
 	int ret = 0;
 
-	BUG_ON(current->bio_list);
+	BUG_ON(current->queued_bios);
 	BUG_ON(bch_keylist_empty(keys));
 
 	bch_btree_op_init(&op.op, 0);
Index: linux-4.7-rc6/drivers/md/dm-bufio.c
===================================================================
--- linux-4.7-rc6.orig/drivers/md/dm-bufio.c	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/drivers/md/dm-bufio.c	2016-07-05 00:02:10.000000000 +0200
@@ -174,7 +174,7 @@ static inline int dm_bufio_cache_index(s
 #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
 #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
 
-#define dm_bufio_in_request()	(!!current->bio_list)
+#define dm_bufio_in_request()	(!!current->queued_bios)
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
Index: linux-4.7-rc6/drivers/md/raid1.c
===================================================================
--- linux-4.7-rc6.orig/drivers/md/raid1.c	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/drivers/md/raid1.c	2016-07-05 00:02:10.000000000 +0200
@@ -876,8 +876,8 @@ static sector_t wait_barrier(struct r1co
 				    (!conf->barrier ||
 				     ((conf->start_next_window <
 				       conf->next_resync + RESYNC_SECTORS) &&
-				      current->bio_list &&
-				      !bio_list_empty(current->bio_list))),
+				      current->queued_bios &&
+				      !bio_list_empty(&current->queued_bios->bio_list))),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1014,7 +1014,7 @@ static void raid1_unplug(struct blk_plug
 	struct r1conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || current->queued_bios) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
Index: linux-4.7-rc6/drivers/md/raid10.c
===================================================================
--- linux-4.7-rc6.orig/drivers/md/raid10.c	2016-07-04 23:58:02.000000000 +0200
+++ linux-4.7-rc6/drivers/md/raid10.c	2016-07-05 00:02:10.000000000 +0200
@@ -945,8 +945,8 @@ static void wait_barrier(struct r10conf 
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
 				    (conf->nr_pending &&
-				     current->bio_list &&
-				     !bio_list_empty(current->bio_list)),
+				     current->queued_bios &&
+				     !bio_list_empty(&current->queued_bios->bio_list)),
 				    conf->resync_lock);
 		conf->nr_waiting--;
 	}
@@ -1022,7 +1022,7 @@ static void raid10_unplug(struct blk_plu
 	struct r10conf *conf = mddev->private;
 	struct bio *bio;
 
-	if (from_schedule || current->bio_list) {
+	if (from_schedule || current->queued_bios) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
