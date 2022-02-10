Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234E7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532849;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QxvrEVQLkhqyX9M05Vmlq+9LF/Uu5oE2KTWgAvhv3YU=;
	b=doLXA9FJyF5TITxX+aWu7cBUilIh+fW4FS08SWEE9KbpbSWn4+Sm7MuLYmPteg9fWaSqSC
	MgRITFRuvCudrJ5iUGBTQd5Pi/zATXeSNsZ3ns1bxsNvhYgaOcE+PEaGrB265N03tP+5uc
	7DdtSp4QtoNghpKxshgKCyieoN5LeUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-4pjTriowN9iDiLMycXJgiQ-1; Thu, 10 Feb 2022 17:40:45 -0500
X-MC-Unique: 4pjTriowN9iDiLMycXJgiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 612E1100D691;
	Thu, 10 Feb 2022 22:40:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46D205BC22;
	Thu, 10 Feb 2022 22:40:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DAAB4CA93;
	Thu, 10 Feb 2022 22:40:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMctpg014880 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6BC2A492D51; Thu, 10 Feb 2022 22:38:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68036492D47
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5016880120D
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:55 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-nsckbaLSMmitnfEiNSHWqw-1; Thu, 10 Feb 2022 17:38:54 -0500
X-MC-Unique: nsckbaLSMmitnfEiNSHWqw-1
Received: by mail-qk1-f199.google.com with SMTP id
	q5-20020ae9dc05000000b00507225deac5so4579436qkf.5
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=64mfGr+BkNDL/qyiDObOyXjA+jYS7+jce6ArkgUIKnM=;
	b=zHu2PzTGjaj32A06R2BlXEC9CWdH+u/sldvMqcuSL/YSU4DClYQR9anpU5jwraJYnt
	r9FsQnguiEw1qIQFFVOdrL36u8bvKqD/iLExtqxsWW6/BGfgDoB5VNu73SojKnWBAaq9
	Hqf//d21wU+9vtz/P5flRnIcjYYk0ybP867lopbog1A71tJ5zbVh2qbnDaqQytNmjno2
	QH/HUeY0rrN++pVVz+lhkuywyaOfX+fe6mxr3JlojcW/OgetgkOq+AbKPpqDpDGLokUa
	48AyeyC6UUKUnnpbetoDrCZ50CHbRnniGO6N4nhMhuD/F0O73ueQTNXGNeC69hdu1Sc+
	1GiQ==
X-Gm-Message-State: AOAM533RcoMxIJFOxOs8/b1WR6uIgxt3as8oCgBceK9DoDWiCY3tqWVL
	b+jeAn7d2ILfLcobIYcjcwD1DpA+9LqSjsiXcXtQTigiYdgNPYjzxHIAKBqrdZxr/+5m1uWFNRY
	kTr455fBGbBEKtgfkSUQndRsM0oBKzxVh33DsTPrbnyBkzRaHE5AyQNXqA1T5go7B9A==
X-Received: by 2002:a05:622a:1303:: with SMTP id
	v3mr6633038qtk.294.1644532733483; 
	Thu, 10 Feb 2022 14:38:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiq9A/dl8/a5+pxZQ8CSXaYG/GlW7bPYTGMKHlZVSuct7m0MfGG+eetHtVr60p3O6UF0//mw==
X-Received: by 2002:a05:622a:1303:: with SMTP id
	v3mr6633025qtk.294.1644532733141; 
	Thu, 10 Feb 2022 14:38:53 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	q12sm12007982qtx.51.2022.02.10.14.38.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:52 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:32 -0500
Message-Id: <20220210223832.99412-15-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 14/14] block: add bio_start_io_acct_remapped for
	the benefit of DM
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM needs the ability to account a clone bio's IO to the original
block_device. So add @orig_bdev argument to bio_start_io_acct_time.
Rename bio_start_io_acct_time to bio_start_io_acct_remapped.
Also, follow bio_end_io_acct and bio_end_io_acct_remapped pattern by
moving bio_start_io_acct to blkdev.h and have it call
bio_start_io_acct_remapped.

Improve DM to no longer need to play games with swizzling a clone
bio's bi_bdev (in dm_submit_bio_remap) and remove DM's
clone_and_start_io_acct() interface.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 24 ++++++++----------------
 drivers/md/dm.c        | 41 ++++++++---------------------------------
 include/linux/blkdev.h | 16 ++++++++++++++--
 3 files changed, 30 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index be8812f5489d..8f23be96c737 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1077,29 +1077,21 @@ static unsigned long __part_start_io_acct(struct block_device *part,
 }
 
 /**
- * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * bio_start_io_acct_remapped - start I/O accounting for bio based drivers
  * @bio:	bio to start account for
  * @start_time:	start time that should be passed back to bio_end_io_acct().
- */
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
-{
-	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-			     bio_op(bio), start_time);
-}
-EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
-
-/**
- * bio_start_io_acct - start I/O accounting for bio based drivers
- * @bio:	bio to start account for
+ * @orig_bdev:	block device that I/O must be accounted to.
  *
  * Returns the start time that should be passed back to bio_end_io_acct().
  */
-unsigned long bio_start_io_acct(struct bio *bio)
+unsigned long bio_start_io_acct_remapped(struct bio *bio,
+				unsigned long start_time,
+				struct block_device *orig_bdev)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				    bio_op(bio), jiffies);
+	return __part_start_io_acct(orig_bdev, bio_sectors(bio),
+				    bio_op(bio), start_time);
 }
-EXPORT_SYMBOL_GPL(bio_start_io_acct);
+EXPORT_SYMBOL_GPL(bio_start_io_acct_remapped);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 329f0be64523..e020f505e243 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -485,35 +485,19 @@ u64 dm_start_time_ns_from_clone(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
-static void __start_io_acct(struct dm_io *io, struct bio *bio)
-{
-	bio_start_io_acct_time(bio, io->start_time);
-	if (unlikely(dm_stats_used(&io->md->stats)))
-		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    false, 0, &io->stats_aux);
-}
-
 static void start_io_acct(struct dm_io *io, struct bio *bio)
 {
 	/* Ensure IO accounting is only ever started once */
 	if (xchg(&io->was_accounted, 1) == 1)
 		return;
 
-	__start_io_acct(io, bio);
-}
+	bio_start_io_acct_remapped(bio, io->start_time,
+				   io->orig_bio->bi_bdev);
 
-static void clone_and_start_io_acct(struct dm_io *io, struct bio *bio)
-{
-	struct bio io_acct_clone;
-
-	/* Ensure IO accounting is only ever started once */
-	if (xchg(&io->was_accounted, 1) == 1)
-		return;
-
-	bio_init_clone(io->orig_bio->bi_bdev,
-		       &io_acct_clone, bio, GFP_NOIO);
-	__start_io_acct(io, &io_acct_clone);
+	if (unlikely(dm_stats_used(&io->md->stats)))
+		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
+				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    false, 0, &io->stats_aux);
 }
 
 static void end_io_acct(struct mapped_device *md, struct bio *bio,
@@ -1137,7 +1121,6 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 {
 	struct dm_target_io *tio = clone_to_tio(clone);
 	struct dm_io *io = tio->io;
-	struct block_device *clone_bdev = clone->bi_bdev;
 
 	/* establish bio that will get submitted */
 	if (!tgt_clone)
@@ -1151,9 +1134,7 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	 *   io->orig_bio so there is no IO imbalance in
 	 *   end_io_acct().
 	 */
-	clone->bi_bdev = io->orig_bio->bi_bdev;
 	start_io_acct(io, clone);
-	clone->bi_bdev = clone_bdev;
 
 	trace_block_bio_remap(tgt_clone, bio_dev(io->orig_bio),
 			      tio->old_sector);
@@ -1213,14 +1194,8 @@ static void __map_bio(struct bio *clone)
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* target has assumed ownership of this io */
-		if (!ti->accounts_remapped_io) {
-			/*
-			 * Any split isn't reflected in io->orig_bio yet. And bio
-			 * cannot be modified because target is submitting it.
-			 * Clone bio and account IO to DM device.
-			 */
-			clone_and_start_io_acct(io, clone);
-		}
+		if (!ti->accounts_remapped_io)
+			start_io_acct(io, clone);
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3bfc75a2a450..31d055d4a17e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1512,11 +1512,23 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
-unsigned long bio_start_io_acct(struct bio *bio);
+unsigned long bio_start_io_acct_remapped(struct bio *bio,
+				unsigned long start_time,
+				struct block_device *orig_bdev);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
 
+/**
+ * bio_start_io_acct - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ *
+ * Returns the start time that should be passed back to bio_end_io_acct().
+ */
+static inline unsigned long bio_start_io_acct(struct bio *bio)
+{
+	return bio_start_io_acct_remapped(bio, jiffies, bio->bi_bdev);
+}
+
 /**
  * bio_end_io_acct - end I/O accounting for bio based drivers
  * @bio:	bio to end account for
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

