From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/14] mikulas' shared snapshot patches
Date: Mon, 1 Mar 2010 19:32:20 -0500
Message-ID: <20100302003217.GA6647@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
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

On Mon, Mar 01 2010 at  7:23pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> But the primary difference with this submission (when compared to your
> r15 patches) is I editted the patches for whitespace and typos.  I'm
> _really_ not trying to step on your hard work by doing this
> superficial stuff.  But while reviewing the code the insanely long
> lines really were distracting.  I tried very hard to preserve the
> intent of the DM_MULTISNAP_SET_ERROR/DM_ERR messages by still having
> grep'able content (on a single line).
> 
> I also didn't go crazy like a checkpatch.pl zealot.. I didn't even run
> these patches through checkpatch!
> 
> I know how sensitive you are about allowing the editor do the wrapping
> but I trully think the length of some lines would never get past
> Alasdair (or Linus) -- even though they have relaxed the rules for
> line length.
> 
> I'll respond to this cover-letter with a single incremental patch that
> shows my edits.

As promised:

 drivers/md/dm-bufio.c                    |  132 +++++++---------
 drivers/md/dm-bufio.h                    |   11 +-
 drivers/md/dm-multisnap-alloc.c          |   75 +++++----
 drivers/md/dm-multisnap-blocks.c         |   57 ++++---
 drivers/md/dm-multisnap-btree.c          |  253 +++++++++++++++++-------------
 drivers/md/dm-multisnap-commit.c         |   36 +++--
 drivers/md/dm-multisnap-daniel.c         |   52 ++++---
 drivers/md/dm-multisnap-delete.c         |   11 +-
 drivers/md/dm-multisnap-freelist.c       |   45 +++---
 drivers/md/dm-multisnap-io.c             |   26 ++--
 drivers/md/dm-multisnap-mikulas-struct.h |   24 ++--
 drivers/md/dm-multisnap-mikulas.c        |  119 +++++++++------
 drivers/md/dm-multisnap-mikulas.h        |   88 +++++++---
 drivers/md/dm-multisnap-snaps.c          |  135 ++++++++++-------
 drivers/md/dm-multisnap.c                |  203 +++++++++++++-----------
 drivers/md/dm-multisnap.h                |   51 ++++--
 16 files changed, 755 insertions(+), 563 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c158622..44dbb0e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -40,10 +40,10 @@
  *
  * In case of memory pressure, the buffer may be written after
  *	dm_bufio_mark_buffer_dirty, but before dm_bufio_write_dirty_buffers.
- *	So, dm_bufio_write_dirty_buffers guarantees that the buffer is on-disk,
+ *	So dm_bufio_write_dirty_buffers guarantees that the buffer is on-disk
  *	but the actual writing may occur earlier.
  *
- * dm_bufio_release_move --- like dm_bufio_release, and also move the buffer to
+ * dm_bufio_release_move --- like dm_bufio_release but also move the buffer to
  *	the new block. dm_bufio_write_dirty_buffers is needed to commit the new
  *	block.
  * dm_bufio_drop_buffers --- clear all buffers.
@@ -76,7 +76,7 @@
 
 /*
  * Don't try to kmalloc blocks larger than this.
- * For exaplanation, see dm_bufio_alloc_buffer_data below.
+ * For explanation, see dm_bufio_alloc_buffer_data below.
  */
 #define DM_BUFIO_BLOCK_SIZE_KMALLOC_LIMIT	PAGE_SIZE
 
@@ -95,12 +95,11 @@ struct dm_bufio_client {
 	 *		are linked to lru with their lru_list field.
 	 *	dirty and clean buffers that are being written are linked
 	 *		to dirty_lru with their	lru_list field. When the write
-	 *		finishes, the buffer cannot be immediatelly relinked
+	 *		finishes, the buffer cannot be immediately relinked
 	 *		(because we are in an interrupt context and relinking
 	 *		requires process context), so some clean-not-writing
 	 *		buffers	can be held on dirty_lru too. They are later
-	 *		added to
-	 *		lru in the process context.
+	 *		added to lru in the process context.
 	 */
 	struct list_head lru;
 	struct list_head dirty_lru;
@@ -124,7 +123,7 @@ struct dm_bufio_client {
 };
 
 /*
- * A method, with wich the data is allocated:
+ * A method, with which the data is allocated:
  * kmalloc(), __get_free_pages() or vmalloc().
  * See the comment at dm_bufio_alloc_buffer_data.
  */
@@ -158,22 +157,23 @@ struct dm_buffer {
  * __get_free_pages can randomly fail, if the memory is fragmented.
  * __vmalloc won't randomly fail, but vmalloc space is limited (it may be
  *	as low as 128M) --- so using it for caching is not appropriate.
- * If the allocation may fail, we use __get_free_pages, memory fragmentation
+ * If the allocation may fail we use __get_free_pages. Memory fragmentation
  *	won't have fatal effect here, it just causes flushes of some other
  *	buffers and more I/O will be performed.
- * If the allocation shouldn't fail, we use __vmalloc. This is only for
+ * If the allocation shouldn't fail we use __vmalloc. This is only for
  *	the initial reserve allocation, so there's no risk of wasting
  *	all vmalloc space.
  */
-
-static void *dm_bufio_alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask, char *data_mode)
+static void *dm_bufio_alloc_buffer_data(struct dm_bufio_client *c,
+					gfp_t gfp_mask, char *data_mode)
 {
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_KMALLOC_LIMIT) {
 		*data_mode = DATA_MODE_KMALLOC;
 		return kmalloc(c->block_size, gfp_mask);
 	} else if (gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
-		return (void *)__get_free_pages(gfp_mask, c->pages_per_block_bits);
+		return (void *)__get_free_pages(gfp_mask,
+						c->pages_per_block_bits);
 	} else {
 		*data_mode = DATA_MODE_VMALLOC;
 		return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
@@ -183,8 +183,8 @@ static void *dm_bufio_alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mas
 /*
  * Free buffer's data.
  */
-
-static void dm_bufio_free_buffer_data(struct dm_bufio_client *c, void *data, char data_mode)
+static void dm_bufio_free_buffer_data(struct dm_bufio_client *c,
+				      void *data, char data_mode)
 {
 	switch (data_mode) {
 
@@ -198,17 +198,16 @@ static void dm_bufio_free_buffer_data(struct dm_bufio_client *c, void *data, cha
 		vfree(data);
 		break;
 	default:
-		printk(KERN_CRIT "dm_bufio_free_buffer_data: bad data mode: %d", data_mode);
+		printk(KERN_CRIT "dm_bufio_free_buffer_data: bad data mode: %d",
+		       data_mode);
 		BUG();
 
 	}
 }
 
-
 /*
  * Allocate buffer and its data.
  */
-
 static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t gfp_mask)
 {
 	struct dm_buffer *b;
@@ -227,7 +226,6 @@ static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t gfp_mask)
 /*
  * Free buffer and its data.
  */
-
 static void free_buffer(struct dm_buffer *b)
 {
 	dm_bufio_free_buffer_data(b->c, b->data, b->data_mode);
@@ -238,7 +236,6 @@ static void free_buffer(struct dm_buffer *b)
 /*
  * Link buffer to the hash list and clean or dirty queue.
  */
-
 static void link_buffer(struct dm_buffer *b, sector_t block, int dirty)
 {
 	struct dm_bufio_client *c = b->c;
@@ -251,7 +248,6 @@ static void link_buffer(struct dm_buffer *b, sector_t block, int dirty)
 /*
  * Unlink buffer from the hash list and dirty or clean queue.
  */
-
 static void unlink_buffer(struct dm_buffer *b)
 {
 	BUG_ON(!b->c->n_buffers);
@@ -263,7 +259,6 @@ static void unlink_buffer(struct dm_buffer *b)
 /*
  * Place the buffer to the head of dirty or clean LRU queue.
  */
-
 static void relink_lru(struct dm_buffer *b, int dirty)
 {
 	struct dm_bufio_client *c = b->c;
@@ -276,7 +271,6 @@ static void relink_lru(struct dm_buffer *b, int dirty)
  * It unplugs the underlying block device, so that coalesced I/Os in
  * the request queue are dispatched to the device.
  */
-
 static int do_io_schedule(void *word)
 {
 	struct dm_buffer *b = container_of(word, struct dm_buffer, state);
@@ -297,7 +291,6 @@ static void write_dirty_buffer(struct dm_buffer *b);
  * When this function finishes, there is no I/O running on the buffer
  * and the buffer is not dirty.
  */
-
 static void make_buffer_clean(struct dm_buffer *b)
 {
 	BUG_ON(b->hold_count);
@@ -311,9 +304,8 @@ static void make_buffer_clean(struct dm_buffer *b)
 /*
  * Find some buffer that is not held by anybody, clean it, unlink it and
  * return it.
- * If "wait" is zero, try less harder and don't block.
+ * If "wait" is zero, try less hard and don't block.
  */
-
 static struct dm_buffer *get_unclaimed_buffer(struct dm_bufio_client *c, int wait)
 {
 	struct dm_buffer *b;
@@ -354,7 +346,6 @@ static struct dm_buffer *get_unclaimed_buffer(struct dm_bufio_client *c, int wai
  * This function is entered with c->lock held, drops it and regains it before
  * exiting.
  */
-
 static void wait_for_free_buffer(struct dm_bufio_client *c)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -377,7 +368,6 @@ static void wait_for_free_buffer(struct dm_bufio_client *c)
  *
  * May drop the lock and regain it.
  */
-
 static struct dm_buffer *alloc_buffer_wait(struct dm_bufio_client *c)
 {
 	struct dm_buffer *b;
@@ -413,7 +403,6 @@ retry:
 /*
  * Free a buffer and wake other threads waiting for free buffers.
  */
-
 static void free_buffer_wake(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
@@ -433,7 +422,6 @@ static void free_buffer_wake(struct dm_buffer *b)
  * If we are over threshold_buffers, start freeing buffers.
  * If we're over "limit_buffers", blocks until we get under the limit.
  */
-
 static void check_watermark(struct dm_bufio_client *c)
 {
 	while (c->n_buffers > c->threshold_buffers) {
@@ -462,14 +450,15 @@ static void dm_bufio_dmio_complete(unsigned long error, void *context);
  * it is not vmalloc()ated, try using the bio interface.
  *
  * If the buffer is big, if it is vmalloc()ated or if the underlying device
- * rejects the bio because it is too large, use dmio layer to do the I/O.
+ * rejects the bio because it is too large, use dm-io layer to do the I/O.
  * dmio layer splits the I/O to multiple requests, solving the above
- * shorcomings.
+ * shortcomings.
  */
-
-static void dm_bufio_submit_io(struct dm_buffer *b, int rw, sector_t block, bio_end_io_t *end_io)
+static void dm_bufio_submit_io(struct dm_buffer *b, int rw, sector_t block,
+			       bio_end_io_t *end_io)
 {
-	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE && b->data_mode != DATA_MODE_VMALLOC) {
+	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
+	    b->data_mode != DATA_MODE_VMALLOC) {
 		char *ptr;
 		int len;
 		bio_init(&b->bio);
@@ -486,7 +475,9 @@ static void dm_bufio_submit_io(struct dm_buffer *b, int rw, sector_t block, bio_
 		ptr = b->data;
 		len = b->c->block_size;
 		do {
-			if (!bio_add_page(&b->bio, virt_to_page(ptr), len < PAGE_SIZE ? len : PAGE_SIZE, virt_to_phys(ptr) & (PAGE_SIZE - 1))) {
+			if (!bio_add_page(&b->bio, virt_to_page(ptr),
+					  len < PAGE_SIZE ? len : PAGE_SIZE,
+					  virt_to_phys(ptr) & (PAGE_SIZE - 1))) {
 				BUG_ON(b->c->block_size <= PAGE_SIZE);
 				goto use_dmio;
 			}
@@ -526,7 +517,6 @@ use_dmio : {
  * dm-io completion routine. It just calls b->bio.bi_end_io, pretending
  * that the request was handled directly with bio interface.
  */
-
 static void dm_bufio_dmio_complete(unsigned long error, void *context)
 {
 	struct dm_buffer *b = context;
@@ -537,7 +527,6 @@ static void dm_bufio_dmio_complete(unsigned long error, void *context)
 }
 
 /* Find a buffer in the hash. */
-
 static struct dm_buffer *dm_bufio_find(struct dm_bufio_client *c, sector_t block)
 {
 	struct dm_buffer *b;
@@ -559,8 +548,8 @@ static void read_endio(struct bio *bio, int error);
  * doesn't read the buffer from the disk (assuming that the caller overwrites
  * all the data and uses dm_bufio_mark_buffer_dirty to write new data back).
  */
-
-static void *dm_bufio_new_read(struct dm_bufio_client *c, sector_t block, struct dm_buffer **bp, int read)
+static void *dm_bufio_new_read(struct dm_bufio_client *c, sector_t block,
+			       struct dm_buffer **bp, int read)
 {
 	struct dm_buffer *b, *new_b = NULL;
 
@@ -572,11 +561,13 @@ retry_search:
 		if (new_b)
 			free_buffer_wake(new_b);
 		b->hold_count++;
-		relink_lru(b, test_bit(B_DIRTY, &b->state) || test_bit(B_WRITING, &b->state));
+		relink_lru(b, test_bit(B_DIRTY, &b->state) ||
+			   test_bit(B_WRITING, &b->state));
 unlock_wait_ret:
 		mutex_unlock(&c->lock);
 wait_ret:
-		wait_on_bit(&b->state, B_READING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit(&b->state, B_READING,
+			    do_io_schedule, TASK_UNINTERRUPTIBLE);
 		if (b->read_error) {
 			int error = b->read_error;
 			dm_bufio_release(b);
@@ -613,16 +604,16 @@ wait_ret:
 }
 
 /* Read the buffer and hold reference on it */
-
-void *dm_bufio_read(struct dm_bufio_client *c, sector_t block, struct dm_buffer **bp)
+void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
+		    struct dm_buffer **bp)
 {
 	return dm_bufio_new_read(c, block, bp, 1);
 }
 EXPORT_SYMBOL(dm_bufio_read);
 
 /* Get the buffer with possibly invalid data and hold reference on it */
-
-void *dm_bufio_new(struct dm_bufio_client *c, sector_t block, struct dm_buffer **bp)
+void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
+		   struct dm_buffer **bp)
 {
 	return dm_bufio_new_read(c, block, bp, 0);
 }
@@ -632,7 +623,6 @@ EXPORT_SYMBOL(dm_bufio_new);
  * The endio routine for reading: set the error, clear the bit and wake up
  * anyone waiting on the buffer.
  */
-
 static void read_endio(struct bio *bio, int error)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
@@ -647,7 +637,6 @@ static void read_endio(struct bio *bio, int error)
 /*
  * Release the reference held on the buffer.
  */
-
 void dm_bufio_release(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
@@ -677,7 +666,6 @@ EXPORT_SYMBOL(dm_bufio_release);
  * Mark that the data in the buffer were modified and the buffer needs to
  * be written back.
  */
-
 void dm_bufio_mark_buffer_dirty(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
@@ -701,13 +689,13 @@ static void write_endio(struct bio *bio, int error);
  * Finally, submit our write and don't wait on it. We set B_WRITING indicating
  * that there is a write in progress.
  */
-
 static void write_dirty_buffer(struct dm_buffer *b)
 {
 	if (!test_bit(B_DIRTY, &b->state))
 		return;
 	clear_bit(B_DIRTY, &b->state);
-	wait_on_bit_lock(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock(&b->state, B_WRITING,
+			 do_io_schedule, TASK_UNINTERRUPTIBLE);
 	dm_bufio_submit_io(b, WRITE, b->block, write_endio);
 }
 
@@ -715,7 +703,6 @@ static void write_dirty_buffer(struct dm_buffer *b)
  * The endio routine for write.
  * Set the error, clear B_WRITING bit and wake anyone who was waiting on it.
  */
-
 static void write_endio(struct bio *bio, int error)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
@@ -734,7 +721,6 @@ static void write_endio(struct bio *bio, int error)
 /*
  * Start writing all the dirty buffers. Don't wait for results.
  */
-
 void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c)
 {
 	struct dm_buffer *b;
@@ -756,7 +742,6 @@ EXPORT_SYMBOL(dm_bufio_write_dirty_buffers_async);
  *
  * Finally, we flush hardware disk cache.
  */
-
 int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 {
 	int a, f;
@@ -777,11 +762,13 @@ again:
 				dropped_lock = 1;
 				b->hold_count++;
 				mutex_unlock(&c->lock);
-				wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+				wait_on_bit(&b->state, B_WRITING,
+					    do_io_schedule, TASK_UNINTERRUPTIBLE);
 				mutex_lock(&c->lock);
 				b->hold_count--;
 			} else
-				wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+				wait_on_bit(&b->state, B_WRITING,
+					    do_io_schedule, TASK_UNINTERRUPTIBLE);
 		}
 		if (!test_bit(B_DIRTY, &b->state) && !test_bit(B_WRITING, &b->state))
 			relink_lru(b, 0);
@@ -794,7 +781,7 @@ again:
 		 * relinked to the clean list, so we won't loop scanning the
 		 * same buffer again and again.
 		 *
-		 * This may livelock if there is other thread simultaneously
+		 * This may livelock if there is another thread simultaneously
 		 * dirtying buffers, so we count the number of buffers walked
 		 * and if it exceeds the total number of buffers, it means that
 		 * someone is doing some writes simultaneously with us --- in
@@ -817,7 +804,6 @@ EXPORT_SYMBOL(dm_bufio_write_dirty_buffers);
 /*
  * Use dm-io to send and empty barrier flush the device.
  */
-
 int dm_bufio_issue_flush(struct dm_bufio_client *c)
 {
 	struct dm_io_request io_req = {
@@ -849,7 +835,6 @@ EXPORT_SYMBOL(dm_bufio_issue_flush);
  * location but not relink it, because that other user needs to have the buffer
  * at the same place.
  */
-
 void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block)
 {
 	struct dm_bufio_client *c = b->c;
@@ -873,14 +858,17 @@ retry:
 	BUG_ON(test_bit(B_READING, &b->state));
 	write_dirty_buffer(b);
 	if (b->hold_count == 1) {
-		wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit(&b->state, B_WRITING,
+			    do_io_schedule, TASK_UNINTERRUPTIBLE);
 		set_bit(B_DIRTY, &b->state);
 		unlink_buffer(b);
 		link_buffer(b, new_block, 1);
 	} else {
-		wait_on_bit_lock(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit_lock(&b->state, B_WRITING,
+				 do_io_schedule, TASK_UNINTERRUPTIBLE);
 		dm_bufio_submit_io(b, WRITE, new_block, write_endio);
-		wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit(&b->state, B_WRITING,
+			    do_io_schedule, TASK_UNINTERRUPTIBLE);
 	}
 	mutex_unlock(&c->lock);
 	dm_bufio_release(b);
@@ -889,15 +877,14 @@ EXPORT_SYMBOL(dm_bufio_release_move);
 
 /*
  * Free all the buffers (and possibly write them if they were dirty)
- * It is required that the calling theread doesn't have any reference on
+ * It is required that the calling thread doesn't have any reference on
  * any buffer.
  */
-
 void dm_bufio_drop_buffers(struct dm_bufio_client *c)
 {
 	struct dm_buffer *b;
 
-	/* an optimization ... so that the buffers are not writte one-by-one */
+	/* an optimization ... so that the buffers are not written one-by-one */
 	dm_bufio_write_dirty_buffers_async(c);
 
 	mutex_lock(&c->lock);
@@ -910,8 +897,9 @@ void dm_bufio_drop_buffers(struct dm_bufio_client *c)
 EXPORT_SYMBOL(dm_bufio_drop_buffers);
 
 /* Create the buffering interface */
-
-struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned blocksize, unsigned flags, __u64 cache_threshold, __u64 cache_limit)
+struct dm_bufio_client *
+dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
+		       unsigned flags, __u64 cache_threshold, __u64 cache_limit)
 {
 	int r;
 	struct dm_bufio_client *c;
@@ -928,7 +916,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->bdev = bdev;
 	c->block_size = blocksize;
 	c->sectors_per_block_bits = ffs(blocksize) - 1 - SECTOR_SHIFT;
-	c->pages_per_block_bits = ffs(blocksize) - 1 >= PAGE_SHIFT ? ffs(blocksize) - 1 - PAGE_SHIFT : 0;
+	c->pages_per_block_bits = (ffs(blocksize) - 1 >= PAGE_SHIFT) ?
+		(ffs(blocksize) - 1 - PAGE_SHIFT) : 0;
 	INIT_LIST_HEAD(&c->lru);
 	INIT_LIST_HEAD(&c->dirty_lru);
 	for (i = 0; i < DM_BUFIO_HASH_SIZE; i++)
@@ -938,7 +927,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	if (!cache_limit)
 		cache_limit = DM_BUFIO_LIMIT_MEMORY;
-	c->limit_buffers = cache_limit >> (c->sectors_per_block_bits + SECTOR_SHIFT);
+	c->limit_buffers = cache_limit >>
+		(c->sectors_per_block_bits + SECTOR_SHIFT);
 	if (!c->limit_buffers)
 		c->limit_buffers = 1;
 
@@ -946,12 +936,11 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		cache_threshold = DM_BUFIO_THRESHOLD_MEMORY;
 	if (cache_threshold > cache_limit)
 		cache_threshold = cache_limit;
-	c->threshold_buffers = cache_threshold >> (c->sectors_per_block_bits + SECTOR_SHIFT);
+	c->threshold_buffers = cache_threshold >>
+		(c->sectors_per_block_bits + SECTOR_SHIFT);
 	if (!c->threshold_buffers)
 		c->threshold_buffers = 1;
 
-	/*printk("%d %d\n", c->limit_buffers, c->threshold_buffers);*/
-
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
 
@@ -983,7 +972,6 @@ EXPORT_SYMBOL(dm_bufio_client_create);
  * Free the buffering interface.
  * It is required that there are no references on any buffers.
  */
-
 void dm_bufio_client_destroy(struct dm_bufio_client *c)
 {
 	unsigned i;
diff --git a/drivers/md/dm-bufio.h b/drivers/md/dm-bufio.h
index 7abc035..3261ea2 100644
--- a/drivers/md/dm-bufio.h
+++ b/drivers/md/dm-bufio.h
@@ -12,8 +12,10 @@
 struct dm_bufio_client;
 struct dm_buffer;
 
-void *dm_bufio_read(struct dm_bufio_client *c, sector_t block, struct dm_buffer **bp);
-void *dm_bufio_new(struct dm_bufio_client *c, sector_t block, struct dm_buffer **bp);
+void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
+		    struct dm_buffer **bp);
+void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
+		   struct dm_buffer **bp);
 void dm_bufio_release(struct dm_buffer *b);
 
 void dm_bufio_mark_buffer_dirty(struct dm_buffer *b);
@@ -23,7 +25,10 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c);
 
 void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
 
-struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned blocksize, unsigned flags, __u64 cache_threshold, __u64 cache_limit);
+struct dm_bufio_client *
+dm_bufio_client_create(struct block_device *bdev, unsigned blocksize,
+		       unsigned flags, __u64 cache_threshold,
+		       __u64 cache_limit);
 void dm_bufio_client_destroy(struct dm_bufio_client *c);
 void dm_bufio_drop_buffers(struct dm_bufio_client *c);
 
diff --git a/drivers/md/dm-multisnap-alloc.c b/drivers/md/dm-multisnap-alloc.c
index 482ed54..02f89be 100644
--- a/drivers/md/dm-multisnap-alloc.c
+++ b/drivers/md/dm-multisnap-alloc.c
@@ -16,7 +16,6 @@
 /*
  * Initialize the root bitmap, write it at the position "writing block".
  */
-
 void dm_multisnap_create_bitmaps(struct dm_exception_store *s, chunk_t *writing_block)
 {
 	struct dm_buffer *bp;
@@ -27,18 +26,23 @@ void dm_multisnap_create_bitmaps(struct dm_exception_store *s, chunk_t *writing_
 		(*writing_block)++;
 
 	if (*writing_block >= s->dev_size) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC, ("dm_multisnap_create_bitmaps: device is too small"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_bitmaps: device is too small"));
 		return;
 	}
 
 	if (*writing_block >= s->chunk_size << BITS_PER_BYTE_SHIFT) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC, ("dm_multisnap_create_bitmaps: invalid block to write: %llx", (unsigned long long)*writing_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_bitmaps: invalid block to write: %llx",
+					(unsigned long long)*writing_block));
 		return;
 	}
 
 	bmp = dm_bufio_new(s->bufio, *writing_block, &bp);
 	if (IS_ERR(bmp)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(bmp), ("dm_multisnap_create_bitmaps: can't create direct bitmap block at %llx", (unsigned long long)*writing_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(bmp),
+				       ("dm_multisnap_create_bitmaps: can't create direct bitmap block at %llx",
+					(unsigned long long)*writing_block));
 		return;
 	}
 	cond_resched();
@@ -64,10 +68,9 @@ static void dm_multisnap_add_bitmap(struct dm_exception_store *s);
 /*
  * Extend bitmaps to cover "new_size" area.
  *
- * While we extend bitmaps, we increase s->dev_size, so that the newly mapped
+ * While we extend bitmaps we increase s->dev_size so that the newly mapped
  * space can be used to hold further bitmaps.
  */
-
 void dm_multisnap_extend_bitmaps(struct dm_exception_store *s, chunk_t new_size)
 {
 	while (s->dev_size < new_size) {
@@ -103,7 +106,6 @@ void dm_multisnap_extend_bitmaps(struct dm_exception_store *s, chunk_t new_size)
  * Add one bitmap after the last bitmap. A helper function for
  * dm_multisnap_extend_bitmaps
  */
-
 static void dm_multisnap_add_bitmap(struct dm_exception_store *s)
 {
 	struct path_element path[MAX_BITMAP_DEPTH];
@@ -171,8 +173,8 @@ static void dm_multisnap_add_bitmap(struct dm_exception_store *s)
  * Return the pointer to the data, store the held buffer to bl.
  * Return the block in block and path in path.
  */
-
-void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap, struct dm_buffer **bp, chunk_t *block, struct path_element *path)
+void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap,
+			      struct dm_buffer **bp, chunk_t *block, struct path_element *path)
 {
 	__u64 *bmp;
 	unsigned idx;
@@ -184,14 +186,15 @@ void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap, str
 		bmp = dm_multisnap_read_block(s, blk, bp);
 		if (unlikely(!bmp)) {
 			/* error is already set in dm_multisnap_read_block */
-			DMERR("dm_multisnap_map_bitmap: can't read bitmap at %llx (%llx), pointed to by %llx (%llx), depth %d/%d, index %llx",
-				(unsigned long long)blk,
-				(unsigned long long)dm_multisnap_remap_block(s, blk),
-				(unsigned long long)parent,
-				(unsigned long long)dm_multisnap_remap_block(s, parent),
-				s->bitmap_depth - d,
-				s->bitmap_depth,
-				(unsigned long long)bitmap);
+			DMERR("dm_multisnap_map_bitmap: can't read bitmap at "
+			      "%llx (%llx), pointed to by %llx (%llx), depth %d/%d, index %llx",
+			      (unsigned long long)blk,
+			      (unsigned long long)dm_multisnap_remap_block(s, blk),
+			      (unsigned long long)parent,
+			      (unsigned long long)dm_multisnap_remap_block(s, parent),
+			      s->bitmap_depth - d,
+			      s->bitmap_depth,
+			      (unsigned long long)bitmap);
 			return NULL;
 		}
 		if (!d) {
@@ -200,7 +203,8 @@ void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap, str
 			return bmp;
 		}
 
-		idx = (bitmap >> ((d - 1) * (s->chunk_shift - BYTES_PER_POINTER_SHIFT))) & ((s->chunk_size - 1) >> BYTES_PER_POINTER_SHIFT);
+		idx = (bitmap >> ((d - 1) * (s->chunk_shift - BYTES_PER_POINTER_SHIFT))) &
+			((s->chunk_size - 1) >> BYTES_PER_POINTER_SHIFT);
 
 		if (unlikely(path != NULL)) {
 			path[s->bitmap_depth - d].block = blk;
@@ -221,7 +225,6 @@ void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap, str
  * Find a free bit from "start" to "end" (in bits).
  * If wide_search is nonzero, search for the whole free byte first.
  */
-
 static int find_bit(const void *bmp, unsigned start, unsigned end, int wide_search)
 {
 	const void *p;
@@ -258,7 +261,6 @@ ret_bit:
  * to find the valid number of bits. Note that bits past s->dev_size are
  * undefined, there can be anything, so we must not scan past this limit.
  */
-
 static unsigned bitmap_limit(struct dm_exception_store *s, bitmap_t bmp)
 {
 	if (bmp == (bitmap_t)(s->dev_size >> (s->chunk_shift + BITS_PER_BYTE_SHIFT)))
@@ -287,8 +289,8 @@ static unsigned bitmap_limit(struct dm_exception_store *s, bitmap_t bmp)
  * This is similar to what ext[23] does, so I suppose it is tuned well enough
  * that it won't fragment too much.
  */
-
-int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results, unsigned n_blocks, int flags)
+int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results,
+			      unsigned n_blocks, int flags)
 {
 	void *bmp;
 	struct dm_buffer *bp;
@@ -427,7 +429,8 @@ bp_release_return:
  * block was created since last commit.
  */
 
-void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp, void *ptr)
+void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block,
+					 struct dm_buffer **bp, void *ptr)
 {
 	int r;
 	chunk_t new_chunk;
@@ -446,15 +449,16 @@ void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t b
 	if (!data)
 		return NULL;
 
-	return dm_multisnap_duplicate_block(s, block, new_chunk, CB_BITMAP_IDX_NONE, bp, NULL);
+	return dm_multisnap_duplicate_block(s, block, new_chunk,
+					    CB_BITMAP_IDX_NONE, bp, NULL);
 }
 
 /*
  * Allocate a new block and return its data. Return the block number in *result
  * and buffer pointer in *bp.
  */
-
-void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result, struct dm_buffer **bp)
+void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result,
+				    struct dm_buffer **bp)
 {
 	int r = dm_multisnap_alloc_blocks(s, result, 1, 0);
 	if (unlikely(r < 0))
@@ -464,16 +468,16 @@ void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *resul
 }
 
 /*
- * Free the block immediatelly. You must be careful with this function because
+ * Free the block immediately. You must be careful with this function because
  * it doesn't follow log-structured protocol.
  *
  * It may be used only if
  * - the blocks to free were allocated since last transactions.
- * - or from freelist management, that makes the blocks is already recorded in
+ * - or from freelist management, which means the blocks were already recorded in
  *   a freelist (thus it would be freed again in case of machine crash).
  */
-
-void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block, unsigned n_blocks)
+void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block,
+					unsigned n_blocks)
 {
 	void *bmp;
 	struct dm_buffer *bp;
@@ -482,7 +486,9 @@ void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t bl
 		return;
 
 	if (unlikely(block + n_blocks > s->dev_size)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_free_block_immediate: freeing invalid blocks %llx, %x", (unsigned long long)block, n_blocks));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_free_block_immediate: freeing invalid blocks %llx, %x",
+					(unsigned long long)block, n_blocks));
 		return;
 	}
 
@@ -515,7 +521,6 @@ void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t bl
  * Flush tmp_remaps for bitmaps. Write the path from modified bitmaps to the
  * root.
  */
-
 void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s, struct tmp_remap *tmp_remap)
 {
 	chunk_t block;
@@ -533,7 +538,8 @@ void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s, struct
 	 * doesn't have to allocate anything.
 	 */
 	if (s->n_preallocated_blocks < s->bitmap_depth) {
-		if (unlikely(dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks, s->bitmap_depth * 2 - s->n_preallocated_blocks, 0) < 0))
+		if (unlikely(dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks,
+						       s->bitmap_depth * 2 - s->n_preallocated_blocks, 0) < 0))
 			return;
 		s->n_preallocated_blocks = s->bitmap_depth * 2;
 	}
@@ -579,5 +585,6 @@ void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s, struct
 	s->bitmap_root = new_blockn;
 
 skip_it:
-	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr, (s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
+	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr,
+		(s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
 }
diff --git a/drivers/md/dm-multisnap-blocks.c b/drivers/md/dm-multisnap-blocks.c
index 2b53cd7..8715ed9 100644
--- a/drivers/md/dm-multisnap-blocks.c
+++ b/drivers/md/dm-multisnap-blocks.c
@@ -11,13 +11,14 @@
 /*
  * Check that the block is valid.
  */
-
 static int check_invalid(struct dm_exception_store *s, chunk_t block)
 {
 	if (unlikely(block >= s->dev_size) ||
 	    unlikely(block == SB_BLOCK) ||
 	    unlikely(dm_multisnap_is_commit_block(s, block))) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("check_invalid: access to invalid part of the device: %llx, size %llx", (unsigned long long)block, (unsigned long long)s->dev_size));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("check_invalid: access to invalid part of the device: %llx, size %llx",
+					(unsigned long long)block, (unsigned long long)s->dev_size));
 		return 1;
 	}
 	return 0;
@@ -39,7 +40,6 @@ static struct tmp_remap *find_tmp_remap(struct dm_exception_store *s, chunk_t bl
 /*
  * Remap a block number according to tmp_remap table.
  */
-
 chunk_t dm_multisnap_remap_block(struct dm_exception_store *s, chunk_t block)
 {
 	struct tmp_remap *t;
@@ -55,8 +55,8 @@ chunk_t dm_multisnap_remap_block(struct dm_exception_store *s, chunk_t block)
  *
  * Do a possible block remapping according to tmp_remap table.
  */
-
-void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp)
+void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block,
+			      struct dm_buffer **bp)
 {
 	void *buf;
 	cond_resched();
@@ -71,7 +71,9 @@ void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block, struc
 
 	buf = dm_bufio_read(s->bufio, block, bp);
 	if (unlikely(IS_ERR(buf))) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf), ("dm_multisnap_read_block: error read chunk %llx", (unsigned long long)block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_read_block: error read chunk %llx",
+					(unsigned long long)block));
 		return NULL;
 	}
 	return buf;
@@ -90,7 +92,6 @@ struct uncommitted_record {
  * This function is used for optimizations, if it returns 0
  * it doesn't break correctness, it only degrades performance.
  */
-
 int dm_multisnap_block_is_uncommitted(struct dm_exception_store *s, chunk_t block)
 {
 	struct tmp_remap *t;
@@ -120,7 +121,6 @@ int dm_multisnap_block_is_uncommitted(struct dm_exception_store *s, chunk_t bloc
  * We can't use non-failing allocation because it could deadlock (wait for some
  * pages being written and that write could be directed through this driver).
  */
-
 void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t block)
 {
 	struct uncommitted_record *ur;
@@ -131,7 +131,8 @@ void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t bl
 	 * __GFP_NOMEMALLOC makes it less aggressive if the allocator recurses
 	 * into itself.
 	 */
-	ur = kmalloc(sizeof(struct uncommitted_record), GFP_NOWAIT | __GFP_NOWARN | __GFP_NOMEMALLOC);
+	ur = kmalloc(sizeof(struct uncommitted_record),
+		     GFP_NOWAIT | __GFP_NOWARN | __GFP_NOMEMALLOC);
 	if (!ur)
 		return;
 	ur->block = block;
@@ -142,14 +143,14 @@ void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t bl
  * Clear the register of uncommitted blocks. This is called on commit and
  * on unload.
  */
-
 void dm_multisnap_clear_uncommitted(struct dm_exception_store *s)
 {
 	int i;
 	for (i = 0; i < UNCOMMITTED_BLOCK_HASH_SIZE; i++) {
 		struct hlist_head *h = &s->uncommitted_blocks[i];
 		while (!hlist_empty(h)) {
-			struct uncommitted_record *ur = hlist_entry(h->first, struct uncommitted_record, hash);
+			struct uncommitted_record *ur =
+				hlist_entry(h->first, struct uncommitted_record, hash);
 			hlist_del(&ur->hash);
 			kfree(ur);
 		}
@@ -170,8 +171,9 @@ void dm_multisnap_clear_uncommitted(struct dm_exception_store *s)
  * A block that needs to be freed is returned in to_free. If to_free is NULL,
  * that block is freed immediatelly.
  */
-
-void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk, chunk_t new_chunk, bitmap_t bitmap_idx, struct dm_buffer **bp, chunk_t *to_free_ptr)
+void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk,
+				   chunk_t new_chunk, bitmap_t bitmap_idx,
+				   struct dm_buffer **bp, chunk_t *to_free_ptr)
 {
 	chunk_t to_free_val;
 	void *buf;
@@ -188,14 +190,17 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chu
 	t = find_tmp_remap(s, old_chunk);
 	if (t) {
 		if (unlikely(t->bitmap_idx != bitmap_idx)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_duplicate_block: bitmap_idx doesn't match, %X != %X", t->bitmap_idx, bitmap_idx));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_duplicate_block: bitmap_idx doesn't match, %X != %X",
+						t->bitmap_idx, bitmap_idx));
 			return NULL;
 		}
 		*to_free_ptr = t->new;
 		t->new = new_chunk;
 	} else {
 		if (unlikely(list_empty(&s->free_tmp_remaps))) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_duplicate_block: all remap blocks used"));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_duplicate_block: all remap blocks used"));
 			return NULL;
 		}
 		t = list_first_entry(&s->free_tmp_remaps, struct tmp_remap, list);
@@ -218,7 +223,9 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chu
 
 	buf = dm_bufio_read(s->bufio, new_chunk, bp);
 	if (IS_ERR(buf)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf), ("dm_multisnap_duplicate_block: error reading chunk %llx", (unsigned long long)new_chunk));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_duplicate_block: error reading chunk %llx",
+					(unsigned long long)new_chunk));
 		return NULL;
 	}
 	return buf;
@@ -227,7 +234,6 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chu
 /*
  * Remove an entry from tmp_remap table.
  */
-
 void dm_multisnap_free_tmp_remap(struct dm_exception_store *s, struct tmp_remap *t)
 {
 	list_del(&t->list);
@@ -241,8 +247,8 @@ void dm_multisnap_free_tmp_remap(struct dm_exception_store *s, struct tmp_remap
  * It is expected that the caller fills all the data in the block, calls
  * dm_bufio_mark_buffer_dirty and releases the buffer.
  */
-
-void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk, struct dm_buffer **bp)
+void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk,
+			      struct dm_buffer **bp)
 {
 	void *buf;
 
@@ -253,7 +259,9 @@ void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk, s
 
 	buf = dm_bufio_new(s->bufio, new_chunk, bp);
 	if (unlikely(IS_ERR(buf))) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf), ("dm_multisnap_make_block: error creating new block at chunk %llx", (unsigned long long)new_chunk));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_make_block: error creating new block at chunk %llx",
+					(unsigned long long)new_chunk));
 		return NULL;
 	}
 	return buf;
@@ -262,7 +270,6 @@ void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk, s
 /*
  * Free the given block and a possible tmp_remap shadow of it.
  */
-
 void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s, chunk_t block)
 {
 	struct tmp_remap *t;
@@ -281,7 +288,6 @@ void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s, chunk_
 /*
  * Return true if the block is a commit block.
  */
-
 int dm_multisnap_is_commit_block(struct dm_exception_store *s, chunk_t block)
 {
 	if (unlikely(block < FIRST_CB_BLOCK))
@@ -299,14 +305,13 @@ int dm_multisnap_is_commit_block(struct dm_exception_store *s, chunk_t block)
 /*
  * These two functions are used to avoid cycling on a corrupted device.
  *
- * If the data on the device are corrupted, we mark the device as errorneous,
+ * If the data on the device is corrupted, we mark the device as errorneous,
  * but we don't want to lockup the whole system. These functions help to achieve
  * this goal.
  *
  * cy->count is the number of processed blocks.
  * cy->key is the recorded block at last power-of-two count.
  */
-
 void dm_multisnap_init_stop_cycles(struct stop_cycles *cy)
 {
 	cy->key = 0;
@@ -316,7 +321,9 @@ void dm_multisnap_init_stop_cycles(struct stop_cycles *cy)
 int dm_multisnap_stop_cycles(struct dm_exception_store *s, struct stop_cycles *cy, chunk_t key)
 {
 	if (unlikely(cy->key == key) && unlikely(cy->count != 0)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_stop_cycles: cycle detected at chunk %llx", (unsigned long long)key));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_stop_cycles: cycle detected at chunk %llx",
+					(unsigned long long)key));
 		return -1;
 	}
 	cy->count++;
diff --git a/drivers/md/dm-multisnap-btree.c b/drivers/md/dm-multisnap-btree.c
index 722d842..a7e3b60 100644
--- a/drivers/md/dm-multisnap-btree.c
+++ b/drivers/md/dm-multisnap-btree.c
@@ -12,8 +12,9 @@
  * Read one btree node and do basic consistency checks.
  * Any btree access should be done with this function.
  */
-
-static struct dm_multisnap_bt_node *dm_multisnap_read_btnode(struct dm_exception_store *s, int depth, chunk_t block, unsigned want_entries, struct dm_buffer **bp)
+static struct dm_multisnap_bt_node *
+dm_multisnap_read_btnode(struct dm_exception_store *s, int depth,
+			 chunk_t block, unsigned want_entries, struct dm_buffer **bp)
 {
 	struct dm_multisnap_bt_node *node;
 
@@ -25,17 +26,21 @@ static struct dm_multisnap_bt_node *dm_multisnap_read_btnode(struct dm_exception
 
 	if (unlikely(node->signature != BT_SIGNATURE)) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_read_btnode: bad signature on btree node %llx", (unsigned long long)block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_read_btnode: bad signature on btree node %llx",
+					(unsigned long long)block));
 		return NULL;
 	}
 
 	if (unlikely((unsigned)(le32_to_cpu(node->n_entries) - 1) >= s->btree_entries) ||
 	    (want_entries && unlikely(le32_to_cpu(node->n_entries) != want_entries))) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_read_btnode: bad number of entries in btree node %llx: %x, wanted %x",
-			(unsigned long long)block,
-			le32_to_cpu(node->n_entries),
-			want_entries));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_read_btnode: bad number of entries in btree node "
+					"%llx: %x, wanted %x",
+					(unsigned long long)block,
+					le32_to_cpu(node->n_entries),
+					want_entries));
 		return NULL;
 	}
 
@@ -49,7 +54,6 @@ static struct dm_multisnap_bt_node *dm_multisnap_read_btnode(struct dm_exception
  * with bits 32-47 set, so that the store could be read on a system with
  * 64-bit chunk_t.
  */
-
 static void write_orig_chunk(struct dm_multisnap_bt_entry *be, chunk_t n)
 {
 	write_48(be, orig_chunk, n);
@@ -61,10 +65,11 @@ static void write_orig_chunk(struct dm_multisnap_bt_entry *be, chunk_t n)
  * Add an entry (key, new_chunk) at an appropriate index to the btree node.
  * Move the existing entries
  */
-
-static void add_at_idx(struct dm_multisnap_bt_node *node, unsigned index, struct bt_key *key, chunk_t new_chunk)
+static void add_at_idx(struct dm_multisnap_bt_node *node, unsigned index,
+		       struct bt_key *key, chunk_t new_chunk)
 {
-	memmove(&node->entries[index + 1], &node->entries[index], (le32_to_cpu(node->n_entries) - index) * sizeof(struct dm_multisnap_bt_entry));
+	memmove(&node->entries[index + 1], &node->entries[index],
+		(le32_to_cpu(node->n_entries) - index) * sizeof(struct dm_multisnap_bt_entry));
 	write_orig_chunk(&node->entries[index], key->chunk);
 	write_48(&node->entries[index], new_chunk, new_chunk);
 	node->entries[index].snap_from = cpu_to_mikulas_snapid(key->snap_from);
@@ -77,7 +82,6 @@ static void add_at_idx(struct dm_multisnap_bt_node *node, unsigned index, struct
  * Create an initial btree.
  * (*writing_block) is updated to point after the btree.
  */
-
 void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_block)
 {
 	struct dm_buffer *bp;
@@ -88,13 +92,16 @@ void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_bl
 		(*writing_block)++;
 
 	if (*writing_block >= s->dev_size) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC, ("dm_multisnap_create_btree: device is too small"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_btree: device is too small"));
 		return;
 	}
 
 	node = dm_bufio_new(s->bufio, *writing_block, &bp);
 	if (IS_ERR(node)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(node), ("dm_multisnap_create_btree: 't create direct bitmap block at %llx", (unsigned long long)*writing_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(node),
+				       ("dm_multisnap_create_btree: 't create direct bitmap block at %llx",
+					(unsigned long long)*writing_block));
 		return;
 	}
 	memset(node, 0, s->chunk_size);
@@ -123,7 +130,6 @@ void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_bl
  *	0: the entry matches the key (both entry and key have ranges, a match
  *		is returned when the ranges overlap)
  */
-
 static int compare_key(struct dm_multisnap_bt_entry *e, struct bt_key *key)
 {
 	chunk_t orig_chunk = read_48(e, orig_chunk);
@@ -146,8 +152,8 @@ static int compare_key(struct dm_multisnap_bt_entry *e, struct bt_key *key)
  * 	*result - if found, then the first entry in the requested range
  *		- if not found, then the first entry after the requested range
  */
-
-static int binary_search(struct dm_multisnap_bt_node *node, struct bt_key *key, unsigned *result)
+static int binary_search(struct dm_multisnap_bt_node *node, struct bt_key *key,
+			 unsigned *result)
 {
 	int c;
 	int first = 0;
@@ -182,8 +188,9 @@ static int binary_search(struct dm_multisnap_bt_node *node, struct bt_key *key,
  *	this node is returned (the buffer must be released with
  *	dm_bufio_release). Also, path with s->bt_depth entries is returned.
  */
-
-static int walk_btree(struct dm_exception_store *s, struct bt_key *key, struct dm_multisnap_bt_node **nodep, struct dm_buffer **bp, struct path_element path[MAX_BT_DEPTH])
+static int walk_btree(struct dm_exception_store *s, struct bt_key *key,
+		      struct dm_multisnap_bt_node **nodep, struct dm_buffer **bp,
+		      struct path_element path[MAX_BT_DEPTH])
 {
 #define		node (*nodep)
 	int r;
@@ -212,16 +219,19 @@ static int walk_btree(struct dm_exception_store *s, struct bt_key *key, struct d
 		if (unlikely(last_chunk != want_last_chunk) ||
 		    unlikely(last_snapid != want_last_snapid)) {
 			dm_bufio_release(*bp);
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("walk_btree: invalid last entry in node %llx/%llx: last_chunk %llx, want_last_chunk %llx, last_snapid: %llx, want_last_snapid: %llx, searching for %llx, %llx-%llx",
-				(unsigned long long)block,
-				(unsigned long long)dm_multisnap_remap_block(s, block),
-				(unsigned long long)last_chunk,
-				(unsigned long long)want_last_chunk,
-				(unsigned long long)last_snapid,
-				(unsigned long long)want_last_snapid,
-				(unsigned long long)key->chunk,
-				(unsigned long long)key->snap_from,
-				(unsigned long long)key->snap_to));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("walk_btree: invalid last entry in node %llx/%llx: "
+						"last_chunk %llx, want_last_chunk %llx, last_snapid: %llx, "
+						"want_last_snapid: %llx, searching for %llx, %llx-%llx",
+						(unsigned long long)block,
+						(unsigned long long)dm_multisnap_remap_block(s, block),
+						(unsigned long long)last_chunk,
+						(unsigned long long)want_last_chunk,
+						(unsigned long long)last_snapid,
+						(unsigned long long)want_last_snapid,
+						(unsigned long long)key->chunk,
+						(unsigned long long)key->snap_from,
+						(unsigned long long)key->snap_to));
 			return -1;
 		}
 
@@ -248,8 +258,8 @@ static int walk_btree(struct dm_exception_store *s, struct bt_key *key, struct d
  *	In case the node is found, key contains updated key and result contains
  *	the resulting chunk.
  */
-
-int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key, chunk_t *result)
+int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t *result)
 {
 	struct dm_multisnap_bt_node *node;
 	struct path_element path[MAX_BT_DEPTH];
@@ -278,8 +288,10 @@ int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key,
  * When the whole tree is scanned, return 0.
  * On error, return -1.
  */
-
-int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key, int (*call)(struct dm_exception_store *, struct dm_multisnap_bt_node *, struct dm_multisnap_bt_entry *, void *), void *cookie)
+int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key,
+			    int (*call)(struct dm_exception_store *, struct dm_multisnap_bt_node *,
+					struct dm_multisnap_bt_entry *, void *),
+			    void *cookie)
 {
 	struct dm_multisnap_bt_node *node;
 	struct path_element path[MAX_BT_DEPTH];
@@ -305,7 +317,8 @@ list_next_node:
 
 	for (depth = s->bt_depth - 2; depth >= 0; depth--) {
 		int idx;
-		node = dm_multisnap_read_btnode(s, depth, path[depth].block, path[depth].n_entries, &bp);
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
 		if (!node)
 			return -1;
 		idx = path[depth].idx + 1;
@@ -313,9 +326,10 @@ list_next_node:
 			r = compare_key(&node->entries[idx], key);
 			if (unlikely(r <= 0)) {
 				dm_bufio_release(bp);
-				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_list_btree: non-monotonic btree: node %llx, index %x",
-					(unsigned long long)path[depth].block,
-					idx));
+				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+						       ("dm_multisnap_list_btree: non-monotonic btree: node "
+							"%llx, index %x",
+							(unsigned long long)path[depth].block, idx));
 				return 0;
 			}
 			path[depth].idx = idx;
@@ -359,10 +373,12 @@ void dm_multisnap_add_to_btree(struct dm_exception_store *s, struct bt_key *key,
 	if (unlikely(r)) {
 		if (r > 0) {
 			dm_bufio_release(bp);
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_add_to_btree: adding key that already exists: %llx, %llx-%llx",
-				(unsigned long long)key->chunk,
-				(unsigned long long)key->snap_from,
-				(unsigned long long)key->snap_to));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_add_to_btree: adding key that already exists: "
+						"%llx, %llx-%llx",
+						(unsigned long long)key->chunk,
+						(unsigned long long)key->snap_from,
+						(unsigned long long)key->snap_to));
 		}
 		return;
 	}
@@ -392,9 +408,11 @@ go_up:
 	cond_resched();
 	memcpy(node, s->tmp_chunk, sizeof(struct dm_multisnap_bt_node));
 	cond_resched();
-	memcpy((char *)node + sizeof(struct dm_multisnap_bt_node), (char *)s->tmp_chunk + split_offset, split_size - split_offset);
+	memcpy((char *)node + sizeof(struct dm_multisnap_bt_node),
+	       (char *)s->tmp_chunk + split_offset, split_size - split_offset);
 	cond_resched();
-	memset((char *)node + sizeof(struct dm_multisnap_bt_node) + split_size - split_offset, 0, s->chunk_size - (sizeof(struct dm_multisnap_bt_node) + split_size - split_offset));
+	memset((char *)node + sizeof(struct dm_multisnap_bt_node) + split_size - split_offset, 0,
+	       s->chunk_size - (sizeof(struct dm_multisnap_bt_node) + split_size - split_offset));
 	cond_resched();
 	node->n_entries = cpu_to_le32(split_entries - split_index);
 
@@ -423,14 +441,16 @@ go_up:
 	dm_bufio_release(bp);
 
 	if (depth--) {
-		node = dm_multisnap_read_btnode(s, depth, path[depth].block, path[depth].n_entries, &bp);
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
 		if (unlikely(!node))
 			return;
 		goto go_up;
 	}
 
 	if (s->bt_depth >= MAX_BT_DEPTH) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_add_to_btree: max b+-tree depth reached"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_add_to_btree: max b+-tree depth reached"));
 		return;
 	}
 
@@ -459,8 +479,10 @@ go_up:
  * Change the last entry from old_chunk/old_snapid to new_chunk/new_snapid.
  * Start at a given depth and go upward to the root.
  */
-
-static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s, struct path_element path[MAX_BT_DEPTH], int depth, chunk_t old_chunk, mikulas_snapid_t old_snapid, chunk_t new_chunk, mikulas_snapid_t new_snapid)
+static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s,
+					  struct path_element path[MAX_BT_DEPTH], int depth,
+					  chunk_t old_chunk, mikulas_snapid_t old_snapid,
+					  chunk_t new_chunk, mikulas_snapid_t new_snapid)
 {
 	int idx;
 	struct dm_multisnap_bt_node *node;
@@ -470,7 +492,8 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s, struct p
 		return;
 
 	for (depth--; depth >= 0; depth--) {
-		node = dm_multisnap_read_btnode(s, depth, path[depth].block, path[depth].n_entries, &bp);
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
 		if (unlikely(!node))
 			return;
 
@@ -484,14 +507,17 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s, struct p
 		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_from) != old_snapid) ||
 		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_to) != old_snapid)) {
 			dm_bufio_release(bp);
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_fixup_backlimits: btree limit does not match, block %llx, idx %x, orig_chunk %llx, snap_from %llx, snap_to %llx, want %llx, %llx",
-				(unsigned long long)path[depth].block,
-				idx,
-				(unsigned long long)read_48(&node->entries[idx], orig_chunk),
-				(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_from),
-				(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_to),
-				(unsigned long long)old_chunk,
-				(unsigned long long)old_snapid));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_fixup_backlimits: btree limit does not match, block "
+						"%llx, idx %x, orig_chunk %llx, snap_from %llx, snap_to "
+						"%llx, want %llx, %llx",
+						(unsigned long long)path[depth].block,
+						idx,
+						(unsigned long long)read_48(&node->entries[idx], orig_chunk),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_from),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_to),
+						(unsigned long long)old_chunk,
+						(unsigned long long)old_snapid));
 			return;
 		}
 		write_48(&node->entries[idx], orig_chunk, new_chunk);
@@ -503,11 +529,12 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s, struct p
 		if (path[depth].idx != path[depth].n_entries - 1)
 			return;
 	}
-	DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_fixup_backlimits: the last entry modified, %llx/%llx -> %llx/%llx",
-		(unsigned long long)old_chunk,
-		(unsigned long long)old_snapid,
-		(unsigned long long)new_chunk,
-		(unsigned long long)new_snapid));
+	DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+			       ("dm_multisnap_fixup_backlimits: the last entry modified, %llx/%llx -> %llx/%llx",
+				(unsigned long long)old_chunk,
+				(unsigned long long)old_snapid,
+				(unsigned long long)new_chunk,
+				(unsigned long long)new_snapid));
 }
 
 /*
@@ -515,7 +542,6 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s, struct p
  * The key must have the same beginning or end as some existing entry (not both)
  * The range of the key is excluded from the entry.
  */
-
 void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_key *key)
 {
 	struct dm_multisnap_bt_node *node;
@@ -531,10 +557,11 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_k
 
 	if (!r) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_restrict_btree_entry: unknown key: %llx, %llx-%llx",
-			(unsigned long long)key->chunk,
-			(unsigned long long)key->snap_from,
-			(unsigned long long)key->snap_to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_restrict_btree_entry: unknown key: %llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
 		return;
 	}
 
@@ -553,12 +580,14 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_k
 		entry->snap_to = cpu_to_mikulas_snapid(new_to);
 	} else {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_restrict_btree_entry: invali range to restruct: %llx, %llx-%llx %llx-%llx",
-			(unsigned long long)key->chunk,
-			(unsigned long long)from,
-			(unsigned long long)to,
-			(unsigned long long)key->snap_from,
-			(unsigned long long)key->snap_to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_restrict_btree_entry: invali range to restruct: "
+					"%llx, %llx-%llx %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)from,
+					(unsigned long long)to,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
 		return;
 	}
 
@@ -566,14 +595,14 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_k
 	dm_bufio_release(bp);
 
 	if (unlikely(idx == path[s->bt_depth - 1].n_entries - 1))
-		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1, key->chunk, to, key->chunk, new_to);
+		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1,
+					      key->chunk, to, key->chunk, new_to);
 }
 
 /*
  * Expand range of an existing btree entry.
  * The key represents the whole new range (including the old and new part).
  */
-
 void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key *key)
 {
 	struct dm_multisnap_bt_node *node;
@@ -589,14 +618,17 @@ void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key
 
 	if (!r) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_extend_btree_entry: unknown key: %llx, %llx-%llx",
-			(unsigned long long)key->chunk,
-			(unsigned long long)key->snap_from,
-			(unsigned long long)key->snap_to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_extend_btree_entry: unknown key: "
+					"%llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
 		return;
 	}
 
-	node = dm_multisnap_alloc_duplicate_block(s, path[s->bt_depth - 1].block, &bp, node);
+	node = dm_multisnap_alloc_duplicate_block(s, path[s->bt_depth - 1].block,
+						  &bp, node);
 	if (unlikely(!node))
 		return;
 
@@ -615,13 +647,13 @@ void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key
 	dm_bufio_release(bp);
 
 	if (unlikely(idx == path[s->bt_depth - 1].n_entries - 1))
-		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1, key->chunk, to, key->chunk, new_to);
+		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1,
+					      key->chunk, to, key->chunk, new_to);
 }
 
 /*
  * Delete an entry from the btree.
  */
-
 void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key *key)
 {
 	struct dm_multisnap_bt_node *node;
@@ -642,10 +674,11 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key
 
 	if (unlikely(!r)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_delete_from_btree: unknown key: %llx, %llx-%llx",
-			(unsigned long long)key->chunk,
-			(unsigned long long)key->snap_from,
-			(unsigned long long)key->snap_to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_from_btree: unknown key: %llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
 		return;
 	}
 
@@ -657,24 +690,28 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key
 	to = mikulas_snapid_to_cpu(entry->snap_to);
 	if (unlikely(from != key->snap_from) || unlikely(to != key->snap_to)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_restrict_btree: invali range to restruct: %llx, %llx-%llx %llx-%llx",
-			(unsigned long long)key->chunk,
-			(unsigned long long)from,
-			(unsigned long long)to,
-			(unsigned long long)key->snap_from,
-			(unsigned long long)key->snap_to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_from_btree: invalid range to restrict: "
+					"%llx, %llx-%llx %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)from,
+					(unsigned long long)to,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
 		return;
 	}
 
 	while (unlikely((n_entries = le32_to_cpu(node->n_entries)) == 1)) {
 		dm_bufio_release(bp);
 		if (unlikely(!depth)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_restrict_btree: b-tree is empty"));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_delete_from_btree: b-tree is empty"));
 			return;
 		}
 		dm_multisnap_free_block_and_duplicates(s, path[depth].block);
 		depth--;
-		node = dm_multisnap_read_btnode(s, depth, path[depth].block, path[depth].n_entries, &bp);
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
 		if (!node)
 			return;
 	}
@@ -686,7 +723,8 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key
 	idx = path[depth].idx;
 
 	cond_resched();
-	memmove(node->entries + idx, node->entries + idx + 1, (n_entries - idx - 1) * sizeof(struct dm_multisnap_bt_entry));
+	memmove(node->entries + idx, node->entries + idx + 1,
+		(n_entries - idx - 1) * sizeof(struct dm_multisnap_bt_entry));
 	cond_resched();
 	n_entries--;
 	memset(node->entries + n_entries, 0, sizeof(struct dm_multisnap_bt_entry));
@@ -701,7 +739,9 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key
 	dm_bufio_release(bp);
 
 	if (unlikely(idx == n_entries))
-		dm_multisnap_fixup_backlimits(s, path, depth, key->chunk, key->snap_to, last_one_chunk, last_one_snap_to);
+		dm_multisnap_fixup_backlimits(s, path, depth, key->chunk,
+					      key->snap_to, last_one_chunk,
+					      last_one_snap_to);
 }
 
 /*
@@ -709,8 +749,8 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key
  * Find the whole path for tmp_remap and write the path as new entries, from
  * the root.
  */
-
-void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s, struct tmp_remap *tmp_remap)
+void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s,
+					struct tmp_remap *tmp_remap)
 {
 	struct dm_buffer *bp;
 	struct dm_multisnap_bt_node *node;
@@ -723,7 +763,8 @@ void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s, struct tmp
 	int i;
 
 	if (s->n_preallocated_blocks < s->bt_depth) {
-		if (dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks, s->bt_depth - s->n_preallocated_blocks, 0) < 0)
+		if (dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks,
+					      s->bt_depth - s->n_preallocated_blocks, 0) < 0)
 			return;
 		s->n_preallocated_blocks = s->bt_depth;
 	}
@@ -751,17 +792,16 @@ void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s, struct tmp
 			goto found;
 
 	DMERR("block %llx/%llx was not found in btree when searching for %llx/%llx",
-		(unsigned long long)tmp_remap->old,
-		(unsigned long long)tmp_remap->new,
-		(unsigned long long)key.chunk,
-		(unsigned long long)key.snap_from);
+	      (unsigned long long)tmp_remap->old,
+	      (unsigned long long)tmp_remap->new,
+	      (unsigned long long)key.chunk,
+	      (unsigned long long)key.snap_from);
 	for (i = 0; i < s->bt_depth; i++)
 		DMERR("path[%d]: %llx/%x", i, (unsigned long long)path[i].block, path[i].idx);
 	dm_multisnap_set_error(s->dm, -EFSERROR);
 	return;
 
 found:
-
 	dm_multisnap_free_block(s, tmp_remap->old, 0);
 
 	new_blockn = tmp_remap->new;
@@ -774,7 +814,8 @@ found:
 			remapped = 1;
 			dm_bufio_release_move(bp, s->preallocated_blocks[results_ptr]);
 			dm_multisnap_free_block_and_duplicates(s, path[i].block);
-			node = dm_multisnap_read_btnode(s, i, s->preallocated_blocks[results_ptr], path[i].n_entries, &bp);
+			node = dm_multisnap_read_btnode(s, i, s->preallocated_blocks[results_ptr],
+							path[i].n_entries, &bp);
 			if (!node)
 				return;
 			dm_multisnap_block_set_uncommitted(s, s->preallocated_blocks[results_ptr]);
@@ -792,6 +833,6 @@ found:
 	s->bt_root = new_blockn;
 
 skip_it:
-	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr, (s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
+	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr,
+		(s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
 }
-
diff --git a/drivers/md/dm-multisnap-commit.c b/drivers/md/dm-multisnap-commit.c
index f44f2e7..78b2583 100644
--- a/drivers/md/dm-multisnap-commit.c
+++ b/drivers/md/dm-multisnap-commit.c
@@ -11,7 +11,6 @@
 /*
  * Flush existing tmp_remaps.
  */
-
 static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *s)
 {
 	struct tmp_remap *t;
@@ -26,21 +25,25 @@ static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *s)
 			 * if there are none, do bitmap remaps
 			 */
 			if (!list_empty(&s->used_bt_tmp_remaps)) {
-				t = container_of(s->used_bt_tmp_remaps.next, struct tmp_remap, list);
+				t = container_of(s->used_bt_tmp_remaps.next,
+						 struct tmp_remap, list);
 				dm_multisnap_bt_finalize_tmp_remap(s, t);
 				dm_multisnap_free_tmp_remap(s, t);
 				continue;
 			}
 		}
 
-/* else: 0 or 1 free remaps : finalize bitmaps */
+		/* else: 0 or 1 free remaps : finalize bitmaps */
 		if (!list_empty(&s->used_bitmap_tmp_remaps)) {
-			t = container_of(s->used_bitmap_tmp_remaps.next, struct tmp_remap, list);
+			t = container_of(s->used_bitmap_tmp_remaps.next,
+					 struct tmp_remap, list);
 			dm_multisnap_bitmap_finalize_tmp_remap(s, t);
 			dm_multisnap_free_tmp_remap(s, t);
 			continue;
 		} else {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_finalize_tmp_remaps: no bitmap tmp remaps, n_used_tmp_remaps %u", s->n_used_tmp_remaps));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_finalize_tmp_remaps: no bitmap tmp remaps, n_used_tmp_remaps %u",
+						s->n_used_tmp_remaps));
 			return;
 		}
 	}
@@ -58,7 +61,6 @@ static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *s)
  * when b+tree is consistent. It flushes tmp_remaps, so that tmp_remap array
  * doesn't overflow. This function doesn't commit anything.
  */
-
 void dm_multisnap_transition_mark(struct dm_exception_store *s)
 {
 	/*
@@ -76,14 +78,14 @@ void dm_multisnap_transition_mark(struct dm_exception_store *s)
  * Flush buffers. This is called without the lock to reduce lock contention.
  * The buffers will be flushed again, with the lock.
  */
-
 void dm_multisnap_prepare_for_commit(struct dm_exception_store *s)
 {
 	int r;
 
 	r = dm_bufio_write_dirty_buffers(s->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("dm_multisnap_prepare_for_commit: error writing data"));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_prepare_for_commit: error writing data"));
 		return;
 	}
 }
@@ -94,7 +96,6 @@ void dm_multisnap_prepare_for_commit(struct dm_exception_store *s)
  * It is valid to make multiple modifications to the exception store and
  * then commit them atomically at once with this function.
  */
-
 void dm_multisnap_commit(struct dm_exception_store *s)
 {
 	struct tmp_remap *t;
@@ -138,7 +139,8 @@ void dm_multisnap_commit(struct dm_exception_store *s)
 
 	r = dm_bufio_write_dirty_buffers(s->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("dm_multisnap_commit: error writing data"));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_commit: error writing data"));
 		return;
 	}
 
@@ -154,7 +156,9 @@ void dm_multisnap_commit(struct dm_exception_store *s)
 
 	cb = dm_bufio_new(s->bufio, cb_addr, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb), ("dm_multisnap_commit: can't allocate new commit block at %llx", (unsigned long long)cb_addr));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("dm_multisnap_commit: can't allocate new commit block at %llx",
+					(unsigned long long)cb_addr));
 		return;
 	}
 
@@ -198,7 +202,9 @@ void dm_multisnap_commit(struct dm_exception_store *s)
 	dm_bufio_release(bp);
 	r = dm_bufio_write_dirty_buffers(s->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("dm_multisnap_commit: can't write commit block at %llx", (unsigned long long)cb_addr));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_commit: can't write commit block at %llx",
+					(unsigned long long)cb_addr));
 		return;
 	}
 
@@ -208,13 +214,15 @@ void dm_multisnap_commit(struct dm_exception_store *s)
 
 	sb = dm_bufio_read(s->bufio, SB_BLOCK, &bp);
 	if (IS_ERR(sb)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb), ("dm_multisnap_commit: can't read super block"));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb),
+				       ("dm_multisnap_commit: can't read super block"));
 		return;
 	}
 
 	if (unlikely(sb->signature != SB_SIGNATURE)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_commit: invalid super block signature when committing"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_commit: invalid super block signature when committing"));
 		return;
 	}
 
diff --git a/drivers/md/dm-multisnap-daniel.c b/drivers/md/dm-multisnap-daniel.c
index df3fafb..00fd3c0 100644
--- a/drivers/md/dm-multisnap-daniel.c
+++ b/drivers/md/dm-multisnap-daniel.c
@@ -33,7 +33,8 @@
 /*-----------------------------------------------------------------
  * Persistent snapshots, by persistent we mean that the snapshot
  * will survive a reboot.
- *---------------------------------------------------------------*/
+ *---------------------------------------------------------------
+ */
 
 /*
  * We need to store a record of which parts of the origin have
@@ -279,7 +280,8 @@ static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *ps)
 	/* Mikulas: changed to GFP_NOIO */
 	b = kzalloc(sizeof(*b), GFP_NOIO);
 	if (!b) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM, ("%s %d: out of memory", __func__, __LINE__));
+		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+				       ("%s %d: out of memory", __func__, __LINE__));
 		return NULL;
 	}
 
@@ -287,7 +289,8 @@ static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *ps)
 	b->data = __vmalloc(ps->chunk_size, GFP_NOIO | __GFP_HIGHMEM, PAGE_KERNEL);
 	if (!b->data) {
 		kfree(b);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM, ("%s %d: out of memory", __func__, __LINE__));
+		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+				       ("%s %d: out of memory", __func__, __LINE__));
 		return NULL;
 	}
 
@@ -378,8 +381,10 @@ static int shared_free_chunk(struct dm_exception_store *ps, chunk_t chunk)
 	chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
 
 	if (!ext2_test_bit(idx, ps->bitmap)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR, ("%s: trying to free free block %lld %lld %u", __func__,
-		      (unsigned long long)chunk, (unsigned long long)ps->cur_bitmap_chunk, idx));
+		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				       ("%s: trying to free free block %lld %lld %u", __func__,
+					(unsigned long long)chunk,
+					(unsigned long long)ps->cur_bitmap_chunk, idx));
 	}
 
 	ext2_clear_bit(idx, ps->bitmap);
@@ -1112,9 +1117,10 @@ static void check_leaf(struct dm_exception_store *ps, struct leaf *leaf, u64 sna
 		for (p = emap(leaf, i); p < emap(leaf, i+1); p++) {
 			/* !!! should also check for any zero sharemaps here */
 			if (le64_to_cpu(p->share) & snapmask) {
-				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR, ("nonzero bits %016llx outside snapmask %016llx",
-				      (unsigned long long)p->share,
-				      (unsigned long long)snapmask));
+				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+						       ("nonzero bits %016llx outside snapmask %016llx",
+							(unsigned long long)p->share,
+							(unsigned long long)snapmask));
 			}
 		}
 	}
@@ -1382,7 +1388,7 @@ keep_prev_node:
 			} while (level < levels - 1);
 		}
 
-/* 		dirty_buffer_count_check(sb); */
+		/* dirty_buffer_count_check(sb); */
 		/*
 		 * Get the leaf indicated in the next index entry in the node
 		 * at this level.
@@ -1433,7 +1439,8 @@ found:
 	return 0;
 }
 
-static int shared_init(struct dm_multisnap *dm, struct dm_exception_store **sp, unsigned argc, char **argv, char **error)
+static int shared_init(struct dm_multisnap *dm, struct dm_exception_store **sp,
+		       unsigned argc, char **argv, char **error)
 {
 	int r;
 	struct dm_exception_store *ps;
@@ -1489,7 +1496,8 @@ static void shared_destroy(struct dm_exception_store *ps)
 	kfree(ps);
 }
 
-static int shared_allocate_snapid(struct dm_exception_store *ps, snapid_t *snapid, int snap_of_snap, snapid_t master)
+static int shared_allocate_snapid(struct dm_exception_store *ps,
+				  snapid_t *snapid, int snap_of_snap, snapid_t master)
 {
 	int i;
 
@@ -1511,11 +1519,13 @@ static int shared_allocate_snapid(struct dm_exception_store *ps, snapid_t *snapi
 static int shared_create_snapshot(struct dm_exception_store *ps, snapid_t snapid)
 {
 	if (snapid >= MAX_SNAPSHOTS) {
-		DMERR("shared_create_snapshot: invalid snapshot id %llx", (unsigned long long)snapid);
+		DMERR("shared_create_snapshot: invalid snapshot id %llx",
+		      (unsigned long long)snapid);
 		return -EINVAL;
 	}
 	if (ps->snapmask & 1LL << snapid) {
-		DMERR("shared_create_snapshot: snapshot with id %llx already exists", (unsigned long long)snapid);
+		DMERR("shared_create_snapshot: snapshot with id %llx already exists",
+		      (unsigned long long)snapid);
 		return -EINVAL;
 	}
 	ps->snapmask |= 1LL << snapid;
@@ -1561,7 +1571,8 @@ static snapid_t shared_get_next_snapid(struct dm_exception_store *ps, snapid_t s
 	return DM_SNAPID_T_ORIGIN;
 }
 
-static int shared_find_snapshot_chunk(struct dm_exception_store *ps, snapid_t snapid, chunk_t chunk, int write, chunk_t *result)
+static int shared_find_snapshot_chunk(struct dm_exception_store *ps, snapid_t snapid,
+				      chunk_t chunk, int write, chunk_t *result)
 {
 	unsigned levels = ps->tree_level;
 	struct etree_path path[levels + 1];
@@ -1593,7 +1604,8 @@ static int shared_query_next_remap(struct dm_exception_store *ps, chunk_t chunk)
 	return !origin_chunk_unique(buffer2leaf(leafbuf), chunk, ps->snapmask);
 }
 
-static void shared_add_next_remap(struct dm_exception_store *ps, union chunk_descriptor *cd, chunk_t *new_chunk)
+static void shared_add_next_remap(struct dm_exception_store *ps,
+				  union chunk_descriptor *cd, chunk_t *new_chunk)
 {
 	struct chunk_buffer *cb;
 	struct etree_path path[ps->tree_level + 1];
@@ -1613,8 +1625,9 @@ static void shared_add_next_remap(struct dm_exception_store *ps, union chunk_des
 
 	ret = origin_chunk_unique(buffer2leaf(cb), chunk, ps->snapmask);
 	if (ret) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR, ("%s %d: bug %llu %d", __func__, __LINE__,
-		       (unsigned long long)chunk, ret));
+		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				       ("%s %d: bug %llu %d", __func__, __LINE__,
+					(unsigned long long)chunk, ret));
 		return;
 	}
 
@@ -1629,7 +1642,8 @@ static void shared_add_next_remap(struct dm_exception_store *ps, union chunk_des
 	       (unsigned long long)*new_chunk);*/
 }
 
-static int shared_check_conflict(struct dm_exception_store *ps, union chunk_descriptor *cd, snapid_t snapid)
+static int shared_check_conflict(struct dm_exception_store *ps,
+				 union chunk_descriptor *cd, snapid_t snapid)
 {
 	return !!(cd->bitmask & (1LL << snapid));
 }
@@ -1695,5 +1709,3 @@ module_exit(dm_multisnapshot_daniel_module_exit);
 MODULE_DESCRIPTION(DM_NAME " multisnapshot Fujita/Daniel's exceptions store");
 MODULE_AUTHOR("Fujita Tomonorig, Daniel Phillips");
 MODULE_LICENSE("GPL");
-
-
diff --git a/drivers/md/dm-multisnap-delete.c b/drivers/md/dm-multisnap-delete.c
index 2dcc251..22705a3 100644
--- a/drivers/md/dm-multisnap-delete.c
+++ b/drivers/md/dm-multisnap-delete.c
@@ -24,7 +24,9 @@ struct list_cookie {
 #define RET_DO_FREE		2
 #define RET_RESCHEDULE		3
 
-static int list_callback(struct dm_exception_store *s, struct dm_multisnap_bt_node *node, struct dm_multisnap_bt_entry *bt, void *cookie)
+static int list_callback(struct dm_exception_store *s,
+			 struct dm_multisnap_bt_node *node,
+			 struct dm_multisnap_bt_entry *bt, void *cookie)
 {
 	struct list_cookie *lc = cookie;
 	mikulas_snapid_t found_from, found_to;
@@ -41,7 +43,9 @@ static int list_callback(struct dm_exception_store *s, struct dm_multisnap_bt_no
 	if (unlikely(!s->delete_rover_snapid))
 		s->delete_rover_chunk++;
 
-	if (!dm_multisnap_find_next_snapid_range(s, lc->key.snap_from, &found_from, &found_to) || found_from > lc->key.snap_to) {
+	if (!dm_multisnap_find_next_snapid_range(s, lc->key.snap_from,
+						 &found_from, &found_to) ||
+	    found_from > lc->key.snap_to) {
 		/*
 		 * This range maps unused snapshots, delete it.
 		 * But we can't do it now, so submit it to the caller;
@@ -113,7 +117,8 @@ static void delete_step(struct dm_exception_store *s)
 	}
 }
 
-void dm_multisnap_background_delete(struct dm_exception_store *s, struct dm_multisnap_background_work *bw)
+void dm_multisnap_background_delete(struct dm_exception_store *s,
+				    struct dm_multisnap_background_work *bw)
 {
 	if (unlikely(dm_multisnap_has_error(s->dm)))
 		return;
diff --git a/drivers/md/dm-multisnap-freelist.c b/drivers/md/dm-multisnap-freelist.c
index 791d291..6ec1476 100644
--- a/drivers/md/dm-multisnap-freelist.c
+++ b/drivers/md/dm-multisnap-freelist.c
@@ -11,7 +11,6 @@
 /*
  * Initialize in-memory freelist structure.
  */
-
 void dm_multisnap_init_freelist(struct dm_multisnap_freelist *fl, unsigned chunk_size)
 {
 	cond_resched();
@@ -29,7 +28,6 @@ void dm_multisnap_init_freelist(struct dm_multisnap_freelist *fl, unsigned chunk
  *	1 --- block was added
  *	0 --- block could not be added because the freelist is full
  */
-
 static int add_to_freelist(struct dm_exception_store *s, chunk_t block, unsigned flags)
 {
 	int i;
@@ -39,10 +37,11 @@ static int add_to_freelist(struct dm_exception_store *s, chunk_t block, unsigned
 		unsigned r = le16_to_cpu(fl->entries[i].run_length) & FREELIST_RL_MASK;
 		unsigned f = le16_to_cpu(fl->entries[i].run_length) & FREELIST_DATA_FLAG;
 		if (block >= x && block < x + r) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("add_to_freelist: freeing already free block %llx (%llx - %x)",
-				(unsigned long long)block,
-				(unsigned long long)x,
-				r));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("add_to_freelist: freeing already free block %llx (%llx - %x)",
+						(unsigned long long)block,
+						(unsigned long long)x,
+						r));
 			return -1;
 		}
 		if (likely(r < FREELIST_RL_MASK) && likely(f == flags)) {
@@ -71,23 +70,29 @@ inc_length:
 /*
  * Read a freelist block from the disk.
  */
-
-static struct dm_multisnap_freelist *read_freelist(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp)
+static struct dm_multisnap_freelist *
+read_freelist(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp)
 {
 	struct dm_multisnap_freelist *fl;
 	fl = dm_bufio_read(s->bufio, block, bp);
 	if (IS_ERR(fl)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl), ("read_freelist: can't read freelist block %llx", (unsigned long long)block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl),
+				       ("read_freelist: can't read freelist block %llx",
+					(unsigned long long)block));
 		return NULL;
 	}
 	if (fl->signature != FL_SIGNATURE) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("read_freelist: bad signature freelist block %llx", (unsigned long long)block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("read_freelist: bad signature freelist block %llx",
+					(unsigned long long)block));
 		return NULL;
 	}
 	if (le32_to_cpu(fl->n_entries) > dm_multisnap_freelist_entries(s->chunk_size)) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("read_freelist: bad number of entries in freelist block %llx", (unsigned long long)block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("read_freelist: bad number of entries in freelist block %llx",
+					(unsigned long long)block));
 		return NULL;
 	}
 	return fl;
@@ -97,7 +102,6 @@ static struct dm_multisnap_freelist *read_freelist(struct dm_exception_store *s,
  * Allocate a block and write the current in-memory freelist to it.
  * Then, clear the in-memory freelist.
  */
-
 static void alloc_write_freelist(struct dm_exception_store *s)
 {
 	chunk_t new_block;
@@ -109,7 +113,9 @@ static void alloc_write_freelist(struct dm_exception_store *s)
 
 	fl = dm_bufio_new(s->bufio, new_block, &bp);
 	if (IS_ERR(fl)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl), ("alloc_write_freelist: can't make new freelist block %llx", (unsigned long long)new_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl),
+				       ("alloc_write_freelist: can't make new freelist block %llx",
+					(unsigned long long)new_block));
 		return;
 	}
 
@@ -127,7 +133,6 @@ static void alloc_write_freelist(struct dm_exception_store *s)
  * It adds the block to the current freelist, if the freelist is full, it
  * flushes the freelist and makes a new one.
  */
-
 void dm_multisnap_free_block(struct dm_exception_store *s, chunk_t block, unsigned flags)
 {
 	if (likely(add_to_freelist(s, block, flags)))
@@ -146,7 +151,6 @@ void dm_multisnap_free_block(struct dm_exception_store *s, chunk_t block, unsign
 /*
  * Check if a given block is in a given freelist.
  */
-
 static int check_against_freelist(struct dm_multisnap_freelist *fl, chunk_t block)
 {
 	int i;
@@ -163,8 +167,8 @@ static int check_against_freelist(struct dm_multisnap_freelist *fl, chunk_t bloc
 /*
  * Check if a given block is in any freelist in a freelist chain.
  */
-
-static int check_against_freelist_chain(struct dm_exception_store *s, chunk_t fl_block, chunk_t block)
+static int check_against_freelist_chain(struct dm_exception_store *s,
+					chunk_t fl_block, chunk_t block)
 {
 	struct stop_cycles cy;
 	dm_multisnap_init_stop_cycles(&cy);
@@ -198,7 +202,6 @@ static int check_against_freelist_chain(struct dm_exception_store *s, chunk_t fl
  * - the current freelist chain
  * - the freelist chain that was active on last commit
  */
-
 int dm_multisnap_check_allocated_block(struct dm_exception_store *s, chunk_t block)
 {
 	int c;
@@ -221,7 +224,6 @@ int dm_multisnap_check_allocated_block(struct dm_exception_store *s, chunk_t blo
 /*
  * This is called prior to commit, it writes the current freelist to the disk.
  */
-
 void dm_multisnap_flush_freelist_before_commit(struct dm_exception_store *s)
 {
 	alloc_write_freelist(s);
@@ -235,8 +237,8 @@ void dm_multisnap_flush_freelist_before_commit(struct dm_exception_store *s)
 /*
  * Free the blocks in the freelist.
  */
-
-static void free_blocks_in_freelist(struct dm_exception_store *s, struct dm_multisnap_freelist *fl)
+static void free_blocks_in_freelist(struct dm_exception_store *s,
+				    struct dm_multisnap_freelist *fl)
 {
 	int i;
 	for (i = le32_to_cpu(fl->n_entries) - 1; i >= 0; i--) {
@@ -260,7 +262,6 @@ static void free_blocks_in_freelist(struct dm_exception_store *s, struct dm_mult
  * If the computer crashes while this operation is in progress, it is done again
  * after a mount --- thus, it maintains data consistency.
  */
-
 void dm_multisnap_load_freelist(struct dm_exception_store *s)
 {
 	chunk_t fl_block = s->freelist_ptr;
diff --git a/drivers/md/dm-multisnap-io.c b/drivers/md/dm-multisnap-io.c
index 9f5b1ad..7620ebe 100644
--- a/drivers/md/dm-multisnap-io.c
+++ b/drivers/md/dm-multisnap-io.c
@@ -13,8 +13,9 @@
  * It returns 1 if remapping exists and is read-only (shared by other snapshots)
  * and 2 if it exists and is read-write (not shared by anyone).
  */
-
-int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snapid, chunk_t chunk, int write, chunk_t *result)
+int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s,
+				     snapid_t snapid, chunk_t chunk,
+				     int write, chunk_t *result)
 {
 	int r;
 	struct bt_key key;
@@ -46,9 +47,9 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snap
 	 * We are writing to a snapshot --- check if anything outside <from-to>
 	 * range exists, if it does, it needs to be copied.
 	 */
-
 	if (key.snap_from < from) {
-		if (likely(dm_multisnap_find_next_snapid_range(s, key.snap_from, &find_from, &find_to))) {
+		if (likely(dm_multisnap_find_next_snapid_range(s, key.snap_from,
+							       &find_from, &find_to))) {
 			if (find_from < from) {
 				s->query_new_key.chunk = chunk;
 				s->query_new_key.snap_from = from;
@@ -64,7 +65,8 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snap
 			BUG(); /* we're asking for a SNAPID not in our tree */
 	}
 	if (key.snap_to > to) {
-		if (likely(dm_multisnap_find_next_snapid_range(s, to + 1, &find_from, &find_to))) {
+		if (likely(dm_multisnap_find_next_snapid_range(s, to + 1,
+							       &find_from, &find_to))) {
 			if (find_from <= key.snap_to) {
 				s->query_new_key.chunk = chunk;
 				s->query_new_key.snap_from = key.snap_from;
@@ -82,7 +84,6 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snap
 /*
  * Reset the query/remap state machine.
  */
-
 void dm_multisnap_reset_query(struct dm_exception_store *s)
 {
 	s->query_active = 0;
@@ -92,7 +93,6 @@ void dm_multisnap_reset_query(struct dm_exception_store *s)
 /*
  * Find the next snapid range to remap.
  */
-
 int dm_multisnap_query_next_remap(struct dm_exception_store *s, chunk_t chunk)
 {
 	int r;
@@ -143,8 +143,8 @@ next_btree_search:
 /*
  * Perform the remap on the range returned by dm_multisnap_query_next_remap.
  */
-
-void dm_multisnap_add_next_remap(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk)
+void dm_multisnap_add_next_remap(struct dm_exception_store *s,
+				 union chunk_descriptor *cd, chunk_t *new_chunk)
 {
 	int r;
 
@@ -169,8 +169,8 @@ void dm_multisnap_add_next_remap(struct dm_exception_store *s, union chunk_descr
 /*
  * Make the chunk writeable (i.e. unshare multiple snapshots).
  */
-
-void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk)
+void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s,
+				       union chunk_descriptor *cd, chunk_t *new_chunk)
 {
 	int r;
 
@@ -201,8 +201,8 @@ void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s, union chunk
 /*
  * Check if the snapshot belongs to the remap range specified by "cd".
  */
-
-int dm_multisnap_check_conflict(struct dm_exception_store *s, union chunk_descriptor *cd, snapid_t snapid)
+int dm_multisnap_check_conflict(struct dm_exception_store *s,
+				union chunk_descriptor *cd, snapid_t snapid)
 {
 	return snapid >= cd->range.from && snapid <= cd->range.to;
 }
diff --git a/drivers/md/dm-multisnap-mikulas-struct.h b/drivers/md/dm-multisnap-mikulas-struct.h
index 3ea1624..39eaa16 100644
--- a/drivers/md/dm-multisnap-mikulas-struct.h
+++ b/drivers/md/dm-multisnap-mikulas-struct.h
@@ -57,14 +57,14 @@
  *
  *	Super block
  *
- * Chunk 0 is the superblock. It is defined in struct multisnap_superblock.
+ * Chunk 0 is the superblock. It is defined in 'struct multisnap_superblock'.
  * The superblock contains chunk size, commit block stride, error (if non-zero,
  * then the exception store is invalid) and pointer to the current commit block.
  *
  *	Commit blocks
  *
  * Chunks 1, 1+cb_stride, 1+2*cb_stride, 1+3*cb_stride, etc. are commit blocks.
- * Chunks at these location ((location % cb_stride) == 1) are only used for
+ * Chunks at these locations ((location % cb_stride) == 1) are only used for
  * commit blocks, they can't be used for anything else. A commit block is
  * written each time a new state is committed. The snapshot store transitions
  * from one consistent state to another consistent state by writing a commit
@@ -104,8 +104,8 @@
  * leaf entry contains: old chunk (in the origin), new chunk (in the snapshot
  * store), the range of snapshot IDs for which this mapping applies. The b+tree
  * is keyed by (old chunk, snapshot ID range). The b+tree node is specified
- * in struct dm_multisnap_bt_node, the b+tree entry is in struct
- * dm_multisnap_bt_entry. The maximum number of entries in one node is specified
+ * in 'struct dm_multisnap_bt_node', the b+tree entry is in 'struct
+ * dm_multisnap_bt_entry'. The maximum number of entries in one node is specified
  * so that the node fits into one chunk.
  *
  * The internal nodes have the same structure as the leaf nodes, except that:
@@ -117,7 +117,7 @@
  *
  *	Snapshot IDs
  *
- * We use 64-bit snapshot IDs. The high 32 bits is the number of a snapshot
+ * We use 64-bit snapshot IDs. The high 32 bits is the number of a snapshot.
  * This number always increases by one when creating a new snapshot. The
  * snapshot IDs are never reused. It is expected that the admin won't create
  * 2^32 snapshots.
@@ -188,7 +188,7 @@
  * store the pair (40, 41) into the commit block.
  * Now, we want to change this node again: so write a new version to a chunk 42
  * and store the pair (40, 42) into the commit block.
- * Now, let's do the same operation for other noder --- the remap array in the
+ * Now, let's do the same operation for other node --- the remap array in the
  * commit block eventually fills up. When this happens, we expunge (40, 42) map
  * by writing the path from the root:
  * copy node 30 to 43, change the pointer from 40 to 42
@@ -204,14 +204,14 @@
  * thing would get into an infinite loop. So, to free blocks, a different method
  * is used: freelists.
  *
- * We have a structure dm_multisnap_freelist that contains an array of runs of
+ * We have a 'struct dm_multisnap_freelist' that contains an array of runs of
  * blocks to free. Each run is the pair (start, length). When we need to free
  * a block, we add the block to the freelist. We optionally allocate a free
- * list, if there is none freelist, or if the current freelist is full. If one
+ * list, if there is no freelist, or if the current freelist is full. If one
  * freelist is not sufficient, a linked list of freelists is being created.
  * In the commit we write the freelist location to the commit block and after
  * the commit, we free individual bits in the bitmaps. If the computer crashes
- * during freeing the bits, we just free the bits again on next mount.
+ * during freeing the bits we just free the bits again on next mount.
  */
 
 #ifndef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
@@ -345,7 +345,8 @@ struct dm_multisnap_bt_node {
 
 static inline unsigned dm_multisnap_btree_entries(unsigned chunk_size)
 {
-	return (chunk_size - sizeof(struct dm_multisnap_bt_node)) / sizeof(struct dm_multisnap_bt_entry);
+	return (chunk_size - sizeof(struct dm_multisnap_bt_node)) /
+		sizeof(struct dm_multisnap_bt_entry);
 }
 
 
@@ -372,7 +373,8 @@ struct dm_multisnap_freelist {
 
 static inline unsigned dm_multisnap_freelist_entries(unsigned chunk_size)
 {
-	return (chunk_size - sizeof(struct dm_multisnap_freelist)) / sizeof(struct dm_multisnap_freelist);
+	return (chunk_size - sizeof(struct dm_multisnap_freelist)) /
+		sizeof(struct dm_multisnap_freelist);
 }
 
 #endif
diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
index 0fc4195..ec6e30f 100644
--- a/drivers/md/dm-multisnap-mikulas.c
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -11,7 +11,6 @@
 /*
  * Initialize in-memory structures, belonging to the commit block.
  */
-
 static void init_commit_block(struct dm_exception_store *s)
 {
 	int i;
@@ -51,7 +50,6 @@ static void init_commit_block(struct dm_exception_store *s)
  * Load the commit block specified in s->valid_commit_block to memory
  * and populate in-memory structures.
  */
-
 static void load_commit_block(struct dm_exception_store *s)
 {
 	struct dm_buffer *bp;
@@ -64,12 +62,16 @@ static void load_commit_block(struct dm_exception_store *s)
 
 	cb = dm_bufio_read(s->bufio, s->valid_commit_block, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb), ("load_commit_block: can't re-read commit block %llx", (unsigned long long)s->valid_commit_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("load_commit_block: can't re-read commit block %llx",
+					(unsigned long long)s->valid_commit_block));
 		return;
 	}
 	if (cb->signature != CB_SIGNATURE) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("load_commit_block: bad signature when re-reading commit block %llx", (unsigned long long)s->valid_commit_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("load_commit_block: bad signature when re-reading commit block %llx",
+					(unsigned long long)s->valid_commit_block));
 		return;
 	}
 
@@ -90,7 +92,9 @@ static void load_commit_block(struct dm_exception_store *s)
 
 	if (s->bt_depth > MAX_BT_DEPTH || !s->bt_depth) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("load_commit_block: invalid b+-tree depth in commit block %llx", (unsigned long long)s->valid_commit_block));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("load_commit_block: invalid b+-tree depth in commit block %llx",
+					(unsigned long long)s->valid_commit_block));
 		return;
 	}
 
@@ -116,12 +120,14 @@ static void load_commit_block(struct dm_exception_store *s)
 	dm_bufio_release(bp);
 
 	if ((chunk_t)(dev_size + s->cb_stride) < (chunk_t)dev_size) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ERANGE, ("load_commit_block: device is too large. Compile kernel with 64-bit sector numbers"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ERANGE,
+				       ("load_commit_block: device is too large. Compile kernel with 64-bit sector numbers"));
 		return;
 	}
 	bitmap_depth = dm_multisnap_bitmap_depth(s->chunk_shift, dev_size);
 	if (bitmap_depth < 0) {
-		DM_MULTISNAP_SET_ERROR(s->dm, bitmap_depth, ("load_commit_block: device is too large"));
+		DM_MULTISNAP_SET_ERROR(s->dm, bitmap_depth,
+				       ("load_commit_block: device is too large"));
 		return;
 	}
 	s->dev_size = dev_size;
@@ -137,7 +143,6 @@ static void load_commit_block(struct dm_exception_store *s)
  * commit blocks linearly as long as the sequence number in the commit block
  * increases.
  */
-
 static void find_commit_block(struct dm_exception_store *s)
 {
 	struct dm_buffer *bp;
@@ -151,12 +156,16 @@ static void find_commit_block(struct dm_exception_store *s)
 try_next:
 	cb = dm_bufio_read(s->bufio, cb_addr, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb), ("find_commit_block: can't read commit block %llx", (unsigned long long)cb_addr));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("find_commit_block: can't read commit block %llx",
+					(unsigned long long)cb_addr));
 		return;
 	}
 	if (cb->signature != CB_SIGNATURE) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("find_commit_block: bad signature on commit block %llx", (unsigned long long)cb_addr));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("find_commit_block: bad signature on commit block %llx",
+					(unsigned long long)cb_addr));
 		return;
 	}
 
@@ -174,7 +183,8 @@ try_next:
 		}
 	}
 	if (!s->valid_commit_block) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("find_commit_block: no valid commit block"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("find_commit_block: no valid commit block"));
 		return;
 	}
 }
@@ -182,7 +192,6 @@ try_next:
 /*
  * Return device size in chunks.
  */
-
 static int get_size(struct dm_exception_store *s, chunk_t *size)
 {
 	__u64 dev_size;
@@ -197,7 +206,6 @@ static int get_size(struct dm_exception_store *s, chunk_t *size)
 /*
  * Initialize the whole snapshot store.
  */
-
 static void initialize_device(struct dm_exception_store *s)
 {
 	int r;
@@ -211,7 +219,8 @@ static void initialize_device(struct dm_exception_store *s)
 
 	r = get_size(s, &s->dev_size);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("initialize_device: device is too large. Compile kernel with 64-bit sector numbers"));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: device is too large. Compile kernel with 64-bit sector numbers"));
 		return;
 	}
 
@@ -220,27 +229,30 @@ static void initialize_device(struct dm_exception_store *s)
 
 	block_to_write = SB_BLOCK + 1;
 
-/* Write btree */
+	/* Write btree */
 	dm_multisnap_create_btree(s, &block_to_write);
 	if (dm_multisnap_has_error(s->dm))
 		return;
 
-/* Write bitmaps */
+	/* Write bitmaps */
 	dm_multisnap_create_bitmaps(s, &block_to_write);
 	if (dm_multisnap_has_error(s->dm))
 		return;
 
 	s->dev_size = block_to_write;
 
-/* Write commit blocks */
+	/* Write commit blocks */
 	if (FIRST_CB_BLOCK >= s->dev_size) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC, ("initialize_device: device is too small"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("initialize_device: device is too small"));
 		return;
 	}
 	for (cb_block = FIRST_CB_BLOCK; cb_block < s->dev_size; cb_block += s->cb_stride) {
 		cb = dm_bufio_new(s->bufio, cb_block, &bp);
 		if (IS_ERR(cb)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb), ("initialize_device: can't allocate commit block at %llx", (unsigned long long)cb_block));
+			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+					       ("initialize_device: can't allocate commit block at %llx",
+						(unsigned long long)cb_block));
 			return;
 		}
 		memset(cb, 0, s->chunk_size);
@@ -263,14 +275,16 @@ static void initialize_device(struct dm_exception_store *s)
 	}
 	r = dm_bufio_write_dirty_buffers(s->bufio);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("initialize_device: write error when initializing device"));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: write error when initializing device"));
 		return;
 	}
 
-/* Write super block */
+	/* Write super block */
 	sb = dm_bufio_new(s->bufio, SB_BLOCK, &bp);
 	if (IS_ERR(sb)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb), ("initialize_device: can't allocate super block"));
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb),
+				       ("initialize_device: can't allocate super block"));
 		return;
 	}
 	memset(sb, 0, s->chunk_size);
@@ -283,7 +297,8 @@ static void initialize_device(struct dm_exception_store *s)
 	dm_bufio_release(bp);
 	r = dm_bufio_write_dirty_buffers(s->bufio);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(s->dm, r, ("initialize_device: can't write super block"));
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: can't write super block"));
 		return;
 	}
 }
@@ -293,21 +308,22 @@ static void initialize_device(struct dm_exception_store *s)
  *
  * Note: the size can never decrease.
  */
-
 static void extend_exception_store(struct dm_exception_store *s, chunk_t new_size)
 {
 	struct dm_buffer *bp;
 	chunk_t cb_block;
 	struct multisnap_commit_block *cb;
 
-/* Write commit blocks */
+	/* Write commit blocks */
 	for (cb_block = FIRST_CB_BLOCK; cb_block < new_size; cb_block += s->cb_stride) {
 		cond_resched();
 		if (cb_block < s->dev_size)
 			continue;
 		cb = dm_bufio_new(s->bufio, cb_block, &bp);
 		if (IS_ERR(cb)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb), ("initialize_device: can't allocate commit block at %llx", (unsigned long long)cb_block));
+			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+					       ("initialize_device: can't allocate commit block at %llx",
+						(unsigned long long)cb_block));
 			return;
 		}
 		memset(cb, 0, s->chunk_size);
@@ -332,7 +348,6 @@ static void extend_exception_store(struct dm_exception_store *s, chunk_t new_siz
  * If the super block is zeroed, we do initialization.
  * Otherwise we report error.
  */
-
 static int read_super(struct dm_exception_store *s, char **error)
 {
 	struct dm_buffer *bp;
@@ -407,7 +422,8 @@ re_read:
 
 	if (e < 0) {
 		/* Don't read the B+-tree if there was an error */
-		DM_MULTISNAP_SET_ERROR(s->dm, e, ("read_super: activating invalidated snapshot store, error %d", e));
+		DM_MULTISNAP_SET_ERROR(s->dm, e,
+				       ("read_super: activating invalidated snapshot store, error %d", e));
 		return 0;
 	}
 
@@ -433,7 +449,6 @@ re_read:
  * If the device size has shrunk, we report an error and stop further
  * operations.
  */
-
 static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *s, int flags)
 {
 	int r;
@@ -448,7 +463,8 @@ static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *s, int
 
 	if (unlikely(new_size != s->dev_size)) {
 		if (unlikely(new_size < s->dev_size)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EINVAL, ("dm_multisnap_mikulas_lock_acquired: device shrinked"));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EINVAL,
+					       ("dm_multisnap_mikulas_lock_acquired: device shrinked"));
 			return;
 		}
 		extend_exception_store(s, new_size);
@@ -462,7 +478,9 @@ static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *s, int
 /*#define PRINT_BTREE*/
 
 #ifdef PRINT_BTREE
-static int print_btree_callback(struct dm_exception_store *s, struct dm_multisnap_bt_node *node, struct dm_multisnap_bt_entry *bt, void *cookie)
+static int print_btree_callback(struct dm_exception_store *s,
+				struct dm_multisnap_bt_node *node,
+				struct dm_multisnap_bt_entry *bt, void *cookie)
 {
 	printk(KERN_DEBUG "entry: %llx, %llx-%llx -> %llx\n",
 		(unsigned long long)read_48(bt, orig_chunk),
@@ -490,7 +508,8 @@ static void print_bitmaps(struct dm_exception_store *s)
 	for (c = 0; c < s->dev_size; c += s->chunk_size * 8) {
 		struct dm_buffer *bp;
 		unsigned i;
-		void *bmp = dm_multisnap_map_bitmap(s, c >> (s->chunk_shift + 3), &bp, NULL, NULL);
+		void *bmp = dm_multisnap_map_bitmap(s, c >> (s->chunk_shift + 3),
+						    &bp, NULL, NULL);
 		if (!bmp)
 			continue;
 		for (i = 0; i < s->chunk_size * 8; i++)
@@ -513,8 +532,9 @@ static void print_bitmaps(struct dm_exception_store *s)
  * Parse arguments, allocate structures and call read_super to read the data
  * from the disk.
  */
-
-static int dm_multisnap_mikulas_init(struct dm_multisnap *dm, struct dm_exception_store **sp, unsigned argc, char **argv, char **error)
+static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
+				     struct dm_exception_store **sp,
+				     unsigned argc, char **argv, char **error)
 {
 	int r, i;
 	struct dm_exception_store *s;
@@ -551,11 +571,13 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm, struct dm_exceptio
 		if (r)
 			goto bad_arguments;
 		if (!strcasecmp(string, "cache-threshold")) {
-			r = dm_multisnap_get_uint64(&argv, &argc, &s->cache_threshold, error);
+			r = dm_multisnap_get_uint64(&argv, &argc,
+						    &s->cache_threshold, error);
 			if (r)
 				goto bad_arguments;
 		} else if (!strcasecmp(string, "cache-limit")) {
-			r = dm_multisnap_get_uint64(&argv, &argc, &s->cache_limit, error);
+			r = dm_multisnap_get_uint64(&argv, &argc,
+						    &s->cache_limit, error);
 			if (r)
 				goto bad_arguments;
 		} else {
@@ -580,7 +602,9 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm, struct dm_exceptio
 		goto bad_freelist;
 	}
 
-	s->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(s->dm), s->chunk_size, 0, s->cache_threshold, s->cache_limit);
+	s->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(s->dm),
+					  s->chunk_size, 0, s->cache_threshold,
+					  s->cache_limit);
 	if (IS_ERR(s->bufio)) {
 		*error = "Can't create bufio client";
 		r = PTR_ERR(s->bufio);
@@ -591,7 +615,8 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm, struct dm_exceptio
 	if (r)
 		goto bad_super;
 
-	if (s->flags & (DM_MULTISNAP_FLAG_DELETING | DM_MULTISNAP_FLAG_PENDING_DELETE))
+	if (s->flags & (DM_MULTISNAP_FLAG_DELETING |
+			DM_MULTISNAP_FLAG_PENDING_DELETE))
 		dm_multisnap_queue_work(s->dm, &s->delete_work);
 
 #ifdef PRINT_BTREE
@@ -619,7 +644,6 @@ bad_private:
 /*
  * Exit the exception store.
  */
-
 static void dm_multisnap_mikulas_exit(struct dm_exception_store *s)
 {
 	int i;
@@ -628,14 +652,16 @@ static void dm_multisnap_mikulas_exit(struct dm_exception_store *s)
 
 	i = 0;
 	while (!list_empty(&s->used_bitmap_tmp_remaps)) {
-		struct tmp_remap *t = list_first_entry(&s->used_bitmap_tmp_remaps, struct tmp_remap, list);
+		struct tmp_remap *t = list_first_entry(&s->used_bitmap_tmp_remaps,
+						       struct tmp_remap, list);
 		list_del(&t->list);
 		hlist_del(&t->hash_list);
 		i++;
 	}
 
 	while (!list_empty(&s->used_bt_tmp_remaps)) {
-		struct tmp_remap *t = list_first_entry(&s->used_bt_tmp_remaps, struct tmp_remap, list);
+		struct tmp_remap *t = list_first_entry(&s->used_bt_tmp_remaps,
+						       struct tmp_remap, list);
 		list_del(&t->list);
 		hlist_del(&t->hash_list);
 		i++;
@@ -664,8 +690,8 @@ static void dm_multisnap_mikulas_exit(struct dm_exception_store *s)
  * Return exception-store specific arguments. This is used in the proces of
  * constructing the table returned by device mapper.
  */
-
-static void dm_multisnap_status_table(struct dm_exception_store *s, char *result, unsigned maxlen)
+static void dm_multisnap_status_table(struct dm_exception_store *s,
+				      char *result, unsigned maxlen)
 {
 	int npar = 0;
 	if (s->cache_threshold)
@@ -677,11 +703,13 @@ static void dm_multisnap_status_table(struct dm_exception_store *s, char *result
 	dm_multisnap_adjust_string(&result, &maxlen);
 
 	if (s->cache_threshold) {
-		snprintf(result, maxlen, " cache-threshold %llu", (unsigned long long)s->cache_threshold);
+		snprintf(result, maxlen, " cache-threshold %llu",
+			 (unsigned long long)s->cache_threshold);
 		dm_multisnap_adjust_string(&result, &maxlen);
 	}
 	if (s->cache_limit) {
-		snprintf(result, maxlen, " cache-limit %llu", (unsigned long long)s->cache_limit);
+		snprintf(result, maxlen, " cache-limit %llu",
+			 (unsigned long long)s->cache_limit);
 		dm_multisnap_adjust_string(&result, &maxlen);
 	}
 }
@@ -730,4 +758,3 @@ module_exit(dm_multisnapshot_mikulas_module_exit);
 MODULE_DESCRIPTION(DM_NAME " multisnapshot Mikulas' exceptions store");
 MODULE_AUTHOR("Mikulas Patocka");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
index 36cf8c3..52c87e0 100644
--- a/drivers/md/dm-multisnap-mikulas.h
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -24,8 +24,11 @@
 
 typedef __u32 bitmap_t;
 
-#define read_48(struc, entry)		(le32_to_cpu((struc)->entry##1) | ((chunk_t)le16_to_cpu((struc)->entry##2) << 31 << 1))
-#define write_48(struc, entry, val)	do { (struc)->entry##1 = cpu_to_le32(val); (struc)->entry##2 = cpu_to_le16((chunk_t)(val) >> 31 >> 1); } while (0)
+#define read_48(struc, entry)		(le32_to_cpu((struc)->entry##1) |\
+					 ((chunk_t)le16_to_cpu((struc)->entry##2) << 31 << 1))
+
+#define write_48(struc, entry, val)	do { (struc)->entry##1 = cpu_to_le32(val); \
+		(struc)->entry##2 = cpu_to_le16((chunk_t)(val) >> 31 >> 1); } while (0)
 
 #define TMP_REMAP_HASH_SIZE		256
 #define TMP_REMAP_HASH(c)		((c) & (TMP_REMAP_HASH_SIZE - 1))
@@ -122,25 +125,37 @@ struct dm_exception_store {
 
 void dm_multisnap_create_bitmaps(struct dm_exception_store *s, chunk_t *writing_block);
 void dm_multisnap_extend_bitmaps(struct dm_exception_store *s, chunk_t new_size);
-void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap, struct dm_buffer **bp, chunk_t *block, struct path_element *path);
-int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results, unsigned n_blocks, int flags);
+void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap,
+			      struct dm_buffer **bp, chunk_t *block,
+			      struct path_element *path);
+int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results,
+			      unsigned n_blocks, int flags);
 #define ALLOC_DRY	1
-void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp, void *ptr);
-void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result, struct dm_buffer **bp);
-void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block, unsigned n_blocks);
-void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s, struct tmp_remap *tmp_remap);
+void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block,
+					 struct dm_buffer **bp, void *ptr);
+void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result,
+				    struct dm_buffer **bp);
+void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block,
+					unsigned n_blocks);
+void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s,
+					    struct tmp_remap *tmp_remap);
 
 /* dm-multisnap-blocks.c */
 
 chunk_t dm_multisnap_remap_block(struct dm_exception_store *s, chunk_t block);
-void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp);
+void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block,
+			      struct dm_buffer **bp);
 int dm_multisnap_block_is_uncommitted(struct dm_exception_store *s, chunk_t block);
 void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t block);
 void dm_multisnap_clear_uncommitted(struct dm_exception_store *s);
-void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk, chunk_t new_chunk, bitmap_t bitmap_idx, struct dm_buffer **bp, chunk_t *to_free);
+void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk,
+				   chunk_t new_chunk, bitmap_t bitmap_idx,
+				   struct dm_buffer **bp, chunk_t *to_free);
 void dm_multisnap_free_tmp_remap(struct dm_exception_store *s, struct tmp_remap *t);
-void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk, struct dm_buffer **bp);
-void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s, chunk_t block);
+void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk,
+			      struct dm_buffer **bp);
+void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s,
+					    chunk_t block);
 
 int dm_multisnap_is_commit_block(struct dm_exception_store *s, chunk_t block);
 
@@ -150,18 +165,26 @@ struct stop_cycles {
 };
 
 void dm_multisnap_init_stop_cycles(struct stop_cycles *cy);
-int dm_multisnap_stop_cycles(struct dm_exception_store *s, struct stop_cycles *cy, chunk_t key);
+int dm_multisnap_stop_cycles(struct dm_exception_store *s,
+			     struct stop_cycles *cy, chunk_t key);
 
 /* dm-multisnap-btree.c */
 
 void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_block);
-int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key, chunk_t *result);
-void dm_multisnap_add_to_btree(struct dm_exception_store *s, struct bt_key *key, chunk_t new_chunk);
+int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t *result);
+void dm_multisnap_add_to_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t new_chunk);
 void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_key *key);
 void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key *key);
 void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key *key);
-void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s, struct tmp_remap *tmp_remap);
-int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key, int (*call)(struct dm_exception_store *, struct dm_multisnap_bt_node *, struct dm_multisnap_bt_entry *, void *), void *cookie);
+void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s,
+					struct tmp_remap *tmp_remap);
+int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key,
+			    int (*call)(struct dm_exception_store *,
+					struct dm_multisnap_bt_node *,
+					struct dm_multisnap_bt_entry *, void *),
+			    void *cookie);
 
 /* dm-multisnap-commit.c */
 
@@ -171,7 +194,8 @@ void dm_multisnap_commit(struct dm_exception_store *s);
 
 /* dm-multisnap-delete.c */
 
-void dm_multisnap_background_delete(struct dm_exception_store *s, struct dm_multisnap_background_work *bw);
+void dm_multisnap_background_delete(struct dm_exception_store *s,
+				    struct dm_multisnap_background_work *bw);
 
 /* dm-multisnap-freelist.c */
 
@@ -183,31 +207,41 @@ void dm_multisnap_load_freelist(struct dm_exception_store *s);
 
 /* dm-multisnap-io.c */
 
-int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snapid, chunk_t chunk, int write, chunk_t *result);
+int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snapid,
+				     chunk_t chunk, int write, chunk_t *result);
 void dm_multisnap_reset_query(struct dm_exception_store *s);
 int dm_multisnap_query_next_remap(struct dm_exception_store *s, chunk_t chunk);
-void dm_multisnap_add_next_remap(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk);
-void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk);
-int dm_multisnap_check_conflict(struct dm_exception_store *s, union chunk_descriptor *cd, snapid_t snapid);
+void dm_multisnap_add_next_remap(struct dm_exception_store *s,
+				 union chunk_descriptor *cd, chunk_t *new_chunk);
+void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s,
+				       union chunk_descriptor *cd, chunk_t *new_chunk);
+int dm_multisnap_check_conflict(struct dm_exception_store *s, union chunk_descriptor *cd,
+				snapid_t snapid);
 
 /* dm-multisnap-snaps.c */
 
 snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s, snapid_t snapid);
 int dm_multisnap_compare_snapids_for_create(const void *p1, const void *p2);
-int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s, snapid_t snapid, snapid_t *from, snapid_t *to);
+int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s, snapid_t snapid,
+					snapid_t *from, snapid_t *to);
 snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s, snapid_t snapid);
 
 void dm_multisnap_destroy_snapshot_tree(struct dm_exception_store *s);
 void dm_multisnap_read_snapshots(struct dm_exception_store *s);
-int dm_multisnap_allocate_snapid(struct dm_exception_store *s, snapid_t *snapid, int snap_of_snap, snapid_t master);
+int dm_multisnap_allocate_snapid(struct dm_exception_store *s, snapid_t *snapid,
+				 int snap_of_snap, snapid_t master);
 int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid);
 int dm_multisnap_delete_snapshot(struct dm_exception_store *s, snapid_t snapid);
 
-void dm_multisnap_get_space(struct dm_exception_store *s, unsigned long long *chunks_total, unsigned long long *chunks_allocated, unsigned long long *chunks_metadata_allocated);
+void dm_multisnap_get_space(struct dm_exception_store *s, unsigned long long *chunks_total,
+			    unsigned long long *chunks_allocated,
+			    unsigned long long *chunks_metadata_allocated);
 
 #ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
-void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string, unsigned maxlen, snapid_t snapid);
-int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string, snapid_t *snapid, char **error);
+void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string,
+			       unsigned maxlen, snapid_t snapid);
+int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string,
+			     snapid_t *snapid, char **error);
 #endif
 
 #endif
diff --git a/drivers/md/dm-multisnap-snaps.c b/drivers/md/dm-multisnap-snaps.c
index c26125d..9947673 100644
--- a/drivers/md/dm-multisnap-snaps.c
+++ b/drivers/md/dm-multisnap-snaps.c
@@ -11,7 +11,6 @@
 /*
  * In-memory red-black tree denoting the used snapshot IDs.
  */
-
 struct snapshot_range {
 	struct rb_node node;
 	mikulas_snapid_t from;
@@ -22,8 +21,9 @@ struct snapshot_range {
  * Find a leftmost key in rbtree in the specified range (if add == 0)
  * or create a new key (if add != 0).
  */
-
-static struct snapshot_range *rb_find_insert_snapshot(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to, int add)
+static struct snapshot_range *
+rb_find_insert_snapshot(struct dm_exception_store *s,
+			mikulas_snapid_t from, mikulas_snapid_t to, int add)
 {
 	struct snapshot_range *new;
 	struct snapshot_range *found = NULL;
@@ -45,11 +45,13 @@ go_left:
 					goto go_left;
 				break;
 			} else {
-				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("rb_insert_snapshot: inserting overlapping entry: (%llx,%llx) overlaps (%llx,%llx)",
-					(unsigned long long)from,
-					(unsigned long long)to,
-					(unsigned long long)rn->from,
-					(unsigned long long)rn->to));
+				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+						       ("rb_insert_snapshot: inserting overlapping entry: "
+							"(%llx,%llx) overlaps (%llx,%llx)",
+							(unsigned long long)from,
+							(unsigned long long)to,
+							(unsigned long long)rn->from,
+							(unsigned long long)rn->to));
 				return NULL;
 			}
 		}
@@ -62,7 +64,8 @@ go_left:
 
 	new = kmalloc(sizeof(struct snapshot_range), GFP_KERNEL);
 	if (!new) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -ENOMEM, ("rb_insert_snapshot: can't allocate memory for snapshot descriptor"));
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOMEM,
+				       ("rb_insert_snapshot: can't allocate memory for snapshot descriptor"));
 		return NULL;
 	}
 
@@ -78,8 +81,9 @@ go_left:
 /*
  * Find a leftmost key in rbtree in the specified range.
  */
-
-static struct snapshot_range *rb_find_snapshot(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to)
+static struct snapshot_range *
+rb_find_snapshot(struct dm_exception_store *s,
+		 mikulas_snapid_t from, mikulas_snapid_t to)
 {
 	return rb_find_insert_snapshot(s, from, to, 0);
 }
@@ -87,8 +91,9 @@ static struct snapshot_range *rb_find_snapshot(struct dm_exception_store *s, mik
 /*
  * Insert a range to rbtree. It must not overlap with existing entries.
  */
-
-static int rb_insert_snapshot_unlocked(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to)
+static int rb_insert_snapshot_unlocked(struct dm_exception_store *s,
+				       mikulas_snapid_t from,
+				       mikulas_snapid_t to)
 {
 	struct snapshot_range *rn;
 	rn = rb_find_insert_snapshot(s, from, to, 1);
@@ -101,8 +106,8 @@ static int rb_insert_snapshot_unlocked(struct dm_exception_store *s, mikulas_sna
  * Hold the lock and insert a range to rbtree. It must not overlap with
  * existing entries.
  */
-
-static int rb_insert_snapshot(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to)
+static int rb_insert_snapshot(struct dm_exception_store *s,
+			      mikulas_snapid_t from, mikulas_snapid_t to)
 {
 	int r;
 	dm_multisnap_status_lock(s->dm);
@@ -115,17 +120,23 @@ static int rb_insert_snapshot(struct dm_exception_store *s, mikulas_snapid_t fro
  * "from" must be last entry in the existing range. This function extends the
  * range. The extended area must not overlap with another entry.
  */
-
-static int rb_extend_range(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to)
+static int rb_extend_range(struct dm_exception_store *s,
+			   mikulas_snapid_t from, mikulas_snapid_t to)
 {
 	struct snapshot_range *rn;
 	rn = rb_find_insert_snapshot(s, from, from, 0);
 	if (!rn) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("rb_extend_range: snapshot %llx not found", (unsigned long long)from));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_extend_range: snapshot %llx not found",
+					(unsigned long long)from));
 		return -1;
 	}
 	if (rn->to != from) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("rb_extend_range: bad attempt to extend range: %llx >= %llx", (unsigned long long)rn->to, (unsigned long long)from));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_extend_range: bad attempt to extend range: "
+					"%llx >= %llx",
+					(unsigned long long)rn->to,
+					(unsigned long long)from));
 		return -1;
 	}
 	dm_multisnap_status_lock(s->dm);
@@ -140,13 +151,17 @@ static int rb_extend_range(struct dm_exception_store *s, mikulas_snapid_t from,
  * It is valid to specify a subset of existing range, in this case, the range
  * is trimmed and possible split to two ranges.
  */
-
-static int rb_delete_range(struct dm_exception_store *s, mikulas_snapid_t from, mikulas_snapid_t to)
+static int rb_delete_range(struct dm_exception_store *s,
+			   mikulas_snapid_t from, mikulas_snapid_t to)
 {
 	struct snapshot_range *sr = rb_find_snapshot(s, from, from);
 
 	if (!sr || sr->to < to) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("rb_delete_range: deleting non-existing snapid %llx-%llx", (unsigned long long)from, (unsigned long long)to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_delete_range: deleting non-existing snapid "
+					"%llx-%llx",
+					(unsigned long long)from,
+					(unsigned long long)to));
 		return -1;
 	}
 
@@ -178,8 +193,8 @@ static int rb_delete_range(struct dm_exception_store *s, mikulas_snapid_t from,
  * Otherwise, return the next valid snapshot ID.
  * If there is no next valid snapshot ID, return DM_SNAPID_T_ORIGIN.
  */
-
-snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s, snapid_t snapid)
+snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s,
+				      snapid_t snapid)
 {
 	struct snapshot_range *rn;
 
@@ -198,8 +213,9 @@ snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s, snapid_t sna
  * A wrapper around rb_find_snapshot that is useable in other object files
  * that don't know about struct snapshot_range.
  */
-
-int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s, snapid_t snapid, snapid_t *from, snapid_t *to)
+int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s,
+					snapid_t snapid, snapid_t *from,
+					snapid_t *to)
 {
 	struct snapshot_range *rn;
 	rn = rb_find_snapshot(s, snapid, DM_SNAPID_T_MAX);
@@ -213,7 +229,6 @@ int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s, snapid_t s
 /*
  * Return true, if the snapid is master (not subsnapshot).
  */
-
 static int dm_multisnap_snapid_is_master(snapid_t snapid)
 {
 	return (snapid & DM_MIKULAS_SUBSNAPID_MASK) == DM_MIKULAS_SUBSNAPID_MASK;
@@ -224,14 +239,15 @@ static int dm_multisnap_snapid_is_master(snapid_t snapid)
  *
  * If it returns snapid, then no subsnapshot can be created.
  */
-
-snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s, snapid_t snapid)
+snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s,
+					    snapid_t snapid)
 {
 #ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
 	mikulas_snapid_t find_from, find_to;
 	if (unlikely(!dm_multisnap_snapid_is_master(snapid)))
 		return snapid;
-	if (!dm_multisnap_find_next_snapid_range(s, snapid, &find_from, &find_to))
+	if (!dm_multisnap_find_next_snapid_range(s, snapid,
+						 &find_from, &find_to))
 		BUG();
 	snapid &= ~DM_MIKULAS_SUBSNAPID_MASK;
 	if (snapid < find_from)
@@ -243,7 +259,6 @@ snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s, snapid
 /*
  * Deallocate the whole rbtree.
  */
-
 void dm_multisnap_destroy_snapshot_tree(struct dm_exception_store *s)
 {
 	struct rb_node *root;
@@ -258,7 +273,6 @@ void dm_multisnap_destroy_snapshot_tree(struct dm_exception_store *s)
 /*
  * Populate in-memory rbtree from on-disk b+tree.
  */
-
 void dm_multisnap_read_snapshots(struct dm_exception_store *s)
 {
 	struct bt_key snap_key;
@@ -279,7 +293,8 @@ find_next:
 
 	if (r) {
 		if (unlikely(snap_key.snap_to > DM_SNAPID_T_MAX)) {
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_read_snapshots: invalid snapshot id"));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_read_snapshots: invalid snapshot id"));
 			return;
 		}
 		r = rb_insert_snapshot(s, snap_key.snap_from, snap_key.snap_to);
@@ -295,8 +310,8 @@ find_next:
  * If snap_of_snap != 0, allocate a subsnapshot ID for snapshot "master".
  * Otherwise, allocate a new master snapshot ID.
  */
-
-int dm_multisnap_allocate_snapid(struct dm_exception_store *s, snapid_t *snapid, int snap_of_snap, snapid_t master)
+int dm_multisnap_allocate_snapid(struct dm_exception_store *s,
+				 snapid_t *snapid, int snap_of_snap, snapid_t master)
 {
 	if (snap_of_snap) {
 #ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
@@ -327,8 +342,8 @@ int dm_multisnap_allocate_snapid(struct dm_exception_store *s, snapid_t *snapid,
  * Add a snapid range to in-memory rbtree and on-disk b+tree.
  * Optionally, merge with the previous range. Don't merge with the next.
  */
-
-static int dm_multisnap_create_snapid_range(struct dm_exception_store *s, snapid_t from, snapid_t to)
+static int dm_multisnap_create_snapid_range(struct dm_exception_store *s,
+					    snapid_t from, snapid_t to)
 {
 	int r;
 	struct bt_key snap_key;
@@ -368,8 +383,8 @@ static int dm_multisnap_create_snapid_range(struct dm_exception_store *s, snapid
 /*
  * Delete a snapid range from in-memory rbtree and on-disk b+tree.
  */
-
-static int dm_multisnap_delete_snapid_range(struct dm_exception_store *s, snapid_t from, snapid_t to)
+static int dm_multisnap_delete_snapid_range(struct dm_exception_store *s,
+					    snapid_t from, snapid_t to)
 {
 	int r;
 	struct bt_key snap_key;
@@ -386,11 +401,15 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *s, snapid
 	r = dm_multisnap_find_in_btree(s, &snap_key, &ignore);
 	if (r <= 0) {
 		if (!r)
-			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_delete_snapshot: snapshot id %llx not found in b-tree", (unsigned long long)from));
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_delete_snapshot: snapshot id %llx not found in b-tree",
+						(unsigned long long)from));
 		return dm_multisnap_has_error(s->dm);
 	}
 	if (snap_key.snap_to < to) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_delete_snapshot: snapshot id %llx-%llx not found in b-tree", (unsigned long long)from, (unsigned long long)to));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_snapshot: snapshot id %llx-%llx not found in b-tree",
+					(unsigned long long)from, (unsigned long long)to));
 		return -EFSERROR;
 	}
 
@@ -424,7 +443,6 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *s, snapid
 /*
  * Create a subsnapshot.
  */
-
 static int dm_multisnap_create_subsnapshot(struct dm_exception_store *s, snapid_t snapid)
 {
 	int r;
@@ -432,13 +450,18 @@ static int dm_multisnap_create_subsnapshot(struct dm_exception_store *s, snapid_
 
 	master = snapid | DM_MIKULAS_SUBSNAPID_MASK;
 	if (!dm_multisnap_snapshot_exists(s->dm, master)) {
-		DMERR("dm_multisnap_create_subsnapshot: master snapshot with id %llx doesn't exist", (unsigned long long)snapid);
+		DMERR("dm_multisnap_create_subsnapshot: master snapshot with id %llx doesn't exist",
+		      (unsigned long long)snapid);
 		return -EINVAL;
 	}
 
 	next_sub = dm_multisnap_find_next_subsnapshot(s, master);
 	if (snapid < next_sub) {
-		DMERR("dm_multisnap_create_subsnapshot: invalid subsnapshot id %llx (allowed range %llx - %llx)", (unsigned long long)snapid, (unsigned long long)next_sub, (unsigned long long)master - 1);
+		DMERR("dm_multisnap_create_subsnapshot: invalid subsnapshot id %llx "
+		      "(allowed range %llx - %llx)",
+		      (unsigned long long)snapid,
+		      (unsigned long long)next_sub,
+		      (unsigned long long)master - 1);
 		return -EINVAL;
 	}
 
@@ -458,7 +481,6 @@ static int dm_multisnap_create_subsnapshot(struct dm_exception_store *s, snapid_
 /*
  * Create a snapshot or subsnapshot with a given snapid.
  */
-
 int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid)
 {
 	int r;
@@ -474,7 +496,8 @@ int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid)
 		return -EINVAL;
 	}
 	if (dm_multisnap_snapshot_exists(s->dm, snapid)) {
-		DMERR("dm_multisnap_create_snapshot: snapshot with id %llx already exists", (unsigned long long)snapid);
+		DMERR("dm_multisnap_create_snapshot: snapshot with id %llx already exists",
+		      (unsigned long long)snapid);
 		return -EINVAL;
 	}
 
@@ -492,13 +515,14 @@ int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid)
  * Delete a snapshot or subsnapshot with a given snapid.
  * Spawn background scanning for entries to delete.
  */
-
 int dm_multisnap_delete_snapshot(struct dm_exception_store *s, snapid_t snapid)
 {
 	int r;
 
 	if (!dm_multisnap_snapshot_exists(s->dm, snapid)) {
-		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR, ("dm_multisnap_delete_snapshot: snapshot id %llx not found in rb-tree", (unsigned long long)snapid));
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_snapshot: snapshot id %llx not found in rb-tree",
+					(unsigned long long)snapid));
 		return -EFSERROR;
 	}
 
@@ -518,7 +542,6 @@ int dm_multisnap_delete_snapshot(struct dm_exception_store *s, snapid_t snapid)
  * Sort the snapids for creating. Sort them linearly except that the master
  * goes before all subsnapshots.
  */
-
 int dm_multisnap_compare_snapids_for_create(const void *p1, const void *p2)
 {
 	mikulas_snapid_t s1 = *(const snapid_t *)p1;
@@ -543,8 +566,10 @@ int dm_multisnap_compare_snapids_for_create(const void *p1, const void *p2)
 /*
  * Return the number of total, allocated and metadata chunks.
  */
-
-void dm_multisnap_get_space(struct dm_exception_store *s, unsigned long long *chunks_total, unsigned long long *chunks_allocated, unsigned long long *chunks_metadata_allocated)
+void dm_multisnap_get_space(struct dm_exception_store *s,
+			    unsigned long long *chunks_total,
+			    unsigned long long *chunks_allocated,
+			    unsigned long long *chunks_metadata_allocated)
 {
 	dm_multisnap_status_assert_locked(s->dm);
 	*chunks_total = s->dev_size;
@@ -558,8 +583,8 @@ void dm_multisnap_get_space(struct dm_exception_store *s, unsigned long long *ch
  * Convert snapid to user-friendly format (so that he won't see things like
  * 4294967296).
  */
-
-void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string, unsigned maxlen, snapid_t snapid)
+void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string,
+			       unsigned maxlen, snapid_t snapid)
 {
 	unsigned master = snapid >> DM_MIKULAS_SNAPID_STEP_BITS;
 	unsigned subsnap = snapid & DM_MIKULAS_SUBSNAPID_MASK;
@@ -572,8 +597,8 @@ void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string, unsig
 /*
  * Convert snapid from user-friendly format to the internal 64-bit number.
  */
-
-int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string, snapid_t *snapid, char **error)
+int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string,
+			     snapid_t *snapid, char **error)
 {
 	unsigned long master;
 	unsigned long subsnap;
diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
index fe4fee6..758c013 100644
--- a/drivers/md/dm-multisnap.c
+++ b/drivers/md/dm-multisnap.c
@@ -134,11 +134,12 @@ static long dm_multisnap_jobs_in_flight(struct dm_multisnap *s)
 
 /*
  * Any reading/writing of snapids in table/status/message must go
- * through this functions, so that snapid format for userspace can
- * be overriden.
+ * through these functions, so that snapid format for userspace can
+ * be overridden.
  */
 
-static void print_snapid(struct dm_multisnap *s, char *string, unsigned maxlen, snapid_t snapid)
+static void print_snapid(struct dm_multisnap *s, char *string,
+			 unsigned maxlen, snapid_t snapid)
 {
 	if (s->store->print_snapid)
 		s->store->print_snapid(s->p, string, maxlen, snapid);
@@ -146,7 +147,8 @@ static void print_snapid(struct dm_multisnap *s, char *string, unsigned maxlen,
 		snprintf(string, maxlen, "%llu", (unsigned long long)snapid);
 }
 
-static int read_snapid(struct dm_multisnap *s, char *string, snapid_t *snapid, char **error)
+static int read_snapid(struct dm_multisnap *s, char *string,
+		       snapid_t *snapid, char **error)
 {
 	if (s->store->read_snapid)
 		return s->store->read_snapid(s->p, string, snapid, error);
@@ -302,7 +304,7 @@ static void bio_put_snapid(struct bio *bio, snapid_t snapid)
 	bio->bi_seg_back_size = snapid;
 }
 
-/* --- tracked chnuks --- */
+/* --- tracked chunks --- */
 
 static struct kmem_cache *tracked_chunk_cache;
 
@@ -338,7 +340,8 @@ static void pending_exception_ctor(void *pe_)
 	bio_list_init(&pe->bios);
 }
 
-static struct dm_multisnap_pending_exception *dm_multisnap_alloc_pending_exception(struct dm_multisnap *s, chunk_t chunk)
+static struct dm_multisnap_pending_exception *
+dm_multisnap_alloc_pending_exception(struct dm_multisnap *s, chunk_t chunk)
 {
 	struct dm_multisnap_pending_exception *pe;
 	/*
@@ -367,7 +370,7 @@ static void dm_multisnap_free_pending_exception(struct dm_multisnap_pending_exce
 static void dm_multisnap_wait_for_pending_exception(struct dm_multisnap *s)
 {
 	/*
-	 * Wait until there is something in the mempool. Free it immediatelly.
+	 * Wait until there is something in the mempool. Free it immediately.
 	 */
 	struct dm_multisnap_pending_exception *pe;
 
@@ -380,8 +383,8 @@ static void dm_multisnap_wait_for_pending_exception(struct dm_multisnap *s)
  *
  * If it does, queue the bio on the pending exception.
  */
-
-static int check_pending_io(struct dm_multisnap *s, struct bio *bio, chunk_t chunk, snapid_t snapid)
+static int check_pending_io(struct dm_multisnap *s, struct bio *bio,
+			    chunk_t chunk, snapid_t snapid)
 {
 	struct dm_multisnap_pending_exception *pe;
 	struct hlist_node *hn;
@@ -410,7 +413,6 @@ conflict:
  * Test if commit can be performed. If these two variables are not equal,
  * there are some pending kcopyd jobs and we must not commit.
  */
-
 int dm_multisnap_can_commit(struct dm_multisnap *s)
 {
 	return s->kcopyd_jobs_submitted_count == s->kcopyd_jobs_finished_count;
@@ -422,7 +424,6 @@ EXPORT_SYMBOL(dm_multisnap_can_commit);
  * This can be called only if dm_multisnap_can_commit returned true;
  * master_lock must be locked.
  */
-
 void dm_multisnap_call_commit(struct dm_multisnap *s)
 {
 	s->kcopyd_jobs_last_commit_count = s->kcopyd_jobs_finished_count;
@@ -436,17 +437,16 @@ EXPORT_SYMBOL(dm_multisnap_call_commit);
  * this function exits.
  * master_lock must be unlocked.
  *
- * If the commit cannot be performed immediatelly (because there are pending
+ * If the commit cannot be performed immediately (because there are pending
  * chunks being copied), the function drops the lock and polls. It won't
  * livelock --- either it will be possible to do the commit or someone
- * have done the commit already (commit_sequence changed).
+ * has done the commit already (commit_sequence changed).
  *
  * The polling is justified because this function is only called when deleting
  * a snapshot or when suspending the origin with postsuspend. These functions
  * are not performance-critical, thus 1ms delay won't cause a performance
  * problem.
  */
-
 static int dm_multisnap_force_commit(struct dm_multisnap *s)
 {
 	int err;
@@ -481,7 +481,8 @@ static void remap_callback(int read_err, unsigned long write_err, void *pe_)
 	struct dm_multisnap *s = pe->s;
 
 	if (unlikely((read_err | write_err) != 0))
-		DM_MULTISNAP_SET_ERROR(s, -EIO, ("remap_callback: kcopyd I/O error: %d, %lx", read_err, write_err));
+		DM_MULTISNAP_SET_ERROR(s, -EIO, ("remap_callback: kcopyd I/O error: "
+						 "%d, %lx", read_err, write_err));
 
 	list_add_tail(&pe->list, &s->pes_waiting_for_commit);
 
@@ -508,29 +509,28 @@ static void remap_callback(int read_err, unsigned long write_err, void *pe_)
 	dm_multisnap_call_commit(s);
 
 	do {
-		pe = container_of(s->pes_waiting_for_commit.next, struct dm_multisnap_pending_exception, list);
+		pe = container_of(s->pes_waiting_for_commit.next,
+				  struct dm_multisnap_pending_exception, list);
 
 		/*
 		 * When we are about to free the pending exception, we must
-		 * wait for all reads to the apropriate chunk to
-		 * finish.
+		 * wait for all reads to the appropriate chunk to finish.
 		 *
 		 * This prevents the following race condition:
 		 * - someone reads the chunk in the snapshot with no exception
 		 * - that read is remapped directly to the origin, the read
 		 *	is delayed for some reason
-		 * - someone other writes to the origin, this triggers realloc
+		 * - someone else writes to the origin, this triggers realloc
 		 * - the realloc finishes
 		 * - the write is dispatched to the origin
 		 * - the read submitted first is dispatched and reads modified
 		 *	data
 		 *
-		 * This race is very improbable (non-shared snapshots had this
+		 * This race is very improbable (non-shared snapshots have this
 		 * race too and it hasn't ever been reported seen, except in
 		 * artifically simulated cases). So we use active waiting with
 		 * msleep(1).
 		 */
-
 		while (chunk_is_tracked(s, pe->chunk))
 			msleep(1);
 
@@ -552,7 +552,10 @@ static void remap_callback(int read_err, unsigned long write_err, void *pe_)
 	blk_unplug(bdev_get_queue(s->snapshot->bdev));
 }
 
-static void dispatch_kcopyd(struct dm_multisnap *s, struct dm_multisnap_pending_exception *pe, int from_snapshot, chunk_t chunk, struct bio *bio, struct dm_io_region *dests, unsigned n_dests)
+static void dispatch_kcopyd(struct dm_multisnap *s,
+			    struct dm_multisnap_pending_exception *pe,
+			    int from_snapshot, chunk_t chunk, struct bio *bio,
+			    struct dm_io_region *dests, unsigned n_dests)
 {
 	unsigned i;
 	struct dm_io_region src;
@@ -565,7 +568,8 @@ static void dispatch_kcopyd(struct dm_multisnap *s, struct dm_multisnap_pending_
 	src.sector = chunk_to_sector(s, chunk);
 	src.count = s->chunk_size >> SECTOR_SHIFT;
 
-	if (likely(!from_snapshot) && unlikely(src.sector + src.count > s->origin_sectors)) {
+	if (likely(!from_snapshot) &&
+	    unlikely(src.sector + src.count > s->origin_sectors)) {
 		if (src.sector >= s->origin_sectors)
 			src.count = 0;
 		else
@@ -586,7 +590,6 @@ static void dispatch_kcopyd(struct dm_multisnap *s, struct dm_multisnap_pending_
  * Process bio on the origin.
  * Reads and barriers never go here, they are dispatched directly.
  */
-
 static void do_origin_write(struct dm_multisnap *s, struct bio *bio)
 {
 	int r;
@@ -599,11 +602,12 @@ static void do_origin_write(struct dm_multisnap *s, struct bio *bio)
 	BUG_ON(bio_rw(bio) != WRITE);
 
 	if (bio->bi_sector + (bio->bi_size >> SECTOR_SHIFT) > s->origin_sectors) {
-		DMERR("do_origin_write: access out of device, flags %lx, sector %llx, size %x, origin sectors %llx",
-			bio->bi_flags,
-			(unsigned long long)bio->bi_sector,
-			bio->bi_size,
-			(unsigned long long)s->origin_sectors);
+		DMERR("do_origin_write: access beyond end of device, flags %lx, "
+		      "sector %llx, size %x, origin sectors %llx",
+		      bio->bi_flags,
+		      (unsigned long long)bio->bi_sector,
+		      bio->bi_size,
+		      (unsigned long long)s->origin_sectors);
 		bio_endio(bio, -EIO);
 		return;
 	}
@@ -621,7 +625,6 @@ static void do_origin_write(struct dm_multisnap *s, struct bio *bio)
 
 	if (likely(!r)) {
 		/* There is nothing to remap */
-
 		if (unlikely(check_pending_io(s, bio, chunk, DM_SNAPID_T_ORIGIN)))
 			return;
 dispatch_write:
@@ -638,15 +641,7 @@ dispatch_write:
 	}
 
 	i = 0;
-	goto midcycle;
 	for (; i < DM_MULTISNAP_MAX_CHUNKS_TO_REMAP; i++) {
-		r = s->store->query_next_remap(s->p, chunk);
-		if (unlikely(r < 0))
-			goto free_err_endio;
-		if (likely(!r))
-			break;
-
-midcycle:
 		s->store->add_next_remap(s->p, &pe->desc[i], &new_chunk);
 		if (unlikely(dm_multisnap_has_error(s)))
 			goto free_err_endio;
@@ -654,6 +649,14 @@ midcycle:
 		dests[i].bdev = s->snapshot->bdev;
 		dests[i].sector = chunk_to_sector(s, new_chunk);
 		dests[i].count = s->chunk_size >> SECTOR_SHIFT;
+
+		r = s->store->query_next_remap(s->p, chunk);
+		if (unlikely(r < 0))
+			goto free_err_endio;
+		if (likely(!r)) {
+			i++;
+			break;
+		}
 	}
 
 	dispatch_kcopyd(s, pe, 0, chunk, bio, dests, i);
@@ -674,7 +677,6 @@ err_endio:
  * Process bio on the snapshot.
  * Barriers never go here, they are dispatched directly.
  */
-
 static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 {
 	chunk_t chunk, result, copy_from;
@@ -682,21 +684,21 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 	struct dm_multisnap_pending_exception *pe;
 	struct dm_io_region dest;
 
-	if (unlikely(!s->store->make_chunk_writeable) && unlikely(bio_rw(bio) == WRITE))
+	if (unlikely(!s->store->make_chunk_writeable) &&
+	    unlikely(bio_rw(bio) == WRITE))
 		goto err_endio;
 
 	if (unlikely(dm_multisnap_has_error(s)))
 		goto err_endio;
 
 	chunk = sector_to_chunk(s, bio->bi_sector);
-	r = s->store->find_snapshot_chunk(s->p, id, chunk, bio_rw(bio) == WRITE, &result);
+	r = s->store->find_snapshot_chunk(s->p, id, chunk,
+					  bio_rw(bio) == WRITE, &result);
 	if (unlikely(r < 0))
 		goto err_endio;
 
 	if (!r) {
-
 		/* Not found in the snapshot */
-
 		if (likely(bio_rw(bio) != WRITE)) {
 			union map_info *map_context;
 			struct dm_multisnap_tracked_chunk *c;
@@ -719,10 +721,9 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 			 * added to tracked_chunk_hash, the bio must be finished
 			 * and removed from the hash without taking master_lock.
 			 *
-			 * So we add it immediatelly before submitting the bio
+			 * So we add it immediately before submitting the bio
 			 * with generic_make_request.
 			 */
-
 			bio->bi_bdev = s->origin->bdev;
 
 			map_context = dm_get_mapinfo(bio);
@@ -750,9 +751,7 @@ static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
 			return;
 		}
 	} else {
-
 		/* Found in the snapshot */
-
 		if (unlikely(check_pending_io(s, bio, chunk, id)))
 			return;
 
@@ -802,7 +801,6 @@ failed_pe_allocation:
  * from other places (for example kcopyd callback), assuming that the caller
  * holds master_lock.
  */
-
 static void dm_multisnap_process_bios(struct dm_multisnap *s)
 {
 	struct bio *bio;
@@ -812,7 +810,9 @@ again:
 	cond_resched();
 
 	if (!list_empty(&s->background_works)) {
-		struct dm_multisnap_background_work *bw = list_entry(s->background_works.next, struct dm_multisnap_background_work, list);
+		struct dm_multisnap_background_work *bw =
+			list_entry(s->background_works.next,
+				   struct dm_multisnap_background_work, list);
 		list_del(&bw->list);
 		bw->queued = 0;
 		bw->work(s->p, bw);
@@ -821,7 +821,6 @@ again:
 	}
 
 	bio = dm_multisnap_dequeue_bio(s);
-
 	if (unlikely(!bio))
 		return;
 
@@ -846,7 +845,8 @@ again:
  * master lock held.
  */
 
-void dm_multisnap_queue_work(struct dm_multisnap *s, struct dm_multisnap_background_work *bw)
+void dm_multisnap_queue_work(struct dm_multisnap *s,
+			     struct dm_multisnap_background_work *bw)
 {
 	dm_multisnap_assert_locked(s);
 
@@ -861,7 +861,8 @@ void dm_multisnap_queue_work(struct dm_multisnap *s, struct dm_multisnap_backgro
 }
 EXPORT_SYMBOL(dm_multisnap_queue_work);
 
-void dm_multisnap_cancel_work(struct dm_multisnap *s, struct dm_multisnap_background_work *bw)
+void dm_multisnap_cancel_work(struct dm_multisnap *s,
+			      struct dm_multisnap_background_work *bw)
 {
 	dm_multisnap_assert_locked(s);
 
@@ -876,7 +877,6 @@ EXPORT_SYMBOL(dm_multisnap_cancel_work);
 /*
  * The main work thread.
  */
-
 static void dm_multisnap_work(struct work_struct *work)
 {
 	struct dm_multisnap *s = container_of(work, struct dm_multisnap, work);
@@ -886,7 +886,7 @@ static void dm_multisnap_work(struct work_struct *work)
 	dm_multisnap_unlock(s);
 
 	/*
-	 * If there was some mempool allocation failure, we must fail, outside
+	 * If there was some mempool allocation failure we must wait, outside
 	 * the lock, until there is some free memory.
 	 * If this branch is taken, the work is already queued again, so it
 	 * reexecutes after finding some memory.
@@ -914,7 +914,8 @@ static struct dm_multisnap *find_multisnapshot(struct block_device *origin)
 static DEFINE_MUTEX(exception_stores_lock);
 static LIST_HEAD(all_exception_stores);
 
-static struct dm_multisnap_exception_store *dm_multisnap_find_exception_store(const char *name)
+static struct dm_multisnap_exception_store *
+dm_multisnap_find_exception_store(const char *name)
 {
 	struct dm_multisnap_exception_store *store;
 
@@ -965,7 +966,8 @@ void dm_multisnap_unregister_exception_store(struct dm_multisnap_exception_store
 }
 EXPORT_SYMBOL(dm_multisnap_unregister_exception_store);
 
-static struct dm_multisnap_exception_store *dm_multisnap_get_exception_store(const char *name)
+static struct dm_multisnap_exception_store *
+dm_multisnap_get_exception_store(const char *name)
 {
 	struct dm_multisnap_exception_store *store;
 
@@ -994,7 +996,8 @@ static void dm_multisnap_put_exception_store(struct dm_multisnap_exception_store
 
 /* --- argument parser --- */
 
-int dm_multisnap_get_string(char ***argv, unsigned *argc, char **string, char **error)
+int dm_multisnap_get_string(char ***argv, unsigned *argc,
+			    char **string, char **error)
 {
 	if (!*argc) {
 		*error = "Not enough arguments";
@@ -1006,7 +1009,8 @@ int dm_multisnap_get_string(char ***argv, unsigned *argc, char **string, char **
 }
 EXPORT_SYMBOL(dm_multisnap_get_string);
 
-int dm_multisnap_get_uint64(char ***argv, unsigned *argc, __u64 *unsigned_int64, char **error)
+int dm_multisnap_get_uint64(char ***argv, unsigned *argc,
+			    __u64 *unsigned_int64, char **error)
 {
 	char *string;
 	int r = dm_multisnap_get_string(argv, argc, &string, error);
@@ -1024,7 +1028,8 @@ invalid_number:
 }
 EXPORT_SYMBOL(dm_multisnap_get_uint64);
 
-int dm_multisnap_get_uint(char ***argv, unsigned *argc, unsigned *unsigned_int, char **error)
+int dm_multisnap_get_uint(char ***argv, unsigned *argc,
+			  unsigned *unsigned_int, char **error)
 {
 	__u64 unsigned_int64;
 	int r = dm_multisnap_get_uint64(argv, argc, &unsigned_int64, error);
@@ -1039,7 +1044,8 @@ int dm_multisnap_get_uint(char ***argv, unsigned *argc, unsigned *unsigned_int,
 }
 EXPORT_SYMBOL(dm_multisnap_get_uint);
 
-int dm_multisnap_get_argcount(char ***argv, unsigned *argc, unsigned *unsigned_int, char **error)
+int dm_multisnap_get_argcount(char ***argv, unsigned *argc,
+			      unsigned *unsigned_int, char **error)
 {
 	int r = dm_multisnap_get_uint(argv, argc, unsigned_int, error);
 	if (r)
@@ -1138,10 +1144,10 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 		if (r)
 			goto bad_generic_arguments;
 
-	/* Synchronize snapshot list against a list given in the target table */
+		/* Synchronize snapshot list against the list given in the target table */
 		if (!strcasecmp(arg, "sync-snapshots"))
 			s->flags |= DM_MULTISNAP_SYNC_SNAPSHOTS;
-	/* Don't drop the snapshot store on error, rather stop the origin */
+		/* Don't drop the snapshot store on error, rather stop the origin */
 		else if (!strcasecmp(arg, "preserve-on-error"))
 			s->flags |= DM_MULTISNAP_PRESERVE_ON_ERROR;
 		else {
@@ -1151,14 +1157,16 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 		}
 	}
 
-	r = dm_get_device(ti, origin_path, 0, 0, FMODE_READ | FMODE_WRITE, &s->origin);
+	r = dm_get_device(ti, origin_path, 0, 0,
+			  FMODE_READ | FMODE_WRITE, &s->origin);
 	if (r) {
 		ti->error = "Could not get origin device";
 		goto bad_origin;
 	}
 	s->origin_sectors = i_size_read(s->origin->bdev->bd_inode) >> SECTOR_SHIFT;
 
-	r = dm_get_device(ti, snapshot_path, 0, 0, FMODE_READ | FMODE_WRITE, &s->snapshot);
+	r = dm_get_device(ti, snapshot_path, 0, 0,
+			  FMODE_READ | FMODE_WRITE, &s->snapshot);
 	if (r) {
 		ti->error = "Could not get snapshot device";
 		goto bad_snapshot;
@@ -1169,14 +1177,13 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 	 *
 	 * Currently, multisnapshot target is loaded just once, there is no
 	 * place where it would be reloaded (even lvchange --refresh doesn't
-	 * do it), so there is no need to handle loading the target multiple
+	 * do it).  So there is no need to handle loading the target multiple
 	 * times for the same devices and "handover" of the exception store.
 	 *
 	 * As a safeguard to protect against possible data corruption from
 	 * userspace misbehavior, we check that there is no other target loaded
 	 * that has the origin or the snapshot store on the same devices.
 	 */
-
 	list_for_each_entry(ss, &all_multisnapshots, list_all)
 		if (ss->origin->bdev == s->origin->bdev ||
 		    ss->snapshot->bdev == s->snapshot->bdev) {
@@ -1186,7 +1193,6 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 		}
 
 	/* Validate the chunk size */
-
 	if (chunk_size > INT_MAX / 512) {
 		ti->error = "Chunk size is too high";
 		r = -EINVAL;
@@ -1207,14 +1213,16 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 	s->chunk_size = chunk_size;
 	s->chunk_shift = ffs(chunk_size) - 1;
 
-	s->pending_pool = mempool_create_slab_pool(DM_PENDING_MEMPOOL_SIZE, pending_exception_cache);
+	s->pending_pool = mempool_create_slab_pool(DM_PENDING_MEMPOOL_SIZE,
+						   pending_exception_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
 		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 
-	s->tracked_chunk_pool = mempool_create_slab_pool(DM_TRACKED_CHUNK_POOL_SIZE, tracked_chunk_cache);
+	s->tracked_chunk_pool = mempool_create_slab_pool(DM_TRACKED_CHUNK_POOL_SIZE,
+							 tracked_chunk_cache);
 	if (!s->tracked_chunk_pool) {
 		ti->error = "Could not allocate tracked_chunk mempool for tracking reads";
 		goto bad_tracked_chunk_pool;
@@ -1306,7 +1314,7 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 				if (!dm_multisnap_has_error(s)) {
 					r = s->store->delete_snapshot(s->p, sn);
 					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
-						ti->error = "Can't delete snapshot";
+						ti->error = "Could not delete snapshot";
 						vfree(snapids);
 						goto error_syncing_snapshots;
 					}
@@ -1322,16 +1330,16 @@ static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv
 			}
 		}
 delete_done:
-
 		/* Create the snapshots that should be there */
 		if (s->store->compare_snapids_for_create)
-			sort(snapids, num_snapshots, sizeof(snapid_t), s->store->compare_snapids_for_create, NULL);
+			sort(snapids, num_snapshots, sizeof(snapid_t),
+			     s->store->compare_snapids_for_create, NULL);
 		for (n = 0; n <= num_snapshots; n++) {
 			if (!dm_multisnap_snapshot_exists(s, snapids[n])) {
 				if (!dm_multisnap_has_error(s)) {
 					r = s->store->create_snapshot(s->p, snapids[n]);
 					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
-						ti->error = "Can't create snapshot";
+						ti->error = "Could not create snapshot";
 						vfree(snapids);
 						goto error_syncing_snapshots;
 					}
@@ -1385,7 +1393,7 @@ static void multisnap_origin_dtr(struct dm_target *ti)
 
 	mutex_lock(&all_multisnapshots_lock);
 
-	/* Make sure that any more IOs won't be submitted by snapshot targets */
+	/* Make sure that no more IOs will be submitted by snapshot targets */
 	list_for_each_entry(sn, &s->all_snaps, list_snaps) {
 		spin_lock_irq(&dm_multisnap_bio_list_lock);
 		sn->s = NULL;
@@ -1411,7 +1419,7 @@ poll_for_ios:
 	}
 	spin_unlock_irq(&dm_multisnap_bio_list_lock);
 
-	/* Bug-check that there are really no IOs */
+	/* Make sure that there really are no outstanding IOs */
 	for (i = 0; i < DM_MULTISNAP_N_QUEUES; i++)
 		BUG_ON(!bio_list_empty(&s->queue[i].bios));
 	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
@@ -1450,7 +1458,8 @@ poll_for_ios:
 	mutex_unlock(&all_multisnapshots_lock);
 }
 
-static int multisnap_origin_map(struct dm_target *ti, struct bio *bio, union map_info *map_context)
+static int multisnap_origin_map(struct dm_target *ti, struct bio *bio,
+				union map_info *map_context)
 {
 	struct dm_multisnap *s = ti->private;
 
@@ -1471,7 +1480,8 @@ static int multisnap_origin_map(struct dm_target *ti, struct bio *bio, union map
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int multisnap_origin_message(struct dm_target *ti, unsigned argc, char **argv)
+static int multisnap_origin_message(struct dm_target *ti,
+				    unsigned argc, char **argv)
 {
 	struct dm_multisnap *s = ti->private;
 	char *error;
@@ -1514,7 +1524,8 @@ create_snapshot:
 		s->new_snapid_valid = 0;
 		dm_multisnap_status_unlock(s);
 
-		r = s->store->allocate_snapid(s->p, &s->new_snapid, subsnap, subsnap_id);
+		r = s->store->allocate_snapid(s->p, &s->new_snapid,
+					      subsnap, subsnap_id);
 		if (r)
 			goto unlock_ret;
 
@@ -1602,7 +1613,6 @@ unlock2_ret:
 }
 
 /* Print used snapshot IDs into a supplied string */
-
 static void print_snapshot_ids(struct dm_multisnap *s, char *result, unsigned maxlen)
 {
 	snapid_t nsnap = 0;
@@ -1621,14 +1631,15 @@ static void print_snapshot_ids(struct dm_multisnap *s, char *result, unsigned ma
 	}
 }
 
-static int multisnap_origin_status(struct dm_target *ti, status_type_t type, char *result, unsigned maxlen)
+static int multisnap_origin_status(struct dm_target *ti, status_type_t type,
+				   char *result, unsigned maxlen)
 {
 	struct dm_multisnap *s = ti->private;
 
 	/*
 	 * Use a special status lock, so that this code can execute even
 	 * when the underlying device is suspended and there is no possibility
-	 * to optain the master lock.
+	 * to obtain the master lock.
 	 */
 	dm_multisnap_status_lock(s);
 
@@ -1695,13 +1706,11 @@ static int multisnap_origin_status(struct dm_target *ti, status_type_t type, cha
  * In postsuspend, we optionally create a snapshot that we prepared with
  * a message.
  */
-
 static void multisnap_origin_postsuspend(struct dm_target *ti)
 {
 	struct dm_multisnap *s = ti->private;
 
 	dm_multisnap_lock(s);
-
 	if (s->new_snapid_valid && !dm_multisnap_has_error(s)) {
 		/*
 		 * No way to return the error code, but it is recorded
@@ -1710,7 +1719,6 @@ static void multisnap_origin_postsuspend(struct dm_target *ti)
 		s->store->create_snapshot(s->p, s->new_snapid);
 		s->new_snapid_valid = 0;
 	}
-
 	dm_multisnap_unlock(s);
 
 	dm_multisnap_force_commit(s);
@@ -1820,12 +1828,12 @@ static void multisnap_snap_dtr(struct dm_target *ti)
 
 /*
  * Each snapshot I/O is counted in n_tracked_ios in the origin and
- * has struct dm_multisnap_tracked_chunk allocated.
- * dm_multisnap_tracked_chunk->node can be optionally linked into origin's hash
- * of tracked I/Os.
+ * has 'struct dm_multisnap_tracked_chunk' allocated.
+ * dm_multisnap_tracked_chunk->node can be optionally linked into
+ * origin's hash of tracked I/Os.
  */
-
-static int multisnap_snap_map(struct dm_target *ti, struct bio *bio, union map_info *map_context)
+static int multisnap_snap_map(struct dm_target *ti, struct bio *bio,
+			      union map_info *map_context)
 {
 	struct dm_multisnap_snap *sn = ti->private;
 	struct dm_multisnap *s;
@@ -1839,10 +1847,10 @@ static int multisnap_snap_map(struct dm_target *ti, struct bio *bio, union map_i
 		spin_unlock_irq(&dm_multisnap_bio_list_lock);
 		return -EIO;
 	}
-		/*
-		 * make sure that the origin is not unloaded under us while
-		 * we drop the lock
-		 */
+	/*
+	 * make sure that the origin is not unloaded under us while
+	 * we drop the lock
+	 */
 	s->n_tracked_ios++;
 
 	c = mempool_alloc(s->tracked_chunk_pool, GFP_ATOMIC);
@@ -1871,7 +1879,8 @@ static int multisnap_snap_map(struct dm_target *ti, struct bio *bio, union map_i
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int multisnap_snap_end_io(struct dm_target *ti, struct bio *bio, int error, union map_info *map_context)
+static int multisnap_snap_end_io(struct dm_target *ti, struct bio *bio,
+				 int error, union map_info *map_context)
 {
 	struct dm_multisnap_tracked_chunk *c = map_context->ptr;
 	struct dm_multisnap *s = c->s;
@@ -1889,7 +1898,8 @@ static int multisnap_snap_end_io(struct dm_target *ti, struct bio *bio, int erro
 	return 0;
 }
 
-static int multisnap_snap_status(struct dm_target *ti, status_type_t type, char *result, unsigned maxlen)
+static int multisnap_snap_status(struct dm_target *ti, status_type_t type,
+				 char *result, unsigned maxlen)
 {
 	struct dm_multisnap_snap *sn = ti->private;
 
@@ -1901,7 +1911,8 @@ static int multisnap_snap_status(struct dm_target *ti, status_type_t type, char
 		dm_multisnap_adjust_string(&result, &maxlen);
 		break;
 	case STATUSTYPE_TABLE:
-		snprintf(result, maxlen, "%s %s", sn->origin_name, sn->snapid_string);
+		snprintf(result, maxlen, "%s %s",
+			 sn->origin_name, sn->snapid_string);
 		dm_multisnap_adjust_string(&result, &maxlen);
 		break;
 	}
diff --git a/drivers/md/dm-multisnap.h b/drivers/md/dm-multisnap.h
index ff7f844..0af87dd 100644
--- a/drivers/md/dm-multisnap.h
+++ b/drivers/md/dm-multisnap.h
@@ -49,24 +49,30 @@ struct dm_multisnap_exception_store {
 	const char *name;
 
 	/* < 0 - error */
-	int (*init_exception_store)(struct dm_multisnap *dm, struct dm_exception_store **s, unsigned argc, char **argv, char **error);
+	int (*init_exception_store)(struct dm_multisnap *dm, struct dm_exception_store **s,
+				    unsigned argc, char **argv, char **error);
 
 	void (*exit_exception_store)(struct dm_exception_store *s);
 
 	void (*store_lock_acquired)(struct dm_exception_store *s, int flags);
 
 	/* These two can override format of snapids in the table. Can be NULL */
-	void (*print_snapid)(struct dm_exception_store *s, char *string, unsigned maxlen, snapid_t snapid);
-	int (*read_snapid)(struct dm_exception_store *s, char *string, snapid_t *snapid, char **error);
+	void (*print_snapid)(struct dm_exception_store *s, char *string,
+			     unsigned maxlen, snapid_t snapid);
+	int (*read_snapid)(struct dm_exception_store *s, char *string,
+			   snapid_t *snapid, char **error);
 
 	/* return the exception-store specific table arguments */
 	void (*status_table)(struct dm_exception_store *s, char *result, unsigned maxlen);
 
 	/* return the space */
-	void (*get_space)(struct dm_exception_store *s, unsigned long long *chunks_total, unsigned long long *chunks_allocated, unsigned long long *chunks_metadata_allocated);
+	void (*get_space)(struct dm_exception_store *s, unsigned long long *chunks_total,
+			  unsigned long long *chunks_allocated,
+			  unsigned long long *chunks_metadata_allocated);
 
 	/* < 0 - error */
-	int (*allocate_snapid)(struct dm_exception_store *s, snapid_t *snapid, int snap_of_snap, snapid_t master);
+	int (*allocate_snapid)(struct dm_exception_store *s, snapid_t *snapid,
+			       int snap_of_snap, snapid_t master);
 
 	/* < 0 - error */
 	int (*create_snapshot)(struct dm_exception_store *s, snapid_t snapid);
@@ -87,7 +93,8 @@ struct dm_multisnap_exception_store {
 	int (*compare_snapids_for_create)(const void *p1, const void *p2);
 
 	/* 0 - not found, 1 - found (read-only), 2 - found (writeable), < 0 - error */
-	int (*find_snapshot_chunk)(struct dm_exception_store *s, snapid_t id, chunk_t chunk, int write, chunk_t *result);
+	int (*find_snapshot_chunk)(struct dm_exception_store *s, snapid_t snapid,
+				   chunk_t chunk, int write, chunk_t *result);
 
 	/*
 	 * Chunk interface between exception store and generic code.
@@ -108,11 +115,14 @@ struct dm_multisnap_exception_store {
 
 	void (*reset_query)(struct dm_exception_store *s);
 	int (*query_next_remap)(struct dm_exception_store *s, chunk_t chunk);
-	void (*add_next_remap)(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk);
+	void (*add_next_remap)(struct dm_exception_store *s,
+			       union chunk_descriptor *cd, chunk_t *new_chunk);
 
 	/* may be NULL if writeable snapshots are not supported */
-	void (*make_chunk_writeable)(struct dm_exception_store *s, union chunk_descriptor *cd, chunk_t *new_chunk);
-	int (*check_conflict)(struct dm_exception_store *s, union chunk_descriptor *cd, snapid_t snapid);
+	void (*make_chunk_writeable)(struct dm_exception_store *s,
+				     union chunk_descriptor *cd, chunk_t *new_chunk);
+	int (*check_conflict)(struct dm_exception_store *s,
+			      union chunk_descriptor *cd, snapid_t snapid);
 
 	/* This is called without the lock, prior to commit */
 	void (*prepare_for_commit)(struct dm_exception_store *s);
@@ -142,19 +152,28 @@ void dm_multisnap_status_lock(struct dm_multisnap *s);
 void dm_multisnap_status_unlock(struct dm_multisnap *s);
 void dm_multisnap_status_assert_locked(struct dm_multisnap *s);
 
-/* Commit. dm_multisnap_call_commit can be called only if dm_multisnap_can_commit returns true */
+/*
+ * Commit. dm_multisnap_call_commit can only be called
+ * if dm_multisnap_can_commit returns true
+ */
 int dm_multisnap_can_commit(struct dm_multisnap *s);
 void dm_multisnap_call_commit(struct dm_multisnap *s);
 
 /* Delayed work for delete/merge */
-void dm_multisnap_queue_work(struct dm_multisnap *s, struct dm_multisnap_background_work *bw);
-void dm_multisnap_cancel_work(struct dm_multisnap *s, struct dm_multisnap_background_work *bw);
+void dm_multisnap_queue_work(struct dm_multisnap *s,
+			     struct dm_multisnap_background_work *bw);
+void dm_multisnap_cancel_work(struct dm_multisnap *s,
+			      struct dm_multisnap_background_work *bw);
 
 /* Parsing command line */
-int dm_multisnap_get_string(char ***argv, unsigned *argc, char **string, char **error);
-int dm_multisnap_get_uint64(char ***argv, unsigned *argc, __u64 *unsigned_int64, char **error);
-int dm_multisnap_get_uint(char ***argv, unsigned *argc, unsigned *unsigned_int, char **error);
-int dm_multisnap_get_argcount(char ***argv, unsigned *argc, unsigned *unsigned_int, char **error);
+int dm_multisnap_get_string(char ***argv, unsigned *argc,
+			    char **string, char **error);
+int dm_multisnap_get_uint64(char ***argv, unsigned *argc,
+			    __u64 *unsigned_int64, char **error);
+int dm_multisnap_get_uint(char ***argv, unsigned *argc,
+			  unsigned *unsigned_int, char **error);
+int dm_multisnap_get_argcount(char ***argv, unsigned *argc,
+			      unsigned *unsigned_int, char **error);
 void dm_multisnap_adjust_string(char **result, unsigned *maxlen);
 
 /* Register/unregister the exception store driver */
