Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F2AC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656954251;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wt8d98lCxfOrPOpsfolOooP54YtzMWflse/oOSnyVaM=;
	b=LOzXHm6Xwe7pa7xNRZn7Aoj2p0n0S6cH6bKj/ZQmJss999Dy/uyR6i1HDRKAjF+0mMAQ4j
	MLOj6u9Gup75pnF2/BPYv7Du3Sk8TvZ1K8rmOff1ybs83fc1MA9LgeSBRUAmCS4CIPz7mI
	CCr9q0cJQPplBbfCcnoFRBacFg3ezbg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-T6fm5VUfNcG8_GDQ9MdKGQ-1; Mon, 04 Jul 2022 13:04:08 -0400
X-MC-Unique: T6fm5VUfNcG8_GDQ9MdKGQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B9373C0D841;
	Mon,  4 Jul 2022 17:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0AD73492C3B;
	Mon,  4 Jul 2022 17:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE4201947041;
	Mon,  4 Jul 2022 17:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 827A519466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 17:04:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FB6A2166B2A; Mon,  4 Jul 2022 17:04:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BA5A2166B26
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 17:04:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 011721C01B28
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 17:04:04 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-fcIgF6zwN5SQVdjzVCcDog-1; Mon, 04 Jul 2022 13:04:00 -0400
X-MC-Unique: fcIgF6zwN5SQVdjzVCcDog-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LSA-008sM9-JA; Mon, 04 Jul 2022 12:45:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:52 +0200
Message-Id: <20220704124500.155247-10-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 09/17] block: pass a gendisk to
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
index 7fbe395fa51fc..5a97b48102221 100644
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

