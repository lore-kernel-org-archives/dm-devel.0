From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Tue, 6 Oct 2015 12:13:56 +0200
Message-ID: <20151006101356.GE12506@8bytes.org>
References: <55B7D054.4070308@maya.org>
 <20150728192908.GA25264@redhat.com>
 <55BCD5A7.2080708@maya.org>
 <55BE1D5E.6020709@maya.org>
 <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
 <55FE5740.2060701@maya.org>
 <20150929152100.GL3036@8bytes.org>
 <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
 <20150929162042.GR3036@8bytes.org>
 <560BF73F.8000008@maya.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560BF73F.8000008@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 30, 2015 at 04:52:47PM +0200, Andreas Hartmann wrote:
> > Alternativly someone who can reproduce it should trace the calls to
> > __map_single and __unmap_single in the AMD IOMMU driver to find out
> > whether the addresses which the faults happen on are really mapped, or
> > at least requested from the AMD IOMMU driver.
> 
> How can I trace it?

Please apply the attached debug patch on-top of Linux v4.3-rc3 and boot
the machine. After boot you run (as root):


	# cat /sys/kernel/debug/tracing/trace_pipe > trace-data

Please run this in a seperate shell an keep it running.

Then trigger the problem while the above command is running. When you
triggered it, please send me the (compressed) trace-data file, full
dmesg and output of lspci on the box.

Please let me know if you have further questions.


Thanks,

	Joerg


--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iommu-debug.patch"

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f82060e7..0002e79 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2465,6 +2465,7 @@ static dma_addr_t __map_single(struct device *dev,
 {
 	dma_addr_t offset = paddr & ~PAGE_MASK;
 	dma_addr_t address, start, ret;
+	phys_addr_t old_paddr = paddr;
 	unsigned int pages;
 	unsigned long align_mask = 0;
 	int i;
@@ -2521,6 +2522,8 @@ retry:
 		domain_flush_pages(&dma_dom->domain, address, size);
 
 out:
+	trace_printk("%s: mapped %llx paddr %llx size %zu\n",
+			dev_name(dev), address, old_paddr, size);
 	return address;
 
 out_unmap:
@@ -2532,6 +2535,9 @@ out_unmap:
 
 	dma_ops_free_addresses(dma_dom, address, pages);
 
+	trace_printk("%s: return DMA_ERROR_CODE paddr %llx size %zu\n",
+			dev_name(dev), old_paddr, size);
+
 	return DMA_ERROR_CODE;
 }
 
@@ -2628,6 +2634,8 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
+	trace_printk("%s: unmap dma_addr %llx size %zu\n",
+			dev_name(dev), dma_addr, size);
 	__unmap_single(domain->priv, dma_addr, size, dir);
 
 	domain_flush_complete(domain);
@@ -2683,9 +2691,13 @@ out:
 	return mapped_elems;
 unmap:
 	for_each_sg(sglist, s, mapped_elems, i) {
-		if (s->dma_address)
+		if (s->dma_address) {
+			trace_printk("%s: unmap dma_addr %llx size %u\n",
+					dev_name(dev), s->dma_address,
+					s->dma_length);
 			__unmap_single(domain->priv, s->dma_address,
 				       s->dma_length, dir);
+		}
 		s->dma_address = s->dma_length = 0;
 	}
 
@@ -2716,6 +2728,9 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
+	trace_printk("%s: unmap dma_addr %llx size %u\n",
+			dev_name(dev), s->dma_address, s->dma_length);
+
 		__unmap_single(domain->priv, s->dma_address,
 			       s->dma_length, dir);
 		s->dma_address = s->dma_length = 0;
@@ -2813,6 +2828,9 @@ static void free_coherent(struct device *dev, size_t size,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
+	trace_printk("%s: unmap dma_addr %llx size %zu\n",
+			dev_name(dev), dma_addr, size);
+
 	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
 	domain_flush_complete(domain);

--liOOAslEiF7prFVr--
