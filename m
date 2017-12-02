From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: use REQ_OP_ macros
Date: Sat, 2 Dec 2017 00:33:39 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1712020033120.14282@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We should use REQ_OP_READ and REQ_OP_WRITE macros instead of READ and
WRITE. The have the same value, but the block layer uses REQ_OP, so we
should use it too.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -662,7 +662,7 @@ static void submit_io(struct dm_buffer *
 
 	sector = (b->block << b->c->sectors_per_block_bits) + b->c->start;
 
-	if (rw != WRITE) {
+	if (rw != REQ_OP_WRITE) {
 		n_sectors = 1 << b->c->sectors_per_block_bits;
 		offset = 0;
 	} else {
@@ -740,7 +740,7 @@ static void __write_dirty_buffer(struct
 	b->write_end = b->dirty_end;
 
 	if (!write_list)
-		submit_io(b, WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, write_endio);
 	else
 		list_add_tail(&b->write_list, write_list);
 }
@@ -753,7 +753,7 @@ static void __flush_write_list(struct li
 		struct dm_buffer *b =
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
-		submit_io(b, WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, write_endio);
 		cond_resched();
 	}
 	blk_finish_plug(&plug);
@@ -1123,7 +1123,7 @@ static void *new_read(struct dm_bufio_cl
 		return NULL;
 
 	if (need_submit)
-		submit_io(b, READ, read_endio);
+		submit_io(b, REQ_OP_READ, read_endio);
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 
@@ -1193,7 +1193,7 @@ void dm_bufio_prefetch(struct dm_bufio_c
 			dm_bufio_unlock(c);
 
 			if (need_submit)
-				submit_io(b, READ, read_endio);
+				submit_io(b, REQ_OP_READ, read_endio);
 			dm_bufio_release(b);
 
 			cond_resched();
@@ -1454,7 +1454,7 @@ retry:
 		old_block = b->block;
 		__unlink_buffer(b);
 		__link_buffer(b, new_block, b->list_mode);
-		submit_io(b, WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, write_endio);
 		wait_on_bit_io(&b->state, B_WRITING,
 			       TASK_UNINTERRUPTIBLE);
 		__unlink_buffer(b);
