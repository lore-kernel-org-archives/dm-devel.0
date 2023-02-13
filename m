Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD2ABC61DA4
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 07:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676360926;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zn8p0uads0bhMNQXebKcsffcSTeMtUtmIVe0iBYr9A8=;
	b=UTMIHv2dnqs3Jm2SQulqB5CCMuAy+2W1MDhzuR0j1XaTWEGkJe/M/UUmQfJBGzAHrhQ6K7
	offBTwasAXVxJuykUT77+ZzzYkRgndZR1Z4CI/7ess/pfy6/J8MKBuny1qu9BwstZ3Nyif
	u8TruHEIdDL5GCFQ7RJIXI7HONV8P0E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-DasNYKRPPSeRnyTd6YZAfg-1; Tue, 14 Feb 2023 02:48:45 -0500
X-MC-Unique: DasNYKRPPSeRnyTd6YZAfg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0C60971085;
	Tue, 14 Feb 2023 07:48:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF315C15BA0;
	Tue, 14 Feb 2023 07:48:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8268B1946588;
	Tue, 14 Feb 2023 07:48:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A6A21946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2A732166B29; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D767C2166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A801C04344
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-AFJ6H7HzNlmnZ_mNSiXJWg-1; Mon, 13 Feb 2023 15:14:36 -0500
X-MC-Unique: AFJ6H7HzNlmnZ_mNSiXJWg-1
Received: by mail-qt1-f175.google.com with SMTP id q13so15216311qtx.2
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=W6kdnWXB6z4VmBcY7fchQfOGcEEfp9g3hZfETL4JoGM=;
 b=zScdXFx0h8ft+7h1Y94+E3i7IsQtsG3vzEcdKojrZVd3uuqQ6CKSx4FANdddJ+Zmnx
 w8GI4f3R+c5mjR6JgqnAs+tR848e3y/a9P0TwqTk1DcHdMwtNsN9Ds91qIzd19WhquFN
 wro3+iwU6T9ctox9d4atVATBJZAWDWuuuiU3UJby2LPJ82kv1lBf8qI6P92tfGSs1WM2
 mT1sZZ5qDkmizAEfH5a1AOsjgZlgASES7HU6lDLz7uBLzFet1ohFdIlYbISVsVILlIVM
 BScUGvc4GSKz3Fd/M7azMoaknI1HGkbm/CMCJ07eELaNM4kf7qKWo6f7jADSv8CDd1Ok
 6Pfg==
X-Gm-Message-State: AO0yUKWCo4bmwxXbH/tRJ6HZETvHi46zX1eWtqnDEPRsqwuQ6RPDmo2j
 8CCl32EQGwf2ApFzEVkK1jxi+46HudPUjc8NWVFBWIMuI+fskp3Tlft8sekfSF1b5bPcee/o8KX
 YZDh5do49Tzl9Ip1b8gCnteAP2L7JHPox7q6yZq4X0GK29Myi2WSC3ii2WvraQPTT6zq9aw==
X-Google-Smtp-Source: AK7set++oVkiucMUOS4fKMmtglnOeY7CagdfM1QtWW4XC8Mhr7pPAsV12hIOerF8CCh5uf8vFN8oIg==
X-Received: by 2002:a05:622a:10e:b0:3b8:6b23:4fc2 with SMTP id
 u14-20020a05622a010e00b003b86b234fc2mr42606858qtw.15.1676319273885; 
 Mon, 13 Feb 2023 12:14:33 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t66-20020a374645000000b007203bbbbb31sm10480224qka.47.2023.02.13.12.14.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:33 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:26 -0500
Message-Id: <20230213201401.45973-5-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 14 Feb 2023 07:48:03 +0000
Subject: [dm-devel] [PATCH 04/39] dm: change "unsigned" to "unsigned int"
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c                 |  10 +-
 drivers/md/dm-bio-prison-v2.c                 |  12 +-
 drivers/md/dm-bio-prison-v2.h                 |  10 +-
 drivers/md/dm-bufio.c                         |  58 ++--
 drivers/md/dm-cache-background-tracker.c      |   8 +-
 drivers/md/dm-cache-background-tracker.h      |   6 +-
 drivers/md/dm-cache-metadata.c                |  40 +--
 drivers/md/dm-cache-metadata.h                |   4 +-
 drivers/md/dm-cache-policy-internal.h         |  10 +-
 drivers/md/dm-cache-policy-smq.c              | 163 ++++-----
 drivers/md/dm-cache-policy.c                  |   2 +-
 drivers/md/dm-cache-policy.h                  |   4 +-
 drivers/md/dm-cache-target.c                  |  50 +--
 drivers/md/dm-core.h                          |   6 +-
 drivers/md/dm-crypt.c                         |  48 +--
 drivers/md/dm-delay.c                         |   6 +-
 drivers/md/dm-ebs-target.c                    |   2 +-
 drivers/md/dm-era-target.c                    |  32 +-
 drivers/md/dm-exception-store.c               |   6 +-
 drivers/md/dm-exception-store.h               |  18 +-
 drivers/md/dm-flakey.c                        |  22 +-
 drivers/md/dm-integrity.c                     | 321 +++++++++---------
 drivers/md/dm-io-rewind.c                     |   4 +-
 drivers/md/dm-io.c                            |  32 +-
 drivers/md/dm-ioctl.c                         |  18 +-
 drivers/md/dm-kcopyd.c                        |  30 +-
 drivers/md/dm-linear.c                        |   2 +-
 drivers/md/dm-log-userspace-base.c            |   6 +-
 drivers/md/dm-log-userspace-transfer.c        |   2 +-
 drivers/md/dm-log-writes.c                    |  10 +-
 drivers/md/dm-log.c                           |  10 +-
 drivers/md/dm-mpath.c                         |  46 +--
 drivers/md/dm-mpath.h                         |   2 +-
 drivers/md/dm-path-selector.h                 |   2 +-
 drivers/md/dm-ps-io-affinity.c                |   4 +-
 drivers/md/dm-ps-queue-length.c               |  10 +-
 drivers/md/dm-ps-round-robin.c                |   6 +-
 drivers/md/dm-ps-service-time.c               |  14 +-
 drivers/md/dm-raid.c                          |   2 +-
 drivers/md/dm-raid1.c                         |  22 +-
 drivers/md/dm-region-hash.c                   |  22 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-rq.h                            |   2 +-
 drivers/md/dm-snap-persistent.c               |   8 +-
 drivers/md/dm-snap-transient.c                |   6 +-
 drivers/md/dm-snap.c                          |  34 +-
 drivers/md/dm-stats.c                         |  74 ++--
 drivers/md/dm-stats.h                         |   6 +-
 drivers/md/dm-stripe.c                        |  10 +-
 drivers/md/dm-switch.c                        |  46 +--
 drivers/md/dm-table.c                         |  25 +-
 drivers/md/dm-thin-metadata.c                 |  24 +-
 drivers/md/dm-thin.c                          |  46 +--
 drivers/md/dm-uevent.c                        |   4 +-
 drivers/md/dm-uevent.h                        |   4 +-
 drivers/md/dm-verity-fec.c                    |  30 +-
 drivers/md/dm-verity-fec.h                    |  18 +-
 drivers/md/dm-verity-target.c                 |  30 +-
 drivers/md/dm-verity.h                        |   8 +-
 drivers/md/dm-writecache.c                    |  80 ++---
 drivers/md/dm.c                               |  51 ++-
 drivers/md/dm.h                               |   5 +-
 drivers/md/persistent-data/dm-array.c         |  69 ++--
 drivers/md/persistent-data/dm-array.h         |   2 +-
 drivers/md/persistent-data/dm-bitset.c        |  12 +-
 drivers/md/persistent-data/dm-block-manager.c |  16 +-
 drivers/md/persistent-data/dm-block-manager.h |   6 +-
 drivers/md/persistent-data/dm-btree-remove.c  |  46 +--
 drivers/md/persistent-data/dm-btree-spine.c   |   4 +-
 drivers/md/persistent-data/dm-btree.c         |  98 +++---
 drivers/md/persistent-data/dm-btree.h         |  12 +-
 .../dm-persistent-data-internal.h             |   6 +-
 .../md/persistent-data/dm-space-map-common.c  |  28 +-
 .../persistent-data/dm-space-map-metadata.c   |  20 +-
 .../persistent-data/dm-transaction-manager.c  |  16 +-
 .../persistent-data/dm-transaction-manager.h  |   2 +-
 include/linux/device-mapper.h                 |  38 +--
 include/linux/dm-bufio.h                      |  12 +-
 include/linux/dm-dirty-log.h                  |   6 +-
 include/linux/dm-io.h                         |   8 +-
 include/linux/dm-kcopyd.h                     |  22 +-
 include/linux/dm-region-hash.h                |   2 +-
 82 files changed, 1016 insertions(+), 1018 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index db7d95d3bb5e..aa58b0671a79 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -286,14 +286,14 @@ EXPORT_SYMBOL_GPL(dm_cell_promote_or_release);
 
 struct dm_deferred_entry {
 	struct dm_deferred_set *ds;
-	unsigned count;
+	unsigned int count;
 	struct list_head work_items;
 };
 
 struct dm_deferred_set {
 	spinlock_t lock;
-	unsigned current_entry;
-	unsigned sweeper;
+	unsigned int current_entry;
+	unsigned int sweeper;
 	struct dm_deferred_entry entries[DEFERRED_SET_SIZE];
 };
 
@@ -339,7 +339,7 @@ struct dm_deferred_entry *dm_deferred_entry_inc(struct dm_deferred_set *ds)
 }
 EXPORT_SYMBOL_GPL(dm_deferred_entry_inc);
 
-static unsigned ds_next(unsigned index)
+static unsigned int ds_next(unsigned int index)
 {
 	return (index + 1) % DEFERRED_SET_SIZE;
 }
@@ -374,7 +374,7 @@ EXPORT_SYMBOL_GPL(dm_deferred_entry_dec);
 int dm_deferred_set_add_work(struct dm_deferred_set *ds, struct list_head *work)
 {
 	int r = 1;
-	unsigned next_entry;
+	unsigned int next_entry;
 
 	spin_lock_irq(&ds->lock);
 	if ((ds->sweeper == ds->current_entry) &&
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 09b84f0c1fbf..3b4875a8488c 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -149,7 +149,7 @@ static bool __find_or_insert(struct dm_bio_prison_v2 *prison,
 
 static bool __get(struct dm_bio_prison_v2 *prison,
 		  struct dm_cell_key_v2 *key,
-		  unsigned lock_level,
+		  unsigned int lock_level,
 		  struct bio *inmate,
 		  struct dm_bio_prison_cell_v2 *cell_prealloc,
 		  struct dm_bio_prison_cell_v2 **cell)
@@ -172,7 +172,7 @@ static bool __get(struct dm_bio_prison_v2 *prison,
 
 bool dm_cell_get_v2(struct dm_bio_prison_v2 *prison,
 		    struct dm_cell_key_v2 *key,
-		    unsigned lock_level,
+		    unsigned int lock_level,
 		    struct bio *inmate,
 		    struct dm_bio_prison_cell_v2 *cell_prealloc,
 		    struct dm_bio_prison_cell_v2 **cell_result)
@@ -225,7 +225,7 @@ EXPORT_SYMBOL_GPL(dm_cell_put_v2);
 
 static int __lock(struct dm_bio_prison_v2 *prison,
 		  struct dm_cell_key_v2 *key,
-		  unsigned lock_level,
+		  unsigned int lock_level,
 		  struct dm_bio_prison_cell_v2 *cell_prealloc,
 		  struct dm_bio_prison_cell_v2 **cell_result)
 {
@@ -256,7 +256,7 @@ static int __lock(struct dm_bio_prison_v2 *prison,
 
 int dm_cell_lock_v2(struct dm_bio_prison_v2 *prison,
 		    struct dm_cell_key_v2 *key,
-		    unsigned lock_level,
+		    unsigned int lock_level,
 		    struct dm_bio_prison_cell_v2 *cell_prealloc,
 		    struct dm_bio_prison_cell_v2 **cell_result)
 {
@@ -292,7 +292,7 @@ EXPORT_SYMBOL_GPL(dm_cell_quiesce_v2);
 
 static int __promote(struct dm_bio_prison_v2 *prison,
 		     struct dm_bio_prison_cell_v2 *cell,
-		     unsigned new_lock_level)
+		     unsigned int new_lock_level)
 {
 	if (!cell->exclusive_lock)
 		return -EINVAL;
@@ -303,7 +303,7 @@ static int __promote(struct dm_bio_prison_v2 *prison,
 
 int dm_cell_lock_promote_v2(struct dm_bio_prison_v2 *prison,
 			    struct dm_bio_prison_cell_v2 *cell,
-			    unsigned new_lock_level)
+			    unsigned int new_lock_level)
 {
 	int r;
 
diff --git a/drivers/md/dm-bio-prison-v2.h b/drivers/md/dm-bio-prison-v2.h
index 3059f3f7656d..8f8423090230 100644
--- a/drivers/md/dm-bio-prison-v2.h
+++ b/drivers/md/dm-bio-prison-v2.h
@@ -45,8 +45,8 @@ struct dm_cell_key_v2 {
 struct dm_bio_prison_cell_v2 {
 	// FIXME: pack these
 	bool exclusive_lock;
-	unsigned exclusive_level;
-	unsigned shared_count;
+	unsigned int exclusive_level;
+	unsigned int shared_count;
 	struct work_struct *quiesce_continuation;
 
 	struct rb_node node;
@@ -87,7 +87,7 @@ void dm_bio_prison_free_cell_v2(struct dm_bio_prison_v2 *prison,
  */
 bool dm_cell_get_v2(struct dm_bio_prison_v2 *prison,
 		    struct dm_cell_key_v2 *key,
-		    unsigned lock_level,
+		    unsigned int lock_level,
 		    struct bio *inmate,
 		    struct dm_bio_prison_cell_v2 *cell_prealloc,
 		    struct dm_bio_prison_cell_v2 **cell_result);
@@ -115,7 +115,7 @@ bool dm_cell_put_v2(struct dm_bio_prison_v2 *prison,
  */
 int dm_cell_lock_v2(struct dm_bio_prison_v2 *prison,
 		    struct dm_cell_key_v2 *key,
-		    unsigned lock_level,
+		    unsigned int lock_level,
 		    struct dm_bio_prison_cell_v2 *cell_prealloc,
 		    struct dm_bio_prison_cell_v2 **cell_result);
 
@@ -133,7 +133,7 @@ void dm_cell_quiesce_v2(struct dm_bio_prison_v2 *prison,
  */
 int dm_cell_lock_promote_v2(struct dm_bio_prison_v2 *prison,
 			    struct dm_bio_prison_cell_v2 *cell,
-			    unsigned new_lock_level);
+			    unsigned int new_lock_level);
 
 /*
  * Adds any held bios to the bio list.
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b16e6b215726..6c5f551d8e44 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -90,7 +90,7 @@ struct dm_bufio_client {
 	unsigned long n_buffers[LIST_SIZE];
 
 	struct block_device *bdev;
-	unsigned block_size;
+	unsigned int block_size;
 	s8 sectors_per_block_bits;
 	void (*alloc_callback)(struct dm_buffer *);
 	void (*write_callback)(struct dm_buffer *);
@@ -99,9 +99,9 @@ struct dm_bufio_client {
 	struct dm_io_client *dm_io;
 
 	struct list_head reserved_buffers;
-	unsigned need_reserved_buffers;
+	unsigned int need_reserved_buffers;
 
-	unsigned minimum_buffers;
+	unsigned int minimum_buffers;
 
 	struct rb_root buffer_tree;
 	wait_queue_head_t free_buffer_wait;
@@ -146,14 +146,14 @@ struct dm_buffer {
 	unsigned char list_mode;		/* LIST_* */
 	blk_status_t read_error;
 	blk_status_t write_error;
-	unsigned accessed;
-	unsigned hold_count;
+	unsigned int accessed;
+	unsigned int hold_count;
 	unsigned long state;
 	unsigned long last_accessed;
-	unsigned dirty_start;
-	unsigned dirty_end;
-	unsigned write_start;
-	unsigned write_end;
+	unsigned int dirty_start;
+	unsigned int dirty_end;
+	unsigned int write_start;
+	unsigned int write_end;
 	struct dm_bufio_client *c;
 	struct list_head write_list;
 	void (*end_io)(struct dm_buffer *, blk_status_t);
@@ -221,7 +221,7 @@ static unsigned long global_num = 0;
 /*
  * Buffers are freed after this timeout
  */
-static unsigned dm_bufio_max_age = DM_BUFIO_DEFAULT_AGE_SECS;
+static unsigned int dm_bufio_max_age = DM_BUFIO_DEFAULT_AGE_SECS;
 static unsigned long dm_bufio_retain_bytes = DM_BUFIO_DEFAULT_RETAIN_BYTES;
 
 static unsigned long dm_bufio_peak_allocated;
@@ -439,7 +439,7 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	 * as if GFP_NOIO was specified.
 	 */
 	if (gfp_mask & __GFP_NORETRY) {
-		unsigned noio_flag = memalloc_noio_save();
+		unsigned int noio_flag = memalloc_noio_save();
 		void *ptr = __vmalloc(c->block_size, gfp_mask);
 
 		memalloc_noio_restore(noio_flag);
@@ -592,7 +592,7 @@ static void dmio_complete(unsigned long error, void *context)
 }
 
 static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		     unsigned n_sectors, unsigned offset)
+		     unsigned int n_sectors, unsigned int offset)
 {
 	int r;
 	struct dm_io_request io_req = {
@@ -630,11 +630,11 @@ static void bio_complete(struct bio *bio)
 }
 
 static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		    unsigned n_sectors, unsigned offset)
+		    unsigned int n_sectors, unsigned int offset)
 {
 	struct bio *bio;
 	char *ptr;
-	unsigned vec_size, len;
+	unsigned int vec_size, len;
 
 	vec_size = b->c->block_size >> PAGE_SHIFT;
 	if (unlikely(b->c->sectors_per_block_bits < PAGE_SHIFT - SECTOR_SHIFT))
@@ -655,7 +655,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 	len = n_sectors << SECTOR_SHIFT;
 
 	do {
-		unsigned this_step = min((unsigned)(PAGE_SIZE - offset_in_page(ptr)), len);
+		unsigned int this_step = min((unsigned int)(PAGE_SIZE - offset_in_page(ptr)), len);
 		if (!bio_add_page(bio, virt_to_page(ptr), this_step,
 				  offset_in_page(ptr))) {
 			bio_put(bio);
@@ -685,9 +685,9 @@ static inline sector_t block_to_sector(struct dm_bufio_client *c, sector_t block
 static void submit_io(struct dm_buffer *b, enum req_op op,
 		      void (*end_io)(struct dm_buffer *, blk_status_t))
 {
-	unsigned n_sectors;
+	unsigned int n_sectors;
 	sector_t sector;
-	unsigned offset, end;
+	unsigned int offset, end;
 
 	b->end_io = end_io;
 
@@ -1157,7 +1157,7 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
 void dm_bufio_prefetch(struct dm_bufio_client *c,
-		       sector_t block, unsigned n_blocks)
+		       sector_t block, unsigned int n_blocks)
 {
 	struct blk_plug plug;
 
@@ -1233,7 +1233,7 @@ void dm_bufio_release(struct dm_buffer *b)
 EXPORT_SYMBOL_GPL(dm_bufio_release);
 
 void dm_bufio_mark_partial_buffer_dirty(struct dm_buffer *b,
-					unsigned start, unsigned end)
+					unsigned int start, unsigned int end)
 {
 	struct dm_bufio_client *c = b->c;
 
@@ -1530,13 +1530,13 @@ void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t
 }
 EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);
 
-void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n)
+void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
 {
 	c->minimum_buffers = n;
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
 
-unsigned dm_bufio_get_block_size(struct dm_bufio_client *c)
+unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
 }
@@ -1735,15 +1735,15 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 /*
  * Create the buffering interface
  */
-struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
-					       unsigned reserved_buffers, unsigned aux_size,
+struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned int block_size,
+					       unsigned int reserved_buffers, unsigned int aux_size,
 					       void (*alloc_callback)(struct dm_buffer *),
 					       void (*write_callback)(struct dm_buffer *),
 					       unsigned int flags)
 {
 	int r;
 	struct dm_bufio_client *c;
-	unsigned i;
+	unsigned int i;
 	char slab_name[27];
 
 	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
@@ -1797,7 +1797,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	if (block_size <= KMALLOC_MAX_SIZE &&
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
-		unsigned align = min(1U << __ffs(block_size), (unsigned)PAGE_SIZE);
+		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", block_size);
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
@@ -1873,7 +1873,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_client_create);
  */
 void dm_bufio_client_destroy(struct dm_bufio_client *c)
 {
-	unsigned i;
+	unsigned int i;
 
 	drop_buffers(c);
 
@@ -1921,9 +1921,9 @@ void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);
 
-static unsigned get_max_age_hz(void)
+static unsigned int get_max_age_hz(void)
 {
-	unsigned max_age = READ_ONCE(dm_bufio_max_age);
+	unsigned int max_age = READ_ONCE(dm_bufio_max_age);
 
 	if (max_age > UINT_MAX / HZ)
 		max_age = UINT_MAX / HZ;
@@ -1974,7 +1974,7 @@ static void do_global_cleanup(struct work_struct *w)
 	struct dm_bufio_client *locked_client = NULL;
 	struct dm_bufio_client *current_client;
 	struct dm_buffer *b;
-	unsigned spinlock_hold_count;
+	unsigned int spinlock_hold_count;
 	unsigned long threshold = dm_bufio_cache_size -
 		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
 	unsigned long loops = global_num * 2;
diff --git a/drivers/md/dm-cache-background-tracker.c b/drivers/md/dm-cache-background-tracker.c
index 67d9b9309032..5b399e652604 100644
--- a/drivers/md/dm-cache-background-tracker.c
+++ b/drivers/md/dm-cache-background-tracker.c
@@ -18,7 +18,7 @@ struct bt_work {
 };
 
 struct background_tracker {
-	unsigned max_work;
+	unsigned int max_work;
 	atomic_t pending_promotes;
 	atomic_t pending_writebacks;
 	atomic_t pending_demotes;
@@ -30,7 +30,7 @@ struct background_tracker {
 	struct kmem_cache *work_cache;
 };
 
-struct background_tracker *btracker_create(unsigned max_work)
+struct background_tracker *btracker_create(unsigned int max_work)
 {
 	struct background_tracker *b = kmalloc(sizeof(*b), GFP_KERNEL);
 
@@ -156,13 +156,13 @@ static void update_stats(struct background_tracker *b, struct policy_work *w, in
 	}
 }
 
-unsigned btracker_nr_writebacks_queued(struct background_tracker *b)
+unsigned int btracker_nr_writebacks_queued(struct background_tracker *b)
 {
 	return atomic_read(&b->pending_writebacks);
 }
 EXPORT_SYMBOL_GPL(btracker_nr_writebacks_queued);
 
-unsigned btracker_nr_demotions_queued(struct background_tracker *b)
+unsigned int btracker_nr_demotions_queued(struct background_tracker *b)
 {
 	return atomic_read(&b->pending_demotes);
 }
diff --git a/drivers/md/dm-cache-background-tracker.h b/drivers/md/dm-cache-background-tracker.h
index a42209c24ec2..aa09cea36890 100644
--- a/drivers/md/dm-cache-background-tracker.h
+++ b/drivers/md/dm-cache-background-tracker.h
@@ -33,7 +33,7 @@ struct background_tracker;
  * Create a new tracker, it will not be able to queue more than
  * 'max_work' entries.
  */
-struct background_tracker *btracker_create(unsigned max_work);
+struct background_tracker *btracker_create(unsigned int max_work);
 
 /*
  * Destroy the tracker. No issued, but not complete, work should
@@ -42,8 +42,8 @@ struct background_tracker *btracker_create(unsigned max_work);
  */
 void btracker_destroy(struct background_tracker *b);
 
-unsigned btracker_nr_writebacks_queued(struct background_tracker *b);
-unsigned btracker_nr_demotions_queued(struct background_tracker *b);
+unsigned int btracker_nr_writebacks_queued(struct background_tracker *b);
+unsigned int btracker_nr_demotions_queued(struct background_tracker *b);
 
 /*
  * Queue some work within the tracker. 'work' should point to the work
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index ba8abd5cb5b4..94634a901157 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -105,7 +105,7 @@ struct dm_cache_metadata {
 	refcount_t ref_count;
 	struct list_head list;
 
-	unsigned version;
+	unsigned int version;
 	struct block_device *bdev;
 	struct dm_block_manager *bm;
 	struct dm_space_map *metadata_sm;
@@ -130,7 +130,7 @@ struct dm_cache_metadata {
 	bool clean_when_opened:1;
 
 	char policy_name[CACHE_POLICY_NAME_SIZE];
-	unsigned policy_version[CACHE_POLICY_VERSION_SIZE];
+	unsigned int policy_version[CACHE_POLICY_VERSION_SIZE];
 	size_t policy_hint_size;
 	struct dm_cache_statistics stats;
 
@@ -261,10 +261,10 @@ static int superblock_lock(struct dm_cache_metadata *cmd,
 static int __superblock_all_zeroes(struct dm_block_manager *bm, bool *result)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct dm_block *b;
 	__le64 *data_le, zero = cpu_to_le64(0);
-	unsigned sb_block_size = dm_bm_block_size(bm) / sizeof(__le64);
+	unsigned int sb_block_size = dm_bm_block_size(bm) / sizeof(__le64);
 
 	/*
 	 * We can't use a validator here - it may be all zeroes.
@@ -728,7 +728,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
  */
 #define FLAGS_MASK ((1 << 16) - 1)
 
-static __le64 pack_value(dm_oblock_t block, unsigned flags)
+static __le64 pack_value(dm_oblock_t block, unsigned int flags)
 {
 	uint64_t value = from_oblock(block);
 	value <<= 16;
@@ -736,7 +736,7 @@ static __le64 pack_value(dm_oblock_t block, unsigned flags)
 	return cpu_to_le64(value);
 }
 
-static void unpack_value(__le64 value_le, dm_oblock_t *block, unsigned *flags)
+static void unpack_value(__le64 value_le, dm_oblock_t *block, unsigned int *flags)
 {
 	uint64_t value = le64_to_cpu(value_le);
 	uint64_t b = value >> 16;
@@ -750,7 +750,7 @@ static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
 					       sector_t data_block_size,
 					       bool may_format_device,
 					       size_t policy_hint_size,
-					       unsigned metadata_version)
+					       unsigned int metadata_version)
 {
 	int r;
 	struct dm_cache_metadata *cmd;
@@ -811,7 +811,7 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
 						sector_t data_block_size,
 						bool may_format_device,
 						size_t policy_hint_size,
-						unsigned metadata_version)
+						unsigned int metadata_version)
 {
 	struct dm_cache_metadata *cmd, *cmd2;
 
@@ -856,7 +856,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 						 sector_t data_block_size,
 						 bool may_format_device,
 						 size_t policy_hint_size,
-						 unsigned metadata_version)
+						 unsigned int metadata_version)
 {
 	struct dm_cache_metadata *cmd = lookup_or_open(bdev, data_block_size, may_format_device,
 						       policy_hint_size, metadata_version);
@@ -891,7 +891,7 @@ static int block_clean_combined_dirty(struct dm_cache_metadata *cmd, dm_cblock_t
 	int r;
 	__le64 value;
 	dm_oblock_t ob;
-	unsigned flags;
+	unsigned int flags;
 
 	r = dm_array_get_value(&cmd->info, cmd->root, from_cblock(b), &value);
 	if (r)
@@ -1289,7 +1289,7 @@ static bool policy_unchanged(struct dm_cache_metadata *cmd,
 			     struct dm_cache_policy *policy)
 {
 	const char *policy_name = dm_cache_policy_get_name(policy);
-	const unsigned *policy_version = dm_cache_policy_get_version(policy);
+	const unsigned int *policy_version = dm_cache_policy_get_version(policy);
 	size_t policy_hint_size = dm_cache_policy_get_hint_size(policy);
 
 	/*
@@ -1340,7 +1340,7 @@ static int __load_mapping_v1(struct dm_cache_metadata *cmd,
 	__le32 *hint_value_le;
 
 	dm_oblock_t oblock;
-	unsigned flags;
+	unsigned int flags;
 	bool dirty = true;
 
 	dm_array_cursor_get_value(mapping_cursor, (void **) &mapping_value_le);
@@ -1382,7 +1382,7 @@ static int __load_mapping_v2(struct dm_cache_metadata *cmd,
 	__le32 *hint_value_le;
 
 	dm_oblock_t oblock;
-	unsigned flags;
+	unsigned int flags;
 	bool dirty = true;
 
 	dm_array_cursor_get_value(mapping_cursor, (void **) &mapping_value_le);
@@ -1514,7 +1514,7 @@ static int __dump_mapping(void *context, uint64_t cblock, void *leaf)
 {
 	__le64 value;
 	dm_oblock_t oblock;
-	unsigned flags;
+	unsigned int flags;
 
 	memcpy(&value, leaf, sizeof(value));
 	unpack_value(value, &oblock, &flags);
@@ -1548,7 +1548,7 @@ int dm_cache_changed_this_transaction(struct dm_cache_metadata *cmd)
 static int __dirty(struct dm_cache_metadata *cmd, dm_cblock_t cblock, bool dirty)
 {
 	int r;
-	unsigned flags;
+	unsigned int flags;
 	dm_oblock_t oblock;
 	__le64 value;
 
@@ -1575,10 +1575,10 @@ static int __dirty(struct dm_cache_metadata *cmd, dm_cblock_t cblock, bool dirty
 
 }
 
-static int __set_dirty_bits_v1(struct dm_cache_metadata *cmd, unsigned nr_bits, unsigned long *bits)
+static int __set_dirty_bits_v1(struct dm_cache_metadata *cmd, unsigned int nr_bits, unsigned long *bits)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	for (i = 0; i < nr_bits; i++) {
 		r = __dirty(cmd, to_cblock(i), test_bit(i, bits));
 		if (r)
@@ -1595,7 +1595,7 @@ static int is_dirty_callback(uint32_t index, bool *value, void *context)
 	return 0;
 }
 
-static int __set_dirty_bits_v2(struct dm_cache_metadata *cmd, unsigned nr_bits, unsigned long *bits)
+static int __set_dirty_bits_v2(struct dm_cache_metadata *cmd, unsigned int nr_bits, unsigned long *bits)
 {
 	int r = 0;
 
@@ -1614,7 +1614,7 @@ static int __set_dirty_bits_v2(struct dm_cache_metadata *cmd, unsigned nr_bits,
 }
 
 int dm_cache_set_dirty_bits(struct dm_cache_metadata *cmd,
-			    unsigned nr_bits,
+			    unsigned int nr_bits,
 			    unsigned long *bits)
 {
 	int r;
@@ -1713,7 +1713,7 @@ static int write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
 	int r;
 	size_t hint_size;
 	const char *policy_name = dm_cache_policy_get_name(policy);
-	const unsigned *policy_version = dm_cache_policy_get_version(policy);
+	const unsigned int *policy_version = dm_cache_policy_get_version(policy);
 
 	if (!policy_name[0] ||
 	    (strlen(policy_name) > sizeof(cmd->policy_name) - 1))
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index c20d3f29ef12..23be396d8608 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -61,7 +61,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 						 sector_t data_block_size,
 						 bool may_format_device,
 						 size_t policy_hint_size,
-						 unsigned metadata_version);
+						 unsigned int metadata_version);
 
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd);
 
@@ -97,7 +97,7 @@ int dm_cache_load_mappings(struct dm_cache_metadata *cmd,
 			   void *context);
 
 int dm_cache_set_dirty_bits(struct dm_cache_metadata *cmd,
-			    unsigned nr_bits, unsigned long *bits);
+			    unsigned int nr_bits, unsigned long *bits);
 
 struct dm_cache_statistics {
 	uint32_t read_hits;
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 43f0808d09e3..22f2cc3ceb6e 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -86,7 +86,7 @@ static inline void policy_tick(struct dm_cache_policy *p, bool can_block)
 }
 
 static inline int policy_emit_config_values(struct dm_cache_policy *p, char *result,
-					    unsigned maxlen, ssize_t *sz_ptr)
+					    unsigned int maxlen, ssize_t *sz_ptr)
 {
 	ssize_t sz = *sz_ptr;
 	if (p->emit_config_values)
@@ -113,18 +113,18 @@ static inline void policy_allow_migrations(struct dm_cache_policy *p, bool allow
 /*
  * Some utility functions commonly used by policies and the core target.
  */
-static inline size_t bitset_size_in_bytes(unsigned nr_entries)
+static inline size_t bitset_size_in_bytes(unsigned int nr_entries)
 {
 	return sizeof(unsigned long) * dm_div_up(nr_entries, BITS_PER_LONG);
 }
 
-static inline unsigned long *alloc_bitset(unsigned nr_entries)
+static inline unsigned long *alloc_bitset(unsigned int nr_entries)
 {
 	size_t s = bitset_size_in_bytes(nr_entries);
 	return vzalloc(s);
 }
 
-static inline void clear_bitset(void *bitset, unsigned nr_entries)
+static inline void clear_bitset(void *bitset, unsigned int nr_entries)
 {
 	size_t s = bitset_size_in_bytes(nr_entries);
 	memset(bitset, 0, s);
@@ -155,7 +155,7 @@ void dm_cache_policy_destroy(struct dm_cache_policy *p);
  */
 const char *dm_cache_policy_get_name(struct dm_cache_policy *p);
 
-const unsigned *dm_cache_policy_get_version(struct dm_cache_policy *p);
+const unsigned int *dm_cache_policy_get_version(struct dm_cache_policy *p);
 
 size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p);
 
diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 2c8b2ce8b7fe..8cb1c7c3e1e1 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -24,12 +24,12 @@
 /*
  * Safe division functions that return zero on divide by zero.
  */
-static unsigned safe_div(unsigned n, unsigned d)
+static unsigned int safe_div(unsigned int n, unsigned int d)
 {
 	return d ? n / d : 0u;
 }
 
-static unsigned safe_mod(unsigned n, unsigned d)
+static unsigned int safe_mod(unsigned int n, unsigned int d)
 {
 	return d ? n % d : 0u;
 }
@@ -37,10 +37,10 @@ static unsigned safe_mod(unsigned n, unsigned d)
 /*----------------------------------------------------------------*/
 
 struct entry {
-	unsigned hash_next:28;
-	unsigned prev:28;
-	unsigned next:28;
-	unsigned level:6;
+	unsigned int hash_next:28;
+	unsigned int prev:28;
+	unsigned int next:28;
+	unsigned int level:6;
 	bool dirty:1;
 	bool allocated:1;
 	bool sentinel:1;
@@ -63,7 +63,7 @@ struct entry_space {
 	struct entry *end;
 };
 
-static int space_init(struct entry_space *es, unsigned nr_entries)
+static int space_init(struct entry_space *es, unsigned int nr_entries)
 {
 	if (!nr_entries) {
 		es->begin = es->end = NULL;
@@ -83,7 +83,7 @@ static void space_exit(struct entry_space *es)
 	vfree(es->begin);
 }
 
-static struct entry *__get_entry(struct entry_space *es, unsigned block)
+static struct entry *__get_entry(struct entry_space *es, unsigned int block)
 {
 	struct entry *e;
 
@@ -93,13 +93,13 @@ static struct entry *__get_entry(struct entry_space *es, unsigned block)
 	return e;
 }
 
-static unsigned to_index(struct entry_space *es, struct entry *e)
+static unsigned int to_index(struct entry_space *es, struct entry *e)
 {
 	BUG_ON(e < es->begin || e >= es->end);
 	return e - es->begin;
 }
 
-static struct entry *to_entry(struct entry_space *es, unsigned block)
+static struct entry *to_entry(struct entry_space *es, unsigned int block)
 {
 	if (block == INDEXER_NULL)
 		return NULL;
@@ -110,8 +110,8 @@ static struct entry *to_entry(struct entry_space *es, unsigned block)
 /*----------------------------------------------------------------*/
 
 struct ilist {
-	unsigned nr_elts;	/* excluding sentinel entries */
-	unsigned head, tail;
+	unsigned int nr_elts;	/* excluding sentinel entries */
+	unsigned int head, tail;
 };
 
 static void l_init(struct ilist *l)
@@ -253,23 +253,23 @@ static struct entry *l_pop_tail(struct entry_space *es, struct ilist *l)
 struct queue {
 	struct entry_space *es;
 
-	unsigned nr_elts;
-	unsigned nr_levels;
+	unsigned int nr_elts;
+	unsigned int nr_levels;
 	struct ilist qs[MAX_LEVELS];
 
 	/*
 	 * We maintain a count of the number of entries we would like in each
 	 * level.
 	 */
-	unsigned last_target_nr_elts;
-	unsigned nr_top_levels;
-	unsigned nr_in_top_levels;
-	unsigned target_count[MAX_LEVELS];
+	unsigned int last_target_nr_elts;
+	unsigned int nr_top_levels;
+	unsigned int nr_in_top_levels;
+	unsigned int target_count[MAX_LEVELS];
 };
 
-static void q_init(struct queue *q, struct entry_space *es, unsigned nr_levels)
+static void q_init(struct queue *q, struct entry_space *es, unsigned int nr_levels)
 {
-	unsigned i;
+	unsigned int i;
 
 	q->es = es;
 	q->nr_elts = 0;
@@ -285,7 +285,7 @@ static void q_init(struct queue *q, struct entry_space *es, unsigned nr_levels)
 	q->nr_in_top_levels = 0u;
 }
 
-static unsigned q_size(struct queue *q)
+static unsigned int q_size(struct queue *q)
 {
 	return q->nr_elts;
 }
@@ -333,9 +333,9 @@ static void q_del(struct queue *q, struct entry *e)
 /*
  * Return the oldest entry of the lowest populated level.
  */
-static struct entry *q_peek(struct queue *q, unsigned max_level, bool can_cross_sentinel)
+static struct entry *q_peek(struct queue *q, unsigned int max_level, bool can_cross_sentinel)
 {
-	unsigned level;
+	unsigned int level;
 	struct entry *e;
 
 	max_level = min(max_level, q->nr_levels);
@@ -370,7 +370,7 @@ static struct entry *q_pop(struct queue *q)
  * used by redistribute, so we know this is true.  It also doesn't adjust
  * the q->nr_elts count.
  */
-static struct entry *__redist_pop_from(struct queue *q, unsigned level)
+static struct entry *__redist_pop_from(struct queue *q, unsigned int level)
 {
 	struct entry *e;
 
@@ -384,9 +384,10 @@ static struct entry *__redist_pop_from(struct queue *q, unsigned level)
 	return NULL;
 }
 
-static void q_set_targets_subrange_(struct queue *q, unsigned nr_elts, unsigned lbegin, unsigned lend)
+static void q_set_targets_subrange_(struct queue *q, unsigned int nr_elts,
+				    unsigned int lbegin, unsigned int lend)
 {
-	unsigned level, nr_levels, entries_per_level, remainder;
+	unsigned int level, nr_levels, entries_per_level, remainder;
 
 	BUG_ON(lbegin > lend);
 	BUG_ON(lend > q->nr_levels);
@@ -427,7 +428,7 @@ static void q_set_targets(struct queue *q)
 
 static void q_redistribute(struct queue *q)
 {
-	unsigned target, level;
+	unsigned int target, level;
 	struct ilist *l, *l_above;
 	struct entry *e;
 
@@ -468,12 +469,12 @@ static void q_redistribute(struct queue *q)
 	}
 }
 
-static void q_requeue(struct queue *q, struct entry *e, unsigned extra_levels,
+static void q_requeue(struct queue *q, struct entry *e, unsigned int extra_levels,
 		      struct entry *s1, struct entry *s2)
 {
 	struct entry *de;
-	unsigned sentinels_passed = 0;
-	unsigned new_level = min(q->nr_levels - 1u, e->level + extra_levels);
+	unsigned int sentinels_passed = 0;
+	unsigned int new_level = min(q->nr_levels - 1u, e->level + extra_levels);
 
 	/* try and find an entry to swap with */
 	if (extra_levels && (e->level < q->nr_levels - 1u)) {
@@ -513,9 +514,9 @@ static void q_requeue(struct queue *q, struct entry *e, unsigned extra_levels,
 #define EIGHTH (1u << (FP_SHIFT - 3u))
 
 struct stats {
-	unsigned hit_threshold;
-	unsigned hits;
-	unsigned misses;
+	unsigned int hit_threshold;
+	unsigned int hits;
+	unsigned int misses;
 };
 
 enum performance {
@@ -524,7 +525,7 @@ enum performance {
 	Q_WELL
 };
 
-static void stats_init(struct stats *s, unsigned nr_levels)
+static void stats_init(struct stats *s, unsigned int nr_levels)
 {
 	s->hit_threshold = (nr_levels * 3u) / 4u;
 	s->hits = 0u;
@@ -536,7 +537,7 @@ static void stats_reset(struct stats *s)
 	s->hits = s->misses = 0u;
 }
 
-static void stats_level_accessed(struct stats *s, unsigned level)
+static void stats_level_accessed(struct stats *s, unsigned int level)
 {
 	if (level >= s->hit_threshold)
 		s->hits++;
@@ -557,7 +558,7 @@ static void stats_miss(struct stats *s)
  */
 static enum performance stats_assess(struct stats *s)
 {
-	unsigned confidence = safe_div(s->hits << FP_SHIFT, s->hits + s->misses);
+	unsigned int confidence = safe_div(s->hits << FP_SHIFT, s->hits + s->misses);
 
 	if (confidence < SIXTEENTH)
 		return Q_POOR;
@@ -574,16 +575,16 @@ static enum performance stats_assess(struct stats *s)
 struct smq_hash_table {
 	struct entry_space *es;
 	unsigned long long hash_bits;
-	unsigned *buckets;
+	unsigned int *buckets;
 };
 
 /*
  * All cache entries are stored in a chained hash table.  To save space we
  * use indexing again, and only store indexes to the next entry.
  */
-static int h_init(struct smq_hash_table *ht, struct entry_space *es, unsigned nr_entries)
+static int h_init(struct smq_hash_table *ht, struct entry_space *es, unsigned int nr_entries)
 {
-	unsigned i, nr_buckets;
+	unsigned int i, nr_buckets;
 
 	ht->es = es;
 	nr_buckets = roundup_pow_of_two(max(nr_entries / 4u, 16u));
@@ -604,7 +605,7 @@ static void h_exit(struct smq_hash_table *ht)
 	vfree(ht->buckets);
 }
 
-static struct entry *h_head(struct smq_hash_table *ht, unsigned bucket)
+static struct entry *h_head(struct smq_hash_table *ht, unsigned int bucket)
 {
 	return to_entry(ht->es, ht->buckets[bucket]);
 }
@@ -614,7 +615,7 @@ static struct entry *h_next(struct smq_hash_table *ht, struct entry *e)
 	return to_entry(ht->es, e->hash_next);
 }
 
-static void __h_insert(struct smq_hash_table *ht, unsigned bucket, struct entry *e)
+static void __h_insert(struct smq_hash_table *ht, unsigned int bucket, struct entry *e)
 {
 	e->hash_next = ht->buckets[bucket];
 	ht->buckets[bucket] = to_index(ht->es, e);
@@ -622,11 +623,11 @@ static void __h_insert(struct smq_hash_table *ht, unsigned bucket, struct entry
 
 static void h_insert(struct smq_hash_table *ht, struct entry *e)
 {
-	unsigned h = hash_64(from_oblock(e->oblock), ht->hash_bits);
+	unsigned int h = hash_64(from_oblock(e->oblock), ht->hash_bits);
 	__h_insert(ht, h, e);
 }
 
-static struct entry *__h_lookup(struct smq_hash_table *ht, unsigned h, dm_oblock_t oblock,
+static struct entry *__h_lookup(struct smq_hash_table *ht, unsigned int h, dm_oblock_t oblock,
 				struct entry **prev)
 {
 	struct entry *e;
@@ -642,7 +643,7 @@ static struct entry *__h_lookup(struct smq_hash_table *ht, unsigned h, dm_oblock
 	return NULL;
 }
 
-static void __h_unlink(struct smq_hash_table *ht, unsigned h,
+static void __h_unlink(struct smq_hash_table *ht, unsigned int h,
 		       struct entry *e, struct entry *prev)
 {
 	if (prev)
@@ -657,7 +658,7 @@ static void __h_unlink(struct smq_hash_table *ht, unsigned h,
 static struct entry *h_lookup(struct smq_hash_table *ht, dm_oblock_t oblock)
 {
 	struct entry *e, *prev;
-	unsigned h = hash_64(from_oblock(oblock), ht->hash_bits);
+	unsigned int h = hash_64(from_oblock(oblock), ht->hash_bits);
 
 	e = __h_lookup(ht, h, oblock, &prev);
 	if (e && prev) {
@@ -674,7 +675,7 @@ static struct entry *h_lookup(struct smq_hash_table *ht, dm_oblock_t oblock)
 
 static void h_remove(struct smq_hash_table *ht, struct entry *e)
 {
-	unsigned h = hash_64(from_oblock(e->oblock), ht->hash_bits);
+	unsigned int h = hash_64(from_oblock(e->oblock), ht->hash_bits);
 	struct entry *prev;
 
 	/*
@@ -690,16 +691,16 @@ static void h_remove(struct smq_hash_table *ht, struct entry *e)
 
 struct entry_alloc {
 	struct entry_space *es;
-	unsigned begin;
+	unsigned int begin;
 
-	unsigned nr_allocated;
+	unsigned int nr_allocated;
 	struct ilist free;
 };
 
 static void init_allocator(struct entry_alloc *ea, struct entry_space *es,
-			   unsigned begin, unsigned end)
+			   unsigned int begin, unsigned int end)
 {
-	unsigned i;
+	unsigned int i;
 
 	ea->es = es;
 	ea->nr_allocated = 0u;
@@ -743,7 +744,7 @@ static struct entry *alloc_entry(struct entry_alloc *ea)
 /*
  * This assumes the cblock hasn't already been allocated.
  */
-static struct entry *alloc_particular_entry(struct entry_alloc *ea, unsigned i)
+static struct entry *alloc_particular_entry(struct entry_alloc *ea, unsigned int i)
 {
 	struct entry *e = __get_entry(ea->es, ea->begin + i);
 
@@ -771,12 +772,12 @@ static bool allocator_empty(struct entry_alloc *ea)
 	return l_empty(&ea->free);
 }
 
-static unsigned get_index(struct entry_alloc *ea, struct entry *e)
+static unsigned int get_index(struct entry_alloc *ea, struct entry *e)
 {
 	return to_index(ea->es, e) - ea->begin;
 }
 
-static struct entry *get_entry(struct entry_alloc *ea, unsigned index)
+static struct entry *get_entry(struct entry_alloc *ea, unsigned int index)
 {
 	return __get_entry(ea->es, ea->begin + index);
 }
@@ -801,9 +802,9 @@ struct smq_policy {
 	sector_t cache_block_size;
 
 	sector_t hotspot_block_size;
-	unsigned nr_hotspot_blocks;
-	unsigned cache_blocks_per_hotspot_block;
-	unsigned hotspot_level_jump;
+	unsigned int nr_hotspot_blocks;
+	unsigned int cache_blocks_per_hotspot_block;
+	unsigned int hotspot_level_jump;
 
 	struct entry_space es;
 	struct entry_alloc writeback_sentinel_alloc;
@@ -832,7 +833,7 @@ struct smq_policy {
 	 * Keeps track of time, incremented by the core.  We use this to
 	 * avoid attributing multiple hits within the same tick.
 	 */
-	unsigned tick;
+	unsigned int tick;
 
 	/*
 	 * The hash tables allows us to quickly find an entry by origin
@@ -847,8 +848,8 @@ struct smq_policy {
 	bool current_demote_sentinels;
 	unsigned long next_demote_period;
 
-	unsigned write_promote_level;
-	unsigned read_promote_level;
+	unsigned int write_promote_level;
+	unsigned int read_promote_level;
 
 	unsigned long next_hotspot_period;
 	unsigned long next_cache_period;
@@ -860,24 +861,24 @@ struct smq_policy {
 
 /*----------------------------------------------------------------*/
 
-static struct entry *get_sentinel(struct entry_alloc *ea, unsigned level, bool which)
+static struct entry *get_sentinel(struct entry_alloc *ea, unsigned int level, bool which)
 {
 	return get_entry(ea, which ? level : NR_CACHE_LEVELS + level);
 }
 
-static struct entry *writeback_sentinel(struct smq_policy *mq, unsigned level)
+static struct entry *writeback_sentinel(struct smq_policy *mq, unsigned int level)
 {
 	return get_sentinel(&mq->writeback_sentinel_alloc, level, mq->current_writeback_sentinels);
 }
 
-static struct entry *demote_sentinel(struct smq_policy *mq, unsigned level)
+static struct entry *demote_sentinel(struct smq_policy *mq, unsigned int level)
 {
 	return get_sentinel(&mq->demote_sentinel_alloc, level, mq->current_demote_sentinels);
 }
 
 static void __update_writeback_sentinels(struct smq_policy *mq)
 {
-	unsigned level;
+	unsigned int level;
 	struct queue *q = &mq->dirty;
 	struct entry *sentinel;
 
@@ -890,7 +891,7 @@ static void __update_writeback_sentinels(struct smq_policy *mq)
 
 static void __update_demote_sentinels(struct smq_policy *mq)
 {
-	unsigned level;
+	unsigned int level;
 	struct queue *q = &mq->clean;
 	struct entry *sentinel;
 
@@ -918,7 +919,7 @@ static void update_sentinels(struct smq_policy *mq)
 
 static void __sentinels_init(struct smq_policy *mq)
 {
-	unsigned level;
+	unsigned int level;
 	struct entry *sentinel;
 
 	for (level = 0; level < NR_CACHE_LEVELS; level++) {
@@ -1009,7 +1010,7 @@ static void requeue(struct smq_policy *mq, struct entry *e)
 	}
 }
 
-static unsigned default_promote_level(struct smq_policy *mq)
+static unsigned int default_promote_level(struct smq_policy *mq)
 {
 	/*
 	 * The promote level depends on the current performance of the
@@ -1031,9 +1032,9 @@ static unsigned default_promote_level(struct smq_policy *mq)
 		1, 1, 1, 2, 4, 6, 7, 8, 7, 6, 4, 4, 3, 3, 2, 2, 1
 	};
 
-	unsigned hits = mq->cache_stats.hits;
-	unsigned misses = mq->cache_stats.misses;
-	unsigned index = safe_div(hits << 4u, hits + misses);
+	unsigned int hits = mq->cache_stats.hits;
+	unsigned int misses = mq->cache_stats.misses;
+	unsigned int index = safe_div(hits << 4u, hits + misses);
 	return table[index];
 }
 
@@ -1043,7 +1044,7 @@ static void update_promote_levels(struct smq_policy *mq)
 	 * If there are unused cache entries then we want to be really
 	 * eager to promote.
 	 */
-	unsigned threshold_level = allocator_empty(&mq->cache_alloc) ?
+	unsigned int threshold_level = allocator_empty(&mq->cache_alloc) ?
 		default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);
 
 	threshold_level = max(threshold_level, NR_HOTSPOT_LEVELS);
@@ -1125,7 +1126,7 @@ static void end_cache_period(struct smq_policy *mq)
 #define CLEAN_TARGET 25u
 #define FREE_TARGET 25u
 
-static unsigned percent_to_target(struct smq_policy *mq, unsigned p)
+static unsigned int percent_to_target(struct smq_policy *mq, unsigned int p)
 {
 	return from_cblock(mq->cache_size) * p / 100u;
 }
@@ -1151,7 +1152,7 @@ static bool clean_target_met(struct smq_policy *mq, bool idle)
 
 static bool free_target_met(struct smq_policy *mq)
 {
-	unsigned nr_free;
+	unsigned int nr_free;
 
 	nr_free = from_cblock(mq->cache_size) - mq->cache_alloc.nr_allocated;
 	return (nr_free + btracker_nr_demotions_queued(mq->bg_work)) >=
@@ -1301,7 +1302,7 @@ static dm_oblock_t to_hblock(struct smq_policy *mq, dm_oblock_t b)
 
 static struct entry *update_hotspot_queue(struct smq_policy *mq, dm_oblock_t b)
 {
-	unsigned hi;
+	unsigned int hi;
 	dm_oblock_t hb = to_hblock(mq, b);
 	struct entry *e = h_lookup(&mq->hotspot_table, hb);
 
@@ -1550,7 +1551,7 @@ static void smq_clear_dirty(struct dm_cache_policy *p, dm_cblock_t cblock)
 	spin_unlock_irqrestore(&mq->lock, flags);
 }
 
-static unsigned random_level(dm_cblock_t cblock)
+static unsigned int random_level(dm_cblock_t cblock)
 {
 	return hash_32(from_cblock(cblock), 9) & (NR_CACHE_LEVELS - 1);
 }
@@ -1661,7 +1662,7 @@ static int mq_set_config_value(struct dm_cache_policy *p,
 }
 
 static int mq_emit_config_values(struct dm_cache_policy *p, char *result,
-				 unsigned maxlen, ssize_t *sz_ptr)
+				 unsigned int maxlen, ssize_t *sz_ptr)
 {
 	ssize_t sz = *sz_ptr;
 
@@ -1700,16 +1701,16 @@ static void init_policy_functions(struct smq_policy *mq, bool mimic_mq)
 
 static bool too_many_hotspot_blocks(sector_t origin_size,
 				    sector_t hotspot_block_size,
-				    unsigned nr_hotspot_blocks)
+				    unsigned int nr_hotspot_blocks)
 {
 	return (hotspot_block_size * nr_hotspot_blocks) > origin_size;
 }
 
 static void calc_hotspot_params(sector_t origin_size,
 				sector_t cache_block_size,
-				unsigned nr_cache_blocks,
+				unsigned int nr_cache_blocks,
 				sector_t *hotspot_block_size,
-				unsigned *nr_hotspot_blocks)
+				unsigned int *nr_hotspot_blocks)
 {
 	*hotspot_block_size = cache_block_size * 16u;
 	*nr_hotspot_blocks = max(nr_cache_blocks / 4u, 1024u);
@@ -1725,9 +1726,9 @@ static struct dm_cache_policy *__smq_create(dm_cblock_t cache_size,
 					    bool mimic_mq,
 					    bool migrations_allowed)
 {
-	unsigned i;
-	unsigned nr_sentinels_per_queue = 2u * NR_CACHE_LEVELS;
-	unsigned total_sentinels = 2u * nr_sentinels_per_queue;
+	unsigned int i;
+	unsigned int nr_sentinels_per_queue = 2u * NR_CACHE_LEVELS;
+	unsigned int total_sentinels = 2u * nr_sentinels_per_queue;
 	struct smq_policy *mq = kzalloc(sizeof(*mq), GFP_KERNEL);
 
 	if (!mq)
diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
index af425491862b..1eb1e3fd9bd4 100644
--- a/drivers/md/dm-cache-policy.c
+++ b/drivers/md/dm-cache-policy.c
@@ -155,7 +155,7 @@ const char *dm_cache_policy_get_name(struct dm_cache_policy *p)
 }
 EXPORT_SYMBOL_GPL(dm_cache_policy_get_name);
 
-const unsigned *dm_cache_policy_get_version(struct dm_cache_policy *p)
+const unsigned int *dm_cache_policy_get_version(struct dm_cache_policy *p)
 {
 	struct dm_cache_policy_type *t = p->private;
 
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index fed3e8d00914..07264a6d60d9 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -129,7 +129,7 @@ struct dm_cache_policy {
 	 * Configuration.
 	 */
 	int (*emit_config_values)(struct dm_cache_policy *p, char *result,
-				  unsigned maxlen, ssize_t *sz_ptr);
+				  unsigned int maxlen, ssize_t *sz_ptr);
 	int (*set_config_value)(struct dm_cache_policy *p,
 				const char *key, const char *value);
 
@@ -158,7 +158,7 @@ struct dm_cache_policy_type {
 	 * what gets passed on the target line to select your policy.
 	 */
 	char name[CACHE_POLICY_NAME_SIZE];
-	unsigned version[CACHE_POLICY_VERSION_SIZE];
+	unsigned int version[CACHE_POLICY_VERSION_SIZE];
 
 	/*
 	 * For use by an alias dm_cache_policy_type to point to the
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 07790e07cfa7..e015123b218b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -276,7 +276,7 @@ enum cache_io_mode {
 struct cache_features {
 	enum cache_metadata_mode mode;
 	enum cache_io_mode io_mode;
-	unsigned metadata_version;
+	unsigned int metadata_version;
 	bool discard_passdown:1;
 };
 
@@ -363,7 +363,7 @@ struct cache {
 	 * Rather than reconstructing the table line for the status we just
 	 * save it and regurgitate.
 	 */
-	unsigned nr_ctr_args;
+	unsigned int nr_ctr_args;
 	const char **ctr_args;
 
 	struct dm_kcopyd_client *copier;
@@ -379,7 +379,7 @@ struct cache {
 	unsigned long *dirty_bitset;
 	atomic_t nr_dirty;
 
-	unsigned policy_nr_args;
+	unsigned int policy_nr_args;
 	struct dm_cache_policy *policy;
 
 	/*
@@ -410,7 +410,7 @@ struct cache {
 
 struct per_bio_data {
 	bool tick:1;
-	unsigned req_nr:2;
+	unsigned int req_nr:2;
 	struct dm_bio_prison_cell_v2 *cell;
 	struct dm_hook_info hook_info;
 	sector_t len;
@@ -518,7 +518,7 @@ static void build_key(dm_oblock_t begin, dm_oblock_t end, struct dm_cell_key_v2
 #define WRITE_LOCK_LEVEL 0
 #define READ_WRITE_LOCK_LEVEL 1
 
-static unsigned lock_level(struct bio *bio)
+static unsigned int lock_level(struct bio *bio)
 {
 	return bio_data_dir(bio) == WRITE ?
 		WRITE_LOCK_LEVEL :
@@ -1881,7 +1881,7 @@ static void check_migrations(struct work_struct *ws)
  */
 static void destroy(struct cache *cache)
 {
-	unsigned i;
+	unsigned int i;
 
 	mempool_exit(&cache->migration_pool);
 
@@ -2121,7 +2121,7 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 	};
 
 	int r, mode_ctr = 0;
-	unsigned argc;
+	unsigned int argc;
 	const char *arg;
 	struct cache_features *cf = &ca->features;
 
@@ -2541,7 +2541,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 static int copy_ctr_args(struct cache *cache, int argc, const char **argv)
 {
-	unsigned i;
+	unsigned int i;
 	const char **copy;
 
 	copy = kcalloc(argc, sizeof(*copy), GFP_KERNEL);
@@ -2563,7 +2563,7 @@ static int copy_ctr_args(struct cache *cache, int argc, const char **argv)
 	return 0;
 }
 
-static int cache_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int cache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r = -EINVAL;
 	struct cache_args *ca;
@@ -2666,7 +2666,7 @@ static int write_dirty_bitset(struct cache *cache)
 
 static int write_discard_bitset(struct cache *cache)
 {
-	unsigned i, r;
+	unsigned int i, r;
 
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return -EINVAL;
@@ -2980,11 +2980,11 @@ static void cache_resume(struct dm_target *ti)
 }
 
 static void emit_flags(struct cache *cache, char *result,
-		       unsigned maxlen, ssize_t *sz_ptr)
+		       unsigned int maxlen, ssize_t *sz_ptr)
 {
 	ssize_t sz = *sz_ptr;
 	struct cache_features *cf = &cache->features;
-	unsigned count = (cf->metadata_version == 2) + !cf->discard_passdown + 1;
+	unsigned int count = (cf->metadata_version == 2) + !cf->discard_passdown + 1;
 
 	DMEMIT("%u ", count);
 
@@ -3024,10 +3024,10 @@ static void emit_flags(struct cache *cache, char *result,
  * <policy name> <#policy args> <policy args>* <cache metadata mode> <needs_check>
  */
 static void cache_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+			 unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int r = 0;
-	unsigned i;
+	unsigned int i;
 	ssize_t sz = 0;
 	dm_block_t nr_free_blocks_metadata = 0;
 	dm_block_t nr_blocks_metadata = 0;
@@ -3064,18 +3064,18 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		residency = policy_residency(cache->policy);
 
 		DMEMIT("%u %llu/%llu %llu %llu/%llu %u %u %u %u %u %u %lu ",
-		       (unsigned)DM_CACHE_METADATA_BLOCK_SIZE,
+		       (unsigned int)DM_CACHE_METADATA_BLOCK_SIZE,
 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
 		       (unsigned long long)nr_blocks_metadata,
 		       (unsigned long long)cache->sectors_per_block,
 		       (unsigned long long) from_cblock(residency),
 		       (unsigned long long) from_cblock(cache->cache_size),
-		       (unsigned) atomic_read(&cache->stats.read_hit),
-		       (unsigned) atomic_read(&cache->stats.read_miss),
-		       (unsigned) atomic_read(&cache->stats.write_hit),
-		       (unsigned) atomic_read(&cache->stats.write_miss),
-		       (unsigned) atomic_read(&cache->stats.demotion),
-		       (unsigned) atomic_read(&cache->stats.promotion),
+		       (unsigned int) atomic_read(&cache->stats.read_hit),
+		       (unsigned int) atomic_read(&cache->stats.read_miss),
+		       (unsigned int) atomic_read(&cache->stats.write_hit),
+		       (unsigned int) atomic_read(&cache->stats.write_miss),
+		       (unsigned int) atomic_read(&cache->stats.demotion),
+		       (unsigned int) atomic_read(&cache->stats.promotion),
 		       (unsigned long) atomic_read(&cache->nr_dirty));
 
 		emit_flags(cache, result, maxlen, &sz);
@@ -3254,11 +3254,11 @@ static int request_invalidation(struct cache *cache, struct cblock_range *range)
 	return r;
 }
 
-static int process_invalidate_cblocks_message(struct cache *cache, unsigned count,
+static int process_invalidate_cblocks_message(struct cache *cache, unsigned int count,
 					      const char **cblock_ranges)
 {
 	int r = 0;
-	unsigned i;
+	unsigned int i;
 	struct cblock_range range;
 
 	if (!passthrough_mode(cache)) {
@@ -3295,8 +3295,8 @@ static int process_invalidate_cblocks_message(struct cache *cache, unsigned coun
  *
  * The key migration_threshold is supported by the cache target core.
  */
-static int cache_message(struct dm_target *ti, unsigned argc, char **argv,
-			 char *result, unsigned maxlen)
+static int cache_message(struct dm_target *ti, unsigned int argc, char **argv,
+			 char *result, unsigned int maxlen)
 {
 	struct cache *cache = ti->private;
 
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 37d546ca604d..28c3ba5dd402 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -120,7 +120,7 @@ struct mapped_device {
 	struct dm_stats stats;
 
 	/* the number of internal suspends */
-	unsigned internal_suspend_count;
+	unsigned int internal_suspend_count;
 
 	int swap_bios;
 	struct semaphore swap_bios_semaphore;
@@ -327,9 +327,9 @@ static inline struct completion *dm_get_completion_from_kobject(struct kobject *
 	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
 }
 
-unsigned __dm_get_module_param(unsigned *module_param, unsigned def, unsigned max);
+unsigned int __dm_get_module_param(unsigned int *module_param, unsigned int def, unsigned int max);
 
-static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
+static inline bool dm_message_test_buffer_overflow(char *result, unsigned int maxlen)
 {
 	return !maxlen || strlen(result) + 1 >= maxlen;
 }
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index e7fd9e770bc0..6a58000f58d7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -172,14 +172,14 @@ struct crypt_config {
 	} iv_gen_private;
 	u64 iv_offset;
 	unsigned int iv_size;
-	unsigned short int sector_size;
+	unsigned short sector_size;
 	unsigned char sector_shift;
 
 	union {
 		struct crypto_skcipher **tfms;
 		struct crypto_aead **tfms_aead;
 	} cipher_tfm;
-	unsigned tfms_count;
+	unsigned int tfms_count;
 	unsigned long cipher_flags;
 
 	/*
@@ -213,7 +213,7 @@ struct crypt_config {
 	 * pool for per bio private data, crypto requests,
 	 * encryption requeusts/buffer pages and integrity tags
 	 */
-	unsigned tag_pool_max_sectors;
+	unsigned int tag_pool_max_sectors;
 	mempool_t tag_pool;
 	mempool_t req_pool;
 	mempool_t page_pool;
@@ -230,7 +230,7 @@ struct crypt_config {
 #define POOL_ENTRY_SIZE	512
 
 static DEFINE_SPINLOCK(dm_crypt_clients_lock);
-static unsigned dm_crypt_clients_n = 0;
+static unsigned int dm_crypt_clients_n = 0;
 static volatile unsigned long dm_crypt_pages_per_client;
 #define DM_CRYPT_MEMORY_PERCENT			2
 #define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_VECS * 16)
@@ -355,7 +355,7 @@ static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs;
+	unsigned int bs;
 	int log;
 
 	if (crypt_integrity_aead(cc))
@@ -1465,7 +1465,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 				     struct convert_context *ctx)
 {
-	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	unsigned int key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
 	if (!ctx->r.req) {
 		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
@@ -1659,13 +1659,13 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
  * non-blocking allocations without a mutex first but on failure we fallback
  * to blocking allocations with a mutex.
  */
-static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
+static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
-	unsigned i, len, remaining_size;
+	unsigned int i, len, remaining_size;
 	struct page *page;
 
 retry:
@@ -1805,7 +1805,7 @@ static void crypt_endio(struct bio *clone)
 {
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->cc;
-	unsigned rw = bio_data_dir(clone);
+	unsigned int rw = bio_data_dir(clone);
 	blk_status_t error;
 
 	/*
@@ -2258,7 +2258,7 @@ static void crypt_free_tfms_aead(struct crypt_config *cc)
 
 static void crypt_free_tfms_skcipher(struct crypt_config *cc)
 {
-	unsigned i;
+	unsigned int i;
 
 	if (!cc->cipher_tfm.tfms)
 		return;
@@ -2283,7 +2283,7 @@ static void crypt_free_tfms(struct crypt_config *cc)
 
 static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
 {
-	unsigned i;
+	unsigned int i;
 	int err;
 
 	cc->cipher_tfm.tfms = kcalloc(cc->tfms_count,
@@ -2341,12 +2341,12 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 		return crypt_alloc_tfms_skcipher(cc, ciphermode);
 }
 
-static unsigned crypt_subkey_size(struct crypt_config *cc)
+static unsigned int crypt_subkey_size(struct crypt_config *cc)
 {
 	return (cc->key_size - cc->key_extra_size) >> ilog2(cc->tfms_count);
 }
 
-static unsigned crypt_authenckey_size(struct crypt_config *cc)
+static unsigned int crypt_authenckey_size(struct crypt_config *cc)
 {
 	return crypt_subkey_size(cc) + RTA_SPACE(sizeof(struct crypto_authenc_key_param));
 }
@@ -2357,7 +2357,7 @@ static unsigned crypt_authenckey_size(struct crypt_config *cc)
  * This funcion converts cc->key to this special format.
  */
 static void crypt_copy_authenckey(char *p, const void *key,
-				  unsigned enckeylen, unsigned authkeylen)
+				  unsigned int enckeylen, unsigned int authkeylen)
 {
 	struct crypto_authenc_key_param *param;
 	struct rtattr *rta;
@@ -2375,7 +2375,7 @@ static void crypt_copy_authenckey(char *p, const void *key,
 
 static int crypt_setkey(struct crypt_config *cc)
 {
-	unsigned subkey_size;
+	unsigned int subkey_size;
 	int err = 0, i, r;
 
 	/* Ignore extra keys (which are used for IV etc) */
@@ -3414,7 +3414,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
 
 	if (cc->on_disk_tag_size) {
-		unsigned tag_len = cc->on_disk_tag_size * (bio_sectors(bio) >> cc->sector_shift);
+		unsigned int tag_len = cc->on_disk_tag_size * (bio_sectors(bio) >> cc->sector_shift);
 
 		if (unlikely(tag_len > KMALLOC_MAX_SIZE) ||
 		    unlikely(!(io->integrity_metadata = kmalloc(tag_len,
@@ -3442,14 +3442,14 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 
 static char hex2asc(unsigned char c)
 {
-	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
+	return c + '0' + ((unsigned int)(9 - c) >> 4 & 0x27);
 }
 
 static void crypt_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+			 unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct crypt_config *cc = ti->private;
-	unsigned i, sz = 0;
+	unsigned int i, sz = 0;
 	int num_feature_args = 0;
 
 	switch (type) {
@@ -3565,8 +3565,8 @@ static void crypt_resume(struct dm_target *ti)
  *	key set <key>
  *	key wipe
  */
-static int crypt_message(struct dm_target *ti, unsigned argc, char **argv,
-			 char *result, unsigned maxlen)
+static int crypt_message(struct dm_target *ti, unsigned int argc, char **argv,
+			 char *result, unsigned int maxlen)
 {
 	struct crypt_config *cc = ti->private;
 	int key_size, ret = -EINVAL;
@@ -3627,10 +3627,10 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_segment_size = PAGE_SIZE;
 
 	limits->logical_block_size =
-		max_t(unsigned, limits->logical_block_size, cc->sector_size);
+		max_t(unsigned int, limits->logical_block_size, cc->sector_size);
 	limits->physical_block_size =
-		max_t(unsigned, limits->physical_block_size, cc->sector_size);
-	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
+	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
 	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index cc87a159b0cd..8d9682a545e0 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -21,8 +21,8 @@
 struct delay_class {
 	struct dm_dev *dev;
 	sector_t start;
-	unsigned delay;
-	unsigned ops;
+	unsigned int delay;
+	unsigned int ops;
 };
 
 struct delay_c {
@@ -306,7 +306,7 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
 	DMEMIT("%s %llu %u", (c)->dev->name, (unsigned long long)(c)->start, (c)->delay)
 
 static void delay_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+			 unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct delay_c *dc = ti->private;
 	int sz = 0;
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 3c4c206675e2..8477e82a95c6 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -391,7 +391,7 @@ static int ebs_map(struct dm_target *ti, struct bio *bio)
 }
 
 static void ebs_status(struct dm_target *ti, status_type_t type,
-		       unsigned status_flags, char *result, unsigned maxlen)
+		       unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct ebs_c *ec = ti->private;
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index e92c1afc3677..a96290103cca 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -51,7 +51,7 @@ static void writeset_free(struct writeset *ws)
 }
 
 static int setup_on_disk_bitset(struct dm_disk_bitset *info,
-				unsigned nr_bits, dm_block_t *root)
+				unsigned int nr_bits, dm_block_t *root)
 {
 	int r;
 
@@ -62,7 +62,7 @@ static int setup_on_disk_bitset(struct dm_disk_bitset *info,
 	return dm_bitset_resize(info, *root, 0, nr_bits, false, root);
 }
 
-static size_t bitset_size(unsigned nr_bits)
+static size_t bitset_size(unsigned int nr_bits)
 {
 	return sizeof(unsigned long) * dm_div_up(nr_bits, BITS_PER_LONG);
 }
@@ -323,10 +323,10 @@ static int superblock_lock(struct era_metadata *md,
 static int superblock_all_zeroes(struct dm_block_manager *bm, bool *result)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct dm_block *b;
 	__le64 *data_le, zero = cpu_to_le64(0);
-	unsigned sb_block_size = dm_bm_block_size(bm) / sizeof(__le64);
+	unsigned int sb_block_size = dm_bm_block_size(bm) / sizeof(__le64);
 
 	/*
 	 * We can't use a validator here - it may be all zeroes.
@@ -363,12 +363,12 @@ static void ws_unpack(const struct writeset_disk *disk, struct writeset_metadata
 	core->root = le64_to_cpu(disk->root);
 }
 
-static void ws_inc(void *context, const void *value, unsigned count)
+static void ws_inc(void *context, const void *value, unsigned int count)
 {
 	struct era_metadata *md = context;
 	struct writeset_disk ws_d;
 	dm_block_t b;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++) {
 		memcpy(&ws_d, value + (i * sizeof(ws_d)), sizeof(ws_d));
@@ -377,12 +377,12 @@ static void ws_inc(void *context, const void *value, unsigned count)
 	}
 }
 
-static void ws_dec(void *context, const void *value, unsigned count)
+static void ws_dec(void *context, const void *value, unsigned int count)
 {
 	struct era_metadata *md = context;
 	struct writeset_disk ws_d;
 	dm_block_t b;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++) {
 		memcpy(&ws_d, value + (i * sizeof(ws_d)), sizeof(ws_d));
@@ -667,7 +667,7 @@ static void swap_writeset(struct era_metadata *md, struct writeset *new_writeset
  *--------------------------------------------------------------*/
 struct digest {
 	uint32_t era;
-	unsigned nr_bits, current_bit;
+	unsigned int nr_bits, current_bit;
 	struct writeset_metadata writeset;
 	__le32 value;
 	struct dm_disk_bitset info;
@@ -702,7 +702,7 @@ static int metadata_digest_transcribe_writeset(struct era_metadata *md,
 {
 	int r;
 	bool marked;
-	unsigned b, e = min(d->current_bit + INSERTS_PER_STEP, d->nr_bits);
+	unsigned int b, e = min(d->current_bit + INSERTS_PER_STEP, d->nr_bits);
 
 	for (b = d->current_bit; b < e; b++) {
 		r = writeset_marked_on_disk(&d->info, &d->writeset, b, &marked);
@@ -1439,7 +1439,7 @@ static bool valid_block_size(dm_block_t block_size)
 /*
  * <metadata dev> <data dev> <data block size (sectors)>
  */
-static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
 	char dummy;
@@ -1618,7 +1618,7 @@ static int era_preresume(struct dm_target *ti)
  * <current era> <held metadata root | '-'>
  */
 static void era_status(struct dm_target *ti, status_type_t type,
-		       unsigned status_flags, char *result, unsigned maxlen)
+		       unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int r;
 	struct era *era = ti->private;
@@ -1633,10 +1633,10 @@ static void era_status(struct dm_target *ti, status_type_t type,
 			goto err;
 
 		DMEMIT("%u %llu/%llu %u",
-		       (unsigned) (DM_ERA_METADATA_BLOCK_SIZE >> SECTOR_SHIFT),
+		       (unsigned int) (DM_ERA_METADATA_BLOCK_SIZE >> SECTOR_SHIFT),
 		       (unsigned long long) stats.used,
 		       (unsigned long long) stats.total,
-		       (unsigned) stats.era);
+		       (unsigned int) stats.era);
 
 		if (stats.snap != SUPERBLOCK_LOCATION)
 			DMEMIT(" %llu", stats.snap);
@@ -1662,8 +1662,8 @@ static void era_status(struct dm_target *ti, status_type_t type,
 	DMEMIT("Error");
 }
 
-static int era_message(struct dm_target *ti, unsigned argc, char **argv,
-		       char *result, unsigned maxlen)
+static int era_message(struct dm_target *ti, unsigned int argc, char **argv,
+		       char *result, unsigned int maxlen)
 {
 	struct era *era = ti->private;
 
diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 5619c9fa90d6..87e948d785dd 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -143,7 +143,7 @@ EXPORT_SYMBOL(dm_exception_store_type_unregister);
 static int set_chunk_size(struct dm_exception_store *store,
 			  const char *chunk_size_arg, char **error)
 {
-	unsigned chunk_size;
+	unsigned int chunk_size;
 
 	if (kstrtouint(chunk_size_arg, 10, &chunk_size)) {
 		*error = "Invalid chunk size";
@@ -159,7 +159,7 @@ static int set_chunk_size(struct dm_exception_store *store,
 }
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned chunk_size,
+				      unsigned int chunk_size,
 				      char **error)
 {
 	/* Check chunk_size is a power of 2 */
@@ -191,7 +191,7 @@ int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
 
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 			      struct dm_snapshot *snap,
-			      unsigned *args_used,
+			      unsigned int *args_used,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 2fec405ec079..5a143dc8d181 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -97,9 +97,9 @@ struct dm_exception_store_type {
 	 */
 	void (*drop_snapshot) (struct dm_exception_store *store);
 
-	unsigned (*status) (struct dm_exception_store *store,
-			    status_type_t status, char *result,
-			    unsigned maxlen);
+	unsigned int (*status) (struct dm_exception_store *store,
+				status_type_t status, char *result,
+				unsigned int maxlen);
 
 	/*
 	 * Return how full the snapshot is.
@@ -119,9 +119,9 @@ struct dm_exception_store {
 	struct dm_snapshot *snap;
 
 	/* Size of data blocks saved - must be a power of 2 */
-	unsigned chunk_size;
-	unsigned chunk_mask;
-	unsigned chunk_shift;
+	unsigned int chunk_size;
+	unsigned int chunk_mask;
+	unsigned int chunk_shift;
 
 	void *context;
 
@@ -145,7 +145,7 @@ static inline chunk_t dm_chunk_number(chunk_t chunk)
 	return chunk & (chunk_t)((1ULL << DM_CHUNK_NUMBER_BITS) - 1ULL);
 }
 
-static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
+static inline unsigned int dm_consecutive_chunk_count(struct dm_exception *e)
 {
 	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
 }
@@ -182,12 +182,12 @@ int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned chunk_size,
+				      unsigned int chunk_size,
 				      char **error);
 
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 			      struct dm_snapshot *snap,
-			      unsigned *args_used,
+			      unsigned int *args_used,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index f0b878c90731..e4464b37732a 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -27,12 +27,12 @@ struct flakey_c {
 	struct dm_dev *dev;
 	unsigned long start_time;
 	sector_t start;
-	unsigned up_interval;
-	unsigned down_interval;
+	unsigned int up_interval;
+	unsigned int down_interval;
 	unsigned long flags;
-	unsigned corrupt_bio_byte;
-	unsigned corrupt_bio_rw;
-	unsigned corrupt_bio_value;
+	unsigned int corrupt_bio_byte;
+	unsigned int corrupt_bio_rw;
+	unsigned int corrupt_bio_value;
 	blk_opf_t corrupt_bio_flags;
 };
 
@@ -49,7 +49,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			  struct dm_target *ti)
 {
 	int r;
-	unsigned argc;
+	unsigned int argc;
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
@@ -149,7 +149,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			BUILD_BUG_ON(sizeof(fc->corrupt_bio_flags) !=
 				     sizeof(unsigned int));
 			r = dm_read_arg(_args + 3, as,
-				(__force unsigned *)&fc->corrupt_bio_flags,
+				(__force unsigned int *)&fc->corrupt_bio_flags,
 				&ti->error);
 			if (r)
 				return r;
@@ -325,7 +325,7 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 static int flakey_map(struct dm_target *ti, struct bio *bio)
 {
 	struct flakey_c *fc = ti->private;
-	unsigned elapsed;
+	unsigned int elapsed;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 	pb->bio_submitted = false;
 
@@ -418,11 +418,11 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 }
 
 static void flakey_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct flakey_c *fc = ti->private;
-	unsigned drop_writes, error_writes;
+	unsigned int drop_writes, error_writes;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index eaf698c09829..e8573dd93483 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -158,13 +158,13 @@ struct alg_spec {
 	char *alg_string;
 	char *key_string;
 	__u8 *key;
-	unsigned key_size;
+	unsigned int key_size;
 };
 
 struct dm_integrity_c {
 	struct dm_dev *dev;
 	struct dm_dev *meta_dev;
-	unsigned tag_size;
+	unsigned int tag_size;
 	__s8 log2_tag_size;
 	sector_t start;
 	mempool_t journal_io_mempool;
@@ -172,8 +172,8 @@ struct dm_integrity_c {
 	struct dm_bufio_client *bufio;
 	struct workqueue_struct *metadata_wq;
 	struct superblock *sb;
-	unsigned journal_pages;
-	unsigned n_bitmap_blocks;
+	unsigned int journal_pages;
+	unsigned int n_bitmap_blocks;
 
 	struct page_list *journal;
 	struct page_list *journal_io;
@@ -181,7 +181,7 @@ struct dm_integrity_c {
 	struct page_list *recalc_bitmap;
 	struct page_list *may_write_bitmap;
 	struct bitmap_block_status *bbs;
-	unsigned bitmap_flush_interval;
+	unsigned int bitmap_flush_interval;
 	int synchronous_mode;
 	struct bio_list synchronous_bios;
 	struct delayed_work bitmap_flush_work;
@@ -202,12 +202,12 @@ struct dm_integrity_c {
 	unsigned char journal_entries_per_sector;
 	unsigned char journal_section_entries;
 	unsigned short journal_section_sectors;
-	unsigned journal_sections;
-	unsigned journal_entries;
+	unsigned int journal_sections;
+	unsigned int journal_entries;
 	sector_t data_device_sectors;
 	sector_t meta_device_sectors;
-	unsigned initial_sectors;
-	unsigned metadata_run;
+	unsigned int initial_sectors;
+	unsigned int metadata_run;
 	__s8 log2_metadata_run;
 	__u8 log2_buffer_sectors;
 	__u8 sectors_per_block;
@@ -231,17 +231,17 @@ struct dm_integrity_c {
 	unsigned char commit_seq;
 	commit_id_t commit_ids[N_COMMIT_IDS];
 
-	unsigned committed_section;
-	unsigned n_committed_sections;
+	unsigned int committed_section;
+	unsigned int n_committed_sections;
 
-	unsigned uncommitted_section;
-	unsigned n_uncommitted_sections;
+	unsigned int uncommitted_section;
+	unsigned int n_uncommitted_sections;
 
-	unsigned free_section;
+	unsigned int free_section;
 	unsigned char free_section_entry;
-	unsigned free_sectors;
+	unsigned int free_sectors;
 
-	unsigned free_sectors_threshold;
+	unsigned int free_sectors_threshold;
 
 	struct workqueue_struct *commit_wq;
 	struct work_struct commit_work;
@@ -258,7 +258,7 @@ struct dm_integrity_c {
 
 	unsigned long autocommit_jiffies;
 	struct timer_list autocommit_timer;
-	unsigned autocommit_msec;
+	unsigned int autocommit_msec;
 
 	wait_queue_head_t copy_to_journal_wait;
 
@@ -306,7 +306,7 @@ struct dm_integrity_io {
 	struct dm_integrity_range range;
 
 	sector_t metadata_block;
-	unsigned metadata_offset;
+	unsigned int metadata_offset;
 
 	atomic_t in_flight;
 	blk_status_t bi_status;
@@ -330,7 +330,7 @@ struct journal_io {
 struct bitmap_block_status {
 	struct work_struct work;
 	struct dm_integrity_c *ic;
-	unsigned idx;
+	unsigned int idx;
 	unsigned long *bitmap;
 	struct bio_list bio_queue;
 	spinlock_t bio_queue_lock;
@@ -411,8 +411,8 @@ static bool dm_integrity_disable_recalculate(struct dm_integrity_c *ic)
 	return false;
 }
 
-static commit_id_t dm_integrity_commit_id(struct dm_integrity_c *ic, unsigned i,
-					  unsigned j, unsigned char seq)
+static commit_id_t dm_integrity_commit_id(struct dm_integrity_c *ic, unsigned int i,
+					  unsigned int j, unsigned char seq)
 {
 	/*
 	 * Xor the number with section and sector, so that if a piece of
@@ -427,7 +427,7 @@ static void get_area_and_offset(struct dm_integrity_c *ic, sector_t data_sector,
 	if (!ic->meta_dev) {
 		__u8 log2_interleave_sectors = ic->sb->log2_interleave_sectors;
 		*area = data_sector >> log2_interleave_sectors;
-		*offset = (unsigned)data_sector & ((1U << log2_interleave_sectors) - 1);
+		*offset = (unsigned int)data_sector & ((1U << log2_interleave_sectors) - 1);
 	} else {
 		*area = 0;
 		*offset = data_sector;
@@ -436,15 +436,15 @@ static void get_area_and_offset(struct dm_integrity_c *ic, sector_t data_sector,
 
 #define sector_to_block(ic, n)						\
 do {									\
-	BUG_ON((n) & (unsigned)((ic)->sectors_per_block - 1));		\
+	BUG_ON((n) & (unsigned int)((ic)->sectors_per_block - 1));		\
 	(n) >>= (ic)->sb->log2_sectors_per_block;			\
 } while (0)
 
 static __u64 get_metadata_sector_and_offset(struct dm_integrity_c *ic, sector_t area,
-					    sector_t offset, unsigned *metadata_offset)
+					    sector_t offset, unsigned int *metadata_offset)
 {
 	__u64 ms;
-	unsigned mo;
+	unsigned int mo;
 
 	ms = area << ic->sb->log2_interleave_sectors;
 	if (likely(ic->log2_metadata_run >= 0))
@@ -485,7 +485,7 @@ static sector_t get_data_sector(struct dm_integrity_c *ic, sector_t area, sector
 	return result;
 }
 
-static void wraparound_section(struct dm_integrity_c *ic, unsigned *sec_ptr)
+static void wraparound_section(struct dm_integrity_c *ic, unsigned int *sec_ptr)
 {
 	if (unlikely(*sec_ptr >= ic->journal_sections))
 		*sec_ptr -= ic->journal_sections;
@@ -509,7 +509,7 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
 {
 	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
 	int r;
-	unsigned size = crypto_shash_digestsize(ic->journal_mac);
+	unsigned int size = crypto_shash_digestsize(ic->journal_mac);
 
 	if (sizeof(struct superblock) + size > 1 << SECTOR_SHIFT) {
 		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
@@ -705,8 +705,8 @@ static bool block_bitmap_op(struct dm_integrity_c *ic, struct page_list *bitmap,
 
 static void block_bitmap_copy(struct dm_integrity_c *ic, struct page_list *dst, struct page_list *src)
 {
-	unsigned n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
-	unsigned i;
+	unsigned int n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
+	unsigned int i;
 
 	for (i = 0; i < n_bitmap_pages; i++) {
 		unsigned long *dst_data = lowmem_page_address(dst[i].page);
@@ -717,18 +717,18 @@ static void block_bitmap_copy(struct dm_integrity_c *ic, struct page_list *dst,
 
 static struct bitmap_block_status *sector_to_bitmap_block(struct dm_integrity_c *ic, sector_t sector)
 {
-	unsigned bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
-	unsigned bitmap_block = bit / (BITMAP_BLOCK_SIZE * 8);
+	unsigned int bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+	unsigned int bitmap_block = bit / (BITMAP_BLOCK_SIZE * 8);
 
 	BUG_ON(bitmap_block >= ic->n_bitmap_blocks);
 	return &ic->bbs[bitmap_block];
 }
 
-static void access_journal_check(struct dm_integrity_c *ic, unsigned section, unsigned offset,
+static void access_journal_check(struct dm_integrity_c *ic, unsigned int section, unsigned int offset,
 				 bool e, const char *function)
 {
 #if defined(CONFIG_DM_DEBUG) || defined(INTERNAL_VERIFY)
-	unsigned limit = e ? ic->journal_section_entries : ic->journal_section_sectors;
+	unsigned int limit = e ? ic->journal_section_entries : ic->journal_section_sectors;
 
 	if (unlikely(section >= ic->journal_sections) ||
 	    unlikely(offset >= limit)) {
@@ -739,10 +739,10 @@ static void access_journal_check(struct dm_integrity_c *ic, unsigned section, un
 #endif
 }
 
-static void page_list_location(struct dm_integrity_c *ic, unsigned section, unsigned offset,
-			       unsigned *pl_index, unsigned *pl_offset)
+static void page_list_location(struct dm_integrity_c *ic, unsigned int section, unsigned int offset,
+			       unsigned int *pl_index, unsigned int *pl_offset)
 {
-	unsigned sector;
+	unsigned int sector;
 
 	access_journal_check(ic, section, offset, false, "page_list_location");
 
@@ -753,9 +753,9 @@ static void page_list_location(struct dm_integrity_c *ic, unsigned section, unsi
 }
 
 static struct journal_sector *access_page_list(struct dm_integrity_c *ic, struct page_list *pl,
-					       unsigned section, unsigned offset, unsigned *n_sectors)
+					       unsigned int section, unsigned int offset, unsigned int *n_sectors)
 {
-	unsigned pl_index, pl_offset;
+	unsigned int pl_index, pl_offset;
 	char *va;
 
 	page_list_location(ic, section, offset, &pl_index, &pl_offset);
@@ -768,14 +768,14 @@ static struct journal_sector *access_page_list(struct dm_integrity_c *ic, struct
 	return (struct journal_sector *)(va + pl_offset);
 }
 
-static struct journal_sector *access_journal(struct dm_integrity_c *ic, unsigned section, unsigned offset)
+static struct journal_sector *access_journal(struct dm_integrity_c *ic, unsigned int section, unsigned int offset)
 {
 	return access_page_list(ic, ic->journal, section, offset, NULL);
 }
 
-static struct journal_entry *access_journal_entry(struct dm_integrity_c *ic, unsigned section, unsigned n)
+static struct journal_entry *access_journal_entry(struct dm_integrity_c *ic, unsigned int section, unsigned int n)
 {
-	unsigned rel_sector, offset;
+	unsigned int rel_sector, offset;
 	struct journal_sector *js;
 
 	access_journal_check(ic, section, n, true, "access_journal_entry");
@@ -787,7 +787,7 @@ static struct journal_entry *access_journal_entry(struct dm_integrity_c *ic, uns
 	return (struct journal_entry *)((char *)js + offset * ic->journal_entry_size);
 }
 
-static struct journal_sector *access_journal_data(struct dm_integrity_c *ic, unsigned section, unsigned n)
+static struct journal_sector *access_journal_data(struct dm_integrity_c *ic, unsigned int section, unsigned int n)
 {
 	n <<= ic->sb->log2_sectors_per_block;
 
@@ -798,11 +798,11 @@ static struct journal_sector *access_journal_data(struct dm_integrity_c *ic, uns
 	return access_journal(ic, section, n);
 }
 
-static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result[JOURNAL_MAC_SIZE])
+static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 result[JOURNAL_MAC_SIZE])
 {
 	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
 	int r;
-	unsigned j, size;
+	unsigned int j, size;
 
 	desc->tfm = ic->journal_mac;
 
@@ -867,10 +867,10 @@ static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result
 	memset(result, 0, JOURNAL_MAC_SIZE);
 }
 
-static void rw_section_mac(struct dm_integrity_c *ic, unsigned section, bool wr)
+static void rw_section_mac(struct dm_integrity_c *ic, unsigned int section, bool wr)
 {
 	__u8 result[JOURNAL_MAC_SIZE];
-	unsigned j;
+	unsigned int j;
 
 	if (!ic->journal_mac)
 		return;
@@ -899,12 +899,12 @@ static void complete_journal_op(void *context)
 		complete(&comp->comp);
 }
 
-static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned section,
-			unsigned n_sections, struct journal_completion *comp)
+static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int section,
+			unsigned int n_sections, struct journal_completion *comp)
 {
 	struct async_submit_ctl submit;
 	size_t n_bytes = (size_t)(n_sections * ic->journal_section_sectors) << SECTOR_SHIFT;
-	unsigned pl_index, pl_offset, section_index;
+	unsigned int pl_index, pl_offset, section_index;
 	struct page_list *source_pl, *target_pl;
 
 	if (likely(encrypt)) {
@@ -929,7 +929,7 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned sectio
 		struct page *dst_page;
 
 		while (unlikely(pl_index == section_index)) {
-			unsigned dummy;
+			unsigned int dummy;
 			if (likely(encrypt))
 				rw_section_mac(ic, section, true);
 			section++;
@@ -991,8 +991,8 @@ static bool do_crypt(bool encrypt, struct skcipher_request *req, struct journal_
 	return false;
 }
 
-static void crypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned section,
-			  unsigned n_sections, struct journal_completion *comp)
+static void crypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int section,
+			  unsigned int n_sections, struct journal_completion *comp)
 {
 	struct scatterlist **source_sg;
 	struct scatterlist **target_sg;
@@ -1009,7 +1009,7 @@ static void crypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned sect
 
 	do {
 		struct skcipher_request *req;
-		unsigned ivsize;
+		unsigned int ivsize;
 		char *iv;
 
 		if (likely(encrypt))
@@ -1035,8 +1035,8 @@ static void crypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned sect
 	complete_journal_op(comp);
 }
 
-static void encrypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned section,
-			    unsigned n_sections, struct journal_completion *comp)
+static void encrypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int section,
+			    unsigned int n_sections, struct journal_completion *comp)
 {
 	if (ic->journal_xor)
 		return xor_journal(ic, encrypt, section, n_sections, comp);
@@ -1053,12 +1053,12 @@ static void complete_journal_io(unsigned long error, void *context)
 }
 
 static void rw_journal_sectors(struct dm_integrity_c *ic, blk_opf_t opf,
-			       unsigned sector, unsigned n_sectors,
+			       unsigned int sector, unsigned int n_sectors,
 			       struct journal_completion *comp)
 {
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
-	unsigned pl_index, pl_offset;
+	unsigned int pl_index, pl_offset;
 	int r;
 
 	if (unlikely(dm_integrity_failed(ic))) {
@@ -1100,10 +1100,10 @@ static void rw_journal_sectors(struct dm_integrity_c *ic, blk_opf_t opf,
 }
 
 static void rw_journal(struct dm_integrity_c *ic, blk_opf_t opf,
-		       unsigned section, unsigned n_sections,
+		       unsigned int section, unsigned int n_sections,
 		       struct journal_completion *comp)
 {
-	unsigned sector, n_sectors;
+	unsigned int sector, n_sectors;
 
 	sector = section * ic->journal_section_sectors;
 	n_sectors = n_sections * ic->journal_section_sectors;
@@ -1111,12 +1111,12 @@ static void rw_journal(struct dm_integrity_c *ic, blk_opf_t opf,
 	rw_journal_sectors(ic, opf, sector, n_sectors, comp);
 }
 
-static void write_journal(struct dm_integrity_c *ic, unsigned commit_start, unsigned commit_sections)
+static void write_journal(struct dm_integrity_c *ic, unsigned int commit_start, unsigned int commit_sections)
 {
 	struct journal_completion io_comp;
 	struct journal_completion crypt_comp_1;
 	struct journal_completion crypt_comp_2;
-	unsigned i;
+	unsigned int i;
 
 	io_comp.ic = ic;
 	init_completion(&io_comp.comp);
@@ -1136,7 +1136,7 @@ static void write_journal(struct dm_integrity_c *ic, unsigned commit_start, unsi
 		rw_journal(ic, REQ_OP_WRITE | REQ_FUA | REQ_SYNC, commit_start,
 			   commit_sections, &io_comp);
 	} else {
-		unsigned to_end;
+		unsigned int to_end;
 		io_comp.in_flight = (atomic_t)ATOMIC_INIT(2);
 		to_end = ic->journal_sections - commit_start;
 		if (ic->journal_io) {
@@ -1173,15 +1173,15 @@ static void write_journal(struct dm_integrity_c *ic, unsigned commit_start, unsi
 	wait_for_completion_io(&io_comp.comp);
 }
 
-static void copy_from_journal(struct dm_integrity_c *ic, unsigned section, unsigned offset,
-			      unsigned n_sectors, sector_t target, io_notify_fn fn, void *data)
+static void copy_from_journal(struct dm_integrity_c *ic, unsigned int section, unsigned int offset,
+			      unsigned int n_sectors, sector_t target, io_notify_fn fn, void *data)
 {
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
 	int r;
-	unsigned sector, pl_index, pl_offset;
+	unsigned int sector, pl_index, pl_offset;
 
-	BUG_ON((target | n_sectors | offset) & (unsigned)(ic->sectors_per_block - 1));
+	BUG_ON((target | n_sectors | offset) & (unsigned int)(ic->sectors_per_block - 1));
 
 	if (unlikely(dm_integrity_failed(ic))) {
 		fn(-1UL, data);
@@ -1222,7 +1222,7 @@ static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *
 	struct rb_node **n = &ic->in_progress.rb_node;
 	struct rb_node *parent;
 
-	BUG_ON((new_range->logical_sector | new_range->n_sectors) & (unsigned)(ic->sectors_per_block - 1));
+	BUG_ON((new_range->logical_sector | new_range->n_sectors) & (unsigned int)(ic->sectors_per_block - 1));
 
 	if (likely(check_waiting)) {
 		struct dm_integrity_range *range;
@@ -1340,10 +1340,10 @@ static void remove_journal_node(struct dm_integrity_c *ic, struct journal_node *
 
 #define NOT_FOUND	(-1U)
 
-static unsigned find_journal_node(struct dm_integrity_c *ic, sector_t sector, sector_t *next_sector)
+static unsigned int find_journal_node(struct dm_integrity_c *ic, sector_t sector, sector_t *next_sector)
 {
 	struct rb_node *n = ic->journal_tree_root.rb_node;
-	unsigned found = NOT_FOUND;
+	unsigned int found = NOT_FOUND;
 	*next_sector = (sector_t)-1;
 	while (n) {
 		struct journal_node *j = container_of(n, struct journal_node, node);
@@ -1361,7 +1361,7 @@ static unsigned find_journal_node(struct dm_integrity_c *ic, sector_t sector, se
 	return found;
 }
 
-static bool test_journal_node(struct dm_integrity_c *ic, unsigned pos, sector_t sector)
+static bool test_journal_node(struct dm_integrity_c *ic, unsigned int pos, sector_t sector)
 {
 	struct journal_node *node, *next_node;
 	struct rb_node *next;
@@ -1386,7 +1386,7 @@ static bool find_newer_committed_node(struct dm_integrity_c *ic, struct journal_
 {
 	struct rb_node *next;
 	struct journal_node *next_node;
-	unsigned next_section;
+	unsigned int next_section;
 
 	BUG_ON(RB_EMPTY_NODE(&node->node));
 
@@ -1399,7 +1399,7 @@ static bool find_newer_committed_node(struct dm_integrity_c *ic, struct journal_
 	if (next_node->sector != node->sector)
 		return false;
 
-	next_section = (unsigned)(next_node - ic->journal_tree) / ic->journal_section_entries;
+	next_section = (unsigned int)(next_node - ic->journal_tree) / ic->journal_section_entries;
 	if (next_section >= ic->committed_section &&
 	    next_section < ic->committed_section + ic->n_committed_sections)
 		return true;
@@ -1414,17 +1414,17 @@ static bool find_newer_committed_node(struct dm_integrity_c *ic, struct journal_
 #define TAG_CMP		2
 
 static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, sector_t *metadata_block,
-			       unsigned *metadata_offset, unsigned total_size, int op)
+			       unsigned int *metadata_offset, unsigned int total_size, int op)
 {
 #define MAY_BE_FILLER		1
 #define MAY_BE_HASH		2
-	unsigned hash_offset = 0;
-	unsigned may_be = MAY_BE_HASH | (ic->discard ? MAY_BE_FILLER : 0);
+	unsigned int hash_offset = 0;
+	unsigned int may_be = MAY_BE_HASH | (ic->discard ? MAY_BE_FILLER : 0);
 
 	do {
 		unsigned char *data, *dp;
 		struct dm_buffer *b;
-		unsigned to_copy;
+		unsigned int to_copy;
 		int r;
 
 		r = dm_integrity_failed(ic);
@@ -1454,7 +1454,7 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 						goto thorough_test;
 				}
 			} else {
-				unsigned i, ts;
+				unsigned int i, ts;
 thorough_test:
 				ts = total_size;
 
@@ -1653,7 +1653,7 @@ static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_hash);
 	int r;
-	unsigned digest_size;
+	unsigned int digest_size;
 
 	req->tfm = ic->internal_hash;
 
@@ -1710,13 +1710,13 @@ static void integrity_metadata(struct work_struct *w)
 	if (ic->internal_hash) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
-		unsigned digest_size = crypto_shash_digestsize(ic->internal_hash);
+		unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
-		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
+		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
 		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
-		unsigned sectors_to_process;
+		unsigned int sectors_to_process;
 
 		if (unlikely(ic->mode == 'R'))
 			goto skip_io;
@@ -1736,13 +1736,13 @@ static void integrity_metadata(struct work_struct *w)
 		}
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
-			unsigned bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned max_blocks = max_size / ic->tag_size;
+			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_blocks = max_size / ic->tag_size;
 			memset(checksums, DISCARD_FILLER, max_size);
 
 			while (bi_size) {
-				unsigned this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
+				unsigned int this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
 				this_step_blocks = min(this_step_blocks, max_blocks);
 				r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 							this_step_blocks * ic->tag_size, TAG_WRITE);
@@ -1764,7 +1764,7 @@ static void integrity_metadata(struct work_struct *w)
 		sectors_to_process = dio->range.n_sectors;
 
 		__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
-			unsigned pos;
+			unsigned int pos;
 			char *mem, *checksums_ptr;
 
 again:
@@ -1817,13 +1817,13 @@ static void integrity_metadata(struct work_struct *w)
 		if (bip) {
 			struct bio_vec biv;
 			struct bvec_iter iter;
-			unsigned data_to_process = dio->range.n_sectors;
+			unsigned int data_to_process = dio->range.n_sectors;
 			sector_to_block(ic, data_to_process);
 			data_to_process *= ic->tag_size;
 
 			bip_for_each_vec(biv, bip, iter) {
 				unsigned char *tag;
-				unsigned this_len;
+				unsigned int this_len;
 
 				BUG_ON(PageHighMem(biv.bv_page));
 				tag = bvec_virt(&biv);
@@ -1861,7 +1861,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	if (unlikely(dio->op == REQ_OP_DISCARD)) {
 		if (ti->max_io_len) {
 			sector_t sec = dm_target_offset(ti, bio->bi_iter.bi_sector);
-			unsigned log2_max_io_len = __fls(ti->max_io_len);
+			unsigned int log2_max_io_len = __fls(ti->max_io_len);
 			sector_t start_boundary = sec >> log2_max_io_len;
 			sector_t end_boundary = (sec + bio_sectors(bio) - 1) >> log2_max_io_len;
 			if (start_boundary < end_boundary) {
@@ -1891,7 +1891,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 		      ic->provided_data_sectors);
 		return DM_MAPIO_KILL;
 	}
-	if (unlikely((dio->range.logical_sector | bio_sectors(bio)) & (unsigned)(ic->sectors_per_block - 1))) {
+	if (unlikely((dio->range.logical_sector | bio_sectors(bio)) & (unsigned int)(ic->sectors_per_block - 1))) {
 		DMERR("Bio not aligned on %u sectors: 0x%llx, 0x%x",
 		      ic->sectors_per_block,
 		      dio->range.logical_sector, bio_sectors(bio));
@@ -1913,7 +1913,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	bip = bio_integrity(bio);
 	if (!ic->internal_hash) {
 		if (bip) {
-			unsigned wanted_tag_size = bio_sectors(bio) >> ic->sb->log2_sectors_per_block;
+			unsigned int wanted_tag_size = bio_sectors(bio) >> ic->sb->log2_sectors_per_block;
 			if (ic->log2_tag_size >= 0)
 				wanted_tag_size <<= ic->log2_tag_size;
 			else
@@ -1943,11 +1943,11 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 }
 
 static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
-				 unsigned journal_section, unsigned journal_entry)
+				 unsigned int journal_section, unsigned int journal_entry)
 {
 	struct dm_integrity_c *ic = dio->ic;
 	sector_t logical_sector;
-	unsigned n_sectors;
+	unsigned int n_sectors;
 
 	logical_sector = dio->range.logical_sector;
 	n_sectors = dio->range.n_sectors;
@@ -1970,7 +1970,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 			if (unlikely(dio->op == REQ_OP_READ)) {
 				struct journal_sector *js;
 				char *mem_ptr;
-				unsigned s;
+				unsigned int s;
 
 				if (unlikely(journal_entry_is_inprogress(je))) {
 					flush_dcache_page(bv.bv_page);
@@ -2007,12 +2007,12 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 
 			if (!ic->internal_hash) {
 				struct bio_integrity_payload *bip = bio_integrity(bio);
-				unsigned tag_todo = ic->tag_size;
+				unsigned int tag_todo = ic->tag_size;
 				char *tag_ptr = journal_entry_tag(ic, je);
 
 				if (bip) do {
 					struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
-					unsigned tag_now = min(biv.bv_len, tag_todo);
+					unsigned int tag_now = min(biv.bv_len, tag_todo);
 					char *tag_addr;
 					BUG_ON(PageHighMem(biv.bv_page));
 					tag_addr = bvec_virt(&biv);
@@ -2031,7 +2031,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 
 			if (likely(dio->op == REQ_OP_WRITE)) {
 				struct journal_sector *js;
-				unsigned s;
+				unsigned int s;
 
 				js = access_journal_data(ic, journal_section, journal_entry);
 				memcpy(js, mem + bv.bv_offset, ic->sectors_per_block << SECTOR_SHIFT);
@@ -2042,7 +2042,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 
 				if (ic->internal_hash) {
-					unsigned digest_size = crypto_shash_digestsize(ic->internal_hash);
+					unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
 						integrity_sector_checksum(ic, logical_sector, (char *)js, checksums_onstack);
@@ -2099,8 +2099,8 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 {
 	struct dm_integrity_c *ic = dio->ic;
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
-	unsigned journal_section, journal_entry;
-	unsigned journal_read_pos;
+	unsigned int journal_section, journal_entry;
+	unsigned int journal_read_pos;
 	struct completion read_comp;
 	bool discard_retried = false;
 	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
@@ -2125,8 +2125,8 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	journal_read_pos = NOT_FOUND;
 	if (ic->mode == 'J' && likely(dio->op != REQ_OP_DISCARD)) {
 		if (dio->op == REQ_OP_WRITE) {
-			unsigned next_entry, i, pos;
-			unsigned ws, we, range_sectors;
+			unsigned int next_entry, i, pos;
+			unsigned int ws, we, range_sectors;
 
 			dio->range.n_sectors = min(dio->range.n_sectors,
 						   (sector_t)ic->free_sectors << ic->sb->log2_sectors_per_block);
@@ -2179,8 +2179,8 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 				if (unlikely(dio->range.n_sectors > next_sector - dio->range.logical_sector))
 					dio->range.n_sectors = next_sector - dio->range.logical_sector;
 			} else {
-				unsigned i;
-				unsigned jp = journal_read_pos + 1;
+				unsigned int i;
+				unsigned int jp = journal_read_pos + 1;
 				for (i = ic->sectors_per_block; i < dio->range.n_sectors; i += ic->sectors_per_block, jp++) {
 					if (!test_journal_node(ic, jp, dio->range.logical_sector + i))
 						break;
@@ -2212,7 +2212,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 		 */
 		if (journal_read_pos != NOT_FOUND) {
 			sector_t next_sector;
-			unsigned new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+			unsigned int new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 			if (unlikely(new_pos != journal_read_pos)) {
 				remove_range_unlocked(ic, &dio->range);
 				goto retry;
@@ -2221,7 +2221,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	}
 	if (ic->mode == 'J' && likely(dio->op == REQ_OP_DISCARD) && !discard_retried) {
 		sector_t next_sector;
-		unsigned new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+		unsigned int new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 		if (unlikely(new_pos != NOT_FOUND) ||
 		    unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
 			remove_range_unlocked(ic, &dio->range);
@@ -2348,8 +2348,8 @@ static void pad_uncommitted(struct dm_integrity_c *ic)
 static void integrity_commit(struct work_struct *w)
 {
 	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, commit_work);
-	unsigned commit_start, commit_sections;
-	unsigned i, j, n;
+	unsigned int commit_start, commit_sections;
+	unsigned int i, j, n;
 	struct bio *flushes;
 
 	del_timer(&ic->autocommit_timer);
@@ -2427,17 +2427,17 @@ static void complete_copy_from_journal(unsigned long error, void *context)
 static void restore_last_bytes(struct dm_integrity_c *ic, struct journal_sector *js,
 			       struct journal_entry *je)
 {
-	unsigned s = 0;
+	unsigned int s = 0;
 	do {
 		js->commit_id = je->last_bytes[s];
 		js++;
 	} while (++s < ic->sectors_per_block);
 }
 
-static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
-			     unsigned write_sections, bool from_replay)
+static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start,
+			     unsigned int write_sections, bool from_replay)
 {
-	unsigned i, j, n;
+	unsigned int i, j, n;
 	struct journal_completion comp;
 	struct blk_plug plug;
 
@@ -2456,9 +2456,9 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 		for (j = 0; j < ic->journal_section_entries; j++) {
 			struct journal_entry *je = access_journal_entry(ic, i, j);
 			sector_t sec, area, offset;
-			unsigned k, l, next_loop;
+			unsigned int k, l, next_loop;
 			sector_t metadata_block;
-			unsigned metadata_offset;
+			unsigned int metadata_offset;
 			struct journal_io *io;
 
 			if (journal_entry_is_unused(je))
@@ -2466,7 +2466,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 			BUG_ON(unlikely(journal_entry_is_inprogress(je)) && !from_replay);
 			sec = journal_entry_get_sector(je);
 			if (unlikely(from_replay)) {
-				if (unlikely(sec & (unsigned)(ic->sectors_per_block - 1))) {
+				if (unlikely(sec & (unsigned int)(ic->sectors_per_block - 1))) {
 					dm_integrity_io_error(ic, "invalid sector in journal", -EIO);
 					sec &= ~(sector_t)(ic->sectors_per_block - 1);
 				}
@@ -2584,9 +2584,9 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 static void integrity_writer(struct work_struct *w)
 {
 	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, writer_work);
-	unsigned write_start, write_sections;
+	unsigned int write_start, write_sections;
 
-	unsigned prev_free_sectors;
+	unsigned int prev_free_sectors;
 
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
@@ -2633,12 +2633,12 @@ static void integrity_recalc(struct work_struct *w)
 	struct dm_io_region io_loc;
 	sector_t area, offset;
 	sector_t metadata_block;
-	unsigned metadata_offset;
+	unsigned int metadata_offset;
 	sector_t logical_sector, n_sectors;
 	__u8 *t;
-	unsigned i;
+	unsigned int i;
 	int r;
-	unsigned super_counter = 0;
+	unsigned int super_counter = 0;
 
 	DEBUG_print("start recalculation... (position %llx)\n", le64_to_cpu(ic->sb->recalc_sector));
 
@@ -2662,7 +2662,7 @@ static void integrity_recalc(struct work_struct *w)
 	get_area_and_offset(ic, range.logical_sector, &area, &offset);
 	range.n_sectors = min((sector_t)RECALC_SECTORS, ic->provided_data_sectors - range.logical_sector);
 	if (!ic->meta_dev)
-		range.n_sectors = min(range.n_sectors, ((sector_t)1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
+		range.n_sectors = min(range.n_sectors, ((sector_t)1U << ic->sb->log2_interleave_sectors) - (unsigned int)offset);
 
 	add_new_range_and_wait(ic, &range);
 	spin_unlock_irq(&ic->endio_wait.lock);
@@ -2853,10 +2853,10 @@ static void bitmap_flush_work(struct work_struct *work)
 }
 
 
-static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
-			 unsigned n_sections, unsigned char commit_seq)
+static void init_journal(struct dm_integrity_c *ic, unsigned int start_section,
+			 unsigned int n_sections, unsigned char commit_seq)
 {
-	unsigned i, j, n;
+	unsigned int i, j, n;
 
 	if (!n_sections)
 		return;
@@ -2879,7 +2879,7 @@ static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
 	write_journal(ic, start_section, n_sections);
 }
 
-static int find_commit_seq(struct dm_integrity_c *ic, unsigned i, unsigned j, commit_id_t id)
+static int find_commit_seq(struct dm_integrity_c *ic, unsigned int i, unsigned int j, commit_id_t id)
 {
 	unsigned char k;
 	for (k = 0; k < N_COMMIT_IDS; k++) {
@@ -2892,11 +2892,11 @@ static int find_commit_seq(struct dm_integrity_c *ic, unsigned i, unsigned j, co
 
 static void replay_journal(struct dm_integrity_c *ic)
 {
-	unsigned i, j;
+	unsigned int i, j;
 	bool used_commit_ids[N_COMMIT_IDS];
-	unsigned max_commit_id_sections[N_COMMIT_IDS];
-	unsigned write_start, write_sections;
-	unsigned continue_section;
+	unsigned int max_commit_id_sections[N_COMMIT_IDS];
+	unsigned int write_start, write_sections;
+	unsigned int continue_section;
 	bool journal_empty;
 	unsigned char unused, last_used, want_commit_seq;
 
@@ -3014,7 +3014,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 		ic->commit_seq = want_commit_seq;
 		DEBUG_print("continuing from section %u, commit seq %d\n", write_start, ic->commit_seq);
 	} else {
-		unsigned s;
+		unsigned int s;
 		unsigned char erase_seq;
 clear_journal:
 		DEBUG_print("clearing journal\n");
@@ -3246,10 +3246,10 @@ static void dm_integrity_resume(struct dm_target *ti)
 }
 
 static void dm_integrity_status(struct dm_target *ti, status_type_t type,
-				unsigned status_flags, char *result, unsigned maxlen)
+				unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
-	unsigned arg_count;
+	unsigned int arg_count;
 	size_t sz = 0;
 
 	switch (type) {
@@ -3299,7 +3299,7 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
 		if (ic->mode == 'J') {
-			DMEMIT(" journal_watermark:%u", (unsigned)watermark_percentage);
+			DMEMIT(" journal_watermark:%u", (unsigned int)watermark_percentage);
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}
 		if (ic->mode == 'B') {
@@ -3378,7 +3378,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
 {
-	unsigned sector_space = JOURNAL_SECTOR_DATA;
+	unsigned int sector_space = JOURNAL_SECTOR_DATA;
 
 	ic->journal_sections = le32_to_cpu(ic->sb->journal_sections);
 	ic->journal_entry_size = roundup(offsetof(struct journal_entry, last_bytes[ic->sectors_per_block]) + ic->tag_size,
@@ -3455,9 +3455,10 @@ static void get_provided_data_sectors(struct dm_integrity_c *ic)
 	}
 }
 
-static int initialize_superblock(struct dm_integrity_c *ic, unsigned journal_sectors, unsigned interleave_sectors)
+static int initialize_superblock(struct dm_integrity_c *ic,
+				 unsigned int journal_sectors, unsigned int interleave_sectors)
 {
-	unsigned journal_sections;
+	unsigned int journal_sections;
 	int test_bit;
 
 	memset(ic->sb, 0, SB_SECTORS << SECTOR_SHIFT);
@@ -3542,7 +3543,7 @@ static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
 
 static void dm_integrity_free_page_list(struct page_list *pl)
 {
-	unsigned i;
+	unsigned int i;
 
 	if (!pl)
 		return;
@@ -3551,10 +3552,10 @@ static void dm_integrity_free_page_list(struct page_list *pl)
 	kvfree(pl);
 }
 
-static struct page_list *dm_integrity_alloc_page_list(unsigned n_pages)
+static struct page_list *dm_integrity_alloc_page_list(unsigned int n_pages)
 {
 	struct page_list *pl;
-	unsigned i;
+	unsigned int i;
 
 	pl = kvmalloc_array(n_pages + 1, sizeof(struct page_list), GFP_KERNEL | __GFP_ZERO);
 	if (!pl)
@@ -3577,7 +3578,7 @@ static struct page_list *dm_integrity_alloc_page_list(unsigned n_pages)
 
 static void dm_integrity_free_journal_scatterlist(struct dm_integrity_c *ic, struct scatterlist **sl)
 {
-	unsigned i;
+	unsigned int i;
 	for (i = 0; i < ic->journal_sections; i++)
 		kvfree(sl[i]);
 	kvfree(sl);
@@ -3587,7 +3588,7 @@ static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_int
 								   struct page_list *pl)
 {
 	struct scatterlist **sl;
-	unsigned i;
+	unsigned int i;
 
 	sl = kvmalloc_array(ic->journal_sections,
 			    sizeof(struct scatterlist *),
@@ -3597,10 +3598,10 @@ static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_int
 
 	for (i = 0; i < ic->journal_sections; i++) {
 		struct scatterlist *s;
-		unsigned start_index, start_offset;
-		unsigned end_index, end_offset;
-		unsigned n_pages;
-		unsigned idx;
+		unsigned int start_index, start_offset;
+		unsigned int end_index, end_offset;
+		unsigned int n_pages;
+		unsigned int idx;
 
 		page_list_location(ic, i, 0, &start_index, &start_offset);
 		page_list_location(ic, i, ic->journal_section_sectors - 1,
@@ -3618,7 +3619,7 @@ static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_int
 		sg_init_table(s, n_pages);
 		for (idx = start_index; idx <= end_index; idx++) {
 			char *va = lowmem_page_address(pl[idx].page);
-			unsigned start = 0, end = PAGE_SIZE;
+			unsigned int start = 0, end = PAGE_SIZE;
 			if (idx == start_index)
 				start = start_offset;
 			if (idx == end_index)
@@ -3705,7 +3706,7 @@ static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
 static int create_journal(struct dm_integrity_c *ic, char **error)
 {
 	int r = 0;
-	unsigned i;
+	unsigned int i;
 	__u64 journal_pages, journal_desc_size, journal_tree_size;
 	unsigned char *crypt_data = NULL, *crypt_iv = NULL;
 	struct skcipher_request *req = NULL;
@@ -3732,7 +3733,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 		goto bad;
 	}
 	if (ic->journal_crypt_alg.alg_string) {
-		unsigned ivsize, blocksize;
+		unsigned int ivsize, blocksize;
 		struct journal_completion comp;
 
 		comp.ic = ic;
@@ -3821,7 +3822,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 			crypto_free_skcipher(ic->journal_crypt);
 			ic->journal_crypt = NULL;
 		} else {
-			unsigned crypt_len = roundup(ivsize, blocksize);
+			unsigned int crypt_len = roundup(ivsize, blocksize);
 
 			req = skcipher_request_alloc(ic->journal_crypt, GFP_KERNEL);
 			if (!req) {
@@ -3909,7 +3910,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 	}
 
 	for (i = 0; i < N_COMMIT_IDS; i++) {
-		unsigned j;
+		unsigned int j;
 retest_commit_id:
 		for (j = 0; j < i; j++) {
 			if (ic->commit_ids[j] == ic->commit_ids[i]) {
@@ -3963,17 +3964,17 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
  *		journal_mac
  *		recalculate
  */
-static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_integrity_c *ic;
 	char dummy;
 	int r;
-	unsigned extra_args;
+	unsigned int extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
 		{0, 18, "Invalid number of feature args"},
 	};
-	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
+	unsigned int journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;
 	__u64 threshold;
 	unsigned long long start;
@@ -4052,7 +4053,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	while (extra_args--) {
 		const char *opt_string;
-		unsigned val;
+		unsigned int val;
 		unsigned long long llval;
 		opt_string = dm_shift_arg(&as);
 		if (!opt_string) {
@@ -4385,7 +4386,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	DEBUG_print("	journal_entries_per_sector %u\n", ic->journal_entries_per_sector);
 	DEBUG_print("	journal_section_entries %u\n", ic->journal_section_entries);
 	DEBUG_print("	journal_section_sectors %u\n", ic->journal_section_sectors);
-	DEBUG_print("	journal_sections %u\n", (unsigned)le32_to_cpu(ic->sb->journal_sections));
+	DEBUG_print("	journal_sections %u\n", (unsigned int)le32_to_cpu(ic->sb->journal_sections));
 	DEBUG_print("	journal_entries %u\n", ic->journal_entries);
 	DEBUG_print("	log2_interleave_sectors %d\n", ic->sb->log2_interleave_sectors);
 	DEBUG_print("	data_device_sectors 0x%llx\n", bdev_nr_sectors(ic->dev->bdev));
@@ -4459,8 +4460,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (ic->mode == 'B') {
-		unsigned i;
-		unsigned n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
+		unsigned int i;
+		unsigned int n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
 
 		ic->recalc_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->recalc_bitmap) {
@@ -4480,7 +4481,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		INIT_DELAYED_WORK(&ic->bitmap_flush_work, bitmap_flush_work);
 		for (i = 0; i < ic->n_bitmap_blocks; i++) {
 			struct bitmap_block_status *bbs = &ic->bbs[i];
-			unsigned sector, pl_index, pl_offset;
+			unsigned int sector, pl_index, pl_offset;
 
 			INIT_WORK(&bbs->work, bitmap_block_work);
 			bbs->ic = ic;
@@ -4517,7 +4518,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			goto bad;
 	}
 	if (ic->mode == 'B') {
-		unsigned max_io_len = ((sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit) * (BITMAP_BLOCK_SIZE * 8);
+		unsigned int max_io_len = ((sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit) * (BITMAP_BLOCK_SIZE * 8);
 		if (!max_io_len)
 			max_io_len = 1U << 31;
 		DEBUG_print("max_io_len: old %u, new %u\n", ti->max_io_len, max_io_len);
@@ -4588,7 +4589,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	if (ic->journal_io_scatterlist)
 		dm_integrity_free_journal_scatterlist(ic, ic->journal_io_scatterlist);
 	if (ic->sk_requests) {
-		unsigned i;
+		unsigned int i;
 
 		for (i = 0; i < ic->journal_sections; i++) {
 			struct skcipher_request *req = ic->sk_requests[i];
diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index ce05819cbe8b..efd76412262a 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -57,7 +57,7 @@ static void dm_bio_integrity_rewind(struct bio *bio, unsigned int bytes_done)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
-	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
+	unsigned int bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
 	bip->bip_iter.bi_sector -= bio_integrity_intervals(bi, bytes_done >> 9);
 	dm_bvec_iter_rewind(bip->bip_vec, &bip->bip_iter, bytes);
@@ -131,7 +131,7 @@ static inline void dm_bio_rewind_iter(const struct bio *bio,
  * rewinding from end of bio and restoring its original position.
  * Caller is also responsibile for restoring bio's size.
  */
-static void dm_bio_rewind(struct bio *bio, unsigned bytes)
+static void dm_bio_rewind(struct bio *bio, unsigned int bytes)
 {
 	if (bio_integrity(bio))
 		dm_bio_integrity_rewind(bio, bytes);
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index fc2ea6e29038..b2e4a6517e2e 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -49,7 +49,7 @@ static struct kmem_cache *_dm_io_cache;
 struct dm_io_client *dm_io_client_create(void)
 {
 	struct dm_io_client *client;
-	unsigned min_ios = dm_get_reserved_bio_based_ios();
+	unsigned int min_ios = dm_get_reserved_bio_based_ios();
 	int ret;
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
@@ -89,7 +89,7 @@ EXPORT_SYMBOL(dm_io_client_destroy);
  * bi_private.
  *---------------------------------------------------------------*/
 static void store_io_and_region_in_bio(struct bio *bio, struct io *io,
-				       unsigned region)
+				       unsigned int region)
 {
 	if (unlikely(!IS_ALIGNED((unsigned long)io, DM_IO_MAX_REGIONS))) {
 		DMCRIT("Unaligned struct io pointer %p", io);
@@ -100,7 +100,7 @@ static void store_io_and_region_in_bio(struct bio *bio, struct io *io,
 }
 
 static void retrieve_io_and_region_from_bio(struct bio *bio, struct io **io,
-				       unsigned *region)
+				       unsigned int *region)
 {
 	unsigned long val = (unsigned long)bio->bi_private;
 
@@ -138,7 +138,7 @@ static void dec_count(struct io *io, unsigned int region, blk_status_t error)
 static void endio(struct bio *bio)
 {
 	struct io *io;
-	unsigned region;
+	unsigned int region;
 	blk_status_t error;
 
 	if (bio->bi_status && bio_data_dir(bio) == READ)
@@ -161,11 +161,11 @@ static void endio(struct bio *bio)
  *---------------------------------------------------------------*/
 struct dpages {
 	void (*get_page)(struct dpages *dp,
-			 struct page **p, unsigned long *len, unsigned *offset);
+			 struct page **p, unsigned long *len, unsigned int *offset);
 	void (*next_page)(struct dpages *dp);
 
 	union {
-		unsigned context_u;
+		unsigned int context_u;
 		struct bvec_iter context_bi;
 	};
 	void *context_ptr;
@@ -178,9 +178,9 @@ struct dpages {
  * Functions for getting the pages from a list.
  */
 static void list_get_page(struct dpages *dp,
-		  struct page **p, unsigned long *len, unsigned *offset)
+		  struct page **p, unsigned long *len, unsigned int *offset)
 {
-	unsigned o = dp->context_u;
+	unsigned int o = dp->context_u;
 	struct page_list *pl = (struct page_list *) dp->context_ptr;
 
 	*p = pl->page;
@@ -195,7 +195,7 @@ static void list_next_page(struct dpages *dp)
 	dp->context_u = 0;
 }
 
-static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offset)
+static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned int offset)
 {
 	dp->get_page = list_get_page;
 	dp->next_page = list_next_page;
@@ -207,7 +207,7 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
  * Functions for getting the pages from a bvec.
  */
 static void bio_get_page(struct dpages *dp, struct page **p,
-			 unsigned long *len, unsigned *offset)
+			 unsigned long *len, unsigned int *offset)
 {
 	struct bio_vec bvec = bvec_iter_bvec((struct bio_vec *)dp->context_ptr,
 					     dp->context_bi);
@@ -245,7 +245,7 @@ static void bio_dp_init(struct dpages *dp, struct bio *bio)
  * Functions for getting the pages from a VMA.
  */
 static void vm_get_page(struct dpages *dp,
-		 struct page **p, unsigned long *len, unsigned *offset)
+		 struct page **p, unsigned long *len, unsigned int *offset)
 {
 	*p = vmalloc_to_page(dp->context_ptr);
 	*offset = dp->context_u;
@@ -270,7 +270,7 @@ static void vm_dp_init(struct dpages *dp, void *data)
  * Functions for getting the pages from kernel memory.
  */
 static void km_get_page(struct dpages *dp, struct page **p, unsigned long *len,
-			unsigned *offset)
+			unsigned int *offset)
 {
 	*p = virt_to_page(dp->context_ptr);
 	*offset = dp->context_u;
@@ -294,15 +294,15 @@ static void km_dp_init(struct dpages *dp, void *data)
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
-static void do_region(const blk_opf_t opf, unsigned region,
+static void do_region(const blk_opf_t opf, unsigned int region,
 		      struct dm_io_region *where, struct dpages *dp,
 		      struct io *io)
 {
 	struct bio *bio;
 	struct page *page;
 	unsigned long len;
-	unsigned offset;
-	unsigned num_bvecs;
+	unsigned int offset;
+	unsigned int num_bvecs;
 	sector_t remaining = where->count;
 	struct request_queue *q = bdev_get_queue(where->bdev);
 	sector_t num_sectors;
@@ -509,7 +509,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 	return 0;
 }
 
-int dm_io(struct dm_io_request *io_req, unsigned num_regions,
+int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
 	  struct dm_io_region *where, unsigned long *sync_error_bits)
 {
 	int r;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 16f55dc65382..36943bcbd8cb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -32,7 +32,7 @@ struct dm_file {
 	 * poll will wait until the global event number is greater than
 	 * this value.
 	 */
-	volatile unsigned global_event_nr;
+	volatile unsigned int global_event_nr;
 };
 
 /*-----------------------------------------------------------------
@@ -414,7 +414,7 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 	struct hash_cell *hc;
 	struct dm_table *table;
 	struct mapped_device *md;
-	unsigned change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
+	unsigned int change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
 	int srcu_idx;
 
 	/*
@@ -1022,7 +1022,7 @@ static int dev_rename(struct file *filp, struct dm_ioctl *param, size_t param_si
 	int r;
 	char *new_data = (char *) param + param->data_start;
 	struct mapped_device *md;
-	unsigned change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
+	unsigned int change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
 
 	if (new_data < param->data ||
 	    invalid_str(new_data, (void *) param + param_size) || !*new_data ||
@@ -1096,7 +1096,7 @@ static int dev_set_geometry(struct file *filp, struct dm_ioctl *param, size_t pa
 static int do_suspend(struct dm_ioctl *param)
 {
 	int r = 0;
-	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
+	unsigned int suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -1125,7 +1125,7 @@ static int do_suspend(struct dm_ioctl *param)
 static int do_resume(struct dm_ioctl *param)
 {
 	int r = 0;
-	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
+	unsigned int suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map, *old_map = NULL;
@@ -1236,7 +1236,7 @@ static void retrieve_status(struct dm_table *table,
 	char *outbuf, *outptr;
 	status_type_t type;
 	size_t remaining, len, used = 0;
-	unsigned status_flags = 0;
+	unsigned int status_flags = 0;
 
 	outptr = outbuf = get_result_buffer(param, param_size, &len);
 
@@ -1641,8 +1641,8 @@ static int table_status(struct file *filp, struct dm_ioctl *param, size_t param_
  * Returns a number <= 1 if message was processed by device mapper.
  * Returns 2 if message should be delivered to the target.
  */
-static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
-			  char *result, unsigned maxlen)
+static int message_for_md(struct mapped_device *md, unsigned int argc, char **argv,
+			  char *result, unsigned int maxlen)
 {
 	int r;
 
@@ -1852,7 +1852,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	struct dm_ioctl *dmi;
 	int secure_data;
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
-	unsigned noio_flag;
+	unsigned int noio_flag;
 
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 132b50d06121..f46e3201b66f 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -35,14 +35,14 @@
 #define DEFAULT_SUB_JOB_SIZE_KB 512
 #define MAX_SUB_JOB_SIZE_KB     1024
 
-static unsigned kcopyd_subjob_size_kb = DEFAULT_SUB_JOB_SIZE_KB;
+static unsigned int kcopyd_subjob_size_kb = DEFAULT_SUB_JOB_SIZE_KB;
 
 module_param(kcopyd_subjob_size_kb, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(kcopyd_subjob_size_kb, "Sub-job size for dm-kcopyd clients");
 
-static unsigned dm_get_kcopyd_subjob_size(void)
+static unsigned int dm_get_kcopyd_subjob_size(void)
 {
-	unsigned sub_job_size_kb;
+	unsigned int sub_job_size_kb;
 
 	sub_job_size_kb = __dm_get_module_param(&kcopyd_subjob_size_kb,
 						DEFAULT_SUB_JOB_SIZE_KB,
@@ -57,9 +57,9 @@ static unsigned dm_get_kcopyd_subjob_size(void)
  *---------------------------------------------------------------*/
 struct dm_kcopyd_client {
 	struct page_list *pages;
-	unsigned nr_reserved_pages;
-	unsigned nr_free_pages;
-	unsigned sub_job_size;
+	unsigned int nr_reserved_pages;
+	unsigned int nr_free_pages;
+	unsigned int sub_job_size;
 
 	struct dm_io_client *io_client;
 
@@ -120,7 +120,7 @@ static DEFINE_SPINLOCK(throttle_spinlock);
 
 static void io_job_start(struct dm_kcopyd_throttle *t)
 {
-	unsigned throttle, now, difference;
+	unsigned int throttle, now, difference;
 	int slept = 0, skew;
 
 	if (unlikely(!t))
@@ -183,7 +183,7 @@ static void io_job_finish(struct dm_kcopyd_throttle *t)
 		goto skip_limit;
 
 	if (!t->num_io_jobs) {
-		unsigned now, difference;
+		unsigned int now, difference;
 
 		now = jiffies;
 		difference = now - t->last_jiffies;
@@ -304,9 +304,9 @@ static void drop_pages(struct page_list *pl)
 /*
  * Allocate and reserve nr_pages for the use of a specific client.
  */
-static int client_reserve_pages(struct dm_kcopyd_client *kc, unsigned nr_pages)
+static int client_reserve_pages(struct dm_kcopyd_client *kc, unsigned int nr_pages)
 {
-	unsigned i;
+	unsigned int i;
 	struct page_list *pl = NULL, *next;
 
 	for (i = 0; i < nr_pages; i++) {
@@ -342,7 +342,7 @@ static void client_free_pages(struct dm_kcopyd_client *kc)
 struct kcopyd_job {
 	struct dm_kcopyd_client *kc;
 	struct list_head list;
-	unsigned flags;
+	unsigned int flags;
 
 	/*
 	 * Error state of the job.
@@ -583,7 +583,7 @@ static int run_io_job(struct kcopyd_job *job)
 static int run_pages_job(struct kcopyd_job *job)
 {
 	int r;
-	unsigned nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
+	unsigned int nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
 
 	r = kcopyd_get_pages(job->kc, nr_pages, &job->pages);
 	if (!r) {
@@ -850,8 +850,8 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 EXPORT_SYMBOL(dm_kcopyd_copy);
 
 void dm_kcopyd_zero(struct dm_kcopyd_client *kc,
-		    unsigned num_dests, struct dm_io_region *dests,
-		    unsigned flags, dm_kcopyd_notify_fn fn, void *context)
+		    unsigned int num_dests, struct dm_io_region *dests,
+		    unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
 {
 	dm_kcopyd_copy(kc, NULL, num_dests, dests, flags, fn, context);
 }
@@ -907,7 +907,7 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
 struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
 	int r;
-	unsigned reserve_pages;
+	unsigned int reserve_pages;
 	struct dm_kcopyd_client *kc;
 
 	kc = kzalloc(sizeof(*kc), GFP_KERNEL);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 0515a7715a8a..874da33f090f 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -96,7 +96,7 @@ static int linear_map(struct dm_target *ti, struct bio *bio)
 }
 
 static void linear_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
 	size_t sz = 0;
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 3d5ef22e005f..d96a9651a462 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -124,7 +124,7 @@ static int userspace_do_request(struct log_c *lc, const char *uuid,
 }
 
 static int build_constructor_string(struct dm_target *ti,
-				    unsigned argc, char **argv,
+				    unsigned int argc, char **argv,
 				    char **ctr_str)
 {
 	int i, str_size;
@@ -189,7 +189,7 @@ static void do_flush(struct work_struct *work)
  * to the userspace ctr function.
  */
 static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
-			 unsigned argc, char **argv)
+			 unsigned int argc, char **argv)
 {
 	int r = 0;
 	int str_size;
@@ -793,7 +793,7 @@ static region_t userspace_get_sync_count(struct dm_dirty_log *log)
  * Returns: amount of space consumed
  */
 static int userspace_status(struct dm_dirty_log *log, status_type_t status_type,
-			    char *result, unsigned maxlen)
+			    char *result, unsigned int maxlen)
 {
 	int r = 0;
 	char *table_args;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 36e803603256..55c743056578 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -143,7 +143,7 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		fill_pkg(msg, NULL);
 	else if (msg->len < sizeof(*tfr))
 		DMERR("Incomplete message received (expected %u, got %u): [%u]",
-		      (unsigned)sizeof(*tfr), msg->len, msg->seq);
+		      (unsigned int)sizeof(*tfr), msg->len, msg->seq);
 	else
 		fill_pkg(NULL, tfr);
 	spin_unlock(&receiving_list_lock);
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index aed3a2cd1abd..6a07534b39fa 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -793,10 +793,10 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio,
  * INFO format: <logged entries> <highest allocated sector>
  */
 static void log_writes_status(struct dm_target *ti, status_type_t type,
-			      unsigned status_flags, char *result,
-			      unsigned maxlen)
+			      unsigned int status_flags, char *result,
+			      unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct log_writes_c *lc = ti->private;
 
 	switch (type) {
@@ -845,8 +845,8 @@ static int log_writes_iterate_devices(struct dm_target *ti,
  * Messages supported:
  *   mark <mark data> - specify the marked data.
  */
-static int log_writes_message(struct dm_target *ti, unsigned argc, char **argv,
-			      char *result, unsigned maxlen)
+static int log_writes_message(struct dm_target *ti, unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen)
 {
 	int r = -EINVAL;
 	struct log_writes_c *lc = ti->private;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index df2e55441648..955767de369b 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -224,7 +224,7 @@ struct log_c {
 	unsigned int region_count;
 	region_t sync_count;
 
-	unsigned bitset_uint32_count;
+	unsigned int bitset_uint32_count;
 	uint32_t *clean_bits;
 	uint32_t *sync_bits;
 	uint32_t *recovering_bits;	/* FIXME: this seems excessive */
@@ -256,20 +256,20 @@ struct log_c {
  * The touched member needs to be updated every time we access
  * one of the bitsets.
  */
-static inline int log_test_bit(uint32_t *bs, unsigned bit)
+static inline int log_test_bit(uint32_t *bs, unsigned int bit)
 {
 	return test_bit_le(bit, bs) ? 1 : 0;
 }
 
 static inline void log_set_bit(struct log_c *l,
-			       uint32_t *bs, unsigned bit)
+			       uint32_t *bs, unsigned int bit)
 {
 	__set_bit_le(bit, bs);
 	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
-				 uint32_t *bs, unsigned bit)
+				 uint32_t *bs, unsigned int bit)
 {
 	__clear_bit_le(bit, bs);
 	l->touched_dirtied = 1;
@@ -583,7 +583,7 @@ static void fail_log_device(struct log_c *lc)
 static int disk_resume(struct dm_dirty_log *log)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct log_c *lc = (struct log_c *) log->context;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 50adee92ad56..a8fcb41878fe 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -30,7 +30,7 @@
 
 #define DM_MSG_PREFIX "multipath"
 #define DM_PG_INIT_DELAY_MSECS 2000
-#define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
+#define DM_PG_INIT_DELAY_DEFAULT ((unsigned int) -1)
 #define QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT 0
 
 static unsigned long queue_if_no_path_timeout_secs = QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT;
@@ -40,7 +40,7 @@ struct pgpath {
 	struct list_head list;
 
 	struct priority_group *pg;	/* Owning PG */
-	unsigned fail_count;		/* Cumulative failure count */
+	unsigned int fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
 	struct delayed_work activate_path;
@@ -60,8 +60,8 @@ struct priority_group {
 	struct multipath *m;		/* Owning multipath instance */
 	struct path_selector ps;
 
-	unsigned pg_num;		/* Reference number */
-	unsigned nr_pgpaths;		/* Number of paths in PG */
+	unsigned int pg_num;		/* Reference number */
+	unsigned int nr_pgpaths;		/* Number of paths in PG */
 	struct list_head pgpaths;
 
 	bool bypassed:1;		/* Temporarily bypass this PG? */
@@ -79,14 +79,14 @@ struct multipath {
 	struct priority_group *next_pg;	/* Switch to this PG if set */
 
 	atomic_t nr_valid_paths;	/* Total number of usable paths */
-	unsigned nr_priority_groups;
+	unsigned int nr_priority_groups;
 	struct list_head priority_groups;
 
 	const char *hw_handler_name;
 	char *hw_handler_params;
 	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
-	unsigned pg_init_retries;	/* Number of times to retry pg_init */
-	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
+	unsigned int pg_init_retries;	/* Number of times to retry pg_init */
+	unsigned int pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once */
 	atomic_t pg_init_count;		/* Number of times pg_init called */
 
@@ -398,7 +398,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 	unsigned long flags;
 	struct priority_group *pg;
 	struct pgpath *pgpath;
-	unsigned bypassed = 1;
+	unsigned int bypassed = 1;
 
 	if (!atomic_read(&m->nr_valid_paths)) {
 		spin_lock_irqsave(&m->lock, flags);
@@ -841,7 +841,7 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 {
 	int r;
 	struct path_selector_type *pst;
-	unsigned ps_argc;
+	unsigned int ps_argc;
 
 	static const struct dm_arg _args[] = {
 		{0, 1024, "invalid number of path selector args"},
@@ -984,7 +984,7 @@ static struct priority_group *parse_priority_group(struct dm_arg_set *as,
 	};
 
 	int r;
-	unsigned i, nr_selector_args, nr_args;
+	unsigned int i, nr_selector_args, nr_args;
 	struct priority_group *pg;
 	struct dm_target *ti = m->ti;
 
@@ -1050,7 +1050,7 @@ static struct priority_group *parse_priority_group(struct dm_arg_set *as,
 
 static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 {
-	unsigned hw_argc;
+	unsigned int hw_argc;
 	int ret;
 	struct dm_target *ti = m->ti;
 
@@ -1102,7 +1102,7 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 static int parse_features(struct dm_arg_set *as, struct multipath *m)
 {
 	int r;
-	unsigned argc;
+	unsigned int argc;
 	struct dm_target *ti = m->ti;
 	const char *arg_name;
 
@@ -1171,7 +1171,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	return r;
 }
 
-static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int multipath_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	/* target arguments */
 	static const struct dm_arg _args[] = {
@@ -1182,8 +1182,8 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	int r;
 	struct multipath *m;
 	struct dm_arg_set as;
-	unsigned pg_count = 0;
-	unsigned next_pg_num;
+	unsigned int pg_count = 0;
+	unsigned int next_pg_num;
 	unsigned long flags;
 
 	as.argc = argc;
@@ -1225,7 +1225,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	/* parse the priority groups */
 	while (as.argc) {
 		struct priority_group *pg;
-		unsigned nr_valid_paths = atomic_read(&m->nr_valid_paths);
+		unsigned int nr_valid_paths = atomic_read(&m->nr_valid_paths);
 
 		pg = parse_priority_group(&as, m);
 		if (IS_ERR(pg)) {
@@ -1366,7 +1366,7 @@ static int reinstate_path(struct pgpath *pgpath)
 	int r = 0, run_queue = 0;
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
-	unsigned nr_valid_paths;
+	unsigned int nr_valid_paths;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -1455,7 +1455,7 @@ static void bypass_pg(struct multipath *m, struct priority_group *pg,
 static int switch_pg_num(struct multipath *m, const char *pgstr)
 {
 	struct priority_group *pg;
-	unsigned pgnum;
+	unsigned int pgnum;
 	unsigned long flags;
 	char dummy;
 
@@ -1488,7 +1488,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 {
 	struct priority_group *pg;
-	unsigned pgnum;
+	unsigned int pgnum;
 	char dummy;
 
 	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
@@ -1790,14 +1790,14 @@ static void multipath_resume(struct dm_target *ti)
  *      num_paths num_selector_args [path_dev [selector_args]* ]+ ]+
  */
 static void multipath_status(struct dm_target *ti, status_type_t type,
-			     unsigned status_flags, char *result, unsigned maxlen)
+			     unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int sz = 0, pg_counter, pgpath_counter;
 	unsigned long flags;
 	struct multipath *m = ti->private;
 	struct priority_group *pg;
 	struct pgpath *p;
-	unsigned pg_num;
+	unsigned int pg_num;
 	char state;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1949,8 +1949,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
-static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
-			     char *result, unsigned maxlen)
+static int multipath_message(struct dm_target *ti, unsigned int argc, char **argv,
+			     char *result, unsigned int maxlen)
 {
 	int r = -EINVAL;
 	struct dm_dev *dev;
diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index beb88b7dcb66..e1ebe6f1bdc3 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -18,6 +18,6 @@ struct dm_path {
 };
 
 /* Callback for hwh_pg_init_fn to use when complete */
-void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
+void dm_pg_init_complete(struct dm_path *path, unsigned int err_flags);
 
 #endif
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index 20a58ce13c60..f7390cb79a3c 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -53,7 +53,7 @@ struct path_selector_type {
 	/*
 	 * Constructs a path selector object, takes custom arguments
 	 */
-	int (*create) (struct path_selector *ps, unsigned argc, char **argv);
+	int (*create) (struct path_selector *ps, unsigned int argc, char **argv);
 	void (*destroy) (struct path_selector *ps);
 
 	/*
diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.c
index f74501e65a8e..76ce4ce87222 100644
--- a/drivers/md/dm-ps-io-affinity.c
+++ b/drivers/md/dm-ps-io-affinity.c
@@ -108,7 +108,7 @@ static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
 	return ret;
 }
 
-static int ioa_create(struct path_selector *ps, unsigned argc, char **argv)
+static int ioa_create(struct path_selector *ps, unsigned int argc, char **argv)
 {
 	struct selector *s;
 
@@ -138,7 +138,7 @@ static int ioa_create(struct path_selector *ps, unsigned argc, char **argv)
 static void ioa_destroy(struct path_selector *ps)
 {
 	struct selector *s = ps->context;
-	unsigned cpu;
+	unsigned int cpu;
 
 	for_each_cpu(cpu, s->path_mask)
 		ioa_free_path(s, cpu);
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index 28b1e6cd308f..4110142df66e 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -36,7 +36,7 @@ struct selector {
 struct path_info {
 	struct list_head	list;
 	struct dm_path		*path;
-	unsigned		repeat_count;
+	unsigned int		repeat_count;
 	atomic_t		qlen;	/* the number of in-flight I/Os */
 };
 
@@ -53,7 +53,7 @@ static struct selector *alloc_selector(void)
 	return s;
 }
 
-static int ql_create(struct path_selector *ps, unsigned argc, char **argv)
+static int ql_create(struct path_selector *ps, unsigned int argc, char **argv)
 {
 	struct selector *s = alloc_selector();
 
@@ -85,9 +85,9 @@ static void ql_destroy(struct path_selector *ps)
 }
 
 static int ql_status(struct path_selector *ps, struct dm_path *path,
-		     status_type_t type, char *result, unsigned maxlen)
+		     status_type_t type, char *result, unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct path_info *pi;
 
 	/* When called with NULL path, return selector status/args. */
@@ -117,7 +117,7 @@ static int ql_add_path(struct path_selector *ps, struct dm_path *path,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi;
-	unsigned repeat_count = QL_MIN_IO;
+	unsigned int repeat_count = QL_MIN_IO;
 	char dummy;
 	unsigned long flags;
 
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index f823fbfac73f..3cc80efbadd2 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -27,7 +27,7 @@
 struct path_info {
 	struct list_head list;
 	struct dm_path *path;
-	unsigned repeat_count;
+	unsigned int repeat_count;
 };
 
 static void free_paths(struct list_head *paths)
@@ -63,7 +63,7 @@ static struct selector *alloc_selector(void)
 	return s;
 }
 
-static int rr_create(struct path_selector *ps, unsigned argc, char **argv)
+static int rr_create(struct path_selector *ps, unsigned int argc, char **argv)
 {
 	struct selector *s;
 
@@ -120,7 +120,7 @@ static int rr_add_path(struct path_selector *ps, struct dm_path *path,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi;
-	unsigned repeat_count = RR_MIN_IO;
+	unsigned int repeat_count = RR_MIN_IO;
 	char dummy;
 	unsigned long flags;
 
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index e3b6a00cb7ec..e38dda83952c 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -31,8 +31,8 @@ struct selector {
 struct path_info {
 	struct list_head list;
 	struct dm_path *path;
-	unsigned repeat_count;
-	unsigned relative_throughput;
+	unsigned int repeat_count;
+	unsigned int relative_throughput;
 	atomic_t in_flight_size;	/* Total size of in-flight I/Os */
 };
 
@@ -49,7 +49,7 @@ static struct selector *alloc_selector(void)
 	return s;
 }
 
-static int st_create(struct path_selector *ps, unsigned argc, char **argv)
+static int st_create(struct path_selector *ps, unsigned int argc, char **argv)
 {
 	struct selector *s = alloc_selector();
 
@@ -81,9 +81,9 @@ static void st_destroy(struct path_selector *ps)
 }
 
 static int st_status(struct path_selector *ps, struct dm_path *path,
-		     status_type_t type, char *result, unsigned maxlen)
+		     status_type_t type, char *result, unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct path_info *pi;
 
 	if (!path)
@@ -114,8 +114,8 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi;
-	unsigned repeat_count = ST_MIN_IO;
-	unsigned relative_throughput = 1;
+	unsigned int repeat_count = ST_MIN_IO;
+	unsigned int relative_throughput = 1;
 	char dummy;
 	unsigned long flags;
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 09caef1b45d9..a9ebe95f716e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3713,7 +3713,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 }
 
 static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
-			char *result, unsigned maxlen)
+			char *result, unsigned int maxlen)
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 0eebf90c138d..13cac904c5b8 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -83,7 +83,7 @@ struct mirror_set {
 
 	struct work_struct trigger_event;
 
-	unsigned nr_mirrors;
+	unsigned int nr_mirrors;
 	struct mirror mirror[];
 };
 
@@ -328,7 +328,7 @@ static void recovery_complete(int read_err, unsigned long write_err,
 
 static void recover(struct mirror_set *ms, struct dm_region *reg)
 {
-	unsigned i;
+	unsigned int i;
 	struct dm_io_region from, to[DM_KCOPYD_MAX_REGIONS], *dest;
 	struct mirror *m;
 	unsigned long flags = 0;
@@ -594,7 +594,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 
 static void write_callback(unsigned long error, void *context)
 {
-	unsigned i;
+	unsigned int i;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
 	int should_wake = 0;
@@ -964,10 +964,10 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
  * Create dirty log: log_type #log_params <log_params>
  */
 static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
-					     unsigned argc, char **argv,
-					     unsigned *args_used)
+					     unsigned int argc, char **argv,
+					     unsigned int *args_used)
 {
-	unsigned param_count;
+	unsigned int param_count;
 	struct dm_dirty_log *dl;
 	char dummy;
 
@@ -998,10 +998,10 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 	return dl;
 }
 
-static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
-			  unsigned *args_used)
+static int parse_features(struct mirror_set *ms, unsigned int argc, char **argv,
+			  unsigned int *args_used)
 {
-	unsigned num_features;
+	unsigned int num_features;
 	struct dm_target *ti = ms->ti;
 	char dummy;
 	int i;
@@ -1390,7 +1390,7 @@ static char device_status_char(struct mirror *m)
 
 
 static void mirror_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	unsigned int m, sz = 0;
 	int num_feature_args = 0;
@@ -1459,7 +1459,7 @@ static int mirror_iterate_devices(struct dm_target *ti,
 {
 	struct mirror_set *ms = ti->private;
 	int ret = 0;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; !ret && i < ms->nr_mirrors; i++)
 		ret = fn(ti, ms->mirror[i].dev,
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 2ac1dd406135..ce6a788e497c 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -57,17 +57,17 @@
  *---------------------------------------------------------------*/
 struct dm_region_hash {
 	uint32_t region_size;
-	unsigned region_shift;
+	unsigned int region_shift;
 
 	/* holds persistent region state */
 	struct dm_dirty_log *log;
 
 	/* hash table */
 	rwlock_t hash_lock;
-	unsigned mask;
-	unsigned nr_buckets;
-	unsigned prime;
-	unsigned shift;
+	unsigned int mask;
+	unsigned int nr_buckets;
+	unsigned int prime;
+	unsigned int shift;
 	struct list_head *buckets;
 
 	/*
@@ -75,7 +75,7 @@ struct dm_region_hash {
 	 */
 	int flush_failure;
 
-	unsigned max_recovery; /* Max # of regions to recover in parallel */
+	unsigned int max_recovery; /* Max # of regions to recover in parallel */
 
 	spinlock_t region_lock;
 	atomic_t recovery_in_flight;
@@ -164,12 +164,12 @@ struct dm_region_hash *dm_region_hash_create(
 						     struct bio_list *bios),
 		void (*wakeup_workers)(void *context),
 		void (*wakeup_all_recovery_waiters)(void *context),
-		sector_t target_begin, unsigned max_recovery,
+		sector_t target_begin, unsigned int max_recovery,
 		struct dm_dirty_log *log, uint32_t region_size,
 		region_t nr_regions)
 {
 	struct dm_region_hash *rh;
-	unsigned nr_buckets, max_buckets;
+	unsigned int nr_buckets, max_buckets;
 	size_t i;
 	int ret;
 
@@ -237,7 +237,7 @@ EXPORT_SYMBOL_GPL(dm_region_hash_create);
 
 void dm_region_hash_destroy(struct dm_region_hash *rh)
 {
-	unsigned h;
+	unsigned int h;
 	struct dm_region *reg, *nreg;
 
 	BUG_ON(!list_empty(&rh->quiesced_regions));
@@ -264,9 +264,9 @@ struct dm_dirty_log *dm_rh_dirty_log(struct dm_region_hash *rh)
 }
 EXPORT_SYMBOL_GPL(dm_rh_dirty_log);
 
-static unsigned rh_hash(struct dm_region_hash *rh, region_t region)
+static unsigned int rh_hash(struct dm_region_hash *rh, region_t region)
 {
-	return (unsigned) ((region * rh->prime) >> rh->shift) & rh->mask;
+	return (unsigned int) ((region * rh->prime) >> rh->shift) & rh->mask;
 }
 
 static struct dm_region *__rh_lookup(struct dm_region_hash *rh, region_t region)
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index e4a7d66cb7cd..073fb5f1b93d 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -24,33 +24,33 @@ struct dm_rq_target_io {
 	union map_info info;
 	struct dm_stats_aux stats_aux;
 	unsigned long duration_jiffies;
-	unsigned n_sectors;
-	unsigned completed;
+	unsigned int n_sectors;
+	unsigned int completed;
 };
 
 #define DM_MQ_NR_HW_QUEUES 1
 #define DM_MQ_QUEUE_DEPTH 2048
-static unsigned dm_mq_nr_hw_queues = DM_MQ_NR_HW_QUEUES;
-static unsigned dm_mq_queue_depth = DM_MQ_QUEUE_DEPTH;
+static unsigned int dm_mq_nr_hw_queues = DM_MQ_NR_HW_QUEUES;
+static unsigned int dm_mq_queue_depth = DM_MQ_QUEUE_DEPTH;
 
 /*
  * Request-based DM's mempools' reserved IOs set by the user.
  */
 #define RESERVED_REQUEST_BASED_IOS	256
-static unsigned reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
+static unsigned int reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
 
-unsigned dm_get_reserved_rq_based_ios(void)
+unsigned int dm_get_reserved_rq_based_ios(void)
 {
 	return __dm_get_module_param(&reserved_rq_based_ios,
 				     RESERVED_REQUEST_BASED_IOS, DM_RESERVED_MAX_IOS);
 }
 
-static unsigned dm_get_blk_mq_nr_hw_queues(void)
+static unsigned int dm_get_blk_mq_nr_hw_queues(void)
 {
 	return __dm_get_module_param(&dm_mq_nr_hw_queues, 1, 32);
 }
 
-static unsigned dm_get_blk_mq_queue_depth(void)
+static unsigned int dm_get_blk_mq_queue_depth(void)
 {
 	return __dm_get_module_param(&dm_mq_queue_depth,
 				     DM_MQ_QUEUE_DEPTH, BLK_MQ_MAX_DEPTH);
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 429a8a1a34e6..8cfd4e1a8c7b 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -39,7 +39,7 @@ void dm_stop_queue(struct request_queue *q);
 
 void dm_mq_kick_requeue_list(struct mapped_device *md);
 
-unsigned dm_get_reserved_rq_based_ios(void);
+unsigned int dm_get_reserved_rq_based_ios(void);
 
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf);
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3abcc5565870..cd599c0e2454 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -304,7 +304,7 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 {
 	int r;
 	struct disk_header *dh;
-	unsigned chunk_size;
+	unsigned int chunk_size;
 	int chunk_size_supplied = 1;
 	char *chunk_err;
 
@@ -896,11 +896,11 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 	return r;
 }
 
-static unsigned persistent_status(struct dm_exception_store *store,
+static unsigned int persistent_status(struct dm_exception_store *store,
 				  status_type_t status, char *result,
-				  unsigned maxlen)
+				  unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 
 	switch (status) {
 	case STATUSTYPE_INFO:
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 147aa7d1264e..a643b087115f 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -85,11 +85,11 @@ static int transient_ctr(struct dm_exception_store *store, char *options)
 	return 0;
 }
 
-static unsigned transient_status(struct dm_exception_store *store,
+static unsigned int transient_status(struct dm_exception_store *store,
 				 status_type_t status, char *result,
-				 unsigned maxlen)
+				 unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 
 	switch (status) {
 	case STATUSTYPE_INFO:
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c50368512bee..3281a168a7d3 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -42,7 +42,7 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
 
 struct dm_exception_table {
 	uint32_t hash_mask;
-	unsigned hash_shift;
+	unsigned int hash_shift;
 	struct hlist_bl_head *table;
 };
 
@@ -107,7 +107,7 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
-	unsigned in_progress;
+	unsigned int in_progress;
 	struct wait_queue_head in_progress_wait;
 
 	struct dm_kcopyd_client *kcopyd_client;
@@ -162,7 +162,7 @@ struct dm_snapshot {
  */
 #define DEFAULT_COW_THRESHOLD 2048
 
-static unsigned cow_threshold = DEFAULT_COW_THRESHOLD;
+static unsigned int cow_threshold = DEFAULT_COW_THRESHOLD;
 module_param_named(snapshot_cow_threshold, cow_threshold, uint, 0644);
 MODULE_PARM_DESC(snapshot_cow_threshold, "Maximum number of chunks being copied on write");
 
@@ -325,7 +325,7 @@ struct origin {
 struct dm_origin {
 	struct dm_dev *dev;
 	struct dm_target *ti;
-	unsigned split_boundary;
+	unsigned int split_boundary;
 	struct list_head hash_list;
 };
 
@@ -378,7 +378,7 @@ static void exit_origin_hash(void)
 	kfree(_dm_origins);
 }
 
-static unsigned origin_hash(struct block_device *bdev)
+static unsigned int origin_hash(struct block_device *bdev)
 {
 	return bdev->bd_dev & ORIGIN_MASK;
 }
@@ -653,7 +653,7 @@ static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
 }
 
 static int dm_exception_table_init(struct dm_exception_table *et,
-				   uint32_t size, unsigned hash_shift)
+				   uint32_t size, unsigned int hash_shift)
 {
 	unsigned int i;
 
@@ -851,7 +851,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 static uint32_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
+	unsigned int chunk_size = rounddown_pow_of_two(UINT_MAX);
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)
@@ -1011,7 +1011,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 }
 
 static int origin_write_extent(struct dm_snapshot *merging_snap,
-			       sector_t sector, unsigned chunk_size);
+			       sector_t sector, unsigned int chunk_size);
 
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
@@ -1184,7 +1184,7 @@ static int parse_snapshot_features(struct dm_arg_set *as, struct dm_snapshot *s,
 				   struct dm_target *ti)
 {
 	int r;
-	unsigned argc;
+	unsigned int argc;
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
@@ -1242,7 +1242,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
 	dev_t origin_dev, cow_dev;
-	unsigned args_used, num_flush_bios = 1;
+	unsigned int args_used, num_flush_bios = 1;
 	fmode_t origin_mode = FMODE_READ;
 
 	if (argc < 4) {
@@ -2316,11 +2316,11 @@ static void snapshot_merge_resume(struct dm_target *ti)
 }
 
 static void snapshot_status(struct dm_target *ti, status_type_t type,
-			    unsigned status_flags, char *result, unsigned maxlen)
+			    unsigned int status_flags, char *result, unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct dm_snapshot *snap = ti->private;
-	unsigned num_features;
+	unsigned int num_features;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2593,7 +2593,7 @@ static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit)
  * size must be a multiple of merging_snap's chunk_size.
  */
 static int origin_write_extent(struct dm_snapshot *merging_snap,
-			       sector_t sector, unsigned size)
+			       sector_t sector, unsigned int size)
 {
 	int must_wait = 0;
 	sector_t n;
@@ -2669,7 +2669,7 @@ static void origin_dtr(struct dm_target *ti)
 static int origin_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_origin *o = ti->private;
-	unsigned available_sectors;
+	unsigned int available_sectors;
 
 	bio_set_dev(bio, o->dev->bdev);
 
@@ -2680,7 +2680,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 
 	available_sectors = o->split_boundary -
-		((unsigned)bio->bi_iter.bi_sector & (o->split_boundary - 1));
+		((unsigned int)bio->bi_iter.bi_sector & (o->split_boundary - 1));
 
 	if (bio_sectors(bio) > available_sectors)
 		dm_accept_partial_bio(bio, available_sectors);
@@ -2714,7 +2714,7 @@ static void origin_postsuspend(struct dm_target *ti)
 }
 
 static void origin_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct dm_origin *o = ti->private;
 
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index f105a71915ab..861e6f97438b 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -42,12 +42,12 @@ struct dm_stat_shared {
 struct dm_stat {
 	struct list_head list_entry;
 	int id;
-	unsigned stat_flags;
+	unsigned int stat_flags;
 	size_t n_entries;
 	sector_t start;
 	sector_t end;
 	sector_t step;
-	unsigned n_histogram_entries;
+	unsigned int n_histogram_entries;
 	unsigned long long *histogram_boundaries;
 	const char *program_id;
 	const char *aux_data;
@@ -63,7 +63,7 @@ struct dm_stat {
 
 struct dm_stats_last_position {
 	sector_t last_sector;
-	unsigned last_rw;
+	unsigned int last_rw;
 };
 
 /*
@@ -250,8 +250,8 @@ static void dm_stats_recalc_precise_timestamps(struct dm_stats *stats)
 }
 
 static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
-			   sector_t step, unsigned stat_flags,
-			   unsigned n_histogram_entries,
+			   sector_t step, unsigned int stat_flags,
+			   unsigned int n_histogram_entries,
 			   unsigned long long *histogram_boundaries,
 			   const char *program_id, const char *aux_data,
 			   void (*suspend_callback)(struct mapped_device *),
@@ -470,11 +470,11 @@ static int dm_stats_delete(struct dm_stats *stats, int id)
 }
 
 static int dm_stats_list(struct dm_stats *stats, const char *program,
-			 char *result, unsigned maxlen)
+			 char *result, unsigned int maxlen)
 {
 	struct dm_stat *s;
 	sector_t len;
-	unsigned sz = 0;
+	unsigned int sz = 0;
 
 	/*
 	 * Output format:
@@ -494,7 +494,7 @@ static int dm_stats_list(struct dm_stats *stats, const char *program,
 			if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
 				DMEMIT(" precise_timestamps");
 			if (s->n_histogram_entries) {
-				unsigned i;
+				unsigned int i;
 				DMEMIT(" histogram:");
 				for (i = 0; i < s->n_histogram_entries; i++) {
 					if (i)
@@ -518,7 +518,7 @@ static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
 	 * This is racy, but so is part_round_stats_single.
 	 */
 	unsigned long long now, difference;
-	unsigned in_flight_read, in_flight_write;
+	unsigned int in_flight_read, in_flight_write;
 
 	if (likely(!(s->stat_flags & STAT_PRECISE_TIMESTAMPS)))
 		now = jiffies;
@@ -529,8 +529,8 @@ static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
 	if (!difference)
 		return;
 
-	in_flight_read = (unsigned)atomic_read(&shared->in_flight[READ]);
-	in_flight_write = (unsigned)atomic_read(&shared->in_flight[WRITE]);
+	in_flight_read = (unsigned int)atomic_read(&shared->in_flight[READ]);
+	in_flight_write = (unsigned int)atomic_read(&shared->in_flight[WRITE]);
 	if (in_flight_read)
 		p->io_ticks[READ] += difference;
 	if (in_flight_write)
@@ -591,9 +591,9 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 			duration = stats_aux->duration_ns;
 		}
 		if (s->n_histogram_entries) {
-			unsigned lo = 0, hi = s->n_histogram_entries + 1;
+			unsigned int lo = 0, hi = s->n_histogram_entries + 1;
 			while (lo + 1 < hi) {
-				unsigned mid = (lo + hi) / 2;
+				unsigned int mid = (lo + hi) / 2;
 				if (s->histogram_boundaries[mid - 1] > duration) {
 					hi = mid;
 				} else {
@@ -651,7 +651,7 @@ static void __dm_stat_bio(struct dm_stat *s, int bi_rw,
 }
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
-			 sector_t bi_sector, unsigned bi_sectors, bool end,
+			 sector_t bi_sector, unsigned int bi_sectors, bool end,
 			 unsigned long start_time,
 			 struct dm_stats_aux *stats_aux)
 {
@@ -740,7 +740,7 @@ static void __dm_stat_init_temporary_percpu_totals(struct dm_stat_shared *shared
 		shared->tmp.io_ticks_total += READ_ONCE(p->io_ticks_total);
 		shared->tmp.time_in_queue += READ_ONCE(p->time_in_queue);
 		if (s->n_histogram_entries) {
-			unsigned i;
+			unsigned int i;
 			for (i = 0; i < s->n_histogram_entries + 1; i++)
 				shared->tmp.histogram[i] += READ_ONCE(p->histogram[i]);
 		}
@@ -774,7 +774,7 @@ static void __dm_stat_clear(struct dm_stat *s, size_t idx_start, size_t idx_end,
 		p->time_in_queue -= shared->tmp.time_in_queue;
 		local_irq_enable();
 		if (s->n_histogram_entries) {
-			unsigned i;
+			unsigned int i;
 			for (i = 0; i < s->n_histogram_entries + 1; i++) {
 				local_irq_disable();
 				p = &s->stat_percpu[smp_processor_id()][x];
@@ -811,7 +811,7 @@ static int dm_stats_clear(struct dm_stats *stats, int id)
 static unsigned long long dm_jiffies_to_msec64(struct dm_stat *s, unsigned long long j)
 {
 	unsigned long long result;
-	unsigned mult;
+	unsigned int mult;
 
 	if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
 		return j;
@@ -831,9 +831,9 @@ static unsigned long long dm_jiffies_to_msec64(struct dm_stat *s, unsigned long
 
 static int dm_stats_print(struct dm_stats *stats, int id,
 			  size_t idx_start, size_t idx_len,
-			  bool clear, char *result, unsigned maxlen)
+			  bool clear, char *result, unsigned int maxlen)
 {
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	struct dm_stat *s;
 	size_t x;
 	sector_t start, end, step;
@@ -889,7 +889,7 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[READ]),
 		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
 		if (s->n_histogram_entries) {
-			unsigned i;
+			unsigned int i;
 			for (i = 0; i < s->n_histogram_entries + 1; i++) {
 				DMEMIT("%s%llu", !i ? " " : ":", shared->tmp.histogram[i]);
 			}
@@ -938,11 +938,11 @@ static int dm_stats_set_aux(struct dm_stats *stats, int id, const char *aux_data
 	return 0;
 }
 
-static int parse_histogram(const char *h, unsigned *n_histogram_entries,
+static int parse_histogram(const char *h, unsigned int *n_histogram_entries,
 			   unsigned long long **histogram_boundaries)
 {
 	const char *q;
-	unsigned n;
+	unsigned int n;
 	unsigned long long last;
 
 	*n_histogram_entries = 1;
@@ -977,23 +977,23 @@ static int parse_histogram(const char *h, unsigned *n_histogram_entries,
 }
 
 static int message_stats_create(struct mapped_device *md,
-				unsigned argc, char **argv,
-				char *result, unsigned maxlen)
+				unsigned int argc, char **argv,
+				char *result, unsigned int maxlen)
 {
 	int r;
 	int id;
 	char dummy;
 	unsigned long long start, end, len, step;
-	unsigned divisor;
+	unsigned int divisor;
 	const char *program_id, *aux_data;
-	unsigned stat_flags = 0;
+	unsigned int stat_flags = 0;
 
-	unsigned n_histogram_entries = 0;
+	unsigned int n_histogram_entries = 0;
 	unsigned long long *histogram_boundaries = NULL;
 
 	struct dm_arg_set as, as_backup;
 	const char *a;
-	unsigned feature_args;
+	unsigned int feature_args;
 
 	/*
 	 * Input format:
@@ -1102,7 +1102,7 @@ static int message_stats_create(struct mapped_device *md,
 }
 
 static int message_stats_delete(struct mapped_device *md,
-				unsigned argc, char **argv)
+				unsigned int argc, char **argv)
 {
 	int id;
 	char dummy;
@@ -1117,7 +1117,7 @@ static int message_stats_delete(struct mapped_device *md,
 }
 
 static int message_stats_clear(struct mapped_device *md,
-			       unsigned argc, char **argv)
+			       unsigned int argc, char **argv)
 {
 	int id;
 	char dummy;
@@ -1132,8 +1132,8 @@ static int message_stats_clear(struct mapped_device *md,
 }
 
 static int message_stats_list(struct mapped_device *md,
-			      unsigned argc, char **argv,
-			      char *result, unsigned maxlen)
+			      unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen)
 {
 	int r;
 	const char *program = NULL;
@@ -1155,8 +1155,8 @@ static int message_stats_list(struct mapped_device *md,
 }
 
 static int message_stats_print(struct mapped_device *md,
-			       unsigned argc, char **argv, bool clear,
-			       char *result, unsigned maxlen)
+			       unsigned int argc, char **argv, bool clear,
+			       char *result, unsigned int maxlen)
 {
 	int id;
 	char dummy;
@@ -1182,7 +1182,7 @@ static int message_stats_print(struct mapped_device *md,
 }
 
 static int message_stats_set_aux(struct mapped_device *md,
-				 unsigned argc, char **argv)
+				 unsigned int argc, char **argv)
 {
 	int id;
 	char dummy;
@@ -1196,8 +1196,8 @@ static int message_stats_set_aux(struct mapped_device *md,
 	return dm_stats_set_aux(dm_get_stats(md), id, argv[2]);
 }
 
-int dm_stats_message(struct mapped_device *md, unsigned argc, char **argv,
-		     char *result, unsigned maxlen)
+int dm_stats_message(struct mapped_device *md, unsigned int argc, char **argv,
+		     char *result, unsigned int maxlen)
 {
 	int r;
 
diff --git a/drivers/md/dm-stats.h b/drivers/md/dm-stats.h
index 09c81a1ec057..0bc152c8e4f3 100644
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -26,11 +26,11 @@ void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
 
-int dm_stats_message(struct mapped_device *md, unsigned argc, char **argv,
-		     char *result, unsigned maxlen);
+int dm_stats_message(struct mapped_device *md, unsigned int argc, char **argv,
+		     char *result, unsigned int maxlen);
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
-			 sector_t bi_sector, unsigned bi_sectors, bool end,
+			 sector_t bi_sector, unsigned int bi_sectors, bool end,
 			 unsigned long start_time,
 			 struct dm_stats_aux *aux);
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index c7721878773b..caa1565e6143 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -274,7 +274,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 {
 	struct stripe_c *sc = ti->private;
 	uint32_t stripe;
-	unsigned target_bio_nr;
+	unsigned int target_bio_nr;
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
 		target_bio_nr = dm_bio_get_target_bio_nr(bio);
@@ -360,7 +360,7 @@ static size_t stripe_dax_recovery_write(struct dm_target *ti, pgoff_t pgoff,
  */
 
 static void stripe_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
 	unsigned int sz = 0;
@@ -407,7 +407,7 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 static int stripe_end_io(struct dm_target *ti, struct bio *bio,
 		blk_status_t *error)
 {
-	unsigned i;
+	unsigned int i;
 	char major_minor[16];
 	struct stripe_c *sc = ti->private;
 
@@ -445,7 +445,7 @@ static int stripe_iterate_devices(struct dm_target *ti,
 {
 	struct stripe_c *sc = ti->private;
 	int ret = 0;
-	unsigned i = 0;
+	unsigned int i = 0;
 
 	do {
 		ret = fn(ti, sc->stripe[i].dev,
@@ -460,7 +460,7 @@ static void stripe_io_hints(struct dm_target *ti,
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned chunk_size = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
 	blk_limits_io_min(limits, chunk_size);
 	blk_limits_io_opt(limits, chunk_size * sc->stripes);
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 497a685137d0..75a4c4b20583 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -39,9 +39,9 @@ struct switch_path {
 struct switch_ctx {
 	struct dm_target *ti;
 
-	unsigned nr_paths;		/* Number of paths in path_list. */
+	unsigned int nr_paths;		/* Number of paths in path_list. */
 
-	unsigned region_size;		/* Region size in 512-byte sectors */
+	unsigned int region_size;		/* Region size in 512-byte sectors */
 	unsigned long nr_regions;	/* Number of regions making up the device */
 	signed char region_size_bits;	/* log2 of region_size or -1 */
 
@@ -57,8 +57,8 @@ struct switch_ctx {
 	struct switch_path path_list[];
 };
 
-static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned nr_paths,
-					   unsigned region_size)
+static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned int nr_paths,
+					   unsigned int region_size)
 {
 	struct switch_ctx *sctx;
 
@@ -74,7 +74,7 @@ static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned nr_pat
 	return sctx;
 }
 
-static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
+static int alloc_region_table(struct dm_target *ti, unsigned int nr_paths)
 {
 	struct switch_ctx *sctx = ti->private;
 	sector_t nr_regions = ti->len;
@@ -125,7 +125,7 @@ static int alloc_region_table(struct dm_target *ti, unsigned nr_paths)
 }
 
 static void switch_get_position(struct switch_ctx *sctx, unsigned long region_nr,
-				unsigned long *region_index, unsigned *bit)
+				unsigned long *region_index, unsigned int *bit)
 {
 	if (sctx->region_entries_per_slot_bits >= 0) {
 		*region_index = region_nr >> sctx->region_entries_per_slot_bits;
@@ -138,10 +138,10 @@ static void switch_get_position(struct switch_ctx *sctx, unsigned long region_nr
 	*bit *= sctx->region_table_entry_bits;
 }
 
-static unsigned switch_region_table_read(struct switch_ctx *sctx, unsigned long region_nr)
+static unsigned int switch_region_table_read(struct switch_ctx *sctx, unsigned long region_nr)
 {
 	unsigned long region_index;
-	unsigned bit;
+	unsigned int bit;
 
 	switch_get_position(sctx, region_nr, &region_index, &bit);
 
@@ -152,9 +152,9 @@ static unsigned switch_region_table_read(struct switch_ctx *sctx, unsigned long
 /*
  * Find which path to use at given offset.
  */
-static unsigned switch_get_path_nr(struct switch_ctx *sctx, sector_t offset)
+static unsigned int switch_get_path_nr(struct switch_ctx *sctx, sector_t offset)
 {
-	unsigned path_nr;
+	unsigned int path_nr;
 	sector_t p;
 
 	p = offset;
@@ -173,10 +173,10 @@ static unsigned switch_get_path_nr(struct switch_ctx *sctx, sector_t offset)
 }
 
 static void switch_region_table_write(struct switch_ctx *sctx, unsigned long region_nr,
-				      unsigned value)
+				      unsigned int value)
 {
 	unsigned long region_index;
-	unsigned bit;
+	unsigned int bit;
 	region_table_slot_t pte;
 
 	switch_get_position(sctx, region_nr, &region_index, &bit);
@@ -192,7 +192,7 @@ static void switch_region_table_write(struct switch_ctx *sctx, unsigned long reg
  */
 static void initialise_region_table(struct switch_ctx *sctx)
 {
-	unsigned path_nr = 0;
+	unsigned int path_nr = 0;
 	unsigned long region_nr;
 
 	for (region_nr = 0; region_nr < sctx->nr_regions; region_nr++) {
@@ -250,7 +250,7 @@ static void switch_dtr(struct dm_target *ti)
  * Optional args are to allow for future extension: currently this
  * parameter must be 0.
  */
-static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int switch_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	static const struct dm_arg _args[] = {
 		{1, (KMALLOC_MAX_SIZE - sizeof(struct switch_ctx)) / sizeof(struct switch_path), "Invalid number of paths"},
@@ -260,7 +260,7 @@ static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	struct switch_ctx *sctx;
 	struct dm_arg_set as;
-	unsigned nr_paths, region_size, nr_optional_args;
+	unsigned int nr_paths, region_size, nr_optional_args;
 	int r;
 
 	as.argc = argc;
@@ -321,7 +321,7 @@ static int switch_map(struct dm_target *ti, struct bio *bio)
 {
 	struct switch_ctx *sctx = ti->private;
 	sector_t offset = dm_target_offset(ti, bio->bi_iter.bi_sector);
-	unsigned path_nr = switch_get_path_nr(sctx, offset);
+	unsigned int path_nr = switch_get_path_nr(sctx, offset);
 
 	bio_set_dev(bio, sctx->path_list[path_nr].dmdev->bdev);
 	bio->bi_iter.bi_sector = sctx->path_list[path_nr].start + offset;
@@ -372,9 +372,9 @@ static __always_inline unsigned long parse_hex(const char **string)
 }
 
 static int process_set_region_mappings(struct switch_ctx *sctx,
-				       unsigned argc, char **argv)
+				       unsigned int argc, char **argv)
 {
-	unsigned i;
+	unsigned int i;
 	unsigned long region_index = 0;
 
 	for (i = 1; i < argc; i++) {
@@ -467,8 +467,8 @@ static int process_set_region_mappings(struct switch_ctx *sctx,
  *
  * Only set_region_mappings is supported.
  */
-static int switch_message(struct dm_target *ti, unsigned argc, char **argv,
-			  char *result, unsigned maxlen)
+static int switch_message(struct dm_target *ti, unsigned int argc, char **argv,
+			  char *result, unsigned int maxlen)
 {
 	static DEFINE_MUTEX(message_mutex);
 
@@ -488,10 +488,10 @@ static int switch_message(struct dm_target *ti, unsigned argc, char **argv,
 }
 
 static void switch_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct switch_ctx *sctx = ti->private;
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	int path_nr;
 
 	switch (type) {
@@ -520,7 +520,7 @@ static void switch_status(struct dm_target *ti, status_type_t type,
 static int switch_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
 {
 	struct switch_ctx *sctx = ti->private;
-	unsigned path_nr;
+	unsigned int path_nr;
 
 	path_nr = switch_get_path_nr(sctx, 0);
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index c458f03129ca..af0a214825d6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -127,7 +127,7 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 }
 
 int dm_table_create(struct dm_table **result, fmode_t mode,
-		    unsigned num_targets, struct mapped_device *md)
+		    unsigned int num_targets, struct mapped_device *md)
 {
 	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
 
@@ -473,10 +473,10 @@ static int adjoin(struct dm_table *t, struct dm_target *ti)
  * On the other hand, dm-switch needs to process bulk data using messages and
  * excessive use of GFP_NOIO could cause trouble.
  */
-static char **realloc_argv(unsigned *size, char **old_argv)
+static char **realloc_argv(unsigned int *size, char **old_argv)
 {
 	char **argv;
-	unsigned new_size;
+	unsigned int new_size;
 	gfp_t gfp;
 
 	if (*size) {
@@ -502,7 +502,7 @@ static char **realloc_argv(unsigned *size, char **old_argv)
 int dm_split_args(int *argc, char ***argvp, char *input)
 {
 	char *start, *end = input, *out, **argv = NULL;
-	unsigned array_size = 0;
+	unsigned int array_size = 0;
 
 	*argc = 0;
 
@@ -735,9 +735,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 /*
  * Target argument parsing helpers.
  */
-static int validate_next_arg(const struct dm_arg *arg,
-			     struct dm_arg_set *arg_set,
-			     unsigned *value, char **error, unsigned grouped)
+static int validate_next_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
+			     unsigned int *value, char **error, unsigned int grouped)
 {
 	const char *arg_str = dm_shift_arg(arg_set);
 	char dummy;
@@ -755,14 +754,14 @@ static int validate_next_arg(const struct dm_arg *arg,
 }
 
 int dm_read_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
-		unsigned *value, char **error)
+		unsigned int *value, char **error)
 {
 	return validate_next_arg(arg, arg_set, value, error, 0);
 }
 EXPORT_SYMBOL(dm_read_arg);
 
 int dm_read_arg_group(const struct dm_arg *arg, struct dm_arg_set *arg_set,
-		      unsigned *value, char **error)
+		      unsigned int *value, char **error)
 {
 	return validate_next_arg(arg, arg_set, value, error, 1);
 }
@@ -783,7 +782,7 @@ const char *dm_shift_arg(struct dm_arg_set *as)
 }
 EXPORT_SYMBOL(dm_shift_arg);
 
-void dm_consume_args(struct dm_arg_set *as, unsigned num_args)
+void dm_consume_args(struct dm_arg_set *as, unsigned int num_args)
 {
 	BUG_ON(as->argc < num_args);
 	as->argc -= num_args;
@@ -859,7 +858,7 @@ static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
 
 static int dm_table_determine_type(struct dm_table *t)
 {
-	unsigned bio_based = 0, request_based = 0, hybrid = 0;
+	unsigned int bio_based = 0, request_based = 0, hybrid = 0;
 	struct dm_target *ti;
 	struct list_head *devices = dm_table_get_devices(t);
 	enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
@@ -1538,7 +1537,7 @@ static bool dm_table_any_dev_attr(struct dm_table *t,
 static int count_device(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
-	unsigned *num_devices = data;
+	unsigned int *num_devices = data;
 
 	(*num_devices)++;
 
@@ -1568,7 +1567,7 @@ bool dm_table_has_no_data_devices(struct dm_table *t)
 {
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
-		unsigned num_devices = 0;
+		unsigned int num_devices = 0;
 
 		if (!ti->type->iterate_devices)
 			return false;
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index bc43b5919a20..92e3bfa369af 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -319,12 +319,12 @@ static void unpack_block_time(uint64_t v, dm_block_t *b, uint32_t *t)
  */
 typedef int (*run_fn)(struct dm_space_map *, dm_block_t, dm_block_t);
 
-static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned count, run_fn fn)
+static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned int count, run_fn fn)
 {
 	uint64_t b, begin, end;
 	uint32_t t;
 	bool in_run = false;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++, value_le++) {
 		/* We know value_le is 8 byte aligned */
@@ -349,13 +349,13 @@ static void with_runs(struct dm_space_map *sm, const __le64 *value_le, unsigned
 		fn(sm, begin, end);
 }
 
-static void data_block_inc(void *context, const void *value_le, unsigned count)
+static void data_block_inc(void *context, const void *value_le, unsigned int count)
 {
 	with_runs((struct dm_space_map *) context,
 		  (const __le64 *) value_le, count, dm_sm_inc_blocks);
 }
 
-static void data_block_dec(void *context, const void *value_le, unsigned count)
+static void data_block_dec(void *context, const void *value_le, unsigned int count)
 {
 	with_runs((struct dm_space_map *) context,
 		  (const __le64 *) value_le, count, dm_sm_dec_blocks);
@@ -375,21 +375,21 @@ static int data_block_equal(void *context, const void *value1_le, const void *va
 	return b1 == b2;
 }
 
-static void subtree_inc(void *context, const void *value, unsigned count)
+static void subtree_inc(void *context, const void *value, unsigned int count)
 {
 	struct dm_btree_info *info = context;
 	const __le64 *root_le = value;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++, root_le++)
 		dm_tm_inc(info->tm, le64_to_cpu(*root_le));
 }
 
-static void subtree_dec(void *context, const void *value, unsigned count)
+static void subtree_dec(void *context, const void *value, unsigned int count)
 {
 	struct dm_btree_info *info = context;
 	const __le64 *root_le = value;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++, root_le++)
 		if (dm_btree_del(info, le64_to_cpu(*root_le)))
@@ -449,10 +449,10 @@ static int superblock_lock(struct dm_pool_metadata *pmd,
 static int __superblock_all_zeroes(struct dm_block_manager *bm, int *result)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct dm_block *b;
 	__le64 *data_le, zero = cpu_to_le64(0);
-	unsigned block_size = dm_bm_block_size(bm) / sizeof(__le64);
+	unsigned int block_size = dm_bm_block_size(bm) / sizeof(__le64);
 
 	/*
 	 * We can't use a validator here - it may be all zeroes.
@@ -972,7 +972,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 {
 	int r;
-	unsigned open_devices = 0;
+	unsigned int open_devices = 0;
 	struct dm_thin_device *td, *tmp;
 
 	down_read(&pmd->root_lock);
@@ -1680,7 +1680,7 @@ int dm_thin_insert_block(struct dm_thin_device *td, dm_block_t block,
 static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_t end)
 {
 	int r;
-	unsigned count, total_count = 0;
+	unsigned int count, total_count = 0;
 	struct dm_pool_metadata *pmd = td->pmd;
 	dm_block_t keys[1] = { td->id };
 	__le64 value;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7da4ce41cb78..f4de72a7d783 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -33,7 +33,7 @@
 #define COMMIT_PERIOD HZ
 #define NO_SPACE_TIMEOUT_SECS 60
 
-static unsigned no_space_timeout_secs = NO_SPACE_TIMEOUT_SECS;
+static unsigned int no_space_timeout_secs = NO_SPACE_TIMEOUT_SECS;
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
 		"A percentage of time allocated for copy on write");
@@ -255,7 +255,7 @@ struct pool {
 	struct delayed_work no_space_timeout;
 
 	unsigned long last_commit_jiffies;
-	unsigned ref_count;
+	unsigned int ref_count;
 
 	spinlock_t lock;
 	struct bio_list deferred_flush_bios;
@@ -2160,7 +2160,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 	struct bio *bio;
 	struct bio_list bios;
 	struct blk_plug plug;
-	unsigned count = 0;
+	unsigned int count = 0;
 
 	if (tc->requeue_mode) {
 		error_thin_bio_list(tc, &tc->deferred_bio_list,
@@ -2229,9 +2229,9 @@ static int cmp_cells(const void *lhs, const void *rhs)
 	return 0;
 }
 
-static unsigned sort_cells(struct pool *pool, struct list_head *cells)
+static unsigned int sort_cells(struct pool *pool, struct list_head *cells)
 {
-	unsigned count = 0;
+	unsigned int count = 0;
 	struct dm_bio_prison_cell *cell, *tmp;
 
 	list_for_each_entry_safe(cell, tmp, cells, user_list) {
@@ -2252,7 +2252,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 	struct pool *pool = tc->pool;
 	struct list_head cells;
 	struct dm_bio_prison_cell *cell;
-	unsigned i, j, count;
+	unsigned int i, j, count;
 
 	INIT_LIST_HEAD(&cells);
 
@@ -3114,7 +3114,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 			       struct dm_target *ti)
 {
 	int r;
-	unsigned argc;
+	unsigned int argc;
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
@@ -3251,7 +3251,7 @@ static dm_block_t calc_metadata_threshold(struct pool_c *pt)
  *	     read_only: Don't allow any changes to be made to the pool metadata.
  *	     error_if_no_space: error IOs, instead of queueing, if no space.
  */
-static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r, pool_created = 0;
 	struct pool_c *pt;
@@ -3646,7 +3646,7 @@ static void pool_postsuspend(struct dm_target *ti)
 	(void) commit(pool);
 }
 
-static int check_arg_count(unsigned argc, unsigned args_required)
+static int check_arg_count(unsigned int argc, unsigned int args_required)
 {
 	if (argc != args_required) {
 		DMWARN("Message received with %u arguments instead of %u.",
@@ -3669,7 +3669,7 @@ static int read_dev_id(char *arg, dm_thin_id *dev_id, int warning)
 	return -EINVAL;
 }
 
-static int process_create_thin_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_create_thin_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	dm_thin_id dev_id;
 	int r;
@@ -3692,7 +3692,7 @@ static int process_create_thin_mesg(unsigned argc, char **argv, struct pool *poo
 	return 0;
 }
 
-static int process_create_snap_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_create_snap_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	dm_thin_id dev_id;
 	dm_thin_id origin_dev_id;
@@ -3720,7 +3720,7 @@ static int process_create_snap_mesg(unsigned argc, char **argv, struct pool *poo
 	return 0;
 }
 
-static int process_delete_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_delete_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	dm_thin_id dev_id;
 	int r;
@@ -3740,7 +3740,7 @@ static int process_delete_mesg(unsigned argc, char **argv, struct pool *pool)
 	return r;
 }
 
-static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_set_transaction_id_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	dm_thin_id old_id, new_id;
 	int r;
@@ -3769,7 +3769,7 @@ static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct po
 	return 0;
 }
 
-static int process_reserve_metadata_snap_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_reserve_metadata_snap_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	int r;
 
@@ -3786,7 +3786,7 @@ static int process_reserve_metadata_snap_mesg(unsigned argc, char **argv, struct
 	return r;
 }
 
-static int process_release_metadata_snap_mesg(unsigned argc, char **argv, struct pool *pool)
+static int process_release_metadata_snap_mesg(unsigned int argc, char **argv, struct pool *pool)
 {
 	int r;
 
@@ -3810,8 +3810,8 @@ static int process_release_metadata_snap_mesg(unsigned argc, char **argv, struct
  *   reserve_metadata_snap
  *   release_metadata_snap
  */
-static int pool_message(struct dm_target *ti, unsigned argc, char **argv,
-			char *result, unsigned maxlen)
+static int pool_message(struct dm_target *ti, unsigned int argc, char **argv,
+			char *result, unsigned int maxlen)
 {
 	int r = -EINVAL;
 	struct pool_c *pt = ti->private;
@@ -3851,9 +3851,9 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv,
 }
 
 static void emit_flags(struct pool_features *pf, char *result,
-		       unsigned sz, unsigned maxlen)
+		       unsigned int sz, unsigned int maxlen)
 {
-	unsigned count = !pf->zero_new_blocks + !pf->discard_enabled +
+	unsigned int count = !pf->zero_new_blocks + !pf->discard_enabled +
 		!pf->discard_passdown + (pf->mode == PM_READ_ONLY) +
 		pf->error_if_no_space;
 	DMEMIT("%u ", count);
@@ -3881,10 +3881,10 @@ static void emit_flags(struct pool_features *pf, char *result,
  *    <pool mode> <discard config> <no space config> <needs_check>
  */
 static void pool_status(struct dm_target *ti, status_type_t type,
-			unsigned status_flags, char *result, unsigned maxlen)
+			unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int r;
-	unsigned sz = 0;
+	unsigned int sz = 0;
 	uint64_t transaction_id;
 	dm_block_t nr_free_blocks_data;
 	dm_block_t nr_free_blocks_metadata;
@@ -4146,7 +4146,7 @@ static void thin_dtr(struct dm_target *ti)
  * If the pool device has discards disabled, they get disabled for the thin
  * device as well.
  */
-static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
 	struct thin_c *tc;
@@ -4368,7 +4368,7 @@ static int thin_preresume(struct dm_target *ti)
  * <nr mapped sectors> <highest mapped sector>
  */
 static void thin_status(struct dm_target *ti, status_type_t type,
-			unsigned status_flags, char *result, unsigned maxlen)
+			unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int r;
 	ssize_t sz = 0;
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 8671267200d8..a02b3f6ea47a 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -60,7 +60,7 @@ static struct dm_uevent *dm_build_path_uevent(struct mapped_device *md,
 					      enum kobject_action action,
 					      const char *dm_action,
 					      const char *path,
-					      unsigned nr_valid_paths)
+					      unsigned int nr_valid_paths)
 {
 	struct dm_uevent *event;
 
@@ -168,7 +168,7 @@ EXPORT_SYMBOL_GPL(dm_send_uevents);
  *
  */
 void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
-		   const char *path, unsigned nr_valid_paths)
+		   const char *path, unsigned int nr_valid_paths)
 {
 	struct mapped_device *md = dm_table_get_md(ti->table);
 	struct dm_uevent *event;
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index d30d226f2a18..2c9ba561fd8e 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -20,7 +20,7 @@ extern void dm_uevent_exit(void);
 extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
 extern void dm_path_uevent(enum dm_uevent_type event_type,
 			   struct dm_target *ti, const char *path,
-			   unsigned nr_valid_paths);
+			   unsigned int nr_valid_paths);
 
 #else
 
@@ -37,7 +37,7 @@ static inline void dm_send_uevents(struct list_head *events,
 }
 static inline void dm_path_uevent(enum dm_uevent_type event_type,
 				  struct dm_target *ti, const char *path,
-				  unsigned nr_valid_paths)
+				  unsigned int nr_valid_paths)
 {
 }
 
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 23cffce56403..962fc32c947c 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -59,14 +59,14 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
  * to the data block. Caller is responsible for releasing buf.
  */
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned *offset, struct dm_buffer **buf)
+			   unsigned int *offset, struct dm_buffer **buf)
 {
 	u64 position, block, rem;
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
 	block = div64_u64_rem(position, v->fec->io_size, &rem);
-	*offset = (unsigned)rem;
+	*offset = (unsigned int)rem;
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
 	if (IS_ERR(res)) {
@@ -102,7 +102,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
  */
 static inline u8 *fec_buffer_rs_block(struct dm_verity *v,
 				      struct dm_verity_fec_io *fio,
-				      unsigned i, unsigned j)
+				      unsigned int i, unsigned int j)
 {
 	return &fio->bufs[i][j * v->fec->rsn];
 }
@@ -111,7 +111,7 @@ static inline u8 *fec_buffer_rs_block(struct dm_verity *v,
  * Return an index to the current RS block when called inside
  * fec_for_each_buffer_rs_block.
  */
-static inline unsigned fec_buffer_rs_index(unsigned i, unsigned j)
+static inline unsigned int fec_buffer_rs_index(unsigned int i, unsigned int j)
 {
 	return (i << DM_VERITY_FEC_BUF_RS_BITS) + j;
 }
@@ -121,12 +121,12 @@ static inline unsigned fec_buffer_rs_index(unsigned i, unsigned j)
  * starting from block_offset.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
-			   u64 rsb, int byte_index, unsigned block_offset,
+			   u64 rsb, int byte_index, unsigned int block_offset,
 			   int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned n, i, offset;
+	unsigned int n, i, offset;
 	u8 *par, *block;
 
 	par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -197,7 +197,7 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			 u64 rsb, u64 target, unsigned block_offset,
+			 u64 rsb, u64 target, unsigned int block_offset,
 			 int *neras)
 {
 	bool is_zero;
@@ -208,7 +208,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	u64 block, ileaved;
 	u8 *bbuf, *rs_block;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
-	unsigned n, k;
+	unsigned int n, k;
 
 	if (neras)
 		*neras = 0;
@@ -304,7 +304,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
  */
 static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 {
-	unsigned n;
+	unsigned int n;
 
 	if (!fio->rs)
 		fio->rs = mempool_alloc(&v->fec->rs_pool, GFP_NOIO);
@@ -344,7 +344,7 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
  */
 static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 {
-	unsigned n;
+	unsigned int n;
 
 	fec_for_each_buffer(fio, n)
 		memset(fio->bufs[n], 0, v->fec->rsn << DM_VERITY_FEC_BUF_RS_BITS);
@@ -362,7 +362,7 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  bool use_erasures)
 {
 	int r, neras = 0;
-	unsigned pos;
+	unsigned int pos;
 
 	r = fec_alloc_bufs(v, fio);
 	if (unlikely(r < 0))
@@ -484,7 +484,7 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
  */
 void verity_fec_finish_io(struct dm_verity_io *io)
 {
-	unsigned n;
+	unsigned int n;
 	struct dm_verity_fec *f = io->v->fec;
 	struct dm_verity_fec_io *fio = fec_io(io);
 
@@ -522,8 +522,8 @@ void verity_fec_init_io(struct dm_verity_io *io)
 /*
  * Append feature arguments and values to the status table.
  */
-unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
-				 char *result, unsigned maxlen)
+unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
+				 char *result, unsigned int maxlen)
 {
 	if (!verity_fec_is_enabled(v))
 		return sz;
@@ -589,7 +589,7 @@ bool verity_is_fec_opt_arg(const char *arg_name)
 }
 
 int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
-			      unsigned *argc, const char *arg_name)
+			      unsigned int *argc, const char *arg_name)
 {
 	int r;
 	struct dm_target *ti = v->ti;
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 3c46c8d61883..8454070d2824 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -55,10 +55,10 @@ struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
 	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
-	unsigned nbufs;		/* number of buffers allocated */
+	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
 	size_t output_pos;
-	unsigned level;		/* recursion level */
+	unsigned int level;		/* recursion level */
 };
 
 #ifdef CONFIG_DM_VERITY_FEC
@@ -72,15 +72,15 @@ extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 			     enum verity_block_type type, sector_t block,
 			     u8 *dest, struct bvec_iter *iter);
 
-extern unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
-					char *result, unsigned maxlen);
+extern unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
+					char *result, unsigned int maxlen);
 
 extern void verity_fec_finish_io(struct dm_verity_io *io);
 extern void verity_fec_init_io(struct dm_verity_io *io);
 
 extern bool verity_is_fec_opt_arg(const char *arg_name);
 extern int verity_fec_parse_opt_args(struct dm_arg_set *as,
-				     struct dm_verity *v, unsigned *argc,
+				     struct dm_verity *v, unsigned int *argc,
 				     const char *arg_name);
 
 extern void verity_fec_dtr(struct dm_verity *v);
@@ -106,9 +106,9 @@ static inline int verity_fec_decode(struct dm_verity *v,
 	return -EOPNOTSUPP;
 }
 
-static inline unsigned verity_fec_status_table(struct dm_verity *v,
-					       unsigned sz, char *result,
-					       unsigned maxlen)
+static inline unsigned int verity_fec_status_table(struct dm_verity *v,
+					       unsigned int sz, char *result,
+					       unsigned int maxlen)
 {
 	return sz;
 }
@@ -128,7 +128,7 @@ static inline bool verity_is_fec_opt_arg(const char *arg_name)
 
 static inline int verity_fec_parse_opt_args(struct dm_arg_set *as,
 					    struct dm_verity *v,
-					    unsigned *argc,
+					    unsigned int *argc,
 					    const char *arg_name)
 {
 	return -EINVAL;
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4c52b056ecf0..c9d937053910 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -41,7 +41,7 @@
 #define DM_VERITY_OPTS_MAX		(4 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
-static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
+static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
 
@@ -51,7 +51,7 @@ struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
 	sector_t block;
-	unsigned n_blocks;
+	unsigned int n_blocks;
 };
 
 /*
@@ -196,10 +196,10 @@ int verity_hash(struct dm_verity *v, struct ahash_request *req,
 }
 
 static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
-				 sector_t *hash_block, unsigned *offset)
+				 sector_t *hash_block, unsigned int *offset)
 {
 	sector_t position = verity_position_at_level(v, block, level);
-	unsigned idx;
+	unsigned int idx;
 
 	*hash_block = v->hash_level_block[level] + (position >> v->hash_per_block_bits);
 
@@ -287,7 +287,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *data;
 	int r;
 	sector_t hash_block;
-	unsigned offset;
+	unsigned int offset;
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
@@ -445,13 +445,13 @@ int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 				       struct dm_verity_io *io, u8 *data,
 				       size_t len))
 {
-	unsigned todo = 1 << v->data_dev_block_bits;
+	unsigned int todo = 1 << v->data_dev_block_bits;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	do {
 		int r;
 		u8 *page;
-		unsigned len;
+		unsigned int len;
 		struct bio_vec bv = bio_iter_iovec(bio, *iter);
 
 		page = bvec_kmap_local(&bv);
@@ -688,7 +688,7 @@ static void verity_prefetch_io(struct work_struct *work)
 		verity_hash_at_level(v, pw->block, i, &hash_block_start, NULL);
 		verity_hash_at_level(v, pw->block + pw->n_blocks - 1, i, &hash_block_end, NULL);
 		if (!i) {
-			unsigned cluster = READ_ONCE(dm_verity_prefetch_cluster);
+			unsigned int cluster = READ_ONCE(dm_verity_prefetch_cluster);
 
 			cluster >>= v->data_dev_block_bits;
 			if (unlikely(!cluster))
@@ -753,7 +753,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	bio_set_dev(bio, v->data_dev->bdev);
 	bio->bi_iter.bi_sector = verity_map_sector(v, bio->bi_iter.bi_sector);
 
-	if (((unsigned)bio->bi_iter.bi_sector | bio_sectors(bio)) &
+	if (((unsigned int)bio->bi_iter.bi_sector | bio_sectors(bio)) &
 	    ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
 		DMERR_LIMIT("unaligned io");
 		return DM_MAPIO_KILL;
@@ -789,12 +789,12 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
  * Status: V (valid) or C (corruption found)
  */
 static void verity_status(struct dm_target *ti, status_type_t type,
-			  unsigned status_flags, char *result, unsigned maxlen)
+			  unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct dm_verity *v = ti->private;
-	unsigned args = 0;
-	unsigned sz = 0;
-	unsigned x;
+	unsigned int args = 0;
+	unsigned int sz = 0;
+	unsigned int x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1054,7 +1054,7 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				 bool only_modifier_opts)
 {
 	int r = 0;
-	unsigned argc;
+	unsigned int argc;
 	struct dm_target *ti = v->ti;
 	const char *arg_name;
 
@@ -1156,7 +1156,7 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
  *	<digest>
  *	<salt>		Hex string or "-" if no salt.
  */
-static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_verity *v;
 	struct dm_verity_sig_opts verify_args = {0};
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 98f306ec6a33..2f555b420367 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -42,7 +42,7 @@ struct dm_verity {
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
 	u8 *zero_digest;	/* digest for a zero block */
-	unsigned salt_size;
+	unsigned int salt_size;
 	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
 	sector_t data_blocks;	/* the number of data blocks */
@@ -54,10 +54,10 @@ struct dm_verity {
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
-	unsigned digest_size;	/* digest size for the current hash algorithm */
+	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
-	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
+	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 
@@ -77,7 +77,7 @@ struct dm_verity_io {
 	bio_end_io_t *orig_bi_end_io;
 
 	sector_t block;
-	unsigned n_blocks;
+	unsigned int n_blocks;
 	bool in_tasklet;
 
 	struct bvec_iter iter;
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 96a003eb7323..431c84595ddb 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -128,9 +128,9 @@ struct dm_writecache {
 	unsigned long max_age;
 	unsigned long pause;
 
-	unsigned uncommitted_blocks;
-	unsigned autocommit_blocks;
-	unsigned max_writeback_jobs;
+	unsigned int uncommitted_blocks;
+	unsigned int autocommit_blocks;
+	unsigned int max_writeback_jobs;
 
 	int error;
 
@@ -155,7 +155,7 @@ struct dm_writecache {
 	sector_t data_device_sectors;
 	void *block_start;
 	struct wc_entry *entries;
-	unsigned block_size;
+	unsigned int block_size;
 	unsigned char block_size_bits;
 
 	bool pmem_mode:1;
@@ -178,13 +178,13 @@ struct dm_writecache {
 	bool metadata_only:1;
 	bool pause_set:1;
 
-	unsigned high_wm_percent_value;
-	unsigned low_wm_percent_value;
-	unsigned autocommit_time_value;
-	unsigned max_age_value;
-	unsigned pause_value;
+	unsigned int high_wm_percent_value;
+	unsigned int low_wm_percent_value;
+	unsigned int autocommit_time_value;
+	unsigned int max_age_value;
+	unsigned int pause_value;
 
-	unsigned writeback_all;
+	unsigned int writeback_all;
 	struct workqueue_struct *writeback_wq;
 	struct work_struct writeback_work;
 	struct work_struct flush_work;
@@ -202,7 +202,7 @@ struct dm_writecache {
 
 	struct dm_kcopyd_client *dm_kcopyd;
 	unsigned long *dirty_bitmap;
-	unsigned dirty_bitmap_size;
+	unsigned int dirty_bitmap_size;
 
 	struct bio_set bio_set;
 	mempool_t copy_pool;
@@ -227,7 +227,7 @@ struct writeback_struct {
 	struct list_head endio_entry;
 	struct dm_writecache *wc;
 	struct wc_entry **wc_list;
-	unsigned wc_list_n;
+	unsigned int wc_list_n;
 	struct wc_entry *wc_list_inline[WB_LIST_INLINE];
 	struct bio bio;
 };
@@ -236,7 +236,7 @@ struct copy_struct {
 	struct list_head endio_entry;
 	struct dm_writecache *wc;
 	struct wc_entry *e;
-	unsigned n_entries;
+	unsigned int n_entries;
 	int error;
 };
 
@@ -369,7 +369,7 @@ static struct page *persistent_memory_page(void *addr)
 		return virt_to_page(addr);
 }
 
-static unsigned persistent_memory_page_offset(void *addr)
+static unsigned int persistent_memory_page_offset(void *addr)
 {
 	return (unsigned long)addr & (PAGE_SIZE - 1);
 }
@@ -502,11 +502,11 @@ static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 		COMPLETION_INITIALIZER_ONSTACK(endio.c),
 		ATOMIC_INIT(1),
 	};
-	unsigned bitmap_bits = wc->dirty_bitmap_size * 8;
-	unsigned i = 0;
+	unsigned int bitmap_bits = wc->dirty_bitmap_size * 8;
+	unsigned int i = 0;
 
 	while (1) {
-		unsigned j;
+		unsigned int j;
 		i = find_next_bit(wc->dirty_bitmap, bitmap_bits, i);
 		if (unlikely(i == bitmap_bits))
 			break;
@@ -1100,7 +1100,7 @@ static void writecache_resume(struct dm_target *ti)
 	wc_unlock(wc);
 }
 
-static int process_flush_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
+static int process_flush_mesg(unsigned int argc, char **argv, struct dm_writecache *wc)
 {
 	if (argc != 1)
 		return -EINVAL;
@@ -1133,7 +1133,7 @@ static int process_flush_mesg(unsigned argc, char **argv, struct dm_writecache *
 	return 0;
 }
 
-static int process_flush_on_suspend_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
+static int process_flush_on_suspend_mesg(unsigned int argc, char **argv, struct dm_writecache *wc)
 {
 	if (argc != 1)
 		return -EINVAL;
@@ -1153,7 +1153,7 @@ static void activate_cleaner(struct dm_writecache *wc)
 	wc->freelist_low_watermark = wc->n_blocks;
 }
 
-static int process_cleaner_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
+static int process_cleaner_mesg(unsigned int argc, char **argv, struct dm_writecache *wc)
 {
 	if (argc != 1)
 		return -EINVAL;
@@ -1167,7 +1167,7 @@ static int process_cleaner_mesg(unsigned argc, char **argv, struct dm_writecache
 	return 0;
 }
 
-static int process_clear_stats_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
+static int process_clear_stats_mesg(unsigned int argc, char **argv, struct dm_writecache *wc)
 {
 	if (argc != 1)
 		return -EINVAL;
@@ -1179,8 +1179,8 @@ static int process_clear_stats_mesg(unsigned argc, char **argv, struct dm_writec
 	return 0;
 }
 
-static int writecache_message(struct dm_target *ti, unsigned argc, char **argv,
-			      char *result, unsigned maxlen)
+static int writecache_message(struct dm_target *ti, unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen)
 {
 	int r = -EINVAL;
 	struct dm_writecache *wc = ti->private;
@@ -1238,9 +1238,9 @@ static void memcpy_flushcache_optimized(void *dest, void *source, size_t size)
 static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data)
 {
 	void *buf;
-	unsigned size;
+	unsigned int size;
 	int rw = bio_data_dir(bio);
-	unsigned remaining_size = wc->block_size;
+	unsigned int remaining_size = wc->block_size;
 
 	do {
 		struct bio_vec bv = bio_iter_iovec(bio, bio->bi_iter);
@@ -1371,7 +1371,7 @@ static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *
 static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 				    struct wc_entry *e, bool search_used)
 {
-	unsigned bio_size = wc->block_size;
+	unsigned int bio_size = wc->block_size;
 	sector_t start_cache_sec = cache_sector(wc, e);
 	sector_t current_cache_sec = start_cache_sec + (bio_size >> SECTOR_SHIFT);
 
@@ -1540,7 +1540,7 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 
 	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 
-	if (unlikely((((unsigned)bio->bi_iter.bi_sector | bio_sectors(bio)) &
+	if (unlikely((((unsigned int)bio->bi_iter.bi_sector | bio_sectors(bio)) &
 				(wc->block_size / 512 - 1)) != 0)) {
 		DMERR("I/O is not aligned, sector %llu, size %u, block size %u",
 		      (unsigned long long)bio->bi_iter.bi_sector,
@@ -1666,7 +1666,7 @@ static void writecache_copy_endio(int read_err, unsigned long write_err, void *p
 
 static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
 {
-	unsigned i;
+	unsigned int i;
 	struct writeback_struct *wb;
 	struct wc_entry *e;
 	unsigned long n_walked = 0;
@@ -1782,7 +1782,7 @@ static int writecache_endio_thread(void *data)
 static bool wc_add_block(struct writeback_struct *wb, struct wc_entry *e)
 {
 	struct dm_writecache *wc = wb->wc;
-	unsigned block_size = wc->block_size;
+	unsigned int block_size = wc->block_size;
 	void *address = memory_data(wc, e);
 
 	persistent_memory_flush_cache(address, block_size);
@@ -1817,7 +1817,7 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 	struct wc_entry *e, *f;
 	struct bio *bio;
 	struct writeback_struct *wb;
-	unsigned max_pages;
+	unsigned int max_pages;
 
 	while (wbl->size) {
 		wbl->size--;
@@ -1880,7 +1880,7 @@ static void __writecache_writeback_ssd(struct dm_writecache *wc, struct writebac
 	struct copy_struct *c;
 
 	while (wbl->size) {
-		unsigned n_sectors;
+		unsigned int n_sectors;
 
 		wbl->size--;
 		e = container_of(wbl->list.prev, struct wc_entry, lru);
@@ -2092,7 +2092,7 @@ static void writecache_writeback(struct work_struct *work)
 	}
 }
 
-static int calculate_memory_size(uint64_t device_size, unsigned block_size,
+static int calculate_memory_size(uint64_t device_size, unsigned int block_size,
 				 size_t *n_blocks_p, size_t *n_metadata_blocks_p)
 {
 	uint64_t n_blocks, offset;
@@ -2207,12 +2207,12 @@ static void writecache_dtr(struct dm_target *ti)
 	kfree(wc);
 }
 
-static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_writecache *wc;
 	struct dm_arg_set as;
 	const char *string;
-	unsigned opt_params;
+	unsigned int opt_params;
 	size_t offset, data_size;
 	int i, r;
 	char dummy;
@@ -2419,7 +2419,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				goto invalid_optional;
 			wc->autocommit_blocks_set = true;
 		} else if (!strcasecmp(string, "autocommit_time") && opt_params >= 1) {
-			unsigned autocommit_msecs;
+			unsigned int autocommit_msecs;
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%u%c", &autocommit_msecs, &dummy) != 1)
 				goto invalid_optional;
@@ -2429,7 +2429,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
-			unsigned max_age_msecs;
+			unsigned int max_age_msecs;
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%u%c", &max_age_msecs, &dummy) != 1)
 				goto invalid_optional;
@@ -2454,7 +2454,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		} else if (!strcasecmp(string, "metadata_only")) {
 			wc->metadata_only = true;
 		} else if (!strcasecmp(string, "pause_writeback") && opt_params >= 1) {
-			unsigned pause_msecs;
+			unsigned int pause_msecs;
 			if (WC_MODE_PMEM(wc))
 				goto invalid_optional;
 			string = dm_shift_arg(&as), opt_params--;
@@ -2653,11 +2653,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 }
 
 static void writecache_status(struct dm_target *ti, status_type_t type,
-			      unsigned status_flags, char *result, unsigned maxlen)
+			      unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	struct dm_writecache *wc = ti->private;
-	unsigned extra_args;
-	unsigned sz = 0;
+	unsigned int extra_args;
+	unsigned int sz = 0;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2e4193ae064c..b18c696099da 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -84,7 +84,7 @@ struct clone_info {
 	struct bio *bio;
 	struct dm_io *io;
 	sector_t sector;
-	unsigned sector_count;
+	unsigned int sector_count;
 	bool is_abnormal_io:1;
 	bool submit_as_polled:1;
 };
@@ -112,7 +112,7 @@ struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size)
 }
 EXPORT_SYMBOL_GPL(dm_bio_from_per_bio_data);
 
-unsigned dm_bio_get_target_bio_nr(const struct bio *bio)
+unsigned int dm_bio_get_target_bio_nr(const struct bio *bio)
 {
 	return container_of(bio, struct dm_target_io, clone)->target_bio_nr;
 }
@@ -143,7 +143,7 @@ struct table_device {
  * Bio-based DM's mempools' reserved IOs set by the user.
  */
 #define RESERVED_BIO_BASED_IOS		16
-static unsigned reserved_bio_based_ios = RESERVED_BIO_BASED_IOS;
+static unsigned int reserved_bio_based_ios = RESERVED_BIO_BASED_IOS;
 
 static int __dm_get_module_param_int(int *module_param, int min, int max)
 {
@@ -166,11 +166,10 @@ static int __dm_get_module_param_int(int *module_param, int min, int max)
 	return param;
 }
 
-unsigned __dm_get_module_param(unsigned *module_param,
-			       unsigned def, unsigned max)
+unsigned int __dm_get_module_param(unsigned int *module_param, unsigned int def, unsigned int max)
 {
-	unsigned param = READ_ONCE(*module_param);
-	unsigned modified_param = 0;
+	unsigned int param = READ_ONCE(*module_param);
+	unsigned int modified_param = 0;
 
 	if (!param)
 		modified_param = def;
@@ -185,14 +184,14 @@ unsigned __dm_get_module_param(unsigned *module_param,
 	return param;
 }
 
-unsigned dm_get_reserved_bio_based_ios(void)
+unsigned int dm_get_reserved_bio_based_ios(void)
 {
 	return __dm_get_module_param(&reserved_bio_based_ios,
 				     RESERVED_BIO_BASED_IOS, DM_RESERVED_MAX_IOS);
 }
 EXPORT_SYMBOL_GPL(dm_get_reserved_bio_based_ios);
 
-static unsigned dm_get_numa_node(void)
+static unsigned int dm_get_numa_node(void)
 {
 	return __dm_get_module_param_int(&dm_numa_node,
 					 DM_NUMA_NODE, num_online_nodes() - 1);
@@ -605,7 +604,7 @@ static void free_io(struct dm_io *io)
 }
 
 static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
-			     unsigned target_bio_nr, unsigned *len, gfp_t gfp_mask)
+			     unsigned int target_bio_nr, unsigned int *len, gfp_t gfp_mask)
 {
 	struct mapped_device *md = ci->io->md;
 	struct dm_target_io *tio;
@@ -1315,11 +1314,11 @@ static size_t dm_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
  * the partially processed part (the sum of regions 1+2) must be the same for all
  * copies of the bio.
  */
-void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
+void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 {
 	struct dm_target_io *tio = clone_to_tio(bio);
 	struct dm_io *io = tio->io;
-	unsigned bio_sectors = bio_sectors(bio);
+	unsigned int bio_sectors = bio_sectors(bio);
 
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
@@ -1448,7 +1447,7 @@ static void __map_bio(struct bio *clone)
 	}
 }
 
-static void setup_split_accounting(struct clone_info *ci, unsigned len)
+static void setup_split_accounting(struct clone_info *ci, unsigned int len)
 {
 	struct dm_io *io = ci->io;
 
@@ -1464,7 +1463,7 @@ static void setup_split_accounting(struct clone_info *ci, unsigned len)
 }
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
-				struct dm_target *ti, unsigned num_bios)
+				struct dm_target *ti, unsigned int num_bios)
 {
 	struct bio *bio;
 	int try;
@@ -1493,7 +1492,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 }
 
 static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
-				 unsigned int num_bios, unsigned *len)
+				 unsigned int num_bios, unsigned int *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
@@ -1559,10 +1558,9 @@ static void __send_empty_flush(struct clone_info *ci)
 }
 
 static void __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
-					unsigned num_bios)
+					unsigned int num_bios)
 {
-	unsigned len;
-	unsigned int bios;
+	unsigned int len, bios;
 
 	len = min_t(sector_t, ci->sector_count,
 		    max_io_len_target_boundary(ti, dm_target_offset(ti, ci->sector)));
@@ -1600,7 +1598,7 @@ static bool is_abnormal_io(struct bio *bio)
 static blk_status_t __process_abnormal_io(struct clone_info *ci,
 					  struct dm_target *ti)
 {
-	unsigned num_bios = 0;
+	unsigned int num_bios = 0;
 
 	switch (bio_op(ci->bio)) {
 	case REQ_OP_DISCARD:
@@ -1678,7 +1676,7 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 {
 	struct bio *clone;
 	struct dm_target *ti;
-	unsigned len;
+	unsigned int len;
 
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (unlikely(!ti))
@@ -2360,7 +2358,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 struct mapped_device *dm_get_md(dev_t dev)
 {
 	struct mapped_device *md;
-	unsigned minor = MINOR(dev);
+	unsigned int minor = MINOR(dev);
 
 	if (MAJOR(dev) != _major || minor >= (1 << MINORBITS))
 		return NULL;
@@ -2642,7 +2640,7 @@ static void unlock_fs(struct mapped_device *md)
  * are being added to md->deferred list.
  */
 static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
-			unsigned suspend_flags, unsigned int task_state,
+			unsigned int suspend_flags, unsigned int task_state,
 			int dmf_suspended_flag)
 {
 	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
@@ -2749,7 +2747,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
  *
  * To abort suspend, start the request_queue.
  */
-int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
+int dm_suspend(struct mapped_device *md, unsigned int suspend_flags)
 {
 	struct dm_table *map = NULL;
 	int r = 0;
@@ -2868,7 +2866,7 @@ int dm_resume(struct mapped_device *md, bool table_swapped)
  * It may be used only from the kernel.
  */
 
-static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
+static void __dm_internal_suspend(struct mapped_device *md, unsigned int suspend_flags)
 {
 	struct dm_table *map = NULL;
 
@@ -2969,11 +2967,10 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fast);
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
-int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie)
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action, unsigned int cookie)
 {
 	int r;
-	unsigned noio_flag;
+	unsigned int noio_flag;
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[] = { udev_cookie, NULL };
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 061dc0cbe515..53a0a436e54d 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -203,8 +203,7 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 			struct dm_dev **result);
 void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
 
-int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		      unsigned cookie);
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action, unsigned int cookie);
 
 void dm_internal_suspend(struct mapped_device *md);
 void dm_internal_resume(struct mapped_device *md);
@@ -223,6 +222,6 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
 /*
  * Various helpers
  */
-unsigned dm_get_reserved_bio_based_ios(void);
+unsigned int dm_get_reserved_bio_based_ios(void);
 
 #endif
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 38d5bfcc48a9..890f5bea1102 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -69,8 +69,8 @@ static int array_block_check(struct dm_block_validator *v,
 					       CSUM_XOR));
 	if (csum_disk != bh_le->csum) {
 		DMERR_LIMIT("array_block_check failed: csum %u != wanted %u",
-			    (unsigned) le32_to_cpu(csum_disk),
-			    (unsigned) le32_to_cpu(bh_le->csum));
+			    (unsigned int) le32_to_cpu(csum_disk),
+			    (unsigned int) le32_to_cpu(bh_le->csum));
 		return -EILSEQ;
 	}
 
@@ -95,7 +95,7 @@ static struct dm_block_validator array_validator = {
  * index - The index into _this_ specific block.
  */
 static void *element_at(struct dm_array_info *info, struct array_block *ab,
-			unsigned index)
+			unsigned int index)
 {
 	unsigned char *entry = (unsigned char *) (ab + 1);
 
@@ -109,9 +109,9 @@ static void *element_at(struct dm_array_info *info, struct array_block *ab,
  * in an array block.
  */
 static void on_entries(struct dm_array_info *info, struct array_block *ab,
-		       void (*fn)(void *, const void *, unsigned))
+		       void (*fn)(void *, const void *, unsigned int))
 {
-	unsigned nr_entries = le32_to_cpu(ab->nr_entries);
+	unsigned int nr_entries = le32_to_cpu(ab->nr_entries);
 	fn(info->value_type.context, element_at(info, ab, 0), nr_entries);
 }
 
@@ -172,7 +172,7 @@ static int alloc_ablock(struct dm_array_info *info, size_t size_of_block,
  * the current number of entries.
  */
 static void fill_ablock(struct dm_array_info *info, struct array_block *ab,
-			const void *value, unsigned new_nr)
+			const void *value, unsigned int new_nr)
 {
 	uint32_t nr_entries, delta, i;
 	struct dm_btree_value_type *vt = &info->value_type;
@@ -195,7 +195,7 @@ static void fill_ablock(struct dm_array_info *info, struct array_block *ab,
  * entries.
  */
 static void trim_ablock(struct dm_array_info *info, struct array_block *ab,
-			unsigned new_nr)
+			unsigned int new_nr)
 {
 	uint32_t nr_entries, delta;
 	struct dm_btree_value_type *vt = &info->value_type;
@@ -248,7 +248,7 @@ static void unlock_ablock(struct dm_array_info *info, struct dm_block *block)
  * / max_entries).
  */
 static int lookup_ablock(struct dm_array_info *info, dm_block_t root,
-			 unsigned index, struct dm_block **block,
+			 unsigned int index, struct dm_block **block,
 			 struct array_block **ab)
 {
 	int r;
@@ -296,7 +296,7 @@ static int __shadow_ablock(struct dm_array_info *info, dm_block_t b,
  * The shadow op will often be a noop.  Only insert if it really
  * copied data.
  */
-static int __reinsert_ablock(struct dm_array_info *info, unsigned index,
+static int __reinsert_ablock(struct dm_array_info *info, unsigned int index,
 			     struct dm_block *block, dm_block_t b,
 			     dm_block_t *root)
 {
@@ -322,7 +322,7 @@ static int __reinsert_ablock(struct dm_array_info *info, unsigned index,
  * for both the current root block, and the new one.
  */
 static int shadow_ablock(struct dm_array_info *info, dm_block_t *root,
-			 unsigned index, struct dm_block **block,
+			 unsigned int index, struct dm_block **block,
 			 struct array_block **ab)
 {
 	int r;
@@ -347,7 +347,7 @@ static int shadow_ablock(struct dm_array_info *info, dm_block_t *root,
  */
 static int insert_new_ablock(struct dm_array_info *info, size_t size_of_block,
 			     uint32_t max_entries,
-			     unsigned block_index, uint32_t nr,
+			     unsigned int block_index, uint32_t nr,
 			     const void *value, dm_block_t *root)
 {
 	int r;
@@ -366,8 +366,8 @@ static int insert_new_ablock(struct dm_array_info *info, size_t size_of_block,
 }
 
 static int insert_full_ablocks(struct dm_array_info *info, size_t size_of_block,
-			       unsigned begin_block, unsigned end_block,
-			       unsigned max_entries, const void *value,
+			       unsigned int begin_block, unsigned int end_block,
+			       unsigned int max_entries, const void *value,
 			       dm_block_t *root)
 {
 	int r = 0;
@@ -403,20 +403,20 @@ struct resize {
 	/*
 	 * Maximum nr entries in an array block.
 	 */
-	unsigned max_entries;
+	unsigned int max_entries;
 
 	/*
 	 * nr of completely full blocks in the array.
 	 *
 	 * 'old' refers to before the resize, 'new' after.
 	 */
-	unsigned old_nr_full_blocks, new_nr_full_blocks;
+	unsigned int old_nr_full_blocks, new_nr_full_blocks;
 
 	/*
 	 * Number of entries in the final block.  0 iff only full blocks in
 	 * the array.
 	 */
-	unsigned old_nr_entries_in_last_block, new_nr_entries_in_last_block;
+	unsigned int old_nr_entries_in_last_block, new_nr_entries_in_last_block;
 
 	/*
 	 * The default value used when growing the array.
@@ -431,8 +431,8 @@ struct resize {
  * begin_index - the index of the first array block to remove.
  * end_index - the one-past-the-end value.  ie. this block is not removed.
  */
-static int drop_blocks(struct resize *resize, unsigned begin_index,
-		       unsigned end_index)
+static int drop_blocks(struct resize *resize, unsigned int begin_index,
+		       unsigned int end_index)
 {
 	int r;
 
@@ -450,8 +450,8 @@ static int drop_blocks(struct resize *resize, unsigned begin_index,
 /*
  * Calculates how many blocks are needed for the array.
  */
-static unsigned total_nr_blocks_needed(unsigned nr_full_blocks,
-				       unsigned nr_entries_in_last_block)
+static unsigned int total_nr_blocks_needed(unsigned int nr_full_blocks,
+				       unsigned int nr_entries_in_last_block)
 {
 	return nr_full_blocks + (nr_entries_in_last_block ? 1 : 0);
 }
@@ -462,7 +462,7 @@ static unsigned total_nr_blocks_needed(unsigned nr_full_blocks,
 static int shrink(struct resize *resize)
 {
 	int r;
-	unsigned begin, end;
+	unsigned int begin, end;
 	struct dm_block *block;
 	struct array_block *ab;
 
@@ -528,7 +528,7 @@ static int grow_add_tail_block(struct resize *resize)
 static int grow_needs_more_blocks(struct resize *resize)
 {
 	int r;
-	unsigned old_nr_blocks = resize->old_nr_full_blocks;
+	unsigned int old_nr_blocks = resize->old_nr_full_blocks;
 
 	if (resize->old_nr_entries_in_last_block > 0) {
 		old_nr_blocks++;
@@ -570,11 +570,11 @@ static int grow(struct resize *resize)
  * These are the value_type functions for the btree elements, which point
  * to array blocks.
  */
-static void block_inc(void *context, const void *value, unsigned count)
+static void block_inc(void *context, const void *value, unsigned int count)
 {
 	const __le64 *block_le = value;
 	struct dm_array_info *info = context;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++, block_le++)
 		dm_tm_inc(info->btree_info.tm, le64_to_cpu(*block_le));
@@ -619,9 +619,9 @@ static void __block_dec(void *context, const void *value)
 	dm_tm_dec(info->btree_info.tm, b);
 }
 
-static void block_dec(void *context, const void *value, unsigned count)
+static void block_dec(void *context, const void *value, unsigned int count)
 {
-	unsigned i;
+	unsigned int i;
 	for (i = 0; i < count; i++, value += sizeof(__le64))
 		__block_dec(context, value);
 }
@@ -701,10 +701,11 @@ int dm_array_resize(struct dm_array_info *info, dm_block_t root,
 EXPORT_SYMBOL_GPL(dm_array_resize);
 
 static int populate_ablock_with_values(struct dm_array_info *info, struct array_block *ab,
-				       value_fn fn, void *context, unsigned base, unsigned new_nr)
+				       value_fn fn, void *context,
+				       unsigned int base, unsigned int new_nr)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct dm_btree_value_type *vt = &info->value_type;
 
 	BUG_ON(le32_to_cpu(ab->nr_entries));
@@ -729,7 +730,7 @@ int dm_array_new(struct dm_array_info *info, dm_block_t *root,
 	int r;
 	struct dm_block *block;
 	struct array_block *ab;
-	unsigned block_index, end_block, size_of_block, max_entries;
+	unsigned int block_index, end_block, size_of_block, max_entries;
 
 	r = dm_array_empty(info, root);
 	if (r)
@@ -777,7 +778,7 @@ int dm_array_get_value(struct dm_array_info *info, dm_block_t root,
 	struct dm_block *block;
 	struct array_block *ab;
 	size_t size_of_block;
-	unsigned entry, max_entries;
+	unsigned int entry, max_entries;
 
 	size_of_block = dm_bm_block_size(dm_tm_get_bm(info->btree_info.tm));
 	max_entries = calc_max_entries(info->value_type.size, size_of_block);
@@ -805,8 +806,8 @@ static int array_set_value(struct dm_array_info *info, dm_block_t root,
 	struct dm_block *block;
 	struct array_block *ab;
 	size_t size_of_block;
-	unsigned max_entries;
-	unsigned entry;
+	unsigned int max_entries;
+	unsigned int entry;
 	void *old_value;
 	struct dm_btree_value_type *vt = &info->value_type;
 
@@ -862,9 +863,9 @@ static int walk_ablock(void *context, uint64_t *keys, void *leaf)
 	struct walk_info *wi = context;
 
 	int r;
-	unsigned i;
+	unsigned int i;
 	__le64 block_le;
-	unsigned nr_entries, max_entries;
+	unsigned int nr_entries, max_entries;
 	struct dm_block *block;
 	struct array_block *ab;
 
diff --git a/drivers/md/persistent-data/dm-array.h b/drivers/md/persistent-data/dm-array.h
index ef0e1375773a..ec5428cc1350 100644
--- a/drivers/md/persistent-data/dm-array.h
+++ b/drivers/md/persistent-data/dm-array.h
@@ -199,7 +199,7 @@ struct dm_array_cursor {
 
 	struct dm_block *block;
 	struct array_block *ab;
-	unsigned index;
+	unsigned int index;
 };
 
 int dm_array_cursor_begin(struct dm_array_info *info,
diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
index 6c71eef8fffe..cf37cd41f96e 100644
--- a/drivers/md/persistent-data/dm-bitset.c
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -42,7 +42,7 @@ EXPORT_SYMBOL_GPL(dm_bitset_empty);
 
 struct packer_context {
 	bit_value_fn fn;
-	unsigned nr_bits;
+	unsigned int nr_bits;
 	void *context;
 };
 
@@ -50,7 +50,7 @@ static int pack_bits(uint32_t index, void *value, void *context)
 {
 	int r;
 	struct packer_context *p = context;
-	unsigned bit, nr = min(64u, p->nr_bits - (index * 64));
+	unsigned int bit, nr = min(64u, p->nr_bits - (index * 64));
 	uint64_t word = 0;
 	bool bv;
 
@@ -148,7 +148,7 @@ static int get_array_entry(struct dm_disk_bitset *info, dm_block_t root,
 			   uint32_t index, dm_block_t *new_root)
 {
 	int r;
-	unsigned array_index = index / BITS_PER_ARRAY_ENTRY;
+	unsigned int array_index = index / BITS_PER_ARRAY_ENTRY;
 
 	if (info->current_index_set) {
 		if (info->current_index == array_index)
@@ -166,7 +166,7 @@ int dm_bitset_set_bit(struct dm_disk_bitset *info, dm_block_t root,
 		      uint32_t index, dm_block_t *new_root)
 {
 	int r;
-	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+	unsigned int b = index % BITS_PER_ARRAY_ENTRY;
 
 	r = get_array_entry(info, root, index, new_root);
 	if (r)
@@ -183,7 +183,7 @@ int dm_bitset_clear_bit(struct dm_disk_bitset *info, dm_block_t root,
 			uint32_t index, dm_block_t *new_root)
 {
 	int r;
-	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+	unsigned int b = index % BITS_PER_ARRAY_ENTRY;
 
 	r = get_array_entry(info, root, index, new_root);
 	if (r)
@@ -200,7 +200,7 @@ int dm_bitset_test_bit(struct dm_disk_bitset *info, dm_block_t root,
 		       uint32_t index, dm_block_t *new_root, bool *result)
 {
 	int r;
-	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+	unsigned int b = index % BITS_PER_ARRAY_ENTRY;
 
 	r = get_array_entry(info, root, index, new_root);
 	if (r)
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index c21b46db04a3..6f1501046ada 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -58,10 +58,10 @@ struct waiter {
 	int wants_write;
 };
 
-static unsigned __find_holder(struct block_lock *lock,
+static unsigned int __find_holder(struct block_lock *lock,
 			      struct task_struct *task)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < MAX_HOLDERS; i++)
 		if (lock->holders[i] == task)
@@ -74,7 +74,7 @@ static unsigned __find_holder(struct block_lock *lock,
 /* call this *after* you increment lock->count */
 static void __add_holder(struct block_lock *lock, struct task_struct *task)
 {
-	unsigned h = __find_holder(lock, NULL);
+	unsigned int h = __find_holder(lock, NULL);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	struct stack_store *t;
 #endif
@@ -91,14 +91,14 @@ static void __add_holder(struct block_lock *lock, struct task_struct *task)
 /* call this *before* you decrement lock->count */
 static void __del_holder(struct block_lock *lock, struct task_struct *task)
 {
-	unsigned h = __find_holder(lock, task);
+	unsigned int h = __find_holder(lock, task);
 	lock->holders[h] = NULL;
 	put_task_struct(task);
 }
 
 static int __check_holder(struct block_lock *lock)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < MAX_HOLDERS; i++) {
 		if (lock->holders[i] == current) {
@@ -377,8 +377,8 @@ struct dm_block_manager {
 };
 
 struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
-						 unsigned block_size,
-						 unsigned max_held_per_thread)
+						 unsigned int block_size,
+						 unsigned int max_held_per_thread)
 {
 	int r;
 	struct dm_block_manager *bm;
@@ -416,7 +416,7 @@ void dm_block_manager_destroy(struct dm_block_manager *bm)
 }
 EXPORT_SYMBOL_GPL(dm_block_manager_destroy);
 
-unsigned dm_bm_block_size(struct dm_block_manager *bm)
+unsigned int dm_bm_block_size(struct dm_block_manager *bm)
 {
 	return dm_bufio_get_block_size(bm->bufio);
 }
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index 9aa79cd1d5b8..b67fc519358f 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -33,11 +33,11 @@ void *dm_block_data(struct dm_block *b);
  */
 struct dm_block_manager;
 struct dm_block_manager *dm_block_manager_create(
-	struct block_device *bdev, unsigned block_size,
-	unsigned max_held_per_thread);
+	struct block_device *bdev, unsigned int block_size,
+	unsigned int max_held_per_thread);
 void dm_block_manager_destroy(struct dm_block_manager *bm);
 
-unsigned dm_bm_block_size(struct dm_block_manager *bm);
+unsigned int dm_bm_block_size(struct dm_block_manager *bm);
 dm_block_t dm_bm_nr_blocks(struct dm_block_manager *bm);
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 358e6da623e5..29f3dda8ff23 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -125,10 +125,10 @@ static int node_copy(struct btree_node *left, struct btree_node *right, int shif
 /*
  * Delete a specific entry from a leaf node.
  */
-static void delete_at(struct btree_node *n, unsigned index)
+static void delete_at(struct btree_node *n, unsigned int index)
 {
-	unsigned nr_entries = le32_to_cpu(n->header.nr_entries);
-	unsigned nr_to_copy = nr_entries - (index + 1);
+	unsigned int nr_entries = le32_to_cpu(n->header.nr_entries);
+	unsigned int nr_to_copy = nr_entries - (index + 1);
 	uint32_t value_size = le32_to_cpu(n->header.value_size);
 	BUG_ON(index >= nr_entries);
 
@@ -145,20 +145,20 @@ static void delete_at(struct btree_node *n, unsigned index)
 	n->header.nr_entries = cpu_to_le32(nr_entries - 1);
 }
 
-static unsigned merge_threshold(struct btree_node *n)
+static unsigned int merge_threshold(struct btree_node *n)
 {
 	return le32_to_cpu(n->header.max_entries) / 3;
 }
 
 struct child {
-	unsigned index;
+	unsigned int index;
 	struct dm_block *block;
 	struct btree_node *n;
 };
 
 static int init_child(struct dm_btree_info *info, struct dm_btree_value_type *vt,
 		      struct btree_node *parent,
-		      unsigned index, struct child *result)
+		      unsigned int index, struct child *result)
 {
 	int r, inc;
 	dm_block_t root;
@@ -264,7 +264,7 @@ static int __rebalance2(struct dm_btree_info *info, struct btree_node *parent,
 		/*
 		 * Rebalance.
 		 */
-		unsigned target_left = (nr_left + nr_right) / 2;
+		unsigned int target_left = (nr_left + nr_right) / 2;
 		ret = shift(left, right, nr_left - target_left);
 		if (ret)
 			return ret;
@@ -274,7 +274,7 @@ static int __rebalance2(struct dm_btree_info *info, struct btree_node *parent,
 }
 
 static int rebalance2(struct shadow_spine *s, struct dm_btree_info *info,
-		      struct dm_btree_value_type *vt, unsigned left_index)
+		      struct dm_btree_value_type *vt, unsigned int left_index)
 {
 	int r;
 	struct btree_node *parent;
@@ -311,7 +311,7 @@ static int delete_center_node(struct dm_btree_info *info, struct btree_node *par
 			      uint32_t nr_left, uint32_t nr_center, uint32_t nr_right)
 {
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
-	unsigned shift = min(max_entries - nr_left, nr_center);
+	unsigned int shift = min(max_entries - nr_left, nr_center);
 
 	if (nr_left + shift > max_entries) {
 		DMERR("node shift out of bounds");
@@ -352,10 +352,10 @@ static int redistribute3(struct dm_btree_info *info, struct btree_node *parent,
 {
 	int s, ret;
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
-	unsigned total = nr_left + nr_center + nr_right;
-	unsigned target_right = total / 3;
-	unsigned remainder = (target_right * 3) != total;
-	unsigned target_left = target_right + remainder;
+	unsigned int total = nr_left + nr_center + nr_right;
+	unsigned int target_right = total / 3;
+	unsigned int remainder = (target_right * 3) != total;
+	unsigned int target_left = target_right + remainder;
 
 	BUG_ON(target_left > max_entries);
 	BUG_ON(target_right > max_entries);
@@ -423,7 +423,7 @@ static int __rebalance3(struct dm_btree_info *info, struct btree_node *parent,
 	uint32_t nr_center = le32_to_cpu(center->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
 
-	unsigned threshold = merge_threshold(left) * 4 + 1;
+	unsigned int threshold = merge_threshold(left) * 4 + 1;
 
 	if ((left->header.max_entries != center->header.max_entries) ||
 	    (center->header.max_entries != right->header.max_entries)) {
@@ -441,7 +441,7 @@ static int __rebalance3(struct dm_btree_info *info, struct btree_node *parent,
 }
 
 static int rebalance3(struct shadow_spine *s, struct dm_btree_info *info,
-		      struct dm_btree_value_type *vt, unsigned left_index)
+		      struct dm_btree_value_type *vt, unsigned int left_index)
 {
 	int r;
 	struct btree_node *parent = dm_block_data(shadow_current(s));
@@ -520,7 +520,7 @@ static int rebalance_children(struct shadow_spine *s,
 	return r;
 }
 
-static int do_leaf(struct btree_node *n, uint64_t key, unsigned *index)
+static int do_leaf(struct btree_node *n, uint64_t key, unsigned int *index)
 {
 	int i = lower_bound(n, key);
 
@@ -540,7 +540,7 @@ static int do_leaf(struct btree_node *n, uint64_t key, unsigned *index)
  */
 static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 		      struct dm_btree_value_type *vt, dm_block_t root,
-		      uint64_t key, unsigned *index)
+		      uint64_t key, unsigned int *index)
 {
 	int i = *index, r;
 	struct btree_node *n;
@@ -590,7 +590,7 @@ static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, dm_block_t *new_root)
 {
-	unsigned level, last_level = info->levels - 1;
+	unsigned int level, last_level = info->levels - 1;
 	int index = 0, r = 0;
 	struct shadow_spine spine;
 	struct btree_node *n;
@@ -602,7 +602,7 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		r = remove_raw(&spine, info,
 			       (level == last_level ?
 				&info->value_type : &le64_vt),
-			       root, keys[level], (unsigned *)&index);
+			       root, keys[level], (unsigned int *)&index);
 		if (r < 0)
 			break;
 
@@ -686,9 +686,9 @@ static int remove_nearest(struct shadow_spine *s, struct dm_btree_info *info,
 
 static int remove_one(struct dm_btree_info *info, dm_block_t root,
 		      uint64_t *keys, uint64_t end_key,
-		      dm_block_t *new_root, unsigned *nr_removed)
+		      dm_block_t *new_root, unsigned int *nr_removed)
 {
-	unsigned level, last_level = info->levels - 1;
+	unsigned int level, last_level = info->levels - 1;
 	int index = 0, r = 0;
 	struct shadow_spine spine;
 	struct btree_node *n;
@@ -699,7 +699,7 @@ static int remove_one(struct dm_btree_info *info, dm_block_t root,
 	init_shadow_spine(&spine, info);
 	for (level = 0; level < last_level; level++) {
 		r = remove_raw(&spine, info, &le64_vt,
-			       root, keys[level], (unsigned *) &index);
+			       root, keys[level], (unsigned int *) &index);
 		if (r < 0)
 			goto out;
 
@@ -743,7 +743,7 @@ static int remove_one(struct dm_btree_info *info, dm_block_t root,
 
 int dm_btree_remove_leaves(struct dm_btree_info *info, dm_block_t root,
 			   uint64_t *first_key, uint64_t end_key,
-			   dm_block_t *new_root, unsigned *nr_removed)
+			   dm_block_t *new_root, unsigned int *nr_removed)
 {
 	int r;
 
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index f62336caa8b9..be1792d85041 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -235,12 +235,12 @@ dm_block_t shadow_root(struct shadow_spine *s)
 	return s->root;
 }
 
-static void le64_inc(void *context, const void *value_le, unsigned count)
+static void le64_inc(void *context, const void *value_le, unsigned int count)
 {
 	dm_tm_with_runs(context, value_le, count, dm_tm_inc_range);
 }
 
-static void le64_dec(void *context, const void *value_le, unsigned count)
+static void le64_dec(void *context, const void *value_le, unsigned int count)
 {
 	dm_tm_with_runs(context, value_le, count, dm_tm_dec_range);
 }
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index b17e12b03b0f..a542d37a9b3e 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -24,8 +24,8 @@ static void memcpy_disk(void *dest, const void *src, size_t len)
 	__dm_unbless_for_disk(src);
 }
 
-static void array_insert(void *base, size_t elt_size, unsigned nr_elts,
-			 unsigned index, void *elt)
+static void array_insert(void *base, size_t elt_size, unsigned int nr_elts,
+			 unsigned int index, void *elt)
 	__dm_written_to_disk(elt)
 {
 	if (index < nr_elts)
@@ -81,7 +81,7 @@ void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 		vt->inc(vt->context, value_ptr(n, 0), nr_entries);
 }
 
-static int insert_at(size_t value_size, struct btree_node *node, unsigned index,
+static int insert_at(size_t value_size, struct btree_node *node, unsigned int index,
 		     uint64_t key, void *value)
 	__dm_written_to_disk(value)
 {
@@ -163,9 +163,9 @@ EXPORT_SYMBOL_GPL(dm_btree_empty);
 struct frame {
 	struct dm_block *b;
 	struct btree_node *n;
-	unsigned level;
-	unsigned nr_children;
-	unsigned current_child;
+	unsigned int level;
+	unsigned int nr_children;
+	unsigned int current_child;
 };
 
 struct del_stack {
@@ -194,7 +194,7 @@ static int unprocessed_frames(struct del_stack *s)
 
 static void prefetch_children(struct del_stack *s, struct frame *f)
 {
-	unsigned i;
+	unsigned int i;
 	struct dm_block_manager *bm = dm_tm_get_bm(s->tm);
 
 	for (i = 0; i < f->nr_children; i++)
@@ -206,7 +206,7 @@ static bool is_internal_level(struct dm_btree_info *info, struct frame *f)
 	return f->level < (info->levels - 1);
 }
 
-static int push_frame(struct del_stack *s, dm_block_t b, unsigned level)
+static int push_frame(struct del_stack *s, dm_block_t b, unsigned int level)
 {
 	int r;
 	uint32_t ref_count;
@@ -372,7 +372,7 @@ static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t key,
 int dm_btree_lookup(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, void *value_le)
 {
-	unsigned level, last_level = info->levels - 1;
+	unsigned int level, last_level = info->levels - 1;
 	int r = -ENODATA;
 	uint64_t rkey;
 	__le64 internal_value_le;
@@ -468,7 +468,7 @@ static int dm_btree_lookup_next_single(struct dm_btree_info *info, dm_block_t ro
 int dm_btree_lookup_next(struct dm_btree_info *info, dm_block_t root,
 			 uint64_t *keys, uint64_t *rkey, void *value_le)
 {
-	unsigned level;
+	unsigned int level;
 	int r = -ENODATA;
 	__le64 internal_value_le;
 	struct ro_spine spine;
@@ -503,9 +503,9 @@ EXPORT_SYMBOL_GPL(dm_btree_lookup_next);
  * Copies entries from one region of a btree node to another.  The regions
  * must not overlap.
  */
-static void copy_entries(struct btree_node *dest, unsigned dest_offset,
-			 struct btree_node *src, unsigned src_offset,
-			 unsigned count)
+static void copy_entries(struct btree_node *dest, unsigned int dest_offset,
+			 struct btree_node *src, unsigned int src_offset,
+			 unsigned int count)
 {
 	size_t value_size = le32_to_cpu(dest->header.value_size);
 	memcpy(dest->keys + dest_offset, src->keys + src_offset, count * sizeof(uint64_t));
@@ -516,9 +516,9 @@ static void copy_entries(struct btree_node *dest, unsigned dest_offset,
  * Moves entries from one region fo a btree node to another.  The regions
  * may overlap.
  */
-static void move_entries(struct btree_node *dest, unsigned dest_offset,
-			 struct btree_node *src, unsigned src_offset,
-			 unsigned count)
+static void move_entries(struct btree_node *dest, unsigned int dest_offset,
+			 struct btree_node *src, unsigned int src_offset,
+			 unsigned int count)
 {
 	size_t value_size = le32_to_cpu(dest->header.value_size);
 	memmove(dest->keys + dest_offset, src->keys + src_offset, count * sizeof(uint64_t));
@@ -529,7 +529,7 @@ static void move_entries(struct btree_node *dest, unsigned dest_offset,
  * Erases the first 'count' entries of a btree node, shifting following
  * entries down into their place.
  */
-static void shift_down(struct btree_node *n, unsigned count)
+static void shift_down(struct btree_node *n, unsigned int count)
 {
 	move_entries(n, 0, n, count, le32_to_cpu(n->header.nr_entries) - count);
 }
@@ -538,7 +538,7 @@ static void shift_down(struct btree_node *n, unsigned count)
  * Moves entries in a btree node up 'count' places, making space for
  * new entries at the start of the node.
  */
-static void shift_up(struct btree_node *n, unsigned count)
+static void shift_up(struct btree_node *n, unsigned int count)
 {
 	move_entries(n, count, n, 0, le32_to_cpu(n->header.nr_entries));
 }
@@ -549,18 +549,18 @@ static void shift_up(struct btree_node *n, unsigned count)
  */
 static void redistribute2(struct btree_node *left, struct btree_node *right)
 {
-	unsigned nr_left = le32_to_cpu(left->header.nr_entries);
-	unsigned nr_right = le32_to_cpu(right->header.nr_entries);
-	unsigned total = nr_left + nr_right;
-	unsigned target_left = total / 2;
-	unsigned target_right = total - target_left;
+	unsigned int nr_left = le32_to_cpu(left->header.nr_entries);
+	unsigned int nr_right = le32_to_cpu(right->header.nr_entries);
+	unsigned int total = nr_left + nr_right;
+	unsigned int target_left = total / 2;
+	unsigned int target_right = total - target_left;
 
 	if (nr_left < target_left) {
-		unsigned delta = target_left - nr_left;
+		unsigned int delta = target_left - nr_left;
 		copy_entries(left, nr_left, right, 0, delta);
 		shift_down(right, delta);
 	} else if (nr_left > target_left) {
-		unsigned delta = nr_left - target_left;
+		unsigned int delta = nr_left - target_left;
 		if (nr_right)
 			shift_up(right, delta);
 		copy_entries(right, 0, left, target_left, delta);
@@ -577,10 +577,10 @@ static void redistribute2(struct btree_node *left, struct btree_node *right)
 static void redistribute3(struct btree_node *left, struct btree_node *center,
 			  struct btree_node *right)
 {
-	unsigned nr_left = le32_to_cpu(left->header.nr_entries);
-	unsigned nr_center = le32_to_cpu(center->header.nr_entries);
-	unsigned nr_right = le32_to_cpu(right->header.nr_entries);
-	unsigned total, target_left, target_center, target_right;
+	unsigned int nr_left = le32_to_cpu(left->header.nr_entries);
+	unsigned int nr_center = le32_to_cpu(center->header.nr_entries);
+	unsigned int nr_right = le32_to_cpu(right->header.nr_entries);
+	unsigned int total, target_left, target_center, target_right;
 
 	BUG_ON(nr_center);
 
@@ -590,19 +590,19 @@ static void redistribute3(struct btree_node *left, struct btree_node *center,
 	target_right = (total - target_left - target_center);
 
 	if (nr_left < target_left) {
-		unsigned left_short = target_left - nr_left;
+		unsigned int left_short = target_left - nr_left;
 		copy_entries(left, nr_left, right, 0, left_short);
 		copy_entries(center, 0, right, left_short, target_center);
 		shift_down(right, nr_right - target_right);
 
 	} else if (nr_left < (target_left + target_center)) {
-		unsigned left_to_center = nr_left - target_left;
+		unsigned int left_to_center = nr_left - target_left;
 		copy_entries(center, 0, left, target_left, left_to_center);
 		copy_entries(center, left_to_center, right, 0, target_center - left_to_center);
 		shift_down(right, nr_right - target_right);
 
 	} else {
-		unsigned right_short = target_right - nr_right;
+		unsigned int right_short = target_right - nr_right;
 		shift_up(right, right_short);
 		copy_entries(right, 0, left, nr_left - right_short, right_short);
 		copy_entries(center, 0, left, target_left, nr_left - target_left);
@@ -643,7 +643,7 @@ static void redistribute3(struct btree_node *left, struct btree_node *center,
  *
  * Where A* is a shadow of A.
  */
-static int split_one_into_two(struct shadow_spine *s, unsigned parent_index,
+static int split_one_into_two(struct shadow_spine *s, unsigned int parent_index,
 			      struct dm_btree_value_type *vt, uint64_t key)
 {
 	int r;
@@ -697,7 +697,7 @@ static int split_one_into_two(struct shadow_spine *s, unsigned parent_index,
  * to the new shadow.
  */
 static int shadow_child(struct dm_btree_info *info, struct dm_btree_value_type *vt,
-			struct btree_node *parent, unsigned index,
+			struct btree_node *parent, unsigned int index,
 			struct dm_block **result)
 {
 	int r, inc;
@@ -726,11 +726,11 @@ static int shadow_child(struct dm_btree_info *info, struct dm_btree_value_type *
  * Splits two nodes into three.  This is more work, but results in fuller
  * nodes, so saves metadata space.
  */
-static int split_two_into_three(struct shadow_spine *s, unsigned parent_index,
+static int split_two_into_three(struct shadow_spine *s, unsigned int parent_index,
                                 struct dm_btree_value_type *vt, uint64_t key)
 {
 	int r;
-	unsigned middle_index;
+	unsigned int middle_index;
 	struct dm_block *left, *middle, *right, *parent;
 	struct btree_node *ln, *rn, *mn, *pn;
 	__le64 location;
@@ -831,7 +831,7 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 {
 	int r;
 	size_t size;
-	unsigned nr_left, nr_right;
+	unsigned int nr_left, nr_right;
 	struct dm_block *left, *right, *new_parent;
 	struct btree_node *pn, *ln, *rn;
 	__le64 val;
@@ -905,7 +905,7 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
  * Redistributes a node's entries with its left sibling.
  */
 static int rebalance_left(struct shadow_spine *s, struct dm_btree_value_type *vt,
-			  unsigned parent_index, uint64_t key)
+			  unsigned int parent_index, uint64_t key)
 {
 	int r;
 	struct dm_block *sib;
@@ -934,7 +934,7 @@ static int rebalance_left(struct shadow_spine *s, struct dm_btree_value_type *vt
  * Redistributes a nodes entries with its right sibling.
  */
 static int rebalance_right(struct shadow_spine *s, struct dm_btree_value_type *vt,
-			   unsigned parent_index, uint64_t key)
+			   unsigned int parent_index, uint64_t key)
 {
 	int r;
 	struct dm_block *sib;
@@ -962,10 +962,10 @@ static int rebalance_right(struct shadow_spine *s, struct dm_btree_value_type *v
 /*
  * Returns the number of spare entries in a node.
  */
-static int get_node_free_space(struct dm_btree_info *info, dm_block_t b, unsigned *space)
+static int get_node_free_space(struct dm_btree_info *info, dm_block_t b, unsigned int *space)
 {
 	int r;
-	unsigned nr_entries;
+	unsigned int nr_entries;
 	struct dm_block *block;
 	struct btree_node *node;
 
@@ -991,12 +991,12 @@ static int get_node_free_space(struct dm_btree_info *info, dm_block_t b, unsigne
  */
 #define SPACE_THRESHOLD 8
 static int rebalance_or_split(struct shadow_spine *s, struct dm_btree_value_type *vt,
-			      unsigned parent_index, uint64_t key)
+			      unsigned int parent_index, uint64_t key)
 {
 	int r;
 	struct btree_node *parent = dm_block_data(shadow_parent(s));
-	unsigned nr_parent = le32_to_cpu(parent->header.nr_entries);
-	unsigned free_space;
+	unsigned int nr_parent = le32_to_cpu(parent->header.nr_entries);
+	unsigned int free_space;
 	int left_shared = 0, right_shared = 0;
 
 	/* Should we move entries to the left sibling? */
@@ -1081,7 +1081,7 @@ static bool has_space_for_insert(struct btree_node *node, uint64_t key)
 
 static int btree_insert_raw(struct shadow_spine *s, dm_block_t root,
 			    struct dm_btree_value_type *vt,
-			    uint64_t key, unsigned *index)
+			    uint64_t key, unsigned int *index)
 {
 	int r, i = *index, top = 1;
 	struct btree_node *node;
@@ -1215,7 +1215,7 @@ int btree_get_overwrite_leaf(struct dm_btree_info *info, dm_block_t root,
 }
 
 static bool need_insert(struct btree_node *node, uint64_t *keys,
-			unsigned level, unsigned index)
+			unsigned int level, unsigned int index)
 {
         return ((index >= le32_to_cpu(node->header.nr_entries)) ||
 		(le64_to_cpu(node->keys[index]) != keys[level]));
@@ -1227,7 +1227,7 @@ static int insert(struct dm_btree_info *info, dm_block_t root,
 		  __dm_written_to_disk(value)
 {
 	int r;
-	unsigned level, index = -1, last_level = info->levels - 1;
+	unsigned int level, index = -1, last_level = info->levels - 1;
 	dm_block_t block = root;
 	struct shadow_spine spine;
 	struct btree_node *n;
@@ -1413,7 +1413,7 @@ static int walk_node(struct dm_btree_info *info, dm_block_t block,
 		     void *context)
 {
 	int r;
-	unsigned i, nr;
+	unsigned int i, nr;
 	struct dm_block *node;
 	struct btree_node *n;
 	uint64_t keys;
@@ -1456,7 +1456,7 @@ EXPORT_SYMBOL_GPL(dm_btree_walk);
 
 static void prefetch_values(struct dm_btree_cursor *c)
 {
-	unsigned i, nr;
+	unsigned int i, nr;
 	__le64 value_le;
 	struct cursor_node *n = c->nodes + c->depth - 1;
 	struct btree_node *bn = dm_block_data(n->b);
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index 74583403fb8f..0381ed689e51 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -59,14 +59,14 @@ struct dm_btree_value_type {
 	 * somewhere.) This method is _not_ called for insertion of a new
 	 * value: It is assumed the ref count is already 1.
 	 */
-	void (*inc)(void *context, const void *value, unsigned count);
+	void (*inc)(void *context, const void *value, unsigned int count);
 
 	/*
 	 * These values are being deleted.  The btree takes care of freeing
 	 * the memory pointed to by @value.  Often the del function just
 	 * needs to decrement a reference counts somewhere.
 	 */
-	void (*dec)(void *context, const void *value, unsigned count);
+	void (*dec)(void *context, const void *value, unsigned int count);
 
 	/*
 	 * A test for equality between two values.  When a value is
@@ -85,7 +85,7 @@ struct dm_btree_info {
 	/*
 	 * Number of nested btrees. (Not the depth of a single tree.)
 	 */
-	unsigned levels;
+	unsigned int levels;
 	struct dm_btree_value_type value_type;
 };
 
@@ -150,7 +150,7 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
  */
 int dm_btree_remove_leaves(struct dm_btree_info *info, dm_block_t root,
 			   uint64_t *keys, uint64_t end_key,
-			   dm_block_t *new_root, unsigned *nr_removed);
+			   dm_block_t *new_root, unsigned int *nr_removed);
 
 /*
  * Returns < 0 on failure.  Otherwise the number of key entries that have
@@ -189,7 +189,7 @@ int dm_btree_walk(struct dm_btree_info *info, dm_block_t root,
 
 struct cursor_node {
 	struct dm_block *b;
-	unsigned index;
+	unsigned int index;
 };
 
 struct dm_btree_cursor {
@@ -197,7 +197,7 @@ struct dm_btree_cursor {
 	dm_block_t root;
 
 	bool prefetch_leaves;
-	unsigned depth;
+	unsigned int depth;
 	struct cursor_node nodes[DM_BTREE_CURSOR_MAX_DEPTH];
 };
 
diff --git a/drivers/md/persistent-data/dm-persistent-data-internal.h b/drivers/md/persistent-data/dm-persistent-data-internal.h
index b2cd998d774c..3dc90d58fc93 100644
--- a/drivers/md/persistent-data/dm-persistent-data-internal.h
+++ b/drivers/md/persistent-data/dm-persistent-data-internal.h
@@ -10,11 +10,11 @@
 
 #include "dm-block-manager.h"
 
-static inline unsigned dm_hash_block(dm_block_t b, unsigned hash_mask)
+static inline unsigned int dm_hash_block(dm_block_t b, unsigned int hash_mask)
 {
-	const unsigned BIG_PRIME = 4294967291UL;
+	const unsigned int BIG_PRIME = 4294967291UL;
 
-	return (((unsigned) b) * BIG_PRIME) & hash_mask;
+	return (((unsigned int) b) * BIG_PRIME) & hash_mask;
 }
 
 #endif	/* _PERSISTENT_DATA_INTERNAL_H */
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index f46bbc65e4c0..b1705e0da437 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -127,7 +127,7 @@ static void *dm_bitmap_data(struct dm_block *b)
 
 #define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
 
-static unsigned dm_bitmap_word_used(void *addr, unsigned b)
+static unsigned int dm_bitmap_word_used(void *addr, unsigned int b)
 {
 	__le64 *words_le = addr;
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
@@ -138,11 +138,11 @@ static unsigned dm_bitmap_word_used(void *addr, unsigned b)
 	return !(~bits & mask);
 }
 
-static unsigned sm_lookup_bitmap(void *addr, unsigned b)
+static unsigned int sm_lookup_bitmap(void *addr, unsigned int b)
 {
 	__le64 *words_le = addr;
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
-	unsigned hi, lo;
+	unsigned int hi, lo;
 
 	b = (b & (ENTRIES_PER_WORD - 1)) << 1;
 	hi = !!test_bit_le(b, (void *) w_le);
@@ -150,7 +150,7 @@ static unsigned sm_lookup_bitmap(void *addr, unsigned b)
 	return (hi << 1) | lo;
 }
 
-static void sm_set_bitmap(void *addr, unsigned b, unsigned val)
+static void sm_set_bitmap(void *addr, unsigned int b, unsigned int val)
 {
 	__le64 *words_le = addr;
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
@@ -168,8 +168,8 @@ static void sm_set_bitmap(void *addr, unsigned b, unsigned val)
 		__clear_bit_le(b + 1, (void *) w_le);
 }
 
-static int sm_find_free(void *addr, unsigned begin, unsigned end,
-			unsigned *result)
+static int sm_find_free(void *addr, unsigned int begin, unsigned int end,
+			unsigned int *result)
 {
 	while (begin < end) {
 		if (!(begin & (ENTRIES_PER_WORD - 1)) &&
@@ -238,7 +238,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 {
 	int r;
 	dm_block_t i, nr_blocks, nr_indexes;
-	unsigned old_blocks, blocks;
+	unsigned int old_blocks, blocks;
 
 	nr_blocks = ll->nr_blocks + extra_blocks;
 	old_blocks = dm_sector_div_up(ll->nr_blocks, ll->entries_per_block);
@@ -352,7 +352,7 @@ int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 
 	for (i = index_begin; i < index_end; i++, begin = 0) {
 		struct dm_block *blk;
-		unsigned position;
+		unsigned int position;
 		uint32_t bit_end;
 
 		r = ll->load_ie(ll, i, &ie_disk);
@@ -370,7 +370,7 @@ int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 		bit_end = (i == index_end - 1) ?  end : ll->entries_per_block;
 
 		r = sm_find_free(dm_bitmap_data(blk),
-				 max_t(unsigned, begin, le32_to_cpu(ie_disk.none_free_before)),
+				 max_t(unsigned int, begin, le32_to_cpu(ie_disk.none_free_before)),
 				 bit_end, &position);
 		if (r == -ENOSPC) {
 			/*
@@ -1098,7 +1098,7 @@ static inline int ie_cache_writeback(struct ll_disk *ll, struct ie_cache *iec)
 			       &iec->index, &iec->ie, &ll->bitmap_root);
 }
 
-static inline unsigned hash_index(dm_block_t index)
+static inline unsigned int hash_index(dm_block_t index)
 {
 	return dm_hash_block(index, IE_CACHE_MASK);
 }
@@ -1107,7 +1107,7 @@ static int disk_ll_load_ie(struct ll_disk *ll, dm_block_t index,
 			   struct disk_index_entry *ie)
 {
 	int r;
-	unsigned h = hash_index(index);
+	unsigned int h = hash_index(index);
 	struct ie_cache *iec = ll->ie_cache + h;
 
 	if (iec->valid) {
@@ -1138,7 +1138,7 @@ static int disk_ll_save_ie(struct ll_disk *ll, dm_block_t index,
 			   struct disk_index_entry *ie)
 {
 	int r;
-	unsigned h = hash_index(index);
+	unsigned int h = hash_index(index);
 	struct ie_cache *iec = ll->ie_cache + h;
 
 	ll->bitmap_index_changed = true;
@@ -1165,7 +1165,7 @@ static int disk_ll_save_ie(struct ll_disk *ll, dm_block_t index,
 
 static int disk_ll_init_index(struct ll_disk *ll)
 {
-	unsigned i;
+	unsigned int i;
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
 		iec->valid = false;
@@ -1187,7 +1187,7 @@ static dm_block_t disk_ll_max_entries(struct ll_disk *ll)
 static int disk_ll_commit(struct ll_disk *ll)
 {
 	int r = 0;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index c4ccb72123bf..ee754bcc2643 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -95,8 +95,8 @@ struct block_op {
 };
 
 struct bop_ring_buffer {
-	unsigned begin;
-	unsigned end;
+	unsigned int begin;
+	unsigned int end;
 	struct block_op bops[MAX_RECURSIVE_ALLOCATIONS + 1];
 };
 
@@ -111,9 +111,9 @@ static bool brb_empty(struct bop_ring_buffer *brb)
 	return brb->begin == brb->end;
 }
 
-static unsigned brb_next(struct bop_ring_buffer *brb, unsigned old)
+static unsigned int brb_next(struct bop_ring_buffer *brb, unsigned int old)
 {
-	unsigned r = old + 1;
+	unsigned int r = old + 1;
 	return r >= ARRAY_SIZE(brb->bops) ? 0 : r;
 }
 
@@ -121,7 +121,7 @@ static int brb_push(struct bop_ring_buffer *brb,
 		    enum block_op_type type, dm_block_t b, dm_block_t e)
 {
 	struct block_op *bop;
-	unsigned next = brb_next(brb, brb->end);
+	unsigned int next = brb_next(brb, brb->end);
 
 	/*
 	 * We don't allow the last bop to be filled, this way we can
@@ -172,8 +172,8 @@ struct sm_metadata {
 
 	dm_block_t begin;
 
-	unsigned recursion_count;
-	unsigned allocated_this_transaction;
+	unsigned int recursion_count;
+	unsigned int allocated_this_transaction;
 	struct bop_ring_buffer uncommitted;
 
 	struct threshold threshold;
@@ -301,9 +301,9 @@ static int sm_metadata_get_count(struct dm_space_map *sm, dm_block_t b,
 				 uint32_t *result)
 {
 	int r;
-	unsigned i;
+	unsigned int i;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
-	unsigned adjustment = 0;
+	unsigned int adjustment = 0;
 
 	/*
 	 * We may have some uncommitted adjustments to add.  This list
@@ -341,7 +341,7 @@ static int sm_metadata_count_is_more_than_one(struct dm_space_map *sm,
 					      dm_block_t b, int *result)
 {
 	int r, adjustment = 0;
-	unsigned i;
+	unsigned int i;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 	uint32_t rc;
 
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 5bcfb50baad8..c0633728b3e7 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -29,14 +29,14 @@ struct prefetch_set {
 	dm_block_t blocks[PREFETCH_SIZE];
 };
 
-static unsigned prefetch_hash(dm_block_t b)
+static unsigned int prefetch_hash(dm_block_t b)
 {
 	return hash_64(b, PREFETCH_BITS);
 }
 
 static void prefetch_wipe(struct prefetch_set *p)
 {
-	unsigned i;
+	unsigned int i;
 	for (i = 0; i < PREFETCH_SIZE; i++)
 		p->blocks[i] = PREFETCH_SENTINEL;
 }
@@ -49,7 +49,7 @@ static void prefetch_init(struct prefetch_set *p)
 
 static void prefetch_add(struct prefetch_set *p, dm_block_t b)
 {
-	unsigned h = prefetch_hash(b);
+	unsigned int h = prefetch_hash(b);
 
 	mutex_lock(&p->lock);
 	if (p->blocks[h] == PREFETCH_SENTINEL)
@@ -60,7 +60,7 @@ static void prefetch_add(struct prefetch_set *p, dm_block_t b)
 
 static void prefetch_issue(struct prefetch_set *p, struct dm_block_manager *bm)
 {
-	unsigned i;
+	unsigned int i;
 
 	mutex_lock(&p->lock);
 
@@ -104,7 +104,7 @@ struct dm_transaction_manager {
 static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
 {
 	int r = 0;
-	unsigned bucket = dm_hash_block(b, DM_HASH_MASK);
+	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
 	struct shadow_info *si;
 
 	spin_lock(&tm->lock);
@@ -124,7 +124,7 @@ static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
  */
 static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
 {
-	unsigned bucket;
+	unsigned int bucket;
 	struct shadow_info *si;
 
 	si = kmalloc(sizeof(*si), GFP_NOIO);
@@ -394,11 +394,11 @@ void dm_tm_dec_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t
 EXPORT_SYMBOL_GPL(dm_tm_dec_range);
 
 void dm_tm_with_runs(struct dm_transaction_manager *tm,
-		     const __le64 *value_le, unsigned count, dm_tm_run_fn fn)
+		     const __le64 *value_le, unsigned int count, dm_tm_run_fn fn)
 {
 	uint64_t b, begin, end;
 	bool in_run = false;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < count; i++, value_le++) {
 		b = le64_to_cpu(*value_le);
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index 2a1390f59288..cfbdddb3d275 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -112,7 +112,7 @@ void dm_tm_dec_range(struct dm_transaction_manager *tm, dm_block_t b, dm_block_t
  */
 typedef void (*dm_tm_run_fn)(struct dm_transaction_manager *, dm_block_t, dm_block_t);
 void dm_tm_with_runs(struct dm_transaction_manager *tm,
-		     const __le64 *value_le, unsigned count, dm_tm_run_fn fn);
+		     const __le64 *value_le, unsigned int count, dm_tm_run_fn fn);
 
 int dm_tm_ref(struct dm_transaction_manager *tm, dm_block_t b, uint32_t *result);
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 56b2cf2cc6e4..4dab671922e5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -88,10 +88,10 @@ typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
 
 typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
-			      unsigned status_flags, char *result, unsigned maxlen);
+			      unsigned int status_flags, char *result, unsigned int maxlen);
 
-typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv,
-			      char *result, unsigned maxlen);
+typedef int (*dm_message_fn) (struct dm_target *ti, unsigned int argc, char **argv,
+			      char *result, unsigned int maxlen);
 
 typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct block_device **bdev);
 
@@ -188,7 +188,7 @@ struct target_type {
 	uint64_t features;
 	const char *name;
 	struct module *module;
-	unsigned version[3];
+	unsigned int version[3];
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
@@ -314,31 +314,31 @@ struct dm_target {
 	 * It is a responsibility of the target driver to remap these bios
 	 * to the real underlying devices.
 	 */
-	unsigned num_flush_bios;
+	unsigned int num_flush_bios;
 
 	/*
 	 * The number of discard bios that will be submitted to the target.
 	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
 	 */
-	unsigned num_discard_bios;
+	unsigned int num_discard_bios;
 
 	/*
 	 * The number of secure erase bios that will be submitted to the target.
 	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
 	 */
-	unsigned num_secure_erase_bios;
+	unsigned int num_secure_erase_bios;
 
 	/*
 	 * The number of WRITE ZEROES bios that will be submitted to the target.
 	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
 	 */
-	unsigned num_write_zeroes_bios;
+	unsigned int num_write_zeroes_bios;
 
 	/*
 	 * The minimum number of extra bytes allocated in each io for the
 	 * target to use.
 	 */
-	unsigned per_io_data_size;
+	unsigned int per_io_data_size;
 
 	/* target specific data */
 	void *private;
@@ -384,7 +384,7 @@ struct dm_target {
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size);
-unsigned dm_bio_get_target_bio_nr(const struct bio *bio);
+unsigned int dm_bio_get_target_bio_nr(const struct bio *bio);
 
 u64 dm_start_time_ns_from_clone(struct bio *bio);
 
@@ -395,7 +395,7 @@ void dm_unregister_target(struct target_type *t);
  * Target argument parsing.
  */
 struct dm_arg_set {
-	unsigned argc;
+	unsigned int argc;
 	char **argv;
 };
 
@@ -404,8 +404,8 @@ struct dm_arg_set {
  * the error message to use if the number is found to be outside that range.
  */
 struct dm_arg {
-	unsigned min;
-	unsigned max;
+	unsigned int min;
+	unsigned int max;
 	char *error;
 };
 
@@ -414,7 +414,7 @@ struct dm_arg {
  * returning -EINVAL and setting *error.
  */
 int dm_read_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
-		unsigned *value, char **error);
+		unsigned int *value, char **error);
 
 /*
  * Process the next argument as the start of a group containing between
@@ -422,7 +422,7 @@ int dm_read_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
  * *num_args or, if invalid, return -EINVAL and set *error.
  */
 int dm_read_arg_group(const struct dm_arg *arg, struct dm_arg_set *arg_set,
-		      unsigned *num_args, char **error);
+		      unsigned int *num_args, char **error);
 
 /*
  * Return the current argument and shift to the next.
@@ -432,7 +432,7 @@ const char *dm_shift_arg(struct dm_arg_set *as);
 /*
  * Move through num_args arguments.
  */
-void dm_consume_args(struct dm_arg_set *as, unsigned num_args);
+void dm_consume_args(struct dm_arg_set *as, unsigned int num_args);
 
 /*-----------------------------------------------------------------
  * Functions for creating and manipulating mapped devices.
@@ -462,7 +462,7 @@ void *dm_get_mdptr(struct mapped_device *md);
 /*
  * A device can still be used while suspended, but I/O is deferred.
  */
-int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
+int dm_suspend(struct mapped_device *md, unsigned int suspend_flags);
 int dm_resume(struct mapped_device *md, bool table_swapped);
 
 /*
@@ -482,7 +482,7 @@ struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_post_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
-void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
+void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors);
 void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
@@ -526,7 +526,7 @@ int dm_set_geometry(struct mapped_device *md, struct hd_geometry *geo);
  * First create an empty table.
  */
 int dm_table_create(struct dm_table **result, fmode_t mode,
-		    unsigned num_targets, struct mapped_device *md);
+		    unsigned int num_targets, struct mapped_device *md);
 
 /*
  * Then call this once for each target.
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 2cf1a7a24746..c4d96abea1c1 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -27,8 +27,8 @@ struct dm_buffer;
  * Create a buffered IO cache on a given device
  */
 struct dm_bufio_client *
-dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
-		       unsigned reserved_buffers, unsigned aux_size,
+dm_bufio_client_create(struct block_device *bdev, unsigned int block_size,
+		       unsigned int reserved_buffers, unsigned int aux_size,
 		       void (*alloc_callback)(struct dm_buffer *),
 		       void (*write_callback)(struct dm_buffer *),
 		       unsigned int flags);
@@ -82,7 +82,7 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
  * I/O to finish.
  */
 void dm_bufio_prefetch(struct dm_bufio_client *c,
-		       sector_t block, unsigned n_blocks);
+		       sector_t block, unsigned int n_blocks);
 
 /*
  * Release a reference obtained with dm_bufio_{read,get,new}. The data
@@ -107,7 +107,7 @@ void dm_bufio_mark_buffer_dirty(struct dm_buffer *b);
  * write the specified part of the buffer or it may write a larger superset.
  */
 void dm_bufio_mark_partial_buffer_dirty(struct dm_buffer *b,
-					unsigned start, unsigned end);
+					unsigned int start, unsigned int end);
 
 /*
  * Initiate writing of dirty buffers, without waiting for completion.
@@ -153,9 +153,9 @@ void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t
 /*
  * Set the minimum number of buffers before cleanup happens.
  */
-void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
+void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 
-unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
+unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
index 9c0f62162fab..8642bfaf41b6 100644
--- a/include/linux/dm-dirty-log.h
+++ b/include/linux/dm-dirty-log.h
@@ -34,7 +34,7 @@ struct dm_dirty_log_type {
 	struct list_head list;
 
 	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
-		   unsigned argc, char **argv);
+		   unsigned int argc, char **argv);
 	void (*dtr)(struct dm_dirty_log *log);
 
 	/*
@@ -117,7 +117,7 @@ struct dm_dirty_log_type {
 	 * Support function for mirror status requests.
 	 */
 	int (*status)(struct dm_dirty_log *log, status_type_t status_type,
-		      char *result, unsigned maxlen);
+		      char *result, unsigned int maxlen);
 
 	/*
 	 * is_remote_recovering is necessary for cluster mirroring. It provides
@@ -140,7 +140,7 @@ int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 			struct dm_target *ti,
 			int (*flush_callback_fn)(struct dm_target *ti),
-			unsigned argc, char **argv);
+			unsigned int argc, char **argv);
 void dm_dirty_log_destroy(struct dm_dirty_log *log);
 
 #endif	/* __KERNEL__ */
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index 0ab753163ca3..589dce78a557 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -27,7 +27,7 @@ struct page_list {
 	struct page *page;
 };
 
-typedef void (*io_notify_fn)(unsigned long error, void *context);
+typedef void (*io_notify_fn)(unsigned int long error, void *context);
 
 enum dm_io_mem_type {
 	DM_IO_PAGE_LIST,/* Page list */
@@ -39,7 +39,7 @@ enum dm_io_mem_type {
 struct dm_io_memory {
 	enum dm_io_mem_type type;
 
-	unsigned offset;
+	unsigned int offset;
 
 	union {
 		struct page_list *pl;
@@ -79,8 +79,8 @@ void dm_io_client_destroy(struct dm_io_client *client);
  * Each bit in the optional 'sync_error_bits' bitset indicates whether an
  * error occurred doing io to the corresponding region.
  */
-int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct dm_io_region *region, unsigned long *sync_error_bits);
+int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
+	  struct dm_io_region *region, unsigned int long *sync_error_bits);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_IO_H */
diff --git a/include/linux/dm-kcopyd.h b/include/linux/dm-kcopyd.h
index 64e7d7d7da04..83525514a2f6 100644
--- a/include/linux/dm-kcopyd.h
+++ b/include/linux/dm-kcopyd.h
@@ -24,11 +24,11 @@
 #define DM_KCOPYD_WRITE_SEQ    2
 
 struct dm_kcopyd_throttle {
-	unsigned throttle;
-	unsigned num_io_jobs;
-	unsigned io_period;
-	unsigned total_period;
-	unsigned last_jiffies;
+	unsigned int throttle;
+	unsigned int num_io_jobs;
+	unsigned int io_period;
+	unsigned int total_period;
+	unsigned int last_jiffies;
 };
 
 /*
@@ -61,12 +61,12 @@ void dm_kcopyd_client_flush(struct dm_kcopyd_client *kc);
  * read_err is a boolean,
  * write_err is a bitset, with 1 bit for each destination region
  */
-typedef void (*dm_kcopyd_notify_fn)(int read_err, unsigned long write_err,
+typedef void (*dm_kcopyd_notify_fn)(int read_err, unsigned int long write_err,
 				    void *context);
 
 void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
-		    unsigned num_dests, struct dm_io_region *dests,
-		    unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+		    unsigned int num_dests, struct dm_io_region *dests,
+		    unsigned int flags, dm_kcopyd_notify_fn fn, void *context);
 
 /*
  * Prepare a callback and submit it via the kcopyd thread.
@@ -81,11 +81,11 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
  */
 void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 				 dm_kcopyd_notify_fn fn, void *context);
-void dm_kcopyd_do_callback(void *job, int read_err, unsigned long write_err);
+void dm_kcopyd_do_callback(void *job, int read_err, unsigned int long write_err);
 
 void dm_kcopyd_zero(struct dm_kcopyd_client *kc,
-		    unsigned num_dests, struct dm_io_region *dests,
-		    unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+		    unsigned int num_dests, struct dm_io_region *dests,
+		    unsigned int flags, dm_kcopyd_notify_fn fn, void *context);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
diff --git a/include/linux/dm-region-hash.h b/include/linux/dm-region-hash.h
index 7feaa3a53f7b..d9f89b8e34c1 100644
--- a/include/linux/dm-region-hash.h
+++ b/include/linux/dm-region-hash.h
@@ -38,7 +38,7 @@ struct dm_region_hash *dm_region_hash_create(
 						     struct bio_list *bios),
 		void (*wakeup_workers)(void *context),
 		void (*wakeup_all_recovery_waiters)(void *context),
-		sector_t target_begin, unsigned max_recovery,
+		sector_t target_begin, unsigned int max_recovery,
 		struct dm_dirty_log *log, uint32_t region_size,
 		region_t nr_regions);
 void dm_region_hash_destroy(struct dm_region_hash *rh);
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

