From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 5/7] blkio-cgroup: Page tracking hooks
Date: Tue, 28 Apr 2009 21:46:32 +0900 (JST)
Message-ID: <20090428.214632.189725895.ryov@valinux.co.jp>
References: <20090428.214457.226801820.ryov@valinux.co.jp>
	<20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090428.214604.104034341.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
List-Id: dm-devel.ids

This patch contains several hooks that let the blkio-cgroup framework to know
which blkio-cgroup is the owner of a page before starting I/O against the page.

Based on 2.6.30-rc3-git3
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 fs/buffer.c         |    2 ++
 fs/direct-io.c      |    2 ++
 mm/bounce.c         |    2 ++
 mm/filemap.c        |    2 ++
 mm/memory.c         |    5 +++++
 mm/page-writeback.c |    2 ++
 mm/swap_state.c     |    2 ++
 7 files changed, 17 insertions(+)

Index: linux-2.6.30-rc3-git3/fs/buffer.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/fs/buffer.c
+++ linux-2.6.30-rc3-git3/fs/buffer.c
@@ -36,6 +36,7 @@
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
+#include <linux/biotrack.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
@@ -668,6 +669,7 @@ static void __set_page_dirty(struct page
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
+		blkio_cgroup_reset_owner_pagedirty(page, current->mm);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
Index: linux-2.6.30-rc3-git3/fs/direct-io.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/fs/direct-io.c
+++ linux-2.6.30-rc3-git3/fs/direct-io.c
@@ -33,6 +33,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/biotrack.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <asm/atomic.h>
@@ -797,6 +798,7 @@ static int do_direct_IO(struct dio *dio)
 			ret = PTR_ERR(page);
 			goto out;
 		}
+		blkio_cgroup_reset_owner(page, current->mm);
 
 		while (block_in_page < blocks_per_page) {
 			unsigned offset_in_page = block_in_page << blkbits;
Index: linux-2.6.30-rc3-git3/mm/bounce.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/mm/bounce.c
+++ linux-2.6.30-rc3-git3/mm/bounce.c
@@ -14,6 +14,7 @@
 #include <linux/hash.h>
 #include <linux/highmem.h>
 #include <linux/blktrace_api.h>
+#include <linux/biotrack.h>
 #include <trace/block.h>
 #include <asm/tlbflush.h>
 
@@ -212,6 +213,7 @@ static void __blk_queue_bounce(struct re
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		blkio_cgroup_copy_owner(to->bv_page, page);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
Index: linux-2.6.30-rc3-git3/mm/filemap.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/mm/filemap.c
+++ linux-2.6.30-rc3-git3/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include "internal.h"
 
@@ -464,6 +465,7 @@ int add_to_page_cache_locked(struct page
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
+	blkio_cgroup_set_owner(page, current->mm);
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
Index: linux-2.6.30-rc3-git3/mm/memory.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/mm/memory.c
+++ linux-2.6.30-rc3-git3/mm/memory.c
@@ -51,6 +51,7 @@
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 #include <linux/mmu_notifier.h>
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
@@ -2053,6 +2054,7 @@ gotten:
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
+		blkio_cgroup_set_owner(new_page, mm);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		if (old_page) {
@@ -2497,6 +2499,7 @@ static int do_swap_page(struct mm_struct
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
+	blkio_cgroup_reset_owner(page, mm);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -2560,6 +2563,7 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	page_add_new_anon_rmap(page, vma, address);
+	blkio_cgroup_set_owner(page, mm);
 	set_pte_at(mm, address, page_table, entry);
 
 	/* No need to invalidate - it was non-present before */
@@ -2712,6 +2716,7 @@ static int __do_fault(struct mm_struct *
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
 			page_add_new_anon_rmap(page, vma, address);
+			blkio_cgroup_set_owner(page, mm);
 		} else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(page);
Index: linux-2.6.30-rc3-git3/mm/page-writeback.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/mm/page-writeback.c
+++ linux-2.6.30-rc3-git3/mm/page-writeback.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/biotrack.h>
 #include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
@@ -1243,6 +1244,7 @@ int __set_page_dirty_nobuffers(struct pa
 			BUG_ON(mapping2 != mapping);
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			account_page_dirtied(page, mapping);
+			blkio_cgroup_reset_owner_pagedirty(page, current->mm);
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
Index: linux-2.6.30-rc3-git3/mm/swap_state.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/mm/swap_state.c
+++ linux-2.6.30-rc3-git3/mm/swap_state.c
@@ -18,6 +18,7 @@
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/page_cgroup.h>
+#include <linux/biotrack.h>
 
 #include <asm/pgtable.h>
 
@@ -308,6 +309,7 @@ struct page *read_swap_cache_async(swp_e
 		 */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
+		blkio_cgroup_set_owner(new_page, current->mm);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (likely(!err)) {
 			/*
