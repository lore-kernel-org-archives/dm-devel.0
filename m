From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 7] DM RAID:  allow metadata devices
Date: Wed, 08 Jun 2011 17:22:01 -0500
Message-ID: <1307571721.18638.13.camel@f14.redhat.com>
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

Add metadata device functionality to dm-raid.c

Add the ability to parse and use metadata devices.  Metadata
devices are not strictly required.  If they are provided, they are used
to store a superblock and bitmap.  Without the metadata area, many features of
RAID are not supported.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -15,12 +15,10 @@
 #define DM_MSG_PREFIX "raid"
 
 /*
- * If the MD doesn't support MD_SYNC_STATE_FORCED yet, then
- * make it so the flag doesn't set anything.
+ * The following flags are used by dm-raid.c to correctly setup the
+ * array state.  They must be cleared before md_run is called.
  */
-#ifndef MD_SYNC_STATE_FORCED
-#define MD_SYNC_STATE_FORCED 0
-#endif
+#define FirstUse 10             /* rdev flag */
 
 struct raid_dev {
 	/*
@@ -148,9 +146,16 @@ static void context_free(struct raid_set
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		if (rs->dev[i].meta_dev)
+			dm_put_device(rs->ti, rs->dev[i].meta_dev);
+		if (rs->dev[i].rdev.sb_page)
+			put_page(rs->dev[i].rdev.sb_page);
+		rs->dev[i].rdev.sb_page = NULL;
+		rs->dev[i].rdev.sb_loaded = 0;
 		if (rs->dev[i].data_dev)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
+	}
 
 	kfree(rs);
 }
@@ -160,7 +165,15 @@ static void context_free(struct raid_set
  *  <meta_dev>: meta device name or '-' if missing
  *  <data_dev>: data device name or '-' if missing
  *
- * This code parses those words.
+ * The following are acceptable:
+ *    - -
+ *    - <data_dev>
+ *    <meta_dev> <data_dev>
+ * The following is not allowed:
+ *    <meta_dev> -
+ *
+ * This code parses those words.  If there is a failure,
+ * context_free must be used to unwind the operations.
  */
 static int dev_parms(struct raid_set *rs, char **argv)
 {
@@ -183,8 +196,16 @@ static int dev_parms(struct raid_set *rs
 		rs->dev[i].rdev.mddev = &rs->md;
 
 		if (strcmp(argv[0], "-")) {
-			rs->ti->error = "Metadata devices not supported";
-			return -EINVAL;
+			ret = dm_get_device(rs->ti, argv[0],
+					    dm_table_get_mode(rs->ti->table),
+					    &rs->dev[i].meta_dev);
+			rs->ti->error = "RAID metadata device lookup failure";
+			if (ret)
+				return ret;
+
+			rs->dev[i].rdev.sb_page = alloc_page(GFP_KERNEL);
+			if (!rs->dev[i].rdev.sb_page)
+				return -ENOMEM;
 		}
 
 		if (!strcmp(argv[1], "-")) {
@@ -194,6 +215,10 @@ static int dev_parms(struct raid_set *rs
 				return -EINVAL;
 			}
 
+			rs->ti->error = "No data device supplied with metadata device";
+			if (rs->dev[i].meta_dev)
+				return -EINVAL;
+
 			continue;
 		}
 
@@ -205,6 +230,10 @@ static int dev_parms(struct raid_set *rs
 			return ret;
 		}
 
+		if (rs->dev[i].meta_dev) {
+			metadata_available = 1;
+			rs->dev[i].rdev.meta_bdev = rs->dev[i].meta_dev->bdev;
+		}
 		rs->dev[i].rdev.bdev = rs->dev[i].data_dev->bdev;
 		list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
@@ -330,23 +359,41 @@ static int parse_raid_params(struct raid
 	argv++;
 	num_raid_params--;
 
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		/*
+		 * We set each individual device as In_sync with a
+		 * completed 'recovery_offset'.  This is always true
+		 * unless there has been a device failure/replacement.
+		 * In such an event, one of the following actions
+		 * will take place:
+		 * 1) User specifies 'rebuild'
+		 *    - device is reset when param is read
+		 * 2) a new device is supplied
+		 *    - No matching superblock found, resets device
+		 * 3) device failure was transient and returns on reload
+		 *    - Failure noticed, resets device for bitmap replay
+		 * 4) device hadn't completed recovery after previous failure
+		 *    - Superblock is read and overrides recovery_offset
+		 *
+		 * What is found in the superblocks of the devices is always
+		 * authoritative, unless 'rebuild' or '[no]sync' was specified.
+		 */
+		set_bit(In_sync, &rs->dev[i].rdev.flags);
+		rs->dev[i].rdev.recovery_offset = MaxSector;
+	}
+
 	/*
 	 * Second, parse the unordered optional arguments
 	 */
-	for (i = 0; i < rs->md.raid_disks; i++)
-		set_bit(In_sync, &rs->dev[i].rdev.flags);
-
 	for (i = 0; i < num_raid_params; i++) {
 		if (!strcmp(argv[i], "nosync")) {
 			rs->md.recovery_cp = MaxSector;
 			rs->print_flags |= DMPF_NOSYNC;
-			rs->md.flags |= MD_SYNC_STATE_FORCED;
 			continue;
 		}
 		if (!strcmp(argv[i], "sync")) {
 			rs->md.recovery_cp = 0;
 			rs->print_flags |= DMPF_SYNC;
-			rs->md.flags |= MD_SYNC_STATE_FORCED;
 			continue;
 		}
 
@@ -479,13 +526,338 @@ static int raid_is_congested(struct dm_t
 }
 
 /*
+ * This structure is never used by userspace.  It is only ever
+ * used in these particular super block accessing functions.
+ * Therefore, we don't put it in any .h file.
+ *
+ * It makes sense to define a new magic number here.  This way,
+ * no userspace application will confuse the device as a device
+ * that is accessible through MD operations.  Devices with this
+ * superblock should only ever be accessed via device-mapper.
+ */
+#define DM_RAID_MAGIC 0x426E6F4A
+struct dm_raid_superblock {
+	__le32 magic;
+	__le32 flags; /* Used to indicate possible future changes */
+
+	__le64 events;
+	__le64 failed_devices; /* bitmap of devs, used to indicate a failure */
+
+	/*
+	 * The following offset variables are used to indicate:
+	 *  reshape_offset:  If the RAID level or layout of an array is
+	 *		     being updated, this offset keeps track of the
+	 *		     progress.
+	 *  disk_recovery_offset:  If drives are being repaired/replaced on
+	 *			   an individual basis, this offset tracks
+	 *			   that progress.  This might happen when a
+	 *			   drive fails and is replaced.
+	 *  array_resync_offset:  When the array is constructed for the first
+	 *			  time, all the devices must be made coherent.
+	 *			  This offset tracks that progress.
+	 */
+	__le64 reshape_offset;
+	__le64 disk_recovery_offset;
+	__le64 array_resync_offset;
+
+	/*
+	 * The following variable pairs reflect things
+	 * that can changed during an array reshape.
+	 */
+	__le32 level;
+	__le32 new_level;
+
+	__le32 layout;
+	__le32 new_layout;
+
+	__le32 stripe_sectors;
+	__le32 new_stripe_sectors;
+
+	__le32 num_devices;    /* Number of devs in RAID, Max = 64 */
+	__le32 new_num_devices;
+
+	__u8 pad[432];         /* Round out the struct to 512 bytes */
+};
+
+static int read_disk_sb(mdk_rdev_t *rdev, int size)
+{
+	BUG_ON(!rdev->sb_page);
+	if (rdev->sb_loaded)
+		return 0;
+
+	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
+		DMERR("Failed to read device superblock");
+		return -EINVAL;
+	}
+
+	rdev->sb_loaded = 1;
+	return 0;
+}
+
+static void super_sync(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdk_rdev_t *r, *t;
+	uint64_t failed_devices;
+	struct dm_raid_superblock *sb;
+
+	sb = (struct dm_raid_superblock *)page_address(rdev->sb_page);
+	failed_devices = le64_to_cpu(sb->failed_devices);
+
+	rdev_for_each(r, t, mddev)
+		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
+			failed_devices |= (1ULL << r->raid_disk);
+
+	memset(sb, 0, sizeof(*sb));
+
+	sb->magic  = cpu_to_le32(DM_RAID_MAGIC);
+	sb->flags  = cpu_to_le32(0); /* No flags yet */
+
+	sb->events = cpu_to_le64(mddev->events);
+
+	sb->reshape_offset = cpu_to_le64(mddev->reshape_position);
+	sb->disk_recovery_offset = cpu_to_le64(rdev->recovery_offset);
+	sb->array_resync_offset = cpu_to_le64(mddev->recovery_cp);
+
+	sb->level = cpu_to_le32(mddev->level);
+	sb->layout = cpu_to_le32(mddev->layout);
+	sb->stripe_sectors = cpu_to_le32(mddev->chunk_sectors);
+	sb->num_devices = cpu_to_le32(mddev->raid_disks);
+
+	if (mddev->reshape_position != MaxSector) {
+		sb->new_level = cpu_to_le32(mddev->new_level);
+		sb->new_layout = cpu_to_le32(mddev->new_layout);
+		sb->new_stripe_sectors = cpu_to_le32(mddev->new_chunk_sectors);
+		sb->new_num_devices = cpu_to_le32(mddev->delta_disks);
+	}
+	sb->failed_devices = cpu_to_le64(failed_devices);
+}
+
+/*
+ * super_load
+ *
+ * This function creates a superblock if one is not found on the device
+ * and will indicate the more appropriate device whose superblock should
+ * be used, if given two.
+ *
+ * Return: 1 if use rdev, 0 if use refdev, -Exxx otherwise
+ */
+static int super_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev)
+{
+	int r;
+	uint64_t ev1, ev2;
+	struct dm_raid_superblock *sb;
+	struct dm_raid_superblock *refsb;
+
+	if (sizeof(*sb) & (sizeof(*sb) - 1)) {
+		DMERR("Programmer error: Bad sized superblock (%lu)",
+		      sizeof(*sb));
+		return -EIO;
+	}
+
+	rdev->sb_start = 0;
+	rdev->sb_size  = sizeof(*sb);
+	r = read_disk_sb(rdev, rdev->sb_size);
+	if (r)
+		return r;
+
+	sb = (struct dm_raid_superblock *)page_address(rdev->sb_page);
+	if (sb->magic != cpu_to_le32(DM_RAID_MAGIC)) {
+		super_sync(rdev->mddev, rdev);
+
+		set_bit(FirstUse, &rdev->flags);
+
+		/* Force new superblocks to disk */
+		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
+
+		/* Any superblock is better than none, choose that if given */
+		return refdev ? 0 : 1;
+	}
+
+	if (!refdev)
+		return 1;
+
+	ev1 = le64_to_cpu(sb->events);
+	refsb = (struct dm_raid_superblock *)page_address(refdev->sb_page);
+	ev2 = le64_to_cpu(refsb->events);
+
+	return (ev1 > ev2) ? 1 : 0;
+}
+
+static int super_init_validation(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct raid_set *rs = container_of(mddev, struct raid_set, md);
+	uint64_t ev1;
+	uint32_t failed_devices;
+	struct dm_raid_superblock *sb;
+	uint32_t new_devs = 0;
+	uint32_t rebuilds = 0;
+	mdk_rdev_t *r, *t;
+	struct dm_raid_superblock *sb2;
+
+	sb = (struct dm_raid_superblock *)page_address(rdev->sb_page);
+	ev1 = le64_to_cpu(sb->events);
+	failed_devices = le64_to_cpu(sb->failed_devices);
+
+	mddev->events = ev1 ? ev1 : 1;
+
+	/* Reshaping is not currently allowed */
+	if ((le32_to_cpu(sb->level) != mddev->level) ||
+	    (le32_to_cpu(sb->layout) != mddev->layout) ||
+	    (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) ||
+	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
+		DMERR("Reshaping arrays not yet supported.");
+		return -EINVAL;
+	}
+
+	if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
+		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
+
+	/*
+	 * During load, we set FirstUse if a new superblock was written.
+	 * There are two reasons we might not have a superblock:
+	 * 1) The array is brand new - in which case, all of the
+	 *    devices must have their In_sync bit set.  Also,
+	 *    recovery_cp must be 0, unless forced.
+	 * 2) This is a new device being added to an old array
+	 *    and the new device needs to be rebuilt - in which
+	 *    case the In_sync bit will /not/ be set and
+	 *    recovery_cp must be MaxSector.
+	 */
+	rdev_for_each(r, t, mddev) {
+		if (!test_bit(In_sync, &r->flags)) {
+			if (!test_bit(FirstUse, &r->flags))
+				DMERR("Superblock area of "
+				      "rebuild device %d should have been "
+				      "cleared.\n", r->raid_disk);
+			set_bit(FirstUse, &r->flags);
+			rebuilds++;
+		} else if (test_bit(FirstUse, &r->flags))
+			new_devs++;
+	}
+
+	if (!rebuilds) {
+		if (new_devs == mddev->raid_disks) {
+			DMINFO("Superblocks created for new array");
+			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
+		} else if (new_devs) {
+			DMERR("New device injected "
+			      "into existing array without 'rebuild' "
+			      "parameter specified");
+			return -EINVAL;
+		}
+	} else if (new_devs) {
+		DMERR("'rebuild' devices cannot be "
+		      "injected into an array with other first-time devices");
+		return -EINVAL;
+	} else if (mddev->recovery_cp != MaxSector) {
+		DMERR("'rebuild' specified while array is not in-sync\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Now we set the Faulty bit for those devices that are
+	 * recorded in the superblock as failed.
+	 */
+	rdev_for_each(r, t, mddev) {
+		if (!r->sb_page)
+			continue;
+		sb2 = (struct dm_raid_superblock *)
+			page_address(r->sb_page);
+		sb2->failed_devices = 0;
+
+		if (failed_devices)
+			DMERR("Checking disk #%d: %s", r->raid_disk,
+			       (failed_devices & (1 << r->raid_disk)) ?
+			       test_bit(FirstUse, &r->flags) ?
+			       "Full resync needed" : "Partial resync needed" :
+			       "Clean");
+		if ((r->raid_disk >= 0) && !test_bit(FirstUse, &r->flags) &&
+		    (failed_devices & (1 << r->raid_disk)))
+			set_bit(Faulty, &r->flags);
+	}
+
+	return 0;
+}
+
+static int super_validate(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct dm_raid_superblock *sb;
+
+	sb = (struct dm_raid_superblock *)page_address(rdev->sb_page);
+
+	/*
+	 * If mddev->events is not set, we know we have not yet initialized
+	 * the array.
+	 */
+	if (!mddev->events && super_init_validation(mddev, rdev))
+		return -EINVAL;
+
+	mddev->bitmap_info.offset = 4096 >> 9; /* enable bitmap creation */
+	rdev->mddev->bitmap_info.default_offset = 4096 >> 9;
+	if (!test_bit(FirstUse, &rdev->flags)) {
+		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
+		if (rdev->recovery_offset != MaxSector)
+			clear_bit(In_sync, &rdev->flags);
+	}
+
+	if (test_bit(Faulty, &rdev->flags)) {
+		clear_bit(Faulty, &rdev->flags);
+		clear_bit(In_sync, &rdev->flags);
+		rdev->saved_raid_disk = rdev->raid_disk;
+		rdev->recovery_offset = 0;
+	}
+
+	clear_bit(FirstUse, &rdev->flags);
+	return 0;
+}
+
+static int analyze_superblocks(struct dm_target *ti, struct raid_set *rs)
+{
+	int ret;
+	mdk_rdev_t *rdev, *freshest, *tmp;
+	mddev_t *mddev = &rs->md;
+
+	freshest = NULL;
+	rdev_for_each(rdev, tmp, mddev) {
+		if (!rdev->meta_bdev)
+			continue;
+		ret = super_load(rdev, freshest);
+		switch (ret) {
+		case 1:
+			freshest = rdev;
+			break;
+		case 0:
+			break;
+		default:
+			ti->error = "Failed to load superblock";
+			return ret;
+		}
+	}
+
+	if (!freshest)
+		return 0;
+
+	/*
+	 * Validation of the freshest device provides the source of
+	 * validation for the remaining devices.
+	 */
+	ti->error = "Unable to assemble array: Invalid superblocks";
+	if (super_validate(mddev, freshest))
+		return -EINVAL;
+
+	rdev_for_each(rdev, tmp, mddev)
+		if ((rdev != freshest) && super_validate(mddev, rdev))
+			return -EINVAL;
+
+	return 0;
+}
+
+/*
  * Construct a RAID4/5/6 mapping:
  * Args:
  *	<raid_type> <#raid_params> <raid_params>		\
  *	<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }
  *
- * ** metadata devices are not supported yet, use '-' instead **
- *
  * <raid_params> varies by <raid_type>.  See 'parse_raid_params' for
  * details on possible <raid_params>.
  */
@@ -553,6 +925,11 @@ static int raid_ctr(struct dm_target *ti
 	if (ret)
 		goto bad;
 
+	rs->md.sync_super = super_sync;
+	ret = analyze_superblocks(ti, rs);
+	if (ret)
+		goto bad;
+
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
 
@@ -694,7 +1071,10 @@ static int raid_status(struct dm_target 
 
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
-			DMEMIT(" -"); /* metadata device */
+			if (rs->dev[i].meta_dev)
+				DMEMIT(" %s", rs->dev[i].meta_dev->name);
+			else
+				DMEMIT(" -");
 
 			if (rs->dev[i].data_dev)
 				DMEMIT(" %s", rs->dev[i].data_dev->name);
@@ -751,6 +1131,7 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
+	bitmap_load(&rs->md);
 	mddev_resume(&rs->md);
 }
 
Index: linux-2.6/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-2.6/Documentation/device-mapper/dm-raid.txt
@@ -46,10 +46,8 @@ is given for the metadata device positio
 missing at creation time, a '-' can be given for both the metadata and
 data drives for a given position.
 
-NB. Currently all metadata devices must be specified as '-'.
-
 Examples:
-# RAID4 - 4 data drives, 1 parity
+# RAID4 - 4 data drives, 1 parity (no metadata devices)
 # No metadata devices specified to hold superblock/bitmap info
 # Chunk size of 1MiB
 # (Lines separated for easy reading)
@@ -57,12 +55,12 @@ Examples:
         raid4 1 2048 \
         5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81
 
-# RAID4 - 4 data drives, 1 parity (no metadata devices)
+# RAID4 - 4 data drives, 1 parity (with metadata devices)
 # Chunk size of 1MiB, force RAID initialization,
 #       min recovery rate at 20 kiB/sec/disk
 0 1960893648 raid \
-        raid4 4 2048 min_recovery_rate 20 sync\
-        5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81
+        raid4 4 2048 sync min_recovery_rate 20 \
+        5 8:17 8:18 8:33 8:34 8:49 8:50 8:65 8:66 8:81 8:82
 
 Performing a 'dmsetup table' will display the CTR table used to construct the
 mapping.  The optional parameters will always be printed in the order listed
