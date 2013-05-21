From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Reg. Persistent Metadata API
Date: Mon, 20 May 2013 20:09:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1305201955210.22151@file.rdu.redhat.com>
References: <CANPE0nUeTkLYTU3vDCdvKhF_zm0Kb0K9YKPrcM+7qHJ7Yhuwfw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANPE0nUeTkLYTU3vDCdvKhF_zm0Kb0K9YKPrcM+7qHJ7Yhuwfw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Vasily Tarasov <tarasov@vasily.name>, Erez Zadok <ezk@cs.stonybrook.edu>
List-Id: dm-devel.ids



On Fri, 17 May 2013, Karthi wrote:

> Hi everyone,
> 
> Our group works on a device mapper target called dmDedup that performs
> inline data deduplication. The dmDedup target internally uses the
> Persistent Metadata API (located in linux/drivers/md/persistent-data)to
> manage its meta-data.
> 
> In our system, there is a main writer thread (or several of them) and a
> separate flusher thread. When a write request comes in, the writer thread
> checks for the duplicates in the data and updates corresponding meta-data.
> The flusher thread periodically (10 sec) flushes the meta-data to disk by
> calling the commit function in the transaction manager of Persistant
> Metadata API.
> 
> When we benchmark dmDedup target with a sequential unique data write
> workload, we observed that write performance periodically drops to 0
> ops/sec for 8 to 15 seconds. It happens because the flusher thread blocks
> the writer thread. Our further analysis showed that, the writer thread is
> blocked on the dm_bufio mutex lock, which is acquired by the flusher thread
> on the dm_bufio_client  when the dirty buffers are being flushed as a part
> of transaction. Though these dirty buffers are flushed asynchronously, the
> function enters a loop with the lock acquired and exits only when it places
> the request for all the dirty buffers. (drivers/md/dm-bufio.c -
> dm_bufio_write_dirty_buffers()). The writer thread is blocked as it needs
> this lock to lookup the metadata. The underlying I/O queue size is 128. The
> flusher thread waits to place IO request for all dirty buffers (which is
> much greater than 128) onto the queue. This way the writes becomes
> synchronous during this entire period, thus blocking the other writer
> thread.
> 
> We want a metadata flush which is not affected by the writer thread so
> drastically. Specifically, we would like the flush to write out dirty
> buffers, while the writer still can update metadata (using COW to preserve
> consistency). Is it something that is possible with a current design of
> persistent metadata subsystem? Our current understanding is that during the
> commit all updates to the meta-data are blocked until all of the meta-data
> is written out.
> 
> We appreciate any suggestions!
> 
> Thank you!
> 

Hi

Try this patch, it moves the code to submit buffers outside of the lock.

Tell us if it improves performance for you.

Mikulas

---

dm-bufio: drop lock when submitting writes

This patch changes dm-bufio so that it submits write I/Os outside of the
lock. If the number of submitted buffers is greater than the number of
requests on the target queue, submit_bio blocks. We want to block outside
of the lock to improve latency of other threads that may need the lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   73 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 15 deletions(-)

Index: linux-3.9.3-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.9.3-fast.orig/drivers/md/dm-bufio.c	2013-05-21 01:24:15.000000000 +0200
+++ linux-3.9.3-fast/drivers/md/dm-bufio.c	2013-05-21 02:03:26.000000000 +0200
@@ -145,6 +145,7 @@ struct dm_buffer {
 	unsigned long state;
 	unsigned long last_accessed;
 	struct dm_bufio_client *c;
+	struct list_head write_list;
 	struct bio bio;
 	struct bio_vec bio_vec[DM_BUFIO_INLINE_VECS];
 };
@@ -630,7 +631,8 @@ static int do_io_schedule(void *word)
  * - Submit our write and don't wait on it. We set B_WRITING indicating
  *   that there is a write in progress.
  */
-static void __write_dirty_buffer(struct dm_buffer *b)
+static void __write_dirty_buffer(struct dm_buffer *b,
+				 struct list_head *write_list)
 {
 	if (!test_bit(B_DIRTY, &b->state))
 		return;
@@ -639,7 +641,24 @@ static void __write_dirty_buffer(struct 
 	wait_on_bit_lock(&b->state, B_WRITING,
 			 do_io_schedule, TASK_UNINTERRUPTIBLE);
 
-	submit_io(b, WRITE, b->block, write_endio);
+	if (!write_list)
+		submit_io(b, WRITE, b->block, write_endio);
+	else
+		list_add_tail(&b->write_list, write_list);
+}
+
+static void __flush_write_list(struct list_head *write_list)
+{
+	struct blk_plug plug;
+	blk_start_plug(&plug);
+	while (!list_empty(write_list)) {
+		struct dm_buffer *b =
+			list_entry(write_list->next, struct dm_buffer, write_list);
+		list_del(&b->write_list);
+		submit_io(b, WRITE, b->block, write_endio);
+		dm_bufio_cond_resched();
+	}
+	blk_finish_plug(&plug);
 }
 
 /*
@@ -655,7 +674,7 @@ static void __make_buffer_clean(struct d
 		return;
 
 	wait_on_bit(&b->state, B_READING, do_io_schedule, TASK_UNINTERRUPTIBLE);
-	__write_dirty_buffer(b);
+	__write_dirty_buffer(b, NULL);
 	wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
 }
 
@@ -802,7 +821,8 @@ static void __free_buffer_wake(struct dm
 	wake_up(&c->free_buffer_wait);
 }
 
-static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait)
+static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait,
+					struct list_head *write_list)
 {
 	struct dm_buffer *b, *tmp;
 
@@ -818,7 +838,7 @@ static void __write_dirty_buffers_async(
 		if (no_wait && test_bit(B_WRITING, &b->state))
 			return;
 
-		__write_dirty_buffer(b);
+		__write_dirty_buffer(b, write_list);
 		dm_bufio_cond_resched();
 	}
 }
@@ -853,7 +873,8 @@ static void __get_memory_limit(struct dm
  * If we are over threshold_buffers, start freeing buffers.
  * If we're over "limit_buffers", block until we get under the limit.
  */
-static void __check_watermark(struct dm_bufio_client *c)
+static void __check_watermark(struct dm_bufio_client *c,
+			      struct list_head *write_list)
 {
 	unsigned long threshold_buffers, limit_buffers;
 
@@ -872,7 +893,7 @@ static void __check_watermark(struct dm_
 	}
 
 	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
-		__write_dirty_buffers_async(c, 1);
+		__write_dirty_buffers_async(c, 1, write_list);
 }
 
 /*
@@ -897,7 +918,8 @@ static struct dm_buffer *__find(struct d
  *--------------------------------------------------------------*/
 
 static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
-				     enum new_flag nf, int *need_submit)
+				     enum new_flag nf, int *need_submit,
+				     struct list_head *write_list)
 {
 	struct dm_buffer *b, *new_b = NULL;
 
@@ -924,7 +946,7 @@ static struct dm_buffer *__bufio_new(str
 		goto found_buffer;
 	}
 
-	__check_watermark(c);
+	__check_watermark(c, write_list);
 
 	b = new_b;
 	b->hold_count = 1;
@@ -992,10 +1014,14 @@ static void *new_read(struct dm_bufio_cl
 	int need_submit;
 	struct dm_buffer *b;
 
+	LIST_HEAD(write_list);
+
 	dm_bufio_lock(c);
-	b = __bufio_new(c, block, nf, &need_submit);
+	b = __bufio_new(c, block, nf, &need_submit, &write_list);
 	dm_bufio_unlock(c);
 
+	__flush_write_list(&write_list);
+
 	if (!b)
 		return b;
 
@@ -1047,6 +1073,8 @@ void dm_bufio_prefetch(struct dm_bufio_c
 {
 	struct blk_plug plug;
 
+	LIST_HEAD(write_list);
+
 	BUG_ON(dm_bufio_in_request());
 
 	blk_start_plug(&plug);
@@ -1055,7 +1083,15 @@ void dm_bufio_prefetch(struct dm_bufio_c
 	for (; n_blocks--; block++) {
 		int need_submit;
 		struct dm_buffer *b;
-		b = __bufio_new(c, block, NF_PREFETCH, &need_submit);
+		b = __bufio_new(c, block, NF_PREFETCH, &need_submit,
+				&write_list);
+		if (unlikely(!list_empty(&write_list))) {
+			dm_bufio_unlock(c);
+			blk_finish_plug(&plug);
+			__flush_write_list(&write_list);
+			blk_start_plug(&plug);
+			dm_bufio_lock(c);
+		}
 		if (unlikely(b != NULL)) {
 			dm_bufio_unlock(c);
 
@@ -1069,7 +1105,6 @@ void dm_bufio_prefetch(struct dm_bufio_c
 				goto flush_plug;
 			dm_bufio_lock(c);
 		}
-
 	}
 
 	dm_bufio_unlock(c);
@@ -1126,11 +1161,14 @@ EXPORT_SYMBOL_GPL(dm_bufio_mark_buffer_d
 
 void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c)
 {
+	LIST_HEAD(write_list);
+
 	BUG_ON(dm_bufio_in_request());
 
 	dm_bufio_lock(c);
-	__write_dirty_buffers_async(c, 0);
+	__write_dirty_buffers_async(c, 0, &write_list);
 	dm_bufio_unlock(c);
+	__flush_write_list(&write_list);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers_async);
 
@@ -1147,8 +1185,13 @@ int dm_bufio_write_dirty_buffers(struct 
 	unsigned long buffers_processed = 0;
 	struct dm_buffer *b, *tmp;
 
+	LIST_HEAD(write_list);
+
+	dm_bufio_lock(c);
+	__write_dirty_buffers_async(c, 0, &write_list);
+	dm_bufio_unlock(c);
+	__flush_write_list(&write_list);
 	dm_bufio_lock(c);
-	__write_dirty_buffers_async(c, 0);
 
 again:
 	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_DIRTY], lru_list) {
@@ -1274,7 +1317,7 @@ retry:
 	BUG_ON(!b->hold_count);
 	BUG_ON(test_bit(B_READING, &b->state));
 
-	__write_dirty_buffer(b);
+	__write_dirty_buffer(b, NULL);
 	if (b->hold_count == 1) {
 		wait_on_bit(&b->state, B_WRITING,
 			    do_io_schedule, TASK_UNINTERRUPTIBLE);
