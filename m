Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 661B8C43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656539867;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=miGgQZNBkFdPzCDQ8UtvfUnJ5kS5RW6eIcsk4VUltHI=;
	b=BZu9AcoNbzL09jO1rpkIz5uyQZ2gBkngwbvlG/gvS3O4H8tSJgoDFNs8r4TqyF8L//pNQD
	OPLN4suRhmkTmRBmXeG7+sgpu+hp3CrDpEHZIARFpaYjcrYIWG1PKwthwAEcqbmzkGWtt8
	ATFZOPpjlbwVnu7S+1Bc1+qxdUYRJ3Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-Zf6CuLtGP9ulJOxDs_6IMQ-1; Wed, 29 Jun 2022 17:57:44 -0400
X-MC-Unique: Zf6CuLtGP9ulJOxDs_6IMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51EB085A581;
	Wed, 29 Jun 2022 21:57:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41DD41121314;
	Wed, 29 Jun 2022 21:57:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC54E19378DE;
	Wed, 29 Jun 2022 21:57:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 517EA1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 21:55:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D2B3492CA3; Wed, 29 Jun 2022 21:55:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 291A2492C3B
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11B863C0CD4F
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:18 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Zyz3b-aBPmyCxwnf8jRiZA-1; Wed, 29 Jun 2022 17:55:16 -0400
X-MC-Unique: Zyz3b-aBPmyCxwnf8jRiZA-1
Received: by mail-qv1-f48.google.com with SMTP id u14so24292260qvv.2
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 14:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=aea/5SE2fqdgOQZcTcu0s6QMHRrZWr3dDOv9618JjIw=;
 b=174zF6aPHZWICKecq2LHgVYsSlsAM5YCkuGMDaYan2XQibC6ztZHN2a2l1u+l+7Mlo
 SCcapELi5SDM2dGHPsg+cv37NXxcW6KaovAKs/Bk6UQ21zQz+0qJBDJeai6Hhfks7nkJ
 as/aDoEoZbswlQoCR1hREAJLamohhsp0D9hQMQzeccJEllS4F3kWBAB/+X8PZXj3BA8i
 fb6+exTvgRIOU+ctdPOl/UeE3OQcLXWf+QmVgHlJo8vs0oGs6KfdGSvM13i1f3JD3nub
 RCXg3wIlqdzJqctqNSGxixND0TXpT7PssHRmuMIn7VI0UJyPVyzOfKxDeeUfRwDyLUIb
 9XvQ==
X-Gm-Message-State: AJIora/bDz2Yr43gjcXLqGoHWqQBTj+QZM/u16iQ+itA4f8KAoFcxbOF
 NhARz5KFJ1zP0bklSUCVuS2jPDU=
X-Google-Smtp-Source: AGRyM1viI+CzApaPiScSoPhn3qnTdzxpeun+Zl6mSNYXOZ5ELYg64jnA9NzY6PKXq79JEpKAbuW0fw==
X-Received: by 2002:ac8:7f16:0:b0:31b:f6dd:abf with SMTP id
 f22-20020ac87f16000000b0031bf6dd0abfmr4475170qtk.523.1656539715930; 
 Wed, 29 Jun 2022 14:55:15 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 v22-20020ac87496000000b003051f450049sm11532659qtq.8.2022.06.29.14.55.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 14:55:15 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Date: Wed, 29 Jun 2022 17:55:11 -0400
Message-Id: <20220629215513.37860-2-snitzer@kernel.org>
In-Reply-To: <20220629215513.37860-1-snitzer@kernel.org>
References: <20220629215513.37860-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 5.20 v2 1/3] dm: improve BLK_STS_DM_REQUEUE and
 BLK_STS_AGAIN handling
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
 Kent Overstreet <kent.overstreet@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Eric Biggers <ebiggers@google.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Ming Lei <ming.lei@redhat.com>

If either BLK_STS_DM_REQUEUE or BLK_STS_AGAIN is returned for POLLED
io, we requeue the original bio into deferred list and kick md->wq to
re-submit it to block layer.

Improve the handling in the following way:

1) Factor out dm_handle_requeue() for handling dm_io requeue.

2) Unify handling for BLK_STS_DM_REQUEUE and BLK_STS_AGAIN: clear
   REQ_POLLED for BLK_STS_DM_REQUEUE too, for the sake of simplicity,
   given BLK_STS_DM_REQUEUE is very unusual.

3) Queue md->wq explicitly in dm_handle_requeue(), so requeue handling
   becomes more robust.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 70 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 84929bd137d0..c987f9ad24a4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -880,22 +880,41 @@ static int __noflush_suspending(struct mapped_device *md)
 	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 }
 
-static void dm_io_complete(struct dm_io *io)
+/*
+ * Return true if the dm_io's original bio is requeued.
+ * io->status is updated with error if requeue disallowed.
+ */
+static bool dm_handle_requeue(struct dm_io *io)
 {
-	blk_status_t io_error;
-	struct mapped_device *md = io->md;
 	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	bool handle_requeue = (io->status == BLK_STS_DM_REQUEUE);
+	bool handle_polled_eagain = ((io->status == BLK_STS_AGAIN) &&
+				     (bio->bi_opf & REQ_POLLED));
+	struct mapped_device *md = io->md;
+	bool requeued = false;
 
-	if (io->status == BLK_STS_DM_REQUEUE) {
+	if (handle_requeue || handle_polled_eagain) {
 		unsigned long flags;
+
+		if (bio->bi_opf & REQ_POLLED) {
+			/*
+			 * Upper layer won't help us poll split bio
+			 * (io->orig_bio may only reflect a subset of the
+			 * pre-split original) so clear REQ_POLLED.
+			 */
+			bio_clear_polled(bio);
+		}
+
 		/*
-		 * Target requested pushing back the I/O.
+		 * Target requested pushing back the I/O or
+		 * polled IO hit BLK_STS_AGAIN.
 		 */
 		spin_lock_irqsave(&md->deferred_lock, flags);
-		if (__noflush_suspending(md) &&
-		    !WARN_ON_ONCE(dm_is_zone_write(md, bio))) {
-			/* NOTE early return due to BLK_STS_DM_REQUEUE below */
+		if ((__noflush_suspending(md) &&
+		     !WARN_ON_ONCE(dm_is_zone_write(md, bio))) ||
+		    handle_polled_eagain) {
 			bio_list_add_head(&md->deferred, bio);
+			requeued = true;
 		} else {
 			/*
 			 * noflush suspend was interrupted or this is
@@ -906,6 +925,21 @@ static void dm_io_complete(struct dm_io *io)
 		spin_unlock_irqrestore(&md->deferred_lock, flags);
 	}
 
+	if (requeued)
+		queue_work(md->wq, &md->work);
+
+	return requeued;
+}
+
+static void dm_io_complete(struct dm_io *io)
+{
+	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	struct mapped_device *md = io->md;
+	blk_status_t io_error;
+	bool requeued;
+
+	requeued = dm_handle_requeue(io);
+
 	io_error = io->status;
 	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
 		dm_end_io_acct(io);
@@ -925,23 +959,9 @@ static void dm_io_complete(struct dm_io *io)
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
+	/* Return early if the original bio was requeued */
+	if (requeued)
+		return;
 
 	if (bio_is_flush_with_data(bio)) {
 		/*
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

