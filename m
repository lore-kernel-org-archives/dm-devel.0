Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADACC433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C13DF64F42
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C13DF64F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-jZoox6hyOduXW5qAxO2LTQ-1; Thu, 04 Mar 2021 09:42:12 -0500
X-MC-Unique: jZoox6hyOduXW5qAxO2LTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C309CCC631;
	Thu,  4 Mar 2021 14:42:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A49E91412A;
	Thu,  4 Mar 2021 14:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5804D1809C8D;
	Thu,  4 Mar 2021 14:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123Bw4Va003407 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 06:58:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5A25D2018746; Wed,  3 Mar 2021 11:58:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 557362018740
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C6E586E929
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:04 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-2-redCQwvWM-Oe-g2g6876yQ-1;
	Wed, 03 Mar 2021 06:57:59 -0500
X-MC-Unique: redCQwvWM-Oe-g2g6876yQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UQGHkCe_1614772672
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQGHkCe_1614772672) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 03 Mar 2021 19:57:52 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: msnitzer@redhat.com, axboe@kernel.dk
Date: Wed,  3 Mar 2021 19:57:39 +0800
Message-Id: <20210303115740.127001-12-jefflexu@linux.alibaba.com>
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Thu, 04 Mar 2021 09:41:43 -0500
Cc: caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v5 11/12] block: sub-fastpath for bio-based
	polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Offer one sub-fastpath for bio-based polling when bio submitted to dm
device gets split and enqueued into multiple hw queues, while the IO
submission process has not been migrated to another CPU.

In this case, the IO submission routine will return the CPU number on
which the IO submission happened as the returned cookie, while the
polling routine will only iterate and poll on hw queues that this CPU
number maps, instead of iterating *all* hw queues.

This optimization can dramatically reduce cache ping-pong and thus
improve the polling performance, when multiple hw queues in polling mode
per device could be reserved when there are multiple polling processes.

It will fall back to iterating all hw queues in polling mode, once the
process has ever been migrated to another CPU during the IO submission
phase.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c          | 18 ++++++++++++++++--
 include/linux/blk_types.h | 38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e5cd4ff08f5c..5479fd74d3be 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -948,7 +948,8 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
 	struct request_queue *top_q;
-	bool poll_on;
+	bool orig_poll_on, poll_on;
+	u64 old_nr_migrations;
 
 	BUG_ON(bio->bi_next);
 
@@ -958,6 +959,8 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	top_q = bio->bi_bdev->bd_disk->queue;
 	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
 		  (bio->bi_opf & REQ_HIPRI);
+	orig_poll_on = poll_on;
+	old_nr_migrations = READ_ONCE(current->se.nr_migrations);
 
 	do {
 		blk_qc_t cookie;
@@ -987,7 +990,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 				ret = cookie;
 			} else if (ret != cookie) {
 				/* bio gets split and enqueued to multi hctxs */
-				ret = BLK_QC_T_BIO_POLL_ALL;
+				ret = blk_qc_t_get_by_cpu();
 				poll_on = false;
 			}
 		}
@@ -1014,6 +1017,17 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 
 	current->bio_list = NULL;
 
+	/*
+	 * For cases when bio gets split and enqueued into multi hctxs, return
+	 * the corresponding CPU number when current process has not been
+	 * migrated to another CPU. Return BLK_QC_T_BIO_POLL_ALL otherwise,
+	 * falling back to iterating and polling on all hw queues, since split
+	 * bios are submitted to different CPUs in this case.
+	 */
+	if (orig_poll_on != poll_on &&
+	    old_nr_migrations != READ_ONCE(current->se.nr_migrations))
+		ret = BLK_QC_T_BIO_POLL_ALL;
+
 	return ret;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8f970e026be9..32de4fb79eff 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -555,8 +555,21 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  *                         ^
  *                         reserved for compatibility with mq
  *
- * 2. When @bio gets split and enqueued into multi hw queues, the returned
- *    cookie is just BLK_QC_T_BIO_POLL_ALL flag.
+ * 2. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has *not* been migrated to another CPU, the returned cookie
+ *    actually stores the corresponding CPU number on which the IO submission
+ *    happened. Also with BLK_QC_T_BIO_POLL_CPU flag set.
+ *
+ * 63                    31                         0 (bit)
+ * +----------------------+-----------------------+-+
+ * |          cpu         |                       |1|
+ * +----------------------+-----------------------+-+
+ *                                                 ^
+ *                                                 BLK_QC_T_BIO_POLL_CPU
+ *
+ * 3. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has ever been migrated to another CPU, the returned cookie is just
+ *    BLK_QC_T_BIO_POLL_ALL flag.
  *
  * 63                                              0 (bit)
  * +----------------------------------------------+-+
@@ -565,7 +578,7 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  *                                                 ^
  *                                                 BLK_QC_T_BIO_POLL_ALL
  *
- * 3. Otherwise, return BLK_QC_T_NONE as the cookie.
+ * 4. Otherwise, return BLK_QC_T_NONE as the cookie.
  *
  * 63                                              0 (bit)
  * +-----------------------------------------------+
@@ -574,12 +587,18 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  */
 #define BLK_QC_T_HIGH_SHIFT	32
 #define BLK_QC_T_BIO_POLL_ALL	1U
+#define BLK_QC_T_BIO_POLL_CPU	2U
 
 static inline unsigned int blk_qc_t_to_devt(blk_qc_t cookie)
 {
 	return cookie >> BLK_QC_T_HIGH_SHIFT;
 }
 
+static inline unsigned int blk_qc_t_to_cpu(blk_qc_t cookie)
+{
+	return cookie >> BLK_QC_T_HIGH_SHIFT;
+}
+
 static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
 					    unsigned int queue_num)
 {
@@ -587,9 +606,20 @@ static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
 	       (queue_num << BLK_QC_T_SHIFT);
 }
 
+static inline blk_qc_t blk_qc_t_get_by_cpu(void)
+{
+	return ((blk_qc_t)raw_smp_processor_id() << BLK_QC_T_HIGH_SHIFT) |
+	       BLK_QC_T_BIO_POLL_CPU;
+}
+
 static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
 {
-	return cookie & BLK_QC_T_BIO_POLL_ALL;
+	return cookie & (BLK_QC_T_BIO_POLL_ALL | BLK_QC_T_BIO_POLL_CPU);
+}
+
+static inline bool blk_qc_t_is_poll_cpu(blk_qc_t cookie)
+{
+	return cookie & BLK_QC_T_BIO_POLL_CPU;
 }
 
 struct blk_rq_stat {
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

