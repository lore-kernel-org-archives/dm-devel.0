From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 02/17] dm bufio: evict buffers that
	are past the max age but retain some buffers
Date: Fri, 17 Oct 2014 14:37:04 -0400
Message-ID: <1413571039-31986-2-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

These changes help keep metadata backed by dm-bufio in-core longer which
fixes reports of metadata churn in the face of heavy random IO workloads.

Before, bufio evicted all buffers older than DM_BUFIO_DEFAULT_AGE_SECS.
Having a device (e.g. dm-thinp or dm-cache) lose all metadata just
because associated buffers had been idle for some time is unfriendly.

Now, the user may now configure the number of bytes that bufio retains
using the 'retain_bytes' module parameter.  The default is 256K.

Also, the DM_BUFIO_WORK_TIMER_SECS and DM_BUFIO_DEFAULT_AGE_SECS
defaults were quite low so increase them (to 30 and 300 respectively).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bufio.c | 109 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index dcaa1d9..99579c8 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -35,12 +35,17 @@
 /*
  * Check buffer ages in this interval (seconds)
  */
-#define DM_BUFIO_WORK_TIMER_SECS	10
+#define DM_BUFIO_WORK_TIMER_SECS	30
 
 /*
  * Free buffers when they are older than this (seconds)
  */
-#define DM_BUFIO_DEFAULT_AGE_SECS	60
+#define DM_BUFIO_DEFAULT_AGE_SECS	300
+
+/*
+ * The nr of bytes of cached data to keep around.
+ */
+#define DM_BUFIO_DEFAULT_RETAIN_BYTES   (256 * 1024)
 
 /*
  * The number of bvec entries that are embedded directly in the buffer.
@@ -216,6 +221,7 @@ static DEFINE_SPINLOCK(param_spinlock);
  * Buffers are freed after this timeout
  */
 static unsigned dm_bufio_max_age = DM_BUFIO_DEFAULT_AGE_SECS;
+static unsigned dm_bufio_retain_bytes = DM_BUFIO_DEFAULT_RETAIN_BYTES;
 
 static unsigned long dm_bufio_peak_allocated;
 static unsigned long dm_bufio_allocated_kmem_cache;
@@ -1457,45 +1463,52 @@ static void drop_buffers(struct dm_bufio_client *c)
 }
 
 /*
- * Test if the buffer is unused and too old, and commit it.
+ * We may not be able to evict this buffer if IO pending or the client
+ * is still using it.  Caller is expected to know buffer is too old.
+ *
  * And if GFP_NOFS is used, we must not do any I/O because we hold
  * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
  * rerouted to different bufio client.
  */
-static int __cleanup_old_buffer(struct dm_buffer *b, gfp_t gfp,
-				unsigned long max_jiffies)
+static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
 {
-	if (jiffies - b->last_accessed < max_jiffies)
-		return 0;
-
 	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
-			return 0;
+			return false;
 	}
 
 	if (b->hold_count)
-		return 0;
+		return false;
 
 	__make_buffer_clean(b);
 	__unlink_buffer(b);
 	__free_buffer_wake(b);
 
-	return 1;
+	return true;
 }
 
-static long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
-		   gfp_t gfp_mask)
+static unsigned get_retain_buffers(struct dm_bufio_client *c)
+{
+        unsigned retain_bytes = ACCESS_ONCE(dm_bufio_retain_bytes);
+        return retain_bytes / c->block_size;
+}
+
+static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
+			    gfp_t gfp_mask)
 {
 	int l;
 	struct dm_buffer *b, *tmp;
-	long freed = 0;
+	unsigned long freed = 0;
+	unsigned long count = nr_to_scan;
+	unsigned retain_target = get_retain_buffers(c);
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
-			freed += __cleanup_old_buffer(b, gfp_mask, 0);
-			if (!--nr_to_scan)
+			if (__try_evict_buffer(b, gfp_mask))
+				freed++;
+			if (!--nr_to_scan || ((count - freed) <= retain_target))
 				return freed;
 			dm_bufio_cond_resched();
 		}
@@ -1697,31 +1710,56 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
 
-static void cleanup_old_buffers(void)
+static unsigned get_max_age_hz(void)
 {
-	unsigned long max_age = ACCESS_ONCE(dm_bufio_max_age);
-	struct dm_bufio_client *c;
+	unsigned max_age = ACCESS_ONCE(dm_bufio_max_age);
 
-	if (max_age > ULONG_MAX / HZ)
-		max_age = ULONG_MAX / HZ;
+	if (max_age > UINT_MAX / HZ)
+		max_age = UINT_MAX / HZ;
 
-	mutex_lock(&dm_bufio_clients_lock);
-	list_for_each_entry(c, &dm_bufio_all_clients, client_list) {
-		if (!dm_bufio_trylock(c))
-			continue;
+	return max_age * HZ;
+}
 
-		while (!list_empty(&c->lru[LIST_CLEAN])) {
-			struct dm_buffer *b;
-			b = list_entry(c->lru[LIST_CLEAN].prev,
-				       struct dm_buffer, lru_list);
-			if (!__cleanup_old_buffer(b, 0, max_age * HZ))
-				break;
-			dm_bufio_cond_resched();
-		}
+static bool older_than(struct dm_buffer *b, unsigned long age_hz)
+{
+	return (jiffies - b->last_accessed) >= age_hz;
+}
+
+static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
+{
+	struct dm_buffer *b, *tmp;
+	unsigned retain_target = get_retain_buffers(c);
+	unsigned count;
+
+	dm_bufio_lock(c);
+
+	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
+	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_CLEAN], lru_list) {
+		if (count <= retain_target)
+			break;
+
+		if (!older_than(b, age_hz))
+			break;
+
+		if (__try_evict_buffer(b, 0))
+			count--;
 
-		dm_bufio_unlock(c);
 		dm_bufio_cond_resched();
 	}
+
+	dm_bufio_unlock(c);
+}
+
+static void cleanup_old_buffers(void)
+{
+	unsigned long max_age_hz = get_max_age_hz();
+	struct dm_bufio_client *c;
+
+	mutex_lock(&dm_bufio_clients_lock);
+
+	list_for_each_entry(c, &dm_bufio_all_clients, client_list)
+		__evict_old_buffers(c, max_age_hz);
+
 	mutex_unlock(&dm_bufio_clients_lock);
 }
 
@@ -1846,6 +1884,9 @@ MODULE_PARM_DESC(max_cache_size_bytes, "Size of metadata cache");
 module_param_named(max_age_seconds, dm_bufio_max_age, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_age_seconds, "Max age of a buffer in seconds");
 
+module_param_named(retain_bytes, dm_bufio_retain_bytes, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(retain_bytes, "Try to keep at least this many bytes cached in memory");
+
 module_param_named(peak_allocated_bytes, dm_bufio_peak_allocated, ulong, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(peak_allocated_bytes, "Tracks the maximum allocated memory");
 
-- 
1.8.3.1
