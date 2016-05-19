From: heinzm@redhat.com
Subject: [PATCH 09/11] dm-raid: enhance super_sync() to support
	new superblock members introduced
Date: Thu, 19 May 2016 18:49:32 +0200
Message-ID: <1463676574-12596-10-git-send-email-heinzm@redhat.com>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

Add transfering the new takeover/reshape related superblock
members introduced to the super_sync() function:

 - add/move supporting functions

 - add failed devices bitfield transfer functions to
   retrieve the bitfield from superblock format or
   update it in the superblock

 - add code to transfer all new members

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 104 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 80 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index dac8dfa..8e419a6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -214,6 +214,12 @@ static bool _test_flags(uint32_t flags, uint32_t all_flags)
 	return (flags & all_flags) ? true : false;
 }
 
+/* Clear (multiple) @flags in @all_flags */
+static void _clear_flags(uint32_t flags, uint32_t *all_flags)
+{
+	*all_flags &= ~flags;
+}
+
 /* Return true if single @flag is set in @*flags, else set it and return false */
 static bool _test_and_set_flag(uint32_t flag, uint32_t *flags)
 {
@@ -1278,31 +1284,69 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return 0;
 }
 
+/* Helper to retrieve all failed devices bits from @sb */
+static void sb_retrieve_failed_devices(struct dm_raid_superblock *sb, uint64_t *failed_devices)
+{
+	failed_devices[0] = le64_to_cpu(sb->failed_devices);
+	memset(failed_devices + 1, 0, sizeof(sb->extended_failed_devices));
+
+	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
+		int i = ARRAY_SIZE(sb->extended_failed_devices);
+
+		while (i--)
+			failed_devices[i+1] = le64_to_cpu(sb->extended_failed_devices[i]);
+	}
+}
+
+/* Helper to update all failed devices bits in @sb */
+static void sb_update_failed_devices(struct dm_raid_superblock *sb, uint64_t *failed_devices)
+{
+	int i = ARRAY_SIZE(sb->extended_failed_devices);
+
+	sb->failed_devices = cpu_to_le64(failed_devices[0]);
+	while (i--)
+		sb->extended_failed_devices[i] = cpu_to_le64(failed_devices[i+1]);
+}
+
+/*
+ * Synchronize the superblock members with the raid set properties
+ *
+ * All superblock data is little endian.
+ */
 static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 {
-	int i;
-	uint64_t failed_devices;
+	bool update_failed_devices = false;
+	unsigned int i;
+	uint64_t failed_devices[DISKS_ARRAY_ELEMS];
 	struct dm_raid_superblock *sb;
 	struct raid_set *rs = container_of(mddev, struct raid_set, md);
 
+	/* No metadata device, no superblock */
+	if (!rdev->meta_bdev)
+		return;
+
+	BUG_ON(!rdev->sb_page);
+
 	sb = page_address(rdev->sb_page);
-	failed_devices = le64_to_cpu(sb->failed_devices);
 
-	for (i = 0; i < mddev->raid_disks; i++)
-		if (!rs->dev[i].data_dev ||
-		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
-			failed_devices |= (1ULL << i);
+	sb_retrieve_failed_devices(sb, failed_devices);
 
-	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
+	for (i = 0; i < rs->raid_disks; i++)
+		if (!rs->dev[i].data_dev || test_bit(Faulty, &rs->dev[i].rdev.flags)) {
+			update_failed_devices = true;
+			set_bit(i, (void *) failed_devices);
+		}
+
+	if (update_failed_devices)
+		sb_update_failed_devices(sb, failed_devices);
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
-	sb->compat_features = cpu_to_le32(0);	/* No features yet */
+	sb->compat_features = cpu_to_le32(0); /* Don't set reshape flag yet */
 
 	sb->num_devices = cpu_to_le32(mddev->raid_disks);
 	sb->array_position = cpu_to_le32(rdev->raid_disk);
 
 	sb->events = cpu_to_le64(mddev->events);
-	sb->failed_devices = cpu_to_le64(failed_devices);
 
 	sb->disk_recovery_offset = cpu_to_le64(rdev->recovery_offset);
 	sb->array_resync_offset = cpu_to_le64(mddev->recovery_cp);
@@ -1310,6 +1354,32 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
 	sb->stripe_sectors = cpu_to_le32(mddev->chunk_sectors);
+
+	sb->new_level = cpu_to_le32(mddev->new_level);
+	sb->new_layout = cpu_to_le32(mddev->new_layout);
+	sb->new_stripe_sectors = cpu_to_le32(mddev->new_chunk_sectors);
+
+	sb->delta_disks = cpu_to_le32(mddev->delta_disks);
+
+	smp_rmb(); /* Make sure we access most recent reshape position */
+	sb->reshape_position = cpu_to_le64(mddev->reshape_position);
+	if (le64_to_cpu(sb->reshape_position) != MaxSector) {
+		/* Flag ongoing reshape */
+		sb->flags |= cpu_to_le32(SB_FLAG_RESHAPE_ACTIVE);
+
+		if (mddev->delta_disks < 0 || mddev->reshape_backwards)
+			sb->flags |= cpu_to_le32(SB_FLAG_RESHAPE_BACKWARDS);
+	} else
+		/* Flag no reshape */
+		_clear_flags(cpu_to_le32(SB_FLAG_RESHAPE_ACTIVE|SB_FLAG_RESHAPE_BACKWARDS), &sb->flags);
+
+	sb->array_sectors = cpu_to_le64(mddev->array_sectors);
+	sb->data_offset = cpu_to_le64(rdev->data_offset);
+	sb->new_data_offset = cpu_to_le64(rdev->new_data_offset);
+	sb->sectors = cpu_to_le64(rdev->sectors);
+
+	/* Zero out the rest of the payload after the size of the superblock */
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 }
 
 /*
@@ -1369,20 +1439,6 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	return (events_sb > events_refsb) ? 1 : 0;
 }
 
-/* Helper to retrieve all failed devices bits from @sb */
-static void sb_retrieve_failed_devices(struct dm_raid_superblock *sb, uint64_t *failed_devices)
-{
-	failed_devices[0] = le64_to_cpu(sb->failed_devices);
-	memset(failed_devices + 1, 0, sizeof(sb->extended_failed_devices));
-
-	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
-		int i = ARRAY_SIZE(sb->extended_failed_devices);
-
-		while (i--)
-			failed_devices[i+1] = le64_to_cpu(sb->extended_failed_devices[i]);
-	}
-}
-
 static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 {
 	int role;
-- 
2.5.5
