Return-Path: <SRS0=X5vH=D3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0B8C433DF
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 533852222F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 533852222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-zo0C_pUhPfqJz7NP_08vmg-1; Tue, 20 Oct 2020 04:22:52 -0400
X-MC-Unique: zo0C_pUhPfqJz7NP_08vmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A9E1006C8D;
	Tue, 20 Oct 2020 08:22:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 570E96EF45;
	Tue, 20 Oct 2020 08:22:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F27488C7BC;
	Tue, 20 Oct 2020 08:22:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09K6sYoQ002613 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Oct 2020 02:54:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5CA5E200E1F0; Tue, 20 Oct 2020 06:54:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 581302028DC0
	for <dm-devel@redhat.com>; Tue, 20 Oct 2020 06:54:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 032B91823613
	for <dm-devel@redhat.com>; Tue, 20 Oct 2020 06:54:32 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-11-j0iLe4tJPQuABhFR1vq2hA-1;
	Tue, 20 Oct 2020 02:54:28 -0400
X-MC-Unique: j0iLe4tJPQuABhFR1vq2hA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UCcdPoy_1603176861
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UCcdPoy_1603176861) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 20 Oct 2020 14:54:21 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Tue, 20 Oct 2020 14:54:19 +0800
Message-Id: <20201020065420.124885-3-jefflexu@linux.alibaba.com>
In-Reply-To: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 20 Oct 2020 04:22:10 -0400
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com,
	xiaoguang.wang@linux.alibaba.com
Subject: [dm-devel] [RFC 2/3] block: add back ->poll_fn in request queue
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a prep for adding support of IO polling for dm device.

->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") for supporting non-mq queues such as
nvme multipath, but removed in commit 529262d56dbe ("block: remove
->poll_fn").

To add support of IO polling for dm device, support for non-mq device
should be added and thus we need ->poll_fn back.

commit c62b37d96b6e ("block: move ->make_request_fn to struct
block_device_operations") moved all callbacks into struct
block_device_operations in gendisk. But ->poll_fn can't be moved there
since there's no way to fetch the corresponding gendisk from
request_queue.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         | 30 ++++++++++++++++++++++++------
 include/linux/blkdev.h |  3 +++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 696450257ac1..b521ab01eaf3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -43,6 +43,7 @@
 
 static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
 
+static int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
 static void blk_mq_poll_stats_start(struct request_queue *q);
 static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
 
@@ -3212,6 +3213,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 
 	q->tag_set = set;
 
+	if (q->mq_ops->poll)
+		q->poll_fn = blk_mq_poll;
+
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 	if (set->nr_maps > HCTX_TYPE_POLL &&
 	    set->map[HCTX_TYPE_POLL].nr_queues)
@@ -3856,7 +3860,8 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	if (current->plug)
 		blk_flush_plug_list(current->plug, false);
 
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+	hctx = queue_is_mq(q) ?
+		q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)] : NULL;
 
 	/*
 	 * If we sleep, have the caller restart the poll loop to reset
@@ -3864,21 +3869,26 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	 * caller is responsible for checking if the IO completed. If
 	 * the IO isn't complete, we'll get called again and will go
 	 * straight to the busy poll loop.
+	 *
+	 * Currently dm doesn't support hybrid polling.
 	 */
-	if (blk_mq_poll_hybrid(q, hctx, cookie))
+	if (hctx && blk_mq_poll_hybrid(q, hctx, cookie))
 		return 1;
 
-	hctx->poll_considered++;
+	if (hctx)
+		hctx->poll_considered++;
 
 	state = current->state;
 	do {
 		int ret;
 
-		hctx->poll_invoked++;
+		if (hctx)
+			hctx->poll_invoked++;
 
-		ret = q->mq_ops->poll(hctx);
+		ret = q->poll_fn(q, cookie);
 		if (ret > 0) {
-			hctx->poll_success++;
+			if (hctx)
+				hctx->poll_success++;
 			__set_current_state(TASK_RUNNING);
 			return ret;
 		}
@@ -3898,6 +3908,14 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 }
 EXPORT_SYMBOL_GPL(blk_poll);
 
+static int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+	return q->mq_ops->poll(hctx);
+}
+
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 639cae2c158b..d05684449893 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -288,6 +288,8 @@ static inline unsigned short req_get_ioprio(struct request *req)
 
 struct blk_queue_ctx;
 
+typedef int (poll_q_fn) (struct request_queue *q, blk_qc_t);
+
 struct bio_vec;
 
 enum blk_eh_timer_return {
@@ -486,6 +488,7 @@ struct request_queue {
 
 	struct blk_stat_callback	*poll_cb;
 	struct blk_rq_stat	poll_stat[BLK_MQ_POLL_STATS_BKTS];
+	poll_q_fn		*poll_fn;
 
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

