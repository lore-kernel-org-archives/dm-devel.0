From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 12 of 15] md separate meta and data devs
Date: Fri, 3 Dec 2010 13:55:42 -0600
Message-ID: <201012031955.oB3JtgiV003636@hydrogen.msp.redhat.com>
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

Patch name: md-separate-meta-and-data-devs.patch

Allow the metadata to be on a separate device from the
data.

This doesn't mean the data and metadata will by on separate
physical devices - it simply gives device-mapper and userspace
tools more flexibility.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -263,14 +263,18 @@ static mdk_rdev_t *next_active_rdev(mdk_
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev = NULL;
+	struct block_device *bdev;
 	mddev_t *mddev = bitmap->mddev;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
 		loff_t offset = mddev->bitmap_info.offset;
+
+		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
+
 		if (page->index == bitmap->file_pages-1)
 			size = roundup(bitmap->last_page_size,
-				       bdev_logical_block_size(rdev->bdev));
+				       bdev_logical_block_size(bdev));
 		/* Just make sure we aren't corrupting data or
 		 * metadata
 		 */
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -707,6 +707,20 @@ static struct mdk_personality *find_pers
 static inline sector_t calc_dev_sboffset(mdk_rdev_t *rdev)
 {
 	sector_t num_sectors = i_size_read(rdev->bdev->bd_inode) / 512;
+
+	if (rdev->meta_bdev)
+		return 0;
+
+	return MD_NEW_SIZE_SECTORS(num_sectors);
+}
+
+static inline sector_t calc_dev_sectors(mdk_rdev_t *rdev)
+{
+	sector_t num_sectors = i_size_read(rdev->bdev->bd_inode) / 512;
+
+	if (rdev->meta_bdev)
+		return num_sectors;
+
 	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
@@ -764,7 +778,7 @@ void md_super_write(mddev_t *mddev, mdk_
 	 */
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
-	bio->bi_bdev = rdev->bdev;
+	bio->bi_bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
@@ -802,7 +816,8 @@ int sync_page_io(mdk_rdev_t *rdev, secto
 
 	rw |= REQ_SYNC | REQ_UNPLUG;
 
-	bio->bi_bdev = rdev->bdev;
+	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
+		rdev->meta_bdev : rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	init_completion(&event);
@@ -820,6 +835,7 @@ EXPORT_SYMBOL_GPL(sync_page_io);
 static int read_disk_sb(mdk_rdev_t * rdev, int size)
 {
 	char b[BDEVNAME_SIZE];
+
 	if (!rdev->sb_page) {
 		MD_BUG();
 		return -EINVAL;
@@ -1678,7 +1694,7 @@ super_1_rdev_size_change(mdk_rdev_t *rde
 	sector_t max_sectors;
 	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
-	if (rdev->sb_start < rdev->data_offset) {
+	if (rdev->meta_bdev || rdev->sb_start < rdev->data_offset) {
 		/* minor versions 1 and 2; superblock before data */
 		max_sectors = i_size_read(rdev->bdev->bd_inode) >> 9;
 		max_sectors -= rdev->data_offset;
@@ -1769,6 +1785,7 @@ int md_integrity_register(mddev_t *mddev
 		 * If at least one rdev is not integrity capable, we can not
 		 * enable data integrity for the md device.
 		 */
+		/* FIXME (brassow): check both [meta_]bdev ? */
 		if (!bdev_get_integrity(rdev->bdev))
 			return -EINVAL;
 		if (!reference) {
@@ -1935,6 +1952,8 @@ static int lock_rdev(mdk_rdev_t *rdev, d
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
 
+	/* FIXME (brassow): [un]lock all both [meta_]bdev ? */
+
 	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE);
 	if (IS_ERR(bdev)) {
 		printk(KERN_ERR "md: could not open %s.\n",
@@ -1957,6 +1976,8 @@ static int lock_rdev(mdk_rdev_t *rdev, d
 static void unlock_rdev(mdk_rdev_t *rdev)
 {
 	struct block_device *bdev = rdev->bdev;
+
+	/* FIXME brassow: end here on 'bdev' search */
 	rdev->bdev = NULL;
 	if (!bdev)
 		MD_BUG();
@@ -4434,7 +4455,18 @@ int md_run(mddev_t *mddev)
 		 * We don't want the data to overlap the metadata,
 		 * Internal Bitmap issues have been handled elsewhere.
 		 */
-		if (rdev->data_offset < rdev->sb_start) {
+		if (rdev->meta_bdev) {
+			/* Metadata is on a separate device */
+			if (rdev->data_offset) {
+				printk(KERN_ERR "md: data_offset should be 0\n");
+				return -EINVAL;
+			}
+
+			if (rdev->sb_start) {
+				printk(KERN_ERR "md: sb_start should be 0\n");
+				return -EINVAL;
+			}
+		} else if (rdev->data_offset < rdev->sb_start) {
 			if (mddev->dev_sectors &&
 			    rdev->data_offset + mddev->dev_sectors
 			    > rdev->sb_start) {
@@ -5240,7 +5272,7 @@ static int add_new_disk(mddev_t * mddev,
 			rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 		} else
 			rdev->sb_start = calc_dev_sboffset(rdev);
-		rdev->sectors = rdev->sb_start;
+		rdev->sectors = calc_dev_sectors(rdev);
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
@@ -5310,7 +5342,7 @@ static int hot_add_disk(mddev_t * mddev,
 	else
 		rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 
-	rdev->sectors = rdev->sb_start;
+	rdev->sectors = calc_dev_sectors(rdev);
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
@@ -5519,7 +5551,6 @@ static int update_size(mddev_t *mddev, s
 	 * sb_start or, if that is <data_offset, it must fit before the size
 	 * of each device.  If num_sectors is zero, we find the largest size
 	 * that fits.
-
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -60,6 +60,12 @@ struct mdk_rdev_s
 	mddev_t *mddev;			/* RAID array if running */
 	int last_events;		/* IO event timestamp */
 
+	/*
+	 * If meta_bdev is non-NULL, it means that a separate device is
+	 * being used to store the metadata (superblock/bitmap) which
+	 * would otherwise be contained on the same device as the data (bdev).
+	 */
+	struct block_device *meta_bdev;
 	struct block_device *bdev;	/* block device handle */
 
 	struct page	*sb_page;
