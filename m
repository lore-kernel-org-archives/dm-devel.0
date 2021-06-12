Return-Path: <SRS0=rkDd=LI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FEEC48BE6
	for <dm-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:10:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DC59613BF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DC59613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-kRUPVFKYNsKscuddDQ1xYA-1; Mon, 14 Jun 2021 03:10:03 -0400
X-MC-Unique: kRUPVFKYNsKscuddDQ1xYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3E2E100B3AC;
	Mon, 14 Jun 2021 07:09:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A89D5C238;
	Mon, 14 Jun 2021 07:09:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5F313808;
	Mon, 14 Jun 2021 07:09:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15C47rhO014370 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Jun 2021 00:07:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 007AE200B67C; Sat, 12 Jun 2021 04:07:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFFAA200B679
	for <dm-devel@redhat.com>; Sat, 12 Jun 2021 04:07:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 913BD811E9C
	for <dm-devel@redhat.com>; Sat, 12 Jun 2021 04:07:49 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-506-dJElTNx9MQqQ7vAagoynzw-1; Sat, 12 Jun 2021 00:07:47 -0400
X-MC-Unique: dJElTNx9MQqQ7vAagoynzw-1
IronPort-SDR: c6v7k4aKKLNkBIvgkiNrZL122PC5yrwH41ev9jWD96CBrxjkJs5VoWgzaDvFtaTes0WDMP3wJP
	OoPV5I7FW5Pw==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="192956372"
X-IronPort-AV: E=Sophos;i="5.83,268,1616482800"; d="scan'208";a="192956372"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
	by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	11 Jun 2021 21:07:45 -0700
IronPort-SDR: w9Z6J/r97mO9lFntwTdvcFJR/T8FN7zIqOB14ZTprURZotbf+h18t1ZDpiThnaK4JmnMY6+zNE
	Gq1E7F9H+CgA==
X-IronPort-AV: E=Sophos;i="5.83,268,1616482800"; d="scan'208";a="483489410"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga001-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 21:07:44 -0700
Date: Fri, 11 Jun 2021 21:07:43 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210612040743.GG1600546@iweiny-DESK2.sc.intel.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-10-hch@lst.de>
	<20210609014822.GT3697498@iweiny-DESK2.sc.intel.com>
	<20210611065338.GA31210@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210611065338.GA31210@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Jun 2021 03:09:48 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>, linux-sh@vger.kernel.org,
	Geoff Levand <geoff@infradead.org>,
	Tero Kristo <t-kristo@ti.com>, linux-mmc@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
	linux-csky@vger.kernel.org, linux-scsi@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [dm-devel] [PATCH 09/16] ps3disk: use memcpy_{from,to}_bvec
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 11, 2021 at 08:53:38AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 08, 2021 at 06:48:22PM -0700, Ira Weiny wrote:
> > I'm still not 100% sure that these flushes are needed but the are not no-ops on
> > every arch.  Would it be best to preserve them after the memcpy_to/from_bvec()?
> > 
> > Same thing in patch 11 and 14.
> 
> To me it seems kunmap_local should basically always call the equivalent
> of flush_kernel_dcache_page.  parisc does this through
> kunmap_flush_on_unmap, but none of the other architectures with VIVT
> caches or other coherency issues does.
> 
> Does anyone have a history or other insights here?

I went digging into the current callers of flush_kernel_dcache_page() other
than this one.  To see if adding kunmap_flush_on_unmap() to the other arch's
would cause any problems.

In particular this call site stood out because it is not always called?!?!?!?

void sg_miter_stop(struct sg_mapping_iter *miter)
{
...
                if ((miter->__flags & SG_MITER_TO_SG) &&
                    !PageSlab(miter->page))
                        flush_kernel_dcache_page(miter->page);
...
}

Looking at 

3d77b50c5874 lib/scatterlist.c: don't flush_kernel_dcache_page on slab page[1]

It seems the restrictions they are quoting for the page are completely out of
date.  I don't see any current way for a VM_BUG_ON() to be triggered.  So is
this code really necessary?

More recently this was added:

7e34e0bbc644 crypto: omap-crypto - fix userspace copied buffer access

I'm CC'ing Tero and Herbert to see why they added the SLAB check.


Then we have interesting comments like this...

...
                /* This can go away once MIPS implements
		 * flush_kernel_dcache_page */
		flush_dcache_page(miter->page);
...


And some users optimizing.

...
		/* discard mappings */
		if (direction == DMA_FROM_DEVICE)
			flush_kernel_dcache_page(sg_page(sg));  
...

The uses in fs/exec.c are the most straight forward and can simply rely on the
kunmap() code to replace the call.

In conclusion I don't see a lot of reason to not define kunmap_flush_on_unmap()
on arm, csky, mips, nds32, and sh...  Then remove all the
flush_kernel_dcache_page() call sites and the documentation...

Something like [2] below...  Completely untested of course...

Ira


[1] commit 3d77b50c5874b7e923be946ba793644f82336b75
Author: Ming Lei <ming.lei@canonical.com>
Date:   Thu Oct 31 16:34:17 2013 -0700

    lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
    
    Commit b1adaf65ba03 ("[SCSI] block: add sg buffer copy helper
    functions") introduces two sg buffer copy helpers, and calls
    flush_kernel_dcache_page() on pages in SG list after these pages are
    written to.
    
    Unfortunately, the commit may introduce a potential bug:
    
     - Before sending some SCSI commands, kmalloc() buffer may be passed to
       block layper, so flush_kernel_dcache_page() can see a slab page
       finally
    
     - According to cachetlb.txt, flush_kernel_dcache_page() is only called
       on "a user page", which surely can't be a slab page.
    
     - ARCH's implementation of flush_kernel_dcache_page() may use page
       mapping information to do optimization so page_mapping() will see the
       slab page, then VM_BUG_ON() is triggered.
    
    Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
    and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
    before calling flush_kernel_dcache_page().


[2]


>From 70b537c31d16c2a5e4e92c35895e8c59303bcbef Mon Sep 17 00:00:00 2001
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 11 Jun 2021 18:24:27 -0700
Subject: [PATCH] COMPLETELY UNTESTED: highmem: Remove direct calls to flush_kernel_dcache_page

When to call flush_kernel_dcache_page() is confusing and inconsistent.  For
architectures which may need to do something the core kmap code should be
leveraged to handle this when direct kernel access is needed.

Like parisc define kunmap_flush_on_unmap() to be called when pages are
unmapped on arm, csky, mpis, nds32, and sh.

Remove all direct calls to flush_kernel_dcache_page() and let the
kunmap() code do this for the users.


Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-csky@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/core-api/cachetlb.rst  | 13 -------------
 arch/arm/include/asm/cacheflush.h    |  6 ++++++
 arch/csky/abiv1/inc/abi/cacheflush.h |  6 ++++++
 arch/mips/include/asm/cacheflush.h   |  6 ++++++
 arch/nds32/include/asm/cacheflush.h  |  6 ++++++
 arch/sh/include/asm/cacheflush.h     |  6 ++++++
 drivers/crypto/omap-crypto.c         |  3 ---
 drivers/mmc/host/mmc_spi.c           |  3 ---
 drivers/scsi/aacraid/aachba.c        |  1 -
 fs/exec.c                            |  3 ---
 include/linux/highmem.h              |  3 ---
 lib/scatterlist.c                    |  4 ----
 12 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/Documentation/core-api/cachetlb.rst b/Documentation/core-api/cachetlb.rst
index fe4290e26729..5c39de30e91f 100644
--- a/Documentation/core-api/cachetlb.rst
+++ b/Documentation/core-api/cachetlb.rst
@@ -351,19 +351,6 @@ maps this page at its virtual address.
 	architectures).  For incoherent architectures, it should flush
 	the cache of the page at vmaddr.
 
-  ``void flush_kernel_dcache_page(struct page *page)``
-
-	When the kernel needs to modify a user page is has obtained
-	with kmap, it calls this function after all modifications are
-	complete (but before kunmapping it) to bring the underlying
-	page up to date.  It is assumed here that the user has no
-	incoherent cached copies (i.e. the original page was obtained
-	from a mechanism like get_user_pages()).  The default
-	implementation is a nop and should remain so on all coherent
-	architectures.  On incoherent architectures, this should flush
-	the kernel cache for page (using page_address(page)).
-
-
   ``void flush_icache_range(unsigned long start, unsigned long end)``
 
   	When the kernel stores into addresses that it will execute
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 2e24e765e6d3..1b7cb0af707f 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -315,6 +315,12 @@ static inline void flush_anon_page(struct vm_area_struct *vma,
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
 extern void flush_kernel_dcache_page(struct page *);
 
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
+{
+	flush_kernel_dcache_page_addr(addr);
+}
+
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
 
diff --git a/arch/csky/abiv1/inc/abi/cacheflush.h b/arch/csky/abiv1/inc/abi/cacheflush.h
index 6cab7afae962..e1ff554850f8 100644
--- a/arch/csky/abiv1/inc/abi/cacheflush.h
+++ b/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -17,6 +17,12 @@ extern void flush_dcache_page(struct page *);
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
 extern void flush_kernel_dcache_page(struct page *);
 
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
+{
+	flush_kernel_dcache_page_addr(addr);
+}
+
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
 
diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index d687b40b9fbb..c3043b600008 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -132,6 +132,12 @@ static inline void flush_kernel_dcache_page(struct page *page)
 	flush_dcache_page(page);
 }
 
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
+{
+	flush_kernel_dcache_page_addr(addr);
+}
+
 /*
  * For now flush_kernel_vmap_range and invalidate_kernel_vmap_range both do a
  * cache writeback and invalidate operation.
diff --git a/arch/nds32/include/asm/cacheflush.h b/arch/nds32/include/asm/cacheflush.h
index 7d6824f7c0e8..bae980846e2a 100644
--- a/arch/nds32/include/asm/cacheflush.h
+++ b/arch/nds32/include/asm/cacheflush.h
@@ -43,6 +43,12 @@ void invalidate_kernel_vmap_range(void *addr, int size);
 #define flush_dcache_mmap_lock(mapping)   xa_lock_irq(&(mapping)->i_pages)
 #define flush_dcache_mmap_unlock(mapping) xa_unlock_irq(&(mapping)->i_pages)
 
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
+{
+	flush_kernel_dcache_page_addr(addr);
+}
+
 #else
 void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 	                     unsigned long addr, int len);
diff --git a/arch/sh/include/asm/cacheflush.h b/arch/sh/include/asm/cacheflush.h
index 4486a865ff62..2e23a8d71aa7 100644
--- a/arch/sh/include/asm/cacheflush.h
+++ b/arch/sh/include/asm/cacheflush.h
@@ -78,6 +78,12 @@ static inline void flush_kernel_dcache_page(struct page *page)
 	flush_dcache_page(page);
 }
 
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
+{
+	flush_kernel_dcache_page_addr(addr);
+}
+
 extern void copy_to_user_page(struct vm_area_struct *vma,
 	struct page *page, unsigned long vaddr, void *dst, const void *src,
 	unsigned long len);
diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
index 94b2dba90f0d..cbc5a4151c3c 100644
--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -183,9 +183,6 @@ static void omap_crypto_copy_data(struct scatterlist *src,
 
 		memcpy(dstb, srcb, amt);
 
-		if (!PageSlab(sg_page(dst)))
-			flush_kernel_dcache_page(sg_page(dst));
-
 		kunmap_atomic(srcb);
 		kunmap_atomic(dstb);
 
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 9776a03a10f5..e1aafbc6a0a1 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -947,9 +947,6 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 				break;
 		}
 
-		/* discard mappings */
-		if (direction == DMA_FROM_DEVICE)
-			flush_kernel_dcache_page(sg_page(sg));
 		kunmap(sg_page(sg));
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f1f62b5da8b7..8897d4ad78c6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -25,7 +25,6 @@
 #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <linux/uaccess.h>
-#include <linux/highmem.h> /* For flush_kernel_dcache_page */
 #include <linux/module.h>
 
 #include <asm/unaligned.h>
diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..da9faa2da36b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -577,7 +577,6 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 				}
 
 				if (kmapped_page) {
-					flush_kernel_dcache_page(kmapped_page);
 					kunmap(kmapped_page);
 					put_arg_page(kmapped_page);
 				}
@@ -595,7 +594,6 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 	ret = 0;
 out:
 	if (kmapped_page) {
-		flush_kernel_dcache_page(kmapped_page);
 		kunmap(kmapped_page);
 		put_arg_page(kmapped_page);
 	}
@@ -637,7 +635,6 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 		kaddr = kmap_atomic(page);
 		flush_arg_page(bprm, pos & PAGE_MASK, page);
 		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
-		flush_kernel_dcache_page(page);
 		kunmap_atomic(kaddr);
 		put_arg_page(page);
 	}
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 832b49b50c7b..7ef83bf52a6c 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -131,9 +131,6 @@ static inline void flush_anon_page(struct vm_area_struct *vma, struct page *page
 #endif
 
 #ifndef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-}
 static inline void flush_kernel_vmap_range(void *vaddr, int size)
 {
 }
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a59778946404..579b323a8042 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -887,10 +887,6 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 		miter->__offset += miter->consumed;
 		miter->__remaining -= miter->consumed;
 
-		if ((miter->__flags & SG_MITER_TO_SG) &&
-		    !PageSlab(miter->page))
-			flush_kernel_dcache_page(miter->page);
-
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON_ONCE(preemptible());
 			kunmap_atomic(miter->addr);
-- 
2.28.0.rc0.12.gb6a658bd00c9

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

