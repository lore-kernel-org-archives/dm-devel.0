From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] md: don't detour through bd_contains for the gendisk
Date: Thu,  3 Sep 2020 07:40:59 +0200
Message-ID: <20200903054104.228829-5-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

bd_disk is set on all block devices, including those for partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 2 +-
 drivers/md/md.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f33562d10d6f5..5a0fd93769a70e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8444,7 +8444,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 	idle = 1;
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
-		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
+		struct gendisk *disk = rdev->bdev->bd_disk;
 		curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
 			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f9e2ccdd22c478..2175a5ac4f7c68 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -551,7 +551,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
+	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
 }
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
-- 
2.28.0
