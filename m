From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 4/4] dm-writecache: use new API for flushing
Date: Sat, 19 May 2018 07:25:07 +0200
Message-ID: <20180519052635.567438191@debian.vm>
References: <20180519052503.325953342@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-writecache-interface.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use new API for flushing persistent memory.

The problem is this:
* on X86-64, non-temporal stores have the best performance
* ARM64 doesn't have non-temporal stores, so we must flush cache. We
  should flush cache as late as possible, because it performs better this
  way.

We introduce functions pmem_memcpy, pmem_flush and pmem_commit. To commit
data persistently, all three functions must be called.

The macro pmem_assign may be used instead of pmem_memcpy. pmem_assign
(unlike pmem_memcpy) guarantees that 8-byte values are written atomically.

On X86, pmem_memcpy is memcpy_flushcache, pmem_flush is empty and
pmem_commit is wmb.

On ARM64, pmem_memcpy is memcpy, pmem_flush is arch_wb_cache_pmem and
pmem_commit is empty.

Signed-off-by: Mike Snitzer <msnitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |  100 +++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 44 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-05-19 06:20:28.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-05-19 07:10:26.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/dm-kcopyd.h>
 #include <linux/dax.h>
 #include <linux/pfn_t.h>
+#include <linux/libnvdimm.h>
 
 #define DM_MSG_PREFIX "writecache"
 
@@ -47,14 +48,48 @@
  * On ARM64, cache flushing is more efficient.
  */
 #if defined(CONFIG_X86_64)
-#define EAGER_DATA_FLUSH
-#define NT_STORE(dest, src)				\
-do {							\
-	typeof(src) val = (src);			\
-	memcpy_flushcache(&(dest), &val, sizeof(src));	\
+
+static void pmem_memcpy(void *dest, void *src, size_t len)
+{
+	memcpy_flushcache(dest, src, len);
+}
+
+#define __pmem_assign(dest, src, uniq)				\
+do {								\
+	typeof(dest) uniq = (src);				\
+	memcpy_flushcache(&(dest), &uniq, sizeof(dest));	\
 } while (0)
+
+#define pmem_assign(dest, src)					\
+	__pmem_assign(dest, src, __UNIQUE_ID(pmem_assign))
+
+static void pmem_flush(void *dest, size_t len)
+{
+}
+
+static void pmem_commit(void)
+{
+	wmb();
+}
+
 #else
-#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
+
+static void pmem_memcpy(void *dest, void *src, size_t len)
+{
+	memcpy(dest, src, len);
+}
+
+#define pmem_assign(dest, src)		WRITE_ONCE(dest, src)
+
+static void pmem_flush(void *dest, size_t len)
+{
+	arch_wb_cache_pmem(dest, len);
+}
+
+static void pmem_commit(void)
+{
+}
+
 #endif
 
 #if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && !defined(DM_WRITECACHE_ONLY_SSD)
@@ -105,7 +140,7 @@ struct wc_entry {
 };
 
 #ifndef DM_WRITECACHE_ONLY_SSD
-#define WC_MODE_PMEM(wc)			((wc)->pmem_mode)
+#define WC_MODE_PMEM(wc)			(likely((wc)->pmem_mode))
 #define WC_MODE_FUA(wc)				((wc)->writeback_fua)
 #else
 #define WC_MODE_PMEM(wc)			false
@@ -400,21 +435,6 @@ static void persistent_memory_invalidate
 		invalidate_kernel_vmap_range(ptr, size);
 }
 
-static void persistent_memory_flush(struct dm_writecache *wc, void *ptr, size_t size)
-{
-#ifndef EAGER_DATA_FLUSH
-	dax_flush(wc->ssd_dev->dax_dev, ptr, size);
-#endif
-}
-
-static void persistent_memory_commit_flushed(void)
-{
-#ifdef EAGER_DATA_FLUSH
-	/* needed since memcpy_flushcache is used instead of dax_flush */
-	wmb();
-#endif
-}
-
 static struct wc_memory_superblock *sb(struct dm_writecache *wc)
 {
 	return wc->memory_map;
@@ -462,21 +482,20 @@ static void clear_seq_count(struct dm_wr
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	e->seq_count = -1;
 #endif
-	NT_STORE(memory_entry(wc, e)->seq_count, cpu_to_le64(-1));
+	pmem_assign(memory_entry(wc, e)->seq_count, cpu_to_le64(-1));
 }
 
 static void write_original_sector_seq_count(struct dm_writecache *wc, struct wc_entry *e,
 					    uint64_t original_sector, uint64_t seq_count)
 {
-	struct wc_memory_entry *me_p, me;
+	struct wc_memory_entry me;
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	e->original_sector = original_sector;
 	e->seq_count = seq_count;
 #endif
-	me_p = memory_entry(wc, e);
 	me.original_sector = cpu_to_le64(original_sector);
 	me.seq_count = cpu_to_le64(seq_count);
-	NT_STORE(*me_p, me);
+	pmem_assign(*memory_entry(wc, e), me);
 }
 
 #define writecache_error(wc, err, msg, arg...)				\
@@ -491,8 +510,7 @@ do {									\
 static void writecache_flush_all_metadata(struct dm_writecache *wc)
 {
 	if (WC_MODE_PMEM(wc)) {
-		persistent_memory_flush(wc,
-			sb(wc), offsetof(struct wc_memory_superblock, entries[wc->n_blocks]));
+		pmem_flush(sb(wc), offsetof(struct wc_memory_superblock, entries[wc->n_blocks]));
 	} else {
 		memset(wc->dirty_bitmap, -1, wc->dirty_bitmap_size);
 	}
@@ -501,7 +519,7 @@ static void writecache_flush_all_metadat
 static void writecache_flush_region(struct dm_writecache *wc, void *ptr, size_t size)
 {
 	if (WC_MODE_PMEM(wc))
-		persistent_memory_flush(wc, ptr, size);
+		pmem_flush(ptr, size);
 	else
 		__set_bit(((char *)ptr - (char *)wc->memory_map) / BITMAP_GRANULARITY,
 			  wc->dirty_bitmap);
@@ -579,7 +597,7 @@ static void ssd_commit_flushed(struct dm
 static void writecache_commit_flushed(struct dm_writecache *wc)
 {
 	if (WC_MODE_PMEM(wc))
-		persistent_memory_commit_flushed();
+		pmem_commit();
 	else
 		ssd_commit_flushed(wc);
 }
@@ -788,10 +806,8 @@ static void writecache_poison_lists(stru
 static void writecache_flush_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
 	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
-#ifndef EAGER_DATA_FLUSH
 	if (WC_MODE_PMEM(wc))
 		writecache_flush_region(wc, memory_data(wc, e), wc->block_size);
-#endif
 }
 
 static bool writecache_entry_is_committed(struct dm_writecache *wc, struct wc_entry *e)
@@ -834,7 +850,7 @@ static void writecache_flush(struct dm_w
 	writecache_wait_for_ios(wc, WRITE);
 
 	wc->seq_count++;
-	NT_STORE(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
+	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
 	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
 	writecache_commit_flushed(wc);
 
@@ -1152,11 +1168,7 @@ static void bio_copy_block(struct dm_wri
 			}
 		} else {
 			flush_dcache_page(bio_page(bio));
-#ifdef EAGER_DATA_FLUSH
-			memcpy_flushcache(data, buf, size);
-#else
-			memcpy(data, buf, size);
-#endif
+			pmem_memcpy(data, buf, size);
 		}
 
 		bvec_kunmap_irq(buf, &flags);
@@ -1850,18 +1862,18 @@ static int init_memory(struct dm_writeca
 		return r;
 
 	for (b = 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
-		NT_STORE(sb(wc)->padding[b], cpu_to_le64(0));
-	NT_STORE(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION));
-	NT_STORE(sb(wc)->block_size, cpu_to_le32(wc->block_size));
-	NT_STORE(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
-	NT_STORE(sb(wc)->seq_count, cpu_to_le64(0));
+		pmem_assign(sb(wc)->padding[b], cpu_to_le64(0));
+	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION));
+	pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_size));
+	pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
+	pmem_assign(sb(wc)->seq_count, cpu_to_le64(0));
 
 	for (b = 0; b < wc->n_blocks; b++)
 		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
 
 	writecache_flush_all_metadata(wc);
 	writecache_commit_flushed(wc);
-	NT_STORE(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
+	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
 	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
 	writecache_commit_flushed(wc);
 
