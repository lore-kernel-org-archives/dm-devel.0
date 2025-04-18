Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D81D41C72
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939014; cv=none; b=Ox/cF6iFUAD5odBbCHXaFKxQRB0TfxgmbrdjwoKQHrRwOhY25BU9/jZgaR0gSexvPNLX/z74L+HdU8R7BkKzALbACHNRITeVUNdp1II1EsMicdpRSRwP8GVMdc5wtiaBiyBJok/9tbud7J9NQyIpba9Z4H97j0s9wHBjCEh90WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939014; c=relaxed/simple;
	bh=KZu7IqF7NwdZavaKYK1LOOM1qL9xtr2+q32UGZ4T7O8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T283sxcJaa2Ep0zrbhs1jk0QjYcFYbcdERDoWcWw2QV/Tt+aNBnAkcmpp0H3dQ7927BQVrNHAqP5cBTijK623rh3BHXUB5DlNOyP2e4a/mvT2lYU39tC/7WuuqyFzrXqvAxqYhG07ClMKZd9K7rRQ0xgG2avgprw2EJLJ2tyIik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zdxfx3XMDz4f3kFH
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3FE151A199B
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S7;
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
Subject: [PATCH v2 3/5] md: add a new api sync_io_depth
Date: Fri, 18 Apr 2025 09:09:39 +0800
Message-Id: <20250418010941.667138-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S7
X-Coremail-Antispam: 1UD129KBjvJXoWxKFW7uw47JrWrKw4fWF4xCrg_yoWxtFWrpa
	y2yFy3Gr1UZFZxXr43JFsxCa4rXr4fK3yUt3y7Gw1xJF13Wr9rGF1SgFW5XF9rWa4fCrnr
	ZF1UJFZ8ua1xtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRM6wCDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently if sync speed is above speed_min and below speed_max,
md_do_sync() will wait for all sync IOs to be done before issuing new
sync IO, means sync IO depth is limited to just 1.

This limit is too low, in order to prevent sync speed drop conspicuously
after fixing is_mddev_idle() in the next patch, add a new api for
limiting sync IO depth, the default value is 32.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 109 +++++++++++++++++++++++++++++++++++++++---------
 drivers/md/md.h |   1 +
 2 files changed, 91 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 438e71e45c16..52cadfce7e8d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -111,32 +111,48 @@ static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
 /* Default safemode delay: 200 msec */
 #define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
 /*
- * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
- * is 1000 KB/sec, so the extra system load does not show up that much.
- * Increase it if you want to have more _guaranteed_ speed. Note that
- * the RAID driver will use the maximum available bandwidth if the IO
- * subsystem is idle. There is also an 'absolute maximum' reconstruction
- * speed limit - in case reconstruction slows down your system despite
- * idle IO detection.
+ * Current RAID-1,4,5,6,10 parallel reconstruction 'guaranteed speed limit'
+ * is sysctl_speed_limit_min, 1000 KB/sec by default, so the extra system load
+ * does not show up that much. Increase it if you want to have more guaranteed
+ * speed. Note that the RAID driver will use the maximum bandwidth
+ * sysctl_speed_limit_max, 200 MB/sec by default, if the IO subsystem is idle.
  *
- * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
- * or /sys/block/mdX/md/sync_speed_{min,max}
+ * Background sync IO speed control:
+ *
+ * - below speed min:
+ *   no limit;
+ * - above speed min and below speed max:
+ *   a) if mddev is idle, then no limit;
+ *   b) if mddev is busy handling normal IO, then limit inflight sync IO
+ *   to sync_io_depth;
+ * - above speed max:
+ *   sync IO can't be issued;
+ *
+ * Following configurations can be changed via /proc/sys/dev/raid/ for system
+ * or /sys/block/mdX/md/ for one array.
  */
-
 static int sysctl_speed_limit_min = 1000;
 static int sysctl_speed_limit_max = 200000;
-static inline int speed_min(struct mddev *mddev)
+static int sysctl_sync_io_depth = 32;
+
+static int speed_min(struct mddev *mddev)
 {
 	return mddev->sync_speed_min ?
 		mddev->sync_speed_min : sysctl_speed_limit_min;
 }
 
-static inline int speed_max(struct mddev *mddev)
+static int speed_max(struct mddev *mddev)
 {
 	return mddev->sync_speed_max ?
 		mddev->sync_speed_max : sysctl_speed_limit_max;
 }
 
+static int sync_io_depth(struct mddev *mddev)
+{
+	return mddev->sync_io_depth ?
+		mddev->sync_io_depth : sysctl_sync_io_depth;
+}
+
 static void rdev_uninit_serial(struct md_rdev *rdev)
 {
 	if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
@@ -293,14 +309,21 @@ static const struct ctl_table raid_table[] = {
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "speed_limit_max",
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sync_io_depth",
+		.data		= &sysctl_sync_io_depth,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 };
@@ -5091,7 +5114,7 @@ static ssize_t
 sync_min_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_min(mddev),
-		       mddev->sync_speed_min ? "local": "system");
+		       mddev->sync_speed_min ? "local" : "system");
 }
 
 static ssize_t
@@ -5100,7 +5123,7 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int min;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		min = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &min);
@@ -5120,7 +5143,7 @@ static ssize_t
 sync_max_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_max(mddev),
-		       mddev->sync_speed_max ? "local": "system");
+		       mddev->sync_speed_max ? "local" : "system");
 }
 
 static ssize_t
@@ -5129,7 +5152,7 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int max;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		max = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &max);
@@ -5145,6 +5168,35 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_sync_max =
 __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
 
+static ssize_t
+sync_io_depth_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%d (%s)\n", sync_io_depth(mddev),
+		       mddev->sync_io_depth ? "local" : "system");
+}
+
+static ssize_t
+sync_io_depth_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned int max;
+	int rv;
+
+	if (strncmp(buf, "system", 6) == 0) {
+		max = 0;
+	} else {
+		rv = kstrtouint(buf, 10, &max);
+		if (rv < 0)
+			return rv;
+		if (max == 0)
+			return -EINVAL;
+	}
+	mddev->sync_io_depth = max;
+	return len;
+}
+
+static struct md_sysfs_entry md_sync_io_depth =
+__ATTR_RW(sync_io_depth);
+
 static ssize_t
 degraded_show(struct mddev *mddev, char *page)
 {
@@ -5671,6 +5723,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_mismatches.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
+	&md_sync_io_depth.attr,
 	&md_sync_speed.attr,
 	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
@@ -8927,6 +8980,23 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 	}
 }
 
+static bool sync_io_within_limit(struct mddev *mddev)
+{
+	int io_sectors;
+
+	/*
+	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
+	 * RESYNC_PAGES(64k) per IO.
+	 */
+	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
+		io_sectors = 8;
+	else
+		io_sectors = 128;
+
+	return atomic_read(&mddev->recovery_active) <
+		io_sectors * sync_io_depth(mddev);
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9195,7 +9265,8 @@ void md_do_sync(struct md_thread *thread)
 				msleep(500);
 				goto repeat;
 			}
-			if (!is_mddev_idle(mddev, 0)) {
+			if (!sync_io_within_limit(mddev) &&
+			    !is_mddev_idle(mddev, 0)) {
 				/*
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9d55b4630077..b57842188f18 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -484,6 +484,7 @@ struct mddev {
 	/* if zero, use the system-wide default */
 	int				sync_speed_min;
 	int				sync_speed_max;
+	int				sync_io_depth;
 
 	/* resync even though the same disks are shared among md-devices */
 	int				parallel_resync;
-- 
2.39.2

