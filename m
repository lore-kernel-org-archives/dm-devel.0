From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] dm-zoned: use array for superblock zones
Date: Fri, 27 Mar 2020 08:14:57 +0100
Message-ID: <20200327071459.67796-3-hare@suse.de>
References: <20200327071459.67796-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327071459.67796-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of storing just the first superblock zone and calculate
the secondary relative to that we should be using an array for
holding the superblock zones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index afce594067fb..dc1d17bc3bbb 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -124,6 +124,7 @@ struct dmz_sb {
 	sector_t		block;
 	struct dmz_mblock	*mblk;
 	struct dmz_super	*sb;
+	struct dm_zone		*zone;
 };
 
 /*
@@ -150,7 +151,6 @@ struct dmz_metadata {
 	/* Zone information array */
 	struct dm_zone		*zones;
 
-	struct dm_zone		*sb_zone;
 	struct dmz_sb		sb[2];
 	unsigned int		mblk_primary;
 	u64			sb_gen;
@@ -937,16 +937,20 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
 
 	/* Bad first super block: search for the second one */
 	zmd->sb[1].block = zmd->sb[0].block + zone_nr_blocks;
+	zmd->sb[1].zone = zmd->sb[0].zone + 1;
 	for (i = 0; i < zmd->nr_rnd_zones - 1; i++) {
 		if (dmz_read_sb(zmd, 1) != 0)
 			break;
-		if (le32_to_cpu(zmd->sb[1].sb->magic) == DMZ_MAGIC)
+		if (le32_to_cpu(zmd->sb[1].sb->magic) == DMZ_MAGIC) {
+			zmd->sb[1].zone += i;
 			return 0;
+		}
 		zmd->sb[1].block += zone_nr_blocks;
 	}
 
 	dmz_free_mblock(zmd, mblk);
 	zmd->sb[1].mblk = NULL;
+	zmd->sb[1].zone = NULL;
 
 	return -EIO;
 }
@@ -990,11 +994,9 @@ static int dmz_recover_mblocks(struct dmz_metadata *zmd, unsigned int dst_set)
 	dmz_dev_warn(zmd->dev, "Metadata set %u invalid: recovering", dst_set);
 
 	if (dst_set == 0)
-		zmd->sb[0].block = dmz_start_block(zmd, zmd->sb_zone);
-	else {
-		zmd->sb[1].block = zmd->sb[0].block +
-			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);
-	}
+		zmd->sb[0].block = dmz_start_block(zmd, zmd->sb[0].zone);
+	else
+		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
 
 	page = alloc_page(GFP_NOIO);
 	if (!page)
@@ -1038,8 +1040,13 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 	u64 sb_gen[2] = {0, 0};
 	int ret;
 
+	if (!zmd->sb[0].zone) {
+		dmz_dev_err(zmd->dev, "Primary super block zone not set");
+		return -ENXIO;
+	}
+
 	/* Read and check the primary super block */
-	zmd->sb[0].block = dmz_start_block(zmd, zmd->sb_zone);
+	zmd->sb[0].block = dmz_start_block(zmd, zmd->sb[0].zone);
 	ret = dmz_get_sb(zmd, 0);
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Read primary super block failed");
@@ -1051,8 +1058,9 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 	/* Read and check secondary super block */
 	if (ret == 0) {
 		sb_good[0] = true;
-		zmd->sb[1].block = zmd->sb[0].block +
-			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);
+		if (!zmd->sb[1].zone)
+			zmd->sb[1].zone = zmd->sb[0].zone + zmd->nr_meta_zones;
+		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
 		ret = dmz_get_sb(zmd, 1);
 	} else
 		ret = dmz_lookup_secondary_sb(zmd);
@@ -1147,9 +1155,9 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 		zmd->nr_useable_zones++;
 		if (dmz_is_rnd(zone)) {
 			zmd->nr_rnd_zones++;
-			if (!zmd->sb_zone) {
+			if (!zmd->sb[0].zone) {
 				/* Super block zone */
-				zmd->sb_zone = zone;
+				zmd->sb[0].zone = zone;
 			}
 		}
 	}
@@ -2420,7 +2428,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 		goto err;
 
 	/* Set metadata zones starting from sb_zone */
-	zid = dmz_id(zmd, zmd->sb_zone);
+	zid = dmz_id(zmd, zmd->sb[0].zone);
 	for (i = 0; i < zmd->nr_meta_zones << 1; i++) {
 		zone = dmz_get(zmd, zid + i);
 		if (!dmz_is_rnd(zone))
-- 
2.16.4
