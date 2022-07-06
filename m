Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC72C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 10:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657102076;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TpKOJOiKQmKmeoOH0nw9Dgxzfa2udyZULnoOxABeYD4=;
	b=MBxMBCsvNjmb0CCPdFC9owTehdVAkW77b512RTP1eGMXpkYhmeXoH8WHdAN1CbtDhIPFh1
	W6U+NKz9LzGQ87zi+8w6e7Rap/mb2B/sk9FKjBu/6H7z728NyXlDEB5QyNhO4eGQjWhP0Z
	i5E3+Td86beV1k3VpqN6OrR1z3JHGkk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-7V8IKqL7P_2BsJWyYFJT5Q-1; Wed, 06 Jul 2022 06:07:53 -0400
X-MC-Unique: 7V8IKqL7P_2BsJWyYFJT5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5111E811E87;
	Wed,  6 Jul 2022 10:07:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC3EB40E80E0;
	Wed,  6 Jul 2022 10:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA8AE1947065;
	Wed,  6 Jul 2022 10:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 838271947063
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 10:07:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 726DE492CA2; Wed,  6 Jul 2022 10:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E3CB492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 10:07:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 565AC8339C4
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 10:07:47 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-msAzalRUNMS-FN8p0uKCTg-1; Wed, 06 Jul 2022 06:07:39 -0400
X-MC-Unique: msAzalRUNMS-FN8p0uKCTg-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z56-006v47-O9; Wed, 06 Jul 2022 07:04:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:43 +0200
Message-Id: <20220706070350.1703384-10-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 09/16] block: remove queue_max_open_zones and
 queue_max_active_zones
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Always use the bdev based helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-sysfs.c      |  4 ++--
 include/linux/blkdev.h | 37 ++++++++++---------------------------
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7590810cf13fc..5ce72345ac666 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -330,12 +330,12 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
 
 static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_max_open_zones(q), page);
+	return queue_var_show(bdev_max_open_zones(q->disk->part0), page);
 }
 
 static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_max_active_zones(q), page);
+	return queue_var_show(bdev_max_active_zones(q->disk->part0), page);
 }
 
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 416faa0137820..7d4105d23b0a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -702,21 +702,22 @@ static inline void blk_queue_max_open_zones(struct request_queue *q,
 	q->max_open_zones = max_open_zones;
 }
 
-static inline unsigned int queue_max_open_zones(const struct request_queue *q)
-{
-	return q->max_open_zones;
-}
-
 static inline void blk_queue_max_active_zones(struct request_queue *q,
 		unsigned int max_active_zones)
 {
 	q->max_active_zones = max_active_zones;
 }
 
-static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
+{
+	return bdev->bd_disk->queue->max_open_zones;
+}
+
+static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 {
-	return q->max_active_zones;
+	return bdev->bd_disk->queue->max_active_zones;
 }
+
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -732,11 +733,11 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
-static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	return 0;
 }
-static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 {
 	return 0;
 }
@@ -1314,24 +1315,6 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
-static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return queue_max_open_zones(q);
-	return 0;
-}
-
-static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return queue_max_active_zones(q);
-	return 0;
-}
-
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

