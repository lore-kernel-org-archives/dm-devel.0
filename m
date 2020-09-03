From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] md: compare bd_disk instead of bd_contains
Date: Thu,  3 Sep 2020 07:40:58 +0200
Message-ID: <20200903054104.228829-4-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

To check for partitions of the same disk bd_contains works as well, but
bd_disk is way more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9562ef598ae1f4..3f33562d10d6f5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2322,8 +2322,7 @@ static int match_mddev_units(struct mddev *mddev1, struct mddev *mddev2)
 			    test_bit(Journal, &rdev2->flags) ||
 			    rdev2->raid_disk == -1)
 				continue;
-			if (rdev->bdev->bd_contains ==
-			    rdev2->bdev->bd_contains) {
+			if (rdev->bdev->bd_disk == rdev2->bdev->bd_disk) {
 				rcu_read_unlock();
 				return 1;
 			}
@@ -5944,8 +5943,8 @@ int md_run(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			rdev_for_each(rdev2, mddev) {
 				if (rdev < rdev2 &&
-				    rdev->bdev->bd_contains ==
-				    rdev2->bdev->bd_contains) {
+				    rdev->bdev->bd_disk ==
+				    rdev2->bdev->bd_disk) {
 					pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
 						mdname(mddev),
 						bdevname(rdev->bdev,b),
-- 
2.28.0
