Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED21C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:02:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7109961057
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7109961057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-w3s3YIuIPxi0YDHXiEZa-A-1; Tue, 09 Nov 2021 04:01:44 -0500
X-MC-Unique: w3s3YIuIPxi0YDHXiEZa-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17DC01013DC9;
	Tue,  9 Nov 2021 09:01:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EED915E275;
	Tue,  9 Nov 2021 09:01:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA330181A1CF;
	Tue,  9 Nov 2021 09:01:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A99052t017670 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 04:00:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A43D52166B26; Tue,  9 Nov 2021 09:00:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F0A02166B25
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A7BA181B7A2
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:00 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-138-0WZt74eeOBmsnbwnO5XFiA-1; Tue, 09 Nov 2021 03:59:58 -0500
X-MC-Unique: 0WZt74eeOBmsnbwnO5XFiA-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZW-000s49-Ix; Tue, 09 Nov 2021 08:33:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:54 +0100
Message-Id: <20211109083309.584081-15-hch@lst.de>
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 14/29] fsdax: simplify the pgoff calculation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace the two steps of dax_iomap_sector and bdev_dax_pgoff with a
single dax_iomap_pgoff helper that avoids lots of cumbersome sector
conversions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c | 14 --------------
 fs/dax.c            | 35 ++++++++++-------------------------
 include/linux/dax.h |  1 -
 3 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 803942586d1b6..c0910687fbcb2 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -67,20 +67,6 @@ void dax_remove_host(struct gendisk *disk)
 }
 EXPORT_SYMBOL_GPL(dax_remove_host);
 
-int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
-		pgoff_t *pgoff)
-{
-	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
-	phys_addr_t phys_off = (start_sect + sector) * 512;
-
-	if (pgoff)
-		*pgoff = PHYS_PFN(phys_off);
-	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
-		return -EINVAL;
-	return 0;
-}
-EXPORT_SYMBOL(bdev_dax_pgoff);
-
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
  * @bdev: block device to find a dax_device for
diff --git a/fs/dax.c b/fs/dax.c
index e51b4129d1b65..5364549d67a48 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -709,23 +709,22 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_entry(mapping, index, false);
 }
 
-static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
+static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
 {
-	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
+	phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
+
+	if (iomap->bdev)
+		paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
+	return PHYS_PFN(paddr);
 }
 
 static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
 {
-	sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
+	pgoff_t pgoff = dax_iomap_pgoff(&iter->iomap, iter->pos);
 	void *vto, *kaddr;
-	pgoff_t pgoff;
 	long rc;
 	int id;
 
-	rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
-	if (rc)
-		return rc;
-
 	id = dax_read_lock();
 	rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 	if (rc < 0) {
@@ -1013,14 +1012,10 @@ EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
 			 pfn_t *pfnp)
 {
-	const sector_t sector = dax_iomap_sector(iomap, pos);
-	pgoff_t pgoff;
+	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 	int id, rc;
 	long length;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
-	if (rc)
-		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
 				   NULL, pfnp);
@@ -1129,7 +1124,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
 {
 	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
-	pgoff_t pgoff;
+	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 	long rc, id;
 	void *kaddr;
 	bool page_aligned = false;
@@ -1140,10 +1135,6 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
 	    (size == PAGE_SIZE))
 		page_aligned = true;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
-	if (rc)
-		return rc;
-
 	id = dax_read_lock();
 
 	if (page_aligned)
@@ -1169,7 +1160,6 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 	const struct iomap *iomap = &iomi->iomap;
 	loff_t length = iomap_length(iomi);
 	loff_t pos = iomi->pos;
-	struct block_device *bdev = iomap->bdev;
 	struct dax_device *dax_dev = iomap->dax_dev;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
@@ -1203,9 +1193,8 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 	while (pos < end) {
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		const size_t size = ALIGN(length + offset, PAGE_SIZE);
-		const sector_t sector = dax_iomap_sector(iomap, pos);
+		pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 		ssize_t map_len;
-		pgoff_t pgoff;
 		void *kaddr;
 
 		if (fatal_signal_pending(current)) {
@@ -1213,10 +1202,6 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 			break;
 		}
 
-		ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
-		if (ret)
-			break;
-
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
 				&kaddr, NULL);
 		if (map_len < 0) {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 439c3c70e347b..324363b798ecd 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -107,7 +107,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 #endif
 
 struct writeback_control;
-int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
 int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
 void dax_remove_host(struct gendisk *disk);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

