From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] dm-raid: record and handle missing devices
Date: Mon, 16 Apr 2012 18:45:43 -0500
Message-ID: <1334619943.16017.27.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

Missing devices should be recorded and cause array to operate in degraded mode.

When specifying the devices that compose a DM RAID array, it is possible to denote
failed or missing devices with '-'s.  When this occurs, we must set mddev->degraded.
Otherwise, if the missing/failed device comes back, the bitmap will not have
recorded what areas of the array need to be recovered - the array will be assumed to
be in-sync!  Additionally, we must mark in the superblock which device was specified
as missing/failed.  We do this by setting the appropriate bit in the 'failed_devices'
field.  Finally, we must also ensure that the superblock is properly recorded by
setting 'MD_CHANGE_DEVS' in raid_resume.  If we do not cause the superblock to be
rewritten by the resume function, it is possible for a stale superblock to be
written by an out-going in-active table (during 'raid_dtr').

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -226,6 +226,7 @@ static int dev_parms(struct raid_set *rs
 			if (rs->dev[i].meta_dev)
 				return -EINVAL;
 
+			rs->md.degraded++;
 			continue;
 		}
 
@@ -606,6 +607,7 @@ static int read_disk_sb(struct md_rdev *
 	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
+		rdev->mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
 		return -EINVAL;
 	}
@@ -617,16 +619,18 @@ static int read_disk_sb(struct md_rdev *
 
 static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 {
-	struct md_rdev *r;
+	int i;
 	uint64_t failed_devices;
 	struct dm_raid_superblock *sb;
+	struct raid_set *rs = container_of(mddev, struct raid_set, md);
 
 	sb = page_address(rdev->sb_page);
 	failed_devices = le64_to_cpu(sb->failed_devices);
 
-	rdev_for_each(r, mddev)
-		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
-			failed_devices |= (1ULL << r->raid_disk);
+	for (i = 0; i < mddev->raid_disks; i++)
+		if (!rs->dev[i].data_dev ||
+		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
+			failed_devices |= (1ULL << i);
 
 	memset(sb, 0, sizeof(*sb));
 
@@ -1252,6 +1256,7 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
+	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
 		rs->bitmap_loaded = 1;


