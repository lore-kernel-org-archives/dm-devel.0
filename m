From: heinzm@redhat.com
Subject: [PATCH v2 2/5] dm raid: be prepared to accept arbitrary
	'- -' tupples
Date: Sat, 14 Jan 2017 03:53:08 +0100
Message-ID: <20170114025311.22762-3-heinzm@redhat.com>
References: <20170114025311.22762-1-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170114025311.22762-1-heinzm@redhat.com>
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

During raid set resize checks and setting up the recovery offset in case a raid
set grows, calculated rd->md.dev_sectors is compared to rs->dev[0].rdev.sectors.

Device 0 may not be defined in case userspace passes in '- -' for it
(lvm2 doesn't do that so far), thus it's device sectors can't be taken
authoritatively in this comparison and another valid device must be used
to retrieve the device size.

Use mddev->dev_sectors in checking for ongoing recovery for the same reason.

Related: rhbz1404425

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 22a4932..f3452b1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -388,7 +388,7 @@ static bool rs_is_reshapable(struct raid_set *rs)
 /* Return true, if raid set in @rs is recovering */
 static bool rs_is_recovering(struct raid_set *rs)
 {
-	return rs->md.recovery_cp < rs->dev[0].rdev.sectors;
+	return rs->md.recovery_cp < rs->md.dev_sectors;
 }
 
 /* Return true, if raid set in @rs is reshaping */
@@ -1490,6 +1490,25 @@ static unsigned int rs_data_stripes(struct raid_set *rs)
 	return rs->raid_disks - rs->raid_type->parity_devs;
 }
 
+/*
+ * Retrieve rdev->sectors from any valid raid device of @rs
+ * to allow userpace to pass in arbitray "- -" device tupples.
+ */
+static sector_t __rdev_sectors(struct raid_set *rs)
+{
+	int i;
+
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		struct md_rdev *rdev = &rs->dev[i].rdev;
+
+		if (!test_bit(Journal, &rdev->flags) &&
+		    rdev->bdev && rdev->sectors)
+			return rdev->sectors;
+	}
+
+	BUG(); /* Constructor ensures we got some. */
+}
+
 /* Calculate the sectors per device and per array used for @rs */
 static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 {
@@ -1576,9 +1595,9 @@ static void rs_setup_recovery(struct raid_set *rs, sector_t dev_sectors)
 	else if (dev_sectors == MaxSector)
 		/* Prevent recovery */
 		__rs_setup_recovery(rs, MaxSector);
-	else if (rs->dev[0].rdev.sectors < dev_sectors)
+	else if (__rdev_sectors(rs) < dev_sectors)
 		/* Grown raid set */
-		__rs_setup_recovery(rs, rs->dev[0].rdev.sectors);
+		__rs_setup_recovery(rs, __rdev_sectors(rs));
 	else
 		__rs_setup_recovery(rs, MaxSector);
 }
@@ -2907,7 +2926,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	calculated_dev_sectors = rs->dev[0].rdev.sectors;
+	calculated_dev_sectors = rs->md.dev_sectors;
 
 	/*
 	 * Backup any new raid set level, layout, ...
@@ -2920,7 +2939,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	resize = calculated_dev_sectors != rs->dev[0].rdev.sectors;
+	resize = calculated_dev_sectors != __rdev_sectors(rs);
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
-- 
2.9.3
