Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90B6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 08:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649753803;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NmBb6M7rFf0wxbZpcL8Xm5cl5FqUfBVQPnxJETvDMvw=;
	b=WvtTPDh0jOjjdupQUCiKsdeMr1LgvvaYQV+DU3G/jMJgCkZDqoawUvu5V8sVWeXgdUDql1
	cM5s14k3fm5x6srjK7zLlV/oKoAI3FjGI8+MaxhjFIWI+USaD9+SgsKCCv2bTOZAW5/NpX
	00U60KEO5cJ+GGNfd0TvY7ELQrD9h+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-gNfyZK3mN6KMfvRrJ8F1EA-1; Tue, 12 Apr 2022 04:56:40 -0400
X-MC-Unique: gNfyZK3mN6KMfvRrJ8F1EA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12194811E83;
	Tue, 12 Apr 2022 08:56:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 010C21400AFB;
	Tue, 12 Apr 2022 08:56:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B5171949762;
	Tue, 12 Apr 2022 08:56:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8394D1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 08:56:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68B7540CFD1E; Tue, 12 Apr 2022 08:56:37 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9E23C40CFD1D;
 Tue, 12 Apr 2022 08:56:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>
Date: Tue, 12 Apr 2022 16:56:09 +0800
Message-Id: <20220412085616.1409626-2-ming.lei@redhat.com>
In-Reply-To: <20220412085616.1409626-1-ming.lei@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 1/8] block: replace disk based account with bdev's
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

'block device' is generic type for interface, and gendisk becomes more
one block layer internal type, so replace disk based account interface
with bdec's.

Also add 'start_time' parameter to bdev_start_io_acct() so that we
can cover device mapper's io accounting by the two bdev based interface.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c              | 15 ++++++++-------
 drivers/block/zram/zram_drv.c |  5 +++--
 include/linux/blkdev.h        |  7 ++++---
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 937bb6b86331..a3ae13b129ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1063,12 +1063,13 @@ unsigned long bio_start_io_acct(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
-unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
-				 unsigned int op)
+unsigned long bdev_start_io_acct(struct block_device *bdev,
+				 unsigned int sectors, unsigned int op,
+				 unsigned long start_time)
 {
-	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
+	return __part_start_io_acct(bdev, sectors, op, start_time);
 }
-EXPORT_SYMBOL(disk_start_io_acct);
+EXPORT_SYMBOL(bdev_start_io_acct);
 
 static void __part_end_io_acct(struct block_device *part, unsigned int op,
 			       unsigned long start_time)
@@ -1091,12 +1092,12 @@ void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 }
 EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
-void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+void bdev_end_io_acct(struct block_device *bdev, unsigned int op,
 		      unsigned long start_time)
 {
-	__part_end_io_acct(disk->part0, op, start_time);
+	__part_end_io_acct(bdev, op, start_time);
 }
-EXPORT_SYMBOL(disk_end_io_acct);
+EXPORT_SYMBOL(bdev_end_io_acct);
 
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e9474b02012d..adb5209a556a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1675,9 +1675,10 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
-	start_time = disk_start_io_acct(bdev->bd_disk, SECTORS_PER_PAGE, op);
+	start_time = bdev_start_io_acct(bdev->bd_disk->part0,
+			SECTORS_PER_PAGE, op, jiffies);
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
-	disk_end_io_acct(bdev->bd_disk, op, start_time);
+	bdev_end_io_acct(bdev->bd_disk->part0, op, start_time);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d016138997..f680ba6f0ab2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1491,9 +1491,10 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
 		wake_up_process(waiter);
 }
 
-unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
-		unsigned int op);
-void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+unsigned long bdev_start_io_acct(struct block_device *bdev,
+				 unsigned int sectors, unsigned int op,
+				 unsigned long start_time);
+void bdev_end_io_acct(struct block_device *bdev, unsigned int op,
 		unsigned long start_time);
 
 void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

