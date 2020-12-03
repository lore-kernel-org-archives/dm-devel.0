Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E04C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C729206B9
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C729206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-yip8nSwuPzWgrw3AMeheVA-1; Thu, 03 Dec 2020 11:34:00 -0500
X-MC-Unique: yip8nSwuPzWgrw3AMeheVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F421F835B48;
	Thu,  3 Dec 2020 16:33:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D183C5D9D7;
	Thu,  3 Dec 2020 16:33:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A47084E58F;
	Thu,  3 Dec 2020 16:33:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3GW1v4031528 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 11:32:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D55382166B34; Thu,  3 Dec 2020 16:32:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE6C32166B30
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61C4E803DCE
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:57 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-493-hi6aLNJkM9WtMPwmIsfWeQ-1; Thu, 03 Dec 2020 11:31:55 -0500
X-MC-Unique: hi6aLNJkM9WtMPwmIsfWeQ-1
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kkrMh-0005dh-KV; Thu, 03 Dec 2020 16:21:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  3 Dec 2020 17:21:38 +0100
Message-Id: <20201203162139.2110977-5-hch@lst.de>
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 4/5] block: remove the request_queue argument to
	the block_bio_remap tracepoint
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The request_queue can trivially be derived from the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c              |  2 +-
 drivers/md/dm.c               |  3 +--
 drivers/md/md-linear.c        |  3 +--
 drivers/md/md.c               |  5 ++---
 drivers/md/raid0.c            |  4 ++--
 drivers/md/raid1.c            |  7 +++----
 drivers/md/raid10.c           |  6 ++----
 drivers/md/raid5.c            | 15 +++++++--------
 drivers/nvme/host/multipath.c |  3 +--
 include/trace/events/block.h  |  8 +++-----
 kernel/trace/blktrace.c       | 14 +++++---------
 11 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cb24654983e1e4..96e5fcd7f071b6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -758,7 +758,7 @@ static inline int blk_partition_remap(struct bio *bio)
 		if (bio_check_eod(bio, bdev_nr_sectors(p)))
 			goto out;
 		bio->bi_iter.bi_sector += p->bd_start_sect;
-		trace_block_bio_remap(bio->bi_disk->queue, bio, p->bd_dev,
+		trace_block_bio_remap(bio, p->bd_dev,
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9a5bd90779c7c4..5181907dc59537 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1276,8 +1276,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
-		trace_block_bio_remap(clone->bi_disk->queue, clone,
-				      bio_dev(io->orig_bio), sector);
+		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
 		ret = submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 98f1b4b2bdcef8..68cac7d1927823 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -257,8 +257,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		bio_endio(bio);
 	} else {
 		if (mddev->gendisk)
-			trace_block_bio_remap(bio->bi_disk->queue,
-					      bio, disk_devt(mddev->gendisk),
+			trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
 					      bio_sector);
 		mddev_check_writesame(mddev, bio);
 		mddev_check_write_zeroes(mddev, bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0065736f05b428..c555be0a8dce78 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8591,9 +8591,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 	bio_chain(discard_bio, bio);
 	bio_clone_blkg_association(discard_bio, bio);
 	if (mddev->gendisk)
-		trace_block_bio_remap(bdev_get_queue(rdev->bdev),
-			discard_bio, disk_devt(mddev->gendisk),
-			bio->bi_iter.bi_sector);
+		trace_block_bio_remap(discard_bio, disk_devt(mddev->gendisk),
+				      bio->bi_iter.bi_sector);
 	submit_bio_noacct(discard_bio);
 }
 EXPORT_SYMBOL(md_submit_discard_bio);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f44177593a552..e5d7411cba9b46 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -571,8 +571,8 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		tmp_dev->data_offset;
 
 	if (mddev->gendisk)
-		trace_block_bio_remap(bio->bi_disk->queue, bio,
-				disk_devt(mddev->gendisk), bio_sector);
+		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
+				      bio_sector);
 	mddev_check_writesame(mddev, bio);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 960d854c07f897..c0347997f6ff73 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1305,8 +1305,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r1_bio;
 
 	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio->bi_disk->queue, read_bio,
-				disk_devt(mddev->gendisk), r1_bio->sector);
+	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
+				      r1_bio->sector);
 
 	submit_bio_noacct(read_bio);
 }
@@ -1517,8 +1517,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		atomic_inc(&r1_bio->remaining);
 
 		if (mddev->gendisk)
-			trace_block_bio_remap(mbio->bi_disk->queue,
-					      mbio, disk_devt(mddev->gendisk),
+			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),
 					      r1_bio->sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
 		mbio->bi_disk = (void *)conf->mirrors[i].rdev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b7bca6703df814..a6f99fa0b32cfc 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1200,8 +1200,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r10_bio;
 
 	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio->bi_disk->queue,
-	                              read_bio, disk_devt(mddev->gendisk),
+	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
 	                              r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
@@ -1250,8 +1249,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_private = r10_bio;
 
 	if (conf->mddev->gendisk)
-		trace_block_bio_remap(mbio->bi_disk->queue,
-				      mbio, disk_devt(conf->mddev->gendisk),
+		trace_block_bio_remap(mbio, disk_devt(conf->mddev->gendisk),
 				      r10_bio->sector);
 	/* flush_pending_writes() needs access to the rdev so...*/
 	mbio->bi_disk = (void *)rdev;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 39343479ac2a94..3a90cc0e43ca8e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1222,9 +1222,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
 			if (conf->mddev->gendisk)
-				trace_block_bio_remap(bi->bi_disk->queue,
-						      bi, disk_devt(conf->mddev->gendisk),
-						      sh->dev[i].sector);
+				trace_block_bio_remap(bi,
+						disk_devt(conf->mddev->gendisk),
+						sh->dev[i].sector);
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, bi);
 			else
@@ -1272,9 +1272,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (op == REQ_OP_DISCARD)
 				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
-				trace_block_bio_remap(rbi->bi_disk->queue,
-						      rbi, disk_devt(conf->mddev->gendisk),
-						      sh->dev[i].sector);
+				trace_block_bio_remap(rbi,
+						disk_devt(conf->mddev->gendisk),
+						sh->dev[i].sector);
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, rbi);
 			else
@@ -5468,8 +5468,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		spin_unlock_irq(&conf->device_lock);
 
 		if (mddev->gendisk)
-			trace_block_bio_remap(align_bi->bi_disk->queue,
-					      align_bi, disk_devt(mddev->gendisk),
+			trace_block_bio_remap(align_bi, disk_devt(mddev->gendisk),
 					      raid_bio->bi_iter.bi_sector);
 		submit_bio_noacct(align_bi);
 		return 1;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 74896be40c1769..106cf5c44ee7ab 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -312,8 +312,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 	if (likely(ns)) {
 		bio->bi_disk = ns->disk;
 		bio->bi_opf |= REQ_NVME_MPATH;
-		trace_block_bio_remap(bio->bi_disk->queue, bio,
-				      disk_devt(ns->head->disk),
+		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
 		ret = submit_bio_noacct(bio);
 	} else if (nvme_available_path(head)) {
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index b415e4cba84304..8fb89574d8677f 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -450,9 +450,8 @@ TRACE_EVENT(block_split,
 
 /**
  * block_bio_remap - map request for a logical device to the raw device
- * @q: queue holding the operation
  * @bio: revised operation
- * @dev: device for the operation
+ * @dev: original device for the operation
  * @from: original sector for the operation
  *
  * An operation for a logical device has been mapped to the
@@ -460,10 +459,9 @@ TRACE_EVENT(block_split,
  */
 TRACE_EVENT(block_bio_remap,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t from),
+	TP_PROTO(struct bio *bio, dev_t dev, sector_t from),
 
-	TP_ARGS(q, bio, dev, from),
+	TP_ARGS(bio, dev, from),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 3ca6d62114f461..405637144a0389 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -993,20 +993,16 @@ static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 /**
  * blk_add_trace_bio_remap - Add a trace for a bio-remap operation
  * @ignore:	trace callback data parameter (not used)
- * @q:		queue the io is for
  * @bio:	the source bio
- * @dev:	target device
+ * @dev:	source device
  * @from:	source sector
  *
- * Description:
- *     Device mapper or raid target sometimes need to split a bio because
- *     it spans a stripe (or similar). Add a trace for that action.
- *
+ * Called after a bio is remapped to a different device and/or sector.
  **/
-static void blk_add_trace_bio_remap(void *ignore,
-				    struct request_queue *q, struct bio *bio,
-				    dev_t dev, sector_t from)
+static void blk_add_trace_bio_remap(void *ignore, struct bio *bio, dev_t dev,
+				    sector_t from)
 {
+	struct request_queue *q = bio->bi_disk->queue;
 	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

