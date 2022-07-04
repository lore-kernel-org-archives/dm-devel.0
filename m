Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C28C43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656960182;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nBkr35kYteGmfj3BBxAHscSlU9bYKLUimimohCjgJbQ=;
	b=L8JtwlcQA/SLT4dY/WnKuajLHz0C99y4PGAe6ncZO2EqkEc74xdfaDYjewXEULkQuQTGT2
	rSQ76zVbwei5CWK3BlDHzR1xgqeNjyWPmTN+OYnN+v3vP3um88HGNNvkLQwdAP4h0/kFum
	NeOk5QHvEIbQzDEaJwLXn3Qf4AF2Uhc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-9bfpN1utNK6iKFMxYkJOBg-1; Mon, 04 Jul 2022 14:42:59 -0400
X-MC-Unique: 9bfpN1utNK6iKFMxYkJOBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9027B802D1C;
	Mon,  4 Jul 2022 18:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C63A4010D2A;
	Mon,  4 Jul 2022 18:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DA7E1947041;
	Mon,  4 Jul 2022 18:42:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E1AB19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 18:42:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C31C141510F; Mon,  4 Jul 2022 18:42:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 682811410F3C
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 18:42:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50CCB101A588
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 18:42:56 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-H8V1se9ZMw2mGxD9MyV4ZQ-1; Mon, 04 Jul 2022 14:42:54 -0400
X-MC-Unique: H8V1se9ZMw2mGxD9MyV4ZQ-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LST-008sZh-Gv; Mon, 04 Jul 2022 12:45:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:59 +0200
Message-Id: <20220704124500.155247-17-hch@lst.de>
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 16/17] block: remove blk_queue_zone_sectors
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Always use bdev_zone_sectors instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c  |  4 +---
 drivers/md/dm-zone.c   | 10 ++++++----
 include/linux/blkdev.h | 11 +++--------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b36b528e56cff..df904b7e95ce3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1620,13 +1620,11 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
 					   sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
 	if (!bdev_is_zoned(dev->bdev))
 		return 0;
-
-	return blk_queue_zone_sectors(q) != *zone_sectors;
+	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
 }
 
 /*
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 6d105abe12415..842c31019b513 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -334,7 +334,7 @@ static int dm_update_zone_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
 static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
 				    unsigned int *wp_ofst)
 {
-	sector_t sector = zno * blk_queue_zone_sectors(md->queue);
+	sector_t sector = zno * bdev_zone_sectors(md->disk->part0);
 	unsigned int noio_flag;
 	struct dm_table *t;
 	int srcu_idx, ret;
@@ -373,7 +373,7 @@ struct orig_bio_details {
 static bool dm_zone_map_bio_begin(struct mapped_device *md,
 				  unsigned int zno, struct bio *clone)
 {
-	sector_t zsectors = blk_queue_zone_sectors(md->queue);
+	sector_t zsectors = bdev_zone_sectors(md->disk->part0);
 	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
 
 	/*
@@ -443,7 +443,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
 		return BLK_STS_OK;
 	case REQ_OP_ZONE_FINISH:
 		WRITE_ONCE(md->zwp_offset[zno],
-			   blk_queue_zone_sectors(md->queue));
+			   bdev_zone_sectors(md->disk->part0));
 		return BLK_STS_OK;
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
@@ -593,6 +593,7 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 {
 	struct mapped_device *md = io->md;
 	struct request_queue *q = md->queue;
+	struct gendisk *disk = md->disk;
 	struct bio *orig_bio = io->orig_bio;
 	unsigned int zwp_offset;
 	unsigned int zno;
@@ -608,7 +609,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 		 */
 		if (clone->bi_status == BLK_STS_OK &&
 		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
-			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
+			sector_t mask =
+				(sector_t)bdev_zone_sectors(disk->part0) - 1;
 
 			orig_bio->bi_iter.bi_sector +=
 				clone->bi_iter.bi_sector & mask;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 183aa83143fd2..f1eca3f5610eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -669,11 +669,6 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
-static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
-{
-	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
-}
-
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -1312,9 +1307,9 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q)
-		return blk_queue_zone_sectors(q);
-	return 0;
+	if (!blk_queue_is_zoned(q))
+		return 0;
+	return q->limits.chunk_sectors;
 }
 
 static inline int queue_dma_alignment(const struct request_queue *q)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

