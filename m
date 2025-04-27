Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745124C074
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745743037; cv=none; b=ZKkdZWaNQR1Mx2RjybcFURVl7vhR4Nnd1IwdTMZstBO8lzuArlDvkwV54ZXg9CM0ydVUYr934tIYV267jaLLmd8BlNYor5EGjx4U64UV1cvBxExWfPnk6AZukY2C+CjwwURvPVfiv7fSspMHjBYAfC6HhIwFheW5yXSRxxv4ing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745743037; c=relaxed/simple;
	bh=3Zm8ayzm+HKCEu5hYRFXLS/uWZqvyuAb/t6xkLJTbOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W4D3z4RQgMnkAw1OoZADCcjZFw5PXkOT5iVzKcdhzDHH/1s6lQP/xlMMoMGTuBK0SwrTSh+cMYzO48Ybimr6aGxSVmW8GI1bEr8b8Ha8nQrQ20EJLPO6cQWgOzClOsmBKZmQvh5yK1cI9U+XhiwQ3orzbnoddcMbYCvqHwtXu4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zlg0s4RcPz4f3lDG
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:36:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 43C521A0EE1
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDHGsWx7A1oOv4xKg--.7274S9;
	Sun, 27 Apr 2025 16:37:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	cl@linux.com,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 5/9] block: export API to get the number of bdev inflight IO
Date: Sun, 27 Apr 2025 16:29:24 +0800
Message-Id: <20250427082928.131295-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250427082928.131295-1-yukuai1@huaweicloud.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDHGsWx7A1oOv4xKg--.7274S9
X-Coremail-Antispam: 1UD129KBjvJXoWxAF13Xr13Cr1Uuw1rJw1DZFb_yoWrAFWDpr
	1UGas8ArZ0gr1fuF4Dtw4xWr1Sqw4qk34Ivw1xA34akF4DtrySvas2yr92yr4SvrZ7AFWU
	u34YkF97CF1jkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

- rename part_in_{flight, flight_rw} to bdev_count_{inflight, inflight_rw}
- export bdev_count_inflight, to fix a problem in mdraid that foreground
  IO can be starved by background sync IO in later patches

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-core.c          |  2 +-
 block/blk.h               |  1 -
 block/genhd.c             | 22 ++++++++++++++++------
 include/linux/part_stat.h |  2 ++
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e8cc270a453f..b862c66018f2 100644
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
index 2470099b492b..fdaeafddfc4c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -125,7 +125,7 @@ static void part_stat_read_all(struct block_device *part,
 	}
 }
 
-static void part_in_flight_rw(struct block_device *part,
+static void bdev_count_inflight_rw(struct block_device *part,
 		unsigned int inflight[2], bool mq_driver)
 {
 	int cpu;
@@ -147,14 +147,24 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[WRITE] = 0;
 }
 
-unsigned int part_in_flight(struct block_device *part)
+/**
+ * bdev_count_inflight - get the number of inflight IOs for a block device.
+ *
+ * @part: the block device.
+ *
+ * Inflight here means started IO accounting, from bdev_start_io_acct() for
+ * bio-based block device, and from blk_account_io_start() for rq-based block
+ * device.
+ */
+unsigned int bdev_count_inflight(struct block_device *part)
 {
 	unsigned int inflight[2] = {0};
 
-	part_in_flight_rw(part, inflight, false);
+	bdev_count_inflight_rw(part, inflight, false);
 
 	return inflight[READ] + inflight[WRITE];
 }
+EXPORT_SYMBOL_GPL(bdev_count_inflight);
 
 /*
  * Can be deleted altogether. Later.
@@ -1004,7 +1014,7 @@ ssize_t part_stat_show(struct device *dev,
 	struct disk_stats stat;
 	unsigned int inflight;
 
-	inflight = part_in_flight(bdev);
+	inflight = bdev_count_inflight(bdev);
 	if (inflight) {
 		part_stat_lock();
 		update_io_ticks(bdev, jiffies, true);
@@ -1053,7 +1063,7 @@ ssize_t part_inflight_show(struct device *dev, struct device_attribute *attr,
 	struct request_queue *q = bdev_get_queue(bdev);
 	unsigned int inflight[2] = {0};
 
-	part_in_flight_rw(bdev, inflight, queue_is_mq(q));
+	bdev_count_inflight_rw(bdev, inflight, queue_is_mq(q));
 
 	return sysfs_emit(buf, "%8u %8u\n", inflight[READ], inflight[WRITE]);
 }
@@ -1308,7 +1318,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		if (bdev_is_partition(hd) && !bdev_nr_sectors(hd))
 			continue;
 
-		inflight = part_in_flight(hd);
+		inflight = bdev_count_inflight(hd);
 		if (inflight) {
 			part_stat_lock();
 			update_io_ticks(hd, jiffies, true);
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index c5e9cac0575e..eeeff2a04529 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -79,4 +79,6 @@ static inline void part_stat_set_all(struct block_device *part, int value)
 #define part_stat_local_read_cpu(part, field, cpu)			\
 	local_read(&(part_stat_get_cpu(part, field, cpu)))
 
+unsigned int bdev_count_inflight(struct block_device *part);
+
 #endif /* _LINUX_PART_STAT_H */
-- 
2.39.2

