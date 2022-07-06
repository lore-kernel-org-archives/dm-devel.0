Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5436BC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657102212;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=87QJCVJARaB+TqrylKZ5A/kMSlqy6NNtid295o0V5LA=;
	b=JU0utWdb2Sd2URj0eyZYhS8SqTNPT2IeweSwstV8hdiSxTP95GjMGKC5FnkLTlrSQgtPZ/
	PbPgfgnphefLITYmayGwqTAKXKsW2dZHa+minQEEUQ1VUF8PyJ9KmHYSPqF68rCHjJP+Ed
	Ie1NAHacUo/QMQdvWc4KPzTEDLVRhLQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-Pj8a8cHyNmCQe-km6di8vg-1; Wed, 06 Jul 2022 06:10:09 -0400
X-MC-Unique: Pj8a8cHyNmCQe-km6di8vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C5603C0D862;
	Wed,  6 Jul 2022 10:10:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED11F2026D64;
	Wed,  6 Jul 2022 10:10:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B58ED1947063;
	Wed,  6 Jul 2022 10:10:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9084F194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 10:10:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60E5640315A; Wed,  6 Jul 2022 10:10:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D3E7492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 10:10:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45CF13C0D85E
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 10:10:05 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-byxZORIWPEytkCfCoWcKJQ-1; Wed, 06 Jul 2022 06:10:03 -0400
X-MC-Unique: byxZORIWPEytkCfCoWcKJQ-1
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8z4t-006uty-J4; Wed, 06 Jul 2022 07:04:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Wed,  6 Jul 2022 09:03:38 +0200
Message-Id: <20220706070350.1703384-5-hch@lst.de>
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 04/16] block: simplify blk_mq_plug
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, linux-scsi@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Drop the unused q argument, and invert the check to move the exception
into a branch and the regular path as the normal return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-core.c  |  2 +-
 block/blk-merge.c |  2 +-
 block/blk-mq.c    |  2 +-
 block/blk-mq.h    | 18 ++++++++----------
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6bcca0b686de4..bc16e9bae2dc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,7 +719,7 @@ void submit_bio_noacct(struct bio *bio)
 
 	might_sleep();
 
-	plug = blk_mq_plug(q, bio);
+	plug = blk_mq_plug(bio);
 	if (plug && plug->nowait)
 		bio->bi_opf |= REQ_NOWAIT;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f5f42ebd0bb0..5abf5aa5a5f0e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1051,7 +1051,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	struct blk_plug *plug;
 	struct request *rq;
 
-	plug = blk_mq_plug(q, bio);
+	plug = blk_mq_plug(bio);
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 15c7c5c4ad222..dc714dff73001 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2804,7 +2804,7 @@ static void bio_set_ioprio(struct bio *bio)
 void blk_mq_submit_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct blk_plug *plug = blk_mq_plug(q, bio);
+	struct blk_plug *plug = blk_mq_plug(bio);
 	const int is_sync = op_is_sync(bio->bi_opf);
 	struct request *rq;
 	unsigned int nr_segs = 1;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 31d75a83a562d..e694ec67d646a 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -294,7 +294,6 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
 
 /*
  * blk_mq_plug() - Get caller context plug
- * @q: request queue
  * @bio : the bio being submitted by the caller context
  *
  * Plugging, by design, may delay the insertion of BIOs into the elevator in
@@ -305,23 +304,22 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
  * order. While this is not a problem with regular block devices, this ordering
  * change can cause write BIO failures with zoned block devices as these
  * require sequential write patterns to zones. Prevent this from happening by
- * ignoring the plug state of a BIO issuing context if the target request queue
- * is for a zoned block device and the BIO to plug is a write operation.
+ * ignoring the plug state of a BIO issuing context if it is for a zoned block
+ * device and the BIO to plug is a write operation.
  *
  * Return current->plug if the bio can be plugged and NULL otherwise
  */
-static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
-					   struct bio *bio)
+static inline struct blk_plug *blk_mq_plug( struct bio *bio)
 {
+	/* Zoned block device write operation case: do not plug the BIO */
+	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
+		return NULL;
+
 	/*
 	 * For regular block devices or read operations, use the context plug
 	 * which may be NULL if blk_start_plug() was not executed.
 	 */
-	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
-		return current->plug;
-
-	/* Zoned block device write operation case: do not plug the BIO */
-	return NULL;
+	return current->plug;
 }
 
 /* Free all requests on the list */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

