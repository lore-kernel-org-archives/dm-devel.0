Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E770C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAA0364D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA0364D9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-xEbcTQY7OFKZ79h_7N7y7A-1; Wed, 17 Feb 2021 10:35:27 -0500
X-MC-Unique: xEbcTQY7OFKZ79h_7N7y7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECBF079EC1;
	Wed, 17 Feb 2021 15:35:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB5D15C1A3;
	Wed, 17 Feb 2021 15:35:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98A0557DFC;
	Wed, 17 Feb 2021 15:35:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1188r0pc030049 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 03:53:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A6F5F200E1F2; Mon,  8 Feb 2021 08:53:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1EDE2026D46
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 901A1858F18
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:00 +0000 (UTC)
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-168-rqIJFaJnM-euJzUcWRt8aw-1;
	Mon, 08 Feb 2021 03:52:58 -0500
X-MC-Unique: rqIJFaJnM-euJzUcWRt8aw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UO9soA7_1612774373
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UO9soA7_1612774373) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 08 Feb 2021 16:52:53 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Mon,  8 Feb 2021 16:52:41 +0800
Message-Id: <20210208085243.82367-10-jefflexu@linux.alibaba.com>
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v3 09/11] dm: support IO polling for bio-based dm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM will iterate and poll all polling hardware queues of all target mq
devices when polling IO for dm device. To mitigate the race introduced
by iterating all target hw queues, a per-hw-queue flag is maintained
to indicate whether this polling hw queue currently being polled on or
not. Every polling hw queue is exclusive to one polling instance, i.e.,
the polling instance will skip this polling hw queue if this hw queue
currently is being polled by another polling instance, and start
polling on the next hw queue.

IO polling is enabled when all underlying target devices are capable
of IO polling. The sanity check supports the stacked device model, in
which one dm device may be build upon another dm device. In this case,
the mapped device will check if the underlying dm target device
supports IO polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-table.c         | 26 ++++++++++++++
 drivers/md/dm.c               | 64 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 91 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index aa37f3e82238..b090b4c9692d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1764,6 +1764,19 @@ static int device_requires_stable_pages(struct dm_target *ti,
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
+	return dm_table_all_devs_attr(t, device_not_poll_capable, NULL);
+}
+
 /*
  * type->iterate_devices() should be called when the sanity check needs to
  * iterate and check all underlying data devices. iterate_devices() will
@@ -1875,6 +1888,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
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
index c2945c90745e..8423f1347bb8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1657,6 +1657,68 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+static int dm_poll_one_md(struct mapped_device *md);
+
+static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	int i, *count = data;
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct blk_mq_hw_ctx *hctx;
+
+	if (queue_is_mq(q)) {
+		if (!percpu_ref_tryget(&q->q_usage_counter))
+			return 0;
+
+		queue_for_each_poll_hw_ctx(q, hctx, i)
+			*count += blk_mq_poll_hctx(q, hctx);
+
+		percpu_ref_put(&q->q_usage_counter);
+	} else
+		*count += dm_poll_one_md(dev->bdev->bd_disk->private_data);
+
+	return 0;
+}
+
+static int dm_poll_one_md(struct mapped_device *md)
+{
+	int i, srcu_idx, ret = 0;
+	struct dm_table *t;
+	struct dm_target *ti;
+
+	t = dm_get_live_table(md, &srcu_idx);
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+		ti->type->iterate_devices(ti, dm_poll_one_dev, &ret);
+	}
+
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
+static int dm_bio_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct gendisk *disk = queue_to_disk(q);
+	struct mapped_device *md = disk->private_data;
+
+	return dm_poll_one_md(md);
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
@@ -3049,6 +3111,8 @@ static const struct pr_ops dm_pr_ops = {
 };
 
 static const struct block_device_operations dm_blk_dops = {
+	.poll = dm_bio_poll,
+	.poll_capable = dm_bio_poll_capable,
 	.submit_bio = dm_submit_bio,
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..6a9de3fd0087 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -515,6 +515,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
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

