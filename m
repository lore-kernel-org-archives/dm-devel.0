From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] Implement vmap_pfn
Date: Wed, 27 Sep 2017 11:46:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709271144540.9676@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1709271122410.9676@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709271122410.9676@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Implement vmap_pfn, so that we can remap discontiguous ranges of 
persistent memory into a contiguous address range.

---
 include/linux/vmalloc.h |    2 +
 mm/vmalloc.c            |   88 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 19 deletions(-)

Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h
+++ linux-2.6/include/linux/vmalloc.h
@@ -97,6 +97,8 @@ extern void vfree_atomic(const void *add
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
+extern void *vmap_pfn(pfn_t *pfns, unsigned int count,
+			unsigned long flags, pgprot_t prot);
 extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -31,6 +31,7 @@
 #include <linux/compiler.h>
 #include <linux/llist.h>
 #include <linux/bitops.h>
+#include <linux/pfn_t.h>
 
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
@@ -134,7 +135,7 @@ static void vunmap_page_range(unsigned l
 }
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, pgprot_t prot, struct page **pages, pfn_t *pfns, int *nr)
 {
 	pte_t *pte;
 
@@ -147,20 +148,25 @@ static int vmap_pte_range(pmd_t *pmd, un
 	if (!pte)
 		return -ENOMEM;
 	do {
-		struct page *page = pages[*nr];
-
+		unsigned long pf;
+		if (pages) {
+			struct page *page = pages[*nr];
+			if (WARN_ON(!page))
+				return -ENOMEM;
+			pf = page_to_pfn(page);
+		} else {
+			pf = pfn_t_to_pfn(pfns[*nr]);
+		}
 		if (WARN_ON(!pte_none(*pte)))
 			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
+		set_pte_at(&init_mm, addr, pte, pfn_pte(pf, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	return 0;
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, pgprot_t prot, struct page **pages, pfn_t *pfns, int *nr)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -170,14 +176,14 @@ static int vmap_pmd_range(pud_t *pud, un
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pte_range(pmd, addr, next, prot, pages, nr))
+		if (vmap_pte_range(pmd, addr, next, prot, pages, pfns, nr))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, pgprot_t prot, struct page **pages, pfn_t *pfns, int *nr)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -187,14 +193,14 @@ static int vmap_pud_range(p4d_t *p4d, un
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
+		if (vmap_pmd_range(pud, addr, next, prot, pages, pfns, nr))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, pgprot_t prot, struct page **pages, pfn_t *pfns, int *nr)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -204,7 +210,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pud_range(p4d, addr, next, prot, pages, nr))
+		if (vmap_pud_range(p4d, addr, next, prot, pages, pfns, nr))
 			return -ENOMEM;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
@@ -217,7 +223,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
 static int vmap_page_range_noflush(unsigned long start, unsigned long end,
-				   pgprot_t prot, struct page **pages)
+				   pgprot_t prot, struct page **pages, pfn_t *pfns)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -229,7 +235,7 @@ static int vmap_page_range_noflush(unsig
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		err = vmap_p4d_range(pgd, addr, next, prot, pages, &nr);
+		err = vmap_p4d_range(pgd, addr, next, prot, pages, pfns, &nr);
 		if (err)
 			return err;
 	} while (pgd++, addr = next, addr != end);
@@ -238,11 +244,11 @@ static int vmap_page_range_noflush(unsig
 }
 
 static int vmap_page_range(unsigned long start, unsigned long end,
-			   pgprot_t prot, struct page **pages)
+			   pgprot_t prot, struct page **pages, pfn_t *pfns)
 {
 	int ret;
 
-	ret = vmap_page_range_noflush(start, end, prot, pages);
+	ret = vmap_page_range_noflush(start, end, prot, pages, pfns);
 	flush_cache_vmap(start, end);
 	return ret;
 }
@@ -1193,7 +1199,7 @@ void *vm_map_ram(struct page **pages, un
 		addr = va->va_start;
 		mem = (void *)addr;
 	}
-	if (vmap_page_range(addr, addr + size, prot, pages) < 0) {
+	if (vmap_page_range(addr, addr + size, prot, pages, NULL) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
@@ -1308,7 +1314,7 @@ void __init vmalloc_init(void)
 int map_kernel_range_noflush(unsigned long addr, unsigned long size,
 			     pgprot_t prot, struct page **pages)
 {
-	return vmap_page_range_noflush(addr, addr + size, prot, pages);
+	return vmap_page_range_noflush(addr, addr + size, prot, pages, NULL);
 }
 
 /**
@@ -1349,13 +1355,24 @@ void unmap_kernel_range(unsigned long ad
 }
 EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
+static int map_vm_area_pfn(struct vm_struct *area, pgprot_t prot, pfn_t *pfns)
+{
+	unsigned long addr = (unsigned long)area->addr;
+	unsigned long end = addr + get_vm_area_size(area);
+	int err;
+
+	err = vmap_page_range(addr, end, prot, NULL, pfns);
+
+	return err > 0 ? 0 : err;
+}
+
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page **pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
-	err = vmap_page_range(addr, end, prot, pages);
+	err = vmap_page_range(addr, end, prot, pages, NULL);
 
 	return err > 0 ? 0 : err;
 }
@@ -1662,6 +1679,39 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
+/**
+ *	vmap_pfn  -  map an array of pages into virtually contiguous space
+ *	@pfns:		array of page frame numbers
+ *	@count:		number of pages to map
+ *	@flags:		vm_area->flags
+ *	@prot:		page protection for the mapping
+ *
+ *	Maps @count pages from @pages into contiguous kernel virtual
+ *	space.
+ */
+void *vmap_pfn(pfn_t *pfns, unsigned int count, unsigned long flags, pgprot_t prot)
+{
+	struct vm_struct *area;
+	unsigned long size;		/* In bytes */
+
+	might_sleep();
+
+	size = (unsigned long)count << PAGE_SHIFT;
+	if (unlikely((size >> PAGE_SHIFT) != count))
+		return NULL;
+	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	if (!area)
+		return NULL;
+
+	if (map_vm_area_pfn(area, prot, pfns)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+
+	return area->addr;
+}
+EXPORT_SYMBOL(vmap_pfn);
+
 static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller);
