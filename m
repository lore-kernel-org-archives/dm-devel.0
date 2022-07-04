Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BC6C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656962161;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZQQDIqF6WuVEL0cnNzUnzsoktmOT1ZRvQ3arWNdvVkE=;
	b=BMyIc1iIcUyXJ9LSkjXQttOv4ZEymw7mJp3wLy0YoSjopf/wWhjscPHoIlrf9+b0A7dNcj
	I3Wd+dT+uhkq3pUcnRjNa5fFghFYi1NZhQRJFBEME7F2BFK+V/5eCbkgInnJvNp7MtTJkK
	kINYxonzI5PQQS+jc5TvC2LB8tulmMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-JRHu7dbhOQ63htVGchflWg-1; Mon, 04 Jul 2022 15:15:58 -0400
X-MC-Unique: JRHu7dbhOQ63htVGchflWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BBB71857F02;
	Mon,  4 Jul 2022 19:15:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8493401E54;
	Mon,  4 Jul 2022 19:15:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6EB03194704D;
	Mon,  4 Jul 2022 19:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C5E61947052
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 19:15:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F393CC15D5C; Mon,  4 Jul 2022 19:15:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EEDF7C15D58
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:15:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6330811E75
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:15:53 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-On03CcARNMSvMJ1O0jsklw-1; Mon, 04 Jul 2022 15:15:52 -0400
X-MC-Unique: On03CcARNMSvMJ1O0jsklw-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LSI-008sRz-IY; Mon, 04 Jul 2022 12:45:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:55 +0200
Message-Id: <20220704124500.155247-13-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 12/17] block: pass a gendisk to
 blk_queue_max_open_zones and blk_queue_max_active_zones
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Switch to a gendisk based API in preparation for moving all zone related
fields from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk/zoned.c | 4 ++--
 drivers/nvme/host/zns.c        | 4 ++--
 drivers/scsi/sd_zbc.c          | 6 +++---
 include/linux/blkdev.h         | 8 ++++----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index b47bbd114058d..576ab3ed082a5 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -174,8 +174,8 @@ int null_register_zoned_dev(struct nullb *nullb)
 	}
 
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-	blk_queue_max_open_zones(q, dev->zone_max_open);
-	blk_queue_max_active_zones(q, dev->zone_max_active);
+	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
+	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 0ed15c2fd56de..12316ab51bda6 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -111,8 +111,8 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 
 	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
-	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
+	disk_set_max_open_zones(ns->disk, le32_to_cpu(id->mor) + 1);
+	disk_set_max_active_zones(ns->disk, le32_to_cpu(id->mar) + 1);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0f5823b674685..b4106f8997342 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -950,10 +950,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	if (sdkp->zones_max_open == U32_MAX)
-		blk_queue_max_open_zones(q, 0);
+		disk_set_max_open_zones(disk, 0);
 	else
-		blk_queue_max_open_zones(q, sdkp->zones_max_open);
-	blk_queue_max_active_zones(q, 0);
+		disk_set_max_open_zones(disk, sdkp->zones_max_open);
+	disk_set_max_active_zones(disk, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a14cc3e46e6ad..e32c147f72868 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -698,16 +698,16 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
 }
 
-static inline void blk_queue_max_open_zones(struct request_queue *q,
+static inline void disk_set_max_open_zones(struct gendisk *disk,
 		unsigned int max_open_zones)
 {
-	q->max_open_zones = max_open_zones;
+	disk->queue->max_open_zones = max_open_zones;
 }
 
-static inline void blk_queue_max_active_zones(struct request_queue *q,
+static inline void disk_set_max_active_zones(struct gendisk *disk,
 		unsigned int max_active_zones)
 {
-	q->max_active_zones = max_active_zones;
+	disk->queue->max_active_zones = max_active_zones;
 }
 
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

