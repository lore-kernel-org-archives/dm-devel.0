Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABC4C61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 23 Feb 2023 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677143224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g7Wedk9W6pgXYinNYL4HMcR62zNg+tmH/7wD1F4EMSQ=;
	b=FcsvRFzt66WFd2PUp84Q5PYnVHdY348YX1QiRSVCedl/sbsTqtzyXmmWiQNbP8BdHukKxy
	ysvl2Jhave5G4uTCXqlsGu3SK7hhIRQiggGcvNiA5im2v6+iZMHT8eRaz2ukAqFFHqQRXg
	aKFjd7jMYblXUbfqbyTAeti06ts01b0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-GvJrwUEoMpmPTE60aOJQIw-1; Thu, 23 Feb 2023 04:07:01 -0500
X-MC-Unique: GvJrwUEoMpmPTE60aOJQIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AD79803493;
	Thu, 23 Feb 2023 09:06:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 093574014D1B;
	Thu, 23 Feb 2023 09:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E05B819465B1;
	Thu, 23 Feb 2023 09:06:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C725819465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Feb 2023 09:06:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A1AB492C18; Thu, 23 Feb 2023 09:06:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82A3E492C14
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 09:06:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 675BF85A588
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 09:06:56 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-Z6d2LS4bNl-lQ9dtvJ-jtA-1; Thu, 23 Feb 2023 04:06:54 -0500
X-MC-Unique: Z6d2LS4bNl-lQ9dtvJ-jtA-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PMmsP14lMz4f3l6l;
 Thu, 23 Feb 2023 16:48:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgBH9CF5KPdjdmo0Dw--.40730S4;
 Thu, 23 Feb 2023 16:48:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, guz.fnst@cn.fujitsu.com
Date: Thu, 23 Feb 2023 17:12:26 +0800
Message-Id: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgBH9CF5KPdjdmo0Dw--.40730S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr1fXr43Gr1DGr4UXr4rGrg_yoW7AF1fpF
 48W3WrCrZrXwnYg3yUAayDuF1rKa10q347AFW7J345Zw4ktryvvF10y3Wqyr15Ca97uFW7
 Aa48AF9rur42k37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
 Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
 xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
 MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
 0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v2
 6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
 U6c_fUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH -next RFC] block: count 'ios' and 'sectors' when
 io is done for bio-based device
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

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
---
 block/blk-core.c              | 16 ++++++----------
 drivers/md/dm.c               |  6 +++---
 drivers/nvme/host/multipath.c |  8 ++++----
 include/linux/blkdev.h        |  5 ++---
 4 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82b5b2c53f1e..fe1d320f5f07 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -953,16 +953,11 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
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
 
@@ -978,13 +973,12 @@ EXPORT_SYMBOL(bdev_start_io_acct);
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
@@ -992,6 +986,8 @@ void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
 
 	part_stat_lock();
 	update_io_ticks(bdev, now, true);
+	part_stat_inc(bdev, ios[sgrp]);
+	part_stat_add(bdev, sectors[sgrp], sectors);
 	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
 	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
@@ -1001,7 +997,7 @@ EXPORT_SYMBOL(bdev_end_io_acct);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 			      struct block_device *orig_bdev)
 {
-	bdev_end_io_acct(orig_bdev, bio_op(bio), start_time);
+	bdev_end_io_acct(orig_bdev, bio_op(bio), bio_sectors(bio), start_time);
 }
 EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eace45a18d45..f5cc330bb549 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -512,10 +512,10 @@ static void dm_io_acct(struct dm_io *io, bool end)
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
index fc39d01e7b63..9171452e2f6d 100644
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
index d1aee08f8c18..941304f17492 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1446,11 +1446,10 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
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
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

