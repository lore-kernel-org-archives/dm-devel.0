Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6865C7618A
	for <dm-devel@archiver.kernel.org>; Sun, 19 Mar 2023 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679227753;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vPiCsDMS45ba9CRC5TkNjTK6iG368ulVMPMXTpOSaU4=;
	b=V96/MYFtjPIVy+0HuI5ZqZzegMdHlqWHAdu3rM1djNVG8lOXo1ByLfU7ghUqvvhBcy+UcZ
	UBTmXgxYFfGvHPB4GzYKCMRmo/vghpvOW38h6Fj3lDdx9EK6tNYkA1PmDzQYqXZRdye+hp
	lZgUIjA65G/J+IukWqaVrYphVl0md+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Ac0Zg75pP46G933LtJfKkQ-1; Sun, 19 Mar 2023 08:09:10 -0400
X-MC-Unique: Ac0Zg75pP46G933LtJfKkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C3A285C06E;
	Sun, 19 Mar 2023 12:09:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56CBE140EBF4;
	Sun, 19 Mar 2023 12:09:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D75101946A50;
	Sun, 19 Mar 2023 12:09:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3507A194658F
 for <dm-devel@listman.corp.redhat.com>; Sun, 19 Mar 2023 12:08:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C29F492C18; Sun, 19 Mar 2023 12:08:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64A7C492C14
 for <dm-devel@redhat.com>; Sun, 19 Mar 2023 12:08:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B09580C8C1
 for <dm-devel@redhat.com>; Sun, 19 Mar 2023 12:08:53 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-q52cdfTfOhShC9esPEE_0A-1; Sun, 19 Mar 2023 08:08:51 -0400
X-MC-Unique: q52cdfTfOhShC9esPEE_0A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 7174EB80B91;
 Sun, 19 Mar 2023 12:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D51C433EF;
 Sun, 19 Mar 2023 12:08:47 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Date: Sun, 19 Mar 2023 08:08:45 -0400
Message-Id: <20230319120846.1336704-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] Patch "block: count 'ios' and 'sectors' when io is done
 for bio-based device" has been added to the 6.2-stable tree
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
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, Minchan Kim <minchan@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    block: count 'ios' and 'sectors' when io is done for bio-based device

to the 6.2-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     block-count-ios-and-sectors-when-io-is-done-for-bio-.patch
and it can be found in the queue-6.2 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 45cf60482f9f7be5b749b7908a03886c0449583a
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Thu Feb 23 17:12:26 2023 +0800

    block: count 'ios' and 'sectors' when io is done for bio-based device
    
    [ Upstream commit 5f27571382ca42daa3e3d40d1b252bf18c2b61d2 ]
    
    While using iostat for raid, I observed very strange 'await'
    occasionally, and turns out it's due to that 'ios' and 'sectors' is
    counted in bdev_start_io_acct(), while 'nsecs' is counted in
    bdev_end_io_acct(). I'm not sure why they are ccounted like that
    but I think this behaviour is obviously wrong because user will get
    wrong disk stats.
    
    Fix the problem by counting 'ios' and 'sectors' when io is done, like
    what rq-based device does.
    
    Fixes: 394ffa503bc4 ("blk: introduce generic io stat accounting help function")
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Link: https://lore.kernel.org/r/20230223091226.1135678-1-yukuai1@huaweicloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index 5a0049215ee72..597293151cd11 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -946,16 +946,11 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	}
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
-				 unsigned int sectors, enum req_op op,
+unsigned long bdev_start_io_acct(struct block_device *bdev, enum req_op op,
 				 unsigned long start_time)
 {
-	const int sgrp = op_stat_group(op);
-
 	part_stat_lock();
 	update_io_ticks(bdev, start_time, false);
-	part_stat_inc(bdev, ios[sgrp]);
-	part_stat_add(bdev, sectors[sgrp], sectors);
 	part_stat_local_inc(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
@@ -971,13 +966,12 @@ EXPORT_SYMBOL(bdev_start_io_acct);
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				  bio_op(bio), jiffies);
+	return bdev_start_io_acct(bio->bi_bdev, bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		      unsigned long start_time)
+		      unsigned int sectors, unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
 	unsigned long now = READ_ONCE(jiffies);
@@ -985,6 +979,8 @@ void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
 
 	part_stat_lock();
 	update_io_ticks(bdev, now, true);
+	part_stat_inc(bdev, ios[sgrp]);
+	part_stat_add(bdev, sectors[sgrp], sectors);
 	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
 	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
@@ -994,7 +990,7 @@ EXPORT_SYMBOL(bdev_end_io_acct);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 			      struct block_device *orig_bdev)
 {
-	bdev_end_io_acct(orig_bdev, bio_op(bio), start_time);
+	bdev_end_io_acct(orig_bdev, bio_op(bio), bio_sectors(bio), start_time);
 }
 EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e290d6d970474..03ef03e10618d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2108,9 +2108,9 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_offset = 0;
 
 	start_time = bdev_start_io_acct(bdev->bd_disk->part0,
-			SECTORS_PER_PAGE, op, jiffies);
+			op, jiffies);
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
-	bdev_end_io_acct(bdev->bd_disk->part0, op, start_time);
+	bdev_end_io_acct(bdev->bd_disk->part0, op, SECTORS_PER_PAGE, start_time);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 605662935ce91..fdcf42554e2a9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -510,10 +510,10 @@ static void dm_io_acct(struct dm_io *io, bool end)
 		sectors = io->sectors;
 
 	if (!end)
-		bdev_start_io_acct(bio->bi_bdev, sectors, bio_op(bio),
-				   start_time);
+		bdev_start_io_acct(bio->bi_bdev, bio_op(bio), start_time);
 	else
-		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), start_time);
+		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), sectors,
+				 start_time);
 
 	if (static_branch_unlikely(&stats_enabled) &&
 	    unlikely(dm_stats_used(&md->stats))) {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fc39d01e7b63b..9171452e2f6d4 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -123,9 +123,8 @@ void nvme_mpath_start_request(struct request *rq)
 		return;
 
 	nvme_req(rq)->flags |= NVME_MPATH_IO_STATS;
-	nvme_req(rq)->start_time = bdev_start_io_acct(disk->part0,
-					blk_rq_bytes(rq) >> SECTOR_SHIFT,
-					req_op(rq), jiffies);
+	nvme_req(rq)->start_time = bdev_start_io_acct(disk->part0, req_op(rq),
+						      jiffies);
 }
 EXPORT_SYMBOL_GPL(nvme_mpath_start_request);
 
@@ -136,7 +135,8 @@ void nvme_mpath_end_request(struct request *rq)
 	if (!(nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
 	bdev_end_io_acct(ns->head->disk->part0, req_op(rq),
-		nvme_req(rq)->start_time);
+			 blk_rq_bytes(rq) >> SECTOR_SHIFT,
+			 nvme_req(rq)->start_time);
 }
 
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 43d4e073b1115..c3e066242941d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1434,11 +1434,10 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
 		wake_up_process(waiter);
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
-				 unsigned int sectors, enum req_op op,
+unsigned long bdev_start_io_acct(struct block_device *bdev, enum req_op op,
 				 unsigned long start_time);
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		unsigned long start_time);
+		      unsigned int sectors, unsigned long start_time);
 
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

