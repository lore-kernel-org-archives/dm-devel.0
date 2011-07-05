From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 9 of 7]: DM RAID superblock must record device
	role
Date: Tue, 05 Jul 2011 10:55:33 -0500
Message-ID: <1309881333.19763.7.camel@f14.redhat.com>
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

Record the role of a device for a RAID array in the superblock.

The role, or position in the array, of each device must be recorded in
its superblock.  This is to help with fault handling, array reshaping,
and sanity checks.  RAID 4/5/6 devices must be loaded in a specific order;
in this way, the 'array_position' field helps validate the correctness
of the mapping description (aka, the CTR table).  It can be used during
reshaping to identify which devices are added/removed.  Fault handling is
not possible without this field.  For example, when a device fails it is
recorded in the superblock.  If this is a RAID1 device and the offending
device is removed from the array, there must be a way during subsequent
array assembly to determine that the failed device was the one removed.
This is done by the correlation of the 'array_position' field and the
bit-field variable 'failed_devices'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -565,6 +565,9 @@ struct dm_raid_superblock {
 	__le32 magic;
 	__le32 flags; /* Used to indicate possible future changes */
 
+	__le32 array_position; /* The position this drive holds in the array */
+	__le32 pad1;
+
 	__le64 events;
 	__le64 failed_devices; /* bitmap of devs, used to indicate a failure */
 
@@ -601,7 +604,7 @@ struct dm_raid_superblock {
 	__le32 num_devices;    /* Number of devs in RAID, Max = 64 */
 	__le32 new_num_devices;
 
-	__u8 pad[432];         /* Round out the struct to 512 bytes */
+	__u8 pad[424];         /* Round out the struct to 512 bytes */
 };
 
 static int read_disk_sb(mdk_rdev_t *rdev, int size)
@@ -637,7 +640,10 @@ static void super_sync(mddev_t *mddev, m
 	sb->magic  = cpu_to_le32(DM_RAID_MAGIC);
 	sb->flags  = cpu_to_le32(0); /* No flags yet */
 
+	sb->array_position = cpu_to_le32(rdev->raid_disk);
+
 	sb->events = cpu_to_le64(mddev->events);
+	sb->failed_devices = cpu_to_le64(failed_devices);
 
 	sb->reshape_offset = cpu_to_le64(mddev->reshape_position);
 	sb->disk_recovery_offset = cpu_to_le64(rdev->recovery_offset);
@@ -654,7 +660,6 @@ static void super_sync(mddev_t *mddev, m
 		sb->new_stripe_sectors = cpu_to_le32(mddev->new_chunk_sectors);
 		sb->new_num_devices = cpu_to_le32(mddev->delta_disks);
 	}
-	sb->failed_devices = cpu_to_le64(failed_devices);
 }
 
 /*
@@ -710,6 +715,7 @@ static int super_load(mdk_rdev_t *rdev, 
 
 static int super_init_validation(mddev_t *mddev, mdk_rdev_t *rdev)
 {
+	int role;
 	struct raid_set *rs = container_of(mddev, struct raid_set, md);
 	uint64_t ev1;
 	uint64_t failed_devices;
@@ -728,7 +734,13 @@ static int super_init_validation(mddev_t
 	/* Reshaping is not currently allowed */
 	if ((le32_to_cpu(sb->level) != mddev->level) ||
 	    (le32_to_cpu(sb->layout) != mddev->layout) ||
-	    (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) ||
+	    (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors)) {
+		DMERR("Reshaping arrays not yet supported.");
+		return -EINVAL;
+	}
+
+	/* We can only change the number of devices in RAID1 right now */
+	if ((rs->raid_type->level != 1) &&
 	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
 		DMERR("Reshaping arrays not yet supported.");
 		return -EINVAL;
@@ -790,15 +802,25 @@ static int super_init_validation(mddev_t
 			page_address(r->sb_page);
 		sb2->failed_devices = 0;
 
-		if (failed_devices)
-			DMERR("Checking disk #%d: %s", r->raid_disk,
-			       (failed_devices & (1 << r->raid_disk)) ?
-			       test_bit(FirstUse, &r->flags) ?
-			       "Full resync needed" : "Partial resync needed" :
-			       "Clean");
-		if ((r->raid_disk >= 0) && !test_bit(FirstUse, &r->flags) &&
-		    (failed_devices & (1 << r->raid_disk)))
-			set_bit(Faulty, &r->flags);
+		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
+			role = le32_to_cpu(sb2->array_position);
+			if (role != r->raid_disk) {
+				if (rs->raid_type->level != 1) {
+					rs->ti->error = "Cannot change device "
+						"positions in RAID array";
+					return -EINVAL;
+				}
+				DMINFO("RAID1 device #%d now at position #%d",
+				       role, r->raid_disk);
+			}
+
+			/*
+			 * Partial recovery is performed on
+			 * returning failed devs
+			 */
+			if (failed_devices & (1 << role))
+				set_bit(Faulty, &r->flags);
+		}
 	}
 
 	return 0;
