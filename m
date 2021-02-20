Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54C0C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:51:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 209F064E77
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 209F064E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-dbJOTWXIOWuRy1EMYIQP3g-1; Mon, 22 Feb 2021 03:51:43 -0500
X-MC-Unique: dbJOTWXIOWuRy1EMYIQP3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53C1518449FC;
	Mon, 22 Feb 2021 08:51:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C4F63CC5;
	Mon, 22 Feb 2021 08:51:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F21F718095CE;
	Mon, 22 Feb 2021 08:51:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11KB6pxT010440 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 20 Feb 2021 06:06:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8FB8D121156; Sat, 20 Feb 2021 11:06:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A75913E790
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 721041022F09
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:51 +0000 (UTC)
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-404-a7jetn46OQmywrhwhyzV4Q-1;
	Sat, 20 Feb 2021 06:06:47 -0500
X-MC-Unique: a7jetn46OQmywrhwhyzV4Q-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UP1XFxp_1613819201
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UP1XFxp_1613819201) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 20 Feb 2021 19:06:42 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Sat, 20 Feb 2021 19:06:29 +0800
Message-Id: <20210220110637.50305-5-jefflexu@linux.alibaba.com>
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 22 Feb 2021 03:49:50 -0500
Cc: caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, ming.lei@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 04/12] block: add poll_capable method to
	support bio-based IO polling
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

This method can be used to check if bio-based device supports IO polling
or not. For mq devices, checking for hw queue in polling mode is
adequate, while the sanity check shall be implementation specific for
bio-based devices. For example, dm device needs to check if all
underlying devices are capable of IO polling.

Though bio-based device may have done the sanity check during the
device initialization phase, cacheing the result of this sanity check
(such as by cacheing in the queue_flags) may not work. Because for dm
devices, users could change the state of the underlying devices through
'/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
the cached result of the very beginning sanity check could be
out-of-date. Thus the sanity check needs to be done every time 'io_poll'
is to be modified.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-sysfs.c      | 14 +++++++++++---
 include/linux/blkdev.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..f11fedefc37d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -420,9 +420,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 	unsigned long poll_on;
 	ssize_t ret;
 
-	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
-	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
-		return -EINVAL;
+	if (queue_is_mq(q)) {
+		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
+		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
+			return -EINVAL;
+	} else {
+		struct gendisk *disk = queue_to_disk(q);
+
+		if (!disk->fops->poll_capable ||
+		    !disk->fops->poll_capable(disk))
+			return -EINVAL;
+	}
 
 	ret = queue_var_store(&poll_on, page, count);
 	if (ret < 0)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebe16f55cba4..8a84088642ce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1854,6 +1854,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
 	int (*poll)(struct request_queue *q, blk_qc_t cookie);
+	bool (*poll_capable)(struct gendisk *disk);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

