From: Arun KS <arunks@codeaurora.org>
Subject: [PATCH] mm: convert totalram_pages,
	totalhigh_pages and managed_pages to atomic.
Date: Mon, 22 Oct 2018 22:53:22 +0530
Message-ID: <1540229092-25207-1-git-send-email-arunks__13834.8115412102$1540281936$gmane$org@codeaurora.org>
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
To: Guo Ren <ren_guo@c-sky.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, David Airlie <airlied@linux.ie>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrig>
Cc: getarunks@gmail.com
List-Id: dm-devel.ids

Remove managed_page_count_lock spinlock and instead use atomic
variables.

Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Arun KS <arunks@codeaurora.org>

---
As discussed here,
https://patchwork.kernel.org/patch/10627521/#22261253
---
---
 arch/csky/mm/init.c                           |  4 +-
 arch/powerpc/platforms/pseries/cmm.c          | 11 ++--
 arch/s390/mm/init.c                           |  2 +-
 arch/um/kernel/mem.c                          |  4 +-
 arch/x86/kernel/cpu/microcode/core.c          |  5 +-
 drivers/char/agp/backend.c                    |  4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c         |  2 +-
 drivers/gpu/drm/i915/i915_gem.c               |  2 +-
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c |  4 +-
 drivers/hv/hv_balloon.c                       | 19 +++----
 drivers/md/dm-bufio.c                         |  5 +-
 drivers/md/dm-crypt.c                         |  4 +-
 drivers/md/dm-integrity.c                     |  4 +-
 drivers/md/dm-stats.c                         |  3 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c      |  3 +-
 drivers/misc/vmw_balloon.c                    |  2 +-
 drivers/parisc/ccio-dma.c                     |  5 +-
 drivers/parisc/sba_iommu.c                    |  5 +-
 drivers/staging/android/ion/ion_system_heap.c |  2 +-
 drivers/xen/xen-selfballoon.c                 |  7 +--
 fs/ceph/super.h                               |  3 +-
 fs/file_table.c                               |  9 ++--
 fs/fuse/inode.c                               |  4 +-
 fs/nfs/write.c                                |  3 +-
 fs/nfsd/nfscache.c                            |  3 +-
 fs/ntfs/malloc.h                              |  2 +-
 fs/proc/base.c                                |  3 +-
 include/linux/highmem.h                       |  2 +-
 include/linux/mm.h                            |  2 +-
 include/linux/mmzone.h                        | 10 +---
 include/linux/swap.h                          |  2 +-
 kernel/fork.c                                 |  6 +--
 kernel/kexec_core.c                           |  5 +-
 kernel/power/snapshot.c                       |  2 +-
 lib/show_mem.c                                |  3 +-
 mm/highmem.c                                  |  2 +-
 mm/huge_memory.c                              |  2 +-
 mm/kasan/quarantine.c                         |  4 +-
 mm/memblock.c                                 |  6 +--
 mm/memory_hotplug.c                           |  4 +-
 mm/mm_init.c                                  |  3 +-
 mm/oom_kill.c                                 |  2 +-
 mm/page_alloc.c                               | 75 ++++++++++++++-------------
 mm/shmem.c                                    | 12 +++--
 mm/slab.c                                     |  3 +-
 mm/swap.c                                     |  3 +-
 mm/util.c                                     |  2 +-
 mm/vmalloc.c                                  |  4 +-
 mm/vmstat.c                                   |  4 +-
 mm/workingset.c                               |  2 +-
 mm/zswap.c                                    |  2 +-
 net/dccp/proto.c                              |  6 +--
 net/decnet/dn_route.c                         |  2 +-
 net/ipv4/tcp_metrics.c                        |  2 +-
 net/netfilter/nf_conntrack_core.c             |  6 +--
 net/netfilter/xt_hashlimit.c                  |  4 +-
 net/sctp/protocol.c                           |  6 +--
 security/integrity/ima/ima_kexec.c            |  2 +-
 58 files changed, 171 insertions(+), 143 deletions(-)

diff --git a/arch/csky/mm/init.c b/arch/csky/mm/init.c
index dc07c07..3f4d35e 100644
--- a/arch/csky/mm/init.c
+++ b/arch/csky/mm/init.c
@@ -71,7 +71,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 		ClearPageReserved(virt_to_page(start));
 		init_page_count(virt_to_page(start));
 		free_page(start);
-		totalram_pages++;
+		atomic_long_inc(&totalram_pages);
 	}
 }
 #endif
@@ -88,7 +88,7 @@ void free_initmem(void)
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		free_page(addr);
-		totalram_pages++;
+		atomic_long_inc(&totalram_pages);
 		addr += PAGE_SIZE;
 	}
 
diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 25427a4..85fe503 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -208,7 +208,7 @@ static long cmm_alloc_pages(long nr)
 
 		pa->page[pa->index++] = addr;
 		loaned_pages++;
-		totalram_pages--;
+		atomic_long_dec(&totalram_pages);
 		spin_unlock(&cmm_lock);
 		nr--;
 	}
@@ -247,7 +247,7 @@ static long cmm_free_pages(long nr)
 		free_page(addr);
 		loaned_pages--;
 		nr--;
-		totalram_pages++;
+		atomic_long_inc(&totalram_pages);
 	}
 	spin_unlock(&cmm_lock);
 	cmm_dbg("End request with %ld pages unfulfilled\n", nr);
@@ -291,7 +291,8 @@ static void cmm_get_mpp(void)
 	int rc;
 	struct hvcall_mpp_data mpp_data;
 	signed long active_pages_target, page_loan_request, target;
-	signed long total_pages = totalram_pages + loaned_pages;
+	signed long total_pages = atomic_long_read(&totalram_pages) +
+				  loaned_pages;
 	signed long min_mem_pages = (min_mem_mb * 1024 * 1024) / PAGE_SIZE;
 
 	rc = h_get_mpp(&mpp_data);
@@ -322,7 +323,7 @@ static void cmm_get_mpp(void)
 
 	cmm_dbg("delta = %ld, loaned = %lu, target = %lu, oom = %lu, totalram = %lu\n",
 		page_loan_request, loaned_pages, loaned_pages_target,
-		oom_freed_pages, totalram_pages);
+		oom_freed_pages, atomic_long_read(&totalram_pages));
 }
 
 static struct notifier_block cmm_oom_nb = {
@@ -581,7 +582,7 @@ static int cmm_mem_going_offline(void *arg)
 			free_page(pa_curr->page[idx]);
 			freed++;
 			loaned_pages--;
-			totalram_pages++;
+			atomic_long_inc(&totalram_pages);
 			pa_curr->page[idx] = pa_last->page[--pa_last->index];
 			if (pa_last->index == 0) {
 				if (pa_curr == pa_last)
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 76d0708..d6529e8 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -59,7 +59,7 @@ static void __init setup_zero_pages(void)
 	order = 7;
 
 	/* Limit number of empty zero pages for small memory sizes */
-	while (order > 2 && (totalram_pages >> 10) < (1UL << order))
+	while (order > 2 && (atomic_long_read(&totalram_pages) >> 10) < (1UL << order))
 		order--;
 
 	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 1067469..da78a06 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -51,8 +51,8 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-	max_low_pfn = totalram_pages;
-	max_pfn = totalram_pages;
+	max_low_pfn = atomic_long_read(&totalram_pages);
+	max_pfn = atomic_long_read(&totalram_pages);
 	mem_init_print_info(NULL);
 	kmalloc_ok = 1;
 }
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2637ff0..4ccc8dd 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -435,8 +435,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 {
 	ssize_t ret = -EINVAL;
 
-	if ((len >> PAGE_SHIFT) > totalram_pages) {
-		pr_err("too much data (max %ld pages)\n", totalram_pages);
+	if ((len >> PAGE_SHIFT) > atomic_long_read(&totalram_pages)) {
+		pr_err("too much data (max %ld pages)\n",
+				atomic_long_read(&totalram_pages));
 		return ret;
 	}
 
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index 38ffb28..2753e1d 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -115,9 +115,9 @@ static int agp_find_max(void)
 	long memory, index, result;
 
 #if PAGE_SHIFT < 20
-	memory = totalram_pages >> (20 - PAGE_SHIFT);
+	memory = atomic_long_read(&totalram_pages) >> (20 - PAGE_SHIFT);
 #else
-	memory = totalram_pages << (PAGE_SHIFT - 20);
+	memory = atomic_long_read(&totalram_pages) << (PAGE_SHIFT - 20);
 #endif
 	index = 1;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 56412b0..ca18502 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -848,7 +848,7 @@ static int kfd_fill_mem_info_for_cpu(int numa_node_id, int *avail_size,
 	 */
 	pgdat = NODE_DATA(numa_node_id);
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
-		mem_in_bytes += pgdat->node_zones[zone_type].managed_pages;
+		mem_in_bytes += atomic_long_read(&pgdat->node_zones[zone_type].managed_pages);
 	mem_in_bytes <<= PAGE_SHIFT;
 
 	sub_type_hdr->length_low = lower_32_bits(mem_in_bytes);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0c8aa57..b4c245b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2539,7 +2539,7 @@ static int i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
 	 * If there's no chance of allocating enough pages for the whole
 	 * object, bail early.
 	 */
-	if (page_count > totalram_pages)
+	if (page_count > atomic_long_read(&totalram_pages))
 		return -ENOMEM;
 
 	st = kmalloc(sizeof(*st), GFP_KERNEL);
diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
index 8e2e269..9ea10eb 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -170,7 +170,7 @@ static int igt_ppgtt_alloc(void *arg)
 	 * This should ensure that we do not run into the oomkiller during
 	 * the test and take down the machine wilfully.
 	 */
-	limit = totalram_pages << PAGE_SHIFT;
+	limit = atomic_long_read(&totalram_pages) << PAGE_SHIFT;
 	limit = min(ppgtt->vm.total, limit);
 
 	/* Check we can allocate the entire range */
@@ -1244,7 +1244,7 @@ static int exercise_mock(struct drm_i915_private *i915,
 				     u64 hole_start, u64 hole_end,
 				     unsigned long end_time))
 {
-	const u64 limit = totalram_pages << PAGE_SHIFT;
+	const u64 limit = atomic_long_read(&totalram_pages) << PAGE_SHIFT;
 	struct i915_gem_context *ctx;
 	struct i915_hw_ppgtt *ppgtt;
 	IGT_TIMEOUT(end_time);
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index c5bc0b5..4498c94 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1092,6 +1092,7 @@ static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg *msg)
 static unsigned long compute_balloon_floor(void)
 {
 	unsigned long min_pages;
+	unsigned long totalram = (unsigned long)atomic_long_read(&totalram_pages);
 #define MB2PAGES(mb) ((mb) << (20 - PAGE_SHIFT))
 	/* Simple continuous piecewiese linear function:
 	 *  max MiB -> min MiB  gradient
@@ -1104,16 +1105,16 @@ static unsigned long compute_balloon_floor(void)
 	 *    8192       744    (1/16)
 	 *   32768      1512	(1/32)
 	 */
-	if (totalram_pages < MB2PAGES(128))
-		min_pages = MB2PAGES(8) + (totalram_pages >> 1);
-	else if (totalram_pages < MB2PAGES(512))
-		min_pages = MB2PAGES(40) + (totalram_pages >> 2);
-	else if (totalram_pages < MB2PAGES(2048))
-		min_pages = MB2PAGES(104) + (totalram_pages >> 3);
-	else if (totalram_pages < MB2PAGES(8192))
-		min_pages = MB2PAGES(232) + (totalram_pages >> 4);
+	if (totalram < MB2PAGES(128))
+		min_pages = MB2PAGES(8) + (totalram >> 1);
+	else if (totalram < MB2PAGES(512))
+		min_pages = MB2PAGES(40) + (totalram >> 2);
+	else if (totalram < MB2PAGES(2048))
+		min_pages = MB2PAGES(104) + (totalram >> 3);
+	else if (totalram < MB2PAGES(8192))
+		min_pages = MB2PAGES(232) + (totalram >> 4);
 	else
-		min_pages = MB2PAGES(488) + (totalram_pages >> 5);
+		min_pages = MB2PAGES(488) + (totalram >> 5);
 #undef MB2PAGES
 	return min_pages;
 }
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index dc385b7..6d61259 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1887,8 +1887,9 @@ static int __init dm_bufio_init(void)
 	dm_bufio_allocated_vmalloc = 0;
 	dm_bufio_current_allocated = 0;
 
-	mem = (__u64)mult_frac(totalram_pages - totalhigh_pages,
-			       DM_BUFIO_MEMORY_PERCENT, 100) << PAGE_SHIFT;
+	mem = (__u64)mult_frac(atomic_long_read(&totalram_pages) -
+				atomic_long_read(&totalhigh_pages),
+				DM_BUFIO_MEMORY_PERCENT, 100) << PAGE_SHIFT;
 
 	if (mem > ULONG_MAX)
 		mem = ULONG_MAX;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0481223..1c58f4c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2158,7 +2158,9 @@ static int crypt_wipe_key(struct crypt_config *cc)
 
 static void crypt_calculate_pages_per_client(void)
 {
-	unsigned long pages = (totalram_pages - totalhigh_pages) * DM_CRYPT_MEMORY_PERCENT / 100;
+	unsigned long pages = (atomic_long_read(&totalram_pages) -
+				atomic_long_read(&totalhigh_pages)) *
+				DM_CRYPT_MEMORY_PERCENT / 100;
 
 	if (!dm_crypt_clients_n)
 		return;
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index bb3096b..d91c931 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2843,7 +2843,9 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 	journal_pages = roundup((__u64)ic->journal_sections * ic->journal_section_sectors,
 				PAGE_SIZE >> SECTOR_SHIFT) >> (PAGE_SHIFT - SECTOR_SHIFT);
 	journal_desc_size = journal_pages * sizeof(struct page_list);
-	if (journal_pages >= totalram_pages - totalhigh_pages || journal_desc_size > ULONG_MAX) {
+	if (journal_pages >= atomic_long_read(&totalram_pages) -
+			atomic_long_read(&totalhigh_pages) ||
+			journal_desc_size > ULONG_MAX) {
 		*error = "Journal doesn't fit into memory";
 		r = -ENOMEM;
 		goto bad;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 21de30b..f154a07 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -85,7 +85,8 @@ static bool __check_shared_memory(size_t alloc_size)
 	a = shared_memory_amount + alloc_size;
 	if (a < shared_memory_amount)
 		return false;
-	if (a >> PAGE_SHIFT > totalram_pages / DM_STATS_MEMORY_FACTOR)
+	if (a >> PAGE_SHIFT > atomic_long_read(&totalram_pages) /
+					DM_STATS_MEMORY_FACTOR)
 		return false;
 #ifdef CONFIG_MMU
 	if (a > (VMALLOC_END - VMALLOC_START) / DM_STATS_VMALLOC_FACTOR)
diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index 616f78b..ee3654a 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -855,7 +855,8 @@ static int mtk_vpu_probe(struct platform_device *pdev)
 	/* Set PTCM to 96K and DTCM to 32K */
 	vpu_cfg_writel(vpu, 0x2, VPU_TCM_CFG);
 
-	vpu->enable_4GB = !!(totalram_pages > (SZ_2G >> PAGE_SHIFT));
+	vpu->enable_4GB = !!(atomic_long_read(&totalram_pages) >
+					(SZ_2G >> PAGE_SHIFT));
 	dev_info(dev, "4GB mode %u\n", vpu->enable_4GB);
 
 	if (vpu->enable_4GB) {
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 9b0b3fa..0ac0fee 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -570,7 +570,7 @@ static int vmballoon_send_get_target(struct vmballoon *b)
 	unsigned long status;
 	unsigned long limit;
 
-	limit = totalram_pages;
+	limit = atomic_long_read(&totalram_pages);
 
 	/* Ensure limit fits in 32-bits */
 	if (limit != (u32)limit)
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 6148236..705df1a 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1255,7 +1255,8 @@ void __init ccio_cujo20_fixup(struct parisc_device *cujo, u32 iovp)
 	** Hot-Plug/Removal of PCI cards. (aka PCI OLARD).
 	*/
 
-	iova_space_size = (u32) (totalram_pages / count_parisc_driver(&ccio_driver));
+	iova_space_size = (u32) (atomic_long_read(&totalram_pages) /
+				count_parisc_driver(&ccio_driver));
 
 	/* limit IOVA space size to 1MB-1GB */
 
@@ -1294,7 +1295,7 @@ void __init ccio_cujo20_fixup(struct parisc_device *cujo, u32 iovp)
 
 	DBG_INIT("%s() hpa 0x%p mem %luMB IOV %dMB (%d bits)\n",
 			__func__, ioc->ioc_regs,
-			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
+			(unsigned long) atomic_long_read(&totalram_pages) >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 11de0ec..02f4ce9 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1419,7 +1419,8 @@ static int setup_ibase_imask_callback(struct device *dev, void *data)
 	** for DMA hints - ergo only 30 bits max.
 	*/
 
-	iova_space_size = (u32) (totalram_pages/global_ioc_cnt);
+	iova_space_size = (u32) (atomic_long_read(&totalram_pages)/
+						global_ioc_cnt);
 
 	/* limit IOVA space size to 1MB-1GB */
 	if (iova_space_size < (1 << (20 - PAGE_SHIFT))) {
@@ -1444,7 +1445,7 @@ static int setup_ibase_imask_callback(struct device *dev, void *data)
 	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
 			__func__,
 			ioc->ioc_hpa,
-			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
+			(unsigned long) atomic_long_read(&totalram_pages) >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 548bb02..64bd925 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -110,7 +110,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	unsigned long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 
-	if (size / PAGE_SIZE > totalram_pages / 2)
+	if (size / PAGE_SIZE > atomic_long_read(&totalram_pages) / 2)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&pages);
diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 5165aa8..0b925fd 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -189,7 +189,7 @@ static void selfballoon_process(struct work_struct *work)
 	bool reset_timer = false;
 
 	if (xen_selfballooning_enabled) {
-		cur_pages = totalram_pages;
+		cur_pages = atomic_long_read(&totalram_pages);
 		tgt_pages = cur_pages; /* default is no change */
 		goal_pages = vm_memory_committed() +
 				totalreserve_pages +
@@ -227,7 +227,8 @@ static void selfballoon_process(struct work_struct *work)
 		if (tgt_pages < floor_pages)
 			tgt_pages = floor_pages;
 		balloon_set_new_target(tgt_pages +
-			balloon_stats.current_pages - totalram_pages);
+			balloon_stats.current_pages -
+			atomic_long_read(&totalram_pages));
 		reset_timer = true;
 	}
 #ifdef CONFIG_FRONTSWAP
@@ -569,7 +570,7 @@ int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 	 * much more reliably and response faster in some cases.
 	 */
 	if (!selfballoon_reserved_mb) {
-		reserve_pages = totalram_pages / 10;
+		reserve_pages = atomic_long_read(&totalram_pages) / 10;
 		selfballoon_reserved_mb = PAGES2MB(reserve_pages);
 	}
 	schedule_delayed_work(&selfballoon_worker, selfballoon_interval * HZ);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 582e28f..92f56d3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -807,7 +807,8 @@ static inline int default_congestion_kb(void)
 	 * This allows larger machines to have larger/more transfers.
 	 * Limit the default to 256M
 	 */
-	congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
+	congestion_kb = (16*int_sqrt(atomic_long_read(&totalram_pages))) <<
+								(PAGE_SHIFT-10);
 	if (congestion_kb > 256*1024)
 		congestion_kb = 256*1024;
 
diff --git a/fs/file_table.c b/fs/file_table.c
index e03c8d1..5dde5c3 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -383,10 +383,13 @@ void __init files_init(void)
 void __init files_maxfiles_init(void)
 {
 	unsigned long n;
-	unsigned long memreserve = (totalram_pages - nr_free_pages()) * 3/2;
+	unsigned long memreserve = (atomic_long_read(&totalram_pages) -
+						nr_free_pages()) * 3/2;
 
-	memreserve = min(memreserve, totalram_pages - 1);
-	n = ((totalram_pages - memreserve) * (PAGE_SIZE / 1024)) / 10;
+	memreserve = min(memreserve,
+			(unsigned long)atomic_long_read(&totalram_pages) - 1);
+	n = ((atomic_long_read(&totalram_pages) - memreserve) *
+					(PAGE_SIZE / 1024)) / 10;
 
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 }
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4727ef6..acdbaf7 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -825,8 +825,8 @@ static struct dentry *fuse_get_parent(struct dentry *child)
 static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
-		*limit = ((totalram_pages << PAGE_SHIFT) >> 13) /
-			 sizeof(struct fuse_req);
+		*limit = ((atomic_long_read(&totalram_pages)
+			 << PAGE_SHIFT) >> 13) / sizeof(struct fuse_req);
 
 	if (*limit >= 1 << 16)
 		*limit = (1 << 16) - 1;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 586726a..e3663b7 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2121,7 +2121,8 @@ int __init nfs_init_writepagecache(void)
 	 * This allows larger machines to have larger/more transfers.
 	 * Limit the default to 256M
 	 */
-	nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
+	nfs_congestion_kb = (16*int_sqrt(atomic_long_read(&totalram_pages))) <<
+								(PAGE_SHIFT-10);
 	if (nfs_congestion_kb > 256*1024)
 		nfs_congestion_kb = 256*1024;
 
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index e2fe0e9..e877558 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -99,7 +99,8 @@ static unsigned long nfsd_reply_cache_scan(struct shrinker *shrink,
 nfsd_cache_size_limit(void)
 {
 	unsigned int limit;
-	unsigned long low_pages = totalram_pages - totalhigh_pages;
+	unsigned long low_pages = atomic_long_read(&totalram_pages) -
+					atomic_long_read(&totalhigh_pages);
 
 	limit = (16 * int_sqrt(low_pages)) << (PAGE_SHIFT-10);
 	return min_t(unsigned int, limit, 256*1024);
diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
index ab172e5..4ae6bbe 100644
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -47,7 +47,7 @@ static inline void *__ntfs_malloc(unsigned long size, gfp_t gfp_mask)
 		return kmalloc(PAGE_SIZE, gfp_mask & ~__GFP_HIGHMEM);
 		/* return (void *)__get_free_page(gfp_mask); */
 	}
-	if (likely((size >> PAGE_SHIFT) < totalram_pages))
+	if (likely((size >> PAGE_SHIFT) < atomic_long_read(&totalram_pages)))
 		return __vmalloc(size, gfp_mask, PAGE_KERNEL);
 	return NULL;
 }
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ce34654..9ef26dc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -530,7 +530,8 @@ static ssize_t lstats_write(struct file *file, const char __user *buf,
 static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
-	unsigned long totalpages = totalram_pages + total_swap_pages;
+	unsigned long totalpages = atomic_long_read(&totalram_pages) +
+							total_swap_pages;
 	unsigned long points = 0;
 
 	points = oom_badness(task, NULL, NULL, totalpages) *
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 0690679..84edaa2 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -36,7 +36,7 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
-extern unsigned long totalhigh_pages;
+extern atomic_long_t totalhigh_pages;
 
 void kmap_flush_unused(void);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fcf9cc9..af952fc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -48,7 +48,7 @@ static inline void set_max_mapnr(unsigned long limit)
 static inline void set_max_mapnr(unsigned long limit) { }
 #endif
 
-extern unsigned long totalram_pages;
+extern atomic_long_t totalram_pages;
 extern void * high_memory;
 extern int page_cluster;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8555509..2639b05 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -428,14 +428,8 @@ struct zone {
 	 * Write access to present_pages at runtime should be protected by
 	 * mem_hotplug_begin/end(). Any reader who can't tolerant drift of
 	 * present_pages should get_online_mems() to get a stable value.
-	 *
-	 * Read access to managed_pages should be safe because it's unsigned
-	 * long. Write access to zone->managed_pages and totalram_pages are
-	 * protected by managed_page_count_lock at runtime. Idealy only
-	 * adjust_managed_page_count() should be used instead of directly
-	 * touching zone->managed_pages and totalram_pages.
 	 */
-	unsigned long		managed_pages;
+	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
 
@@ -814,7 +808,7 @@ static inline bool is_dev_zone(const struct zone *zone)
  */
 static inline bool managed_zone(struct zone *zone)
 {
-	return zone->managed_pages;
+	return atomic_long_read(&zone->managed_pages);
 }
 
 /* Returns true if a zone has memory */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index d098743..b34c6e7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -309,7 +309,7 @@ struct vma_swap_readahead {
 } while (0)
 
 /* linux/mm/page_alloc.c */
-extern unsigned long totalram_pages;
+extern atomic_long_t totalram_pages;
 extern unsigned long totalreserve_pages;
 extern unsigned long nr_free_buffer_pages(void);
 extern unsigned long nr_free_pagecache_pages(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index 2f78d32..b6068c5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -744,11 +744,11 @@ static void set_max_threads(unsigned int max_threads_suggested)
 	 * The number of threads shall be limited such that the thread
 	 * structures may only consume a small part of the available memory.
 	 */
-	if (fls64(totalram_pages) + fls64(PAGE_SIZE) > 64)
+	if (fls64(atomic_long_read(&totalram_pages)) + fls64(PAGE_SIZE) > 64)
 		threads = MAX_THREADS;
 	else
-		threads = div64_u64((u64) totalram_pages * (u64) PAGE_SIZE,
-				    (u64) THREAD_SIZE * 8UL);
+		threads = div64_u64((u64) atomic_long_read(&totalram_pages) *
+				(u64) PAGE_SIZE, (u64) THREAD_SIZE * 8UL);
 
 	if (threads > max_threads_suggested)
 		threads = max_threads_suggested;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 86ef06d..ed85ddd 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -217,13 +217,14 @@ int sanity_check_segment_list(struct kimage *image)
 	 * wasted allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
-		if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2)
+		if (PAGE_COUNT(image->segment[i].memsz) >
+				atomic_long_read(&totalram_pages) / 2)
 			return -EINVAL;
 
 		total_pages += PAGE_COUNT(image->segment[i].memsz);
 	}
 
-	if (total_pages > totalram_pages / 2)
+	if (total_pages > atomic_long_read(&totalram_pages) / 2)
 		return -EINVAL;
 
 	/*
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b0308a2..142a3c76 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -105,7 +105,7 @@ void __init hibernate_reserved_size_init(void)
 
 void __init hibernate_image_size_init(void)
 {
-	image_size = ((totalram_pages * 2) / 5) * PAGE_SIZE;
+	image_size = ((atomic_long_read(&totalram_pages) * 2) / 5) * PAGE_SIZE;
 }
 
 /*
diff --git a/lib/show_mem.c b/lib/show_mem.c
index 0beaa1d..0701f63 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -28,7 +28,8 @@ void show_mem(unsigned int filter, nodemask_t *nodemask)
 				continue;
 
 			total += zone->present_pages;
-			reserved += zone->present_pages - zone->managed_pages;
+			reserved += zone->present_pages -
+				atomic_long_read(&zone->managed_pages);
 
 			if (is_highmem_idx(zoneid))
 				highmem += zone->present_pages;
diff --git a/mm/highmem.c b/mm/highmem.c
index 59db322..93a45c0 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -105,7 +105,7 @@ static inline wait_queue_head_t *get_pkmap_wait_queue_head(unsigned int color)
 }
 #endif
 
-unsigned long totalhigh_pages __read_mostly;
+atomic_long_t totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d394d18..f2f18b5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -420,7 +420,7 @@ static int __init hugepage_init(void)
 	 * where the extra memory used could hurt more than TLB overhead
 	 * is likely to save.  The admin can still enable it through /sys.
 	 */
-	if (totalram_pages < (512 << (20 - PAGE_SHIFT))) {
+	if (atomic_long_read(&totalram_pages) < (512 << (20 - PAGE_SHIFT))) {
 		transparent_hugepage_flags = 0;
 		return 0;
 	}
diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index b209dba..4d36aed 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -236,8 +236,8 @@ void quarantine_reduce(void)
 	 * Update quarantine size in case of hotplug. Allocate a fraction of
 	 * the installed memory to quarantine minus per-cpu queue limits.
 	 */
-	total_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
-		QUARANTINE_FRACTION;
+	total_size = (READ_ONCE(atomic_long_read(&totalram_pages)) <<
+			PAGE_SHIFT) / QUARANTINE_FRACTION;
 	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
 	new_quarantine_size = (total_size < percpu_quarantines) ?
 		0 : total_size - percpu_quarantines;
diff --git a/mm/memblock.c b/mm/memblock.c
index eddcac2..43f53e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1627,7 +1627,7 @@ void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
 
 	for (; cursor < end; cursor++) {
 		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages++;
+		atomic_long_inc(&totalram_pages);
 	}
 }
 
@@ -2001,7 +2001,7 @@ void reset_node_managed_pages(pg_data_t *pgdat)
 	struct zone *z;
 
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->managed_pages = 0;
+		atomic_long_set(&z->managed_pages, 0);
 }
 
 void __init reset_all_zones_managed_pages(void)
@@ -2029,7 +2029,7 @@ unsigned long __init memblock_free_all(void)
 	reset_all_zones_managed_pages();
 
 	pages = free_low_memory_core_early();
-	totalram_pages += pages;
+	atomic_long_add(pages, &totalram_pages);
 
 	return pages;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index dbbb945..0725984 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -657,10 +657,10 @@ void __online_page_free(struct page *page)
 static int generic_online_page(struct page *page, unsigned int order)
 {
 	__free_pages_core(page, order);
-	totalram_pages += (1UL << order);
+	atomic_long_add((1UL << order), &totalram_pages);
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
-		totalhigh_pages += (1UL << order);
+		atomic_long_add((1UL << order), &totalhigh_pages);
 #endif
 	return 0;
 }
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6838a53..93a6611 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -146,7 +146,8 @@ static void __meminit mm_compute_batch(void)
 	s32 batch = max_t(s32, nr*2, 32);
 
 	/* batch size set to 0.4% of (total memory/#cpus), or max int32 */
-	memsized_batch = min_t(u64, (totalram_pages/nr)/256, 0x7fffffff);
+	memsized_batch = min_t(u64, (atomic_long_read(&totalram_pages)/nr)/256,
+								0x7fffffff);
 
 	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
 }
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6589f60..1a37d68 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -269,7 +269,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	}
 
 	/* Default to all available memory */
-	oc->totalpages = totalram_pages + total_swap_pages;
+	oc->totalpages = atomic_long_read(&totalram_pages) + total_swap_pages;
 
 	if (!IS_ENABLED(CONFIG_NUMA))
 		return CONSTRAINT_NONE;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4bd858d..c7b26e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -121,10 +121,7 @@
 };
 EXPORT_SYMBOL(node_states);
 
-/* Protect totalram_pages and zone->managed_pages */
-static DEFINE_SPINLOCK(managed_page_count_lock);
-
-unsigned long totalram_pages __read_mostly;
+atomic_long_t totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
@@ -1275,7 +1272,7 @@ void __free_pages_core(struct page *page, unsigned int order)
 		set_page_count(p, 0);
 	}
 
-	page_zone(page)->managed_pages += nr_pages;
+	atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	set_page_refcounted(page);
 	__free_pages(page, order);
 }
@@ -2254,7 +2251,8 @@ static void reserve_highatomic_pageblock(struct page *page, struct zone *zone,
 	 * Limit the number reserved to 1 pageblock or roughly 1% of a zone.
 	 * Check is race-prone but harmless.
 	 */
-	max_managed = (zone->managed_pages / 100) + pageblock_nr_pages;
+	max_managed = (atomic_long_read(&zone->managed_pages) / 100) +
+						pageblock_nr_pages;
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
@@ -4658,7 +4656,7 @@ static unsigned long nr_free_zone_pages(int offset)
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), GFP_KERNEL);
 
 	for_each_zone_zonelist(zone, z, zonelist, offset) {
-		unsigned long size = zone->managed_pages;
+		unsigned long size = atomic_long_read(&zone->managed_pages);
 		unsigned long high = high_wmark_pages(zone);
 		if (size > high)
 			sum += size - high;
@@ -4744,11 +4742,15 @@ long si_mem_available(void)
 
 void si_meminfo(struct sysinfo *val)
 {
-	val->totalram = totalram_pages;
+	val->totalram = atomic_long_read(&totalram_pages);
 	val->sharedram = global_node_page_state(NR_SHMEM);
 	val->freeram = global_zone_page_state(NR_FREE_PAGES);
 	val->bufferram = nr_blockdev_pages();
-	val->totalhigh = totalhigh_pages;
+#ifdef CONFIG_HIGHMEM
+	val->totalhigh = atomic_long_read(&totalhigh_pages);
+#else
+	val->totalhigh = 0;
+#endif
 	val->freehigh = nr_free_highpages();
 	val->mem_unit = PAGE_SIZE;
 }
@@ -4765,7 +4767,7 @@ void si_meminfo_node(struct sysinfo *val, int nid)
 	pg_data_t *pgdat = NODE_DATA(nid);
 
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
-		managed_pages += pgdat->node_zones[zone_type].managed_pages;
+		managed_pages += atomic_long_read(&pgdat->node_zones[zone_type].managed_pages);
 	val->totalram = managed_pages;
 	val->sharedram = node_page_state(pgdat, NR_SHMEM);
 	val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
@@ -4774,7 +4776,7 @@ void si_meminfo_node(struct sysinfo *val, int nid)
 		struct zone *zone = &pgdat->node_zones[zone_type];
 
 		if (is_highmem(zone)) {
-			managed_highpages += zone->managed_pages;
+			managed_highpages += atomic_long_read(&zone->managed_pages);
 			free_highpages += zone_page_state(zone, NR_FREE_PAGES);
 		}
 	}
@@ -4981,7 +4983,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
 			K(zone->present_pages),
-			K(zone->managed_pages),
+			K(atomic_long_read(&zone->managed_pages)),
 			K(zone_page_state(zone, NR_MLOCK)),
 			zone_page_state(zone, NR_KERNEL_STACK_KB),
 			K(zone_page_state(zone, NR_PAGETABLE)),
@@ -5643,7 +5645,7 @@ static int zone_batchsize(struct zone *zone)
 	 * The per-cpu-pages pools are set to around 1000th of the
 	 * size of the zone.
 	 */
-	batch = zone->managed_pages / 1024;
+	batch = atomic_long_read(&zone->managed_pages) / 1024;
 	/* But no more than a meg. */
 	if (batch * PAGE_SIZE > 1024 * 1024)
 		batch = (1024 * 1024) / PAGE_SIZE;
@@ -5754,7 +5756,7 @@ static void pageset_set_high_and_batch(struct zone *zone,
 {
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
-			(zone->managed_pages /
+			(atomic_long_read(&zone->managed_pages) /
 				percpu_pagelist_fraction));
 	else
 		pageset_set_batch(pcp, zone_batchsize(zone));
@@ -6309,7 +6311,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
 							unsigned long remaining_pages)
 {
-	zone->managed_pages = remaining_pages;
+	atomic_long_set(&zone->managed_pages, remaining_pages);
 	zone_set_nid(zone, nid);
 	zone->name = zone_names[idx];
 	zone->zone_pgdat = NODE_DATA(nid);
@@ -7061,14 +7063,12 @@ static int __init cmdline_parse_movablecore(char *p)
 
 void adjust_managed_page_count(struct page *page, long count)
 {
-	spin_lock(&managed_page_count_lock);
-	page_zone(page)->managed_pages += count;
-	totalram_pages += count;
+	atomic_long_add(count, &page_zone(page)->managed_pages);
+	atomic_long_add(count, &totalram_pages);
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
-		totalhigh_pages += count;
+		atomic_long_add(count, &totalhigh_pages);
 #endif
-	spin_unlock(&managed_page_count_lock);
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
@@ -7109,9 +7109,9 @@ unsigned long free_reserved_area(void *start, void *end, int poison, char *s)
 void free_highmem_page(struct page *page)
 {
 	__free_reserved_page(page);
-	totalram_pages++;
-	page_zone(page)->managed_pages++;
-	totalhigh_pages++;
+	atomic_long_inc(&totalram_pages);
+	atomic_long_inc(&page_zone(page)->managed_pages);
+	atomic_long_inc(&totalhigh_pages);
 }
 #endif
 
@@ -7160,10 +7160,10 @@ void __init mem_init_print_info(const char *str)
 		physpages << (PAGE_SHIFT - 10),
 		codesize >> 10, datasize >> 10, rosize >> 10,
 		(init_data_size + init_code_size) >> 10, bss_size >> 10,
-		(physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT - 10),
+		(physpages - atomic_long_read(&totalram_pages) - totalcma_pages) << (PAGE_SHIFT - 10),
 		totalcma_pages << (PAGE_SHIFT - 10),
 #ifdef	CONFIG_HIGHMEM
-		totalhigh_pages << (PAGE_SHIFT - 10),
+		atomic_long_read(&totalhigh_pages) << (PAGE_SHIFT - 10),
 #endif
 		str ? ", " : "", str ? str : "");
 }
@@ -7253,8 +7253,8 @@ static void calculate_totalreserve_pages(void)
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
-			if (max > zone->managed_pages)
-				max = zone->managed_pages;
+			if (max > atomic_long_read(&zone->managed_pages))
+				max = atomic_long_read(&zone->managed_pages);
 
 			pgdat->totalreserve_pages += max;
 
@@ -7278,7 +7278,7 @@ static void setup_per_zone_lowmem_reserve(void)
 	for_each_online_pgdat(pgdat) {
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = pgdat->node_zones + j;
-			unsigned long managed_pages = zone->managed_pages;
+			unsigned long managed_pages = atomic_long_read(&zone->managed_pages);
 
 			zone->lowmem_reserve[j] = 0;
 
@@ -7296,7 +7296,7 @@ static void setup_per_zone_lowmem_reserve(void)
 					lower_zone->lowmem_reserve[j] =
 						managed_pages / sysctl_lowmem_reserve_ratio[idx];
 				}
-				managed_pages += lower_zone->managed_pages;
+				managed_pages += atomic_long_read(&lower_zone->managed_pages);
 			}
 		}
 	}
@@ -7315,14 +7315,14 @@ static void __setup_per_zone_wmarks(void)
 	/* Calculate total number of !ZONE_HIGHMEM pages */
 	for_each_zone(zone) {
 		if (!is_highmem(zone))
-			lowmem_pages += zone->managed_pages;
+			lowmem_pages += atomic_long_read(&zone->managed_pages);
 	}
 
 	for_each_zone(zone) {
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
-		tmp = (u64)pages_min * zone->managed_pages;
+		tmp = (u64)pages_min * atomic_long_read(&zone->managed_pages);
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
 			/*
@@ -7336,7 +7336,8 @@ static void __setup_per_zone_wmarks(void)
 			 */
 			unsigned long min_pages;
 
-			min_pages = zone->managed_pages / 1024;
+			min_pages = atomic_long_read(&zone->managed_pages) /
+									1024;
 			min_pages = clamp(min_pages, SWAP_CLUSTER_MAX, 128UL);
 			zone->watermark[WMARK_MIN] = min_pages;
 		} else {
@@ -7353,7 +7354,7 @@ static void __setup_per_zone_wmarks(void)
 		 * ensure a minimum size on small systems.
 		 */
 		tmp = max_t(u64, tmp >> 2,
-			    mult_frac(zone->managed_pages,
+			    mult_frac(atomic_long_read(&zone->managed_pages),
 				      watermark_scale_factor, 10000));
 
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
@@ -7483,7 +7484,8 @@ static void setup_min_unmapped_ratio(void)
 		pgdat->min_unmapped_pages = 0;
 
 	for_each_zone(zone)
-		zone->zone_pgdat->min_unmapped_pages += (zone->managed_pages *
+		zone->zone_pgdat->min_unmapped_pages +=
+				(atomic_long_read(&zone->managed_pages) *
 				sysctl_min_unmapped_ratio) / 100;
 }
 
@@ -7511,8 +7513,9 @@ static void setup_min_slab_ratio(void)
 		pgdat->min_slab_pages = 0;
 
 	for_each_zone(zone)
-		zone->zone_pgdat->min_slab_pages += (zone->managed_pages *
-				sysctl_min_slab_ratio) / 100;
+		zone->zone_pgdat->min_slab_pages +=
+			(atomic_long_read(&zone->managed_pages) *
+			sysctl_min_slab_ratio) / 100;
 }
 
 int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
diff --git a/mm/shmem.c b/mm/shmem.c
index a6964ba..edd55db 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -109,12 +109,18 @@ struct shmem_falloc {
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
-	return totalram_pages / 2;
+	return atomic_long_read(&totalram_pages) / 2;
 }
 
 static unsigned long shmem_default_max_inodes(void)
 {
-	return min(totalram_pages - totalhigh_pages, totalram_pages / 2);
+	return min((unsigned long)atomic_long_read(&totalram_pages) -
+#ifdef CONFIG_HIGHMEM
+		(unsigned long) atomic_long_read(&totalhigh_pages),
+#else
+		0,
+#endif
+		(unsigned long)atomic_long_read(&totalram_pages) / 2);
 }
 #endif
 
@@ -3274,7 +3280,7 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
 			size = memparse(value,&rest);
 			if (*rest == '%') {
 				size <<= PAGE_SHIFT;
-				size *= totalram_pages;
+				size *= atomic_long_read(&totalram_pages);
 				do_div(size, 100);
 				rest++;
 			}
diff --git a/mm/slab.c b/mm/slab.c
index 2a5654b..70252b0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1248,7 +1248,8 @@ void __init kmem_cache_init(void)
 	 * page orders on machines with more than 32MB of memory if
 	 * not overridden on the command line.
 	 */
-	if (!slab_max_order_set && totalram_pages > (32 << 20) >> PAGE_SHIFT)
+	if (!slab_max_order_set && atomic_long_read(&totalram_pages) >
+						(32 << 20) >> PAGE_SHIFT)
 		slab_max_order = SLAB_MAX_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
diff --git a/mm/swap.c b/mm/swap.c
index aa48371..e85bc4a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1023,7 +1023,8 @@ unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
  */
 void __init swap_setup(void)
 {
-	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
+	unsigned long megs = atomic_long_read(&totalram_pages) >>
+						(20 - PAGE_SHIFT);
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
diff --git a/mm/util.c b/mm/util.c
index 7f1f165..a3ae8ee 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -600,7 +600,7 @@ unsigned long vm_commit_limit(void)
 	if (sysctl_overcommit_kbytes)
 		allowed = sysctl_overcommit_kbytes >> (PAGE_SHIFT - 10);
 	else
-		allowed = ((totalram_pages - hugetlb_total_pages())
+		allowed = ((atomic_long_read(&totalram_pages) - hugetlb_total_pages())
 			   * sysctl_overcommit_ratio / 100);
 	allowed += total_swap_pages;
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 97d4b25..f177af8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1634,7 +1634,7 @@ void *vmap(struct page **pages, unsigned int count,
 
 	might_sleep();
 
-	if (count > totalram_pages)
+	if (count > atomic_long_read(&totalram_pages))
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
@@ -1739,7 +1739,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
+	if (!size || (size >> PAGE_SHIFT) > atomic_long_read(&totalram_pages))
 		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6038ce5..20551e8 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -227,7 +227,7 @@ int calculate_normal_threshold(struct zone *zone)
 	 * 125		1024		10	16-32 GB	9
 	 */
 
-	mem = zone->managed_pages >> (27 - PAGE_SHIFT);
+	mem = atomic_long_read(&zone->managed_pages) >> (27 - PAGE_SHIFT);
 
 	threshold = 2 * fls(num_online_cpus()) * (1 + fls(mem));
 
@@ -1569,7 +1569,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   high_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
-		   zone->managed_pages);
+		   atomic_long_read(&zone->managed_pages));
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
diff --git a/mm/workingset.c b/mm/workingset.c
index b15799d..dcd4e16 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -550,7 +550,7 @@ static int __init workingset_init(void)
 	 * double the initial memory by using totalram_pages as-is.
 	 */
 	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
-	max_order = fls_long(totalram_pages - 1);
+	max_order = fls_long(atomic_long_read(&totalram_pages) - 1);
 	if (max_order > timestamp_bits)
 		bucket_order = max_order - timestamp_bits;
 	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
diff --git a/mm/zswap.c b/mm/zswap.c
index cd91fd9..5d2d7b9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -219,7 +219,7 @@ struct zswap_tree {
 
 static bool zswap_is_full(void)
 {
-	return totalram_pages * zswap_max_pool_percent / 100 <
+	return atomic_long_read(&totalram_pages) * zswap_max_pool_percent / 100 <
 		DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
 }
 
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 875858c..4a92d11 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1154,10 +1154,10 @@ static int __init dccp_init(void)
 	 *
 	 * The methodology is similar to that of the buffer cache.
 	 */
-	if (totalram_pages >= (128 * 1024))
-		goal = totalram_pages >> (21 - PAGE_SHIFT);
+	if (atomic_long_read(&totalram_pages) >= (128 * 1024))
+		goal = atomic_long_read(&totalram_pages) >> (21 - PAGE_SHIFT);
 	else
-		goal = totalram_pages >> (23 - PAGE_SHIFT);
+		goal = atomic_long_read(&totalram_pages) >> (23 - PAGE_SHIFT);
 
 	if (thash_entries)
 		goal = (thash_entries *
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 1c002c0..bb49b0f 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1866,7 +1866,7 @@ void __init dn_route_init(void)
 	dn_route_timer.expires = jiffies + decnet_dst_gc_interval * HZ;
 	add_timer(&dn_route_timer);
 
-	goal = totalram_pages >> (26 - PAGE_SHIFT);
+	goal = atomic_long_read(&totalram_pages) >> (26 - PAGE_SHIFT);
 
 	for(order = 0; (1UL << order) < goal; order++)
 		/* NOTHING */;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 03b51cd..d91bdab 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -1000,7 +1000,7 @@ static int __net_init tcp_net_metrics_init(struct net *net)
 
 	slots = tcpmhash_entries;
 	if (!slots) {
-		if (totalram_pages >= 128 * 1024)
+		if (atomic_long_read(&totalram_pages) >= 128 * 1024)
 			slots = 16 * 1024;
 		else
 			slots = 8 * 1024;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ca1168d..3285df9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2267,11 +2267,11 @@ int nf_conntrack_init_start(void)
 		 * >= 4GB machines have 65536 buckets.
 		 */
 		nf_conntrack_htable_size
-			= (((totalram_pages << PAGE_SHIFT) / 16384)
+			= (((atomic_long_read(&totalram_pages) << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (totalram_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
+		if (atomic_long_read(&totalram_pages) > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
 			nf_conntrack_htable_size = 65536;
-		else if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		else if (atomic_long_read(&totalram_pages) > (1024 * 1024 * 1024 / PAGE_SIZE))
 			nf_conntrack_htable_size = 16384;
 		if (nf_conntrack_htable_size < 32)
 			nf_conntrack_htable_size = 32;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 3e7d259..3c79a0f 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -279,9 +279,9 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	if (cfg->size) {
 		size = cfg->size;
 	} else {
-		size = (totalram_pages << PAGE_SHIFT) / 16384 /
+		size = (atomic_long_read(&totalram_pages) << PAGE_SHIFT) / 16384 /
 		       sizeof(struct hlist_head);
-		if (totalram_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
+		if (atomic_long_read(&totalram_pages) > 1024 * 1024 * 1024 / PAGE_SIZE)
 			size = 8192;
 		if (size < 16)
 			size = 16;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 9b277bd..4ca4def 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1426,10 +1426,10 @@ static __init int sctp_init(void)
 	 * The methodology is similar to that of the tcp hash tables.
 	 * Though not identical.  Start by getting a goal size
 	 */
-	if (totalram_pages >= (128 * 1024))
-		goal = totalram_pages >> (22 - PAGE_SHIFT);
+	if (atomic_long_read(&totalram_pages) >= (128 * 1024))
+		goal = atomic_long_read(&totalram_pages) >> (22 - PAGE_SHIFT);
 	else
-		goal = totalram_pages >> (24 - PAGE_SHIFT);
+		goal = atomic_long_read(&totalram_pages) >> (24 - PAGE_SHIFT);
 
 	/* Then compute the page order for said goal */
 	order = get_order(goal);
diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 16bd187..8bb32ad 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -106,7 +106,7 @@ void ima_add_kexec_buffer(struct kimage *image)
 		kexec_segment_size = ALIGN(ima_get_binary_runtime_size() +
 					   PAGE_SIZE / 2, PAGE_SIZE);
 	if ((kexec_segment_size == ULONG_MAX) ||
-	    ((kexec_segment_size >> PAGE_SHIFT) > totalram_pages / 2)) {
+	    ((kexec_segment_size >> PAGE_SHIFT) > atomic_long_read(&totalram_pages) / 2)) {
 		pr_err("Binary measurement list too large.\n");
 		return;
 	}
-- 
1.9.1
