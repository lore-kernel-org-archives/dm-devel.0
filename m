From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 10 of 15] md new param to calc_dev_sboffset
Date: Fri, 3 Dec 2010 13:55:20 -0600
Message-ID: <201012031955.oB3JtKKT003488@hydrogen.msp.redhat.com>
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

Patch name: md-new-param-to-calc_dev_sboffset.patch

When we allow for separate devices for data and metadata
in a later patch, we will need to be able to calculate
the superblock offset based on more than the bdev.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -704,9 +704,9 @@ static struct mdk_personality *find_pers
 }
 
 /* return the offset of the super block in 512byte sectors */
-static inline sector_t calc_dev_sboffset(struct block_device *bdev)
+static inline sector_t calc_dev_sboffset(mdk_rdev_t *rdev)
 {
-	sector_t num_sectors = i_size_read(bdev->bd_inode) / 512;
+	sector_t num_sectors = i_size_read(rdev->bdev->bd_inode) / 512;
 	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
@@ -990,7 +990,7 @@ static int super_90_load(mdk_rdev_t *rde
 	 *
 	 * It also happens to be a multiple of 4Kb.
 	 */
-	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+	rdev->sb_start = calc_dev_sboffset(rdev);
 
 	ret = read_disk_sb(rdev, MD_SB_BYTES);
 	if (ret) return ret;
@@ -1331,7 +1331,7 @@ super_90_rdev_size_change(mdk_rdev_t *rd
 		return 0; /* component must fit device */
 	if (rdev->mddev->bitmap_info.offset)
 		return 0; /* can't move bitmap */
-	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+	rdev->sb_start = calc_dev_sboffset(rdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
 		num_sectors = rdev->sb_start;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
@@ -5237,7 +5237,7 @@ static int add_new_disk(mddev_t * mddev,
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
 			rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 		} else
-			rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+			rdev->sb_start = calc_dev_sboffset(rdev);
 		rdev->sectors = rdev->sb_start;
 
 		err = bind_rdev_to_array(rdev, mddev);
@@ -5304,7 +5304,7 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 
 	if (mddev->persistent)
-		rdev->sb_start = calc_dev_sboffset(rdev->bdev);
+		rdev->sb_start = calc_dev_sboffset(rdev);
 	else
 		rdev->sb_start = i_size_read(rdev->bdev->bd_inode) / 512;
 
