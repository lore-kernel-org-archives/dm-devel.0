Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8512C7FD
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419646; cv=none; b=dvE774k934Pg8fGs+xeKPRZtAp4KY1JDCNZnXtuKnzZdel1L24Qu2nrOkjmk3dTeBUOkqbvt8Qa1XIb1UOLs9d3pBH1qEaboAB2k1zgRKnjLDZomlk0B4D09KU3Nf5cHi+kacWAV1CpMeVvX6pDjXHMizZdS0M4htRyu4zLPFLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419646; c=relaxed/simple;
	bh=VzkuVyLAD0EzOcgP5NNPguozUkIKwVKBp4GGC4ZZue8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGHzd6BD6YmdIJpTEWGpDC2+EMGyTpEoLd+UoHnozsv3/Aiz4VHgxtfioLrgkkmAUIq7zgPhw7TSMLk34TrCt12SJBtd3wlLSwPovSBbRX/uSBv+s9JZNQB9auaix1mkcFG9XOhSwwV2epbgjjenAVEddjHCqa7rv5TXnM3SrUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtDHc2nDmzmW8y;
	Mon,  3 Jun 2024 20:56:12 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id AD7FD1403D2;
	Mon,  3 Jun 2024 21:00:27 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:19 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 11/12] md: pass in max_sectors for pers->sync_request()
Date: Mon, 3 Jun 2024 20:58:14 +0800
Message-ID: <20240603125815.2199072-12-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240603125815.2199072-1-yukuai3@huawei.com>
References: <20240603125815.2199072-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

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
index a1f9d9b69911..e1555971ebe8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9191,7 +9191,8 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
-		sectors = mddev->pers->sync_request(mddev, j, &skipped);
+		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
+						    &skipped);
 		if (sectors == 0) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			break;
@@ -9281,7 +9282,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
-	mddev->pers->sync_request(mddev, max_sectors, &skipped);
+	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 296a78568fc4..3458ac5ce9c1 100644
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
index 7b8a71ca66dd..387f9a53e35f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2757,12 +2757,12 @@ static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
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
@@ -2778,7 +2778,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (init_resync(conf))
 			return 0;
 
-	max_sector = mddev->dev_sectors;
 	if (sector_nr >= max_sector) {
 		/* If we aborted, we need to abort the
 		 * sync on the 'current' bitmap chunk (there will
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf..af54ac30a667 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3140,12 +3140,12 @@ static void raid10_set_cluster_sync_high(struct r10conf *conf)
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
@@ -3175,10 +3175,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
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
index 2bd1ce9b3922..69a083ca41a3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6458,11 +6458,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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

