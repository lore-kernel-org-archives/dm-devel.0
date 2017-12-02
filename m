From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 02/12] dm raid: correct sizes and check of
	component devices
Date: Sat,  2 Dec 2017 01:03:49 +0100
Message-ID: <05c0cd9485f606ad74d4a392456dcc80c54e62e1.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

The md raid personalities call md_finish_reshape() at the end
of a reshape conversion which adjusts rdev->sectors.

Correct/check rdev->sectors before initiating a reshape
and raise the recovery pointer accordingly.
---
 drivers/md/dm-raid.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 536666facbf1..5f099d1f7ccc 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2640,12 +2640,19 @@ static int rs_adjust_data_offsets(struct raid_set *rs)
 	 * Make sure we got a minimum amount of free sectors per device
 	 */
 	if (rs->data_offset &&
-	    to_sector(i_size_read(rdev->bdev->bd_inode)) - rdev->sectors < MIN_FREE_RESHAPE_SPACE) {
+	    to_sector(i_size_read(rdev->bdev->bd_inode)) - rs->md.dev_sectors < MIN_FREE_RESHAPE_SPACE) {
 		rs->ti->error = data_offset ? "No space for forward reshape" :
 					      "No space for backward reshape";
 		return -ENOSPC;
 	}
 out:
+	/*
+	 * Raise recovery_cp in case data_offset != 0 to
+	 * avoid false recovery positives in the constructor.
+	 */
+	if (rs->md.recovery_cp < rs->md.dev_sectors)
+		rs->md.recovery_cp += rs->dev[0].rdev.data_offset;
+
 	/* Adjust data offsets on all rdevs but on any raid4/5/6 journal device */
 	rdev_for_each(rdev, &rs->md) {
 		if (!test_bit(Journal, &rdev->flags)) {
@@ -2777,6 +2784,23 @@ static int rs_prepare_reshape(struct raid_set *rs)
 	return 0;
 }
 
+/* Get reshape sectors from data_offsets or raid set */
+static sector_t _get_reshape_sectors(struct raid_set *rs)
+{
+	struct md_rdev *rdev;
+	sector_t reshape_sectors = 0;
+
+	rdev_for_each(rdev, &rs->md)
+		if (!test_bit(Journal, &rdev->flags)) {
+			reshape_sectors = (rdev->data_offset > rdev->new_data_offset) ?
+					rdev->data_offset - rdev->new_data_offset :
+					rdev->new_data_offset - rdev->data_offset;
+			break;
+		}
+
+	return max(reshape_sectors, (sector_t) rs->data_offset);
+}
+
 /*
  *
  * - change raid layout
@@ -2788,6 +2812,7 @@ static int rs_setup_reshape(struct raid_set *rs)
 {
 	int r = 0;
 	unsigned int cur_raid_devs, d;
+	sector_t reshape_sectors = _get_reshape_sectors(rs);
 	struct mddev *mddev = &rs->md;
 	struct md_rdev *rdev;
 
@@ -2874,6 +2899,15 @@ static int rs_setup_reshape(struct raid_set *rs)
 		mddev->reshape_backwards = rs->dev[0].rdev.data_offset ? 0 : 1;
 	}
 
+	/*
+	 * Adjust device size for forward reshape
+	 * because md_finish_reshape() reduces it.
+	 */
+	if (!mddev->reshape_backwards)
+		rdev_for_each(rdev, &rs->md)
+			if (!test_bit(Journal, &rdev->flags))
+				rdev->sectors += reshape_sectors;
+
 	return r;
 }
 
-- 
2.13.6
