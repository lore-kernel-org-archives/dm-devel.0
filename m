Return-Path: <SRS0=X5vH=D3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A1EC43457
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C0B132222F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0B132222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-w4yZQkDKMeqhrcY8UVEurQ-1; Tue, 20 Oct 2020 04:22:53 -0400
X-MC-Unique: w4yZQkDKMeqhrcY8UVEurQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4072F8049CB;
	Tue, 20 Oct 2020 08:22:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F17F1000232;
	Tue, 20 Oct 2020 08:22:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4E26181A050;
	Tue, 20 Oct 2020 08:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09K6sVSj002598 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Oct 2020 02:54:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2DFFE2166B44; Tue, 20 Oct 2020 06:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 291F22166B28
	for <dm-devel@redhat.com>; Tue, 20 Oct 2020 06:54:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7F00100B165
	for <dm-devel@redhat.com>; Tue, 20 Oct 2020 06:54:28 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-131-Hf1Z4D3zNSeW2e0lzfGP1A-1;
	Tue, 20 Oct 2020 02:54:26 -0400
X-MC-Unique: Hf1Z4D3zNSeW2e0lzfGP1A-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UCd5jTt_1603176861
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UCd5jTt_1603176861) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 20 Oct 2020 14:54:22 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Tue, 20 Oct 2020 14:54:20 +0800
Message-Id: <20201020065420.124885-4-jefflexu@linux.alibaba.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 20 Oct 2020 04:22:10 -0400
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com,
	xiaoguang.wang@linux.alibaba.com
Subject: [dm-devel] [RFC 3/3] dm: add support for IO polling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Design of cookie is initially constrained as a per-bio concept. It
dosn't work well when bio-split needed, and it is really an issue when
adding support of iopoll for dm devices.

The current algorithm implementation is simple. The returned cookie of
dm device is actually not used since it is just the cookie of one of
the cloned bios. Polling of dm device is actually polling on all
hardware queues (in poll mode) of all underlying target devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-core.h  |  1 +
 drivers/md/dm-table.c | 30 ++++++++++++++++++++++++++++++
 drivers/md/dm.c       | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index d522093cb39d..f18e066beffe 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -187,4 +187,5 @@ extern atomic_t dm_global_event_nr;
 extern wait_queue_head_t dm_global_eventq;
 void dm_issue_global_event(void);
 
+int dm_io_poll(struct request_queue *q, blk_qc_t cookie);
 #endif
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ce543b761be7..634b79842519 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1809,6 +1809,31 @@ static bool dm_table_requires_stable_pages(struct dm_table *t)
 	return false;
 }
 
+static int device_not_support_poll(struct dm_target *ti, struct dm_dev *dev,
+					   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !(q->queue_flags & QUEUE_FLAG_POLL);
+}
+
+bool dm_table_supports_poll(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	/* Ensure that all targets support DAX. */
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_support_poll, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1901,6 +1926,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
 	blk_queue_update_readahead(q);
+
+	if (dm_table_supports_poll(t)) {
+		q->poll_fn = dm_io_poll;
+		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+	}
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c18fc2548518..4eceaf87ffd4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1666,6 +1666,45 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return ret;
 }
 
+static int dm_poll_one_dev(struct request_queue *q, blk_qc_t cookie)
+{
+	/* Iterate polling on all polling queues for mq device */
+	if (queue_is_mq(q)) {
+		struct blk_mq_hw_ctx *hctx;
+		int i, ret = 0;
+
+		if (!percpu_ref_tryget(&q->q_usage_counter))
+			return 0;
+
+		queue_for_each_poll_hw_ctx(q, hctx, i) {
+			ret += q->mq_ops->poll(hctx);
+		}
+
+		percpu_ref_put(&q->q_usage_counter);
+		return ret;
+	} else
+		return q->poll_fn(q, cookie);
+}
+
+int dm_io_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct mapped_device *md = q->queuedata;
+	struct dm_table *table;
+	struct dm_dev_internal *dd;
+	int srcu_idx;
+	int ret = 0;
+
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!table)
+		goto out;
+
+	list_for_each_entry(dd, dm_table_get_devices(table), list)
+		ret += dm_poll_one_dev(bdev_get_queue(dd->dm_dev->bdev), cookie);
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

