From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 14 of 15] md new superblock type
Date: Fri, 3 Dec 2010 13:56:03 -0600
Message-ID: <201012031956.oB3Ju333003782@hydrogen.msp.redhat.com>
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

Patch name: md-new-superblock-type.patch

New MD superblock methods that will be used by device-mapper.
The new format will contain the bare minimum to connote
device health, presence of bitmap, and (possibly) reshaping
information.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -1723,6 +1723,171 @@ super_1_rdev_size_change(mdk_rdev_t *rde
 	return num_sectors;
 }
 
+/*
+ * This structure is never used by userspace.  It is only ever
+ * used in these particular super block accessing functions.
+ * Therefore, we don't put it in any .h file.
+ *
+ * It makes sense to define a new magic number here.  This way,
+ * no userspace application will confuse the device as a device
+ * that is accessible through MD operations.  Devices with this
+ * superblock should only ever be accessed via device-mapper.
+ */
+#define MD_DM_SB_MAGIC 0x426E6F4A
+struct mdp_superblock_2 {
+	__le32 magic;
+	__le32 flags;
+
+	__le64 events;
+	__le64 reshape_position;
+
+	__le32 num_devices;     /* Number of devs in RAID, Max = 32 */
+	__le32 failed_devices;  /* bitmap of devs used to indicate a failure */
+
+	__le32 reserved[120];   /* Round out the struct to 512 bytes */
+};
+
+static void super_2_sync(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdk_rdev_t *r, *t;
+	uint32_t failed_devices;
+	struct mdp_superblock_2 *sb;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	failed_devices = le32_to_cpu(sb->failed_devices);
+
+	rdev_for_each(r, t, mddev)
+		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags)) {
+			printk(KERN_INFO "  Dev #%d is faulty\n",
+			       (r->raid_disk < 0) ?
+			       r->saved_raid_disk : r->raid_disk);
+			failed_devices |= (1 << r->raid_disk);
+		}
+
+	memset(sb, 0, sizeof(*sb));
+
+	sb->magic  = cpu_to_le32(MD_DM_SB_MAGIC);
+	sb->events = cpu_to_le64(mddev->events);
+	sb->num_devices = cpu_to_le32(mddev->raid_disks);
+	sb->failed_devices = cpu_to_le32(failed_devices);
+}
+
+/*
+ * super_2_load
+ *
+ * This function creates a superblock if one is not found on the device
+ * and will indicate the more appropriate device whose superblock should
+ * be used - if given two.
+ *
+ * Return: 1 if use rdev, 0 if use refdev, -Exxx otherwise
+ */
+static int super_2_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
+{
+	int r;
+	uint64_t ev1, ev2;
+	struct mdp_superblock_2 *sb;
+	struct mdp_superblock_2 *refsb;
+
+	if (sizeof(*sb) & (sizeof(*sb) - 1)) {
+		printk(KERN_ERR "Programmer error: Bad sized superblock (%lu)\n",
+		       sizeof(*sb));
+		return -EIO;
+	}
+
+	rdev->sb_start = 0;
+	rdev->sb_size  = sizeof(*sb);
+	r = read_disk_sb(rdev, rdev->sb_size);
+	if (r)
+		return r;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	if (sb->magic != cpu_to_le32(MD_DM_SB_MAGIC)) {
+		printk(KERN_INFO "  Superblock not found: creating new\n");
+		super_2_sync(rdev->mddev, rdev);
+
+		/* Force new superblocks to disk */
+		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
+
+		/* Any superblock is better than none, choose that if given */
+		return refdev ? 0 : 1;
+	}
+
+	ev1 = le64_to_cpu(sb->events);
+	if (!refdev) {
+		if (le32_to_cpu(sb->num_devices) != rdev->mddev->raid_disks) {
+			/*
+			 * User should clear device of old superblocks before
+			 * attempting to create something different.
+			 */
+
+			printk(KERN_ERR "Configuration incompatible with on-disk information\n");
+			return -EINVAL;
+		}
+		return 1;
+	}
+
+	refsb = (struct mdp_superblock_2 *)page_address(refdev->sb_page);
+	ev2 = le64_to_cpu(refsb->events);
+
+	if (ev1 != ev2)
+		printk(KERN_INFO "Comparing event counts [%llu %llu], choosing dev #%d\n",
+		       ev1, ev2, (ev1 > ev2) ? rdev->raid_disk :
+		       refdev->raid_disk);
+
+	return (ev1 > ev2) ? 1 : 0;
+}
+
+static int super_2_validate(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	uint64_t ev1;
+	uint32_t failed_devices;
+	struct mdp_superblock_2 *sb;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	ev1 = le64_to_cpu(sb->events);
+	failed_devices = le32_to_cpu(sb->failed_devices);
+
+	if (!mddev->events) {
+		mdk_rdev_t *r, *t;
+		struct mdp_superblock_2 *sb2;
+
+		mddev->events = ev1;
+		rdev_for_each(r, t, mddev) {
+			if (!r->sb_page)
+				continue;
+			sb2 = (struct mdp_superblock_2 *)
+				page_address(r->sb_page);
+			sb2->failed_devices = 0;
+
+			if ((r->raid_disk >= 0) &&
+			    (failed_devices & (1 << r->raid_disk)))
+				set_bit(Faulty, &r->flags);
+		}
+	}
+
+	rdev->mddev->bitmap_info.offset = 0; /* disable bitmap creation */
+	rdev->mddev->bitmap_info.default_offset = 1024 >> 9;
+
+	/*
+	 * If the device was marked as failed when the array
+	 * was previously active, we must mark the device as
+	 * not In_sync
+	 */
+	if (test_bit(Faulty, &rdev->flags)) {
+		printk(KERN_INFO "  Dev #%d marked as failed, clearing In_sync\n",
+		       rdev->raid_disk);
+		clear_bit(Faulty, &rdev->flags);
+		clear_bit(In_sync, &rdev->flags);
+		rdev->recovery_offset = 0;
+	}
+
+	/* FIXME: Pull these debug statements */
+	if (test_bit(In_sync, &rdev->flags))
+		printk(KERN_INFO "  In_sync flag set\n");
+
+	return 0;
+}
+
 static struct super_type super_types[] = {
 	[0] = {
 		.name	= "0.90.0",
@@ -1740,6 +1905,14 @@ static struct super_type super_types[] =
 		.sync_super	    = super_1_sync,
 		.rdev_size_change   = super_1_rdev_size_change,
 	},
+	[2] = {
+		.name	= "dm",
+		.owner	= THIS_MODULE,
+		.load_super	    = super_2_load,
+		.validate_super	    = super_2_validate,
+		.sync_super	    = super_2_sync,
+		.rdev_size_change   = super_1_rdev_size_change,
+	},
 };
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
@@ -4408,6 +4581,20 @@ static void md_safemode_timeout(unsigned
 	md_wakeup_thread(mddev->thread);
 }
 
+static int should_read_super(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev, *tmp;
+
+	if (!mddev->raid_disks)
+		return 1;
+
+	rdev_for_each(rdev, tmp, mddev)
+		if (rdev->meta_bdev)
+			return 1;
+
+	return 0;
+}
+
 static int start_dirty_degraded;
 
 int md_run(mddev_t *mddev)
@@ -4429,7 +4616,7 @@ int md_run(mddev_t *mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->raid_disks) {
+	if (should_read_super(mddev)) {
 		if (!mddev->persistent)
 			return -EINVAL;
 		analyze_sbs(mddev);
