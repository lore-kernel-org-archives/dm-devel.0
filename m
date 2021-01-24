Return-Path: <SRS0=PWLs=G3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA26C433DB
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:14:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6433A22C9D
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6433A22C9D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-szJLlLLhPOadoZAh_QR3AA-1; Sun, 24 Jan 2021 05:14:07 -0500
X-MC-Unique: szJLlLLhPOadoZAh_QR3AA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17A6418C89CF;
	Sun, 24 Jan 2021 10:14:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE32660C66;
	Sun, 24 Jan 2021 10:14:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C356C4E58E;
	Sun, 24 Jan 2021 10:14:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10OADx5t005764 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 24 Jan 2021 05:13:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B07C047CD4; Sun, 24 Jan 2021 10:13:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB74E47CDC
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61AB9187504B
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:57 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-557-MMsOuBEmN6GjNboe0JTq-A-1; Sun, 24 Jan 2021 05:13:55 -0500
X-MC-Unique: MMsOuBEmN6GjNboe0JTq-A-1
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1l3cHD-002qA0-TP; Sun, 24 Jan 2021 10:05:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sun, 24 Jan 2021 11:02:38 +0100
Message-Id: <20210124100241.1167849-8-hch@lst.de>
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 07/10] blk-mq: use ->bi_bdev for I/O accounting
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the reverse map from a sector to a partition for I/O accounting by
simply using ->bi_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |  6 +++++-
 block/blk.h      |  2 --
 block/genhd.c    | 48 ------------------------------------------------
 3 files changed, 5 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9315311c27a913..6dfbdde6b9ff84 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1298,7 +1298,11 @@ void blk_account_io_start(struct request *rq)
 	if (!blk_do_io_stat(rq))
 		return;
 
-	rq->part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
+	/* passthrough requests can hold bios that do not have ->bi_bdev set */
+	if (rq->bio && rq->bio->bi_bdev)
+		rq->part = rq->bio->bi_bdev;
+	else
+		rq->part = rq->rq_disk->part0;
 
 	part_stat_lock();
 	update_io_ticks(rq->part, jiffies, false);
diff --git a/block/blk.h b/block/blk.h
index 10ab7c0d0766f0..d965cacc5bdaa1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -333,8 +333,6 @@ void blk_queue_free_zone_bitmaps(struct request_queue *q);
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 #endif
 
-struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector);
-
 int blk_alloc_devt(struct block_device *part, dev_t *devt);
 void blk_free_devt(dev_t devt);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
diff --git a/block/genhd.c b/block/genhd.c
index e536d0b4bbae34..e46de616a19e59 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -285,54 +285,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 }
 EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 
-static inline int sector_in_part(struct block_device *part, sector_t sector)
-{
-	return part->bd_start_sect <= sector &&
-		sector < part->bd_start_sect + bdev_nr_sectors(part);
-}
-
-/**
- * disk_map_sector_rcu - map sector to partition
- * @disk: gendisk of interest
- * @sector: sector to map
- *
- * Find out which partition @sector maps to on @disk.  This is
- * primarily used for stats accounting.
- *
- * CONTEXT:
- * RCU read locked.
- *
- * RETURNS:
- * Found partition on success, part0 is returned if no partition matches
- * or the matched partition is being deleted.
- */
-struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
-{
-	struct disk_part_tbl *ptbl;
-	struct block_device *part;
-	int i;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
-	part = rcu_dereference(ptbl->last_lookup);
-	if (part && sector_in_part(part, sector))
-		goto out_unlock;
-
-	for (i = 1; i < ptbl->len; i++) {
-		part = rcu_dereference(ptbl->part[i]);
-		if (part && sector_in_part(part, sector)) {
-			rcu_assign_pointer(ptbl->last_lookup, part);
-			goto out_unlock;
-		}
-	}
-
-	part = disk->part0;
-out_unlock:
-	rcu_read_unlock();
-	return part;
-}
-
 /**
  * disk_has_partitions
  * @disk: gendisk of interest
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

