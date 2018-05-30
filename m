From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache changes
Date: Wed, 30 May 2018 12:11:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805301209430.12334@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch removes the per-architecture abstraction.

Only pmem_assign is left, because it is more convenient to use than 
memcpy_flushcache (and also, on architectures that don't support 
persistent memory, we want to redefine pmem_assign so that it doesn't 
flush the cache).

It also fixes a test for failure of dm_io_client_create and
dm_kcopyd_client_create.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   72 ++++++---------------------------------------
 1 file changed, 11 insertions(+), 61 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-05-30 17:38:22.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-05-30 18:02:13.000000000 +0200
@@ -34,60 +34,12 @@
 #define BITMAP_GRANULARITY	PAGE_SIZE
 #endif
 
-/*
- * API for optimized flushing of persistent memory:
- * On X86, non-temporal stores are more efficient than cache flushing.
- * On ARM64, cache flushing is more efficient.
- *
- * This API is a candidate for being elevated out of DM but for now
- * it serves to cleanly allow optimized flushing without excessive
- * branching throughout this target's code.
- */
-#if defined(CONFIG_X86_64)
-
-#define __pmem_assign(dest, src, uniq)				\
+#define pmem_assign(dest, src)					\
 do {								\
 	typeof(dest) uniq = (src);				\
 	memcpy_flushcache(&(dest), &uniq, sizeof(dest));	\
 } while (0)
 
-#define pmem_assign(dest, src)					\
-	__pmem_assign(dest, src, __UNIQUE_ID(pmem_assign))
-
-static void pmem_memcpy(void *dest, void *src, size_t len)
-{
-	memcpy_flushcache(dest, src, len);
-}
-
-static void pmem_flush(void *dest, size_t len)
-{
-}
-
-static void pmem_commit(void)
-{
-	wmb();
-}
-
-#else
-
-#define pmem_assign(dest, src)	WRITE_ONCE(dest, src)
-
-static void pmem_memcpy(void *dest, void *src, size_t len)
-{
-	memcpy(dest, src, len);
-}
-
-static void pmem_flush(void *dest, size_t len)
-{
-	arch_wb_cache_pmem(dest, len);
-}
-
-static void pmem_commit(void)
-{
-}
-
-#endif
-
 #if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && defined(CONFIG_ARCH_HAS_PMEM_API)
 #define DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 #endif
@@ -450,17 +402,13 @@ do {									\
 
 static void writecache_flush_all_metadata(struct dm_writecache *wc)
 {
-	if (WC_MODE_PMEM(wc))
-		pmem_flush(sb(wc), offsetof(struct wc_memory_superblock, entries[wc->n_blocks]));
-	else
+	if (!WC_MODE_PMEM(wc))
 		memset(wc->dirty_bitmap, -1, wc->dirty_bitmap_size);
 }
 
 static void writecache_flush_region(struct dm_writecache *wc, void *ptr, size_t size)
 {
-	if (WC_MODE_PMEM(wc))
-		pmem_flush(ptr, size);
-	else
+	if (!WC_MODE_PMEM(wc))
 		__set_bit(((char *)ptr - (char *)wc->memory_map) / BITMAP_GRANULARITY,
 			  wc->dirty_bitmap);
 }
@@ -537,7 +485,7 @@ static void ssd_commit_flushed(struct dm
 static void writecache_commit_flushed(struct dm_writecache *wc)
 {
 	if (WC_MODE_PMEM(wc))
-		pmem_commit();
+		wmb();
 	else
 		ssd_commit_flushed(wc);
 }
@@ -1090,7 +1038,7 @@ static void bio_copy_block(struct dm_wri
 			}
 		} else {
 			flush_dcache_page(bio_page(bio));
-			pmem_memcpy(data, buf, size);
+			memcpy_flushcache(data, buf, size);
 		}
 
 		bvec_kunmap_irq(buf, &flags);
@@ -1872,9 +1820,10 @@ static int writecache_ctr(struct dm_targ
 	}
 
 	wc->dm_io = dm_io_client_create();
-	if (!wc->dm_io) {
-		r = -ENOMEM;
+	if (IS_ERR(wc->dm_io)) {
+		r = PTR_ERR(wc->dm_io);
 		ti->error = "Unable to allocate dm-io client";
+		wc->dm_io = NULL;
 		goto bad;
 	}
 
@@ -2096,9 +2045,10 @@ invalid_optional:
 		}
 
 		wc->dm_kcopyd = dm_kcopyd_client_create(&dm_kcopyd_throttle);
-		if (!wc->dm_kcopyd) {
-			r = -ENOMEM;
+		if (IS_ERR(wc->dm_kcopyd)) {
+			r = PTR_ERR(wc->dm_kcopyd);
 			ti->error = "Unable to allocate dm-kcopyd client";
+			wc->dm_kcopyd = NULL;
 			goto bad;
 		}
 
