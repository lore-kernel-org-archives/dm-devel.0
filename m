Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A715C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 09:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657099048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7j3wHPnZRYFJ4H95QwGv5FOQeq+qA1YpFpRGJYoa4kM=;
	b=COwe8RFHOxP0ISyNm+P/HLpc3WNXF+yYxyXjF/ZYzfkj/PVaytPzVoZzG54nCf6Hq22w0j
	iAlkt4d6wbxkMluCG/Jvl5/DQFaKARDXbVMfida3WxXK6LEiij5l88W+ZPW/KpmhwcGTVF
	cWxoBpfGx2OprI/s7W7n4PO88zkV6S4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-33p2upblPhaDIsUoHuMArw-1; Wed, 06 Jul 2022 05:17:25 -0400
X-MC-Unique: 33p2upblPhaDIsUoHuMArw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 820E33801158;
	Wed,  6 Jul 2022 09:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33B2D14582E0;
	Wed,  6 Jul 2022 09:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1A841947065;
	Wed,  6 Jul 2022 09:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C0FF3194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 09:17:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B141D40C141D; Wed,  6 Jul 2022 09:17:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACA174010D2A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:17:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 945BF18A64F7
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:17:21 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-F6R_U_v8NuyKpqh4aL8-9A-1; Wed, 06 Jul 2022 05:17:19 -0400
X-MC-Unique: F6R_U_v8NuyKpqh4aL8-9A-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z4q-006usR-Sk; Wed, 06 Jul 2022 07:04:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:37 +0200
Message-Id: <20220706070350.1703384-4-hch@lst.de>
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 03/16] block: use bdev_is_zoned instead of open
 coding it
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, linux-scsi@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use bdev_is_zoned in all places where a block_device is available instead
of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/bio.c           | 2 +-
 block/blk-core.c      | 6 +++---
 block/blk-mq.h        | 2 +-
 block/blk-zoned.c     | 9 ++++-----
 drivers/md/dm-table.c | 2 +-
 drivers/md/dm-zone.c  | 2 +-
 drivers/md/dm.c       | 2 +-
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 933ea32109547..888ee81ea3034 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1033,7 +1033,7 @@ int bio_add_zone_append_page(struct bio *bio, struct page *page,
 	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
 		return 0;
 
-	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+	if (WARN_ON_ONCE(!bdev_is_zoned(bio->bi_bdev)))
 		return 0;
 
 	return bio_add_hw_page(q, bio, page, len, offset,
diff --git a/block/blk-core.c b/block/blk-core.c
index 5ad7bd93077c8..6bcca0b686de4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -569,7 +569,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 	int nr_sectors = bio_sectors(bio);
 
 	/* Only applicable to zoned block devices */
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bio->bi_bdev))
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
@@ -775,11 +775,11 @@ void submit_bio_noacct(struct bio *bio)
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		if (!blk_queue_is_zoned(q))
+		if (!bdev_is_zoned(bio->bi_bdev))
 			goto not_supported;
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
-		if (!blk_queue_is_zoned(q) || !blk_queue_zone_resetall(q))
+		if (!bdev_is_zoned(bio->bi_bdev) || !blk_queue_zone_resetall(q))
 			goto not_supported;
 		break;
 	case REQ_OP_WRITE_ZEROES:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 54e20edf0da30..31d75a83a562d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -317,7 +317,7 @@ static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
 	 * For regular block devices or read operations, use the context plug
 	 * which may be NULL if blk_start_plug() was not executed.
 	 */
-	if (!blk_queue_is_zoned(q) || !op_is_write(bio_op(bio)))
+	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
 		return current->plug;
 
 	/* Zoned block device write operation case: do not plug the BIO */
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 38cd840d88387..90a5c9cc80ab3 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -149,8 +149,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	struct gendisk *disk = bdev->bd_disk;
 	sector_t capacity = get_capacity(disk);
 
-	if (!blk_queue_is_zoned(bdev_get_queue(bdev)) ||
-	    WARN_ON_ONCE(!disk->fops->report_zones))
+	if (!bdev_is_zoned(bdev) || WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
 	if (!nr_zones || sector >= capacity)
@@ -268,7 +267,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	struct bio *bio = NULL;
 	int ret = 0;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -EOPNOTSUPP;
 
 	if (bdev_read_only(bdev))
@@ -350,7 +349,7 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!q)
 		return -ENXIO;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -ENOTTY;
 
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
@@ -408,7 +407,7 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!q)
 		return -ENXIO;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(bdev))
 		return -ENOTTY;
 
 	if (!(mode & FMODE_WRITE))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd539afbfe88f..b36b528e56cff 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1623,7 +1623,7 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
-	if (!blk_queue_is_zoned(q))
+	if (!bdev_is_zoned(dev->bdev))
 		return 0;
 
 	return blk_queue_zone_sectors(q) != *zone_sectors;
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3e7b1fe1580b9..ae616b87c91ae 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -270,7 +270,7 @@ static int device_not_zone_append_capable(struct dm_target *ti,
 					  struct dm_dev *dev, sector_t start,
 					  sector_t len, void *data)
 {
-	return !blk_queue_is_zoned(bdev_get_queue(dev->bdev));
+	return !bdev_is_zoned(dev->bdev);
 }
 
 static bool dm_table_supports_zone_append(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8872f9c636889..33d3799bb66ec 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1033,7 +1033,7 @@ static void clone_endio(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
+	    unlikely(bdev_is_zoned(bio->bi_bdev)))
 		dm_zone_endio(io, bio);
 
 	if (endio) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

