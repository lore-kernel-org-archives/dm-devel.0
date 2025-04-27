Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13C248871
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745743034; cv=none; b=LSLbyy80q/gXqu7urAk/3XDsAMZTZY0olNebvQIL4UI+FUEH9ISTKMh/eQCPqO1ZPY5fJgxDKN+FYxakD+vItKwh8lITsvkJASbxhjHzdGvMbJhV08tOEzx7fw/OJVlVk3xTkiY8ZV/cH6zkK0K/EanY/2Hi5iKd9gYS2u1c5P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745743034; c=relaxed/simple;
	bh=ijmU0npkFWkOhFlJZmS1k2UfSaOwsdS9IBPLWBwjzwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m40MVNiAhiwaVhqNw0QvXBQEOmE5/RCLFqMvJnQxfe5CkCglVh+JuGx/+QL/ZGS9LEY7PMKqGG9OIUto0lcNsIsvayl2rCKxP6pWbbwcPnIIV0T4ed5LhGOTH/uKjmV9FcbS9L08vuk3EjwrHm/kZuVvM3Xov+8URrQtjpZSwD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zlg1M0QyszYQv4j
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 89BF91A0A31
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDHGsWx7A1oOv4xKg--.7274S8;
	Sun, 27 Apr 2025 16:37:10 +0800 (CST)
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
Subject: [PATCH v2 4/9] block: cleanup blk_mq_in_flight_rw()
Date: Sun, 27 Apr 2025 16:29:23 +0800
Message-Id: <20250427082928.131295-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDHGsWx7A1oOv4xKg--.7274S8
X-Coremail-Antispam: 1UD129KBjvJXoWxuF15Jw1xtw45KF47Ar43ZFb_yoWrZF45pr
	45Ka98trW5Wr1fur1xtan7XF1fKw48KryIvwnxAr1ayr18Kr98ZFy8Gw1kAr1SvrykCFW3
	C3WYyFy7GF1UC37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7sRiHUDtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Also add comment for part_inflight_show() for the difference between
bio-based and rq-based device.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-mq.c | 12 ++++++------
 block/blk-mq.h |  3 +--
 block/genhd.c  | 43 +++++++++++++++++++++++++------------------
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 301dbd3e1743..0067e8226e05 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -89,7 +89,7 @@ struct mq_inflight {
 	unsigned int inflight[2];
 };
 
-static bool blk_mq_check_inflight(struct request *rq, void *priv)
+static bool blk_mq_check_in_driver(struct request *rq, void *priv)
 {
 	struct mq_inflight *mi = priv;
 
@@ -101,14 +101,14 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv)
 	return true;
 }
 
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2])
+void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2])
 {
 	struct mq_inflight mi = { .part = part };
 
-	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
-	inflight[0] = mi.inflight[0];
-	inflight[1] = mi.inflight[1];
+	blk_mq_queue_tag_busy_iter(bdev_get_queue(part), blk_mq_check_in_driver,
+				   &mi);
+	inflight[READ] = mi.inflight[READ];
+	inflight[WRITE] = mi.inflight[WRITE];
 }
 
 #ifdef CONFIG_LOCKDEP
diff --git a/block/blk-mq.h b/block/blk-mq.h
index a23d5812d08f..4205da1a4836 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -246,8 +246,7 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2]);
+void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2]);
 
 static inline void blk_mq_put_dispatch_budget(struct request_queue *q,
 					      int budget_token)
diff --git a/block/genhd.c b/block/genhd.c
index d158c25237b6..2470099b492b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -126,27 +126,32 @@ static void part_stat_read_all(struct block_device *part,
 }
 
 static void part_in_flight_rw(struct block_device *part,
-		unsigned int inflight[2])
+		unsigned int inflight[2], bool mq_driver)
 {
 	int cpu;
 
-	inflight[0] = 0;
-	inflight[1] = 0;
-	for_each_possible_cpu(cpu) {
-		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
-		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
+	if (mq_driver) {
+		blk_mq_in_driver_rw(part, inflight);
+	} else {
+		for_each_possible_cpu(cpu) {
+			inflight[READ] += part_stat_local_read_cpu(
+						part, in_flight[READ], cpu);
+			inflight[WRITE] += part_stat_local_read_cpu(
+						part, in_flight[WRITE], cpu);
+		}
 	}
-	if (WARN_ON_ONCE((int)inflight[0] < 0))
-		inflight[0] = 0;
-	if (WARN_ON_ONCE((int)inflight[1] < 0))
-		inflight[1] = 0;
+
+	if (WARN_ON_ONCE((int)inflight[READ] < 0))
+		inflight[READ] = 0;
+	if (WARN_ON_ONCE((int)inflight[WRITE] < 0))
+		inflight[WRITE] = 0;
 }
 
 unsigned int part_in_flight(struct block_device *part)
 {
-	unsigned int inflight[2];
+	unsigned int inflight[2] = {0};
 
-	part_in_flight_rw(part, inflight);
+	part_in_flight_rw(part, inflight, false);
 
 	return inflight[READ] + inflight[WRITE];
 }
@@ -1036,19 +1041,21 @@ ssize_t part_stat_show(struct device *dev,
 		(unsigned int)div_u64(stat.nsecs[STAT_FLUSH], NSEC_PER_MSEC));
 }
 
+/*
+ * Show the number of IOs issued to driver.
+ * For bio-based device, started from bdev_start_io_acct();
+ * For rq-based device, started from blk_mq_start_request();
+ */
 ssize_t part_inflight_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	struct block_device *bdev = dev_to_bdev(dev);
 	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int inflight[2];
+	unsigned int inflight[2] = {0};
 
-	if (queue_is_mq(q))
-		blk_mq_in_flight_rw(q, bdev, inflight);
-	else
-		part_in_flight_rw(bdev, inflight);
+	part_in_flight_rw(bdev, inflight, queue_is_mq(q));
 
-	return sysfs_emit(buf, "%8u %8u\n", inflight[0], inflight[1]);
+	return sysfs_emit(buf, "%8u %8u\n", inflight[READ], inflight[WRITE]);
 }
 
 static ssize_t disk_capability_show(struct device *dev,
-- 
2.39.2

