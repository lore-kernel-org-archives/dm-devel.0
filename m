From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix frozen recovery regression
Date: Tue,  9 Aug 2016 14:56:06 +0200
Message-ID: <1470747366-31600-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

On LVM2 conversions via lvconvert(8), the target keeps mapped devices
in frozen state when requesting resynchonization of RAID devices.  This
applies to e.g. adding legs to a raid1 device or taking over from raid0
to raid4 when the rebuild flag's set on the new raid1 legs or the added
dedicated parity stripe.
Patch fixes frozen recovery for reshaping as well.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 20e03b2..73bf535 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -191,7 +191,6 @@ struct raid_dev {
 #define RT_FLAG_RS_BITMAP_LOADED	2
 #define RT_FLAG_UPDATE_SBS		3
 #define RT_FLAG_RESHAPE_RS		4
-#define RT_FLAG_KEEP_RS_FROZEN		5
 
 /* Array elements of 64 bit needed for rebuild/failed disk bits */
 #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
@@ -2579,7 +2578,6 @@ static int rs_prepare_reshape(struct raid_set *rs)
 		} else {
 			/* Process raid1 without delta_disks */
 			mddev->raid_disks = rs->raid_disks;
-			set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
 			reshape = false;
 		}
 	} else {
@@ -2590,7 +2588,6 @@ static int rs_prepare_reshape(struct raid_set *rs)
 	if (reshape) {
 		set_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags);
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
 	} else if (mddev->raid_disks < rs->raid_disks)
 		/* Create new superblocks and bitmaps, if any new disks */
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
@@ -2902,7 +2899,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
 		/* Takeover ain't recovery, so disable recovery */
 		rs_setup_recovery(rs, MaxSector);
 		rs_set_new(rs);
@@ -3640,8 +3636,7 @@ static void raid_resume(struct dm_target *ti)
 		 *    retrieved from the superblock by the ctr because
 		 *    the ongoing recovery/reshape will change it after read.
 		 */
-		if (!test_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags))
-			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
 		if (mddev->suspended)
 			mddev_resume(mddev);
-- 
2.7.4
