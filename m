Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450DFC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AEA92068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AEA92068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-e7_MfvFUMgaY8MVUHL8Kbw-1; Mon, 04 Jan 2021 14:03:47 -0500
X-MC-Unique: e7_MfvFUMgaY8MVUHL8Kbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0DC51842173;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C14095D9D5;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 911621809CAC;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNBQZXP019550 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 06:26:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 26B3E110E988; Wed, 23 Dec 2020 11:26:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22C93110E987
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 11:26:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F40C3800296
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 11:26:33 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-460-W0fIvdmhOfOWxIxPkH-fLg-1;
	Wed, 23 Dec 2020 06:26:31 -0500
X-MC-Unique: W0fIvdmhOfOWxIxPkH-fLg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UJXS7XL_1608722785
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UJXS7XL_1608722785) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 23 Dec 2020 19:26:25 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Wed, 23 Dec 2020 19:26:20 +0800
Message-Id: <20201223112624.78955-4-jefflexu@linux.alibaba.com>
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH RFC 3/7] block: add iopoll method for non-mq
	device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") for supporting non-mq queues such as
nvme multipath, but removed in commit 529262d56dbe ("block: remove
->poll_fn").

To add support of IO polling for non-mq device, this method need to be
back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
struct block_device_operations") has moved all callbacks into struct
block_device_operations in gendisk, we also add the new method named
->iopoll in block_device_operations.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c         | 70 +++++--------------------------------
 include/linux/blk-mq.h |  3 ++
 include/linux/blkdev.h |  1 +
 4 files changed, 92 insertions(+), 61 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd7f071..2f5c51ce32e3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	/* TODO: bio-based device doesn't support hybrid poll. */
+	if (!queue_is_mq(q))
+		return false;
+
+	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+	if (blk_mq_poll_hybrid(q, hctx, cookie))
+		return true;
+
+	hctx->poll_considered++;
+	return false;
+}
+
+/**
+ * blk_poll - poll for IO completions
+ * @q:  the queue
+ * @cookie: cookie passed back at IO submission time
+ * @spin: whether to spin for completions
+ *
+ * Description:
+ *    Poll for completions on the passed in queue. Returns number of
+ *    completed entries found. If @spin is true, then blk_poll will continue
+ *    looping until at least one completion is found, unless the task is
+ *    otherwise marked running (or we need to reschedule).
+ */
+int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	long state;
+
+	if (!blk_qc_t_valid(cookie) ||
+	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+		return 0;
+
+	if (current->plug)
+		blk_flush_plug_list(current->plug, false);
+
+	/*
+	 * If we sleep, have the caller restart the poll loop to reset
+	 * the state. Like for the other success return cases, the
+	 * caller is responsible for checking if the IO completed. If
+	 * the IO isn't complete, we'll get called again and will go
+	 * straight to the busy poll loop. If specified not to spin,
+	 * we also should not sleep.
+	 */
+	if (spin && blk_poll_hybrid(q, cookie))
+		return 1;
+
+	state = current->state;
+	do {
+		int ret;
+		struct gendisk *disk = queue_to_disk(q);
+
+		if (disk->fops->iopoll)
+			ret = disk->fops->iopoll(q, cookie);
+		else
+			ret = blk_mq_poll(q, cookie);
+		if (ret > 0) {
+			__set_current_state(TASK_RUNNING);
+			return ret;
+		}
+
+		if (signal_pending_state(state, current))
+			__set_current_state(TASK_RUNNING);
+
+		if (current->state == TASK_RUNNING)
+			return 1;
+		if (ret < 0 || !spin)
+			break;
+		cpu_relax();
+	} while (!need_resched());
+
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_poll);
+
 /**
  * blk_cloned_rq_check_limits - Helper function to check a cloned request
  *                              for the new queue limits
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b09ce00cc6af..85258958e9f1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3818,8 +3818,8 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
 	return true;
 }
 
-static bool blk_mq_poll_hybrid(struct request_queue *q,
-			       struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
+bool blk_mq_poll_hybrid(struct request_queue *q,
+			struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
 {
 	struct request *rq;
 
@@ -3843,72 +3843,20 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
-/**
- * blk_poll - poll for IO completions
- * @q:  the queue
- * @cookie: cookie passed back at IO submission time
- * @spin: whether to spin for completions
- *
- * Description:
- *    Poll for completions on the passed in queue. Returns number of
- *    completed entries found. If @spin is true, then blk_poll will continue
- *    looping until at least one completion is found, unless the task is
- *    otherwise marked running (or we need to reschedule).
- */
-int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
 {
+	int ret;
 	struct blk_mq_hw_ctx *hctx;
-	long state;
-
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
-		return 0;
-
-	if (current->plug)
-		blk_flush_plug_list(current->plug, false);
 
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset
-	 * the state. Like for the other success return cases, the
-	 * caller is responsible for checking if the IO completed. If
-	 * the IO isn't complete, we'll get called again and will go
-	 * straight to the busy poll loop. If specified not to spin,
-	 * we also should not sleep.
-	 */
-	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
-		return 1;
-
-	hctx->poll_considered++;
+	hctx->poll_invoked++;
+	ret = q->mq_ops->poll(hctx);
+	if (ret > 0)
+		hctx->poll_success++;
 
-	state = current->state;
-	do {
-		int ret;
-
-		hctx->poll_invoked++;
-
-		ret = q->mq_ops->poll(hctx);
-		if (ret > 0) {
-			hctx->poll_success++;
-			__set_current_state(TASK_RUNNING);
-			return ret;
-		}
-
-		if (signal_pending_state(state, current))
-			__set_current_state(TASK_RUNNING);
-
-		if (current->state == TASK_RUNNING)
-			return 1;
-		if (ret < 0 || !spin)
-			break;
-		cpu_relax();
-	} while (!need_resched());
-
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(blk_poll);
 
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 47b021952ac7..032e08ecd42e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,6 +607,9 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
+bool blk_mq_poll_hybrid(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2303d06a5a82..e8965879eb90 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1845,6 +1845,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
+	int (*iopoll)(struct request_queue *q, blk_qc_t cookie);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

