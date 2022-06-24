Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D57C43334
	for <dm-devel@archiver.kernel.org>; Fri, 24 Jun 2022 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656080291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xlAuXivqrMl66udl0Q1X4FxHYiXyFFQgsSI8lfUZjdM=;
	b=RznFHhL251t2HvOlslKaKZLnlUofu5ynwL3cgIZ1m4gL/uWsOWaBA3Fr0o+fX7jRfDFylJ
	dAN0W6GVzLof61AYART2AWw3Pt5AT/I6RD2qWg5zCRNzplOJvKByD5+rONW0BqJ+Rt+P79
	2XZsPrUv0pyjZO0AKJqiCMw2BHE+Xjc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-xZ3Q6tIeM_OQQzYo_eq_qw-1; Fri, 24 Jun 2022 10:17:08 -0400
X-MC-Unique: xZ3Q6tIeM_OQQzYo_eq_qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECC881010361;
	Fri, 24 Jun 2022 14:14:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA9A4C08087;
	Fri, 24 Jun 2022 14:14:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E360194B94C;
	Fri, 24 Jun 2022 14:14:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78BDD194B946
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Jun 2022 14:14:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58AF340CFD0B; Fri, 24 Jun 2022 14:14:43 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6A99540CFD0A;
 Fri, 24 Jun 2022 14:14:41 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>
Date: Fri, 24 Jun 2022 22:12:54 +0800
Message-Id: <20220624141255.2461148-4-ming.lei@redhat.com>
In-Reply-To: <20220624141255.2461148-1-ming.lei@redhat.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 5.20 3/4] dm: improve handling for DM_REQUEUE and
 AGAIN
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In case that BLK_STS_DM_REQUEUE is returned or BLK_STS_AGAIN is returned
for POLLED io, we requeue the original bio into deferred list and
request md->wq to re-submit it to block layer.

Improve the handling in the following way:

1) unify handling for BLK_STS_DM_REQUEUE and BLK_STS_AGAIN, and clear
REQ_POLLED for BLK_STS_DM_REQUEUE too, for the sake of simplicity,
given BLK_STS_DM_REQUEUE is very unusual

2) queue md->wq explicitly in __dm_io_complete(), so requeue handling
becomes more robust

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 58 +++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a9e5e429c150..ee22c763873f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -884,20 +884,39 @@ static int __noflush_suspending(struct mapped_device *md)
 	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 }
 
-static void dm_handle_requeue(struct dm_io *io)
+/* Return true if the original bio is requeued */
+static bool dm_handle_requeue(struct dm_io *io)
 {
-	if (io->status == BLK_STS_DM_REQUEUE) {
-		struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
-		struct mapped_device *md = io->md;
+	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	bool need_requeue = (io->status == BLK_STS_DM_REQUEUE);
+	bool handle_eagain = (io->status == BLK_STS_AGAIN) &&
+		(bio->bi_opf & REQ_POLLED);
+	struct mapped_device *md = io->md;
+	bool requeued = false;
+
+	if (need_requeue || handle_eagain) {
 		unsigned long flags;
+
+		if (bio->bi_opf & REQ_POLLED) {
+			/*
+			 * Upper layer won't help us poll split bio
+			 * (io->orig_bio may only reflect a subset of the
+			 * pre-split original) so clear REQ_POLLED in case
+			 * of requeue.
+			 */
+			bio_clear_polled(bio);
+		}
+
 		/*
 		 * Target requested pushing back the I/O.
 		 */
 		spin_lock_irqsave(&md->deferred_lock, flags);
-		if (__noflush_suspending(md) &&
-		    !WARN_ON_ONCE(dm_is_zone_write(md, bio))) {
+		if ((__noflush_suspending(md) &&
+		    !WARN_ON_ONCE(dm_is_zone_write(md, bio))) ||
+				handle_eagain) {
 			/* NOTE early return due to BLK_STS_DM_REQUEUE below */
 			bio_list_add_head(&md->deferred, bio);
+			requeued = true;
 		} else {
 			/*
 			 * noflush suspend was interrupted or this is
@@ -907,6 +926,10 @@ static void dm_handle_requeue(struct dm_io *io)
 		}
 		spin_unlock_irqrestore(&md->deferred_lock, flags);
 	}
+
+	if (requeued)
+		queue_work(md->wq, &md->work);
+	return requeued;
 }
 
 static void dm_io_complete(struct dm_io *io)
@@ -914,8 +937,9 @@ static void dm_io_complete(struct dm_io *io)
 	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
 	struct mapped_device *md = io->md;
 	blk_status_t io_error;
+	bool requeued;
 
-	dm_handle_requeue(io);
+	requeued = dm_handle_requeue(io);
 
 	io_error = io->status;
 	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
@@ -936,23 +960,9 @@ static void dm_io_complete(struct dm_io *io)
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
 
-	if (io_error == BLK_STS_DM_REQUEUE || io_error == BLK_STS_AGAIN) {
-		if (bio->bi_opf & REQ_POLLED) {
-			/*
-			 * Upper layer won't help us poll split bio (io->orig_bio
-			 * may only reflect a subset of the pre-split original)
-			 * so clear REQ_POLLED in case of requeue.
-			 */
-			bio_clear_polled(bio);
-			if (io_error == BLK_STS_AGAIN) {
-				/* io_uring doesn't handle BLK_STS_AGAIN (yet) */
-				queue_io(md, bio);
-				return;
-			}
-		}
-		if (io_error == BLK_STS_DM_REQUEUE)
-			return;
-	}
+	/* We have requeued, so return now */
+	if (requeued)
+		return;
 
 	if (bio_is_flush_with_data(bio)) {
 		/*
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

