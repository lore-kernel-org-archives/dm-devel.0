Return-Path: <SRS0=pEh8=LR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834C7C4743C
	for <dm-devel@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2BBBB6128C
	for <dm-devel@archiver.kernel.org>; Wed, 23 Jun 2021 07:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BBBB6128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624434129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KnM5isQukCikJIZkG5vtnFmFYgnrf4Pht1BrtBc0QNY=;
	b=VyyRH8PUpLu0SA+M1lSQPQ+5LNMTtr+bszwvoSyJZWVALbO5O/VHymgB0EUY4wdKjM/1O2
	haKhviUgn02ydwMBj8syYkCvw5HD3KGEw3wvhzDa5trKQg0vLNjg5tVtgwWaNiAPqiErGQ
	PvhchFkIDRIDczAojsQnoyIix2YwtbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-dVrpBh0PO4yPoTFYmUCsqw-1; Wed, 23 Jun 2021 03:42:08 -0400
X-MC-Unique: dVrpBh0PO4yPoTFYmUCsqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AAAB100C665;
	Wed, 23 Jun 2021 07:42:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1559C5D6D7;
	Wed, 23 Jun 2021 07:42:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD6424EA29;
	Wed, 23 Jun 2021 07:42:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15N7fCJW008270 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Jun 2021 03:41:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1E8460C05; Wed, 23 Jun 2021 07:41:12 +0000 (UTC)
Received: from localhost (ovpn-12-52.pek2.redhat.com [10.72.12.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AA2E60C13;
	Wed, 23 Jun 2021 07:41:01 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 23 Jun 2021 15:40:30 +0800
Message-Id: <20210623074032.1484665-2-ming.lei@redhat.com>
In-Reply-To: <20210623074032.1484665-1-ming.lei@redhat.com>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH V3 1/3] block: add helper of blk_queue_poll
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There has been 3 users, and will be more, so add one such helper.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c         | 5 ++---
 block/blk-sysfs.c        | 4 ++--
 drivers/nvme/host/core.c | 2 +-
 include/linux/blkdev.h   | 1 +
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 531176578221..1e24c71c6738 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -835,7 +835,7 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_poll(q))
 		bio->bi_opf &= ~REQ_POLLED;
 
 	switch (bio_op(bio)) {
@@ -1117,8 +1117,7 @@ int bio_poll(struct bio *bio, unsigned int flags)
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
 	int ret;
 
-	if (cookie == BLK_QC_T_NONE ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (cookie == BLK_QC_T_NONE || !blk_queue_poll(q))
 		return 0;
 
 	if (current->plug)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f78e73ca6091..93dcf2dfaafd 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -422,13 +422,13 @@ static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_poll_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(test_bit(QUEUE_FLAG_POLL, &q->queue_flags), page);
+	return queue_var_show(blk_queue_poll(q), page);
 }
 
 static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 				size_t count)
 {
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_poll(q))
 		return -EINVAL;
 	pr_info_ratelimited("writes to the poll attribute are ignored.\n");
 	pr_info_ratelimited("please use driver specific parameters instead.\n");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fe0b8da3de7f..e31c7704ef4d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1025,7 +1025,7 @@ static void nvme_execute_rq_polled(struct request_queue *q,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	WARN_ON_ONCE(!test_bit(QUEUE_FLAG_POLL, &q->queue_flags));
+	WARN_ON_ONCE(!blk_queue_poll(q));
 
 	rq->cmd_flags |= REQ_POLLED;
 	rq->end_io_data = &wait;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 561b04117bd4..fc0ba0b80776 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -677,6 +677,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
+#define blk_queue_poll(q)	test_bit(QUEUE_FLAG_POLL, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

