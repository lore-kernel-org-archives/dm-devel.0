From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/12] dm-zoned: add metadata pointer to struct
	dmz_dev
Date: Fri, 22 May 2020 17:38:55 +0200
Message-ID: <20200522153901.133375-7-hare@suse.de>
References: <20200522153901.133375-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200522153901.133375-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien LeMoal <damien.lemoal@wdc.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Add a metadata pointer to struct dmz_dev and use it as argument
for blkdev_report_zones() instead of the metadata itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 14 +++++++++-----
 drivers/md/dm-zoned.h          |  7 ++++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 7b6e7404f1e8..73479b4c8bca 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1343,8 +1343,8 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
  */
 static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 {
-	struct dmz_metadata *zmd = data;
-	struct dmz_dev *dev = zmd->nr_devs > 1 ? &zmd->dev[1] : &zmd->dev[0];
+	struct dmz_dev *dev = data;
+	struct dmz_metadata *zmd = dev->metadata;
 	int idx = num + dev->zone_offset;
 	struct dm_zone *zone = kzalloc(sizeof(struct dm_zone), GFP_KERNEL);
 
@@ -1480,8 +1480,12 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 
 	/* Allocate zone array */
 	zmd->nr_zones = 0;
-	for (i = 0; i < zmd->nr_devs; i++)
-		zmd->nr_zones += zmd->dev[i].nr_zones;
+	for (i = 0; i < zmd->nr_devs; i++) {
+		struct dmz_dev *dev = &zmd->dev[i];
+
+		dev->metadata = zmd;
+		zmd->nr_zones += dev->nr_zones;
+	}
 
 	if (!zmd->nr_zones) {
 		DMERR("(%s): No zones found", zmd->devname);
@@ -1516,7 +1520,7 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 	 * first randomly writable zone.
 	 */
 	ret = blkdev_report_zones(zoned_dev->bdev, 0, BLK_ALL_ZONES,
-				  dmz_init_zone, zmd);
+				  dmz_init_zone, zoned_dev);
 	if (ret < 0) {
 		DMDEBUG("(%s): Failed to report zones, error %d",
 			zmd->devname, ret);
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 356b436425e4..dab701893b67 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -45,11 +45,15 @@
 #define dmz_bio_block(bio)	dmz_sect2blk((bio)->bi_iter.bi_sector)
 #define dmz_bio_blocks(bio)	dmz_sect2blk(bio_sectors(bio))
 
+struct dmz_metadata;
+struct dmz_reclaim;
+
 /*
  * Zoned block device information.
  */
 struct dmz_dev {
 	struct block_device	*bdev;
+	struct dmz_metadata	*metadata;
 
 	char			name[BDEVNAME_SIZE];
 	uuid_t			uuid;
@@ -168,9 +172,6 @@ enum {
 #define dmz_dev_debug(dev, format, args...)	\
 	DMDEBUG("(%s): " format, (dev)->name, ## args)
 
-struct dmz_metadata;
-struct dmz_reclaim;
-
 /*
  * Functions defined in dm-zoned-metadata.c
  */
-- 
2.16.4
