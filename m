Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439C0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/VhCMdTv5Mhg5vcxTHoMYOEWje88pTGIqo+gz5oab80=;
	b=OTiGMoJ1u9faynV9mwADqMVO8YcRgjPXrnY0FEoD0l9GSNvSlxwcVFYb9yB9WIHNfvCUc9
	c26+7YRxpV1yNw2jMCJAAnzBRMHAn1rIfF8RDjxijVshQt3t2qb9GBqhKClPRynfPzLFAD
	WLLTlezjdfipT3Vy/mb6P7KhsqYmkD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-yIiJEXGkNOiFHTdOuV3oFw-1; Thu, 10 Feb 2022 17:42:44 -0500
X-MC-Unique: yIiJEXGkNOiFHTdOuV3oFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 730F11018720;
	Thu, 10 Feb 2022 22:42:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A39B4697C;
	Thu, 10 Feb 2022 22:42:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 352EF4A7C8;
	Thu, 10 Feb 2022 22:42:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcoGc014840 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A309EC07F5D; Thu, 10 Feb 2022 22:38:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EDD4C1D38B
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86A7485A5A8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:50 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-588-jzo0LSOeNcy65xVsviOU6Q-1; Thu, 10 Feb 2022 17:38:49 -0500
X-MC-Unique: jzo0LSOeNcy65xVsviOU6Q-1
Received: by mail-qv1-f70.google.com with SMTP id
	3-20020ad45b83000000b00423e8603906so5041553qvp.1
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=clg1j9AsWGf13nZ+cL57xlbQXn238yrRMLtUXnWXd9Q=;
	b=Vu1RBgHBpCLAS2fdZigUOGL8WY8dpdAQ5svNhyjm/GKmUpGC/YLxSQHGKf9/SccoNZ
	hiUZRRDjj1O1oMmjeBcze2GtfTUjKVKwwzLq6zBoVMJ41JtGU+zT2jHXVkLgdKIdZDst
	Ll5CR+Rb1I+JaivmPv3yOTUDQoF7MMT8IbjO8tDQaGhELXxmTdZCjyftnFs19ibfPdTq
	6elKIQ9HZVqytN/AeC4NDluJmiCvDO5QZuFa2pG+QiXlzdx7sKq1tXde+FDdu+Onu1iR
	zeoexACfDjLVsMdvMSDg+4ok8qI2hLtJqVVSOjU2605avyTwNAfqfi012cNijXN/bVlX
	dk6A==
X-Gm-Message-State: AOAM531yNQFZGTPE73fFpJo+q1DevR7zJC7Jtdd78EfqwdP9RkH0ekLL
	3v6OJdIbsrhOMFAsvlUpkPazJ0Onl9Onwk5KfTYyzk4Ho+reYxvTgjDFh0baXnvzcw9uv+Ux7qD
	RRmPDP3fFtAm0+/j2fUqQra2z/uEcKR4XBhP5HEabha53swNc21a8gBneXHr+D7j2/Q==
X-Received: by 2002:a37:61ca:: with SMTP id v193mr5007963qkb.177.1644532728515;
	Thu, 10 Feb 2022 14:38:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2IldN0gw3kZyxdPqUqit4+42CSSY2elFZp9qQdt60LjZzqSwEFWIWb3gl3fnkNs62ee8TQw==
X-Received: by 2002:a37:61ca:: with SMTP id v193mr5007952qkb.177.1644532728122;
	Thu, 10 Feb 2022 14:38:48 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	w14sm12344783qtc.29.2022.02.10.14.38.47
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:47 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:28 -0500
Message-Id: <20220210223832.99412-11-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 10/14] dm: add dm_submit_bio_remap interface
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

Switch from early bio-based IO accounting (at the time DM clones each
incoming bio) to late IO accounting just before each remapped bio is
issued to underlying device via submit_bio_noacct().

Allows more precise bio-based IO accounting for DM targets that use
their own workqueues to perform additional processing of each bio in
conjunction with their DM_MAPIO_SUBMITTED return from their map
function.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm.c               | 93 +++++++++++++++++++++++++++++++++++++++----
 include/linux/device-mapper.h |  7 ++++
 3 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 8dd196aec130..3ecd6f294f53 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -230,6 +230,7 @@ struct dm_io {
 	atomic_t io_count;
 	struct bio *orig_bio;
 	unsigned long start_time;
+	unsigned long io_acct_time;
 	spinlock_t lock;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8c0e96b8e1a5..ad512f40716e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -485,21 +485,54 @@ u64 dm_start_time_ns_from_clone(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
-static void start_io_acct(struct dm_io *io)
+static void __start_io_acct(struct dm_io *io, struct bio *bio)
 {
-	struct bio *bio = io->orig_bio;
+	unsigned long flags;
 
-	bio_start_io_acct_time(bio, io->start_time);
+	/* Ensure IO accounting is only ever started once */
+	spin_lock_irqsave(&io->lock, flags);
+	if (smp_load_acquire(&io->io_acct_time)) {
+		spin_unlock_irqrestore(&io->lock, flags);
+		return;
+	}
+	smp_store_release(&io->io_acct_time, jiffies);
+	spin_unlock_irqrestore(&io->lock, flags);
 
+	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&io->md->stats)))
 		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    false, 0, &io->stats_aux);
 }
 
+static void start_io_acct(struct dm_io *io, struct bio *bio)
+{
+	/* Only start_io_acct() once for this IO */
+	if (smp_load_acquire(&io->io_acct_time))
+		return;
+
+	__start_io_acct(io, bio);
+}
+
+static void clone_and_start_io_acct(struct dm_io *io, struct bio *bio)
+{
+	struct bio io_acct_clone;
+
+	/* Only clone_and_start_io_acct() once for this IO */
+	if (smp_load_acquire(&io->io_acct_time))
+		return;
+
+	bio_init_clone(io->orig_bio->bi_bdev,
+		       &io_acct_clone, bio, GFP_NOIO);
+	__start_io_acct(io, &io_acct_clone);
+}
+
 static void end_io_acct(struct mapped_device *md, struct bio *bio,
 			unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
+	if (!start_time)
+		return;
+
 	bio_end_io_acct(bio, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
@@ -529,6 +562,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	spin_lock_init(&io->lock);
 
 	io->start_time = jiffies;
+	io->io_acct_time = 0;
 
 	return io;
 }
@@ -818,7 +852,8 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		}
 
 		io_error = io->status;
-		start_time = io->start_time;
+		if (io->io_acct_time)
+			start_time = io->start_time;
 		stats_aux = io->stats_aux;
 		free_io(io);
 		end_io_acct(md, bio, start_time, &stats_aux);
@@ -1099,6 +1134,43 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+/*
+ * @clone: clone bio that DM core passed to target's .map function
+ * @tgt_clone: bio that target needs to submit (after DM_MAPIO_SUBMITTED)
+ *
+ * Targets should use this interface to submit bios they take
+ * ownership of when returning DM_MAPIO_SUBMITTED.
+ *
+ * Target should also enable ti->accounts_remapped_io
+ */
+void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
+{
+	struct dm_target_io *tio = clone_to_tio(clone);
+	struct dm_io *io = tio->io;
+	struct block_device *clone_bdev = clone->bi_bdev;
+
+	/* establish bio that will get submitted */
+	if (!tgt_clone)
+		tgt_clone = clone;
+
+	/*
+	 * account IO to DM device in terms of clone's
+	 * payload to avoid concern about late bio splitting.
+	 * - clone will reflect any dm_accept_partial_bio()
+	 * - any bio splitting is ultimately reflected in
+	 *   io->orig_bio so there is no IO imbalance in
+	 *   end_io_acct().
+	 */
+	clone->bi_bdev = io->orig_bio->bi_bdev;
+	start_io_acct(io, clone);
+	clone->bi_bdev = clone_bdev;
+
+	trace_block_bio_remap(tgt_clone, bio_dev(io->orig_bio),
+			      tio->old_sector);
+	submit_bio_noacct(tgt_clone);
+}
+EXPORT_SYMBOL_GPL(dm_submit_bio_remap);
+
 static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
 {
 	mutex_lock(&md->swap_bios_lock);
@@ -1151,12 +1223,18 @@ static void __map_bio(struct bio *clone)
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* target has assumed ownership of this io */
+		if (!ti->accounts_remapped_io) {
+			/*
+			 * Any split isn't reflected in io->orig_bio yet. And bio
+			 * cannot be modified because target is submitting it.
+			 * Clone bio and account IO to DM device.
+			 */
+			clone_and_start_io_acct(io, clone);
+		}
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
-		trace_block_bio_remap(clone, bio_dev(io->orig_bio),
-				      tio->old_sector);
-		submit_bio_noacct(clone);
+		dm_submit_bio_remap(clone, NULL);
 		break;
 	case DM_MAPIO_KILL:
 	case DM_MAPIO_REQUEUE:
@@ -1403,7 +1481,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 		submit_bio_noacct(bio);
 	}
 out:
-	start_io_acct(ci.io);
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
 }
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b26fecf6c8e8..a3e397155bc9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -362,6 +362,12 @@ struct dm_target {
 	 * zone append operations using regular writes.
 	 */
 	bool emulate_zone_append:1;
+
+	/*
+	 * Set if the target will submit IO using dm_submit_bio_remap()
+	 * after returning DM_MAPIO_SUBMITTED from its map function.
+	 */
+	bool accounts_remapped_io:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
@@ -465,6 +471,7 @@ int dm_suspended(struct dm_target *ti);
 int dm_post_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
+void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

