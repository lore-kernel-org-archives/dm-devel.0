Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1BCC433E4
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:20:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7439161A06
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:20:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7439161A06
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616588429;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HeVR61AyeyudH9WLiJPPKlqj3pAOjlHp7zKKtxS+f0g=;
	b=Oy9cULN5Bug2oST8YOCoz8G+s55TbtM99ACXxfFnJWo0BXp2G4YjolgW63lnFG45NfXGzT
	pB03gQ8sQQ0DrZqPH86mnQxvblcfFEit0C9PFL7PAszxSMOq4REDrzo7jdMuH0kdto4eot
	ghaZhgjeoLlbolnvFG/M7PD+cO+SvrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-8WArb8uZN_GJKaQCIOUWAQ-1; Wed, 24 Mar 2021 08:20:27 -0400
X-MC-Unique: 8WArb8uZN_GJKaQCIOUWAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 600C4107ACCD;
	Wed, 24 Mar 2021 12:20:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 380EF5D9D0;
	Wed, 24 Mar 2021 12:20:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2D8D4A7C9;
	Wed, 24 Mar 2021 12:20:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OCKMh3005183 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 08:20:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9E7EE1001281; Wed, 24 Mar 2021 12:20:22 +0000 (UTC)
Received: from localhost (ovpn-13-127.pek2.redhat.com [10.72.13.127])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8AF51048116;
	Wed, 24 Mar 2021 12:20:05 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 24 Mar 2021 20:19:18 +0800
Message-Id: <20210324121927.362525-5-ming.lei@redhat.com>
In-Reply-To: <20210324121927.362525-1-ming.lei@redhat.com>
References: <20210324121927.362525-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [dm-devel] [PATCH V3 04/13] block: create io poll context for
	submission and poll task
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Create per-task io poll context for both IO submission and poll task
if the queue is bio based and supports polling.

This io polling context includes two queues:

1) submission queue(sq) for storing HIPRI bio, written by submission task
   and read by poll task.
2) polling queue(pq) for holding data moved from sq, only used in poll
   context for running bio polling.

Following patches will support bio based io polling.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c          | 71 ++++++++++++++++++++++++++++++++-------
 block/blk-ioc.c           |  1 +
 block/blk-mq.c            | 14 ++++++++
 block/blk.h               | 45 +++++++++++++++++++++++++
 include/linux/iocontext.h |  2 ++
 5 files changed, 121 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d58f8a0c80de..4671bbf31fd3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -792,16 +792,59 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 	return BLK_STS_OK;
 }
 
-static inline void blk_create_io_context(struct request_queue *q)
+static inline struct blk_bio_poll_ctx *blk_get_bio_poll_ctx(void)
 {
-	/*
-	 * Various block parts want %current->io_context, so allocate it up
-	 * front rather than dealing with lots of pain to allocate it only
-	 * where needed. This may fail and the block layer knows how to live
-	 * with it.
-	 */
-	if (unlikely(!current->io_context))
-		create_task_io_context(current, GFP_ATOMIC, q->node);
+	struct io_context *ioc = current->io_context;
+
+	return ioc ? ioc->data : NULL;
+}
+
+static inline unsigned int bio_grp_list_size(unsigned int nr_grps)
+{
+	return sizeof(struct bio_grp_list) + nr_grps *
+		sizeof(struct bio_grp_list_data);
+}
+
+static void bio_poll_ctx_init(struct blk_bio_poll_ctx *pc)
+{
+	pc->sq = (void *)pc + sizeof(*pc);
+	pc->sq->max_nr_grps = BLK_BIO_POLL_SQ_SZ;
+
+	pc->pq = (void *)pc->sq + bio_grp_list_size(BLK_BIO_POLL_SQ_SZ);
+	pc->pq->max_nr_grps = BLK_BIO_POLL_PQ_SZ;
+
+	spin_lock_init(&pc->sq_lock);
+	spin_lock_init(&pc->pq_lock);
+}
+
+void bio_poll_ctx_alloc(struct io_context *ioc)
+{
+	struct blk_bio_poll_ctx *pc;
+	unsigned int size = sizeof(*pc) +
+		bio_grp_list_size(BLK_BIO_POLL_SQ_SZ) +
+		bio_grp_list_size(BLK_BIO_POLL_PQ_SZ);
+
+	pc = kzalloc(GFP_ATOMIC, size);
+	if (pc) {
+		bio_poll_ctx_init(pc);
+		if (cmpxchg(&ioc->data, NULL, (void *)pc))
+			kfree(pc);
+	}
+}
+
+static inline bool blk_queue_support_bio_poll(struct request_queue *q)
+{
+	return !queue_is_mq(q) && blk_queue_poll(q);
+}
+
+static inline void blk_bio_poll_preprocess(struct request_queue *q,
+		struct bio *bio)
+{
+	if (!(bio->bi_opf & REQ_HIPRI))
+		return;
+
+	if (!blk_queue_poll(q) || (!queue_is_mq(q) && !blk_get_bio_poll_ctx()))
+		bio->bi_opf &= ~REQ_HIPRI;
 }
 
 static noinline_for_stack bool submit_bio_checks(struct bio *bio)
@@ -848,10 +891,14 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		}
 	}
 
-	blk_create_io_context(q);
+	/*
+	 * Create per-task io poll ctx if bio polling supported and HIPRI
+	 * set.
+	 */
+	blk_create_io_context(q, blk_queue_support_bio_poll(q) &&
+			(bio->bi_opf & REQ_HIPRI));
 
-	if (!blk_queue_poll(q))
-		bio->bi_opf &= ~REQ_HIPRI;
+	blk_bio_poll_preprocess(q, bio);
 
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index b0cde18c4b8c..5574c398eff6 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -19,6 +19,7 @@ static struct kmem_cache *iocontext_cachep;
 
 static inline void free_io_context(struct io_context *ioc)
 {
+	kfree(ioc->data);
 	kmem_cache_free(iocontext_cachep, ioc);
 }
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 63c81df3b8b5..c832faa52ca0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3852,6 +3852,17 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
+static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	/*
+	 * Create poll queue for storing poll bio and its cookie from
+	 * submission queue
+	 */
+	blk_create_io_context(q, true);
+
+	return 0;
+}
+
 /**
  * blk_poll - poll for IO completions
  * @q:  the queue
@@ -3875,6 +3886,9 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	if (current->plug)
 		blk_flush_plug_list(current->plug, false);
 
+	if (!queue_is_mq(q))
+		return blk_bio_poll(q, cookie, spin);
+
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	/*
diff --git a/block/blk.h b/block/blk.h
index 3b53e44b967e..424949f2226d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -357,4 +357,49 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
 		unsigned int max_sectors, bool *same_page);
 
+/* Grouping bios that share same data into one list */
+struct bio_grp_list_data {
+	void *grp_data;
+
+	/* all bios in this list share same 'grp_data' */
+	struct bio_list list;
+};
+
+struct bio_grp_list {
+	unsigned int max_nr_grps, nr_grps;
+	struct bio_grp_list_data head[0];
+};
+
+struct blk_bio_poll_ctx {
+	spinlock_t sq_lock;
+	struct bio_grp_list *sq;
+
+	spinlock_t pq_lock;
+	struct bio_grp_list *pq;
+};
+
+#define BLK_BIO_POLL_SQ_SZ		16U
+#define BLK_BIO_POLL_PQ_SZ		(BLK_BIO_POLL_SQ_SZ * 2)
+
+void bio_poll_ctx_alloc(struct io_context *ioc);
+
+static inline void blk_create_io_context(struct request_queue *q,
+		bool need_poll_ctx)
+{
+	struct io_context *ioc;
+
+	/*
+	 * Various block parts want %current->io_context, so allocate it up
+	 * front rather than dealing with lots of pain to allocate it only
+	 * where needed. This may fail and the block layer knows how to live
+	 * with it.
+	 */
+	if (unlikely(!current->io_context))
+		create_task_io_context(current, GFP_ATOMIC, q->node);
+
+	ioc = current->io_context;
+	if (need_poll_ctx && unlikely(ioc && !ioc->data))
+		bio_poll_ctx_alloc(ioc);
+}
+
 #endif /* BLK_INTERNAL_H */
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 0a9dc40b7be8..f9a467571356 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -110,6 +110,8 @@ struct io_context {
 	struct io_cq __rcu	*icq_hint;
 	struct hlist_head	icq_list;
 
+	void			*data;
+
 	struct work_struct release_work;
 };
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

