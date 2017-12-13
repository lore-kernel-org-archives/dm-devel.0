From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 5/5] dm raid: use rs_is_raid*() / comment
Date: Wed, 13 Dec 2017 03:02:38 +0100
Message-ID: <64b0552a7ff668a15bdcf838f13e9f2dd9d2d29e.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Cleanup, no functional change.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 41a411526b27..6c9e3d9e56c2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -588,7 +588,7 @@ static const char *raid10_md_layout_to_format(int layout)
 }
 
 /* Return md raid10 algorithm for @name */
-static int raid10_name_to_format(const char *name)
+static const int raid10_name_to_format(const char *name)
 {
 	if (!strcasecmp(name, "near"))
 		return ALGORITHM_RAID10_NEAR;
@@ -1913,7 +1913,7 @@ static bool rs_reshape_requested(struct raid_set *rs)
 	if (rs_takeover_requested(rs))
 		return false;
 
-	if (!mddev->level)
+	if (rs_is_raid0(rs))
 		return false;
 
 	change = mddev->new_layout != mddev->layout ||
@@ -1921,7 +1921,7 @@ static bool rs_reshape_requested(struct raid_set *rs)
 		 rs->delta_disks;
 
 	/* Historical case to support raid1 reshape without delta disks */
-	if (mddev->level == 1) {
+	if (rs_is_raid1(rs)) {
 		if (rs->delta_disks)
 			return !!rs->delta_disks;
 
@@ -1929,7 +1929,7 @@ static bool rs_reshape_requested(struct raid_set *rs)
 		       mddev->raid_disks != rs->raid_disks;
 	}
 
-	if (mddev->level == 10)
+	if (rs_is_raid10(rs))
 		return change &&
 		       !__is_raid10_far(mddev->new_layout) &&
 		       rs->delta_disks >= 0;
@@ -2742,14 +2742,14 @@ static int rs_setup_takeover(struct raid_set *rs)
 	sector_t new_data_offset = rs->dev[0].rdev.data_offset ? 0 : rs->data_offset;
 
 	if (rt_is_raid10(rs->raid_type)) {
-		if (mddev->level == 0) {
+		if (rs_is_raid0(rs)) {
 			/* Userpace reordered disks -> adjust raid_disk indexes */
 			__reorder_raid_disk_indexes(rs);
 
 			/* raid0 -> raid10_far layout */
 			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_FAR,
 								   rs->raid10_copies);
-		} else if (mddev->level == 1)
+		} else if (rs_is_raid1(rs))
 			/* raid1 -> raid10_near layout */
 			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_NEAR,
 								   rs->raid_disks);
@@ -2974,10 +2974,8 @@ static void configure_discard_support(struct raid_set *rs)
 	bool raid456;
 	struct dm_target *ti = rs->ti;
 
-	/*
-	 * XXX: RAID level 4,5,6 require zeroing for safety.
-	 */
-	raid456 = (rs->md.level == 4 || rs->md.level == 5 || rs->md.level == 6);
+	/* RAID level 4,5,6 require discard_zeroes_data for data integrity! */
+	raid456 = rs_is_raid456(rs);
 
 	for (i = 0; i < rs->raid_disks; i++) {
 		struct request_queue *q;
@@ -3002,7 +3000,7 @@ static void configure_discard_support(struct raid_set *rs)
 	 * RAID1 and RAID10 personalities require bio splitting,
 	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
-	ti->split_discard_bios = !!(rs->md.level == 1 || rs->md.level == 10);
+	ti->split_discard_bios = !!(rs_is_raid1(rs) || rs_is_raid10(rs));
 	ti->num_discard_bios = 1;
 }
 
-- 
2.13.6
