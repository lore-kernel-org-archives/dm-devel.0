From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: avoid a possible __vmalloc deadlock
Date: Fri, 5 Apr 2013 15:57:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304051547370.18568@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Mike <mikeandmore@gmail.com>
List-Id: dm-devel.ids

Hi

This patch avoids a possible deadlock in dm-bufio. (it could happen only 
with large block size, at most PAGE_SIZE << MAX_ORDER (typically 8MiB).

Mikulas

---

dm-bufio: use memalloc_noio_save()

__vmalloc doesn't fully respect gfp flags. The specified gfp flags are
used for allocation of requested pages, structures vmap_area, vmap_block
and vm_struct and the radix tree nodes.

However, the kernel pagetables are allocated always with GFP_KERNEL. Thus
the allocation of pagetables can recurse back to the I/O layer and cause a
deadlock.

This patch uses the function memalloc_noio_save to set per-process
PF_MEMALLOC_NOIO flag and the function memalloc_noio_restore to restore
it. When this flag is set, all allocations in the process are done with
implied GFP_NOIO flag, thus the deadlock can't happen.

This should be backported to stable kernels, but they don't have the
PF_MEMALLOC_NOIO flag and memalloc_noio_save/memalloc_noio_restore
functions. So, PF_MEMALLOC should be set and restored instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-bufio.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-3.9-rc5-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.9-rc5-fast.orig/drivers/md/dm-bufio.c	2013-04-05 00:02:20.000000000 +0200
+++ linux-3.9-rc5-fast/drivers/md/dm-bufio.c	2013-04-05 00:59:15.000000000 +0200
@@ -319,6 +319,9 @@ static void __cache_size_refresh(void)
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 			       enum data_mode *data_mode)
 {
+	unsigned noio_flag;
+	void *ptr;
+
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
 		*data_mode = DATA_MODE_SLAB;
 		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
@@ -332,7 +335,26 @@ static void *alloc_buffer_data(struct dm
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
-	return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	/*
+	 * __vmalloc allocates the data pages and auxiliary structures with
+	 * gfp_flags that were specified, but pagetables are always allocated
+	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
+	 *
+	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
+	 * all allocations done by this process (including pagetables) are done
+	 * as if GFP_NOIO was specified.
+	 */
+
+	if (gfp_mask & __GFP_NORETRY)
+		noio_flag = memalloc_noio_save();
+
+	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	if (gfp_mask & __GFP_NORETRY)
+		memalloc_noio_restore(noio_flag);
+
+	return ptr;
 }
 
 /*
