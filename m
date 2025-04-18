Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CAE433C4
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939016; cv=none; b=Jf0CGyw4u/V2CRtbF9w2J6iElk2rgeOw+hL4IFv/ig8wpbggpDNs6920G/mKfyTgaMPvI+uH0xiGoeY8ZCF6OKICUPUnStXMQNbo2ibxSF+dSyKUWZ8ojhamCcMCvgdbhGEhbd0U0UEHQc1Q3WgyCdJ/nsFiLl4qX1eDK/b0Z8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939016; c=relaxed/simple;
	bh=SP6IEDez3ywyfEcGSwvguVNEtstiBWYr8YsoFHc3QlI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tl9Y2FcrJpOzIAZ9DTjZOrsvd816ZmPjwOSJZq/aJHo8eqbWrJZlfHYehwieJX9Gl12HWkEnoMhXsJOqQQ2/bMdYWCfe1qGHHxCFLNr06rOBmn34VRTTFZdol30/mRw8zE4WQ99D9jTq9dqRTPraAqdyZ9/tSvb4k3E5F0i2GHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zdxg3495Kz4f3jYl
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F33141A058E
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S8;
	Fri, 18 Apr 2025 09:16:49 +0800 (CST)
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
Subject: [PATCH v2 4/5] md: fix is_mddev_idle()
Date: Fri, 18 Apr 2025 09:09:40 +0800
Message-Id: <20250418010941.667138-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S8
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr48WrW5Xw1kJF1DGFW3ZFb_yoW7Ar4xpF
	W3ua43trW8XFWSqw45JFyv9a4Fg34fJ39xtFy3A34xZF15Grs0kF4agFWYv3s8W3ykZFya
	qa15KF4DCa4UJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjTRNdb1DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If sync_speed is above speed_min, then is_mddev_idle() will be called
for each sync IO to check if the array is idle, and inflihgt sync_io
will be limited if the array is not idle.

However, while mkfs.ext4 for a large raid5 array while recovery is in
progress, it's found that sync_speed is already above speed_min while
lots of stripes are used for sync IO, causing long delay for mkfs.ext4.

Root cause is the following checking from is_mddev_idle():

t1: submit sync IO: events1 = completed IO - issued sync IO
t2: submit next sync IO: events2  = completed IO - issued sync IO
if (events2 - events1 > 64)

For consequence, the more sync IO issued, the less likely checking will
pass. And when completed normal IO is more than issued sync IO, the
condition will finally pass and is_mddev_idle() will return false,
however, last_events will be updated hence is_mddev_idle() can only
return false once in a while.

Fix this problem by changing the checking as following:

1) mddev doesn't have normal IO completed;
2) mddev doesn't have normal IO inflight;
3) if any member disks is partition, and all other partitions doesn't
   have IO completed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 84 +++++++++++++++++++++++++++----------------------
 drivers/md/md.h |  3 +-
 2 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 52cadfce7e8d..dfd85a5d6112 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8625,50 +8625,58 @@ void md_cluster_stop(struct mddev *mddev)
 	put_cluster_ops(mddev);
 }
 
-static int is_mddev_idle(struct mddev *mddev, int init)
+static bool is_rdev_holder_idle(struct md_rdev *rdev, bool init)
 {
+	unsigned long last_events = rdev->last_events;
+
+	if (!bdev_is_partition(rdev->bdev))
+		return true;
+
+	/*
+	 * If rdev is partition, and user doesn't issue IO to the array, the
+	 * array is still not idle if user issues IO to other partitions.
+	 */
+	rdev->last_events = part_stat_read_accum(rdev->bdev->bd_disk->part0,
+						 sectors) -
+			    part_stat_read_accum(rdev->bdev, sectors);
+
+	if (!init && rdev->last_events > last_events)
+		return false;
+
+	return true;
+}
+
+/*
+ * mddev is idle if following conditions are match since last check:
+ * 1) mddev doesn't have normal IO completed;
+ * 2) mddev doesn't have inflight normal IO;
+ * 3) if any member disk is partition, and other partitions doesn't have IO
+ *    completed;
+ *
+ * Noted this checking rely on IO accounting is enabled.
+ */
+static bool is_mddev_idle(struct mddev *mddev, int init)
+{
+	unsigned long last_events = mddev->last_events;
+	struct gendisk *disk;
 	struct md_rdev *rdev;
-	int idle;
-	int curr_events;
+	bool idle = true;
 
-	idle = 1;
-	rcu_read_lock();
-	rdev_for_each_rcu(rdev, mddev) {
-		struct gendisk *disk = rdev->bdev->bd_disk;
+	disk = mddev_is_dm(mddev) ? mddev->dm_gendisk : mddev->gendisk;
+	if (!disk)
+		return true;
 
-		if (!init && !blk_queue_io_stat(disk->queue))
-			continue;
+	mddev->last_events = part_stat_read_accum(disk->part0, sectors);
+	if (!init && (mddev->last_events > last_events ||
+		      bdev_count_inflight(disk->part0)))
+		idle = false;
 
-		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
-			      atomic_read(&disk->sync_io);
-		/* sync IO will cause sync_io to increase before the disk_stats
-		 * as sync_io is counted when a request starts, and
-		 * disk_stats is counted when it completes.
-		 * So resync activity will cause curr_events to be smaller than
-		 * when there was no such activity.
-		 * non-sync IO will cause disk_stat to increase without
-		 * increasing sync_io so curr_events will (eventually)
-		 * be larger than it was before.  Once it becomes
-		 * substantially larger, the test below will cause
-		 * the array to appear non-idle, and resync will slow
-		 * down.
-		 * If there is a lot of outstanding resync activity when
-		 * we set last_event to curr_events, then all that activity
-		 * completing might cause the array to appear non-idle
-		 * and resync will be slowed down even though there might
-		 * not have been non-resync activity.  This will only
-		 * happen once though.  'last_events' will soon reflect
-		 * the state where there is little or no outstanding
-		 * resync requests, and further resync activity will
-		 * always make curr_events less than last_events.
-		 *
-		 */
-		if (init || curr_events - rdev->last_events > 64) {
-			rdev->last_events = curr_events;
-			idle = 0;
-		}
-	}
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev)
+		if (!is_rdev_holder_idle(rdev, init))
+			idle = false;
 	rcu_read_unlock();
+
 	return idle;
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b57842188f18..1d51c2405d3d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -132,7 +132,7 @@ struct md_rdev {
 
 	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	struct mddev *mddev;		/* RAID array if running */
-	int last_events;		/* IO event timestamp */
+	unsigned long last_events;	/* IO event timestamp */
 
 	/*
 	 * If meta_bdev is non-NULL, it means that a separate device is
@@ -520,6 +520,7 @@ struct mddev {
 							 * adding a spare
 							 */
 
+	unsigned long			last_events;	/* IO event timestamp */
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
-- 
2.39.2

