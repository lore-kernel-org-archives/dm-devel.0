Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB27C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 08:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641801604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Je4LE7jhjzmn58LXdVXXBuliq3xca16XWNoejoKKFVM=;
	b=dP4UfeS/uboe0J84XS8a5Uk5qrkJ9srWqwyLAWUHdfYl2r8oiLpa/7nIAwi+6EsZB0MKcS
	9MZQVLa4LptLP3oE64qmBDuoaEMa8S2JtDVB+iqjxnFPxBYslXEUIbtwUnW+YpkRP9w2qr
	2M/fopr///zQbWHqOYis0rjY/H9yGxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-sGSgdBYbMeazVFBXNv9QjQ-1; Mon, 10 Jan 2022 02:57:27 -0500
X-MC-Unique: sGSgdBYbMeazVFBXNv9QjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B10121006AA9;
	Mon, 10 Jan 2022 07:57:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91955104B4C6;
	Mon, 10 Jan 2022 07:57:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68C181809CBA;
	Mon, 10 Jan 2022 07:57:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20A7qQ9f015286 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 02:52:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B03A5F92D; Mon, 10 Jan 2022 07:52:26 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CADAB5ED4F;
	Mon, 10 Jan 2022 07:52:25 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Mon, 10 Jan 2022 15:51:40 +0800
Message-Id: <20220110075141.389532-2-ming.lei@redhat.com>
In-Reply-To: <20220110075141.389532-1-ming.lei@redhat.com>
References: <20220110075141.389532-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, lining <lining2020x@163.com>,
	Tejun Heo <tj@kernel.org>, Chunguang Xu <brookxu@tencent.com>
Subject: [dm-devel] [PATCH 1/2] block: add resubmit_bio_noacct()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add block layer API of resubmit_bio_noacct() for handling blk-throttle
iops limit correctly. Typical use case is that bio split, and it isn't
good to export blk_throtl_charge_bio_split() for drivers, so add new API
for serving such purpose.

Cc: lining <lining2020x@163.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chunguang Xu <brookxu@tencent.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 12 ++++++++++++
 block/blk-merge.c      |  4 +---
 include/linux/blkdev.h |  1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd029c86d6ac..733fec7dc5d6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -910,6 +910,18 @@ void submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
+/*
+ * Usually for submitting one bio which has been checked by
+ * submit_bio_checks already. The typical use case is for handling
+ * blk-throttle iops limit correctly.
+ */
+void resubmit_bio_noacct(struct bio *bio)
+{
+	submit_bio_noacct(bio);
+	blk_throtl_charge_bio_split(bio);
+}
+EXPORT_SYMBOL(resubmit_bio_noacct);
+
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4de34a332c9f..acc786d872e6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -366,10 +366,8 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
 
 		bio_chain(split, *bio);
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
-		submit_bio_noacct(*bio);
+		resubmit_bio_noacct(*bio);
 		*bio = split;
-
-		blk_throtl_charge_bio_split(*bio);
 	}
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 22746b2d6825..cce2db9fae1f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -600,6 +600,7 @@ static inline unsigned int blk_queue_depth(struct request_queue *q)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 void submit_bio_noacct(struct bio *bio);
+void resubmit_bio_noacct(struct bio *bio);
 
 extern int blk_lld_busy(struct request_queue *q);
 extern void blk_queue_split(struct bio **);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

