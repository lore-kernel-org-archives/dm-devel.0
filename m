Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CCEC64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2751206B7
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2751206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-qgyTIq2gPQiOBlvbLw3tgg-1; Tue, 01 Dec 2020 12:02:16 -0500
X-MC-Unique: qgyTIq2gPQiOBlvbLw3tgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0B5D1074641;
	Tue,  1 Dec 2020 17:02:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFB1910016F4;
	Tue,  1 Dec 2020 17:02:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 929BC1809C9F;
	Tue,  1 Dec 2020 17:02:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1H25RY032240 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:02:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6EF399458A; Tue,  1 Dec 2020 17:02:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69BC594585
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:02:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5662B8007D9
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:02:05 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-305-E4tlhp1bPbKVH7SJlme1ww-1; Tue, 01 Dec 2020 12:01:57 -0500
X-MC-Unique: E4tlhp1bPbKVH7SJlme1ww-1
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kk8vB-0005Zh-O2; Tue, 01 Dec 2020 16:54:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Dec 2020 17:54:21 +0100
Message-Id: <20201201165424.2030647-7-hch@lst.de>
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
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
Subject: [dm-devel] [PATCH 6/9] blk-mq: use ->bi_bdev for I/O accounting
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the reverse map from a sector to a partition for I/O accounting by
simply using ->bi_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c |  6 +++++-
 block/blk.h      |  2 --
 block/genhd.c    | 48 ------------------------------------------------
 3 files changed, 5 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d53cc887e1b8ea..ad041e903b0a8f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1296,7 +1296,11 @@ void blk_account_io_start(struct request *rq)
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
index 64dc8e5a3f44cb..f93a6af04adbd1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -346,8 +346,6 @@ void blk_queue_free_zone_bitmaps(struct request_queue *q);
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 #endif
 
-struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector);
-
 int blk_alloc_devt(struct block_device *part, dev_t *devt);
 void blk_free_devt(dev_t devt);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
diff --git a/block/genhd.c b/block/genhd.c
index 57c709a9f90267..3b9cd766d95228 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -280,54 +280,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
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

