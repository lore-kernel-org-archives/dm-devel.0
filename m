From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 05/08] dm: add DMF_FREEING flag to indicate that
	a mapped_device is no longer legal to use
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18965@locomotive.unixthugs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device Mapper Development List <dm-devel@redhat.com>
List-Id: dm-devel.ids


 The previous patch serialized reference counting with respect to users with
 valid references, but there is a chicken-egg problem between the block layer
 and dm that causes the gendisk associated with a mapping to keep a reference-
 less pointer to the mapped_device. 

 Without major reconstruction, the pointer must be referenceless or we run
 into a chicken-egg problem with freeing the disk or the mapped_device. When
 the block layer is actually using the mapped_device, a reference is taken.

 This patch adds a flag to indicate that the mapped_device is no longer valid.
 In free_dev(), we reset the ->private_data pointer, but prior to that, the
 block layer can still attempt to open the device. The flag is used to 
 check the validity of the pointer, and return -ENXIO if it is invalid.
 Otherwise, an appropriate reference is taken.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:46.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:46.000000000 -0400
@@ -63,6 +63,7 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_BLOCK_IO 0
 #define DMF_SUSPENDED 1
 #define DMF_FROZEN 2
+#define DMF_FREEING 3
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
@@ -221,9 +222,16 @@ static int dm_blk_open(struct inode *ino
 {
 	struct mapped_device *md;
 
+	spin_lock(&_minor_lock);
 	md = inode->i_bdev->bd_disk->private_data;
-	dm_get(md);
-	return 0;
+	if (md) {
+		if (test_bit(DMF_FREEING, &md->flags) == 0)
+			dm_get(md);
+		else
+			md = NULL;
+	}
+	spin_unlock(&_minor_lock);
+	return md ? 0 : -ENXIO;
 }
 
 static int dm_blk_close(struct inode *inode, struct file *file)
@@ -920,6 +928,11 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->io_pool);
 	del_gendisk(md->disk);
 	free_minor(minor);
+
+	spin_lock(&_minor_lock);
+	md->disk->private_data = NULL;
+	spin_unlock(&_minor_lock);
+
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
 	kfree(md);
@@ -1027,6 +1040,11 @@ static struct mapped_device *dm_find_md(
 	if (md && (md == MINOR_ALLOCED || (dm_disk(md)->first_minor != minor)))
 		md = NULL;
 
+	if (md) {
+		if (test_bit(DMF_FREEING, &md->flags))
+			md = NULL;
+	}
+
 	spin_unlock(&_minor_lock);
 
 	return md;
@@ -1061,9 +1079,12 @@ void dm_put(struct mapped_device *md)
 {
 	struct dm_table *map;
 
+	BUG_ON(test_bit(DMF_FREEING, &md->flags));
+
 	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
 		map = dm_get_table(md);
 		idr_replace(&_minor_idr, MINOR_ALLOCED, md->disk->first_minor);
+		set_bit(DMF_FREEING, &md->flags);
 		spin_unlock(&_minor_lock);
 		if (!dm_suspended(md)) {
 			dm_table_presuspend_targets(map);
