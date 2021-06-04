Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26625C4708F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:27:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF7366136E
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF7366136E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-Ly6W6Rs9PaKzxB03V3w8HA-1; Fri, 04 Jun 2021 02:26:58 -0400
X-MC-Unique: Ly6W6Rs9PaKzxB03V3w8HA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2660A106BB33;
	Fri,  4 Jun 2021 06:26:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0949C376E;
	Fri,  4 Jun 2021 06:26:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF2D944A58;
	Fri,  4 Jun 2021 06:26:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1541KGM4026818 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 21:20:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2968011E5BB; Fri,  4 Jun 2021 01:20:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2500111E5CB
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 01:20:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D780805F44
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 01:20:16 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-371-CrnSrQysNU2CzVrkgSpltg-3;
	Thu, 03 Jun 2021 21:20:11 -0400
X-MC-Unique: CrnSrQysNU2CzVrkgSpltg-3
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AciOndaGMdrd53wsKpLqEjceALOsnbusQ8zAX?=
	=?us-ascii?q?PiFKKSC9Hfb0qynDpp4mPHzP6Qr5OktOpTnoAsDpKk80naQFgrX5Vo3PYOCJgg?=
	=?us-ascii?q?WVEL0=3D?=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; d="scan'208";a="109209802"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 04 Jun 2021 09:19:06 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id D3F604C36A00;
	Fri,  4 Jun 2021 09:19:01 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 4 Jun 2021 09:19:02 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 4 Jun 2021 09:18:55 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 4 Jun 2021 09:18:54 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Fri, 4 Jun 2021 09:18:39 +0800
Message-ID: <20210604011844.1756145-6-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: D3F604C36A00.A0E01
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Jun 2021 02:21:36 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v4 05/10] mm,
	pmem: Implement ->memory_failure() in pmem driver
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

Call the ->memory_failure() which is implemented by pmem driver, in
order to finally notify filesystem to handle the corrupted data.  The
handler which collects and kills processes are moved into
mf_dax_kill_procs(), which will be called by filesystem.

Keep the old handler in order to roll back if driver or filesystem
does not support ->memory_failure()/->corrupted_range().

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 block/genhd.c         | 30 ++++++++++++++++++
 drivers/nvdimm/pmem.c | 14 +++++++++
 include/linux/genhd.h |  1 +
 mm/memory-failure.c   | 71 +++++++++++++++++++++++++++----------------
 4 files changed, 90 insertions(+), 26 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9f8cb7beaad1..75834bd057df 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -718,6 +718,36 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	return bdev;
 }
 
+/**
+ * bdget_disk_sector - get block device by given sector number
+ * @disk: gendisk of interest
+ * @sector: sector number
+ *
+ * RETURNS: the found block device where sector locates in
+ */
+struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
+{
+	struct block_device *part = NULL, *p;
+	unsigned long idx;
+
+	rcu_read_lock();
+	xa_for_each(&disk->part_tbl, idx, p) {
+		if (p->bd_partno == 0)
+			continue;
+		if (p->bd_start_sect <= sector &&
+			sector < p->bd_start_sect + bdev_nr_sectors(p)) {
+			part = p;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (!part)
+		part = disk->part0;
+
+	return bdget_disk(disk, part->bd_partno);
+}
+EXPORT_SYMBOL(bdget_disk_sector);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ed10a8b66068..98349e7d0a28 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -364,9 +364,23 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }
 
+static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, int flags)
+{
+	struct pmem_device *pdev =
+			container_of(pgmap, struct pmem_device, pgmap);
+	loff_t offset = PFN_PHYS(pfn) - pdev->phys_addr - pdev->data_offset;
+	struct block_device *bdev =
+			bdget_disk_sector(pdev->disk, offset >> SECTOR_SHIFT);
+
+	return dax_corrupted_range(pdev->dax_dev, bdev, offset,
+				   page_size(pfn_to_page(pfn)), &flags);
+}
+
 static const struct dev_pagemap_ops fsdax_pagemap_ops = {
 	.kill			= pmem_pagemap_kill,
 	.cleanup		= pmem_pagemap_cleanup,
+	.memory_failure		= pmem_pagemap_memory_failure,
 };
 
 static int pmem_attach_disk(struct device *dev,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6fc26f7bdf71..2ad70c02c343 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,6 +219,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 
 extern void del_gendisk(struct gendisk *gp);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
+extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);
 
 void set_disk_ro(struct gendisk *disk, bool read_only);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4377e727d478..43017d7f3918 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1247,6 +1247,36 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
 }
 
+static int mf_generic_kill_procs(unsigned long long pfn, int flags)
+{
+	struct page *page = pfn_to_page(pfn);
+	LIST_HEAD(to_kill);
+	dax_entry_t cookie;
+
+	/*
+	 * Prevent the inode from being freed while we are interrogating
+	 * the address_space, typically this would be handled by
+	 * lock_page(), but dax pages do not use the page lock. This
+	 * also prevents changes to the mapping of this pfn until
+	 * poison signaling is complete.
+	 */
+	cookie = dax_lock_page(page);
+	if (!cookie)
+		return -EBUSY;
+	/*
+	 * Unlike System-RAM there is no possibility to swap in a
+	 * different physical page at a given virtual address, so all
+	 * userspace consumption of ZONE_DEVICE memory necessitates
+	 * SIGBUS (i.e. MF_MUST_KILL)
+	 */
+	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+	collect_procs(page, &to_kill, flags & MF_ACTION_REQUIRED);
+
+	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
+	dax_unlock_page(page, cookie);
+	return 0;
+}
+
 int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index, int flags)
 {
 	LIST_HEAD(to_kill);
@@ -1348,9 +1378,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
-	LIST_HEAD(to_kill);
 	int rc = -EBUSY;
-	dax_entry_t cookie;
 
 	if (flags & MF_COUNT_INCREASED)
 		/*
@@ -1364,20 +1392,9 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		goto out;
 	}
 
-	/*
-	 * Prevent the inode from being freed while we are interrogating
-	 * the address_space, typically this would be handled by
-	 * lock_page(), but dax pages do not use the page lock. This
-	 * also prevents changes to the mapping of this pfn until
-	 * poison signaling is complete.
-	 */
-	cookie = dax_lock_page(page);
-	if (!cookie)
-		goto out;
-
 	if (hwpoison_filter(page)) {
 		rc = 0;
-		goto unlock;
+		goto out;
 	}
 
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
@@ -1385,7 +1402,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		 * TODO: Handle HMM pages which may need coordination
 		 * with device-side memory.
 		 */
-		goto unlock;
+		goto out;
 	}
 
 	/*
@@ -1395,19 +1412,21 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	SetPageHWPoison(page);
 
 	/*
-	 * Unlike System-RAM there is no possibility to swap in a
-	 * different physical page at a given virtual address, so all
-	 * userspace consumption of ZONE_DEVICE memory necessitates
-	 * SIGBUS (i.e. MF_MUST_KILL)
+	 * Call driver's implementation to handle the memory failure,
+	 * otherwise roll back to generic handler.
 	 */
-	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs_file(page, page->mapping, page->index, &to_kill,
-			   flags & MF_ACTION_REQUIRED);
+	if (pgmap->ops->memory_failure) {
+		rc = pgmap->ops->memory_failure(pgmap, pfn, flags);
+		/*
+		 * Roll back to generic handler too if operation is not
+		 * supported inside the driver/device/filesystem.
+		 */
+		if (rc != EOPNOTSUPP)
+			goto out;
+	}
+
+	rc = mf_generic_kill_procs(pfn, flags);
 
-	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
-	rc = 0;
-unlock:
-	dax_unlock_page(page, cookie);
 out:
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
-- 
2.31.1



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

