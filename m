From: Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 2/4] Add sector start offset to dm-bufio
	interface.
Date: Wed,  4 Jan 2017 20:23:52 +0100
Message-ID: <68e010626dd70e86afbc641ac4f1379d71c12952.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

This patch adds possibility to set sector offset for dm-bufio client.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-bufio.c | 51 ++++++++++++++++++++++++++++++++-------------------
 drivers/md/dm-bufio.h |  7 +++++++
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 84d2f0e4c754..0105f9196ab3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -109,6 +109,8 @@ struct dm_bufio_client {
 	struct rb_root buffer_tree;
 	wait_queue_head_t free_buffer_wait;
 
+	sector_t start;
+
 	int async_write_error;
 
 	struct list_head client_list;
@@ -556,8 +558,8 @@ static void dmio_complete(unsigned long error, void *context)
 	b->bio.bi_end_io(&b->bio);
 }
 
-static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
-		     bio_end_io_t *end_io)
+static void use_dmio(struct dm_buffer *b, int rw, sector_t sector,
+		     unsigned n_sectors, bio_end_io_t *end_io)
 {
 	int r;
 	struct dm_io_request io_req = {
@@ -569,8 +571,8 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 	};
 	struct dm_io_region region = {
 		.bdev = b->c->bdev,
-		.sector = block << b->c->sectors_per_block_bits,
-		.count = b->c->block_size >> SECTOR_SHIFT,
+		.sector = sector,
+		.count = n_sectors,
 	};
 
 	if (b->data_mode != DATA_MODE_VMALLOC) {
@@ -605,14 +607,14 @@ static void inline_endio(struct bio *bio)
 	end_fn(bio);
 }
 
-static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
-			   bio_end_io_t *end_io)
+static void use_inline_bio(struct dm_buffer *b, int rw, sector_t sector,
+			   unsigned n_sectors, bio_end_io_t *end_io)
 {
 	char *ptr;
 	int len;
 
 	bio_init(&b->bio, b->bio_vec, DM_BUFIO_INLINE_VECS);
-	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
+	b->bio.bi_iter.bi_sector = sector;
 	b->bio.bi_bdev = b->c->bdev;
 	b->bio.bi_end_io = inline_endio;
 	/*
@@ -627,7 +629,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	 * If len < PAGE_SIZE the buffer doesn't cross page boundary.
 	 */
 	ptr = b->data;
-	len = b->c->block_size;
+	len = n_sectors << SECTOR_SHIFT;
 
 	if (len >= PAGE_SIZE)
 		BUG_ON((unsigned long)ptr & (PAGE_SIZE - 1));
@@ -639,7 +641,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 				  len < PAGE_SIZE ? len : PAGE_SIZE,
 				  offset_in_page(ptr))) {
 			BUG_ON(b->c->block_size <= PAGE_SIZE);
-			use_dmio(b, rw, block, end_io);
+			use_dmio(b, rw, sector, n_sectors, end_io);
 			return;
 		}
 
@@ -650,17 +652,22 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	submit_bio(&b->bio);
 }
 
-static void submit_io(struct dm_buffer *b, int rw, sector_t block,
-		      bio_end_io_t *end_io)
+static void submit_io(struct dm_buffer *b, int rw, bio_end_io_t *end_io)
 {
+	unsigned n_sectors;
+	sector_t sector;
+
 	if (rw == WRITE && b->c->write_callback)
 		b->c->write_callback(b);
 
-	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
+	sector = (b->block << b->c->sectors_per_block_bits) + b->c->start;
+	n_sectors = 1 << b->c->sectors_per_block_bits;
+
+	if (n_sectors <= ((DM_BUFIO_INLINE_VECS * PAGE_SIZE) >> SECTOR_SHIFT) &&
 	    b->data_mode != DATA_MODE_VMALLOC)
-		use_inline_bio(b, rw, block, end_io);
+		use_inline_bio(b, rw, sector, n_sectors, end_io);
 	else
-		use_dmio(b, rw, block, end_io);
+		use_dmio(b, rw, sector, n_sectors, end_io);
 }
 
 /*----------------------------------------------------------------
@@ -712,7 +719,7 @@ static void __write_dirty_buffer(struct dm_buffer *b,
 	wait_on_bit_lock_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 
 	if (!write_list)
-		submit_io(b, WRITE, b->block, write_endio);
+		submit_io(b, WRITE, write_endio);
 	else
 		list_add_tail(&b->write_list, write_list);
 }
@@ -725,7 +732,7 @@ static void __flush_write_list(struct list_head *write_list)
 		struct dm_buffer *b =
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
-		submit_io(b, WRITE, b->block, write_endio);
+		submit_io(b, WRITE, write_endio);
 		cond_resched();
 	}
 	blk_finish_plug(&plug);
@@ -1093,7 +1100,7 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 		return NULL;
 
 	if (need_submit)
-		submit_io(b, READ, b->block, read_endio);
+		submit_io(b, READ, read_endio);
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 
@@ -1163,7 +1170,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 			dm_bufio_unlock(c);
 
 			if (need_submit)
-				submit_io(b, READ, b->block, read_endio);
+				submit_io(b, READ, read_endio);
 			dm_bufio_release(b);
 
 			cond_resched();
@@ -1404,7 +1411,7 @@ void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block)
 		old_block = b->block;
 		__unlink_buffer(b);
 		__link_buffer(b, new_block, b->list_mode);
-		submit_io(b, WRITE, new_block, write_endio);
+		submit_io(b, WRITE, write_endio);
 		wait_on_bit_io(&b->state, B_WRITING,
 			       TASK_UNINTERRUPTIBLE);
 		__unlink_buffer(b);
@@ -1761,6 +1768,12 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
 
+void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start)
+{
+	c->start = start;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);
+
 static unsigned get_max_age_hz(void)
 {
 	unsigned max_age = ACCESS_ONCE(dm_bufio_max_age);
diff --git a/drivers/md/dm-bufio.h b/drivers/md/dm-bufio.h
index c096779a7292..b6d8f53ec15b 100644
--- a/drivers/md/dm-bufio.h
+++ b/drivers/md/dm-bufio.h
@@ -32,6 +32,13 @@ dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
 void dm_bufio_client_destroy(struct dm_bufio_client *c);
 
 /*
+ * Set the sector range.
+ * When this function is called, there must be no I/O in progress on the bufio
+ * client.
+ */
+void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start);
+
+/*
  * WARNING: to avoid deadlocks, these conditions are observed:
  *
  * - At most one thread can hold at most "reserved_buffers" simultaneously.
-- 
2.11.0
