From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix panic when attempting to force a
	raid to sync
Date: Thu,  2 Nov 2017 19:58:28 +0100
Message-ID: <20171102185828.5205-1-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Requesting a sync on an active raid device via a table reload
(see 'sync' parameter in Documentation/device-mapper/dm-raid.txt)
prevents the super_load() call defining the superblock size (rdev->sb_size)
thus super_sync()->memset() called later will oops.

Fix by moving the initialization of the superblock start and size
out of super_load() to the caller.

Resolves: rhbz1226440
---
 drivers/md/dm-raid.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2245d06d2045..a25eebd98996 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2143,13 +2143,6 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	struct dm_raid_superblock *refsb;
 	uint64_t events_sb, events_refsb;
 
-	rdev->sb_start = 0;
-	rdev->sb_size = bdev_logical_block_size(rdev->meta_bdev);
-	if (rdev->sb_size < sizeof(*sb) || rdev->sb_size > PAGE_SIZE) {
-		DMERR("superblock size of a logical block is no longer valid");
-		return -EINVAL;
-	}
-
 	r = read_disk_sb(rdev, rdev->sb_size, false);
 	if (r)
 		return r;
@@ -2494,6 +2487,17 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		if (test_bit(Journal, &rdev->flags))
 			continue;
 
+		if (!rdev->meta_bdev)
+			continue;
+
+		/* Set superblock offset/size for metadata device. */
+		rdev->sb_start = 0;
+		rdev->sb_size = bdev_logical_block_size(rdev->meta_bdev);
+		if (rdev->sb_size < sizeof(struct dm_raid_superblock) || rdev->sb_size > PAGE_SIZE) {
+			DMERR("superblock size of a logical block is no longer valid");
+			return -EINVAL;
+		}
+
 		/*
 		 * Skipping super_load due to CTR_FLAG_SYNC will cause
 		 * the array to undergo initialization again as
@@ -2506,9 +2510,6 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
 			continue;
 
-		if (!rdev->meta_bdev)
-			continue;
-
 		r = super_load(rdev, freshest);
 
 		switch (r) {
-- 
2.13.6
