Return-Path: <SRS0=dJ+f=FC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8BAC63697
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:31:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9B45246CA
	for <dm-devel@archiver.kernel.org>; Sat, 28 Nov 2020 16:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9B45246CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-_HMYGQ36Mq64_iHM5Y-hsQ-1; Sat, 28 Nov 2020 11:31:51 -0500
X-MC-Unique: _HMYGQ36Mq64_iHM5Y-hsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C41F100531A;
	Sat, 28 Nov 2020 16:31:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FA1960862;
	Sat, 28 Nov 2020 16:31:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 554125002C;
	Sat, 28 Nov 2020 16:31:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ASGViSu024606 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 28 Nov 2020 11:31:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BB8A02166B2A; Sat, 28 Nov 2020 16:31:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B682C2166B28
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:31:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 384051010439
	for <dm-devel@redhat.com>; Sat, 28 Nov 2020 16:31:41 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-584-U247XASAOqa3FpwUlxLmPg-1; Sat, 28 Nov 2020 11:31:38 -0500
X-MC-Unique: U247XASAOqa3FpwUlxLmPg-1
Received: from 089144198196.atnat0007.highway.a1.net ([89.144.198.196]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kj38I-0001U0-Eo; Sat, 28 Nov 2020 16:31:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat, 28 Nov 2020 17:15:05 +0100
Message-Id: <20201128161510.347752-41-hch@lst.de>
In-Reply-To: <20201128161510.347752-1-hch@lst.de>
References: <20201128161510.347752-1-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pass the block_device actually needed instead of the hd_struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
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
index f4e5a892fc8208..835393b7101ace 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -562,8 +562,8 @@ static int blk_mangle_minor(int minor)
 }
 
 /**
- * blk_alloc_devt - allocate a dev_t for a partition
- * @part: partition to allocate dev_t for
+ * blk_alloc_devt - allocate a dev_t for a block device
+ * @bdev: block device to allocate dev_t for
  * @devt: out parameter for resulting dev_t
  *
  * Allocate a dev_t for block device.
@@ -575,14 +575,14 @@ static int blk_mangle_minor(int minor)
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
 
@@ -738,7 +738,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 
 	disk->flags |= GENHD_FL_UP;
 
-	retval = blk_alloc_devt(disk->part0->bd_part, &devt);
+	retval = blk_alloc_devt(disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
 		return;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 6db9ca8b722d66..3d8243334c7cb4 100644
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

