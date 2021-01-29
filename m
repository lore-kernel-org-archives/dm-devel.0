Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D86C433E6
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D40164DFD
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D40164DFD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-fqy2GyKaOxKG_QMByElH7w-1; Fri, 29 Jan 2021 04:39:33 -0500
X-MC-Unique: fqy2GyKaOxKG_QMByElH7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BD99107ACF8;
	Fri, 29 Jan 2021 09:39:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C83210023BA;
	Fri, 29 Jan 2021 09:39:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DA475002F;
	Fri, 29 Jan 2021 09:39:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10T6TPei015839 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 01:29:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F54810439BD; Fri, 29 Jan 2021 06:29:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B8241043A03
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 06:29:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9F4F8001B8
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 06:29:24 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-475-D8O9KgxIP9u2THTs5T6b6Q-2;
	Fri, 29 Jan 2021 01:29:20 -0500
X-MC-Unique: D8O9KgxIP9u2THTs5T6b6Q-2
X-IronPort-AV: E=Sophos;i="5.79,384,1602518400"; d="scan'208";a="103973626"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 29 Jan 2021 14:28:11 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id C7B4A4CE6016;
	Fri, 29 Jan 2021 14:28:06 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 29 Jan 2021 14:28:06 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 29 Jan 2021 14:28:07 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Fri, 29 Jan 2021 14:27:51 +0800
Message-ID: <20210129062757.1594130-5-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210129062757.1594130-1-ruansy.fnst@cn.fujitsu.com>
References: <20210129062757.1594130-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: C7B4A4CE6016.AF008
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:25 -0500
Cc: qi.fuli@fujitsu.com, snitzer@redhat.com, darrick.wong@oracle.com,
	rgoldwyn@suse.de, david@fromorbit.com, y-goto@fujitsu.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH RESEND v2 04/10] mm,
	fsdax: Refactor memory-failure handler for dax mapping
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The current memory_failure_dev_pagemap() can only handle single-mapped
dax page for fsdax mode.  The dax page could be mapped by multiple files
and offsets if we let reflink feature & fsdax mode work together.  So,
we refactor current implementation to support handle memory failure on
each file and offset.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/dax.c            | 21 ++++++++++
 include/linux/dax.h |  1 +
 include/linux/mm.h  |  9 +++++
 mm/memory-failure.c | 98 ++++++++++++++++++++++++++++++++++-----------
 4 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 26d5dcd2d69e..c64c3a0e76a6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -378,6 +378,27 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
+/*
+ * dax_load_pfn - Load pfn of the DAX entry corresponding to a page
+ * @mapping: The file whose entry we want to load
+ * @index:   The offset where the DAX entry located in
+ *
+ * Return:   pfn of the DAX entry
+ */
+unsigned long dax_load_pfn(struct address_space *mapping, unsigned long index)
+{
+	XA_STATE(xas, &mapping->i_pages, index);
+	void *entry;
+	unsigned long pfn;
+
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	pfn = dax_to_pfn(entry);
+	xas_unlock_irq(&xas);
+
+	return pfn;
+}
+
 /*
  * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
  * @page: The page whose entry we want to lock
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b52f084aa643..89e56ceeffc7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -150,6 +150,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
+unsigned long dax_load_pfn(struct address_space *mapping, unsigned long index);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 #else
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecdf8a8cd6ae..ab52bc633d84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1157,6 +1157,14 @@ static inline bool is_device_private_page(const struct page *page)
 		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
+static inline bool is_device_fsdax_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		IS_ENABLED(CONFIG_FS_DAX) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_FS_DAX;
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
@@ -3045,6 +3053,7 @@ enum mf_flags {
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
 };
+extern int mf_dax_mapping_kill_procs(struct address_space *mapping, pgoff_t index, int flags);
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e9481632fcd1..158fe0c8e602 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -56,6 +56,7 @@
 #include <linux/kfifo.h>
 #include <linux/ratelimit.h>
 #include <linux/page-isolation.h>
+#include <linux/dax.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -120,6 +121,13 @@ static int hwpoison_filter_dev(struct page *p)
 	if (PageSlab(p))
 		return -EINVAL;
 
+	if (pfn_valid(page_to_pfn(p))) {
+		if (is_device_fsdax_page(p))
+			return 0;
+		else
+			return -EINVAL;
+	}
+
 	mapping = page_mapping(p);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
@@ -286,10 +294,9 @@ void shake_page(struct page *p, int access)
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
-static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
+static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
+					       unsigned long address)
 {
-	unsigned long address = vma_address(page, vma);
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -329,9 +336,8 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  */
-static void add_to_kill(struct task_struct *tsk, struct page *p,
-		       struct vm_area_struct *vma,
-		       struct list_head *to_kill)
+static void add_to_kill(struct task_struct *tsk, struct page *p, pgoff_t pgoff,
+			struct vm_area_struct *vma, struct list_head *to_kill)
 {
 	struct to_kill *tk;
 
@@ -342,9 +348,12 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 	}
 
 	tk->addr = page_address_in_vma(p, vma);
-	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
-	else
+	if (is_zone_device_page(p)) {
+		if (is_device_fsdax_page(p))
+			tk->addr = vma->vm_start +
+					((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
+	} else
 		tk->size_shift = page_shift(compound_head(p));
 
 	/*
@@ -492,7 +501,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -502,24 +511,19 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 /*
  * Collect processes when the error hit a file mapped page.
  */
-static void collect_procs_file(struct page *page, struct list_head *to_kill,
-				int force_early)
+static void collect_procs_file(struct page *page, struct address_space *mapping,
+		pgoff_t pgoff, struct list_head *to_kill, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
-	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
-
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
-				      pgoff) {
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
@@ -528,7 +532,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 			 * to be informed of all such data corruptions.
 			 */
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, pgoff, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -547,7 +551,8 @@ static void collect_procs(struct page *page, struct list_head *tokill,
 	if (PageAnon(page))
 		collect_procs_anon(page, tokill, force_early);
 	else
-		collect_procs_file(page, tokill, force_early);
+		collect_procs_file(page, page_mapping(page), page_to_pgoff(page),
+				   tokill, force_early);
 }
 
 static const char *action_name[] = {
@@ -1214,6 +1219,50 @@ static int try_to_split_thp_page(struct page *page, const char *msg)
 	return 0;
 }
 
+int mf_dax_mapping_kill_procs(struct address_space *mapping, pgoff_t index, int flags)
+{
+	const bool unmap_success = true;
+	unsigned long pfn, size = 0;
+	struct to_kill *tk;
+	LIST_HEAD(to_kill);
+	int rc = -EBUSY;
+	loff_t start;
+
+	/* load the pfn of the dax mapping file */
+	pfn = dax_load_pfn(mapping, index);
+	if (!pfn)
+		return rc;
+	/*
+	 * Unlike System-RAM there is no possibility to swap in a
+	 * different physical page at a given virtual address, so all
+	 * userspace consumption of ZONE_DEVICE memory necessitates
+	 * SIGBUS (i.e. MF_MUST_KILL)
+	 */
+	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+	collect_procs_file(pfn_to_page(pfn), mapping, index, &to_kill,
+			   flags & MF_ACTION_REQUIRED);
+
+	list_for_each_entry(tk, &to_kill, nd)
+		if (tk->size_shift)
+			size = max(size, 1UL << tk->size_shift);
+	if (size) {
+		/*
+		 * Unmap the largest mapping to avoid breaking up
+		 * device-dax mappings which are constant size. The
+		 * actual size of the mapping being torn down is
+		 * communicated in siginfo, see kill_proc()
+		 */
+		start = (index << PAGE_SHIFT) & ~(size - 1);
+		unmap_mapping_range(mapping, start, start + size, 0);
+	}
+
+	kill_procs(&to_kill, flags & MF_MUST_KILL, !unmap_success,
+		   pfn, flags);
+	rc = 0;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(mf_dax_mapping_kill_procs);
+
 static int memory_failure_hugetlb(unsigned long pfn, int flags)
 {
 	struct page *p = pfn_to_page(pfn);
@@ -1297,7 +1346,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	const bool unmap_success = true;
 	unsigned long size = 0;
 	struct to_kill *tk;
-	LIST_HEAD(tokill);
+	LIST_HEAD(to_kill);
 	int rc = -EBUSY;
 	loff_t start;
 	dax_entry_t cookie;
@@ -1345,9 +1394,10 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs_file(page, page->mapping, page->index, &to_kill,
+			   flags & MF_ACTION_REQUIRED);
 
-	list_for_each_entry(tk, &tokill, nd)
+	list_for_each_entry(tk, &to_kill, nd)
 		if (tk->size_shift)
 			size = max(size, 1UL << tk->size_shift);
 	if (size) {
@@ -1360,7 +1410,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, start + size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
+	kill_procs(&to_kill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
-- 
2.30.0



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

