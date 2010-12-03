From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 15 of 15] md add bitmap support
Date: Fri, 3 Dec 2010 13:56:14 -0600
Message-ID: <201012031956.oB3JuEs3003855@hydrogen.msp.redhat.com>
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

Patch name: md-add-bitmap-support.patch

Add bitmap support to the device-mapper specific metadata area.

Bitmaps are now created and written, but they are not honored when the
array is started and I don't know why yet.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -1802,9 +1802,24 @@ static int super_2_load(mdk_rdev_t *rdev
 
 	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
 	if (sb->magic != cpu_to_le32(MD_DM_SB_MAGIC)) {
+		/*
+		 * If we are in this function at all, it means that
+		 * the device-mapper interface is being used /and/
+		 * metadata devices have been allocated and specified.
+		 *
+		 * If no superblock has been found, then we must create
+		 * a new one - including a new bitmap.  First, populate
+		 * the superblock with good info.  Then set the bitmap's
+		 * chunksize, which has the effect of notifying 'bitmap_create'
+		 * to allocate the bitmap's superblock page.  Finally,
+		 * ensure that the changes will be written by setting
+		 * MD_CHANGE_DEVS.
+		 */
 		printk(KERN_INFO "  Superblock not found: creating new\n");
 		super_2_sync(rdev->mddev, rdev);
 
+		rdev->mddev->bitmap_info.chunksize = rdev->mddev->chunk_sectors;
+
 		/* Force new superblocks to disk */
 		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
 
@@ -1865,7 +1880,7 @@ static int super_2_validate(mddev_t *mdd
 		}
 	}
 
-	rdev->mddev->bitmap_info.offset = 0; /* disable bitmap creation */
+	mddev->bitmap_info.offset = 1024 >> 9; /* enable bitmap creation */
 	rdev->mddev->bitmap_info.default_offset = 1024 >> 9;
 
 	/*
Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -533,6 +533,90 @@ void bitmap_print_sb(struct bitmap *bitm
 	kunmap_atomic(sb, KM_USER0);
 }
 
+/*
+ * bitmap_new_disk_sb
+ * @bitmap
+ *
+ * This function is somewhat the reverse of bitmap_read_sb.  bitmap_read_sb
+ * reads and verifies the on-disk bitmap superblock and populates bitmap_info.
+ * This function verifies 'bitmap_info' and populates the on-disk bitmap
+ * structure, which is to be written to disk.
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int bitmap_new_disk_sb(struct bitmap *bitmap)
+{
+	char *reason = NULL;
+	bitmap_super_t *sb;
+	unsigned long chunksize, daemon_sleep, write_behind;
+	unsigned long long events;
+	int err = -EINVAL;
+
+	printk("CREATING NEW BITMAP SUPERBLOCK\n");
+
+	/* page 0 is the superblock, read it... */
+	/* FIXME:  It's probably enough to just allocate the page */
+	bitmap->sb_page = read_sb_page(bitmap->mddev,
+				       bitmap->mddev->bitmap_info.offset,
+				       NULL, 0, sizeof(bitmap_super_t));
+
+	if (IS_ERR(bitmap->sb_page)) {
+		err = PTR_ERR(bitmap->sb_page);
+		bitmap->sb_page = NULL;
+		return err;
+	}
+
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+
+	sb->magic = cpu_to_le32(BITMAP_MAGIC);
+	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
+
+	chunksize = bitmap->mddev->bitmap_info.chunksize;
+	BUG_ON(!chunksize);
+	if ((1 << ffz(~chunksize)) != chunksize) {
+		kunmap_atomic(sb, KM_USER0);
+		printk(KERN_ERR "bitmap chunksize not a power of 2\n");
+		return -EINVAL;
+	}
+	sb->chunksize = cpu_to_le32(chunksize);
+
+	daemon_sleep = bitmap->mddev->bitmap_info.daemon_sleep;
+	if (!daemon_sleep ||
+	    (daemon_sleep < 1) || (daemon_sleep > MAX_SCHEDULE_TIMEOUT)) {
+		/* FIXME: A guess */
+		printk(KERN_INFO "Guessing at good daemon_sleep default\n");
+		daemon_sleep = MAX_SCHEDULE_TIMEOUT / 2;
+	}
+	sb->daemon_sleep = cpu_to_le32(daemon_sleep);
+	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
+
+	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
+	if (write_behind > COUNTER_MAX) {
+		/* FIXME: A guess */
+		printk(KERN_INFO "Guessing at good write_behind default\n");
+		write_behind = COUNTER_MAX / 2;
+	}
+	sb->write_behind = cpu_to_le32(write_behind);
+	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
+
+	/* keep the array size field of the bitmap superblock up to date */
+	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
+
+	memcpy(sb->uuid, bitmap->mddev->uuid, 16);
+
+	/* Force full recovery? */
+	bitmap->flags |= BITMAP_STALE;
+	sb->state |= cpu_to_le32(BITMAP_STALE);
+	bitmap->events_cleared = bitmap->mddev->events;
+	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+
+	bitmap->flags |= BITMAP_HOSTENDIAN;
+	sb->version = cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
+
+	kunmap_atomic(sb, KM_USER0);
+	return 0;
+}
+
 /* read the superblock from the bitmap file and initialize some bitmap fields */
 static int bitmap_read_sb(struct bitmap *bitmap)
 {
@@ -542,6 +626,8 @@ static int bitmap_read_sb(struct bitmap 
 	unsigned long long events;
 	int err = -EINVAL;
 
+	printk("READING OLD BITMAP\n");
+
 	/* page 0 is the superblock, read it... */
 	if (bitmap->file) {
 		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
@@ -1687,9 +1773,20 @@ int bitmap_create(mddev_t *mddev)
 		vfs_fsync(file, 1);
 	}
 	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunksize) */
-	if (!mddev->bitmap_info.external)
-		err = bitmap_read_sb(bitmap);
-	else {
+	if (!mddev->bitmap_info.external) {
+		/*
+		 * If the bitmap is internal and persistent and the chunksize
+		 * is already set, then we know we are being called through
+		 * device-mapper and that this is the first time the array
+		 * is being activated.  We must create a new on-disk bitmap
+		 * instance.
+		 */
+		if (!bitmap->file && bitmap->mddev->persistent &&
+		    mddev->bitmap_info.chunksize)
+			err = bitmap_new_disk_sb(bitmap);
+		else
+			err = bitmap_read_sb(bitmap);
+	} else {
 		err = 0;
 		if (mddev->bitmap_info.chunksize == 0 ||
 		    mddev->bitmap_info.daemon_sleep == 0)
