Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27433C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-2Iqjl4NuMJSn0TKUdVTt4Q-1; Sun, 17 Apr 2022 22:27:59 -0400
X-MC-Unique: 2Iqjl4NuMJSn0TKUdVTt4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8D21857F0F;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC79145D480;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BFF319451F3;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4498F1940352
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 365822166B1E; Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31ABE2166B1C
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44DC580159B
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:49 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-PdA9sxftPXyFqdXo24hAWw-1; Sun, 17 Apr 2022 22:27:47 -0400
X-MC-Unique: PdA9sxftPXyFqdXo24hAWw-1
Received: by mail-qt1-f182.google.com with SMTP id a11so9280049qtb.12
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=Nf0mm/AnzvT816f+pNuqDw1vTu75lzlkj5IDnLDhk6I=;
 b=rGJTgPO/5Sc6SsUNqQmywJmcI5CxcwEDk08ipMKNUaGctwtHxbVuKrfu3zwr6kGfe9
 fw+o/t9BZpeaplkr5eKlku/BBBWXaRVq/HmLf/nc5GqTU/rB87jYVNQ8t+NkJvTBBS6L
 fhZ2XbDJwSlxS0394PtJpV7pjmJC0xB09cbmFnLQnlkVJyzWOZd3Pvbe61MDeLs/wFuT
 4SQlxFNvkIjNpY7XkzbbSc5S8DsUKT8bwFIyeEbVfN9wF52Sl5Gzu163gu2iP79IX5Ti
 lyK6eZvk8s4onvEMXsnVwA6NXTmdPyq0p6uJU8snC01FXjyq5DhJPsmUmVfd3w3pUmcO
 EaYA==
X-Gm-Message-State: AOAM5322DvGPabNAgX5GpHXBrxYproXQDp3oLn8Xb5iGwCU5bnZBE6JI
 39dkxBl+ScTyauyuireTeXBtnrF8XlBNXIXi0tDF1hyrXzanmQVF1PqKdNXd8YGqrxjSNnnLnH2
 aQWQjQAzVyEObnWi1U9leBk/AknLfeNQwjkZWZ/+8kmeKTa4pahI0OVFee2sPkLVyiWI=
X-Google-Smtp-Source: ABdhPJyMZYD5yvrA3uMQQTKtbhCchGyGJ7GrADx6RZYVernNDOHoXoQwV6GheB/Ds+lKcscWHOWrtg==
X-Received: by 2002:a05:622a:302:b0:2e0:7aed:d653 with SMTP id
 q2-20020a05622a030200b002e07aedd653mr5894440qtw.492.1650248866876; 
 Sun, 17 Apr 2022 19:27:46 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 j131-20020a37a089000000b0069e7ebc625bsm2405183qke.78.2022.04.17.19.27.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:46 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:22 -0400
Message-Id: <20220418022733.56168-11-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [dm-5.19 PATCH 10/21] dm: conditionally enable branching
 for less used features
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use jump_labels to further reduce cost of unlikely branches for zoned
block devices, dm-stats and swap_bios throttling.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h  |  5 ++++
 drivers/md/dm-stats.c |  3 +++
 drivers/md/dm-table.c |  5 ++++
 drivers/md/dm.c       | 63 ++++++++++++++++++++++++++++++++-------------------
 4 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 41d6511dc7cf..8ba99eaa0872 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -13,6 +13,7 @@
 #include <linux/ktime.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-crypto-profile.h>
+#include <linux/jump_label.h>
 
 #include <trace/events/block.h>
 
@@ -154,6 +155,10 @@ static inline struct dm_stats *dm_get_stats(struct mapped_device *md)
 	return &md->stats;
 }
 
+DECLARE_STATIC_KEY_FALSE(stats_enabled);
+DECLARE_STATIC_KEY_FALSE(swap_bios_enabled);
+DECLARE_STATIC_KEY_FALSE(zoned_enabled);
+
 static inline bool dm_emulate_zone_append(struct mapped_device *md)
 {
 	if (blk_queue_is_zoned(md->queue))
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 0e039a8c0bf2..86e0697330e8 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -396,6 +396,9 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 
 	dm_stats_recalc_precise_timestamps(stats);
 
+	if (!static_key_enabled(&stats_enabled.key))
+		static_branch_enable(&stats_enabled);
+
 	mutex_unlock(&stats->mutex);
 
 	resume_callback(md);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ffd97cb6d1c1..a9d2fc5d9ad9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -719,6 +719,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMWARN("%s: %s: ignoring discards_supported because num_discard_bios is zero.",
 		       dm_device_name(t->md), type);
 
+	if (tgt->limit_swap_bios && !static_key_enabled(&swap_bios_enabled.key))
+		static_branch_enable(&swap_bios_enabled);
+
 	return 0;
 
  bad:
@@ -2051,6 +2054,8 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		r = dm_set_zones_restrictions(t, q);
 		if (r)
 			return r;
+		if (!static_key_enabled(&zoned_enabled.key))
+			static_branch_enable(&zoned_enabled);
 	}
 
 	dm_update_crypto_profile(q, t);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 073b41ce7a30..3359b55daa99 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -71,6 +71,10 @@ void dm_issue_global_event(void)
 	wake_up(&dm_global_eventq);
 }
 
+DEFINE_STATIC_KEY_FALSE(stats_enabled);
+DEFINE_STATIC_KEY_FALSE(swap_bios_enabled);
+DEFINE_STATIC_KEY_FALSE(zoned_enabled);
+
 /*
  * One of these is allocated (on-stack) per original bio.
  */
@@ -516,7 +520,8 @@ static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
 	else
 		bio_end_io_acct(bio, start_time);
 
-	if (unlikely(dm_stats_used(&md->stats)))
+	if (static_branch_unlikely(&stats_enabled) &&
+	    unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    end, start_time, stats_aux);
@@ -586,7 +591,8 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->start_time = jiffies;
 	io->flags = 0;
 
-	dm_stats_record_start(&md->stats, &io->stats_aux);
+	if (static_branch_unlikely(&stats_enabled))
+		dm_stats_record_start(&md->stats, &io->stats_aux);
 
 	return io;
 }
@@ -1013,21 +1019,25 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (unlikely(blk_queue_is_zoned(q)))
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(blk_queue_is_zoned(q)))
 		dm_zone_endio(io, bio);
 
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {
 		case DM_ENDIO_REQUEUE:
-			/*
-			 * Requeuing writes to a sequential zone of a zoned
-			 * target will break the sequential write pattern:
-			 * fail such IO.
-			 */
-			if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
-				error = BLK_STS_IOERR;
-			else
+			if (static_branch_unlikely(&zoned_enabled)) {
+				/*
+				 * Requeuing writes to a sequential zone of a zoned
+				 * target will break the sequential write pattern:
+				 * fail such IO.
+				 */
+				if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
+					error = BLK_STS_IOERR;
+				else
+					error = BLK_STS_DM_REQUEUE;
+			} else
 				error = BLK_STS_DM_REQUEUE;
 			fallthrough;
 		case DM_ENDIO_DONE:
@@ -1041,7 +1051,8 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
-	if (unlikely(swap_bios_limit(ti, bio)))
+	if (static_branch_unlikely(&swap_bios_enabled) &&
+	    unlikely(swap_bios_limit(ti, bio)))
 		up(&md->swap_bios_semaphore);
 
 	free_tio(bio);
@@ -1296,21 +1307,25 @@ static void __map_bio(struct bio *clone)
 	dm_io_inc_pending(io);
 	tio->old_sector = clone->bi_iter.bi_sector;
 
-	if (unlikely(swap_bios_limit(ti, clone))) {
+	if (static_branch_unlikely(&swap_bios_enabled) &&
+	    unlikely(swap_bios_limit(ti, clone))) {
 		int latch = get_swap_bios();
 		if (unlikely(latch != md->swap_bios))
 			__set_swap_bios_limit(md, latch);
 		down(&md->swap_bios_semaphore);
 	}
 
-	/*
-	 * Check if the IO needs a special mapping due to zone append emulation
-	 * on zoned target. In this case, dm_zone_map_bio() calls the target
-	 * map operation.
-	 */
-	if (unlikely(dm_emulate_zone_append(md)))
-		r = dm_zone_map_bio(tio);
-	else
+	if (static_branch_unlikely(&zoned_enabled)) {
+		/*
+		 * Check if the IO needs a special mapping due to zone append
+		 * emulation on zoned target. In this case, dm_zone_map_bio()
+		 * calls the target map operation.
+		 */
+		if (unlikely(dm_emulate_zone_append(md)))
+			r = dm_zone_map_bio(tio);
+		else
+			r = ti->type->map(ti, clone);
+	} else
 		r = ti->type->map(ti, clone);
 
 	switch (r) {
@@ -1330,7 +1345,8 @@ static void __map_bio(struct bio *clone)
 		break;
 	case DM_MAPIO_KILL:
 	case DM_MAPIO_REQUEUE:
-		if (unlikely(swap_bios_limit(ti, clone)))
+		if (static_branch_unlikely(&swap_bios_enabled) &&
+		    unlikely(swap_bios_limit(ti, clone)))
 			up(&md->swap_bios_semaphore);
 		free_tio(clone);
 		if (r == DM_MAPIO_KILL)
@@ -1566,7 +1582,8 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->sector_count = bio_sectors(bio);
 
 	/* Shouldn't happen but sector_count was being set to 0 so... */
-	if (WARN_ON_ONCE(op_is_zone_mgmt(bio_op(bio)) && ci->sector_count))
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    WARN_ON_ONCE(op_is_zone_mgmt(bio_op(bio)) && ci->sector_count))
 		ci->sector_count = 0;
 }
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

