Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C604C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 07:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657091351;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4ioNrfGsglkBbbM9w1rQnHrLgVreoeZ1yL1waM+hnoU=;
	b=B6xTS2GeEF2deRTxSuxl7pKLNfV+cEXBf4PPte0wsZ8jLVqgEN3lLPbVelBAwNArwxBls3
	0vhOSZB6tYJKaEk/kOMUGyZbeb1GRAUvli98eXflEGdTeaXVwS9263EXNnIuNesv1rPWwX
	N99JlCS+nyj/QTkPe1f2jeTt24pnu5k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-5not3MY1M6O0btmC3_nP1A-1; Wed, 06 Jul 2022 03:09:02 -0400
X-MC-Unique: 5not3MY1M6O0btmC3_nP1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9336802C16;
	Wed,  6 Jul 2022 07:09:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7DA61121315;
	Wed,  6 Jul 2022 07:09:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A27A61947060;
	Wed,  6 Jul 2022 07:09:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD849194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 07:08:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B170C2024CB6; Wed,  6 Jul 2022 07:08:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD88A2026D64
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 07:08:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91D148339C2
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 07:08:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-y_L1WbZBPAilOPwZs1knuw-1; Wed, 06 Jul 2022 03:08:50 -0400
X-MC-Unique: y_L1WbZBPAilOPwZs1knuw-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z59-006v79-BF; Wed, 06 Jul 2022 07:04:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:44 +0200
Message-Id: <20220706070350.1703384-11-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 10/16] block: pass a gendisk to
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>, linux-scsi@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Switch to a gendisk based API in preparation for moving all zone related
fields from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
index 7d4105d23b0a4..c05e1cc05c265 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -696,16 +696,16 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
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

