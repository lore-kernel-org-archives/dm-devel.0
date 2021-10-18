Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D9AC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 05:56:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02AE160F48
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 05:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 02AE160F48
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300--DFB3DnaMKm3sMVfYe7IDQ-1; Mon, 18 Oct 2021 01:56:23 -0400
X-MC-Unique: -DFB3DnaMKm3sMVfYe7IDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE4669720;
	Mon, 18 Oct 2021 05:56:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AE8E18174;
	Mon, 18 Oct 2021 05:56:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0EAE1832DD4;
	Mon, 18 Oct 2021 05:56:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I5uHtY007915 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 01:56:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8929640D1B9D; Mon, 18 Oct 2021 05:56:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8588340C1257
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:56:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E439185A7A4
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:56:17 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399--hZ1qqK2OCqMza58pRkydQ-1; Mon, 18 Oct 2021 01:56:15 -0400
X-MC-Unique: -hZ1qqK2OCqMza58pRkydQ-1
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcKSg-00E3P7-Px; Mon, 18 Oct 2021 04:41:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Date: Mon, 18 Oct 2021 06:40:51 +0200
Message-Id: <20211018044054.1779424-9-hch@lst.de>
In-Reply-To: <20211018044054.1779424-1-hch@lst.de>
References: <20211018044054.1779424-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
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

Add a helper to perform the entire remapping for DAX accesses.  This
helper open codes bdev_dax_pgoff given that the alignment checks have
already been done by the submitting file system and don't need to be
repeated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-linear.c | 49 +++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 32fbab11bf90c..bf03f73fd0f36 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -164,63 +164,44 @@ static int linear_iterate_devices(struct dm_target *ti,
 }
 
 #if IS_ENABLED(CONFIG_FS_DAX)
+static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
+{
+	struct linear_c *lc = ti->private;
+	sector_t sector = linear_map_sector(ti, *pgoff << PAGE_SECTORS_SHIFT);
+
+	*pgoff = (get_start_sect(lc->dev->bdev) + sector) >> PAGE_SECTORS_SHIFT;
+	return lc->dev->dax_dev;
+}
+
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	long ret;
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
+
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
 
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
 
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 				      size_t nr_pages)
 {
-	int ret;
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
-	if (ret)
-		return ret;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
+
 	return dax_zero_page_range(dax_dev, pgoff, nr_pages);
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

