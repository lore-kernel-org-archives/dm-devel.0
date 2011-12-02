From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Fix inability to handle failed devices
 during start-up
Date: Fri, 02 Dec 2011 11:52:11 -0600
Message-ID: <1322848332.2045.2.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

DM RAID: Fix inability to handle failed devices during start-up

The code fails to create a RAID array if any of the superblocks cannot be read.
However, if the userspace program passing in the device-mapper table spots the
failure and passes in the sentinel values ('- -') for the failed array position,
then everything is handled properly.  This functional gap should not exist.

This patch makes it so that if a superblock cannot be read, the array position's
fields are initialized as though '- -' were passed in via the CTR table.  That
is, the device is failed and the position should not be used; but if there is
sufficient redundancy, the array should still be activated.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -603,7 +603,9 @@ static int read_disk_sb(struct md_rdev *
 		return 0;
 
 	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
-		DMERR("Failed to read device superblock");
+		DMERR("Failed to read superblock of device at position %d",
+		      rdev->raid_disk);
+		set_bit(Faulty, &rdev->flags);
 		return -EINVAL;
 	}
 
@@ -854,9 +856,25 @@ static int super_validate(struct mddev *
 static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 {
 	int ret;
+	unsigned redundancy = 0;
+	struct raid_dev *dev;
 	struct md_rdev *rdev, *freshest, *tmp;
 	struct mddev *mddev = &rs->md;
 
+	switch (rs->raid_type->level) {
+	case 1:
+		redundancy = rs->md.raid_disks - 1;
+		break;
+	case 4:
+	case 5:
+	case 6:
+		redundancy = rs->raid_type->parity_devs;
+		break;
+	default:
+		ti->error = "Unknown RAID type";
+		return -EINVAL;
+	}
+
 	freshest = NULL;
 	rdev_for_each(rdev, tmp, mddev) {
 		if (!rdev->meta_bdev)
@@ -871,6 +889,34 @@ static int analyse_superblocks(struct dm
 		case 0:
 			break;
 		default:
+			dev = container_of(rdev, struct raid_dev, rdev);
+			if (redundancy--) {
+				if (dev->meta_dev)
+					dm_put_device(ti, dev->meta_dev);
+				dev->meta_dev = NULL;
+				rdev->meta_bdev = NULL;
+
+				if (rdev->sb_page)
+					put_page(rdev->sb_page);
+				rdev->sb_page = NULL;
+
+				rdev->sb_loaded = 0;
+
+				/*
+				 * We might be able to salvage the data device
+				 * even though the meta device has failed.  For
+				 * now, we behave as though '- -' had been
+				 * passed in for this device via the CTR table.
+				 */
+				if (dev->data_dev)
+					dm_put_device(ti, dev->data_dev);
+				dev->data_dev = NULL;
+				rdev->bdev = NULL;
+
+				list_del(&rdev->same_set);
+
+				continue;
+			}
 			ti->error = "Failed to load superblock";
 			return ret;
 		}
