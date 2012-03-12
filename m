From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: prefetch
Date: Mon, 12 Mar 2012 17:48:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203121744510.3313@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Hi

This patch adds prefetch function to dm-bufio. I'm adding Joe to CC, 
because he may use it in his code too.

Mikulas

---

dm-bufio: prefetch

This patch introduces a new function dm_bufio_prefetch. It prefetches
the specified range of blocks into dm-bufio cache without waiting
for i/o completion.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   88 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm-bufio.h |    8 ++++
 2 files changed, 77 insertions(+), 19 deletions(-)

Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.3-rc6-fast.orig/drivers/md/dm-bufio.c	2012-03-12 22:20:47.000000000 +0100
+++ linux-3.3-rc6-fast/drivers/md/dm-bufio.c	2012-03-12 22:38:01.000000000 +0100
@@ -579,7 +579,7 @@ static void write_endio(struct bio *bio,
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
 	b->write_error = error;
-	if (error) {
+	if (unlikely(error)) {
 		struct dm_bufio_client *c = b->c;
 		(void)cmpxchg(&c->async_write_error, 0, error);
 	}
@@ -698,13 +698,20 @@ static void __wait_for_free_buffer(struc
 	dm_bufio_lock(c);
 }
 
+enum new_flag {
+	NF_FRESH = 0,
+	NF_READ = 1,
+	NF_GET = 2,
+	NF_PREFETCH = 3
+};
+
 /*
  * Allocate a new buffer. If the allocation is not possible, wait until
  * some other thread frees a buffer.
  *
  * May drop the lock and regain it.
  */
-static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client *c)
+static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client *c, enum new_flag nf)
 {
 	struct dm_buffer *b;
 
@@ -727,6 +734,9 @@ static struct dm_buffer *__alloc_buffer_
 				return b;
 		}
 
+		if (nf == NF_PREFETCH)
+			return NULL;
+
 		if (!list_empty(&c->reserved_buffers)) {
 			b = list_entry(c->reserved_buffers.next,
 				       struct dm_buffer, lru_list);
@@ -744,9 +754,12 @@ static struct dm_buffer *__alloc_buffer_
 	}
 }
 
-static struct dm_buffer *__alloc_buffer_wait(struct dm_bufio_client *c)
+static struct dm_buffer *__alloc_buffer_wait(struct dm_bufio_client *c, enum new_flag nf)
 {
-	struct dm_buffer *b = __alloc_buffer_wait_no_callback(c);
+	struct dm_buffer *b = __alloc_buffer_wait_no_callback(c, nf);
+
+	if (!b)
+		return NULL;
 
 	if (c->alloc_callback)
 		c->alloc_callback(b);
@@ -866,15 +879,8 @@ static struct dm_buffer *__find(struct d
  * Getting a buffer
  *--------------------------------------------------------------*/
 
-enum new_flag {
-	NF_FRESH = 0,
-	NF_READ = 1,
-	NF_GET = 2
-};
-
 static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
-				     enum new_flag nf, struct dm_buffer **bp,
-				     int *need_submit)
+				     enum new_flag nf, int *need_submit)
 {
 	struct dm_buffer *b, *new_b = NULL;
 
@@ -882,6 +888,19 @@ static struct dm_buffer *__bufio_new(str
 
 	b = __find(c, block);
 	if (b) {
+found_buffer:
+		if (nf == NF_PREFETCH)
+			return NULL;
+		/*
+		 * Note: it is essential that we don't wait for the buffer to be
+		 * read if dm_bufio_get function is used. Both dm_bufio_get and
+		 * dm_bufio_prefetch can be used in the driver request routine.
+		 * If the user called both dm_bufio_prefetch and dm_bufio_get on
+		 * the same buffer, it would deadlock if we waited.
+		 */
+		if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+			return NULL;
+
 		b->hold_count++;
 		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
 			     test_bit(B_WRITING, &b->state));
@@ -891,7 +910,9 @@ static struct dm_buffer *__bufio_new(str
 	if (nf == NF_GET)
 		return NULL;
 
-	new_b = __alloc_buffer_wait(c);
+	new_b = __alloc_buffer_wait(c, nf);
+	if (!new_b)
+		return NULL;
 
 	/*
 	 * We've had a period where the mutex was unlocked, so need to
@@ -900,10 +921,7 @@ static struct dm_buffer *__bufio_new(str
 	b = __find(c, block);
 	if (b) {
 		__free_buffer_wake(new_b);
-		b->hold_count++;
-		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
-			     test_bit(B_WRITING, &b->state));
-		return b;
+		goto found_buffer;
 	}
 
 	__check_watermark(c);
@@ -957,7 +975,7 @@ static void *new_read(struct dm_bufio_cl
 	struct dm_buffer *b;
 
 	dm_bufio_lock(c);
-	b = __bufio_new(c, block, nf, bp, &need_submit);
+	b = __bufio_new(c, block, nf, &need_submit);
 	dm_bufio_unlock(c);
 
 	if (!b || IS_ERR(b))
@@ -1006,13 +1024,42 @@ void *dm_bufio_new(struct dm_bufio_clien
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
+void dm_bufio_prefetch(struct dm_bufio_client *c,
+		       sector_t block, unsigned n_blocks)
+{
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
+	dm_bufio_lock(c);
+
+	for (; n_blocks--; block++) {
+		int need_submit;
+		struct dm_buffer *b;
+		b = __bufio_new(c, block, NF_PREFETCH, &need_submit);
+		if (unlikely(b != NULL)) {
+			dm_bufio_unlock(c);
+
+			if (need_submit)
+				submit_io(b, READ, b->block, read_endio);
+			dm_bufio_release(b);
+
+			dm_bufio_cond_resched();
+			dm_bufio_lock(c);
+		}
+
+	}
+
+	dm_bufio_unlock(c);
+	blk_finish_plug(&plug);
+}
+EXPORT_SYMBOL(dm_bufio_prefetch);
+
 void dm_bufio_release(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
 
 	dm_bufio_lock(c);
 
-	BUG_ON(test_bit(B_READING, &b->state));
 	BUG_ON(!b->hold_count);
 
 	b->hold_count--;
@@ -1025,6 +1072,7 @@ void dm_bufio_release(struct dm_buffer *
 		 * invalid buffer.
 		 */
 		if ((b->read_error || b->write_error) &&
+		    !test_bit(B_READING, &b->state) &&
 		    !test_bit(B_WRITING, &b->state) &&
 		    !test_bit(B_DIRTY, &b->state)) {
 			__unlink_buffer(b);
@@ -1042,6 +1090,8 @@ void dm_bufio_mark_buffer_dirty(struct d
 
 	dm_bufio_lock(c);
 
+	BUG_ON(test_bit(B_READING, &b->state));
+
 	if (!test_and_set_bit(B_DIRTY, &b->state))
 		__relink_lru(b, LIST_DIRTY);
 
Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.h
===================================================================
--- linux-3.3-rc6-fast.orig/drivers/md/dm-bufio.h	2012-03-12 22:20:47.000000000 +0100
+++ linux-3.3-rc6-fast/drivers/md/dm-bufio.h	2012-03-12 22:20:50.000000000 +0100
@@ -63,6 +63,14 @@ void *dm_bufio_new(struct dm_bufio_clien
 		   struct dm_buffer **bp);
 
 /*
+ * Prefetch the specified blocks to the cache.
+ * The function starts to read the blocks and returns without waiting for
+ * I/O to finish.
+ */
+void dm_bufio_prefetch(struct dm_bufio_client *c,
+		       sector_t block, unsigned n_blocks);
+
+/*
  * Release a reference obtained with dm_bufio_{read,get,new}. The data
  * pointer and dm_buffer pointer is no longer valid after this call.
  */
