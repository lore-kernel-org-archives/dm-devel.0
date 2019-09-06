From: Martijn Coenen <maco@android.com>
Subject: [PATCH] dm-bufio: Allow clients to specify an upper bound on cache size.
Date: Fri,  6 Sep 2019 09:45:26 +0200
Message-ID: <20190906074526.169194-1-maco@android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@android.com, narayan@google.com, dariofreni@google.com, ioffe@google.com, jiyong@google.com, maco@google.com, Martijn Coenen <maco@android.com>
List-Id: dm-devel.ids

The upper limit on the cache size of a client is currently determined by
dividing the total cache size by the number of clients. However, in some
cases it is beneficial to give one client a higher limit than others; an
example is a device with many dm-verity targets, where one target has a
very large hashtree, and all the others have a small hashtree. Giving
the target with the large hashtree a higher limit will be beneficial.
Another example is dm-verity-fec: FEC is only used in (rare) error
conditions, yet for every dm-verity target with FEC, we create two FEC
dm-bufio clients, which together have a higher cache limit than the
dm-verity target itself.

This patchset allows a client to indicate a maximum cache size for its
client; if that maximum is lower than the calculated per-client limit,
that maximum will be used instead, and the freed up cache size will be
allocated to other clients (that haven't set a maximum).

Note that this algorithm is not perfect; if we have 100MB with 3
clients, where the first set a max of 1MB, the second set a max of 40MB,
and the third set no maximumm, the ideal allocation would be 1:40:59,
respectively. However, because the initial per-client limit is 100 / 3
=~33MB, the requested max of 40MB is over the per-client limit, and
instead the allocation will end up being ~ 1:40:49. This is still better
than the original 33:33:33 allocation. An iterative algorithm could do
better, but it also complicates the code significantly.

Signed-off-by: Martijn Coenen <maco@android.com>
---
 drivers/md/dm-bufio.c    | 60 +++++++++++++++++++++++++++++++++++++---
 include/linux/dm-bufio.h |  7 +++++
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b6b5acc92ca2d..d116030107c54 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -25,9 +25,20 @@
  * Memory management policy:
  *	Limit the number of buffers to DM_BUFIO_MEMORY_PERCENT of main memory
  *	or DM_BUFIO_VMALLOC_PERCENT of vmalloc memory (whichever is lower).
- *	Always allocate at least DM_BUFIO_MIN_BUFFERS buffers.
- *	Start background writeback when there are DM_BUFIO_WRITEBACK_PERCENT
- *	dirty buffers.
+ *
+ *	By default, all clients have an equal memory limit, which is the total
+ *	cache size divided by the number of clients. On devices with few
+ *	clients, this can be quite a large amount, and clients that know an
+ *	upper bound on their desired cache size can call
+ *	dm_bufio_set_maximum_buffers() to indicate this, to allow more "needy"
+ *	clients to get higher limits. In that case, if the per-client memory
+ *	limit exceeds the requested maximum, we use the requested maximum
+ *	instead, and divide the freed up space evenly with other clients that
+ *	haven't requested a maximum.
+ *
+ *	Always allocate at least DM_BUFIO_MIN_BUFFERS buffers.  Start
+ *	background writeback when there are DM_BUFIO_WRITEBACK_PERCENT dirty
+ *	buffers.
  */
 #define DM_BUFIO_MIN_BUFFERS		8
 
@@ -98,6 +109,7 @@ struct dm_bufio_client {
 	unsigned need_reserved_buffers;
 
 	unsigned minimum_buffers;
+	unsigned maximum_buffers;
 
 	struct rb_root buffer_tree;
 	wait_queue_head_t free_buffer_wait;
@@ -310,6 +322,11 @@ static void adjust_total_allocated(unsigned char data_mode, long diff)
  */
 static void __cache_size_refresh(void)
 {
+	unsigned long max_cache_size_per_client;
+	unsigned long remaining_cache_size_to_divide;
+	struct dm_bufio_client *c;
+	unsigned int num_clients_to_divide = 0;
+
 	BUG_ON(!mutex_is_locked(&dm_bufio_clients_lock));
 	BUG_ON(dm_bufio_client_count < 0);
 
@@ -324,8 +341,22 @@ static void __cache_size_refresh(void)
 		dm_bufio_cache_size_latch = dm_bufio_default_cache_size;
 	}
 
-	dm_bufio_cache_size_per_client = dm_bufio_cache_size_latch /
+	remaining_cache_size_to_divide = dm_bufio_cache_size_latch;
+	max_cache_size_per_client = dm_bufio_cache_size_latch /
 					 (dm_bufio_client_count ? : 1);
+
+	list_for_each_entry(c, &dm_bufio_all_clients, client_list) {
+		unsigned long max = (unsigned long) c->maximum_buffers *
+			c->block_size;
+
+		if (max > 0 && max < max_cache_size_per_client)
+			remaining_cache_size_to_divide -= max;
+		else
+			num_clients_to_divide++;
+	}
+
+	dm_bufio_cache_size_per_client = remaining_cache_size_to_divide /
+					 (num_clients_to_divide ? : 1);
 }
 
 /*
@@ -928,6 +959,15 @@ static void __get_memory_limit(struct dm_bufio_client *c,
 	else
 		buffers /= c->block_size;
 
+	/*
+	 * Note that dm_bufio_cache_size_per_client already takes into account
+	 * clients requesting less than is available; but that means the
+	 * available cache size per client has increased, and if they were
+	 * below the per-client limit then, they will still be below the limit
+	 * now.
+	 */
+	if ((c->maximum_buffers > 0) && buffers > c->maximum_buffers)
+		buffers = c->maximum_buffers;
 	if (buffers < c->minimum_buffers)
 		buffers = c->minimum_buffers;
 
@@ -1450,6 +1490,17 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
 
+void dm_bufio_set_maximum_buffers(struct dm_bufio_client *c, unsigned n)
+{
+	mutex_lock(&dm_bufio_clients_lock);
+
+	c->maximum_buffers = n;
+	__cache_size_refresh();
+
+	mutex_unlock(&dm_bufio_clients_lock);
+}
+EXPORT_SYMBOL(dm_bufio_set_maximum_buffers);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
@@ -1664,6 +1715,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->need_reserved_buffers = reserved_buffers;
 
 	dm_bufio_set_minimum_buffers(c, DM_BUFIO_MIN_BUFFERS);
+	c->maximum_buffers = 0;
 
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 3c8b7d274bd9b..89f2f04c16ef2 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -136,6 +136,13 @@ void dm_bufio_forget(struct dm_bufio_client *c, sector_t block);
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
 
+/*
+ * Set the maximum number of buffers a client can hold. If called with a value
+ * of 0 (which is also the default), the maximum number of buffers is equal to
+ * the total cache size divided by the number of clients.
+ */
+void dm_bufio_set_maximum_buffers(struct dm_bufio_client *c, unsigned n);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
-- 
2.23.0.162.g0b9fbb3734-goog
