Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB8E2AEE1
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 01:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939012; cv=none; b=d5ySP7uvOhF0ool/QE77vCloYE2bxFftHdhLKtyD8qnWEOC50Y5Yu3nfaBwyzZUnj7rBOOFSuX7y+Ox3k5952mDKZyttsf/ghsz6J54E9NMAzUepq5H12Qv5Rc9BuKbodUyEEDMPiaZnurU7NdDWQFmCYRwCGy5H71fqOoeTMaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939012; c=relaxed/simple;
	bh=Jau39SBrXHknyOdYiaz9O82TYiffYp3tf+jbGEJAANo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sw6QpfRTU5jDPMe6pDlX/y04tTGJPjx/zCkUXijBnozoOvBa7yQU1YjnZwCISgZuX+D6d2yGWpY9b6nLXSUoW74QrUGORTpUgkuNrQ+FOKSzEHdY/C+3Ni7c66fjWQSiXnkh61WCxF06JPg1hBawJPjKzCgah4b+dMUj79QCavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zdxg130dVz4f3k5s
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CC7791A058E
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S5;
	Fri, 18 Apr 2025 09:16:47 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	cl@linux.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 1/5] block: cleanup and export bdev IO inflight APIs
Date: Fri, 18 Apr 2025 09:09:37 +0800
Message-Id: <20250418010941.667138-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250418010941.667138-1-yukuai1@huaweicloud.com>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S5
X-Coremail-Antispam: 1UD129KBjvJXoW3AF1rtr1rXr4kCr15GF43trb_yoWxtr17pr
	45GasxJrWUKr1xur1Utw4xXr1ftw4qkryIvr1fA34akF4DtrnxZF1ktr1kArySvrWkAFW7
	uw1YyF9rGF1jkwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRMv31JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

- rename part_in_{flight, flight_rw} and to bdev_count_{inflight,
  inflight_rw}.
- export bdev_count_inflight_rw, to fix a problem in mdraid that foreground
  IO can be starved by background sync IO in later patches.
- reuse bdev_count_inflight_rw for bdev_count_inflight, also add warning if
  inflight is negative, means related driver is buggy.
- remove unused blk_mq_in_flight
- rename blk_mq_in_flight_rw to blk_mq_count_in_driver_rw, to distinguish
  from bdev_count_inflight_rw.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-core.c          |  2 +-
 block/blk-mq.c            | 15 +++---------
 block/blk-mq.h            |  7 +++---
 block/blk.h               |  1 -
 block/genhd.c             | 48 +++++++++++++++++++--------------------
 include/linux/part_stat.h | 10 ++++++++
 6 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4623de79effa..ead2072eb3bd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1018,7 +1018,7 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	stamp = READ_ONCE(part->bd_stamp);
 	if (unlikely(time_after(now, stamp)) &&
 	    likely(try_cmpxchg(&part->bd_stamp, &stamp, now)) &&
-	    (end || part_in_flight(part)))
+	    (end || bdev_count_inflight(part)))
 		__part_stat_add(part, io_ticks, now - stamp);
 
 	if (bdev_is_partition(part)) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c2697db59109..a2bd77601623 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -101,18 +101,9 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv)
 	return true;
 }
 
-unsigned int blk_mq_in_flight(struct request_queue *q,
-		struct block_device *part)
-{
-	struct mq_inflight mi = { .part = part };
-
-	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
-
-	return mi.inflight[0] + mi.inflight[1];
-}
-
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2])
+void blk_mq_count_in_driver_rw(struct request_queue *q,
+			       struct block_device *part,
+			       unsigned int inflight[2])
 {
 	struct mq_inflight mi = { .part = part };
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 3011a78cf16a..3897522f014f 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -246,10 +246,9 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-unsigned int blk_mq_in_flight(struct request_queue *q,
-		struct block_device *part);
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2]);
+void blk_mq_count_in_driver_rw(struct request_queue *q,
+			       struct block_device *part,
+			       unsigned int inflight[2]);
 
 static inline void blk_mq_put_dispatch_budget(struct request_queue *q,
 					      int budget_token)
diff --git a/block/blk.h b/block/blk.h
index 006e3be433d2..f476f233f195 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -418,7 +418,6 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 int blk_dev_init(void);
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
-unsigned int part_in_flight(struct block_device *part);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
diff --git a/block/genhd.c b/block/genhd.c
index c2bd86cd09de..8329bd539be3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -125,37 +125,35 @@ static void part_stat_read_all(struct block_device *part,
 	}
 }
 
-unsigned int part_in_flight(struct block_device *part)
-{
-	unsigned int inflight = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		inflight += part_stat_local_read_cpu(part, in_flight[0], cpu) +
-			    part_stat_local_read_cpu(part, in_flight[1], cpu);
-	}
-	if ((int)inflight < 0)
-		inflight = 0;
-
-	return inflight;
-}
-
-static void part_in_flight_rw(struct block_device *part,
-		unsigned int inflight[2])
+/**
+ * bdev_count_inflight_rw - get the number of inflight IOs for a block device.
+ *
+ * @bdev:	the block device.
+ * @inflight:	return number of inflight IOs, @inflight[0] for read and
+ *		@inflight[1] for write.
+ *
+ * For bio-based block device, IO is inflight from bdev_start_io_acct(), and for
+ * rq-based block device, IO is inflight from blk_account_io_start().
+ *
+ * Noted, for rq-based block device, use blk_mq_count_in_driver_rw() to get the
+ * number of requests issued to driver.
+ */
+void bdev_count_inflight_rw(struct block_device *bdev, unsigned int inflight[2])
 {
 	int cpu;
 
 	inflight[0] = 0;
 	inflight[1] = 0;
 	for_each_possible_cpu(cpu) {
-		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
-		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
+		inflight[0] += part_stat_local_read_cpu(bdev, in_flight[0], cpu);
+		inflight[1] += part_stat_local_read_cpu(bdev, in_flight[1], cpu);
 	}
-	if ((int)inflight[0] < 0)
+	if (WARN_ON_ONCE((int)inflight[0] < 0))
 		inflight[0] = 0;
-	if ((int)inflight[1] < 0)
+	if (WARN_ON_ONCE((int)inflight[1] < 0))
 		inflight[1] = 0;
 }
+EXPORT_SYMBOL_GPL(bdev_count_inflight_rw);
 
 /*
  * Can be deleted altogether. Later.
@@ -1005,7 +1003,7 @@ ssize_t part_stat_show(struct device *dev,
 	struct disk_stats stat;
 	unsigned int inflight;
 
-	inflight = part_in_flight(bdev);
+	inflight = bdev_count_inflight(bdev);
 	if (inflight) {
 		part_stat_lock();
 		update_io_ticks(bdev, jiffies, true);
@@ -1050,9 +1048,9 @@ ssize_t part_inflight_show(struct device *dev, struct device_attribute *attr,
 	unsigned int inflight[2];
 
 	if (queue_is_mq(q))
-		blk_mq_in_flight_rw(q, bdev, inflight);
+		blk_mq_count_in_driver_rw(q, bdev, inflight);
 	else
-		part_in_flight_rw(bdev, inflight);
+		bdev_count_inflight_rw(bdev, inflight);
 
 	return sysfs_emit(buf, "%8u %8u\n", inflight[0], inflight[1]);
 }
@@ -1307,7 +1305,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		if (bdev_is_partition(hd) && !bdev_nr_sectors(hd))
 			continue;
 
-		inflight = part_in_flight(hd);
+		inflight = bdev_count_inflight(hd);
 		if (inflight) {
 			part_stat_lock();
 			update_io_ticks(hd, jiffies, true);
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index c5e9cac0575e..6248e59dc891 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -79,4 +79,14 @@ static inline void part_stat_set_all(struct block_device *part, int value)
 #define part_stat_local_read_cpu(part, field, cpu)			\
 	local_read(&(part_stat_get_cpu(part, field, cpu)))
 
+void bdev_count_inflight_rw(struct block_device *bdev, unsigned int inflight[2]);
+
+static inline unsigned int bdev_count_inflight(struct block_device *bdev)
+{
+	unsigned int inflight[2];
+
+	bdev_count_inflight_rw(bdev, inflight);
+
+	return inflight[0] + inflight[1];
+}
 #endif /* _LINUX_PART_STAT_H */
-- 
2.39.2

