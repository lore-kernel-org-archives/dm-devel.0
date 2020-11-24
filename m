Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE7AC825A8
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F29C4206F9
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F29C4206F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-pHI4DzTvMbGAUYtd3B-mAg-1; Tue, 24 Nov 2020 08:29:45 -0500
X-MC-Unique: pHI4DzTvMbGAUYtd3B-mAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E703687315C;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAD5119C46;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8747E1809CA4;
	Tue, 24 Nov 2020 13:29:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODTH9i018184 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:29:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 390482026D16; Tue, 24 Nov 2020 13:29:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 315DE2026D37
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82C59858295
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:13 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-298-NQXy1wvtOceUphBzLMbe0g-1; Tue, 24 Nov 2020 08:29:11 -0500
X-MC-Unique: NQXy1wvtOceUphBzLMbe0g-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYNS-0006hp-IQ; Tue, 24 Nov 2020 13:29:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:46 +0100
Message-Id: <20201124132751.3747337-41-hch@lst.de>
In-Reply-To: <20201124132751.3747337-1-hch@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] [PATCH 40/45] block: pass a block_device to
	blk_alloc_devt
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pass the block_device actually needed instead of the hd_struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h             |  2 +-
 block/genhd.c           | 14 +++++++-------
 block/partitions/core.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index d5bf8f3a078186..9657c6da7c770c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -350,7 +350,7 @@ static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 
 struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector);
 
-int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
+int blk_alloc_devt(struct block_device *part, dev_t *devt);
 void blk_free_devt(dev_t devt);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
 #define ADDPART_FLAG_NONE	0
diff --git a/block/genhd.c b/block/genhd.c
index 60004bc8ba5b56..498c816e90df64 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -557,8 +557,8 @@ static int blk_mangle_minor(int minor)
 }
 
 /**
- * blk_alloc_devt - allocate a dev_t for a partition
- * @part: partition to allocate dev_t for
+ * blk_alloc_devt - allocate a dev_t for a block device
+ * @bdev: block device to allocate dev_t for
  * @devt: out parameter for resulting dev_t
  *
  * Allocate a dev_t for block device.
@@ -570,14 +570,14 @@ static int blk_mangle_minor(int minor)
  * CONTEXT:
  * Might sleep.
  */
-int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
+int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
 {
-	struct gendisk *disk = part_to_disk(part);
+	struct gendisk *disk = bdev->bd_disk;
 	int idx;
 
 	/* in consecutive minor range? */
-	if (part->bdev->bd_partno < disk->minors) {
-		*devt = MKDEV(disk->major, disk->first_minor + part->bdev->bd_partno);
+	if (bdev->bd_partno < disk->minors) {
+		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
 		return 0;
 	}
 
@@ -733,7 +733,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 
 	disk->flags |= GENHD_FL_UP;
 
-	retval = blk_alloc_devt(disk->part0->bd_part, &devt);
+	retval = blk_alloc_devt(disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
 		return;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index ee4f4e3237aa2d..45fed1108d4425 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -392,7 +392,7 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	pdev->type = &part_type;
 	pdev->parent = ddev;
 
-	err = blk_alloc_devt(p, &devt);
+	err = blk_alloc_devt(bdev, &devt);
 	if (err)
 		goto out_bdput;
 	pdev->devt = devt;
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

