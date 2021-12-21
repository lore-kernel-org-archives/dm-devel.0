Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7243C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 21 Dec 2021 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640096172;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Lgud5inCptvFs2IZ7POMTstZ/nlcM1O5+SkOS1NXzfo=;
	b=EeWP6sIMNhpZ9y+sZi1N32mEYcqXISHUm+Kt6Sic3Gt+MQDV33kdr2KZTEK7UAlbgHT0a+
	2NR/PGuI28M8puWNKQjxxTDh+IkYqAbGFfLBrhA3RLTowoV2nODnbgd9ebaRpHbCncSUW5
	Mvs3EyAMDW5jW9jr5SS4zfibwk/Fzbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-gAO07PaTMC64zhHF-AVSrw-1; Tue, 21 Dec 2021 09:16:09 -0500
X-MC-Unique: gAO07PaTMC64zhHF-AVSrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F95F801B25;
	Tue, 21 Dec 2021 14:16:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC5110911AA;
	Tue, 21 Dec 2021 14:16:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93E6D1806D1C;
	Tue, 21 Dec 2021 14:16:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BLEG2EF006192 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 21 Dec 2021 09:16:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DB737519BA; Tue, 21 Dec 2021 14:16:02 +0000 (UTC)
Received: from localhost (ovpn-8-30.pek2.redhat.com [10.72.8.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9E715DF3A;
	Tue, 21 Dec 2021 14:15:38 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 21 Dec 2021 22:14:57 +0800
Message-Id: <20211221141459.1368176-2-ming.lei@redhat.com>
In-Reply-To: <20211221141459.1368176-1-ming.lei@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [dm-devel] [PATCH 1/3] block: split having srcu from queue blocking
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now we reuse queue flag of QUEUE_FLAG_HAS_SRCU for both having srcu and
BLK_MQ_F_BLOCKING. Actually they are two things: one is that srcu is
allocated inside queue, another is that we need to handle blocking
->queue_rq. So far this way works as expected.

dm-rq needs to set BLK_MQ_F_BLOCKING if any underlying queue is
marked as BLK_MQ_F_BLOCKING. But dm queue is allocated before tagset
is allocated, one doable way is to always allocate SRCU for dm
queue, then set BLK_MQ_F_BLOCKING for the tagset if it is required,
meantime we can mark the request queue as supporting blocking
->queue_rq.

So add one new flag of QUEUE_FLAG_BLOCKING for supporting blocking
->queue_rq only, and use one private field to describe if request
queue has allocated srcu instance.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 2 +-
 block/blk-mq.c         | 6 +++---
 block/blk-mq.h         | 2 +-
 block/blk-sysfs.c      | 2 +-
 include/linux/blkdev.h | 5 +++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 10619fd83c1b..7ba806a4e779 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -449,7 +449,7 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 		return NULL;
 
 	if (alloc_srcu) {
-		blk_queue_flag_set(QUEUE_FLAG_HAS_SRCU, q);
+		q->has_srcu = true;
 		if (init_srcu_struct(q->srcu) != 0)
 			goto fail_q;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0d7c9d3e0329..1408a6b8ccdc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -259,7 +259,7 @@ EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue_nowait);
  */
 void blk_mq_wait_quiesce_done(struct request_queue *q)
 {
-	if (blk_queue_has_srcu(q))
+	if (blk_queue_blocking(q))
 		synchronize_srcu(q->srcu);
 	else
 		synchronize_rcu();
@@ -4024,8 +4024,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q)
 {
-	WARN_ON_ONCE(blk_queue_has_srcu(q) !=
-			!!(set->flags & BLK_MQ_F_BLOCKING));
+	if (set->flags & BLK_MQ_F_BLOCKING)
+		blk_queue_flag_set(QUEUE_FLAG_BLOCKING, q);
 
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 948791ea2a3e..9601918e2034 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -377,7 +377,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 /* run the code block in @dispatch_ops with rcu/srcu read lock held */
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
-	if (!blk_queue_has_srcu(q)) {				\
+	if (!blk_queue_blocking(q)) {				\
 		rcu_read_lock();				\
 		(dispatch_ops);					\
 		rcu_read_unlock();				\
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e20eadfcf5c8..af89fabb58e3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -736,7 +736,7 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 	struct request_queue *q = container_of(rcu_head, struct request_queue,
 					       rcu_head);
 
-	kmem_cache_free(blk_get_queue_kmem_cache(blk_queue_has_srcu(q)), q);
+	kmem_cache_free(blk_get_queue_kmem_cache(q->has_srcu), q);
 }
 
 /* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c80cfaefc0a8..d84abdb294c4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -365,6 +365,7 @@ struct request_queue {
 #endif
 
 	bool			mq_sysfs_init_done;
+	bool			has_srcu;
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
@@ -385,7 +386,7 @@ struct request_queue {
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
 #define QUEUE_FLAG_DYING	1	/* queue being torn down */
-#define QUEUE_FLAG_HAS_SRCU	2	/* SRCU is allocated */
+#define QUEUE_FLAG_BLOCKING	2	/* ->queue_rq may block */
 #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
@@ -423,7 +424,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
-#define blk_queue_has_srcu(q)	test_bit(QUEUE_FLAG_HAS_SRCU, &(q)->queue_flags)
+#define blk_queue_blocking(q)	test_bit(QUEUE_FLAG_BLOCKING, &(q)->queue_flags)
 #define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_init_done(q)	test_bit(QUEUE_FLAG_INIT_DONE, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

