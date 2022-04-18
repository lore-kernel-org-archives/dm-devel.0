Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB21C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-zCnf9QCqPU-nwB6AzhY6Eg-1; Sun, 17 Apr 2022 22:27:42 -0400
X-MC-Unique: zCnf9QCqPU-nwB6AzhY6Eg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4CBC3C00105;
	Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91B4D200A4F0;
	Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52F4D19451F1;
	Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C537B19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9239145BA58; Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5744145BA54
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AFC5811E75
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:38 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-eVbZJCFgMPuVHODzJIMz0g-1; Sun, 17 Apr 2022 22:27:37 -0400
X-MC-Unique: eVbZJCFgMPuVHODzJIMz0g-1
Received: by mail-qk1-f170.google.com with SMTP id b68so5589612qkc.4
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=yX7Km7uC+2/I6rFIKqJdrUbEElXhCOJMmE/aqjjxnpk=;
 b=BW6lYA+muuAO4jAFwEBVr5dXgbKk7AqLy2rMjNJ0bL3V32yiVQyS2icKFKPRhaLoV5
 tUHDjex/ImZ6qrcC1K2U5owFT9ZnhUpTQERflKo4zXVXSFQDRKefDoNACkIPSjurTWss
 NzeaLK2qc1T2d8WXdkrGgI6KYbxMpmd2N/fw2+wYCpIMe/H6Gc7yrGLeYSCjQQKgzPnl
 kGfginyY6Mf4BzWkbG8d5tH5U1kfHk8upxXBq/HYGkTKCVC40wxGGzBMyZy26ROzyt9i
 Wo1d9leT7A1EI227ORS7rqZOUVvbwy3F+JJvJuLWeqVkHSRlsH2ZC7WSFQRI7UD1v0sZ
 Q2zA==
X-Gm-Message-State: AOAM5319A//LbmpYngh04D2Pb555AbE+WLSMtkDSdo/RQdMDT63bQjSD
 iP/yQOlDKJzuM2BPOh7SovC/Lgbyo47SN5CtjYTQaMwTJMrqEdV9iX+DW8jynMgD7T29jWef3Ts
 oDnZHKZj0Mcg+h7sU30gv2EIx+31nk+NySQRFq5ukiX+ZDH5pS5YIm1zZZfyPsH4Jxko=
X-Google-Smtp-Source: ABdhPJxPoascgnCJCRKobr3PSxcoxNZPTdT/3om+1LW64S3EDST2On6NO+3NpR7920B4u9NfRZI7Zg==
X-Received: by 2002:a05:620a:2441:b0:69c:3451:2a60 with SMTP id
 h1-20020a05620a244100b0069c34512a60mr5270687qkn.181.1650248856091; 
 Sun, 17 Apr 2022 19:27:36 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w3-20020a376203000000b0069e9a4568f9sm1109629qkb.125.2022.04.17.19.27.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:35 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:13 -0400
Message-Id: <20220418022733.56168-2-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [dm-5.19 PATCH 01/21] block: change exported IO
 accounting interface from gendisk to bdev
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4162643757411405702=="

--===============4162643757411405702==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

Export IO accounting interfaces in terms of block_device now that
gendisk has become more internal to block core.

Rename __part_{start,end}_io_acct's first argument from part to bdev.
Rename __part_{start,end}_io_acct to bdev_{start,end}_io_acct and
export them.  Remove disk_{start,end}_io_acct and update caller (zram)
to use bdev_{start,end}_io_acct.

DM can now be updated to use bdev_{start,end}_io_acct.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/blk-core.c              | 52 +++++++++++++++++--------------------------
 drivers/block/zram/zram_drv.c |  5 +++--
 include/linux/blkdev.h        |  7 +++---
 3 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 937bb6b86331..99deb4603be3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1022,21 +1022,22 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	}
 }
 
-static unsigned long __part_start_io_acct(struct block_device *part,
-					  unsigned int sectors, unsigned int op,
-					  unsigned long start_time)
+unsigned long bdev_start_io_acct(struct block_device *bdev,
+				 unsigned int sectors, unsigned int op,
+				 unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
 
 	part_stat_lock();
-	update_io_ticks(part, start_time, false);
-	part_stat_inc(part, ios[sgrp]);
-	part_stat_add(part, sectors[sgrp], sectors);
-	part_stat_local_inc(part, in_flight[op_is_write(op)]);
+	update_io_ticks(bdev, start_time, false);
+	part_stat_inc(bdev, ios[sgrp]);
+	part_stat_add(bdev, sectors[sgrp], sectors);
+	part_stat_local_inc(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
 	return start_time;
 }
+EXPORT_SYMBOL(bdev_start_io_acct);
 
 /**
  * bio_start_io_acct_time - start I/O accounting for bio based drivers
@@ -1045,8 +1046,8 @@ static unsigned long __part_start_io_acct(struct block_device *part,
  */
 void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
 {
-	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-			     bio_op(bio), start_time);
+	bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			   bio_op(bio), start_time);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
 
@@ -1058,46 +1059,33 @@ EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				    bio_op(bio), jiffies);
+	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+				  bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
-unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
-				 unsigned int op)
-{
-	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
-}
-EXPORT_SYMBOL(disk_start_io_acct);
-
-static void __part_end_io_acct(struct block_device *part, unsigned int op,
-			       unsigned long start_time)
+void bdev_end_io_acct(struct block_device *bdev, unsigned int op,
+		      unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
 	unsigned long now = READ_ONCE(jiffies);
 	unsigned long duration = now - start_time;
 
 	part_stat_lock();
-	update_io_ticks(part, now, true);
-	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
-	part_stat_local_dec(part, in_flight[op_is_write(op)]);
+	update_io_ticks(bdev, now, true);
+	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 }
+EXPORT_SYMBOL(bdev_end_io_acct);
 
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
-		struct block_device *orig_bdev)
+			      struct block_device *orig_bdev)
 {
-	__part_end_io_acct(orig_bdev, bio_op(bio), start_time);
+	bdev_end_io_acct(orig_bdev, bio_op(bio), start_time);
 }
 EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
-void disk_end_io_acct(struct gendisk *disk, unsigned int op,
-		      unsigned long start_time)
-{
-	__part_end_io_acct(disk->part0, op, start_time);
-}
-EXPORT_SYMBOL(disk_end_io_acct);
-
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
  * @q : the queue of the device being checked
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
2.15.0


--===============4162643757411405702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4162643757411405702==--

