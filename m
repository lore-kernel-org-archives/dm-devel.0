Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C2FC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB909610A6
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB909610A6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-3ZGHRM_rOZ6_OYs8QOd-3w-1; Tue, 09 Nov 2021 04:00:36 -0500
X-MC-Unique: 3ZGHRM_rOZ6_OYs8QOd-3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E50C102C889;
	Tue,  9 Nov 2021 09:00:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DB8F56AA7;
	Tue,  9 Nov 2021 09:00:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4256E1832DD2;
	Tue,  9 Nov 2021 09:00:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A98xbss017456 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 03:59:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E6DF4010FF7; Tue,  9 Nov 2021 08:59:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89C0240CFD02
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 734D8185A794
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:37 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-146-GmMwhMIbOf63zFCjJmx2bQ-1; Tue, 09 Nov 2021 03:59:34 -0500
X-MC-Unique: GmMwhMIbOf63zFCjJmx2bQ-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZG-000ryb-Kt; Tue, 09 Nov 2021 08:33:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:45 +0100
Message-Id: <20211109083309.584081-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 05/29] dax: remove the pgmap sanity checks in
	generic_fsdax_supported
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Drivers that register a dax_dev should make sure it works, no need
to double check from the file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c | 49 +--------------------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9383c11b21853..04fc680542e8d 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -107,13 +107,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors)
 {
-	bool dax_enabled = false;
 	pgoff_t pgoff, pgoff_end;
-	void *kaddr, *end_kaddr;
-	pfn_t pfn, end_pfn;
 	sector_t last_page;
-	long len, len2;
-	int err, id;
+	int err;
 
 	if (blocksize != PAGE_SIZE) {
 		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
@@ -138,49 +134,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
 		return false;
 	}
 
-	id = dax_read_lock();
-	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
-	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
-
-	if (len < 1 || len2 < 1) {
-		pr_info("%pg: error: dax access failed (%ld)\n",
-				bdev, len < 1 ? len : len2);
-		dax_read_unlock(id);
-		return false;
-	}
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
-		/*
-		 * An arch that has enabled the pmem api should also
-		 * have its drivers support pfn_t_devmap()
-		 *
-		 * This is a developer warning and should not trigger in
-		 * production. dax_flush() will crash since it depends
-		 * on being able to do (page_address(pfn_to_page())).
-		 */
-		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
-		dax_enabled = true;
-	} else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
-		struct dev_pagemap *pgmap, *end_pgmap;
-
-		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
-		end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
-		if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
-				&& pfn_t_to_page(pfn)->pgmap == pgmap
-				&& pfn_t_to_page(end_pfn)->pgmap == pgmap
-				&& pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
-				&& pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))
-			dax_enabled = true;
-		put_dev_pagemap(pgmap);
-		put_dev_pagemap(end_pgmap);
-
-	}
-	dax_read_unlock(id);
-
-	if (!dax_enabled) {
-		pr_info("%pg: error: dax support not enabled\n", bdev);
-		return false;
-	}
 	return true;
 }
 EXPORT_SYMBOL_GPL(generic_fsdax_supported);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

