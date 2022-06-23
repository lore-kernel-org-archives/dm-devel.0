Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04ED5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 23 Jun 2022 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655990424;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dt5kNHWxiqf3jkUekySrYWEM8Y3bpxqvWGzIFEHV7O4=;
	b=CXKTW6WkQPad5H6/bxA53UUvonwSI2vfd1hpJRgr1uVPlZiEgOJI3fRjg+Kt2b8CqPLTPR
	CVARp/Wdd/NOrFbHm2E8+aj6p5UwZXxtYRBgBh9O1diF38CAP5Qmv9N0/U8bMkC1gYbDnx
	cm9oRkw70Aks2dTqEdC1sTchbe1Y69k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-ZVaHIRhsO16uGmf_LB7Cfg-1; Thu, 23 Jun 2022 09:20:19 -0400
X-MC-Unique: ZVaHIRhsO16uGmf_LB7Cfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB8858001EA;
	Thu, 23 Jun 2022 13:20:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F455141510C;
	Thu, 23 Jun 2022 13:20:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 237FB194B952;
	Thu, 23 Jun 2022 13:20:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE2F4194B950
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Jun 2022 13:20:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD854492CA6; Thu, 23 Jun 2022 13:20:12 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B3120492CA5;
 Thu, 23 Jun 2022 13:20:11 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 23 Jun 2022 21:20:05 +0800
Message-Id: <20220623132005.2179011-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH] dm: fix dm io BLK_STS_DM_REQUEUE
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
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO accounting")
removes cloned bio when dm io splitting is needed. This way will make
multiple dm io instance sharing same original bio, and it works fine if
IOs are completed successfully. But regression may be caused if
BLK_STS_DM_REQUEUE is returned from either one of cloned io.

If case of BLK_STS_DM_REQUEUE from one cloned io, only the mapped part
of original bio for the current exact dm io needs to be re-submitted.
However, since the original bio is shared among all dm io instances,
actually the original bio only represents the last dm io instance, so
requeue can't work as expected. Also when more than one dm io is
requeued, the same original bio is requeued from all dm io's completion
handler, then race is caused.

Fix the issue by still allocating one bio for completing io only, then
io accounting can reply on ->orig_bio.

Based on one earlier version from Mike.

In theory, we can delay the bio clone when BLK_STS_DM_REQUEUE happens,
but that approach is a bit complicated: 1) bio clone needs to be done in
task context; 2) one block interface for unwinding bio is required.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Fixes: 7dd76d1feec7 ("dm: improve bio splitting and associated IO accounting")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-core.h |  2 +-
 drivers/md/dm.c      | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 54c0473a51dd..32f461c624c6 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -273,7 +273,7 @@ struct dm_io {
 	struct mapped_device *md;
 
 	/* The three fields represent mapped part of original bio */
-	struct bio *orig_bio;
+	struct bio *orig_bio, *bak_bio;
 	unsigned int sector_offset; /* offset to end of orig_bio */
 	unsigned int sectors;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9ede55278eec..85d8f2f1c9c8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -594,6 +594,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	atomic_set(&io->io_count, 2);
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = bio;
+	io->bak_bio = NULL;
 	io->md = md;
 	spin_lock_init(&io->lock);
 	io->start_time = jiffies;
@@ -887,7 +888,7 @@ static void dm_io_complete(struct dm_io *io)
 {
 	blk_status_t io_error;
 	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
+	struct bio *bio = io->bak_bio ? io->bak_bio : io->orig_bio;
 
 	if (io->status == BLK_STS_DM_REQUEUE) {
 		unsigned long flags;
@@ -1693,9 +1694,10 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	 * Remainder must be passed to submit_bio_noacct() so it gets handled
 	 * *after* bios already submitted have been completely processed.
 	 */
-	bio_trim(bio, io->sectors, ci.sector_count);
-	trace_block_split(bio, bio->bi_iter.bi_sector);
-	bio_inc_remaining(bio);
+	io->bak_bio = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+			GFP_NOIO, &md->queue->bio_split);
+	bio_chain(io->bak_bio, bio);
+	trace_block_split(io->bak_bio, bio->bi_iter.bi_sector);
 	submit_bio_noacct(bio);
 out:
 	/*
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

