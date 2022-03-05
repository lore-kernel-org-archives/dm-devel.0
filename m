Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A7DC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  5 Mar 2022 02:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646446114;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Au1GQ4icEn/kXmtgkA94bZdu8DIuhLx3gFkrylGrBIE=;
	b=UepR5cJoANQsdZuGEn8ZRO/GSln8eNoLszv9U/UgHquix4QzHjXmVz70Gae5yBogr5dM13
	SSMzTs6q25vhOQDz+NrkixxV45WJoGP3Kjw+WxFRDMlW/BJncMAMUuIcPClR9H9sdrC3zI
	LrEM6Z21fO1lUU593HNshs3JzIT/q1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-hi4ATk9OMxGmvl2LnF0xiQ-1; Fri, 04 Mar 2022 21:08:31 -0500
X-MC-Unique: hi4ATk9OMxGmvl2LnF0xiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E15C180FD71;
	Sat,  5 Mar 2022 02:08:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 041905F4FE;
	Sat,  5 Mar 2022 02:08:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A0A554A701;
	Sat,  5 Mar 2022 02:08:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 22528BtK029103 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 21:08:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CC6D1400E437; Sat,  5 Mar 2022 02:08:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C833E404779D
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A9143C02184
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:11 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-451-8JmqS861Nqao7IoAeZbngA-1; Fri, 04 Mar 2022 21:08:10 -0500
X-MC-Unique: 8JmqS861Nqao7IoAeZbngA-1
Received: by mail-qv1-f70.google.com with SMTP id
	p12-20020a0c9a0c000000b0043299cbbd36so8427894qvd.16
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 18:08:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=nuqHrxxiLjKwIKGFIEG11jEi0JDG4ZjL1r2pZPX9y5Y=;
	b=OhamPFn3spqfoFvFXxH9FPxFrYjsrqYgm2jiscWWj7ZtDRPMvVWTI9dZuIfDIednIe
	dTn0b4lj83Uxv9M6oejyzPVmYN9FHeZasrow9PJRR269+fIaohw7tGuoy+lheFCEW7kO
	GswtK7KLGfDJ5Z7iNegWZCQA5YvzYjtNSz3rsTnB29aMsklhVz7VhTv+IRx+N1FY+MKd
	mzFQx6IhaimLM8mGiswH6/GWfoeOm2kCroacJHRFwpE0NDNGNQFMc7BqG+6b66CP3nyL
	gb5VDS3HI6KisHoyETI2H5ZysZb4sWLueq3IMiv7X/qj7dFQskm04CNtU+b4wAYEJR4y
	md2g==
X-Gm-Message-State: AOAM530znTagltEFdO+0cvYJNxA3ik7QC3IVdbTVlkU64zB4ms3zyn4m
	aoTr2DoXQdNx3PKM9R/DXKbMAFYDGYKepLL3wHGWfuzTeXChwmWqOMuzfGXl34mDsPG5QwPyhbV
	3q9dHzpJ2mfZd3Q==
X-Received: by 2002:a05:6214:240c:b0:42c:728e:8a55 with SMTP id
	fv12-20020a056214240c00b0042c728e8a55mr1334591qvb.126.1646446089547;
	Fri, 04 Mar 2022 18:08:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO1e0sw1ZknZ5fe6MMPLOM04heX1oaX+MTgbCfYym4UffPA19KNQxbK+4EXckALDorTx3VkQ==
X-Received: by 2002:a05:6214:240c:b0:42c:728e:8a55 with SMTP id
	fv12-20020a056214240c00b0042c728e8a55mr1334574qvb.126.1646446089233;
	Fri, 04 Mar 2022 18:08:09 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	15-20020ac8570f000000b002e05a1f990dsm260445qtw.65.2022.03.04.18.08.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 18:08:08 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri,  4 Mar 2022 21:08:04 -0500
Message-Id: <20220305020804.54010-3-snitzer@redhat.com>
In-Reply-To: <20220305020804.54010-1-snitzer@redhat.com>
References: <20220305020804.54010-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: [dm-devel] [PATCH v5 2/2] dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Ming Lei <ming.lei@redhat.com>

Support bio(REQ_POLLED) polling in the following approach:

1) only support io polling on normal READ/WRITE, and other abnormal IOs
still fallback to IRQ mode, so the target io is exactly inside the dm
io.

2) hold one refcnt on io->io_count after submitting this dm bio with
REQ_POLLED

3) support dm native bio splitting, any dm io instance associated with
current bio will be added into one list which head is bio->bi_end_io
which will be recovered before ending this bio

4) implement .poll_bio() callback, call bio_poll() on the single target
bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
dm_io_dec_pending() after the target io is done in .poll_bio()

5) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
which is based on Jeffle's previous patch.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h  |   2 +
 drivers/md/dm-table.c |  27 +++++++++
 drivers/md/dm.c       | 150 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 8078b6c155ef..b3d1429fba83 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -235,6 +235,8 @@ struct dm_io {
 	bool start_io_acct:1;
 	int was_accounted;
 	unsigned long start_time;
+	void *saved_bio_end_io;
+	struct hlist_node node;
 	spinlock_t endio_lock;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f4ed756ab391..c0be4f60b427 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1481,6 +1481,14 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
+}
+
 /*
  * type->iterate_devices() should be called when the sanity check needs to
  * iterate and check all underlying data devices. iterate_devices() will
@@ -1531,6 +1539,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
 	return 0;
 }
 
+static int dm_table_supports_poll(struct dm_table *t)
+{
+	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
+}
+
 /*
  * Check whether a table has no data devices attached using each
  * target's iterate_devices method.
@@ -2067,6 +2080,20 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	dm_update_crypto_profile(q, t);
 	disk_update_readahead(t->md->disk);
 
+	/*
+	 * Check for request-based device is left to
+	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
+	 *
+	 * For bio-based device, only set QUEUE_FLAG_POLL when all
+	 * underlying devices supporting polling.
+	 */
+	if (__table_type_bio_based(t->type)) {
+		if (dm_table_supports_poll(t))
+			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+		else
+			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 454d39bc7745..c28d453e9930 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -40,6 +40,13 @@
 #define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
 #define DM_COOKIE_LENGTH 24
 
+/*
+ * For REQ_POLLED fs bio, this flag is set if we link mapped underlying
+ * dm_io into one list, and reuse bio->bi_end_io as the list head. Before
+ * ending this fs bio, we will recover its ->bi_end_io callback.
+ */
+#define REQ_DM_POLL_LIST	REQ_DRV
+
 static const char *_name = DM_NAME;
 
 static unsigned int major = 0;
@@ -73,6 +80,7 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	unsigned sector_count;
+	bool submit_as_polled;
 };
 
 #define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
@@ -599,6 +607,9 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		if (!clone)
 			return NULL;
 
+		/* REQ_DM_POLL_LIST shouldn't be inherited */
+		clone->bi_opf &= ~REQ_DM_POLL_LIST;
+
 		tio = clone_to_tio(clone);
 		tio->inside_dm_io = false;
 	}
@@ -888,8 +899,15 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		if (unlikely(wq_has_sleeper(&md->wait)))
 			wake_up(&md->wait);
 
-		if (io_error == BLK_STS_DM_REQUEUE)
+		if (io_error == BLK_STS_DM_REQUEUE) {
+			/*
+			 * Upper layer won't help us poll split bio, io->orig_bio
+			 * may only reflect a subset of the pre-split original,
+			 * so clear REQ_POLLED in case of requeue
+			 */
+			bio->bi_opf &= ~REQ_POLLED;
 			return;
+		}
 
 		if (bio_is_flush_with_data(bio)) {
 			/*
@@ -1440,6 +1458,42 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 	return true;
 }
 
+/*
+ * Reuse ->bi_end_io as hlist head for storing all dm_io instances
+ * associated with this bio, and this bio's bi_end_io has to be
+ * stored in one of 'dm_io' instance first.
+ */
+static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
+{
+	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
+
+	return (struct hlist_head *)&bio->bi_end_io;
+}
+
+static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
+{
+	if (!(bio->bi_opf & REQ_DM_POLL_LIST)) {
+		bio->bi_opf |= REQ_DM_POLL_LIST;
+		/*
+		 * Save .bi_end_io into dm_io, so that we can reuse
+		 * .bi_end_io for storing dm_io list
+		 */
+		io->saved_bio_end_io = bio->bi_end_io;
+
+		INIT_HLIST_HEAD(dm_get_bio_hlist_head(bio));
+
+		/* tell block layer to poll for completion */
+		bio->bi_cookie = ~BLK_QC_T_NONE;
+	} else {
+		/*
+		 * bio recursed due to split, reuse original poll list
+		 */
+		io->saved_bio_end_io = NULL;
+	}
+
+	hlist_add_head(&io->node, dm_get_bio_hlist_head(bio));
+}
+
 /*
  * Select the correct strategy for processing a non-flush bio.
  */
@@ -1457,6 +1511,12 @@ static int __split_and_process_bio(struct clone_info *ci)
 	if (__process_abnormal_io(ci, ti, &r))
 		return r;
 
+	/*
+	 * Only support bio polling for normal IO, and the target io is
+	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
+	 */
+	ci->submit_as_polled = ci->bio->bi_opf & REQ_POLLED;
+
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
 	__map_bio(clone);
@@ -1473,6 +1533,7 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->map = map;
 	ci->io = alloc_io(md, bio);
 	ci->bio = bio;
+	ci->submit_as_polled = false;
 	ci->sector = bio->bi_iter.bi_sector;
 	ci->sector_count = bio_sectors(bio);
 
@@ -1522,8 +1583,17 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (ci.io->start_io_acct)
 		dm_start_io_acct(ci.io, NULL);
 
-	/* drop the extra reference count */
-	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
+	/*
+	 * Drop the extra reference count for non-POLLED bio, and hold one
+	 * reference for POLLED bio, which will be released in dm_poll_bio
+	 *
+	 * Add every dm_io instance into the hlist_head which is stored in
+	 * bio->bi_end_io, so that dm_poll_bio can poll them all.
+	 */
+	if (error || !ci.submit_as_polled)
+		dm_io_dec_pending(ci.io, errno_to_blk_status(error));
+	else
+		dm_queue_poll_io(bio, ci.io);
 }
 
 static void dm_submit_bio(struct bio *bio)
@@ -1558,6 +1628,79 @@ static void dm_submit_bio(struct bio *bio)
 	dm_put_live_table(md, srcu_idx);
 }
 
+static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
+			  unsigned int flags)
+{
+	WARN_ON_ONCE(!io->tio.inside_dm_io);
+
+	/* don't poll if the mapped io is done */
+	if (atomic_read(&io->io_count) > 1)
+		bio_poll(&io->tio.clone, iob, flags);
+
+	/* bio_poll holds the last reference */
+	return atomic_read(&io->io_count) == 1;
+}
+
+static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
+		       unsigned int flags)
+{
+	struct hlist_head *head = dm_get_bio_hlist_head(bio);
+	struct hlist_head tmp = HLIST_HEAD_INIT;
+	void *saved_bio_end_io = NULL;
+	struct hlist_node *next;
+	struct dm_io *io;
+
+	/* Only poll normal bio which was marked as REQ_DM_POLL_LIST */
+	if (!(bio->bi_opf & REQ_DM_POLL_LIST))
+		return 0;
+
+	WARN_ON_ONCE(hlist_empty(head));
+
+	hlist_move_list(head, &tmp);
+
+	hlist_for_each_entry(io, &tmp, node) {
+		if (io->saved_bio_end_io) {
+			saved_bio_end_io = io->saved_bio_end_io;
+			break;
+		}
+	}
+
+	/*
+	 * Restore .bi_end_io before possibly completing dm_io.
+	 *
+	 * bio_poll() is only possible once @bio has been completely
+	 * submitted via submit_bio_noacct()'s depth-first submission.
+	 * So there is no dm_queue_poll_io() race associated with
+	 * clearing REQ_DM_POLL_LIST here.
+	 */
+	WARN_ON_ONCE(!saved_bio_end_io);
+	bio->bi_opf &= ~REQ_DM_POLL_LIST;
+	bio->bi_end_io = saved_bio_end_io;
+
+	hlist_for_each_entry_safe(io, next, &tmp, node) {
+		if (dm_poll_dm_io(io, iob, flags)) {
+			hlist_del_init(&io->node);
+			/*
+			 * clone_endio() has already occurred, so passing
+			 * error as 0 here doesn't override io->status
+			 */
+			dm_io_dec_pending(io, 0);
+		}
+	}
+
+	/* Not done? */
+	if (!hlist_empty(&tmp)) {
+		/* Store saved_bio_end_io in a remaining dm_io */
+		io = hlist_entry(tmp.first, struct dm_io, node);
+		io->saved_bio_end_io = saved_bio_end_io;
+		bio->bi_opf |= REQ_DM_POLL_LIST;
+		/* Reset bio->bi_end_io to dm_io list head */
+		hlist_move_list(&tmp, head);
+		return 0;
+	}
+	return 1;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -2983,6 +3126,7 @@ static const struct pr_ops dm_pr_ops = {
 
 static const struct block_device_operations dm_blk_dops = {
 	.submit_bio = dm_submit_bio,
+	.poll_bio = dm_poll_bio,
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

