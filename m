From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 3/4] dm unstriped: rename symbols to conform to
	target name
Date: Thu,  1 Feb 2018 19:06:11 +0100
Message-ID: <04aeb5e9574c6dd402c3a492690043d19fc172e6.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Rename all "unstripe_" symbol substrings to "unstriped_".

Rename 'struct unstriped_c' member 'unstripe' to
more meaningful 'unstriped_idx'

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-unstripe.c | 76 ++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 790b534c67d8..c1eddd1f7972 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -14,15 +14,15 @@
 #include <linux/bitops.h>
 #include <linux/device-mapper.h>
 
-struct unstripe_c {
+struct unstriped_c {
 	struct dm_dev *dev;
 	sector_t physical_start;
 
 	uint32_t stripes;
 
-	uint32_t unstripe;
-	sector_t unstripe_width;
-	sector_t unstripe_offset;
+	uint32_t unstriped_idx;
+	sector_t unstriped_width;
+	sector_t unstriped_offset;
 
 	uint32_t chunk_size;
 	u8 chunk_shift;
@@ -30,7 +30,7 @@ struct unstripe_c {
 
 #define DM_MSG_PREFIX "unstriped"
 
-static void cleanup_unstripe(struct unstripe_c *uc, struct dm_target *ti)
+static void cleanup_unstripe(struct unstriped_c *uc, struct dm_target *ti)
 {
 	if (uc->dev)
 		dm_put_device(ti, uc->dev);
@@ -41,9 +41,9 @@ static void cleanup_unstripe(struct unstripe_c *uc, struct dm_target *ti)
  * Contruct an unstriped mapping.
  * <number of stripes> <chunk size> <stripe #> <dev_path> <offset>
  */
-static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+static int unstriped_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	struct unstripe_c *uc;
+	struct unstriped_c *uc;
 	sector_t tmp_len;
 	unsigned long long start;
 	char dummy;
@@ -69,12 +69,12 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	if (kstrtouint(argv[2], 10, &uc->unstripe)) {
+	if (kstrtouint(argv[2], 10, &uc->unstriped_idx)) {
 		ti->error = "Invalid stripe number";
 		goto err;
 	}
 
-	if (uc->unstripe > uc->stripes && uc->stripes > 1) {
+	if (uc->unstriped_idx > uc->stripes && uc->stripes > 1) {
 		ti->error = "Please provide stripe between [0, # of stripes]";
 		goto err;
 	}
@@ -90,8 +90,8 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	uc->physical_start = start;
 
-	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
-	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
+	uc->unstriped_offset = uc->unstriped_idx * uc->chunk_size;
+	uc->unstriped_width = (uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;
@@ -112,16 +112,16 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return -EINVAL;
 }
 
-static void unstripe_dtr(struct dm_target *ti)
+static void unstriped_dtr(struct dm_target *ti)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 
 	cleanup_unstripe(uc, ti);
 }
 
 static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 	sector_t sector = bio->bi_iter.bi_sector;
 	sector_t tmp_sector = sector;
 
@@ -131,15 +131,15 @@ static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 	else
 		sector_div(tmp_sector, uc->chunk_size);
 
-	sector += uc->unstripe_width * tmp_sector;
+	sector += uc->unstriped_width * tmp_sector;
 
 	/* Account for what stripe we're operating on */
-	return sector + uc->unstripe_offset;
+	return sector + uc->unstriped_offset;
 }
 
-static int unstripe_map(struct dm_target *ti, struct bio *bio)
+static int unstriped_map(struct dm_target *ti, struct bio *bio)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 
 	bio_set_dev(bio, uc->dev->bdev);
 	bio->bi_iter.bi_sector = map_to_core(ti, bio) + uc->physical_start;
@@ -147,10 +147,10 @@ static int unstripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static void unstripe_status(struct dm_target *ti, status_type_t type,
+static void unstriped_status(struct dm_target *ti, status_type_t type,
 			    unsigned int status_flags, char *result, unsigned int maxlen)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 	unsigned int sz = 0;
 
 	switch (type) {
@@ -159,52 +159,52 @@ static void unstripe_status(struct dm_target *ti, status_type_t type,
 
 	case STATUSTYPE_TABLE:
 		DMEMIT("%d %llu %d %s %llu",
-		       uc->stripes, (unsigned long long)uc->chunk_size, uc->unstripe,
+		       uc->stripes, (unsigned long long)uc->chunk_size, uc->unstriped_idx,
 		       uc->dev->name, (unsigned long long)uc->physical_start);
 		break;
 	}
 }
 
-static int unstripe_iterate_devices(struct dm_target *ti,
+static int unstriped_iterate_devices(struct dm_target *ti,
 				    iterate_devices_callout_fn fn, void *data)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 
 	return fn(ti, uc->dev, uc->physical_start, ti->len, data);
 }
 
-static void unstripe_io_hints(struct dm_target *ti,
+static void unstriped_io_hints(struct dm_target *ti,
 			       struct queue_limits *limits)
 {
-	struct unstripe_c *uc = ti->private;
+	struct unstriped_c *uc = ti->private;
 
 	limits->chunk_sectors = uc->chunk_size;
 }
 
-static struct target_type unstripe_target = {
+static struct target_type unstriped_target = {
 	.name = "unstriped",
 	.version = {1, 0, 1},
 	.module = THIS_MODULE,
-	.ctr = unstripe_ctr,
-	.dtr = unstripe_dtr,
-	.map = unstripe_map,
-	.status = unstripe_status,
-	.iterate_devices = unstripe_iterate_devices,
-	.io_hints = unstripe_io_hints,
+	.ctr = unstriped_ctr,
+	.dtr = unstriped_dtr,
+	.map = unstriped_map,
+	.status = unstriped_status,
+	.iterate_devices = unstriped_iterate_devices,
+	.io_hints = unstriped_io_hints,
 };
 
-static int __init dm_unstripe_init(void)
+static int __init dm_unstriped_init(void)
 {
-	return dm_register_target(&unstripe_target);
+	return dm_register_target(&unstriped_target);
 }
 
-static void __exit dm_unstripe_exit(void)
+static void __exit dm_unstriped_exit(void)
 {
-	dm_unregister_target(&unstripe_target);
+	dm_unregister_target(&unstriped_target);
 }
 
-module_init(dm_unstripe_init);
-module_exit(dm_unstripe_exit);
+module_init(dm_unstriped_init);
+module_exit(dm_unstriped_exit);
 
 MODULE_DESCRIPTION(DM_NAME " unstriped target");
 MODULE_ALIAS("dm-unstriped");
-- 
2.14.3
