From: heinzm@redhat.com
Subject: [PATCH v2 1/5] dm raid: fix transient device failure
	processing
Date: Sat, 14 Jan 2017 03:53:07 +0100
Message-ID: <20170114025311.22762-2-heinzm@redhat.com>
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

This fix addresses the following 3 failure scenarios:

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

Resolves: rhbz1404425

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  4 ++
 drivers/md/dm-raid.c                    | 92 +++++++++++++++------------------
 2 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 8e6d910..b1e3a60 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -327,3 +327,7 @@ Version History
 	and set size reduction.
 1.9.1   Fix activation of existing RAID 4/10 mapped devices
 1.10.0  Add support for raid4/5/6 journal device
+1.10.1  Don't emit '- -' on the status table line in case the constructor
+	fails reading a superblock. Correctly emit 'maj:min1 maj:min2' and
+	'D' on the status line.  If '- -' is passed into the constructor, emit
+	'- -' on the table line and '-' as the status line health character.
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 25bb5ab..22a4932 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2323,7 +2323,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	struct mddev *mddev = &rs->md;
 	struct dm_raid_superblock *sb;
 
-	if (rs_is_raid0(rs) || !rdev->sb_page)
+	if (rs_is_raid0(rs) || !rdev->sb_page || rdev->raid_disk < 0)
 		return 0;
 
 	sb = page_address(rdev->sb_page);
@@ -2386,12 +2386,11 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
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
 
@@ -2401,9 +2400,8 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
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
@@ -2420,6 +2418,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		case 0:
 			break;
 		default:
+			/* This is a failure to read the superblock from the metadata device. */
 			/*
 			 * We have to keep any raid0 data/metadata device pairs or
 			 * the MD raid0 personality will fail to start the array.
@@ -2427,33 +2426,17 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
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
 
@@ -3173,10 +3156,13 @@ static const char *decipher_sync_action(struct mddev *mddev)
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
@@ -3281,7 +3267,6 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	sector_t progress, resync_max_sectors, resync_mismatches;
 	const char *sync_action;
 	struct raid_type *rt;
-	struct md_rdev *rdev;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -3302,10 +3287,9 @@ static void raid_status(struct dm_target *ti, status_type_t type,
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
@@ -3536,8 +3520,12 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < mddev->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
+		/* HM FIXME: enhance journal device recovery processing */
+		if (test_bit(Journal, &r->flags))
+			continue;
+
 		if (test_bit(Faulty, &r->flags) && r->sb_page &&
 		    sync_page_io(r, 0, r->sb_size, r->sb_page,
 				 REQ_OP_READ, 0, true)) {
@@ -3554,22 +3542,26 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
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
+				/* Failed to revive this device, try next */
+				r->raid_disk = r->saved_raid_disk = -1;
 				r->flags = flags;
 			} else {
+				clear_bit(In_sync, &r->flags);
 				r->recovery_offset = 0;
 				set_bit(i, (void *) cleared_failed_devices);
 				cleared = true;
@@ -3769,7 +3761,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 10, 0},
+	.version = {1, 10, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.3
