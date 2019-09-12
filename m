From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/5] dm-bufio: remove old-style buffer cleanup
Date: Thu, 12 Sep 2019 10:44:47 +0200
Message-ID: <20190912084549.114522000@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-remove-old-cleanup.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martijn Coenen <maco@android.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dariofreni@google.com, jiyong@google.com, dm-devel@redhat.com, maco@google.com, Mikulas Patocka <mpatocka@redhat.com>, kernel-team@android.com
List-Id: dm-devel.ids

Remove a code that cleans up buffers if the cache size grows over the limit.

The next patch will introduce a new global cleanup.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   61 ++------------------------------------------------
 1 file changed, 3 insertions(+), 58 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2019-09-10 17:34:24.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2019-09-10 17:34:29.000000000 +0200
@@ -33,7 +33,7 @@
 
 #define DM_BUFIO_MEMORY_PERCENT		2
 #define DM_BUFIO_VMALLOC_PERCENT	25
-#define DM_BUFIO_WRITEBACK_PERCENT	75
+#define DM_BUFIO_WRITEBACK_RATIO	3
 
 /*
  * Check buffer ages in this interval (seconds)
@@ -213,11 +213,6 @@ static unsigned long dm_bufio_current_al
 /*----------------------------------------------------------------*/
 
 /*
- * Per-client cache: dm_bufio_cache_size / dm_bufio_client_count
- */
-static unsigned long dm_bufio_cache_size_per_client;
-
-/*
  * The current number of clients.
  */
 static int dm_bufio_client_count;
@@ -228,8 +223,7 @@ static int dm_bufio_client_count;
 static LIST_HEAD(dm_bufio_all_clients);
 
 /*
- * This mutex protects dm_bufio_cache_size_latch,
- * dm_bufio_cache_size_per_client and dm_bufio_client_count
+ * This mutex protects dm_bufio_cache_size_latch and dm_bufio_client_count
  */
 static DEFINE_MUTEX(dm_bufio_clients_lock);
 
@@ -341,9 +335,6 @@ static void __cache_size_refresh(void)
 			      dm_bufio_default_cache_size);
 		dm_bufio_cache_size_latch = dm_bufio_default_cache_size;
 	}
-
-	dm_bufio_cache_size_per_client = dm_bufio_cache_size_latch /
-					 (dm_bufio_client_count ? : 1);
 }
 
 /*
@@ -927,36 +918,6 @@ static void __write_dirty_buffers_async(
 }
 
 /*
- * Get writeback threshold and buffer limit for a given client.
- */
-static void __get_memory_limit(struct dm_bufio_client *c,
-			       unsigned long *threshold_buffers,
-			       unsigned long *limit_buffers)
-{
-	unsigned long buffers;
-
-	if (unlikely(READ_ONCE(dm_bufio_cache_size) != dm_bufio_cache_size_latch)) {
-		if (mutex_trylock(&dm_bufio_clients_lock)) {
-			__cache_size_refresh();
-			mutex_unlock(&dm_bufio_clients_lock);
-		}
-	}
-
-	buffers = dm_bufio_cache_size_per_client;
-	if (likely(c->sectors_per_block_bits >= 0))
-		buffers >>= c->sectors_per_block_bits + SECTOR_SHIFT;
-	else
-		buffers /= c->block_size;
-
-	if (buffers < c->minimum_buffers)
-		buffers = c->minimum_buffers;
-
-	*limit_buffers = buffers;
-	*threshold_buffers = mult_frac(buffers,
-				       DM_BUFIO_WRITEBACK_PERCENT, 100);
-}
-
-/*
  * Check if we're over watermark.
  * If we are over threshold_buffers, start freeing buffers.
  * If we're over "limit_buffers", block until we get under the limit.
@@ -964,23 +925,7 @@ static void __get_memory_limit(struct dm
 static void __check_watermark(struct dm_bufio_client *c,
 			      struct list_head *write_list)
 {
-	unsigned long threshold_buffers, limit_buffers;
-
-	__get_memory_limit(c, &threshold_buffers, &limit_buffers);
-
-	while (c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY] >
-	       limit_buffers) {
-
-		struct dm_buffer *b = __get_unclaimed_buffer(c);
-
-		if (!b)
-			return;
-
-		__free_buffer_wake(b);
-		cond_resched();
-	}
-
-	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
+	if (c->n_buffers[LIST_DIRTY] > c->n_buffers[LIST_CLEAN] * DM_BUFIO_WRITEBACK_RATIO)
 		__write_dirty_buffers_async(c, 1, write_list);
 }
 
