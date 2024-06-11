Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1AB17DE12
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112206; cv=none; b=eFNW0ff/EN9vAdbLN/YM42V69WGbZyOVRZvJzvl0lna4g4ESRfJiJbHYud4pzNFOzqIodfPgj14Y0OL6u3i77Evhi5JX6/53/+EwoPfSfqS3ykCdzB2rOhmprqnG3EQGQSa5GTuilfqEfzSf9eqra/pK2kLIC84VoPjafjh4hB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112206; c=relaxed/simple;
	bh=p6GcwtlwvyezQBURAJy6CD+f1+JDfefWGbpm3TwM6BQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uk6oY4iX4jpDPKH5O7/8zwykRCjj2a5my3nMfp82+3oYDjeKs8+dUIdATxaAVTlJr0rw6p0Ct9cVIA8D4AjtL1fNJePnYk6vkHeF6XEJEy9kaFvNvack/ivSAAL4ectjkADflzu818YVtbLV4sFI/BY/XpI5hCAfx4r5t8AR+7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W173PJz4f3lfQ
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 67C211A058E
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S15;
	Tue, 11 Jun 2024 21:23:21 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 11/12] md: pass in max_sectors for pers->sync_request()
Date: Tue, 11 Jun 2024 21:22:50 +0800
Message-Id: <20240611132251.1967786-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S15
X-Coremail-Antispam: 1UD129KBjvJXoWxXr4fJF1kGrW3XrWDtr4ktFb_yoWrKF4kpa
	18JFy3ZrW7W3y5Jwn8AryDua4Fva43trWqyry3u3s3WFn3Kr9rAF1rXa1UXFyDua4rJrW5
	tw1UJr45u3Z2grJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

For different sync_action, sync_thread will use different max_sectors,
see details in md_sync_max_sectors(), currently both md_do_sync() and
pers->sync_request() in eatch iteration have to get the same
max_sectors. Hence pass in max_sectors for pers->sync_request() to
prevent redundant code.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c     | 5 +++--
 drivers/md/md.h     | 3 ++-
 drivers/md/raid1.c  | 5 ++---
 drivers/md/raid10.c | 8 ++------
 drivers/md/raid5.c  | 3 +--
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ec2ef4dd42cf..c0426a6d2fd1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9186,7 +9186,8 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
-		sectors = mddev->pers->sync_request(mddev, j, &skipped);
+		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
+						    &skipped);
 		if (sectors == 0) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			break;
@@ -9276,7 +9277,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
-	mddev->pers->sync_request(mddev, max_sectors, &skipped);
+	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 41781e41d8ff..2dc52edec3fe 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -729,7 +729,8 @@ struct md_personality
 	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
-	sector_t (*sync_request)(struct mddev *mddev, sector_t sector_nr, int *skipped);
+	sector_t (*sync_request)(struct mddev *mddev, sector_t sector_nr,
+				 sector_t max_sector, int *skipped);
 	int (*resize) (struct mddev *mddev, sector_t sectors);
 	sector_t (*size) (struct mddev *mddev, sector_t sectors, int raid_disks);
 	int (*check_reshape) (struct mddev *mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3d54f30112a0..2bbfb4e682b2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2756,12 +2756,12 @@ static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
  */
 
 static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
-				   int *skipped)
+				   sector_t max_sector, int *skipped)
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 	struct bio *bio;
-	sector_t max_sector, nr_sectors;
+	sector_t nr_sectors;
 	int disk = -1;
 	int i;
 	int wonly = -1;
@@ -2777,7 +2777,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (init_resync(conf))
 			return 0;
 
-	max_sector = mddev->dev_sectors;
 	if (sector_nr >= max_sector) {
 		/* If we aborted, we need to abort the
 		 * sync on the 'current' bitmap chunk (there will
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f8d7c02c6ed5..4e804602d1e5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3139,12 +3139,12 @@ static void raid10_set_cluster_sync_high(struct r10conf *conf)
  */
 
 static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
-			     int *skipped)
+				    sector_t max_sector, int *skipped)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 	struct bio *biolist = NULL, *bio;
-	sector_t max_sector, nr_sectors;
+	sector_t nr_sectors;
 	int i;
 	int max_sync;
 	sector_t sync_blocks;
@@ -3174,10 +3174,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			return 0;
 
  skipped:
-	max_sector = mddev->dev_sectors;
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
-		max_sector = mddev->resync_max_sectors;
 	if (sector_nr >= max_sector) {
 		conf->cluster_sync_low = 0;
 		conf->cluster_sync_high = 0;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a84389311dd1..013adc5ba0e1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6457,11 +6457,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 }
 
 static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_nr,
-					  int *skipped)
+					  sector_t max_sector, int *skipped)
 {
 	struct r5conf *conf = mddev->private;
 	struct stripe_head *sh;
-	sector_t max_sector = mddev->dev_sectors;
 	sector_t sync_blocks;
 	int still_degraded = 0;
 	int i;
-- 
2.39.2

