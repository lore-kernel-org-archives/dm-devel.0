Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FC4C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 12:23:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 559C16142F
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 12:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 559C16142F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619094188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0O45x/b2uCE+kEA109zm3+dDwe6josm0kzLNQ9znfLo=;
	b=epLM8o5NWCaxqaVZvV+V3BJWcHTCs8yOHrk9Q+3CSyfIfu2RcHxUYgPaMSdofOsaryEwcM
	iOuIdi15d6pe9nwOypYp41Ct+MYbY9iuK122VUv/uoNwHNts1Mdo8wKeGyJy5pLrIh2y5Y
	z/4SDIRNvrhBoon0W4rerKHpTbUQRV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-blT5Dn1qOiy_CE1QKRmRCQ-1; Thu, 22 Apr 2021 08:23:06 -0400
X-MC-Unique: blT5Dn1qOiy_CE1QKRmRCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05C08192377B;
	Thu, 22 Apr 2021 12:23:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E16BC62688;
	Thu, 22 Apr 2021 12:23:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8840E44A5C;
	Thu, 22 Apr 2021 12:23:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13MCMxMU020950 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 08:22:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B43215C27C; Thu, 22 Apr 2021 12:22:59 +0000 (UTC)
Received: from localhost (ovpn-13-243.pek2.redhat.com [10.72.13.243])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF8965C1D5;
	Thu, 22 Apr 2021 12:22:46 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 22 Apr 2021 20:20:37 +0800
Message-Id: <20210422122038.2192933-12-ming.lei@redhat.com>
In-Reply-To: <20210422122038.2192933-1-ming.lei@redhat.com>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH V6 11/12] block: allow to control FLAG_POLL via
	sysfs for bio poll capable queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for supporting bio based io polling. If one disk is capable of
bio polling, we allow user to control FLAG_POLL via sysfs.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-sysfs.c     | 14 ++++++++++++--
 include/linux/genhd.h |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index fed4981b1f7a..3620db390658 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -430,9 +430,14 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 {
 	unsigned long poll_on;
 	ssize_t ret;
+	struct gendisk *disk = queue_to_disk(q);
 
-	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
-	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
+	if (!queue_is_mq(q) && !(disk->flags & GENHD_FL_CAP_BIO_POLL))
+		return -EINVAL;
+
+	if (queue_is_mq(q) && (!q->tag_set ||
+	    q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
+	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues))
 		return -EINVAL;
 
 	ret = queue_var_store(&poll_on, page, count);
@@ -442,6 +447,11 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 	if (poll_on) {
 		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
 	} else {
+		/*
+		 * For bio queue, it is safe to just freeze bio submission
+		 * activity because we don't read FLAG_POLL after bio is
+		 * submitted.
+		 */
 		blk_mq_freeze_queue(q);
 		blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
 		blk_mq_unfreeze_queue(q);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7e9660ea967d..e5ae77cba853 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -104,6 +104,8 @@ struct partition_meta_info {
 #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	0x0100
 #define GENHD_FL_NO_PART_SCAN			0x0200
 #define GENHD_FL_HIDDEN				0x0400
+/* only valid for bio based disk */
+#define GENHD_FL_CAP_BIO_POLL			0x0800
 
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

