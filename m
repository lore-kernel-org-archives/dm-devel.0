Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEBDC47092
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:00:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2869661376
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2869661376
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-xxHHIitwMZa__GhdFy1r9g-1; Wed, 02 Jun 2021 03:00:04 -0400
X-MC-Unique: xxHHIitwMZa__GhdFy1r9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DB486D4E0;
	Wed,  2 Jun 2021 07:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 290E15D9D0;
	Wed,  2 Jun 2021 07:00:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C80C644A59;
	Wed,  2 Jun 2021 06:59:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1526xwxE017860 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 02:59:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7CA8B21602A8; Wed,  2 Jun 2021 06:59:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7873321602A6
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:59:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7D2810504A2
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:59:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-118-K2TU8d0ZMbefRAm2evLyfw-1; Wed, 02 Jun 2021 02:59:54 -0400
X-MC-Unique: K2TU8d0ZMbefRAm2evLyfw-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKlL-0025I2-Rr; Wed, 02 Jun 2021 06:54:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:17 +0300
Message-Id: <20210602065345.355274-3-hch@lst.de>
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Geoff Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 02/30] blk-mq: improve the
	blk_mq_init_allocated_queue interface
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

Don't return the passed in request_queue but a normal error code, and
drop the elevator_init argument in favor of just calling elevator_init_mq
directly from dm-rq.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c           | 36 ++++++++++++++----------------------
 block/blk.h              |  1 -
 block/elevator.c         |  2 +-
 drivers/md/dm-rq.c       |  9 +++------
 include/linux/blk-mq.h   |  5 ++---
 include/linux/elevator.h |  1 +
 6 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index eaacfa963a73..6112741e1ff9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3115,21 +3115,18 @@ void blk_mq_release(struct request_queue *q)
 struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
 		void *queuedata)
 {
-	struct request_queue *uninit_q, *q;
+	struct request_queue *q;
+	int ret;
 
-	uninit_q = blk_alloc_queue(set->numa_node);
-	if (!uninit_q)
+	q = blk_alloc_queue(set->numa_node);
+	if (!q)
 		return ERR_PTR(-ENOMEM);
-	uninit_q->queuedata = queuedata;
-
-	/*
-	 * Initialize the queue without an elevator. device_add_disk() will do
-	 * the initialization.
-	 */
-	q = blk_mq_init_allocated_queue(set, uninit_q, false);
-	if (IS_ERR(q))
-		blk_cleanup_queue(uninit_q);
-
+	q->queuedata = queuedata;
+	ret = blk_mq_init_allocated_queue(set, q);
+	if (ret) {
+		blk_cleanup_queue(q);
+		return ERR_PTR(ret);
+	}
 	return q;
 }
 EXPORT_SYMBOL_GPL(blk_mq_init_queue_data);
@@ -3273,9 +3270,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 	mutex_unlock(&q->sysfs_lock);
 }
 
-struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-						  struct request_queue *q,
-						  bool elevator_init)
+int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
+		struct request_queue *q)
 {
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
@@ -3325,11 +3321,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
-
-	if (elevator_init)
-		elevator_init_mq(q);
-
-	return q;
+	return 0;
 
 err_hctxs:
 	kfree(q->queue_hw_ctx);
@@ -3340,7 +3332,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	q->poll_cb = NULL;
 err_exit:
 	q->mq_ops = NULL;
-	return ERR_PTR(-ENOMEM);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
diff --git a/block/blk.h b/block/blk.h
index 3440142f029b..d3fa47af3607 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -192,7 +192,6 @@ void blk_account_io_done(struct request *req, u64 now);
 
 void blk_insert_flush(struct request *rq);
 
-void elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
 void __elevator_exit(struct request_queue *, struct elevator_queue *);
diff --git a/block/elevator.c b/block/elevator.c
index 440699c28119..06e203426410 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -693,7 +693,7 @@ void elevator_init_mq(struct request_queue *q)
 		elevator_put(e);
 	}
 }
-
+EXPORT_SYMBOL_GPL(elevator_init_mq); /* only for dm-rq */
 
 /*
  * switch to new_e io scheduler. be careful not to introduce deadlocks -
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9c3bc3711b33..0dbd48cbdff9 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -530,7 +530,6 @@ static const struct blk_mq_ops dm_mq_ops = {
 
 int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 {
-	struct request_queue *q;
 	struct dm_target *immutable_tgt;
 	int err;
 
@@ -557,12 +556,10 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	if (err)
 		goto out_kfree_tag_set;
 
-	q = blk_mq_init_allocated_queue(md->tag_set, md->queue, true);
-	if (IS_ERR(q)) {
-		err = PTR_ERR(q);
+	err = blk_mq_init_allocated_queue(md->tag_set, md->queue);
+	if (err)
 		goto out_tag_set;
-	}
-
+	elevator_init_mq(md->queue);
 	return 0;
 
 out_tag_set:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bb950fc669ef..73750b2838d2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -429,9 +429,8 @@ enum {
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
 struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
 		void *queuedata);
-struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-						  struct request_queue *q,
-						  bool elevator_init);
+int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
+		struct request_queue *q);
 struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,
 						const struct blk_mq_ops *ops,
 						unsigned int queue_depth,
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index dcb2f9022c1d..783ecb3cb77a 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -120,6 +120,7 @@ extern void elv_merged_request(struct request_queue *, struct request *,
 extern bool elv_attempt_insert_merge(struct request_queue *, struct request *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
+void elevator_init_mq(struct request_queue *q);
 
 /*
  * io scheduler registration
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

