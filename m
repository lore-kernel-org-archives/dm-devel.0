Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8418DC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 019EE64D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 019EE64D9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-Q2diLuezNK6DCijfB2vq1Q-1; Wed, 17 Feb 2021 10:37:49 -0500
X-MC-Unique: Q2diLuezNK6DCijfB2vq1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 159B9801977;
	Wed, 17 Feb 2021 15:37:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB8B15D9DC;
	Wed, 17 Feb 2021 15:37:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B9A7118095CC;
	Wed, 17 Feb 2021 15:37:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118AtqDI011340 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 05:55:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EE9895EDE2; Mon,  8 Feb 2021 10:55:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E99B85F25A
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D712F802A60
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:51 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-352-6GdUZp8PPlKNlfkEkzKung-1;
	Mon, 08 Feb 2021 05:55:49 -0500
X-MC-Unique: 6GdUZp8PPlKNlfkEkzKung-1
X-IronPort-AV: E=Sophos;i="5.81,161,1610380800"; d="scan'208";a="104328073"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 08 Feb 2021 18:55:47 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 2C8424CE6F81;
	Mon,  8 Feb 2021 18:55:41 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 18:55:43 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 8 Feb 2021 18:55:42 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 8 Feb 2021 18:55:26 +0800
Message-ID: <20210208105530.3072869-8-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 2C8424CE6F81.ABF51
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: qi.fuli@fujitsu.com, snitzer@redhat.com, darrick.wong@oracle.com,
	rgoldwyn@suse.de, david@fromorbit.com, y-goto@fujitsu.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v3 07/11] pmem: Implement ->corrupted_range() for
	pmem driver
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

Obtain the superblock of a pmem disk, and call filesystem's
->corrupted_range() to handle the corrupted data.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 block/genhd.c         |  6 ++++++
 drivers/nvdimm/pmem.c | 19 +++++++++++++++++++
 include/linux/genhd.h |  1 +
 3 files changed, 26 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 419548e92d82..fd7cf03b65a8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -936,6 +936,12 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	return bdev;
 }
 
+struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
+{
+	return disk_map_sector_rcu(disk, sector);
+}
+EXPORT_SYMBOL(bdget_disk_sector);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c77c80e3d155..e38b9f9c7d97 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -253,6 +253,24 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return blk_status_to_errno(rc);
 }
 
+static int pmem_corrupted_range(struct gendisk *disk, struct block_device *bdev,
+				loff_t disk_offset, size_t len, void *data)
+{
+	loff_t bdev_offset;
+	sector_t disk_sector = disk_offset >> SECTOR_SHIFT;
+	int rc = -ENODEV;
+
+	bdev = bdget_disk_sector(disk, disk_sector);
+	if (!bdev)
+		return rc;
+
+	bdev_offset = (disk_sector - get_start_sect(bdev)) << SECTOR_SHIFT;
+	rc = bd_corrupted_range(bdev, bdev_offset, bdev_offset, len, data);
+
+	bdput(bdev);
+	return rc;
+}
+
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
@@ -281,6 +299,7 @@ static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.submit_bio =		pmem_submit_bio,
 	.rw_page =		pmem_rw_page,
+	.corrupted_range =	pmem_corrupted_range,
 };
 
 static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 751cbd559bba..996f91b08d48 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -248,6 +248,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 
 extern void del_gendisk(struct gendisk *gp);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
+extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);
 
 extern void set_disk_ro(struct gendisk *disk, int flag);
 
-- 
2.30.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

