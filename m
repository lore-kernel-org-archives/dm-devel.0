Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD06C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:22:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C61BC61A05
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C61BC61A05
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616588550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j/15/r0K9wiCAgIZrfL/7IyYJDlC5jCHr7qjYC2y/PY=;
	b=BsTasHfUn6T02FyPHJmdIolxs/036Lo7XJJ7r0on+kdLw2c1kh7brW+95sU98nwwcuVwun
	hqvAfMSmLvSgI7Kd6JkUN6R4CFVM6dFhabXxrqbP4TVhh1nl0YtdIx4WPAn0l9QBzRibmW
	4mdLFpOf0YMs2rcjT608IG3oejkkPSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-6JoVrdq0Ma6EfiFmFyKP2Q-1; Wed, 24 Mar 2021 08:22:28 -0400
X-MC-Unique: 6JoVrdq0Ma6EfiFmFyKP2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24C4A1092592;
	Wed, 24 Mar 2021 12:21:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1EA067280;
	Wed, 24 Mar 2021 12:21:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B62434A702;
	Wed, 24 Mar 2021 12:21:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OCLk2f005503 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 08:21:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BD82A2B0D9; Wed, 24 Mar 2021 12:21:46 +0000 (UTC)
Received: from localhost (ovpn-13-127.pek2.redhat.com [10.72.13.127])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13BF953B2F;
	Wed, 24 Mar 2021 12:21:45 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 24 Mar 2021 20:19:26 +0800
Message-Id: <20210324121927.362525-13-ming.lei@redhat.com>
In-Reply-To: <20210324121927.362525-1-ming.lei@redhat.com>
References: <20210324121927.362525-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH V3 12/13] block: add poll_capable method to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Jeffle Xu <jefflexu@linux.alibaba.com>

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
index 0f4f0c8a7825..367c1d9a55c6 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
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
index bfab74b45f15..a46f975f2a2f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1881,6 +1881,7 @@ struct block_device_operations {
 	int (*report_zones)(struct gendisk *, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
 	char *(*devnode)(struct gendisk *disk, umode_t *mode);
+	bool (*poll_capable)(struct gendisk *disk);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

