Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADE3C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E37761057
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9E37761057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Q-6QzqdfM_e_wmbXGTpF7Q-1; Tue, 09 Nov 2021 04:00:20 -0500
X-MC-Unique: Q-6QzqdfM_e_wmbXGTpF7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57AB69F933;
	Tue,  9 Nov 2021 09:00:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 523F577C15;
	Tue,  9 Nov 2021 09:00:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 260D11832DD4;
	Tue,  9 Nov 2021 09:00:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A98xKM8017356 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 03:59:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E1A862024CAE; Tue,  9 Nov 2021 08:59:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCEAA2026D69
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF51585A5BC
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:16 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-591--689IHQlPTC_nfnUPP3ghw-1; Tue, 09 Nov 2021 03:59:13 -0500
X-MC-Unique: -689IHQlPTC_nfnUPP3ghw-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZP-000s1P-HH; Tue, 09 Nov 2021 08:33:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:50 +0100
Message-Id: <20211109083309.584081-11-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 10/29] dm-log-writes: add a log_writes_dax_pgoff
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-log-writes.c | 42 +++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 524bc536922eb..df3cd78223fb2 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -949,17 +949,21 @@ static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
 	return 0;
 }
 
+static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
+		pgoff_t *pgoff)
+{
+	struct log_writes_c *lc = ti->private;
+
+	*pgoff += (get_start_sect(lc->dev->bdev) >> PAGE_SECTORS_SHIFT);
+	return lc->dev->dax_dev;
+}
+
 static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 					 long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
-	int ret;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	ret = bdev_dax_pgoff(lc->dev->bdev, sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
-	return dax_direct_access(lc->dev->dax_dev, pgoff, nr_pages, kaddr, pfn);
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
@@ -968,11 +972,9 @@ static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
 {
 	struct log_writes_c *lc = ti->private;
 	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 	int err;
 
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-
 	/* Don't bother doing anything if logging has been disabled */
 	if (!lc->logging_enabled)
 		goto dax_copy;
@@ -983,34 +985,24 @@ static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
 		return 0;
 	}
 dax_copy:
-	return dax_copy_from_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static size_t log_writes_dax_copy_to_iter(struct dm_target *ti,
 					  pgoff_t pgoff, void *addr, size_t bytes,
 					  struct iov_iter *i)
 {
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-	return dax_copy_to_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
+	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 					  size_t nr_pages)
 {
-	int ret;
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	ret = bdev_dax_pgoff(lc->dev->bdev, sector, nr_pages << PAGE_SHIFT,
-			     &pgoff);
-	if (ret)
-		return ret;
-	return dax_zero_page_range(lc->dev->dax_dev, pgoff,
-				   nr_pages << PAGE_SHIFT);
+	return dax_zero_page_range(dax_dev, pgoff, nr_pages << PAGE_SHIFT);
 }
 
 #else
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

