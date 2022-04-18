Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435C4C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-5HZ-ioyoNPCrFr2MWpoL5Q-1; Sun, 17 Apr 2022 22:28:05 -0400
X-MC-Unique: 5HZ-ioyoNPCrFr2MWpoL5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C07A51857F08;
	Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB9111121315;
	Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5446E19451F1;
	Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8FF519466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:28:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAB1B145D47D; Mon, 18 Apr 2022 02:28:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D71CC145D47B
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC225802803
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:01 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-hV06rONaN7iA13SsThHp2A-1; Sun, 17 Apr 2022 22:28:00 -0400
X-MC-Unique: hV06rONaN7iA13SsThHp2A-1
Received: by mail-qt1-f178.google.com with SMTP id d14so1360658qtw.5
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=+Nx4ePs90HaNMR2AWjcB56EOnrA02o23cKPmk6rDsqs=;
 b=eXxdhII1vpASYBRMqfTspvSdJJjgBGACu0P4dd5QGoPlIGlhS/HKVjkzJa6N31nINv
 y1UsWBQxSnc1B1qN9OK/l93tVs517hQn9IvC7ZTylrbq0CjpliECfbxTOCb4Qfws87iv
 Y0D3JH21ahBv+LaNqNfY1dTHAvA2oiW6Vuz68chQnOsl9W1EiytRkbZ58/87Nt2YE8SG
 oax2dadY+dXAjdCIrW7bGu4zd9X/ISquC34ljGiqUD4Q2HF24BA63T1Bhf1EKV+kc8m8
 zSrxzi6ZT8/HWG2j3EAhlyVwrYGry/exMVUTelvnGV9vXlo5HLQsyYKp/tbDjPuGHyx0
 4DyA==
X-Gm-Message-State: AOAM530WiXdtxLS4wwXInt6BHCx16VQsenek2cP+ZKGL4yUPrtts2joJ
 8xloOkjvptwuS0VBPsaADVK2xQHK4hs2g9XF4xwDubGi97wlMu2COqDqmzPT/5VUhWV6P8BYV6M
 podnQT6mrW8z7B173IYYSKY6f+HD/y9X7BcWJtkW2AL5doAl/OaTkU82dXrtTDLl694Q=
X-Google-Smtp-Source: ABdhPJxIX9+HTN89noLwoxnOHP2HscVMnA76O+2ghEBR9ltaWJypyN6I80GBlibKH6k/FHBVzlNtxw==
X-Received: by 2002:ac8:7d51:0:b0:2e1:c757:6d25 with SMTP id
 h17-20020ac87d51000000b002e1c7576d25mr5953474qtb.301.1650248879362; 
 Sun, 17 Apr 2022 19:27:59 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 128-20020a370486000000b0069e9d72b45fsm1020529qke.13.2022.04.17.19.27.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:59 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:32 -0400
Message-Id: <20220418022733.56168-21-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [dm-5.19 PATCH 20/21] dm: simplify bio-based IO
 accounting further
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
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

Now that io splitting is recorded prior to, or during, ->map IO
accounting can happen immediately rather than defer until after
bio splitting in dm_split_and_process_bio().

Remove the DM_IO_START_ACCT flag and also remove dm_io's map_task
member because there is no longer any need to wait for splitting to
occur before accounting.

Also move dm_io struct's 'flags' member to consolidate struct holes.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h |  6 +-----
 drivers/md/dm.c      | 34 +++++-----------------------------
 2 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index f3cfc7affd12..d21648a923ea 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -255,15 +255,12 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
 #define DM_IO_MAGIC 19577
 struct dm_io {
 	unsigned short magic;
-
+	blk_short_t flags;
 	spinlock_t lock;
 	unsigned long start_time;
 	void *data;
 	struct dm_io *next;
-	struct task_struct *map_task;
 	struct dm_stats_aux stats_aux;
-
-	blk_short_t flags;
 	blk_status_t status;
 	atomic_t io_count;
 	struct mapped_device *md;
@@ -281,7 +278,6 @@ struct dm_io {
  * dm_io flags
  */
 enum {
-	DM_IO_START_ACCT,
 	DM_IO_ACCOUNTED,
 	DM_IO_WAS_SPLIT
 };
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c5a79712de1d..3b87d151ef88 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -596,7 +596,6 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = bio;
 	io->md = md;
-	io->map_task = current;
 	spin_lock_init(&io->lock);
 	io->start_time = jiffies;
 	io->flags = 0;
@@ -1242,13 +1241,6 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
-static inline void __dm_submit_bio_remap(struct bio *clone,
-					 dev_t dev, sector_t old_sector)
-{
-	trace_block_bio_remap(clone, dev, old_sector);
-	submit_bio_noacct(clone);
-}
-
 /*
  * @clone: clone bio that DM core passed to target's .map function
  * @tgt_clone: clone of @clone bio that target needs submitted
@@ -1263,8 +1255,6 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	struct dm_target_io *tio = clone_to_tio(clone);
 	struct dm_io *io = tio->io;
 
-	WARN_ON_ONCE(!tio->ti->accounts_remapped_io);
-
 	/* establish bio that will get submitted */
 	if (!tgt_clone)
 		tgt_clone = clone;
@@ -1273,15 +1263,11 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
 	 */
-	if (io->map_task == current) {
-		/* Still in target's map function */
-		dm_io_set_flag(io, DM_IO_START_ACCT);
-	} else {
-		dm_start_io_acct(io, clone);
-	}
+	dm_start_io_acct(io, clone);
 
-	__dm_submit_bio_remap(tgt_clone, disk_devt(io->md->disk),
+	trace_block_bio_remap(tgt_clone, disk_devt(io->md->disk),
 			      tio->old_sector);
+	submit_bio_noacct(tgt_clone);
 }
 EXPORT_SYMBOL_GPL(dm_submit_bio_remap);
 
@@ -1341,16 +1327,10 @@ static void __map_bio(struct bio *clone)
 	case DM_MAPIO_SUBMITTED:
 		/* target has assumed ownership of this io */
 		if (!ti->accounts_remapped_io)
-			dm_io_set_flag(io, DM_IO_START_ACCT);
+			dm_start_io_acct(io, clone);
 		break;
 	case DM_MAPIO_REMAPPED:
-		/*
-		 * the bio has been remapped so dispatch it, but defer
-		 * dm_start_io_acct() until after possible bio_split().
-		 */
-		__dm_submit_bio_remap(clone, disk_devt(md->disk),
-				      tio->old_sector);
-		dm_io_set_flag(io, DM_IO_START_ACCT);
+		dm_submit_bio_remap(clone, NULL);
 		break;
 	case DM_MAPIO_KILL:
 	case DM_MAPIO_REQUEUE:
@@ -1668,7 +1648,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	}
 
 	error = __split_and_process_bio(&ci);
-	io->map_task = NULL;
 	if (error || !ci.sector_count)
 		goto out;
 	/*
@@ -1680,9 +1659,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	bio_inc_remaining(bio);
 	submit_bio_noacct(bio);
 out:
-	if (dm_io_flagged(io, DM_IO_START_ACCT))
-		dm_start_io_acct(io, NULL);
-
 	/*
 	 * Drop the extra reference count for non-POLLED bio, and hold one
 	 * reference for POLLED bio, which will be released in dm_poll_bio
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

