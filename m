Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A6DC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 08:23:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DADF61184
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 08:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DADF61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-UgpZteaEMcCrTDa4wKEpIg-1; Fri, 16 Apr 2021 04:23:03 -0400
X-MC-Unique: UgpZteaEMcCrTDa4wKEpIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 539861008062;
	Fri, 16 Apr 2021 08:22:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35AB55C5B5;
	Fri, 16 Apr 2021 08:22:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 077E944A5E;
	Fri, 16 Apr 2021 08:22:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G80oxY025492 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 04:00:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 073DCFA731; Fri, 16 Apr 2021 08:00:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1421FED3E
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 08:00:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55EB310334AB
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 08:00:47 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-179-s_14QchoM9m8uSXDeihJWA-1;
	Fri, 16 Apr 2021 04:00:42 -0400
X-MC-Unique: s_14QchoM9m8uSXDeihJWA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UVj6W0l_1618560037
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UVj6W0l_1618560037) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 16 Apr 2021 16:00:37 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: ming.lei@redhat.com, snitzer@redhat.com, axboe@kernel.dk
Date: Fri, 16 Apr 2021 16:00:37 +0800
Message-Id: <20210416080037.26335-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20210401021927.343727-12-ming.lei@redhat.com>
References: <20210401021927.343727-12-ming.lei@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Apr 2021 04:21:18 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] block: introduce QUEUE_FLAG_POLL_CAP flag
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

Hi,
How about this patch to remove the extra poll_capable() method?

And the following 'dm: support IO polling for bio-based dm device' needs
following change.

```
+       /*
+        * Check for request-based device is remained to
+        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
+        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
+        * devices supporting polling.
+        */
+       if (__table_type_bio_based(t->type)) {
+               if (dm_table_supports_poll(t)) {
+                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
+                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+               }
+               else {
+                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
+                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
+               }
+       }
```


Introduce QUEUE_FLAG_POLL_CAP flag, indicating if the device supports IO
polling or not. Thus both blk-mq and bio-based device could set this
flag at the initialization phase, and then only this flag needs to be
checked instead of rechecking if the device has the ability of IO
polling when enabling IO polling via sysfs.

For NVMe, the ability of IO polling may change after RESET, since
nvme.poll_queues module parameter may change. Thus the ability of IO
polling need to be rechecked after RESET.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c           |  5 +++--
 block/blk-sysfs.c        |  3 +--
 drivers/nvme/host/core.c |  2 ++
 include/linux/blk-mq.h   | 12 ++++++++++++
 include/linux/blkdev.h   |  2 ++
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 414f5d99d9de..55ef6b975169 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3227,9 +3227,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	q->tag_set = set;
 
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
-	if (set->nr_maps > HCTX_TYPE_POLL &&
-	    set->map[HCTX_TYPE_POLL].nr_queues)
+	if (blk_mq_poll_capable(set)) {
+		blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
 		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+	}
 
 	q->sg_reserved_size = INT_MAX;
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index db3268d41274..64f0ab84b606 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -426,8 +426,7 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 	unsigned long poll_on;
 	ssize_t ret;
 
-	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
-	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
+	if(!blk_queue_poll_cap(q))
 		return -EINVAL;
 
 	ret = queue_var_store(&poll_on, page, count);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bb7da34dd967..5344cc877b05 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2210,6 +2210,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	ns->lba_shift = id->lbaf[lbaf].ds;
 	nvme_set_queue_limits(ns->ctrl, ns->queue);
 
+	blk_mq_check_poll(ns->disk->queue, ns->disk->queue->tag_set);
+
 	ret = nvme_configure_metadata(ns, id);
 	if (ret)
 		goto out_unfreeze;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2c473c9b8990..ee4c89c8bebc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -618,4 +618,16 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
+static inline bool blk_mq_poll_capable(struct blk_mq_tag_set *set)
+{
+	return set->nr_maps > HCTX_TYPE_POLL &&
+	       set->map[HCTX_TYPE_POLL].nr_queues;
+}
+
+static inline void blk_mq_check_poll(struct request_queue *q,
+				     struct blk_mq_tag_set *set)
+{
+	if (blk_mq_poll_capable(set))
+		blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
+}
 #endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1e88116dc070..d192a106bf40 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -621,6 +621,7 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+#define QUEUE_FLAG_POLL_CAP     30	/* device supports IO polling */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
@@ -668,6 +669,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 #define blk_queue_poll(q)	test_bit(QUEUE_FLAG_POLL, &(q)->queue_flags)
+#define blk_queue_poll_cap(q)	test_bit(QUEUE_FLAG_POLL_CAP, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

