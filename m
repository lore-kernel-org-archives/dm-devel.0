From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix transient device failure processing
Date: Thu, 22 Dec 2016 21:26:01 +0100
Message-ID: <20161222202601.20274-1-heinzm@redhat.com>
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

This patch addresses the following 3 failure scenarios:

1) If a (transiently) inaccessible metadata device is being passed into the
constructor (e.g. a device tuple '254:4 254:5'), it is processed as if
'- -' was given.  This erroneously results in a status table line containing
'- -', which mistakenly differs from what has been passed in.  As a result,
userspace libdevmapper puts the device tuple seperate from the RAID device
thus not processing the dependencies properly.

2) False health status char 'A' instead of 'D' is emitted on the status
status info line for the meta/data device tuple in this metadata device
failure case.

3) If the metadata device is accessible when passed into the constructor
but the data device (partially) isn't, that leg may be set faulty by the
raid personality on access to the (partially) unavailable leg.  Restore
tried in a second raid device resume on such failed leg (status char 'D')
fails after the (partial) leg returned.

Fixes for aforementioned failure scenarios:

- don't release passed in devices in the constructor thus allowing the
  status table line to e.g. contain '254:4 254:5' rather than '- -'

- emit device status char 'D' rather than 'A' for the device tuple
  with the failed metadata device on the status info line

- when attempting to restore faulty devices in a second resume, allow the
  device hot remove function to succeed by setting the device to not in-sync

In case userspace intentionally passes '- -' into the constructor to avoid that
device tuple (e.g. to split off a raid1 leg temporarily for later re-addition),
the status table line will correctly show '- -' and the status info line will
provide a '-' device health character for the non-defined device tuple.

Cleanups:

- use rs->md.dev_sectors throughout instead of rs->dev[0].rdev.sectors to be
  prepared for userspace ever passing in '- -' for the first tuple

- avoid sync_page_io() in favour of read_disk_sb()

- consistently use mddev-> instead of rdev->mddev on bitmap setup


This patch is on top of
"[PATCH] dm raid: change raid4/5/6 journal device status health char to 'A' rather than 'J'"
dated 12/13/2016.

Resolves: rhbz1404425

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |   4 ++
 drivers/md/dm-raid.c                    | 121 +++++++++++++++-----------------
 2 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 8e6d910..f0f43a7 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -327,3 +327,7 @@ Version History
 	and set size reduction.
 1.9.1   Fix activation of existing RAID 4/10 mapped devices
 1.10.0  Add support for raid4/5/6 journal device
+1.10.1  Don't emit '- -' on the status table line in case the constructor
+        fails reading a superblock. Correctly emit 'maj:min1 maj:min2' and
+        'D' on the status line.  If '- -' is passed into the constructor, emit
+        '- -' on the table line and '-' as the status line health character.
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 25bb5ab..f29abb2 100644
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
@@ -1576,9 +1576,9 @@ static void rs_setup_recovery(struct raid_set *rs, sector_t dev_sectors)
 	else if (dev_sectors == MaxSector)
 		/* Prevent recovery */
 		__rs_setup_recovery(rs, MaxSector);
-	else if (rs->dev[0].rdev.sectors < dev_sectors)
+	else if (rs->md.dev_sectors < dev_sectors)
 		/* Grown raid set */
-		__rs_setup_recovery(rs, rs->dev[0].rdev.sectors);
+		__rs_setup_recovery(rs, rs->md.dev_sectors);
 	else
 		__rs_setup_recovery(rs, MaxSector);
 }
@@ -1917,18 +1917,21 @@ static int rs_check_reshape(struct raid_set *rs)
 	return -EPERM;
 }
 
-static int read_disk_sb(struct md_rdev *rdev, int size)
+static int read_disk_sb(struct md_rdev *rdev, int size, bool force_reload)
 {
 	BUG_ON(!rdev->sb_page);
 
-	if (rdev->sb_loaded)
+	if (rdev->sb_loaded && !force_reload)
 		return 0;
 
+	rdev->sb_loaded = 0;
+
 	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, true)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
 		md_error(rdev->mddev, rdev);
-		return -EINVAL;
+		set_bit(Faulty, &rdev->flags);
+		return -EIO;
 	}
 
 	rdev->sb_loaded = 1;
@@ -2056,7 +2059,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		return -EINVAL;
 	}
 
-	r = read_disk_sb(rdev, rdev->sb_size);
+	r = read_disk_sb(rdev, rdev->sb_size, false);
 	if (r)
 		return r;
 
@@ -2323,7 +2326,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	struct mddev *mddev = &rs->md;
 	struct dm_raid_superblock *sb;
 
-	if (rs_is_raid0(rs) || !rdev->sb_page)
+	if (rs_is_raid0(rs) || !rdev->sb_page || rdev->raid_disk < 0)
 		return 0;
 
 	sb = page_address(rdev->sb_page);
@@ -2348,7 +2351,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 
 	/* Enable bitmap creation for RAID levels != 0 */
 	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
-	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
+	mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
 		/* Retrieve device size stored in superblock to be prepared for shrink */
@@ -2386,12 +2389,11 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 {
 	int r;
-	struct raid_dev *dev;
-	struct md_rdev *rdev, *tmp, *freshest;
+	struct md_rdev *rdev, *freshest;
 	struct mddev *mddev = &rs->md;
 
 	freshest = NULL;
-	rdev_for_each_safe(rdev, tmp, mddev) {
+	rdev_for_each(rdev, mddev) {
 		if (test_bit(Journal, &rdev->flags))
 			continue;
 
@@ -2401,9 +2403,8 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		 * though it were new.	This is the intended effect
 		 * of the "sync" directive.
 		 *
-		 * When reshaping capability is added, we must ensure
-		 * that the "sync" directive is disallowed during the
-		 * reshape.
+		 * With reshaping capability added, we must ensure that
+		 * that the "sync" directive is disallowed during the reshape.
 		 */
 		if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
 			continue;
@@ -2420,6 +2421,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		case 0:
 			break;
 		default:
+			/* This is a failure to read the superblock off the metadata device. */
 			/*
 			 * We have to keep any raid0 data/metadata device pairs or
 			 * the MD raid0 personality will fail to start the array.
@@ -2427,33 +2429,17 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 			if (rs_is_raid0(rs))
 				continue;
 
-			dev = container_of(rdev, struct raid_dev, rdev);
-			if (dev->meta_dev)
-				dm_put_device(ti, dev->meta_dev);
-
-			dev->meta_dev = NULL;
-			rdev->meta_bdev = NULL;
-
-			if (rdev->sb_page)
-				put_page(rdev->sb_page);
-
-			rdev->sb_page = NULL;
-
-			rdev->sb_loaded = 0;
-
 			/*
-			 * We might be able to salvage the data device
-			 * even though the meta device has failed.  For
-			 * now, we behave as though '- -' had been
-			 * set for this device in the table.
+			 * We keep the dm_devs to be able to emit the device tuple
+			 * properly on the table line in raid_status() (rather than
+			 * mistakenly acting as if '- -' got passed into the constructor).
+			 *
+			 * The rdev has to stay on the same_set list to allow for
+			 * the attempt to restore faulty devices on second resume.
 			 */
-			if (dev->data_dev)
-				dm_put_device(ti, dev->data_dev);
-
-			dev->data_dev = NULL;
-			rdev->bdev = NULL;
-
-			list_del(&rdev->same_set);
+			set_bit(Faulty, &rdev->flags);
+			rdev->raid_disk = rdev->saved_raid_disk = -1;
+			break;
 		}
 	}
 
@@ -2924,7 +2910,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	calculated_dev_sectors = rs->dev[0].rdev.sectors;
+	calculated_dev_sectors = rs->md.dev_sectors;
 
 	/*
 	 * Backup any new raid set level, layout, ...
@@ -2937,7 +2923,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	resize = calculated_dev_sectors != rs->dev[0].rdev.sectors;
+	resize = calculated_dev_sectors != rs->md.dev_sectors;
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
@@ -3014,7 +3000,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 * is an instant operation as oposed to an ongoing reshape.
 		 */
 
-		/* We can't reshape a jorunaled radi4/5/6 */
+		/* We can't reshape a journaled radi4/5/6 */
 		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
 			ti->error = "Can't reshape a journaled raid4/5/6 set";
 			r = -EPERM;
@@ -3166,17 +3152,20 @@ static const char *decipher_sync_action(struct mddev *mddev)
 }
 
 /*
- * Return status string @rdev
+ * Return status string for @rdev
  *
  * Status characters:
  *
  *  'D' = Dead/Failed raid set component or raid4/5/6 journal device
  *  'a' = Alive but not in-sync
  *  'A' = Alive and in-sync raid set component or alive raid4/5/6 journal device
+ *  '-' = Non-existing device (i.e. uspace passed '- -' into the ctr)
  */
 static const char *__raid_dev_status(struct md_rdev *rdev, bool array_in_sync)
 {
-	if (test_bit(Faulty, &rdev->flags))
+	if (!rdev->bdev)
+		return "-";
+	else if (test_bit(Faulty, &rdev->flags))
 		return "D";
 	else if (test_bit(Journal, &rdev->flags))
 		return "A";
@@ -3281,7 +3270,6 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	sector_t progress, resync_max_sectors, resync_mismatches;
 	const char *sync_action;
 	struct raid_type *rt;
-	struct md_rdev *rdev;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -3302,10 +3290,9 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 				    atomic64_read(&mddev->resync_mismatches) : 0;
 		sync_action = decipher_sync_action(&rs->md);
 
-		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
-		rdev_for_each(rdev, mddev)
-			if (!test_bit(Journal, &rdev->flags))
-				DMEMIT(__raid_dev_status(rdev, array_in_sync));
+		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
+		for (i = 0; i < rs->raid_disks; i++)
+			DMEMIT(__raid_dev_status(&rs->dev[i].rdev, array_in_sync));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3536,11 +3523,12 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < mddev->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
-		if (test_bit(Faulty, &r->flags) && r->sb_page &&
-		    sync_page_io(r, 0, r->sb_size, r->sb_page,
-				 REQ_OP_READ, 0, true)) {
+		if (test_bit(Journal, &r->flags))
+			continue;
+
+		if (test_bit(Faulty, &r->flags) && !read_disk_sb(r, r->sb_size, true)) {
 			DMINFO("Faulty %s device #%d has readable super block."
 			       "  Attempting to revive it.",
 			       rs->raid_type->name, i);
@@ -3554,22 +3542,25 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 			 * '>= 0' - meaning we must call this function
 			 * ourselves.
 			 */
-			if ((r->raid_disk >= 0) &&
-			    (mddev->pers->hot_remove_disk(mddev, r) != 0))
-				/* Failed to revive this device, try next */
-				continue;
-
-			r->raid_disk = i;
-			r->saved_raid_disk = i;
 			flags = r->flags;
+			clear_bit(In_sync, &r->flags); /* Mandatory for hot remove. */
+			if (r->raid_disk >= 0) {
+				if (mddev->pers->hot_remove_disk(mddev, r)) {
+					/* Failed to revive this device, try next */
+					r->flags = flags;
+					continue;
+				}
+			} else
+				r->raid_disk = r->saved_raid_disk = i;
+
 			clear_bit(Faulty, &r->flags);
 			clear_bit(WriteErrorSeen, &r->flags);
-			clear_bit(In_sync, &r->flags);
+
 			if (mddev->pers->hot_add_disk(mddev, r)) {
-				r->raid_disk = -1;
-				r->saved_raid_disk = -1;
+				r->raid_disk = r->saved_raid_disk = -1;
 				r->flags = flags;
 			} else {
+				clear_bit(In_sync, &r->flags);
 				r->recovery_offset = 0;
 				set_bit(i, (void *) cleared_failed_devices);
 				cleared = true;
@@ -3769,7 +3760,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 10, 0},
+	.version = {1, 10, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.3
