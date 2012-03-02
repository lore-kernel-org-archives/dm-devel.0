From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: relax hard limit on the maximum size of
	a metadata device
Date: Fri,  2 Mar 2012 16:32:33 -0500
Message-ID: <1330723953-16872-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

The thin metadata format can only make use of a device that is <=
METADATA_DEV_MAX_SECTORS (currently 15.9375 GB).  Therefore, there is no
practical benefit to using a larger device.

However, it may be that other factors impose a certain granularity for
the space that is allocated to a device (E.g. lvm2 can impose a coarse
granularity through the use of large, >= 1 GB, physical extents).

Rather than reject a larger metadata device, during thin-pool device
construction, switch to allowing it but issue a warning if a device
larger than METADATA_DEV_MAX_SECTORS_NEAREST_POWER_OF_2 (16 GB) is
provided.  Any space over 15.9375 GB will not be used.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |    8 +++++---
 drivers/md/dm-thin-metadata.c                     |    5 ++++-
 drivers/md/dm-thin-metadata.h                     |   15 +++++++++++++++
 drivers/md/dm-thin.c                              |   18 ++++--------------
 4 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 57076dd..ca54bac 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -75,10 +75,12 @@ less sharing than average you'll need a larger-than-average metadata device.
 
 As a guide, we suggest you calculate the number of bytes to use in the
 metadata device as 48 * $data_dev_size / $data_block_size but round it up
-to 2MB if the answer is smaller.  The largest size supported is 16GB.
+to 2MB if the answer is smaller.  If you're creating large numbers of
+snapshots which are recording large amounts of change, you may find you
+need to increase this.
 
-If you're creating large numbers of snapshots which are recording large
-amounts of change, you may need find you need to increase this.
+The largest size supported, without a warning about space being wasted,
+is 16GB.
 
 Reloading a pool table
 ----------------------
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index f3ba61d..1783741 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -718,7 +718,10 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	disk_super->version = cpu_to_le32(THIN_VERSION);
 	disk_super->time = 0;
 	disk_super->metadata_block_size = cpu_to_le32(THIN_METADATA_BLOCK_SIZE >> SECTOR_SHIFT);
-	disk_super->metadata_nr_blocks = cpu_to_le64(bdev_size >> SECTOR_TO_BLOCK_SHIFT);
+	if (bdev_size > METADATA_DEV_MAX_SECTORS)
+		disk_super->metadata_nr_blocks = cpu_to_le64(METADATA_DEV_MAX_SECTORS >> SECTOR_TO_BLOCK_SHIFT);	
+	else
+		disk_super->metadata_nr_blocks = cpu_to_le64(bdev_size >> SECTOR_TO_BLOCK_SHIFT);
 	disk_super->data_block_size = cpu_to_le32(data_block_size);
 
 	r = dm_bm_unlock(sblock);
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index cfc7d0b..df290fc 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -11,6 +11,21 @@
 
 #define THIN_METADATA_BLOCK_SIZE 4096
 
+/*
+ * The metadata device is currently limited in size.
+ *
+ * We have one block of index, which can hold 255 index entries.  Each
+ * index entry contains allocation info about 16k metadata blocks.
+ */
+#define METADATA_DEV_MAX_SECTORS (255 * (1 << 14) * (THIN_METADATA_BLOCK_SIZE / (1 << SECTOR_SHIFT)))
+
+/*
+ * Userspace may need to provide a metadata device that is larger than
+ * METADATA_DEV_MAX_SECTORS.  Anything larger than the power of 2 nearest
+ * to METADATA_DEV_MAX_SECTORS will trigger a warning.
+ */
+#define METADATA_DEV_MAX_SECTORS_NEAREST_POWER_OF_2 (16 * (1024 * 1024 * 1024 >> SECTOR_SHIFT))
+
 /*----------------------------------------------------------------*/
 
 struct dm_pool_metadata;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2b1d5bd..d9ea643 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -33,16 +33,6 @@
 #define DATA_DEV_BLOCK_SIZE_MAX_SECTORS (1024 * 1024 * 1024 >> SECTOR_SHIFT)
 
 /*
- * The metadata device is currently limited in size.  The limitation is
- * checked lower down in dm-space-map-metadata, but we also check it here
- * so we can fail early.
- *
- * We have one block of index, which can hold 255 index entries.  Each
- * index entry contains allocation info about 16k metadata blocks.
- */
-#define METADATA_DEV_MAX_SECTORS (255 * (1 << 14) * (THIN_METADATA_BLOCK_SIZE / (1 << SECTOR_SHIFT)))
-
-/*
  * Device id is restricted to 24 bits.
  */
 #define MAX_DEV_ID ((1 << 24) - 1)
@@ -1927,10 +1917,10 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	metadata_dev_size = i_size_read(metadata_dev->bdev->bd_inode) >> SECTOR_SHIFT;
-	if (metadata_dev_size > METADATA_DEV_MAX_SECTORS) {
-		ti->error = "Metadata device is too large";
-		r = -EINVAL;
-		goto out_metadata;
+	if (metadata_dev_size > METADATA_DEV_MAX_SECTORS_NEAREST_POWER_OF_2) {
+		char b[BDEVNAME_SIZE];
+		DMWARN("Metadata device %s is larger than %u sectors, excess space will not be used",
+		       bdevname(metadata_dev->bdev, b), METADATA_DEV_MAX_SECTORS);
 	}
 
 	r = dm_get_device(ti, argv[1], FMODE_READ | FMODE_WRITE, &data_dev);
-- 
1.7.1
