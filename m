From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm-table: pass device's length to
	device_area_is_valid
Date: Wed,  1 Jul 2009 14:14:46 -0400
Message-ID: <1246472086-10969-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

The length associated with the specified device must be passed to
device_area_is_valid().

This fixes a regression in the dm-stripe target where the size of the
target (ti->len) was used rather than stripe_width (ti->len/#stripes).
The resulting error was:
device-mapper: table: 254:0: sdb too small for target

The regression appeared in 2.6.31-rc1 via commit:
754c5fc7ebb417b23601a6222a6005cc2e7f2913

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c         |    2 +-
 drivers/md/dm-delay.c         |    4 ++--
 drivers/md/dm-linear.c        |    2 +-
 drivers/md/dm-mpath.c         |    2 +-
 drivers/md/dm-raid1.c         |    2 +-
 drivers/md/dm-stripe.c        |    3 ++-
 drivers/md/dm-table.c         |   10 +++++-----
 include/linux/device-mapper.h |    4 ++--
 8 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9933eb8..c72a8dd 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1318,7 +1318,7 @@ static int crypt_iterate_devices(struct dm_target *ti,
 {
 	struct crypt_config *cc = ti->private;
 
-	return fn(ti, cc->dev, cc->start, data);
+	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
 static struct target_type crypt_target = {
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 4e5b843..ebe7381 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -324,12 +324,12 @@ static int delay_iterate_devices(struct dm_target *ti,
 	struct delay_c *dc = ti->private;
 	int ret = 0;
 
-	ret = fn(ti, dc->dev_read, dc->start_read, data);
+	ret = fn(ti, dc->dev_read, dc->start_read, ti->len, data);
 	if (ret)
 		goto out;
 
 	if (dc->dev_write)
-		ret = fn(ti, dc->dev_write, dc->start_write, data);
+		ret = fn(ti, dc->dev_write, dc->start_write, ti->len, data);
 
 out:
 	return ret;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 9184b6d..82f7d6e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -139,7 +139,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 {
 	struct linear_c *lc = ti->private;
 
-	return fn(ti, lc->dev, lc->start, data);
+	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
 static struct target_type linear_target = {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c70604a..6f0d90d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1453,7 +1453,7 @@ static int multipath_iterate_devices(struct dm_target *ti,
 
 	list_for_each_entry(pg, &m->priority_groups, list) {
 		list_for_each_entry(p, &pg->pgpaths, list) {
-			ret = fn(ti, p->path.dev, ti->begin, data);
+			ret = fn(ti, p->path.dev, ti->begin, ti->len, data);
 			if (ret)
 				goto out;
 		}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ce8868c..8382de3 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1292,7 +1292,7 @@ static int mirror_iterate_devices(struct dm_target *ti,
 
 	for (i = 0; !ret && i < ms->nr_mirrors; i++)
 		ret = fn(ti, ms->mirror[i].dev,
-			 ms->mirror[i].offset, data);
+			 ms->mirror[i].offset, ti->len, data);
 
 	return ret;
 }
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index b240e85..22c2407 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -322,7 +322,8 @@ static int stripe_iterate_devices(struct dm_target *ti,
 
 	do
 		ret = fn(ti, sc->stripe[i].dev,
-			 sc->stripe[i].physical_start, data);
+			 sc->stripe[i].physical_start,
+			 sc->stripe_width, data);
 	while (!ret && ++i < sc->stripes);
 
 	return ret;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2cba557..2a57f77 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -346,7 +346,7 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
  * If possible, this checks an area of a destination device is valid.
  */
 static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
-				sector_t start, void *data)
+				sector_t start, sector_t len, void *data)
 {
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
@@ -359,7 +359,7 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
 	if (!dev_size)
 		return 1;
 
-	if ((start >= dev_size) || (start + ti->len > dev_size)) {
+	if ((start >= dev_size) || (start + len > dev_size)) {
 		DMWARN("%s: %s too small for target",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 		return 0;
@@ -377,11 +377,11 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (ti->len & (logical_block_size_sectors - 1)) {
+	if (len & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: len=%llu not aligned to h/w "
 		       "logical block size %hu of %s",
 		       dm_device_name(ti->table->md),
-		       (unsigned long long)ti->len,
+		       (unsigned long long)len,
 		       limits->logical_block_size, bdevname(bdev, b));
 		return 0;
 	}
@@ -482,7 +482,7 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 
 int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
-			 sector_t start, void *data)
+			 sector_t start, sector_t len, void *data)
 {
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0d63106..655e772 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -84,7 +84,7 @@ typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
 
 typedef int (*iterate_devices_callout_fn) (struct dm_target *ti,
 					   struct dm_dev *dev,
-					   sector_t physical_start,
+					   sector_t start, sector_t len,
 					   void *data);
 
 typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
@@ -104,7 +104,7 @@ void dm_error(const char *message);
  * Combine device limits.
  */
 int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
-			 sector_t start, void *data);
+			 sector_t start, sector_t len, void *data);
 
 struct dm_dev {
 	struct block_device *bdev;
