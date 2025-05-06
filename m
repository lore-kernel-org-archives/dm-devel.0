Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F528001C
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536243; cv=none; b=hl0LdsHHad8tSTZlEK1MPpN362zuZVukfWW5cfWvrlgMPAl7hR9/bJqGt/KWgVvYHeQtIrDsrsMUZ97ahuxzrfDKZZmcwYrF64441SJW/79ic+CVdIHtzGFDc6GuRrNOV5be4S4DK3SAFT9rS4AvBs+LNW9KDEFvwNxMEfxJjF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536243; c=relaxed/simple;
	bh=9HvytNFZLzxscgQdQ7UkwMiUyIzF+y/aobPVsrzIgko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ln3gJV3yjfNd4Rv/O9ij5I1GHPZ07eDnGiNAHizpp54h7juCJWrBSeijkX7ofnp69j2rvaTOS3SSM9QKJIAYEObfxsbjQTy2jFeZ78oiXzm3AsZkcZsW0VkoACs6U9iKqG4YthbC4kY6CnsnBpGngvHPfZNfBfFcGXJLuD8YYd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZsJLs6lHvz4f3jd2
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:56:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 675C81A0F0E
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S9;
	Tue, 06 May 2025 20:57:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	song@kernel.org,
	hch@lst.de,
	john.g.garry@oracle.com,
	hare@suse.de,
	xni@redhat.com,
	pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 5/9] block: export API to get the number of bdev inflight IO
Date: Tue,  6 May 2025 20:48:59 +0800
Message-Id: <20250506124903.2540268-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506124903.2540268-1-yukuai1@huaweicloud.com>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S9
X-Coremail-Antispam: 1UD129KBjvJXoWxAF13Xr13Cr1kWw1UCFW5GFg_yoWrCF4Dpr
	1UGas8ArZ8Kr1fuF1Utw4xWr1ftw4qk34Svr1xA34akF4DtrySvF92yr92yr4SvrZ7AFWU
	uw1YkF97CF1jkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

- rename part_in_{flight, flight_rw} to bdev_count_{inflight, inflight_rw}
- export bdev_count_inflight, to fix a problem in mdraid that foreground
  IO can be starved by background sync IO in later patches

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
index ff21f234b62f..c5a18f0fd3a9 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -421,7 +421,6 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
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

