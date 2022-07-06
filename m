Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F70AC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 09:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657100009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AcnXJlGeEdknAQRNGxpFfyllbqv/6zGUui09ldIEPFU=;
	b=IbGNgB3bTLhbfk3jRuHvMdbL3RVuiOmoyvjjF3pQf20hCr0ItWeKdAoH2Sv/GnztQoTDRy
	8RW336d5mf4g/NnxsgTZ0Wlq29v6purCh1W1jb4xVMFCkrMKO2+K/P8g2ItK4uGZkGyspT
	rc0ZB73a/IUTnXBKGBpVyKp1V04RVS8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-4tlTyIg8O_6KiQ5HTZeQdQ-1; Wed, 06 Jul 2022 05:33:19 -0400
X-MC-Unique: 4tlTyIg8O_6KiQ5HTZeQdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5411B1C09047;
	Wed,  6 Jul 2022 09:33:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98AD9C28129;
	Wed,  6 Jul 2022 09:33:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A9461947063;
	Wed,  6 Jul 2022 09:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D20BA194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 09:33:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B470F2166B29; Wed,  6 Jul 2022 09:33:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0AE82166B26
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:33:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95522811E81
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 09:33:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-dvru59M7MNWuR9FxwMg1oA-1; Wed, 06 Jul 2022 05:33:14 -0400
X-MC-Unique: dvru59M7MNWuR9FxwMg1oA-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z51-006uzw-DV; Wed, 06 Jul 2022 07:04:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:41 +0200
Message-Id: <20220706070350.1703384-8-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 07/16] block: pass a gendisk to
 blk_queue_clear_zone_settings
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 block/blk-settings.c | 2 +-
 block/blk-zoned.c    | 4 +++-
 block/blk.h          | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 35b7bba306a83..8bb9eef5310eb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -946,7 +946,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		blk_queue_zone_write_granularity(q,
 						queue_logical_block_size(q));
 	} else {
-		blk_queue_clear_zone_settings(q);
+		disk_clear_zone_settings(disk);
 	}
 }
 EXPORT_SYMBOL_GPL(disk_set_zoned);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 90a5c9cc80ab3..82a4fa89678ce 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -622,8 +622,10 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
-void blk_queue_clear_zone_settings(struct request_queue *q)
+void disk_clear_zone_settings(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	blk_mq_freeze_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
diff --git a/block/blk.h b/block/blk.h
index 58ad50cacd2d5..7482a3a441dd9 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -406,10 +406,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void blk_queue_free_zone_bitmaps(struct request_queue *q);
-void blk_queue_clear_zone_settings(struct request_queue *q);
+void disk_clear_zone_settings(struct gendisk *disk);
 #else
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
-static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
+static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 #endif
 
 int blk_alloc_ext_minor(void);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

