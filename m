Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5F9C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3E4A6137D
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3E4A6137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618482858;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GATPTje4f2zBdCA28Q0txcJpWt/R+7VwBfip6t4OIFY=;
	b=LFuwUFfsUuTWsHvKzT1h/ithUNTnAJbFarPcAX9JGRoFamxF1bwfZmkId+AFWaWMz2FzdQ
	VZIffnqVRrlF2idd0GzzC6jvIPZPUt3PHHCQitBI/Aj3EW+EsyX5LFRer021eBa74Qn4O0
	aiT/dbfmTu7/PdbPIvCefsn8wy2sobI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-KmhKneL5NMqRNW8Wh_DRXw-1; Thu, 15 Apr 2021 06:34:17 -0400
X-MC-Unique: KmhKneL5NMqRNW8Wh_DRXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01FC918B9F41;
	Thu, 15 Apr 2021 10:34:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D264410016FE;
	Thu, 15 Apr 2021 10:34:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D71444A5F;
	Thu, 15 Apr 2021 10:34:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FAYAF9032095 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 06:34:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BA396294D; Thu, 15 Apr 2021 10:34:10 +0000 (UTC)
Received: from localhost (ovpn-13-200.pek2.redhat.com [10.72.13.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5DDB5D76F;
	Thu, 15 Apr 2021 10:34:09 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 15 Apr 2021 18:33:10 +0800
Message-Id: <20210415103310.1513841-3-ming.lei@redhat.com>
In-Reply-To: <20210415103310.1513841-1-ming.lei@redhat.com>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
	request queue
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For bio based request queue, the queue usage refcnt is only grabbed
during submission, which isn't consistent with request base queue.

Queue freezing has been used widely, and turns out it is very useful
to quiesce queue activity.

Support to freeze bio based request queue by the following approach:

1) grab two queue usage refcount for blk-mq before submitting blk-mq
bio, one is for bio, anther is for request;

2) add bio flag of BIO_QUEUE_REFFED for making sure that only one
refcnt is grabbed for each bio, so we can put the refcnt when the
bio is going away

3) nvme mpath is a bit special, because same bio is used for both
mpath queue and underlying nvme queue. So we put the mpath queue's
usage refcnt before completing the nvme request.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c                   | 12 ++++++++++--
 block/blk-core.c              | 23 +++++++++++++++++------
 drivers/nvme/host/core.c      | 16 ++++++++++++++++
 drivers/nvme/host/multipath.c |  6 ++++++
 include/linux/blk-mq.h        |  2 ++
 include/linux/blk_types.h     |  1 +
 include/linux/blkdev.h        |  7 ++++++-
 7 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 303298996afe..941a306e390b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1365,14 +1365,18 @@ static inline bool bio_remaining_done(struct bio *bio)
  **/
 void bio_endio(struct bio *bio)
 {
+	struct block_device *bdev;
+	bool put_queue;
 again:
+	bdev = bio->bi_bdev;
+	put_queue = bio_flagged(bio, BIO_QUEUE_REFFED);
 	if (!bio_remaining_done(bio))
 		return;
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_bdev)
-		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
+	if (bdev)
+		rq_qos_done_bio(bdev->bd_disk->queue, bio);
 
 	/*
 	 * Need to have a real endio function for chained bios, otherwise
@@ -1384,6 +1388,8 @@ void bio_endio(struct bio *bio)
 	 */
 	if (bio->bi_end_io == bio_chain_endio) {
 		bio = __bio_chain_endio(bio);
+		if (bdev && put_queue)
+			blk_queue_exit(bdev->bd_disk->queue);
 		goto again;
 	}
 
@@ -1397,6 +1403,8 @@ void bio_endio(struct bio *bio)
 	bio_uninit(bio);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
+	if (bdev && put_queue)
+		blk_queue_exit(bdev->bd_disk->queue);
 }
 EXPORT_SYMBOL(bio_endio);
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 09f774e7413d..f71e4b433030 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -431,12 +431,13 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
 	const bool pm = flags & BLK_MQ_REQ_PM;
+	const unsigned int nr = (flags & BLK_MQ_REQ_DOUBLE_REF) ? 2 : 1;
 
 	while (true) {
 		bool success = false;
 
 		rcu_read_lock();
-		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
+		if (percpu_ref_tryget_many_live(&q->q_usage_counter, nr)) {
 			/*
 			 * The code that increments the pm_only counter is
 			 * responsible for ensuring that that counter is
@@ -446,7 +447,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
-				percpu_ref_put(&q->q_usage_counter);
+				percpu_ref_put_many(&q->q_usage_counter, nr);
 			}
 		}
 		rcu_read_unlock();
@@ -480,8 +481,18 @@ static inline int bio_queue_enter(struct bio *bio)
 	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	int ret;
+	blk_mq_req_flags_t flags = nowait ? BLK_MQ_REQ_NOWAIT : 0;
+	bool reffed = bio_flagged(bio, BIO_QUEUE_REFFED);
 
-	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
+	if (!reffed)
+		bio_set_flag(bio, BIO_QUEUE_REFFED);
+
+	/*
+	 * Grab two queue references for blk-mq, one is for bio, and
+	 * another is for blk-mq request.
+	 */
+	ret = blk_queue_enter(q, q->mq_ops && !reffed ?
+			(flags | BLK_MQ_REQ_DOUBLE_REF) : flags);
 	if (unlikely(ret)) {
 		if (nowait && !blk_queue_dying(q))
 			bio_wouldblock_error(bio);
@@ -492,10 +503,11 @@ static inline int bio_queue_enter(struct bio *bio)
 	return ret;
 }
 
-void blk_queue_exit(struct request_queue *q)
+void __blk_queue_exit(struct request_queue *q, unsigned int nr)
 {
-	percpu_ref_put(&q->q_usage_counter);
+	percpu_ref_put_many(&q->q_usage_counter, nr);
 }
+EXPORT_SYMBOL_GPL(__blk_queue_exit);
 
 static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 {
@@ -920,7 +932,6 @@ static blk_qc_t __submit_bio(struct bio *bio)
 			return blk_mq_submit_bio(bio);
 		ret = disk->fops->submit_bio(bio);
 	}
-	blk_queue_exit(disk->queue);
 	return ret;
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 34b8c78f88e0..791638a7164b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -323,14 +323,30 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 static inline void nvme_end_req(struct request *req)
 {
 	blk_status_t status = nvme_error_status(nvme_req(req)->status);
+	const bool mpath = req->cmd_flags & REQ_NVME_MPATH;
+	unsigned int nr = 0;
+	struct bio *bio;
+	struct nvme_ns *ns;
 
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    req_op(req) == REQ_OP_ZONE_APPEND)
 		req->__sector = nvme_lba_to_sect(req->q->queuedata,
 			le64_to_cpu(nvme_req(req)->result.u64));
 
+	if (mpath) {
+		ns = req->q->queuedata;
+		__rq_for_each_bio(bio, req)
+			nr++;
+	}
 	nvme_trace_bio_complete(req);
 	blk_mq_end_request(req, status);
+
+	/*
+	 * We changed multipath bio->bi_bdev, so have to drop the queue
+	 * reference manually
+	 */
+	if (mpath && nr)
+		__blk_queue_exit(ns->head->disk->queue, nr);
 }
 
 void nvme_complete_rq(struct request *req)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a1d476e1ac02..017487c835fb 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -312,6 +312,12 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
+		/*
+		 * this bio's ownership is transferred to underlying queue, so
+		 * clear the queue reffed flag and let underlying queue to put
+		 * the multipath queue for us.
+		 */
+		bio_clear_flag(bio, BIO_QUEUE_REFFED);
 		bio_set_dev(bio, ns->disk->part0);
 		bio->bi_opf |= REQ_NVME_MPATH;
 		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2c473c9b8990..b96ac162e703 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -445,6 +445,8 @@ enum {
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
 	/* set RQF_PM */
 	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
+	/* double queue reference */
+	BLK_MQ_REQ_DOUBLE_REF	= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 57099b37ef3a..e7f7d67198cc 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -305,6 +305,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_QUEUE_REFFED,	/* need to put queue refcnt */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 62944d06a80f..6ad09b2ff2d1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -925,7 +925,7 @@ extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
 extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
 
 extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
-extern void blk_queue_exit(struct request_queue *q);
+extern void __blk_queue_exit(struct request_queue *q, unsigned int nr);
 extern void blk_sync_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
@@ -947,6 +947,11 @@ blk_status_t errno_to_blk_status(int errno);
 
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 
+static inline void blk_queue_exit(struct request_queue *q)
+{
+	__blk_queue_exit(q, 1);
+}
+
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue;	/* this is never NULL */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

