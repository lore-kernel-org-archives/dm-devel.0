Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B46C433E9
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 03:20:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9DAD65098
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 03:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9DAD65098
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615864803;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JTcdCk2Jork8fcv/ey+SihCHDkPyR28rjIrK8eSyg/o=;
	b=C4lc+ioiJzKN3ZMlwbmSKmJGX2ecrX39jlUdK8l236AS4yzeiQoFWmAaDl32bvTpBctWp8
	x1Q5/zic/MXDs6dzl8GQ3q4XE6a/hkovYLLXOcGBnvQ9f++TcpRNT51i9J05ODlCRi2ucx
	DQHyz9VGWLW0CPVwNOPGG8D7W5IY2kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-pq26CnuUOWuGToU-cnF4Lw-1; Mon, 15 Mar 2021 23:20:01 -0400
X-MC-Unique: pq26CnuUOWuGToU-cnF4Lw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AC3281744F;
	Tue, 16 Mar 2021 03:19:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 018601A880;
	Tue, 16 Mar 2021 03:19:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C489A57DC6;
	Tue, 16 Mar 2021 03:19:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12G3JPWi002995 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Mar 2021 23:19:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8C03D614FB; Tue, 16 Mar 2021 03:19:25 +0000 (UTC)
Received: from localhost (ovpn-12-86.pek2.redhat.com [10.72.12.86])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1FC11B472;
	Tue, 16 Mar 2021 03:19:18 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 16 Mar 2021 11:15:23 +0800
Message-Id: <20210316031523.864506-12-ming.lei@redhat.com>
In-Reply-To: <20210316031523.864506-1-ming.lei@redhat.com>
References: <20210316031523.864506-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCH 11/11] dm: support IO polling for bio-based
	dm device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Jeffle Xu <jefflexu@linux.alibaba.com>

IO polling is enabled when all underlying target devices are capable
of IO polling. The sanity check supports the stacked device model, in
which one dm device may be build upon another dm device. In this case,
the mapped device will check if the underlying dm target device
supports IO polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-table.c         | 24 ++++++++++++++++++++++++
 drivers/md/dm.c               | 14 ++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 95391f78b8d5..a8f3575fb118 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1509,6 +1509,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	return !blk_queue_poll(bdev_get_queue(dev->bdev));
+}
+
 /*
  * type->iterate_devices() should be called when the sanity check needs to
  * iterate and check all underlying data devices. iterate_devices() will
@@ -1559,6 +1565,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
 	return 0;
 }
 
+int dm_table_supports_poll(struct dm_table *t)
+{
+	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
+}
+
 /*
  * Check whether a table has no data devices attached using each
  * target's iterate_devices method.
@@ -2079,6 +2090,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 
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
index 50b693d776d6..fe6893b078dc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1720,6 +1720,19 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return ret;
 }
 
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
@@ -3132,6 +3145,7 @@ static const struct pr_ops dm_pr_ops = {
 };
 
 static const struct block_device_operations dm_blk_dops = {
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
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

