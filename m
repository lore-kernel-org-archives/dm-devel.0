Return-Path: <SRS0=pEh8=LR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC4BC48BC2
	for <dm-devel@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6B836128C
	for <dm-devel@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6B836128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624434131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lIp9wgea/WuSE4b845E9tt+m6SFr0mIR/2v9rXXnMi0=;
	b=FINs2UXohkyVoAJ/TFv+kPdFIul9Yr4R5hRIQlkbM9BQPerE2bvLfhgigK7IkzRftlQs1E
	YqHIRfmnMiS9AG0J4zms1ohmuvuCLsmljsjv9jd42dR+OOHkRsZ8xLNz+HVFXiVzv8huCG
	RpOymFQbWcNMceDYIniJFyFhEWMxE4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-b7_9Nl4gM1enKrrFxBnMfA-1; Wed, 23 Jun 2021 03:42:09 -0400
X-MC-Unique: b7_9Nl4gM1enKrrFxBnMfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D221804147;
	Wed, 23 Jun 2021 07:42:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EE2C5C1A3;
	Wed, 23 Jun 2021 07:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3394B4EA37;
	Wed, 23 Jun 2021 07:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15N7fG2Z008283 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Jun 2021 03:41:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B1C7360CCC; Wed, 23 Jun 2021 07:41:16 +0000 (UTC)
Received: from localhost (ovpn-12-52.pek2.redhat.com [10.72.12.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9C9D60C05;
	Wed, 23 Jun 2021 07:41:15 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 23 Jun 2021 15:40:31 +0800
Message-Id: <20210623074032.1484665-3-ming.lei@redhat.com>
In-Reply-To: <20210623074032.1484665-1-ming.lei@redhat.com>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH V3 2/3] block: add ->poll_bio to
	block_device_operations
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for supporting IO polling for bio based driver.

Add ->poll_bio callback so that bio driver can provide their own logic
for polling bio.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 13 +++++++++----
 block/genhd.c          |  2 ++
 include/linux/blkdev.h |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1e24c71c6738..e585e549c291 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1113,7 +1113,8 @@ EXPORT_SYMBOL(submit_bio);
  */
 int bio_poll(struct bio *bio, unsigned int flags)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct request_queue *q = disk->queue;
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
 	int ret;
 
@@ -1125,10 +1126,14 @@ int bio_poll(struct bio *bio, unsigned int flags)
 
 	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
 		return 0;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		ret = 0;	/* not yet implemented, should not happen */
-	else
+
+	if (queue_is_mq(q))
 		ret = blk_mq_poll(q, cookie, flags);
+	else if (disk->fops->poll_bio)
+		ret = disk->fops->poll_bio(bio, flags);
+	else
+		ret = !WARN_ON_ONCE(1);
+
 	blk_queue_exit(q);
 	return ret;
 }
diff --git a/block/genhd.c b/block/genhd.c
index 5f5628216295..3dfb7d52e280 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -471,6 +471,8 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 {
 	int ret;
 
+	WARN_ON_ONCE(queue_is_mq(disk->queue) && disk->fops->poll_bio);
+
 	/*
 	 * The disk queue should now be all set with enough information about
 	 * the device for the elevator code to pick an adequate default
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fc0ba0b80776..fc63155d2ac4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1858,6 +1858,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
+	int (*poll_bio)(struct bio *bio, unsigned int flags);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

