Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CBFC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 08:56:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-daR8peX0ODmQpBES9iMDOw-1; Wed, 09 Feb 2022 03:56:12 -0500
X-MC-Unique: daR8peX0ODmQpBES9iMDOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAD2D100C609;
	Wed,  9 Feb 2022 08:56:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B018F5F92B;
	Wed,  9 Feb 2022 08:56:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C1944CA9B;
	Wed,  9 Feb 2022 08:56:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198u5cT020292 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:56:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D34C240CFD27; Wed,  9 Feb 2022 08:56:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF09A40CFD14
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:56:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B778F18A6582
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:56:05 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-400-DQwiWeH1PwuOHHf6dxbzoA-1; Wed, 09 Feb 2022 03:56:04 -0500
X-MC-Unique: DQwiWeH1PwuOHHf6dxbzoA-1
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nHiLJ-00GcFP-5b; Wed, 09 Feb 2022 08:28:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, manoj@linux.ibm.com,
	mrochs@linux.ibm.com, ukrishn@linux.ibm.com
Date: Wed,  9 Feb 2022 09:28:26 +0100
Message-Id: <20220209082828.2629273-6-hch@lst.de>
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 5/7] md: drop WRITE_SAME support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are no more end-users of REQ_OP_WRITE_SAME left, so we can start
deleting it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-linear.c    | 1 -
 drivers/md/md-multipath.c | 1 -
 drivers/md/md.h           | 7 -------
 drivers/md/raid0.c        | 2 --
 drivers/md/raid1.c        | 4 +---
 drivers/md/raid10.c       | 1 -
 drivers/md/raid5.c        | 1 -
 7 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 1ff51647a6822..0f55b079371b1 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -259,7 +259,6 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		if (mddev->gendisk)
 			trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
 					      bio_sector);
-		mddev_check_writesame(mddev, bio);
 		mddev_check_write_zeroes(mddev, bio);
 		submit_bio_noacct(bio);
 	}
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 97fb948e3e741..68dec76694d53 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -127,7 +127,6 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_opf |= REQ_FAILFAST_TRANSPORT;
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
-	mddev_check_writesame(mddev, &mp_bh->bio);
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
 	submit_bio_noacct(&mp_bh->bio);
 	return true;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f1bf3625ef4c9..6ac2838645336 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -797,13 +797,6 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 	mddev->flags &= ~unsupported_flags;
 }
 
-static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
-{
-	if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-	    !bio->bi_bdev->bd_disk->queue->limits.max_write_same_sectors)
-		mddev->queue->limits.max_write_same_sectors = 0;
-}
-
 static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio)
 {
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b59a77b31b90d..b21e101183f44 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -402,7 +402,6 @@ static int raid0_run(struct mddev *mddev)
 		bool discard_supported = false;
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
 
@@ -594,7 +593,6 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	if (mddev->gendisk)
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
 				      bio_sector);
-	mddev_check_writesame(mddev, bio);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
 	return true;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c3288d46948de..9cec48d335065 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3147,10 +3147,8 @@ static int raid1_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue) {
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
+	if (mddev->queue)
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-	}
 
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5dd2e17e1d0ea..764ca020b7a40 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4113,7 +4113,6 @@ static int raid10_run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      UINT_MAX);
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8891aaba65964..f5f36fdd37336 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7767,7 +7767,6 @@ static int raid5_run(struct mddev *mddev)
 		mddev->queue->limits.discard_alignment = stripe;
 		mddev->queue->limits.discard_granularity = stripe;
 
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 
 		rdev_for_each(rdev, mddev) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

