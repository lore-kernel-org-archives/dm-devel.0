Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1ABC61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 19:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675365301;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BC2RfMtbUANVMujDDKbpsEQ38ZyLsBFaH11/uYy0c+s=;
	b=DTeh4RgxUdUVBfJDKE9pODa+dXk+QVALnu+SilzYlxyUjBEF6KNOxmH7iPBBM/vf46ICsP
	3uruPxuPpXtUbDCyiNC5oUVtNJtmCBcSVI9xhuU7hbRBEyYTvfDArq7nRpFuUysGn1mBFY
	agZ1R180KCzP+t0J3JZ6MRKe8Vo3wEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-haf6uuZSNtaTaCfntwVFOg-1; Thu, 02 Feb 2023 14:15:00 -0500
X-MC-Unique: haf6uuZSNtaTaCfntwVFOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC481811E6E;
	Thu,  2 Feb 2023 19:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92FA2404CD80;
	Thu,  2 Feb 2023 19:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 67D53194658C;
	Thu,  2 Feb 2023 19:14:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EBBAA1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 19:14:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBB02492B01; Thu,  2 Feb 2023 19:14:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D37EA492C3E
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:14:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFFB5800B24
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:14:56 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-pTxQO8AQO4OUyNwOzwBy5A-1; Thu, 02 Feb 2023 14:14:55 -0500
X-MC-Unique: pTxQO8AQO4OUyNwOzwBy5A-1
Received: from [2001:4bb8:19a:272a:3196:5eba:213b:e6aa] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1pNe6L-00Gv80-Qb; Thu, 02 Feb 2023 18:14:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Date: Thu,  2 Feb 2023 19:14:23 +0100
Message-Id: <20230202181423.2910619-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] block: remove submit_bio_noacct
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
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The current usage of submit_bio vs submit_bio_noacct which skips the
VM events and task account is a bit unclear.  It seems to be mostly
intended for sending on bios received by stacking drivers, but also
seems to be used for stacking drivers newly generated metadata
sometimes.

Remove the separate API and just skip the accounting if submit_bio
is called recursively.  This gets us an accounting behavior that
is very similar (but not quite identical) to the current one, while
simplifying the API and code base.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../fault-injection/fault-injection.rst       |  2 +-
 Documentation/trace/ftrace.rst                |  2 -
 block/bio.c                                   | 14 +--
 block/blk-core.c                              | 92 ++++++++-----------
 block/blk-crypto-fallback.c                   |  2 +-
 block/blk-crypto.c                            |  2 +-
 block/blk-merge.c                             |  2 +-
 block/blk-throttle.c                          |  2 +-
 block/blk.h                                   |  2 +-
 block/bounce.c                                |  2 +-
 drivers/block/drbd/drbd_int.h                 |  2 +-
 drivers/block/drbd/drbd_main.c                |  2 +-
 drivers/block/drbd/drbd_req.c                 |  2 +-
 drivers/block/drbd/drbd_worker.c              |  2 +-
 drivers/block/pktcdvd.c                       |  2 +-
 drivers/md/bcache/bcache.h                    |  2 +-
 drivers/md/bcache/btree.c                     |  2 +-
 drivers/md/bcache/request.c                   |  6 +-
 drivers/md/dm-clone-target.c                  | 10 +-
 drivers/md/dm-era-target.c                    |  2 +-
 drivers/md/dm-integrity.c                     |  4 +-
 drivers/md/dm-mpath.c                         |  2 +-
 drivers/md/dm-raid1.c                         |  2 +-
 drivers/md/dm-snap-persistent.c               |  2 +-
 drivers/md/dm-snap.c                          |  6 +-
 drivers/md/dm-verity-target.c                 |  2 +-
 drivers/md/dm-writecache.c                    |  2 +-
 drivers/md/dm-zoned-target.c                  |  2 +-
 drivers/md/dm.c                               | 10 +-
 drivers/md/md-faulty.c                        |  4 +-
 drivers/md/md-linear.c                        |  4 +-
 drivers/md/md-multipath.c                     |  4 +-
 drivers/md/md.c                               |  2 +-
 drivers/md/raid0.c                            |  6 +-
 drivers/md/raid1.c                            | 14 +--
 drivers/md/raid10.c                           | 32 +++----
 drivers/md/raid5.c                            | 10 +-
 drivers/nvme/host/multipath.c                 |  4 +-
 include/linux/blkdev.h                        |  2 +-
 39 files changed, 127 insertions(+), 141 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 5f6454b9dbd4d9..6e326b2117b6e0 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -32,7 +32,7 @@ Available fault injection capabilities
 
   injects disk IO errors on devices permitted by setting
   /sys/block/<device>/make-it-fail or
-  /sys/block/<device>/<partition>/make-it-fail. (submit_bio_noacct())
+  /sys/block/<device>/<partition>/make-it-fail. (submit_bio())
 
 - fail_mmc_request
 
diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index 21f01d32c95985..310248593225bf 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -1471,7 +1471,6 @@ function-trace, we get a much larger output::
    => __blk_run_queue_uncond
    => __blk_run_queue
    => blk_queue_bio
-   => submit_bio_noacct
    => submit_bio
    => submit_bh
    => __ext3_get_inode_loc
@@ -1756,7 +1755,6 @@ tracers.
    => __blk_run_queue_uncond
    => __blk_run_queue
    => blk_queue_bio
-   => submit_bio_noacct
    => submit_bio
    => submit_bh
    => ext3_bread
diff --git a/block/bio.c b/block/bio.c
index d7fbc7adfc50aa..ea143fd825d768 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -373,7 +373,7 @@ static void bio_alloc_rescue(struct work_struct *work)
 		if (!bio)
 			break;
 
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 }
 
@@ -473,19 +473,19 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
  * previously allocated bio for IO before attempting to allocate a new one.
  * Failure to do so can cause deadlocks under memory pressure.
  *
- * Note that when running under submit_bio_noacct() (i.e. any block driver),
+ * Note that when running under submit_bio() (i.e. any block driver),
  * bios are not submitted until after you return - see the code in
- * submit_bio_noacct() that converts recursion into iteration, to prevent
+ * submit_bio() that converts recursion into iteration, to prevent
  * stack overflows.
  *
- * This would normally mean allocating multiple bios under submit_bio_noacct()
+ * This would normally mean allocating multiple bios under submit_bio()
  * would be susceptible to deadlocks, but we have
  * deadlock avoidance code that resubmits any blocked bios from a rescuer
  * thread.
  *
  * However, we do not guarantee forward progress for allocations from other
  * mempools. Doing multiple allocations from the same mempool under
- * submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
+ * submit_bio() should be avoided - instead, use bio_set's front_pad
  * for per bio allocations.
  *
  * Returns: Pointer to new bio on success, NULL on failure.
@@ -518,12 +518,12 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	}
 
 	/*
-	 * submit_bio_noacct() converts recursion to iteration; this means if
+	 * submit_bio() converts recursion to iteration; this means if
 	 * we're running beneath it, any bios we allocate and submit will not be
 	 * submitted (and thus freed) until after we return.
 	 *
 	 * This exposes us to a potential deadlock if we allocate multiple bios
-	 * from the same bio_set() while running underneath submit_bio_noacct().
+	 * from the same bio_set() while running underneath submit_bio().
 	 * If we were to allocate multiple bios (say a stacking block driver
 	 * that was splitting bios), we would deadlock if we exhausted the
 	 * mempool's reserve.
diff --git a/block/blk-core.c b/block/blk-core.c
index ccf9a7683a3cc7..6423bd4104a0a3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -615,7 +615,7 @@ static void __submit_bio(struct bio *bio)
  *  - We pretend that we have just taken it off a longer list, so we assign
  *    bio_list to a pointer to the bio_list_on_stack, thus initialising the
  *    bio_list of new bios to be added.  ->submit_bio() may indeed add some more
- *    bios through a recursive call to submit_bio_noacct.  If it did, we find a
+ *    bios through a recursive call to submit_bio.  If it did, we find a
  *    non-NULL value in bio_list and re-enter the loop from the top.
  *  - In this case we really did just take the bio of the top of the list (no
  *    pretending) and so remove it from bio_list, and call into ->submit_bio()
@@ -625,7 +625,7 @@ static void __submit_bio(struct bio *bio)
  * bio_list_on_stack[1] contains bios that were submitted before the current
  *	->submit_bio, but that haven't been processed yet.
  */
-static void __submit_bio_noacct(struct bio *bio)
+static void __submit_bio_nocheck(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack[2];
 
@@ -669,7 +669,7 @@ static void __submit_bio_noacct(struct bio *bio)
 	current->bio_list = NULL;
 }
 
-static void __submit_bio_noacct_mq(struct bio *bio)
+static void __submit_bio_nocheck_mq(struct bio *bio)
 {
 	struct bio_list bio_list[2] = { };
 
@@ -682,32 +682,28 @@ static void __submit_bio_noacct_mq(struct bio *bio)
 	current->bio_list = NULL;
 }
 
-void submit_bio_noacct_nocheck(struct bio *bio)
+void submit_bio_nocheck(struct bio *bio)
 {
-	/*
-	 * We only want one ->submit_bio to be active at a time, else stack
-	 * usage with stacked devices could be a problem.  Use current->bio_list
-	 * to collect a list of requests submited by a ->submit_bio method while
-	 * it is active, and then process them after it returned.
-	 */
-	if (current->bio_list)
-		bio_list_add(&current->bio_list[0], bio);
-	else if (!bio->bi_bdev->bd_disk->fops->submit_bio)
-		__submit_bio_noacct_mq(bio);
+	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
+		__submit_bio_nocheck_mq(bio);
 	else
-		__submit_bio_noacct(bio);
+		__submit_bio_nocheck(bio);
 }
 
 /**
- * submit_bio_noacct - re-submit a bio to the block device layer for I/O
- * @bio:  The bio describing the location in memory and on the device.
+ * submit_bio - submit a bio to the block device layer for I/O
+ * @bio: The &struct bio which describes the I/O
  *
- * This is a version of submit_bio() that shall only be used for I/O that is
- * resubmitted to lower level drivers by stacking block drivers.  All file
- * systems and other upper level users of the block layer should use
- * submit_bio() instead.
+ * submit_bio() is used to submit I/O requests to block devices.  It is passed a
+ * fully set up &struct bio that describes the I/O that needs to be done.  The
+ * bio will be send to the device described by the bi_bdev field.
+ *
+ * The success/failure status of the request, along with notification of
+ * completion, is delivered asynchronously through the ->bi_end_io() callback
+ * in @bio.  The bio must NOT be touched by the caller until ->bi_end_io() has
+ * been called.
  */
-void submit_bio_noacct(struct bio *bio)
+void submit_bio(struct bio *bio)
 {
 	struct block_device *bdev = bio->bi_bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
@@ -716,6 +712,27 @@ void submit_bio_noacct(struct bio *bio)
 
 	might_sleep();
 
+	/*
+	 * We only want one ->submit_bio to be active at a time, else stack
+	 * usage with stacked devices could be a problem.  Use current->bio_list
+	 * to collect a list of requests submited by a ->submit_bio method while
+	 * it is active, and then process them after it returned.
+	 */
+	if (current->bio_list) {
+		bio_list_add(&current->bio_list[0], bio);
+		return;
+	}
+
+	if (blkcg_punt_bio_submit(bio))
+		return;
+
+	if (bio_op(bio) == REQ_OP_READ) {
+		task_io_account_read(bio->bi_iter.bi_size);
+		count_vm_events(PGPGIN, bio_sectors(bio));
+	} else if (bio_op(bio) == REQ_OP_WRITE) {
+		count_vm_events(PGPGOUT, bio_sectors(bio));
+	}
+
 	plug = blk_mq_plug(bio);
 	if (plug && plug->nowait)
 		bio->bi_opf |= REQ_NOWAIT;
@@ -799,7 +816,7 @@ void submit_bio_noacct(struct bio *bio)
 		 */
 		bio_set_flag(bio, BIO_TRACE_COMPLETION);
 	}
-	submit_bio_noacct_nocheck(bio);
+	submit_bio_nocheck(bio);
 	return;
 
 not_supported:
@@ -808,35 +825,6 @@ void submit_bio_noacct(struct bio *bio)
 	bio->bi_status = status;
 	bio_endio(bio);
 }
-EXPORT_SYMBOL(submit_bio_noacct);
-
-/**
- * submit_bio - submit a bio to the block device layer for I/O
- * @bio: The &struct bio which describes the I/O
- *
- * submit_bio() is used to submit I/O requests to block devices.  It is passed a
- * fully set up &struct bio that describes the I/O that needs to be done.  The
- * bio will be send to the device described by the bi_bdev field.
- *
- * The success/failure status of the request, along with notification of
- * completion, is delivered asynchronously through the ->bi_end_io() callback
- * in @bio.  The bio must NOT be touched by the caller until ->bi_end_io() has
- * been called.
- */
-void submit_bio(struct bio *bio)
-{
-	if (blkcg_punt_bio_submit(bio))
-		return;
-
-	if (bio_op(bio) == REQ_OP_READ) {
-		task_io_account_read(bio->bi_iter.bi_size);
-		count_vm_events(PGPGIN, bio_sectors(bio));
-	} else if (bio_op(bio) == REQ_OP_WRITE) {
-		count_vm_events(PGPGOUT, bio_sectors(bio));
-	}
-
-	submit_bio_noacct(bio);
-}
 EXPORT_SYMBOL(submit_bio);
 
 /**
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index ad9844c5b40cb8..1d98d82c42edaf 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -230,7 +230,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 			return false;
 		}
 		bio_chain(split_bio, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		*bio_ptr = split_bio;
 	}
 
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 45378586151f78..0ae8cf8408cd56 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -259,7 +259,7 @@ void __blk_crypto_free_request(struct request *rq)
  * kernel crypto API. When the crypto API fallback is used for encryption,
  * blk-crypto may choose to split the bio into 2 - the first one that will
  * continue to be processed and the second one that will be resubmitted via
- * submit_bio_noacct. A bounce bio will be allocated to encrypt the contents
+ * submit_bio. A bounce bio will be allocated to encrypt the contents
  * of the aforementioned "first one", and *bio_ptr will be updated to this
  * bounce bio.
  *
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b7c193d67185de..4fd8e58664ad6b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -380,7 +380,7 @@ struct bio *__bio_split_to_limits(struct bio *bio,
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
 		trace_block_split(split, bio->bi_iter.bi_sector);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		return split;
 	}
 	return bio;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6fb5a2f9e1eed5..ab8993f1f13777 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1263,7 +1263,7 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	if (!bio_list_empty(&bio_list_on_stack)) {
 		blk_start_plug(&plug);
 		while ((bio = bio_list_pop(&bio_list_on_stack)))
-			submit_bio_noacct_nocheck(bio);
+			submit_bio_nocheck(bio);
 		blk_finish_plug(&plug);
 	}
 }
diff --git a/block/blk.h b/block/blk.h
index 4c3b3325219a5b..1df6cac3a3bc44 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -36,7 +36,7 @@ void blk_freeze_queue(struct request_queue *q);
 void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 void blk_queue_start_drain(struct request_queue *q);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
-void submit_bio_noacct_nocheck(struct bio *bio);
+void submit_bio_nocheck(struct bio *bio);
 
 static inline bool blk_try_enter_queue(struct request_queue *q, bool pm)
 {
diff --git a/block/bounce.c b/block/bounce.c
index 7cfcb242f9a112..1a5ef7626d6eb8 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -228,7 +228,7 @@ struct bio *__blk_queue_bounce(struct bio *bio_orig, struct request_queue *q)
 	if (sectors < bio_sectors(bio_orig)) {
 		bio = bio_split(bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, bio_orig);
-		submit_bio_noacct(bio_orig);
+		submit_bio(bio_orig);
 		bio_orig = bio;
 	}
 	bio = bounce_clone_bio(bio_orig);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d89b7d03d4c8d8..6fd500fe80d494 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1512,7 +1512,7 @@ static inline void drbd_submit_bio_noacct(struct drbd_device *device,
 	if (drbd_insert_fault(device, fault_type))
 		bio_io_error(bio);
 	else
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 }
 
 void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backing_dev *bdev,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2c764f7ee4a724..5db6e05012796a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2278,7 +2278,7 @@ static void do_retry(struct work_struct *ws)
 		 * workqueues instead.
 		 */
 
-		/* We are not just doing submit_bio_noacct(),
+		/* We are not just doing submit_bio(),
 		 * as we want to keep the start_time information. */
 		inc_ap_bio(device);
 		__drbd_make_request(device, bio);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index e36216d50753c8..205743db339b40 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1170,7 +1170,7 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 		else if (bio_op(bio) == REQ_OP_DISCARD)
 			drbd_process_discard_or_zeroes_req(req, EE_TRIM);
 		else
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		put_ldev(device);
 	} else
 		bio_io_error(bio);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f46738040d6be4..3f2fa60ac0d7b7 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1523,7 +1523,7 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 					  &drbd_io_bio_set);
 	req->private_bio->bi_private = req;
 	req->private_bio->bi_end_io = drbd_request_endio;
-	submit_bio_noacct(req->private_bio);
+	submit_bio(req->private_bio);
 
 	return 0;
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2f1a92509271c4..fe37452a2bda93 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -899,7 +899,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		}
 
 		atomic_inc(&pd->cdrw.pending_bios);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 }
 
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e631a..de323e1d502589 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -940,7 +940,7 @@ static inline void closure_bio_submit(struct cache_set *c,
 		bio_endio(bio);
 		return;
 	}
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 }
 
 /*
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a5e..68fae4d9b61b03 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -970,7 +970,7 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
  * bch_btree_node_get - find a btree node in the cache and lock it, reading it
  * in from disk if necessary.
  *
- * If IO is necessary and running under submit_bio_noacct, returns -EAGAIN.
+ * If IO is necessary and running under submit_bio, returns -EAGAIN.
  *
  * The btree node will have either a read or a write lock held, depending on
  * level and op->lock.
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 67a2e29e0b40e0..51ad92476f547d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1124,7 +1124,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	    !bdev_max_discard_sectors(dc->bdev))
 		bio->bi_end_io(bio);
 	else
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 }
 
 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1210,7 +1210,7 @@ void cached_dev_submit_bio(struct bio *bio)
 		if (!bio->bi_iter.bi_size) {
 			/*
 			 * can't call bch_journal_meta from under
-			 * submit_bio_noacct
+			 * submit_bio
 			 */
 			continue_at_nobarrier(&s->cl,
 					      cached_dev_nodata,
@@ -1295,7 +1295,7 @@ void flash_dev_submit_bio(struct bio *bio)
 
 	if (!bio->bi_iter.bi_size) {
 		/*
-		 * can't call bch_journal_meta from under submit_bio_noacct
+		 * can't call bch_journal_meta from under submit_bio
 		 */
 		continue_at_nobarrier(&s->cl,
 				      flash_dev_nodata,
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 29e0b85eeaf090..f18f9ec141755c 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -323,7 +323,7 @@ static void submit_bios(struct bio_list *bios)
 	blk_start_plug(&plug);
 
 	while ((bio = bio_list_pop(bios)))
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 
 	blk_finish_plug(&plug);
 }
@@ -339,7 +339,7 @@ static void submit_bios(struct bio_list *bios)
 static void issue_bio(struct clone *clone, struct bio *bio)
 {
 	if (!bio_triggers_commit(clone, bio)) {
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		return;
 	}
 
@@ -466,7 +466,7 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 		bio_region_range(clone, bio, &rs, &nr_regions);
 		trim_bio(bio, region_to_sector(clone, rs),
 			 nr_regions << clone->region_shift);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	} else
 		bio_endio(bio);
 }
@@ -858,7 +858,7 @@ static void hydration_overwrite(struct dm_clone_region_hydration *hd, struct bio
 	bio->bi_private = hd;
 
 	atomic_inc(&hd->clone->hydrations_in_flight);
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 }
 
 /*
@@ -1270,7 +1270,7 @@ static void process_deferred_flush_bios(struct clone *clone)
 			 */
 			bio_endio(bio);
 		} else {
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		}
 	}
 }
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index e92c1afc3677fe..6ef471ae9b2cf1 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1293,7 +1293,7 @@ static void process_deferred_bios(struct era *era)
 			 */
 			if (commit_needed)
 				set_bit(get_block(era, bio), ws->bits);
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		}
 		blk_finish_plug(&plug);
 	}
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1388ee35571e0a..0654daa6eb0df2 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2284,12 +2284,12 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 		dio->in_flight = (atomic_t)ATOMIC_INIT(1);
 		dio->completion = NULL;
 
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 
 		return;
 	}
 
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e325469a252a3..e440d8ede3017b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -719,7 +719,7 @@ static void process_queued_bios(struct work_struct *work)
 			bio_endio(bio);
 			break;
 		case DM_MAPIO_REMAPPED:
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 			break;
 		case DM_MAPIO_SUBMITTED:
 			break;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 06a38dc3202537..1fa26d9caeed35 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -777,7 +777,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 			wakeup_mirrord(ms);
 		} else {
 			map_bio(get_default_mirror(ms), bio);
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		}
 	}
 }
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 680cc05ec6542e..fe7155b4320279 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -251,7 +251,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, blk_opf_t opf,
 
 	/*
 	 * Issue the synchronous I/O from a different thread
-	 * to avoid submit_bio_noacct recursion.
+	 * to avoid submit_bio recursion.
 	 */
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index d1c2f84d27e364..76b7c799f48500 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1575,7 +1575,7 @@ static void flush_bios(struct bio *bio)
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = n;
 	}
 }
@@ -1595,7 +1595,7 @@ static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
 		bio->bi_next = NULL;
 		r = do_origin(s->origin, bio, false);
 		if (r == DM_MAPIO_REMAPPED)
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		bio = n;
 	}
 }
@@ -1836,7 +1836,7 @@ static void start_full_bio(struct dm_snap_pending_exception *pe,
 	bio->bi_end_io = full_bio_end_io;
 	bio->bi_private = callback_data;
 
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 }
 
 static struct dm_snap_pending_exception *
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index ccf5b852fbf7a7..c8676dd08fb415 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -780,7 +780,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 
 	verity_submit_prefetch(v, io);
 
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 
 	return DM_MAPIO_SUBMITTED;
 }
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 96a003eb732341..430ac6d0d3830e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1297,7 +1297,7 @@ static int writecache_flush_thread(void *data)
 					   bio_end_sector(bio));
 			wc_unlock(wc);
 			bio_set_dev(bio, wc->dev->bdev);
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		} else {
 			writecache_flush(wc);
 			wc_unlock(wc);
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f3323..69bb2d4538d844 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -139,7 +139,7 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
 	bio_advance(bio, clone->bi_iter.bi_size);
 
 	refcount_inc(&bioctx->ref);
-	submit_bio_noacct(clone);
+	submit_bio(clone);
 
 	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
 		zone->wp_block += nr_blocks;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b424a6ee27baf2..538b514b5a8468 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1365,7 +1365,7 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 
 	trace_block_bio_remap(tgt_clone, disk_devt(io->md->disk),
 			      tio->old_sector);
-	submit_bio_noacct(tgt_clone);
+	submit_bio(tgt_clone);
 }
 EXPORT_SYMBOL_GPL(dm_submit_bio_remap);
 
@@ -1759,13 +1759,13 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (error || !ci.sector_count)
 		goto out;
 	/*
-	 * Remainder must be passed to submit_bio_noacct() so it gets handled
+	 * Remainder must be passed to submit_bio() so it gets handled
 	 * *after* bios already submitted have been completely processed.
 	 */
 	bio_trim(bio, io->sectors, ci.sector_count);
 	trace_block_split(bio, bio->bi_iter.bi_sector);
 	bio_inc_remaining(bio);
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 out:
 	/*
 	 * Drop the extra reference count for non-POLLED bio, and hold one
@@ -1843,7 +1843,7 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
 	 * Restore .bi_private before possibly completing dm_io.
 	 *
 	 * bio_poll() is only possible once @bio has been completely
-	 * submitted via submit_bio_noacct()'s depth-first submission.
+	 * submitted via submit_bio()'s depth-first submission.
 	 * So there is no dm_queue_poll_io() race associated with
 	 * clearing REQ_DM_POLL_LIST here.
 	 */
@@ -2568,7 +2568,7 @@ static void dm_wq_work(struct work_struct *work)
 		if (!bio)
 			break;
 
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 }
 
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 50ad818978a433..c96f1fb95f9d39 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -169,7 +169,7 @@ static bool faulty_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE) {
 		/* write request */
 		if (atomic_read(&conf->counters[WriteAll])) {
-			/* special case - don't decrement, don't submit_bio_noacct,
+			/* special case - don't decrement, don't submit_bio,
 			 * just fail immediately
 			 */
 			bio_io_error(bio);
@@ -214,7 +214,7 @@ static bool faulty_make_request(struct mddev *mddev, struct bio *bio)
 	} else
 		bio_set_dev(bio, conf->rdev->bdev);
 
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 	return true;
 }
 
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 6e7797b4e7381a..9223b634e1e081 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -233,7 +233,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, end_sector - bio_sector,
 					      GFP_NOIO, &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 	}
 
@@ -250,7 +250,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 			trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
 					      bio_sector);
 		mddev_check_write_zeroes(mddev, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 	return true;
 
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 66edf5e72bd60b..04e5a051546531 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -127,7 +127,7 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
-	submit_bio_noacct(&mp_bh->bio);
+	submit_bio(&mp_bh->bio);
 	return true;
 }
 
@@ -319,7 +319,7 @@ static void multipathd(struct md_thread *thread)
 			bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
 			bio->bi_end_io = multipath_end_request;
 			bio->bi_private = mp_bh;
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02b0240e7c715a..37ad1dd34db74a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8590,7 +8590,7 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 		trace_block_bio_remap(discard_bio,
 				disk_devt(mddev->gendisk),
 				bio->bi_iter.bi_sector);
-	submit_bio_noacct(discard_bio);
+	submit_bio(discard_bio);
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b536befd889883..d0597f5e94f2b2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -452,7 +452,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 		end = zone->zone_end;
 	} else
@@ -547,7 +547,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 	}
 
@@ -582,7 +582,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
 				      bio_sector);
 	mddev_check_write_zeroes(mddev, bio);
-	submit_bio_noacct(bio);
+	submit_bio(bio);
 	return true;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 68a9e2d9985b2f..8fcde9e6007015 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -809,7 +809,7 @@ static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 			/* Just ignore it */
 			bio_endio(bio);
 		else
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		bio = next;
 		cond_resched();
 	}
@@ -1302,7 +1302,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
@@ -1331,7 +1331,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
 				      r1_bio->sector);
 
-	submit_bio_noacct(read_bio);
+	submit_bio(read_bio);
 }
 
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
@@ -1502,7 +1502,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
@@ -2262,7 +2262,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
-		submit_bio_noacct(wbio);
+		submit_bio(wbio);
 	}
 
 	put_sync_write_buf(r1_bio, 1);
@@ -2946,7 +2946,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				md_sync_acct_bio(bio, nr_sectors);
 				if (read_targets == 1)
 					bio->bi_opf &= ~MD_FAILFAST;
-				submit_bio_noacct(bio);
+				submit_bio(bio);
 			}
 		}
 	} else {
@@ -2955,7 +2955,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		md_sync_acct_bio(bio, nr_sectors);
 		if (read_targets == 1)
 			bio->bi_opf &= ~MD_FAILFAST;
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 	return nr_sectors;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6c66357f92f559..7999baed089012 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -919,7 +919,7 @@ static void flush_pending_writes(struct r10conf *conf)
 				/* Just ignore it */
 				bio_endio(bio);
 			else
-				submit_bio_noacct(bio);
+				submit_bio(bio);
 			bio = next;
 		}
 		blk_finish_plug(&plug);
@@ -1134,7 +1134,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 			/* Just ignore it */
 			bio_endio(bio);
 		else
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		bio = next;
 	}
 	kfree(plug);
@@ -1236,7 +1236,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
@@ -1263,7 +1263,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (mddev->gendisk)
 	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
 	                              r10_bio->sector);
-	submit_bio_noacct(read_bio);
+	submit_bio(read_bio);
 	return;
 }
 
@@ -1540,7 +1540,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
@@ -1711,7 +1711,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
-		submit_bio_noacct(split);
+		submit_bio(split);
 		wait_barrier(conf, false);
 	}
 	div_u64_rem(bio_end, stripe_size, &remainder);
@@ -1721,7 +1721,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 		bio = split;
 		wait_barrier(conf, false);
 	}
@@ -2483,7 +2483,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
 			tbio->bi_opf |= MD_FAILFAST;
 		tbio->bi_iter.bi_sector += conf->mirrors[d].rdev->data_offset;
-		submit_bio_noacct(tbio);
+		submit_bio(tbio);
 	}
 
 	/* Now write out to any replacement devices
@@ -2502,7 +2502,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
 			     bio_sectors(tbio));
-		submit_bio_noacct(tbio);
+		submit_bio(tbio);
 	}
 
 done:
@@ -2625,7 +2625,7 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	wbio = r10_bio->devs[1].bio;
 	wbio2 = r10_bio->devs[1].repl_bio;
 	/* Need to test wbio2->bi_end_io before we call
-	 * submit_bio_noacct as if the former is NULL,
+	 * submit_bio as if the former is NULL,
 	 * the latter is free to free wbio2.
 	 */
 	if (wbio2 && !wbio2->bi_end_io)
@@ -2633,13 +2633,13 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
-		submit_bio_noacct(wbio);
+		submit_bio(wbio);
 	}
 	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
 			     bio_sectors(wbio2));
-		submit_bio_noacct(wbio2);
+		submit_bio(wbio2);
 	}
 }
 
@@ -3265,7 +3265,7 @@ static void raid10_set_cluster_sync_high(struct r10conf *conf)
  * a number of r10_bio structures, one for each out-of-sync device.
  * As we setup these structures, we collect all bio's together into a list
  * which we then process collectively to add pages, and then process again
- * to pass to submit_bio_noacct.
+ * to pass to submit_bio.
  *
  * The r10_bio structures are linked using a borrowed master_bio pointer.
  * This link is counted in ->remaining.  When the r10_bio that points to NULL
@@ -3872,7 +3872,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct_bio(bio, nr_sectors);
 			bio->bi_status = 0;
-			submit_bio_noacct(bio);
+			submit_bio(bio);
 		}
 	}
 
@@ -5001,7 +5001,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	md_sync_acct_bio(read_bio, r10_bio->sectors);
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
-	submit_bio_noacct(read_bio);
+	submit_bio(read_bio);
 	sectors_done += nr_sectors;
 	if (sector_nr <= last)
 		goto read_more;
@@ -5064,7 +5064,7 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		md_sync_acct_bio(b, r10_bio->sectors);
 		atomic_inc(&r10_bio->remaining);
 		b->bi_next = NULL;
-		submit_bio_noacct(b);
+		submit_bio(b);
 	}
 	end_reshape_request(r10_bio);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2b0..27d4e9a949c649 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1025,7 +1025,7 @@ static void dispatch_bio_list(struct bio_list *tmp)
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(tmp)))
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 }
 
 static int cmp_stripe(void *priv, const struct list_head *a,
@@ -1303,7 +1303,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, bi);
 			else
-				submit_bio_noacct(bi);
+				submit_bio(bi);
 		}
 		if (rrdev) {
 			if (s->syncing || s->expanding || s->expanded
@@ -1350,7 +1350,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, rbi);
 			else
-				submit_bio_noacct(rbi);
+				submit_bio(rbi);
 		}
 		if (!rdev && !rrdev) {
 			if (op_is_write(op))
@@ -5580,7 +5580,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	if (mddev->gendisk)
 		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
 				      raid_bio->bi_iter.bi_sector);
-	submit_bio_noacct(align_bio);
+	submit_bio(align_bio);
 	return 1;
 
 out_rcu_unlock:
@@ -5599,7 +5599,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		struct r5conf *conf = mddev->private;
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
-		submit_bio_noacct(raid_bio);
+		submit_bio(raid_bio);
 		raid_bio = split;
 	}
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fc39d01e7b63be..5c1bf83160256c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -386,7 +386,7 @@ static void nvme_ns_head_submit_bio(struct bio *bio)
 		bio->bi_opf |= REQ_NVME_MPATH;
 		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	} else if (nvme_available_path(head)) {
 		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 
@@ -501,7 +501,7 @@ static void nvme_requeue_work(struct work_struct *work)
 		next = bio->bi_next;
 		bio->bi_next = NULL;
 
-		submit_bio_noacct(bio);
+		submit_bio(bio);
 	}
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b9637d63e6f024..01a8f3cc5cb474 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,7 +853,7 @@ void blk_request_module(dev_t devt);
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
-void submit_bio_noacct(struct bio *bio);
+void submit_bio(struct bio *bio);
 struct bio *bio_split_to_limits(struct bio *bio);
 
 extern int blk_lld_busy(struct request_queue *q);
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

