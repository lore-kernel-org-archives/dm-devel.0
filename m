Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC2BC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656539780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+7/7rXMttfdsrETlSgu5bDlDoOOjeUhsnlkEGw1RhGk=;
	b=hLMJTveVR5NqbsStbcDr63PYzmskbWgfL4yLMmzqnkRbwS9URSXspYCo4kYdLAJluMP83P
	8+AlDIge5gsys0/JbSuufS1Pk2/DOHg+TfsH/MlkLElKLqejdvdItplEzlPeFZfKXsIBMF
	KbU7j/bgfU78cTUU6QG9wMzb3ZDv1Oo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-ArTAk73YMOyr9A4veh-nGQ-1; Wed, 29 Jun 2022 17:56:16 -0400
X-MC-Unique: ArTAk73YMOyr9A4veh-nGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0871E1C05144;
	Wed, 29 Jun 2022 21:56:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DAE61410F3B;
	Wed, 29 Jun 2022 21:56:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 46843194705B;
	Wed, 29 Jun 2022 21:56:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 558171947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 21:55:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4849F17452; Wed, 29 Jun 2022 21:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 440489D63
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24A01801E67
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 21:55:21 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-gv-48aF3MZq93htb2c0Y1g-1; Wed, 29 Jun 2022 17:55:19 -0400
X-MC-Unique: gv-48aF3MZq93htb2c0Y1g-1
Received: by mail-qv1-f49.google.com with SMTP id c1so26900634qvi.11
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 14:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=wOc7PiTHWWO7hPXQjf/yGdfIN9CM5Q88rtx5tDXMxXM=;
 b=MWZ/p005nAg+zDKwiNqeIPy1x4BPDD/aFRMi+DP1Tg+SIH6vM5ghqFqHJdDyV8bHV9
 WF8kN20o6Gg55k/kA90GUX+8/zN5z56bdpPS6Y2IxnXIKv6gM8E5BHh87wFowIuA7fXy
 oDYihl97a7SlCQ3+ghz72Djgjz8XtfBjtSatmSxbDmtP90f/hgQ2ceq+3f8SMiGVtN1S
 /lrkKi2CgyHv4Tndm/8KQTQZcER5qy93ci5CvKKzaw1kRHNVnhz3yF/OsqMuN2wKNdA2
 Q3ufcmCkEMy0hxAq8CMV7q0oFqXtU7kNI7PzkIAKzsBAG4AkkB3009ygibvDZzgSYgjt
 0KCQ==
X-Gm-Message-State: AJIora8++Cq4D9luqR3XltYmboLXqgBb6abG5uh56pQ/oGJt+C9QNy3t
 o82iFEv2Qq66Pgkz1CBMMbINi8E=
X-Google-Smtp-Source: AGRyM1uXWFM4Etdb50ZR4c5bvr+DgE+PjjwwOvUEI19IrTZJ4Bb+AbEhv5B+1yw64d9qox0dk66ECQ==
X-Received: by 2002:a05:622a:1883:b0:305:1ce4:59d2 with SMTP id
 v3-20020a05622a188300b003051ce459d2mr4577175qtc.638.1656539718984; 
 Wed, 29 Jun 2022 14:55:18 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 y21-20020ac87095000000b0031b18d29864sm5335568qto.64.2022.06.29.14.55.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 14:55:18 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Date: Wed, 29 Jun 2022 17:55:13 -0400
Message-Id: <20220629215513.37860-4-snitzer@kernel.org>
In-Reply-To: <20220629215513.37860-1-snitzer@kernel.org>
References: <20220629215513.37860-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 5.20 v2 3/3] dm: add two stage requeue mechanism
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Ming Lei <ming.lei@redhat.com>

Commit 61b6e2e5321d ("dm: fix BLK_STS_DM_REQUEUE handling when dm_io
represents split bio") reverted DM core's bio splitting back to using
bio_split()+bio_chain() because it was found that otherwise DM's
BLK_STS_DM_REQUEUE would trigger a live-lock waiting for bio
completion that would never occur.

Restore using bio_trim()+bio_inc_remaining(), like was done in commit
7dd76d1feec7 ("dm: improve bio splitting and associated IO
accounting"), but this time with proper handling for the above
scenario that is covered in more detail in the commit header for
61b6e2e5321d.

Solve this issue by adding a two staged dm_io requeue mechanism that
uses the new bio_rewind():

1) requeue the dm_io into the requeue_list added to struct
   mapped_device, and schedule it via new added requeue work. This
   workqueue just clones the dm_io->orig_bio (which DM saves and
   ensures its end sector isn't modified). Using the sectors and
   sectors_offset members of the dm_io that are recorded relative to
   the end of orig_bio: bio_rewind()+bio_trim() are then used to make
   that cloned bio reflect the subset of the original bio that is
   represented by the dm_io that is being requeued.

2) the 2nd stage requeue is same with original requeue, but
   io->orig_bio points to new cloned bio (which matches the requeued
   dm_io as described above).

This allows DM core to shift the need for bio cloning from bio-split
time (during IO submission) to the less likely BLK_STS_DM_REQUEUE
handling (after IO completes with that error).

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h |  11 ++++-
 drivers/md/dm.c      | 133 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 118 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 5d9afca0d105..2999f135b16f 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -22,6 +22,8 @@
 
 #define DM_RESERVED_MAX_IOS		1024
 
+struct dm_io;
+
 struct dm_kobject_holder {
 	struct kobject kobj;
 	struct completion completion;
@@ -91,6 +93,14 @@ struct mapped_device {
 	spinlock_t deferred_lock;
 	struct bio_list deferred;
 
+	/*
+	 * requeue work context is needed for cloning one new bio
+	 * to represent the dm_io to be requeued, since each
+	 * dm_io may point to the original bio from FS.
+	 */
+	struct work_struct requeue_work;
+	struct dm_io *requeue_list;
+
 	void *interface_ptr;
 
 	/*
@@ -275,7 +285,6 @@ struct dm_io {
 	atomic_t io_count;
 	struct mapped_device *md;
 
-	struct bio *split_bio;
 	/* The three fields represent mapped part of original bio */
 	struct bio *orig_bio;
 	unsigned int sector_offset; /* offset to end of orig_bio */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c987f9ad24a4..563206c6c2cb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -590,7 +590,6 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	atomic_set(&io->io_count, 2);
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = bio;
-	io->split_bio = NULL;
 	io->md = md;
 	spin_lock_init(&io->lock);
 	io->start_time = jiffies;
@@ -880,13 +879,35 @@ static int __noflush_suspending(struct mapped_device *md)
 	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 }
 
+static void dm_requeue_add_io(struct dm_io *io, bool first_stage)
+{
+	struct mapped_device *md = io->md;
+
+	if (first_stage) {
+		struct dm_io *next = md->requeue_list;
+
+		md->requeue_list = io;
+		io->next = next;
+	} else {
+		bio_list_add_head(&md->deferred, io->orig_bio);
+	}
+}
+
+static void dm_kick_requeue(struct mapped_device *md, bool first_stage)
+{
+	if (first_stage)
+		queue_work(md->wq, &md->requeue_work);
+	else
+		queue_work(md->wq, &md->work);
+}
+
 /*
  * Return true if the dm_io's original bio is requeued.
  * io->status is updated with error if requeue disallowed.
  */
-static bool dm_handle_requeue(struct dm_io *io)
+static bool dm_handle_requeue(struct dm_io *io, bool first_stage)
 {
-	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	struct bio *bio = io->orig_bio;
 	bool handle_requeue = (io->status == BLK_STS_DM_REQUEUE);
 	bool handle_polled_eagain = ((io->status == BLK_STS_AGAIN) &&
 				     (bio->bi_opf & REQ_POLLED));
@@ -912,8 +933,8 @@ static bool dm_handle_requeue(struct dm_io *io)
 		spin_lock_irqsave(&md->deferred_lock, flags);
 		if ((__noflush_suspending(md) &&
 		     !WARN_ON_ONCE(dm_is_zone_write(md, bio))) ||
-		    handle_polled_eagain) {
-			bio_list_add_head(&md->deferred, bio);
+		    handle_polled_eagain || first_stage) {
+			dm_requeue_add_io(io, first_stage);
 			requeued = true;
 		} else {
 			/*
@@ -926,19 +947,21 @@ static bool dm_handle_requeue(struct dm_io *io)
 	}
 
 	if (requeued)
-		queue_work(md->wq, &md->work);
+		dm_kick_requeue(md, first_stage);
 
 	return requeued;
 }
 
-static void dm_io_complete(struct dm_io *io)
+static void __dm_io_complete(struct dm_io *io, bool first_stage)
 {
-	struct bio *bio = io->split_bio ? io->split_bio : io->orig_bio;
+	struct bio *bio = io->orig_bio;
 	struct mapped_device *md = io->md;
 	blk_status_t io_error;
 	bool requeued;
 
-	requeued = dm_handle_requeue(io);
+	requeued = dm_handle_requeue(io, first_stage);
+	if (requeued && first_stage)
+		return;
 
 	io_error = io->status;
 	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
@@ -978,6 +1001,76 @@ static void dm_io_complete(struct dm_io *io)
 	}
 }
 
+static void dm_wq_requeue_work(struct work_struct *work)
+{
+	struct mapped_device *md = container_of(work, struct mapped_device,
+						requeue_work);
+	unsigned long flags;
+	struct dm_io *io;
+
+	/* reuse deferred lock to simplify dm_handle_requeue  */
+	spin_lock_irqsave(&md->deferred_lock, flags);
+	io = md->requeue_list;
+	md->requeue_list = NULL;
+	spin_unlock_irqrestore(&md->deferred_lock, flags);
+
+	while (io) {
+		struct dm_io *next = io->next;
+		struct bio *orig = io->orig_bio;
+		struct bio *new_orig = bio_alloc_clone(orig->bi_bdev,
+				orig, GFP_NOIO, &md->queue->bio_split);
+
+		/*
+		 * bio_rewind can restore to previous position since the end
+		 * sector is fixed for original bio, but we still need to
+		 * restore bio's size manually (using io->sectors).
+		 */
+		bio_rewind(new_orig, ((io->sector_offset << 9) -
+				      orig->bi_iter.bi_size));
+		bio_trim(new_orig, 0, io->sectors);
+
+		bio_chain(new_orig, orig);
+		/*
+		 * __bi_remaining was increased by dm_split_and_process_bio,
+		 *  so must drop the one added in bio_chain.
+		 */
+		atomic_dec(&orig->__bi_remaining);
+		io->orig_bio = new_orig;
+
+		io->next = NULL;
+		__dm_io_complete(io, false);
+		io = next;
+	}
+}
+
+/*
+ * Two staged requeue:
+ *
+ * 1) io->orig_bio points to the real original bio, and the part mapped to
+ *    this io must be requeued, instead of other parts of the original bio.
+ *
+ * 2) io->orig_bio points to new cloned bio which matches the requeued dm_io.
+ */
+static void dm_io_complete(struct dm_io *io)
+{
+	bool first_requeue;
+
+	/*
+	 * Only dm_io that has been split needs two stage requeue, otherwise
+	 * we may run into long bio clone chain during suspend and OOM could
+	 * be triggered.
+	 *
+	 * Also flush data dm_io won't be marked as DM_IO_WAS_SPLIT, so they
+	 * also aren't handled via the first stage requeue.
+	 */
+	if (dm_io_flagged(io, DM_IO_WAS_SPLIT))
+		first_requeue = true;
+	else
+		first_requeue = false;
+
+	__dm_io_complete(io, first_requeue);
+}
+
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
@@ -1395,17 +1488,7 @@ static void setup_split_accounting(struct clone_info *ci, unsigned len)
 		 */
 		dm_io_set_flag(io, DM_IO_WAS_SPLIT);
 		io->sectors = len;
-	}
-
-	if (static_branch_unlikely(&stats_enabled) &&
-	    unlikely(dm_stats_used(&io->md->stats))) {
-		/*
-		 * Save bi_sector in terms of its offset from end of
-		 * original bio, only needed for DM-stats' benefit.
-		 * - saved regardless of whether split needed so that
-		 *   dm_accept_partial_bio() doesn't need to.
-		 */
-		io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
+		io->sector_offset = bio_sectors(ci->bio);
 	}
 }
 
@@ -1705,11 +1788,9 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	 * Remainder must be passed to submit_bio_noacct() so it gets handled
 	 * *after* bios already submitted have been completely processed.
 	 */
-	WARN_ON_ONCE(!dm_io_flagged(io, DM_IO_WAS_SPLIT));
-	io->split_bio = bio_split(bio, io->sectors, GFP_NOIO,
-				  &md->queue->bio_split);
-	bio_chain(io->split_bio, bio);
-	trace_block_split(io->split_bio, bio->bi_iter.bi_sector);
+	bio_trim(bio, io->sectors, ci.sector_count);
+	trace_block_split(bio, bio->bi_iter.bi_sector);
+	bio_inc_remaining(bio);
 	submit_bio_noacct(bio);
 out:
 	/*
@@ -1985,9 +2066,11 @@ static struct mapped_device *alloc_dev(int minor)
 
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
+	INIT_WORK(&md->requeue_work, dm_wq_requeue_work);
 	init_waitqueue_head(&md->eventq);
 	init_completion(&md->kobj_holder.completion);
 
+	md->requeue_list = NULL;
 	md->swap_bios = get_swap_bios();
 	sema_init(&md->swap_bios_semaphore, md->swap_bios);
 	mutex_init(&md->swap_bios_lock);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

