Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BD0C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656961440;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g1+JUnKakgpcQHMiNE22syKcy5o6EtB5tL6U8jTQ9iE=;
	b=bqmO+jQP37X5i3EOHezwhbakuwXvjzCSEmZX6WMURQJ57ehEwuDWk5m+lUE2MCma/tLs91
	vApbiBH79ySOqAYm/tgSi7wz5gsgY8iTn5lih6AuAT/opkGsKMIHySiRO1GyJ7E5qCRjws
	mHroqJ3NaazG7BYtn1pEPHbqi7P49So=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-WKYBLsKONSeux1umwnC8OQ-1; Mon, 04 Jul 2022 15:03:57 -0400
X-MC-Unique: WKYBLsKONSeux1umwnC8OQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54EE1805B98;
	Mon,  4 Jul 2022 19:03:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8234B2026985;
	Mon,  4 Jul 2022 19:03:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E97C194704D;
	Mon,  4 Jul 2022 19:03:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BA1B1947B99
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 19:03:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8CF6112131B; Mon,  4 Jul 2022 19:03:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4C171121315
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:03:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8982D801E95
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:03:43 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-qxiSEKi5OK23gF7tLgjW3A-1; Mon, 04 Jul 2022 15:03:36 -0400
X-MC-Unique: qxiSEKi5OK23gF7tLgjW3A-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LSD-008sNn-6Z; Mon, 04 Jul 2022 12:45:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:53 +0200
Message-Id: <20220704124500.155247-11-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 block/blk-zoned.c | 8 +++++---
 block/blk.h       | 4 ++--
 block/genhd.c     | 2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5a97b48102221..9085f9fb3ab42 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -449,8 +449,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
-void blk_queue_free_zone_bitmaps(struct request_queue *q)
+void disk_free_zone_bitmaps(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	kfree(q->conv_zones_bitmap);
 	q->conv_zones_bitmap = NULL;
 	kfree(q->seq_zones_wlock);
@@ -612,7 +614,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		ret = 0;
 	} else {
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-		blk_queue_free_zone_bitmaps(q);
+		disk_free_zone_bitmaps(disk);
 	}
 	blk_mq_unfreeze_queue(q);
 
@@ -628,7 +630,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
 
 	blk_mq_freeze_queue(q);
 
-	blk_queue_free_zone_bitmaps(q);
+	disk_free_zone_bitmaps(disk);
 	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
 	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
 	q->nr_zones = 0;
diff --git a/block/blk.h b/block/blk.h
index 7482a3a441dd9..b71e22c97d773 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -405,10 +405,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 #endif
 
 #ifdef CONFIG_BLK_DEV_ZONED
-void blk_queue_free_zone_bitmaps(struct request_queue *q);
+void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
 #else
-static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
+static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 #endif
 
diff --git a/block/genhd.c b/block/genhd.c
index d0bdeb93e922c..9d30f159c59ac 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1165,7 +1165,7 @@ static void disk_release(struct device *dev)
 
 	disk_release_events(disk);
 	kfree(disk->random);
-	blk_queue_free_zone_bitmaps(disk->queue);
+	disk_free_zone_bitmaps(disk);
 	xa_destroy(&disk->part_tbl);
 
 	disk->queue->disk = NULL;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

