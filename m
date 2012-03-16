From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 08/14] dm_thin: add support for read-only
	external snapshot origins
Date: Fri, 16 Mar 2012 15:22:31 +0000
Message-ID: <1331911358-8848-8-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Enhancement.

You can use an external, _read only_, device as an origin for a thin
device.  Any read to an unprovisioned area of the thin device will be
passed through to the origin.  Writes trigger allocation of new blocks
as usual.

One possible use case for this would be VM hosts who want to run
guests on thinp volumes, but have the base image on another device
(possibly shared between many VMs).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |   38 +++++++++-
 drivers/md/dm-thin.c                              |   84 +++++++++++++++++---
 2 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 981aebb..0fc0b0f 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -167,6 +167,38 @@ ii) Using an internal snapshot.
 
     dmsetup create snap --table "0 2097152 thin /dev/mapper/pool 1"
 
+External snapshots
+------------------
+
+You can use an external, _read only_, device as an origin for a thin
+device.  Any read to an unprovisioned area of the thin device will be
+passed through to the origin.  Writes trigger allocation of new blocks
+as usual.
+
+One possible use case for this would be VM hosts who want to run
+guests on thinp volumes, but have the base image on another device
+(possibly shared between many VMs).
+
+You must not write to the origin device if you use this technique!  Of
+course you can write to the thin device, and take internal snapshots
+of the thin.
+
+i) Creating an external snapshot
+
+  Same as creating a thin device.  You don't need to mention the
+  origin at this stage.
+
+    dmsetup message /dev/mapper/pool 0 "create_thin 0"
+
+ii) Using an external snapshot.
+
+  Add an extra parameter to the thin target specifying the origin:
+
+    dmsetup create snap --table "0 2097152 thin /dev/mapper/pool 0 /dev/image"
+
+  All descendants (internal snapshots) of an external snapshot will
+  need the extra origin argument.
+
 Deactivation
 ------------
 
@@ -252,7 +284,7 @@ iii) Messages
 
 i) Constructor
 
-    thin <pool dev> <dev id>
+    thin <pool dev> <dev id> [external origin id]
 
     pool dev:
 	the thin-pool device, e.g. /dev/mapper/my_pool or 253:0
@@ -261,6 +293,10 @@ i) Constructor
 	the internal device identifier of the device to be
 	activated.
 
+    external origin dev:
+        a block device; reads to unprovisioned areas of the thin target
+        will be mapped to here.
+
 The pool doesn't store any size against the thin devices.  If you
 load a thin target that is smaller than you've been using previously,
 then you'll have no access to blocks mapped beyond the end.  If you
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2620a13..4b57e69 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -557,6 +557,7 @@ struct pool_c {
  */
 struct thin_c {
 	struct dm_dev *pool_dev;
+	struct dm_dev *origin_dev;
 	dm_thin_id dev_id;
 
 	struct pool *pool;
@@ -674,14 +675,16 @@ static void remap(struct thin_c *tc, struct bio *bio, dm_block_t block)
 		(bio->bi_sector & pool->offset_mask);
 }
 
-static void remap_and_issue(struct thin_c *tc, struct bio *bio,
-			    dm_block_t block)
+static void remap_to_origin(struct thin_c *tc, struct bio *bio)
+{
+	bio->bi_bdev = tc->origin_dev->bdev;
+}
+
+static void issue(struct thin_c *tc, struct bio *bio)
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
-	remap(tc, bio, block);
-
 	/*
 	 * Batch together any FUA/FLUSH bios we find and then issue
 	 * a single commit for them in process_deferred_bios().
@@ -694,6 +697,19 @@ static void remap_and_issue(struct thin_c *tc, struct bio *bio,
 		generic_make_request(bio);
 }
 
+static void remap_to_origin_and_issue(struct thin_c *tc, struct bio *bio)
+{
+	remap_to_origin(tc, bio);
+	issue(tc, bio);
+}
+
+static void remap_and_issue(struct thin_c *tc, struct bio *bio,
+			    dm_block_t block)
+{
+	remap(tc, bio, block);
+	issue(tc, bio);
+}
+
 /*
  * wake_worker() is used when new work is queued and when pool_resume is
  * ready to continue deferred IO processing.
@@ -940,7 +956,8 @@ static struct new_mapping *get_next_mapping(struct pool *pool)
 }
 
 static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
-			  dm_block_t data_origin, dm_block_t data_dest,
+			  struct dm_dev *origin, dm_block_t data_origin,
+			  dm_block_t data_dest,
 			  struct cell *cell, struct bio *bio)
 {
 	int r;
@@ -972,7 +989,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	} else {
 		struct dm_io_region from, to;
 
-		from.bdev = tc->pool_dev->bdev;
+		from.bdev = origin->bdev;
 		from.sector = data_origin * pool->sectors_per_block;
 		from.count = pool->sectors_per_block;
 
@@ -990,6 +1007,22 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	}
 }
 
+static void schedule_internal_copy(struct thin_c *tc, dm_block_t virt_block,
+				   dm_block_t data_origin, dm_block_t data_dest,
+				   struct cell *cell, struct bio *bio)
+{
+	schedule_copy(tc, virt_block, tc->pool_dev,
+		      data_origin, data_dest, cell, bio);
+}
+
+static void schedule_external_copy(struct thin_c *tc, dm_block_t virt_block,
+				   dm_block_t data_dest,
+				   struct cell *cell, struct bio *bio)
+{
+	schedule_copy(tc, virt_block, tc->origin_dev,
+		      virt_block, data_dest, cell, bio);
+}
+
 static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 			  dm_block_t data_block, struct cell *cell,
 			  struct bio *bio)
@@ -1136,8 +1169,8 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 	r = alloc_data_block(tc, &data_block);
 	switch (r) {
 	case 0:
-		schedule_copy(tc, block, lookup_result->block,
-			      data_block, cell, bio);
+		schedule_internal_copy(tc, block, lookup_result->block,
+				       data_block, cell, bio);
 		break;
 
 	case -ENOSPC:
@@ -1211,7 +1244,10 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	r = alloc_data_block(tc, &data_block);
 	switch (r) {
 	case 0:
-		schedule_zero(tc, block, data_block, cell, bio);
+		if (tc->origin_dev)
+			schedule_external_copy(tc, block, data_block, cell, bio);
+		else
+			schedule_zero(tc, block, data_block, cell, bio);
 		break;
 
 	case -ENOSPC:
@@ -1262,7 +1298,11 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 		break;
 
 	case -ENODATA:
-		provision_block(tc, bio, block, cell);
+		if (bio_data_dir(bio) == READ && tc->origin_dev) {
+			cell_release_singleton(cell, bio);
+			remap_to_origin_and_issue(tc, bio);
+		} else
+			provision_block(tc, bio, block, cell);
 		break;
 
 	default:
@@ -2225,6 +2265,8 @@ static void thin_dtr(struct dm_target *ti)
 	__pool_dec(tc->pool);
 	dm_pool_close_thin_device(tc->td);
 	dm_put_device(ti, tc->pool_dev);
+	if (tc->origin_dev)
+		dm_put_device(ti, tc->origin_dev);
 	kfree(tc);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -2233,21 +2275,22 @@ static void thin_dtr(struct dm_target *ti)
 /*
  * Thin target parameters:
  *
- * <pool_dev> <dev_id>
+ * <pool_dev> <dev_id> [origin_dev]
  *
  * pool_dev: the path to the pool (eg, /dev/mapper/my_pool)
  * dev_id: the internal device identifier
+ * origin_dev: a device external to the pool that should act as the origin
  */
 static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r;
 	struct thin_c *tc;
-	struct dm_dev *pool_dev;
+	struct dm_dev *pool_dev, *origin_dev;
 	struct mapped_device *pool_md;
 
 	mutex_lock(&dm_thin_pool_table.mutex);
 
-	if (argc != 2) {
+	if (argc != 2 && argc != 3) {
 		ti->error = "Invalid argument count";
 		r = -EINVAL;
 		goto out_unlock;
@@ -2260,6 +2303,15 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out_unlock;
 	}
 
+	if (argc == 3) {
+		r = dm_get_device(ti, argv[2], FMODE_READ, &origin_dev);
+		if (r) {
+			ti->error = "Error opening origin device";
+			goto bad_origin_dev;
+		}
+		tc->origin_dev = origin_dev;
+	}
+
 	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &pool_dev);
 	if (r) {
 		ti->error = "Error opening pool device";
@@ -2312,6 +2364,9 @@ bad_pool_lookup:
 bad_common:
 	dm_put_device(ti, tc->pool_dev);
 bad_pool_dev:
+	if (tc->origin_dev)
+		dm_put_device(ti, tc->origin_dev);
+bad_origin_dev:
 	kfree(tc);
 out_unlock:
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -2343,6 +2398,7 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 	ssize_t sz = 0;
 	dm_block_t mapped, highest;
 	char buf[BDEVNAME_SIZE];
+	char buf2[BDEVNAME_SIZE];
 	struct thin_c *tc = ti->private;
 
 	if (!tc->td)
@@ -2370,6 +2426,8 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("%s %lu",
 			       format_dev_t(buf, tc->pool_dev->bdev->bd_dev),
 			       (unsigned long) tc->dev_id);
+			if (tc->origin_dev)
+				DMEMIT(" %s", format_dev_t(buf2, tc->origin_dev->bdev->bd_dev));
 			break;
 		}
 	}
-- 
1.7.9.1
