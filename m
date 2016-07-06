From: heinzm@redhat.com
Subject: [PATCH 14/26] dm raid: comments and fixed typos
Date: Wed,  6 Jul 2016 19:24:45 +0200
Message-ID: <1467825897-26058-15-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8118f1e..4572202 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1618,7 +1618,6 @@ static int rs_check_takeover(struct raid_set *rs)
 		/* raid1 -> raid10 */
 		if (mddev->new_level == 10)
 			return 0;
-
 		break;
 
 	case 4:
@@ -2424,8 +2423,8 @@ static int rs_adjust_data_offsets(struct raid_set *rs)
 		 *                   data is at offset rs->data_offset != 0 and
 		 *		     free space is at begin of each component LV
 		 *
-		 * - after reshape: data is at offset 0 if i was at offset != 0
-		 *                  of at offset != 0 if it was at offset 0
+		 * - after reshape: data is at offset 0 if it was at offset != 0
+		 *                  or at offset != 0 if it was at offset 0
 		 *                  on each component LV
 		 *
 		 */
@@ -2731,6 +2730,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	rs->md.sync_super = super_sync;
 
+	/*
+	 * Calculate ctr requested array and device sizes to allow
+	 * for superblock analysis needing device sizes defined.
+	 *
+	 * Any existing superblock will overwrite the array and device sizes
+	 */
 	r = rs_set_dev_and_array_sectors(rs, false);
 	if (r)
 		return r;
@@ -2781,8 +2786,9 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 
 		/*
-		 * If a takeover is needed, just set the level to
-		 * the new requested one and allow the raid set to run.
+		 * If a takeover is needed, userspace sets any additional
+		 * devices to rebuild, so just set the level to the new
+		 * requested one and allow the raid set to run
 		 */
 		r = rs_check_takeover(rs);
 		if (r)
@@ -2845,7 +2851,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 
 		if (rs->md.raid_disks < rs->raid_disks)
-			set_bit(MD_ARRAY_FIRST_USE, &rs->md.flags);
+			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
 
 		rs_set_cur(rs);
 		rs_setup_recovery(rs, MaxSector);
@@ -2935,7 +2941,7 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 	 * mddev->array_sectors will differ during the process
 	 * (ti->len > mddev->array_sectors), so we have to requeue
 	 * bios with addresses > mddev->array_sectors here or
-	 * or there will occur accesses past EOD of the component
+	 * there will occur accesses past EOD of the component
 	 * data images thus erroring the raid set.
 	 */
 	if (unlikely(bio_end_sector(bio) > mddev->array_sectors))
-- 
2.5.5
