Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B35C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A315F64F44
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A315F64F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-EmD0w7F5OBypKaUA-VudDA-1; Thu, 04 Mar 2021 09:42:12 -0500
X-MC-Unique: EmD0w7F5OBypKaUA-VudDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 162FA108BD1D;
	Thu,  4 Mar 2021 14:42:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE21C175BB;
	Thu,  4 Mar 2021 14:42:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B189057DC3;
	Thu,  4 Mar 2021 14:42:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123Bw9od003426 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 06:58:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 714321445347; Wed,  3 Mar 2021 11:58:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C98C1445354
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5512087B2B3
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:09 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-280-ZHXjtuKxMlCgiViJrQf8_Q-1;
	Wed, 03 Mar 2021 06:58:05 -0500
X-MC-Unique: ZHXjtuKxMlCgiViJrQf8_Q-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R621e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UQGMHnb_1614772673
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQGMHnb_1614772673) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 03 Mar 2021 19:57:53 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: msnitzer@redhat.com, axboe@kernel.dk
Date: Wed,  3 Mar 2021 19:57:40 +0800
Message-Id: <20210303115740.127001-13-jefflexu@linux.alibaba.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Mar 2021 09:41:43 -0500
Cc: caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v5 12/12] dm: support IO polling for bio-based dm
	device
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

IO polling is enabled when all underlying target devices are capable
of IO polling. The sanity check supports the stacked device model, in
which one dm device may be build upon another dm device. In this case,
the mapped device will check if the underlying dm target device
supports IO polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-table.c         | 26 ++++++++++++
 drivers/md/dm.c               | 74 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 101 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 95391f78b8d5..ed72349eb1db 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1982,6 +1982,19 @@ static int device_requires_stable_pages(struct dm_target *ti,
 	return blk_queue_stable_writes(q);
 }
 
+static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
+}
+
+int dm_table_supports_poll(struct dm_table *t)
+{
+	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -2079,6 +2092,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 
 	dm_update_keyslot_manager(q, t);
 	blk_queue_update_readahead(q);
+
+	/*
+	 * Check for request-based device is remained to
+	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
+	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
+	 * devices supporting polling.
+	 */
+	if (__table_type_bio_based(t->type)) {
+		if (dm_table_supports_poll(t))
+			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+		else
+			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
+	}
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f1b76203b3c7..3f3f47d66386 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1714,6 +1714,78 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+struct dm_poll_data {
+	blk_qc_t cookie;
+	int count;
+};
+
+static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
+			   sector_t start, sector_t len, void *data)
+{
+	struct dm_poll_data *pdata = data;
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	if (queue_is_mq(q)) {
+		struct blk_mq_hw_ctx *hctx;
+		int i, cpu;
+
+		if (!percpu_ref_tryget(&q->q_usage_counter))
+			return 0;
+
+		if (blk_qc_t_is_poll_cpu(pdata->cookie)) {
+			cpu = blk_qc_t_to_cpu(pdata->cookie);
+			hctx = blk_mq_get_hctx(q, cpu, REQ_HIPRI);
+			pdata->count += blk_mq_poll_hctx(q, hctx);
+		} else {
+			queue_for_each_poll_hw_ctx(q, hctx, i)
+				pdata->count += blk_mq_poll_hctx(q, hctx);
+		}
+
+		percpu_ref_put(&q->q_usage_counter);
+	} else {
+		struct gendisk *disk = dev->bdev->bd_disk;
+
+		pdata->count += disk->fops->poll(q, pdata->cookie);
+	}
+
+	return 0;
+}
+
+static int dm_bio_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	int i, srcu_idx;
+	struct dm_table *t;
+	struct dm_target *ti;
+	struct mapped_device *md = queue_to_disk(q)->private_data;
+	struct dm_poll_data pdata = {
+		.cookie = cookie,
+	};
+
+	t = dm_get_live_table(md, &srcu_idx);
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+		ti->type->iterate_devices(ti, dm_poll_one_dev, &pdata);
+	}
+
+	dm_put_live_table(md, srcu_idx);
+
+	return pdata.count;
+}
+
+static bool dm_bio_poll_capable(struct gendisk *disk)
+{
+	int ret, srcu_idx;
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *t;
+
+	t = dm_get_live_table(md, &srcu_idx);
+	ret = dm_table_supports_poll(t);
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -3126,6 +3198,8 @@ static const struct pr_ops dm_pr_ops = {
 };
 
 static const struct block_device_operations dm_blk_dops = {
+	.poll = dm_bio_poll,
+	.poll_capable = dm_bio_poll_capable,
 	.submit_bio = dm_submit_bio,
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7f4ac87c0b32..31bfd6f70013 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -538,6 +538,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
 fmode_t dm_table_get_mode(struct dm_table *t);
 struct mapped_device *dm_table_get_md(struct dm_table *t);
 const char *dm_table_device_name(struct dm_table *t);
+int dm_table_supports_poll(struct dm_table *t);
 
 /*
  * Trigger an event.
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

