From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: make the parameter "retain_bytes"
	unsigned long
Date: Tue, 2 May 2017 16:22:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1705021621210.5794@file01.intranet.prod.int.rdu2.redhat.com>
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

Change the type of the parameter "retain_bytes" from unsigned to unsigned
long, so that on 64-bit machines the user can set more than 4GiB of data
to be retained.

Also, change the type of the variable "count" in the function
"__evict_old_buffers" to unsigned long. The assignment
	"count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];"
could result in unsigned long to unsigned overflow and that could result
in buffers not being freed when they should.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -228,7 +228,7 @@ static DEFINE_SPINLOCK(param_spinlock);
  * Buffers are freed after this timeout
  */
 static unsigned dm_bufio_max_age = DM_BUFIO_DEFAULT_AGE_SECS;
-static unsigned dm_bufio_retain_bytes = DM_BUFIO_DEFAULT_RETAIN_BYTES;
+static unsigned long dm_bufio_retain_bytes = DM_BUFIO_DEFAULT_RETAIN_BYTES;
 
 static unsigned long dm_bufio_peak_allocated;
 static unsigned long dm_bufio_allocated_kmem_cache;
@@ -1597,9 +1597,9 @@ static bool __try_evict_buffer(struct dm
 	return true;
 }
 
-static unsigned get_retain_buffers(struct dm_bufio_client *c)
+static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-        unsigned retain_bytes = ACCESS_ONCE(dm_bufio_retain_bytes);
+        unsigned long retain_bytes = ACCESS_ONCE(dm_bufio_retain_bytes);
         return retain_bytes >> (c->sectors_per_block_bits + SECTOR_SHIFT);
 }
 
@@ -1610,7 +1610,7 @@ static unsigned long __scan(struct dm_bu
 	struct dm_buffer *b, *tmp;
 	unsigned long freed = 0;
 	unsigned long count = nr_to_scan;
-	unsigned retain_target = get_retain_buffers(c);
+	unsigned long retain_target = get_retain_buffers(c);
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
@@ -1833,8 +1833,8 @@ static bool older_than(struct dm_buffer
 static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
 {
 	struct dm_buffer *b, *tmp;
-	unsigned retain_target = get_retain_buffers(c);
-	unsigned count;
+	unsigned long retain_target = get_retain_buffers(c);
+	unsigned long count;
 	LIST_HEAD(write_list);
 
 	dm_bufio_lock(c);
@@ -1994,7 +1994,7 @@ MODULE_PARM_DESC(max_cache_size_bytes, "
 module_param_named(max_age_seconds, dm_bufio_max_age, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_age_seconds, "Max age of a buffer in seconds");
 
-module_param_named(retain_bytes, dm_bufio_retain_bytes, uint, S_IRUGO | S_IWUSR);
+module_param_named(retain_bytes, dm_bufio_retain_bytes, ulong, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(retain_bytes, "Try to keep at least this many bytes cached in memory");
 
 module_param_named(peak_allocated_bytes, dm_bufio_peak_allocated, ulong, S_IRUGO | S_IWUSR);
