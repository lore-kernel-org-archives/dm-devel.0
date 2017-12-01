From: heinzm@redhat.com
Subject: [PATCH 04/10] dm raid: correct raid set size revalidation
Date: Fri,  1 Dec 2017 01:02:22 +0100
Message-ID: <20171201000228.32677-5-heinzm@redhat.com>
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

The raid set size is being revalidated unconditionally
before a reshaping conversion is started.  MD requires
the size to only be reduced in case of a stripe removing
(i.e. shrinking) reshape but not when growing because
the raid array has to stay small until after the growing
reshape finished.

Fix by avoiding the size revalidation in preresume unless
a shrinking reshape is requested.

Related: rhbz1501145
---
 drivers/md/dm-raid.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ec28a6cf1bf8..3b0964c7da17 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -675,15 +675,11 @@ static struct raid_type *get_raid_type_by_ll(const int level, const int layout)
 	return NULL;
 }
 
-/*
- * Conditionally change bdev capacity of @rs
- * in case of a disk add/remove reshape
- */
-static void rs_set_capacity(struct raid_set *rs)
+/* Adjust rdev sectors */
+static void rs_set_rdev_sectors(struct raid_set *rs)
 {
 	struct mddev *mddev = &rs->md;
 	struct md_rdev *rdev;
-	struct gendisk *gendisk = dm_disk(dm_table_get_md(rs->ti->table));
 
 	/*
 	 * raid10 sets rdev->sector to the device size, which
@@ -692,8 +688,16 @@ static void rs_set_capacity(struct raid_set *rs)
 	rdev_for_each(rdev, mddev)
 		if (!test_bit(Journal, &rdev->flags))
 			rdev->sectors = mddev->dev_sectors;
+}
 
-	set_capacity(gendisk, mddev->array_sectors);
+/*
+ * Change bdev capacity of @rs in case of a disk add/remove reshape
+ */
+static void rs_set_capacity(struct raid_set *rs)
+{
+	struct gendisk *gendisk = dm_disk(dm_table_get_md(rs->ti->table));
+
+	set_capacity(gendisk, rs->md.array_sectors);
 	revalidate_disk(gendisk);
 }
 
@@ -1674,8 +1678,11 @@ static void do_table_event(struct work_struct *ws)
 	struct raid_set *rs = container_of(ws, struct raid_set, md.event_work);
 
 	smp_rmb(); /* Make sure we access most actual mddev properties */
-	if (!rs_is_reshaping(rs))
+	if (!rs_is_reshaping(rs)) {
+		if (rs_is_raid10(rs))
+			rs_set_rdev_sectors(rs);
 		rs_set_capacity(rs);
+	}
 	dm_table_event(rs->ti->table);
 }
 
@@ -3877,11 +3884,10 @@ static int raid_preresume(struct dm_target *ti)
 		mddev->resync_min = mddev->recovery_cp;
 	}
 
-	rs_set_capacity(rs);
-
 	/* Check for any reshape request unless new raid set */
 	if (test_and_clear_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		/* Initiate a reshape. */
+		rs_set_rdev_sectors(rs);
 		mddev_lock_nointr(mddev);
 		r = rs_start_reshape(rs);
 		mddev_unlock(mddev);
@@ -3910,6 +3916,10 @@ static void raid_resume(struct dm_target *ti)
 	mddev->ro = 0;
 	mddev->in_sync = 0;
 
+	/* Only reduce raid set size before running a disk removing reshape. */
+	if (mddev->delta_disks < 0)
+		rs_set_capacity(rs);
+
 	/*
 	 * Keep the RAID set frozen if reshape/rebuild flags are set.
 	 * The RAID set is unfrozen once the next table load/resume,
-- 
2.13.6
