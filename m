Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DF8C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:27:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C25261920
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:27:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C25261920
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617031624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=267IpAGHwETRUG+53Zn6mehBx+iUSxvltqbI+ltQ6Hw=;
	b=et9HXt6Aez733Y8qcPqFiHRLVup7D4THEN+Ax4V/pUVlkn0tloviP6WiKxLB+woMu9Gfay
	SDyrd+5Tr7/7tfCe29Ro2tmvdQuNPb6H5Fvqna/ZtBzyP1MmK7wFZ/ggK2YZ30aDWYXoM3
	PkZeyLhoQgG0W7rHRLptjllKvfInMdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-oKbuxh0LMvq4jpDqSfJZCg-1; Mon, 29 Mar 2021 11:27:02 -0400
X-MC-Unique: oKbuxh0LMvq4jpDqSfJZCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49DD51005D54;
	Mon, 29 Mar 2021 15:26:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1097C59441;
	Mon, 29 Mar 2021 15:26:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCA031800216;
	Mon, 29 Mar 2021 15:26:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TFQqMc019327 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 11:26:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2951F60CE6; Mon, 29 Mar 2021 15:26:52 +0000 (UTC)
Received: from localhost (ovpn-12-50.pek2.redhat.com [10.72.12.50])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BEB46061F;
	Mon, 29 Mar 2021 15:26:41 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 29 Mar 2021 23:26:11 +0800
Message-Id: <20210329152622.173035-2-ming.lei@redhat.com>
In-Reply-To: <20210329152622.173035-1-ming.lei@redhat.com>
References: <20210329152622.173035-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [dm-devel] [PATCH V4 01/12] block: add helper of blk_queue_poll
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 block/blk-core.c         | 2 +-
 block/blk-mq.c           | 3 +--
 block/blk-sysfs.c        | 2 +-
 drivers/nvme/host/core.c | 2 +-
 include/linux/blkdev.h   | 1 +
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff208497..a31371d55b9d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_poll(q))
 		bio->bi_opf &= ~REQ_HIPRI;
 
 	switch (bio_op(bio)) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d4d7c1caa439..63c81df3b8b5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3869,8 +3869,7 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	struct blk_mq_hw_ctx *hctx;
 	long state;
 
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_qc_t_valid(cookie) || !blk_queue_poll(q))
 		return 0;
 
 	if (current->plug)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0f4f0c8a7825..db3268d41274 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -417,7 +417,7 @@ static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_poll_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(test_bit(QUEUE_FLAG_POLL, &q->queue_flags), page);
+	return queue_var_show(blk_queue_poll(q), page);
 }
 
 static ssize_t queue_poll_store(struct request_queue *q, const char *page,
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0896e21642be..34b8c78f88e0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -956,7 +956,7 @@ static void nvme_execute_rq_polled(struct request_queue *q,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	WARN_ON_ONCE(!test_bit(QUEUE_FLAG_POLL, &q->queue_flags));
+	WARN_ON_ONCE(!blk_queue_poll(q));
 
 	rq->cmd_flags |= REQ_HIPRI;
 	rq->end_io_data = &wait;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc6bc8383b43..89a01850cf12 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -665,6 +665,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
+#define blk_queue_poll(q)	test_bit(QUEUE_FLAG_POLL, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

