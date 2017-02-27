From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix data corruption on reshape request
Date: Mon, 27 Feb 2017 20:46:27 +0100
Message-ID: <20170227194627.22657-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

The lvm2 sequence to process constructor flags triggering
a rebuild or a reshape is defined as:

- load with table flags (e.g. rebuild/delta_disks/data_offset)
- clear out the flags in lvm2
- store the lvm2 metadata reloading the adjusted mapping
  in order to prevent requesting a rebuild or a reshape
  over and over again on activation

Currently, loading an inactive table with those flags dm-raid directly
starts the rebuild/reshape thus updating the raid metadata on resume about
the progress.  The aforementioned second reload to reset the flags accesses
the versatile progress state kept in raid superblocks in the constructor.
Because the active mapping is still processing the reshape, that position
will be stale by the time the device is resumed.

In case of reshaping, this causes data corruption by processing already
reshaped stripes again.  In case of rebuilds it does _not_ cause data
corruption but involves superfluous rebuilds.

Fix by keeping the raid set frozen during the first table load and allowing
it during the second.

This patch is based on

https://patchwork.kernel.org/patch/9485615 "dm raid: fix transient device failure processing"
https://patchwork.kernel.org/patch/9454975 "dm raid: journal device support"

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b8f978e..f750493 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -92,6 +92,8 @@ struct raid_dev {
 #define CTR_FLAG_DATA_OFFSET		(1 << __CTR_FLAG_DATA_OFFSET)
 #define CTR_FLAG_RAID10_USE_NEAR_SETS	(1 << __CTR_FLAG_RAID10_USE_NEAR_SETS)
 
+#define RESUME_STAY_FROZEN_FLAGS	(CTR_FLAG_DELTA_DISKS | \
+					 CTR_FLAG_DATA_OFFSET)
 /*
  * Definitions of various constructor flags to
  * be used in checks of valid / invalid flags
@@ -3643,7 +3645,15 @@ static void raid_resume(struct dm_target *ti)
 	mddev->ro = 0;
 	mddev->in_sync = 0;
 
-	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	/*
+	 * Keep the RAID set frozen in case flags respective to
+	 * reshape or rebuild are set until an imminent inactive
+	 * table load/resume occurs.  This ensures that the
+	 * constructor for the inactive table retrieves an
+	 * up-to-date reshape_position.
+	 */
+	if (!(rs->ctr_flags & RESUME_STAY_FROZEN_FLAGS))
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
 	if (mddev->suspended)
 		mddev_resume(mddev);
@@ -3651,7 +3661,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 9, 1},
+	.version = {1, 10, 2},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.3
