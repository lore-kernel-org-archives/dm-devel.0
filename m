Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A134C433B4
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF2C461182
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF2C461182
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-3NGVZ7x5MpuvKVQj_JYJ6g-1; Fri, 09 Apr 2021 07:48:37 -0400
X-MC-Unique: 3NGVZ7x5MpuvKVQj_JYJ6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E59D9107ACF3;
	Fri,  9 Apr 2021 11:48:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D23F718A50;
	Fri,  9 Apr 2021 11:48:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D2661806D0F;
	Fri,  9 Apr 2021 11:48:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139BmU42000931 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 07:48:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E8E121493D9; Fri,  9 Apr 2021 11:48:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 191AB21493D8
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92C78101A531
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:27 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-217-d7YMOkHuPJOvT53SaEjXHA-1;
	Fri, 09 Apr 2021 07:48:25 -0400
X-MC-Unique: d7YMOkHuPJOvT53SaEjXHA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id D468F42280;
	Fri,  9 Apr 2021 07:48:21 -0400 (EDT)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 9 Apr 2021 13:48:18 +0200
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 9 Apr 2021 14:48:02 +0300
Message-ID: <1617968884-15149-3-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
References: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B59657262
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v8 2/4] Adds the blk_interposers logic to
	__submit_bio_noacct().
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

* The calling to blk_partition_remap() function has moved
from submit_bio_checks() to submit_bio_noacct().
* The __submit_bio() and __submit_bio_noacct_mq() functions
have been removed and their functionality moved to
submit_bio_noacct().
* Added locking of the block device queue using
the bd_interposer_lock.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 block/bio.c      |   2 +
 block/blk-core.c | 194 ++++++++++++++++++++++++++---------------------
 2 files changed, 108 insertions(+), 88 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 50e579088aca..6fc9e8f395a6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -640,6 +640,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 		bio_set_flag(bio, BIO_THROTTLED);
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
+	if (bio_flagged(bio_src, BIO_INTERPOSED))
+		bio_set_flag(bio, BIO_INTERPOSED);
 	bio->bi_opf = bio_src->bi_opf;
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff208497..a987daa76a79 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -735,26 +735,27 @@ static inline int bio_check_eod(struct bio *bio)
 		handle_bad_sector(bio, maxsector);
 		return -EIO;
 	}
+
+	if (unlikely(should_fail_request(bio->bi_bdev, bio->bi_iter.bi_size)))
+		return -EIO;
+
 	return 0;
 }
 
 /*
  * Remap block n of partition p to block n+start(p) of the disk.
  */
-static int blk_partition_remap(struct bio *bio)
+static inline void blk_partition_remap(struct bio *bio)
 {
-	struct block_device *p = bio->bi_bdev;
+	struct block_device *bdev = bio->bi_bdev;
 
-	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
-		return -EIO;
-	if (bio_sectors(bio)) {
-		bio->bi_iter.bi_sector += p->bd_start_sect;
-		trace_block_bio_remap(bio, p->bd_dev,
+	if (bdev->bd_partno && bio_sectors(bio)) {
+		bio->bi_iter.bi_sector += bdev->bd_start_sect;
+		trace_block_bio_remap(bio, bdev->bd_dev,
 				      bio->bi_iter.bi_sector -
-				      p->bd_start_sect);
+				      bdev->bd_start_sect);
 	}
 	bio_set_flag(bio, BIO_REMAPPED);
-	return 0;
 }
 
 /*
@@ -819,8 +820,6 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	if (!bio_flagged(bio, BIO_REMAPPED)) {
 		if (unlikely(bio_check_eod(bio)))
 			goto end_io;
-		if (bdev->bd_partno && unlikely(blk_partition_remap(bio)))
-			goto end_io;
 	}
 
 	/*
@@ -910,20 +909,6 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	return false;
 }
 
-static blk_qc_t __submit_bio(struct bio *bio)
-{
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	blk_qc_t ret = BLK_QC_T_NONE;
-
-	if (blk_crypto_bio_prep(&bio)) {
-		if (!disk->fops->submit_bio)
-			return blk_mq_submit_bio(bio);
-		ret = disk->fops->submit_bio(bio);
-	}
-	blk_queue_exit(disk->queue);
-	return ret;
-}
-
 /*
  * The loop in this function may be a bit non-obvious, and so deserves some
  * explanation:
@@ -931,7 +916,7 @@ static blk_qc_t __submit_bio(struct bio *bio)
  *  - Before entering the loop, bio->bi_next is NULL (as all callers ensure
  *    that), so we have a list with a single bio.
  *  - We pretend that we have just taken it off a longer list, so we assign
- *    bio_list to a pointer to the bio_list_on_stack, thus initialising the
+ *    bio_list to a pointer to the current->bio_list, thus initialising the
  *    bio_list of new bios to be added.  ->submit_bio() may indeed add some more
  *    bios through a recursive call to submit_bio_noacct.  If it did, we find a
  *    non-NULL value in bio_list and re-enter the loop from the top.
@@ -939,83 +924,75 @@ static blk_qc_t __submit_bio(struct bio *bio)
  *    pretending) and so remove it from bio_list, and call into ->submit_bio()
  *    again.
  *
- * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
- * bio_list_on_stack[1] contains bios that were submitted before the current
+ * current->bio_list[0] contains bios submitted by the current ->submit_bio.
+ * current->bio_list[1] contains bios that were submitted before the current
  *	->submit_bio_bio, but that haven't been processed yet.
  */
 static blk_qc_t __submit_bio_noacct(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack[2];
-	blk_qc_t ret = BLK_QC_T_NONE;
-
-	BUG_ON(bio->bi_next);
-
-	bio_list_init(&bio_list_on_stack[0]);
-	current->bio_list = bio_list_on_stack;
-
-	do {
-		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
-		struct bio_list lower, same;
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct bio_list lower, same;
+	blk_qc_t ret;
 
-		if (unlikely(bio_queue_enter(bio) != 0))
-			continue;
+	if (!blk_crypto_bio_prep(&bio)) {
+		blk_queue_exit(disk->queue);
+		return BLK_QC_T_NONE;
+	}
 
-		/*
-		 * Create a fresh bio_list for all subordinate requests.
-		 */
-		bio_list_on_stack[1] = bio_list_on_stack[0];
-		bio_list_init(&bio_list_on_stack[0]);
+	if (queue_is_mq(disk->queue))
+		return blk_mq_submit_bio(bio);
 
-		ret = __submit_bio(bio);
+	/*
+	 * Create a fresh bio_list for all subordinate requests.
+	 */
+	current->bio_list[1] = current->bio_list[0];
+	bio_list_init(&current->bio_list[0]);
 
-		/*
-		 * Sort new bios into those for a lower level and those for the
-		 * same level.
-		 */
-		bio_list_init(&lower);
-		bio_list_init(&same);
-		while ((bio = bio_list_pop(&bio_list_on_stack[0])) != NULL)
-			if (q == bio->bi_bdev->bd_disk->queue)
-				bio_list_add(&same, bio);
-			else
-				bio_list_add(&lower, bio);
+	WARN_ON_ONCE(!disk->fops->submit_bio);
+	ret = disk->fops->submit_bio(bio);
+	blk_queue_exit(disk->queue);
+	/*
+	 * Sort new bios into those for a lower level and those
+	 * for the same level.
+	 */
+	bio_list_init(&lower);
+	bio_list_init(&same);
+	while ((bio = bio_list_pop(&current->bio_list[0])) != NULL)
+		if (disk->queue == bio->bi_bdev->bd_disk->queue)
+			bio_list_add(&same, bio);
+		else
+			bio_list_add(&lower, bio);
 
-		/*
-		 * Now assemble so we handle the lowest level first.
-		 */
-		bio_list_merge(&bio_list_on_stack[0], &lower);
-		bio_list_merge(&bio_list_on_stack[0], &same);
-		bio_list_merge(&bio_list_on_stack[0], &bio_list_on_stack[1]);
-	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
+	/*
+	 * Now assemble so we handle the lowest level first.
+	 */
+	bio_list_merge(&current->bio_list[0], &lower);
+	bio_list_merge(&current->bio_list[0], &same);
+	bio_list_merge(&current->bio_list[0], &current->bio_list[1]);
 
-	current->bio_list = NULL;
 	return ret;
 }
 
-static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
+static inline struct block_device *bio_interposer_lock(struct bio *bio)
 {
-	struct bio_list bio_list[2] = { };
-	blk_qc_t ret = BLK_QC_T_NONE;
-
-	current->bio_list = bio_list;
-
-	do {
-		struct gendisk *disk = bio->bi_bdev->bd_disk;
-
-		if (unlikely(bio_queue_enter(bio) != 0))
-			continue;
+	bool locked;
+	struct block_device *bdev = bio->bi_bdev;
 
-		if (!blk_crypto_bio_prep(&bio)) {
-			blk_queue_exit(disk->queue);
-			ret = BLK_QC_T_NONE;
-			continue;
+	if (bio->bi_opf & REQ_NOWAIT) {
+		locked = percpu_down_read_trylock(&bdev->bd_interposer_lock);
+		if (unlikely(!locked)) {
+			bio_wouldblock_error(bio);
+			return NULL;
 		}
+	} else
+		percpu_down_read(&bdev->bd_interposer_lock);
 
-		ret = blk_mq_submit_bio(bio);
-	} while ((bio = bio_list_pop(&bio_list[0])));
+	return bdev;
+}
 
-	current->bio_list = NULL;
-	return ret;
+static inline void bio_interposer_unlock(struct block_device *locked_bdev)
+{
+	percpu_up_read(&locked_bdev->bd_interposer_lock);
 }
 
 /**
@@ -1029,6 +1006,10 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
  */
 blk_qc_t submit_bio_noacct(struct bio *bio)
 {
+	struct block_device *locked_bdev;
+	struct bio_list bio_list_on_stack[2] = { };
+	blk_qc_t ret = BLK_QC_T_NONE;
+
 	if (!submit_bio_checks(bio))
 		return BLK_QC_T_NONE;
 
@@ -1043,9 +1024,46 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
-		return __submit_bio_noacct_mq(bio);
-	return __submit_bio_noacct(bio);
+	BUG_ON(bio->bi_next);
+
+	locked_bdev = bio_interposer_lock(bio);
+	if (!locked_bdev)
+		return BLK_QC_T_NONE;
+
+	current->bio_list = bio_list_on_stack;
+
+	do {
+		if (unlikely(bio_queue_enter(bio) != 0)) {
+			ret = BLK_QC_T_NONE;
+			continue;
+		}
+
+		if (!bio_flagged(bio, BIO_INTERPOSED) &&
+		    bio->bi_bdev->bd_interposer) {
+			struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+			bio_set_dev(bio, bio->bi_bdev->bd_interposer);
+			bio_set_flag(bio, BIO_INTERPOSED);
+
+			bio_list_add(&bio_list_on_stack[0], bio);
+
+			blk_queue_exit(disk->queue);
+			ret = BLK_QC_T_NONE;
+			continue;
+		}
+
+		if (!bio_flagged(bio, BIO_REMAPPED))
+			blk_partition_remap(bio);
+
+		ret = __submit_bio_noacct(bio);
+
+	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
+
+	current->bio_list = NULL;
+
+	bio_interposer_unlock(locked_bdev);
+
+	return ret;
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

