From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 11/14] dm_thin: add pool target flags to control
	discard
Date: Fri, 16 Mar 2012 15:22:34 +0000
Message-ID: <1331911358-8848-11-git-send-email-ejt@redhat.com>
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

You can turn discard support on or off.  Also you can specify whether
the discard gets passed down to the lower layer, or just removes the
mapping within the thinp target.

New, optional pool target flags:
      'ignore_discard': disable discard support
      'no_discard_passdown': don't pass discards down to the underlying data device

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |    2 +
 drivers/md/dm-thin.c                              |   78 +++++++++++++++------
 2 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 0fc0b0f..c33bf28 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -222,6 +222,8 @@ i) Constructor
 
     Optional feature arguments:
     - 'skip_block_zeroing': skips the zeroing of newly-provisioned blocks.
+      'ignore_discard': disable discard support
+      'no_discard_passdown': don't pass discards down to the underlying data device
 
     Data block size must be between 64KB (128 sectors) and 1GB
     (2097152 sectors) inclusive.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1691be9..a1b274b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -499,6 +499,13 @@ static void build_virtual_key(struct dm_thin_device *td, dm_block_t b,
  * devices.
  */
 struct new_mapping;
+
+struct pool_features {
+	unsigned zero_new_blocks:1;
+	unsigned discard_enabled:1;
+	unsigned discard_passdown:1;
+};
+
 struct pool {
 	struct list_head list;
 	struct dm_target *ti;	/* Only set if a pool target is bound */
@@ -512,7 +519,7 @@ struct pool {
 	dm_block_t offset_mask;
 	dm_block_t low_water_blocks;
 
-	unsigned zero_new_blocks:1;
+	struct pool_features pf;
 	unsigned low_water_triggered:1;	/* A dm event has been sent */
 	unsigned no_free_space:1;	/* A -ENOSPC warning has been issued */
 
@@ -551,7 +558,7 @@ struct pool_c {
 	struct dm_target_callbacks callbacks;
 
 	dm_block_t low_water_blocks;
-	unsigned zero_new_blocks:1;
+	struct pool_features pf;
 };
 
 /*
@@ -1057,7 +1064,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	 * zeroing pre-existing data, we can issue the bio immediately.
 	 * Otherwise we use kcopyd to zero the data first.
 	 */
-	if (!pool->zero_new_blocks)
+	if (!pool->pf.zero_new_blocks)
 		process_prepared_mapping(m);
 
 	else if (io_overwrites_block(pool, bio)) {
@@ -1605,7 +1612,7 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 
 	pool->ti = ti;
 	pool->low_water_blocks = pt->low_water_blocks;
-	pool->zero_new_blocks = pt->zero_new_blocks;
+	pool->pf = pt->pf;
 
 	return 0;
 }
@@ -1619,6 +1626,14 @@ static void unbind_control_target(struct pool *pool, struct dm_target *ti)
 /*----------------------------------------------------------------
  * Pool creation
  *--------------------------------------------------------------*/
+/* Initialize pool features. */
+static void pool_features_init(struct pool_features *pf)
+{
+	pf->zero_new_blocks = 1;
+	pf->discard_enabled = 1;
+	pf->discard_passdown = 1;
+}
+
 static void __pool_destroy(struct pool *pool)
 {
 	__pool_table_remove(pool);
@@ -1666,7 +1681,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->block_shift = ffs(block_size) - 1;
 	pool->offset_mask = block_size - 1;
 	pool->low_water_blocks = 0;
-	pool->zero_new_blocks = 1;
+	pool_features_init(&pool->pf);
 	pool->prison = prison_create(PRISON_CELLS);
 	if (!pool->prison) {
 		*error = "Error creating pool's bio prison";
@@ -1802,10 +1817,6 @@ static void pool_dtr(struct dm_target *ti)
 	mutex_unlock(&dm_thin_pool_table.mutex);
 }
 
-struct pool_features {
-	unsigned zero_new_blocks:1;
-};
-
 static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 			       struct dm_target *ti)
 {
@@ -1814,7 +1825,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 1, "Invalid number of pool feature arguments"},
+		{0, 3, "Invalid number of pool feature arguments"},
 	};
 
 	/*
@@ -1834,6 +1845,12 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 		if (!strcasecmp(arg_name, "skip_block_zeroing")) {
 			pf->zero_new_blocks = 0;
 			continue;
+		} else if (!strcasecmp(arg_name, "ignore_discard")) {
+			pf->discard_enabled = 0;
+			continue;
+		} else if (!strcasecmp(arg_name, "no_discard_passdown")) {
+			pf->discard_passdown = 0;
+			continue;
 		}
 
 		ti->error = "Unrecognised pool feature requested";
@@ -1851,6 +1868,8 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
  *
  * Optional feature arguments are:
  *	     skip_block_zeroing: skips the zeroing of newly-provisioned blocks.
+ *           ignore_discard: disable discard
+ *           no_discard_passdown: don't pass discards down to the data device
  */
 static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -1915,8 +1934,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	/*
 	 * Set default pool features.
 	 */
-	memset(&pf, 0, sizeof(pf));
-	pf.zero_new_blocks = 1;
+	pool_features_init(&pf);
 
 	dm_consume_args(&as, 4);
 	r = parse_pool_features(&as, &pf, ti);
@@ -1941,10 +1959,12 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->metadata_dev = metadata_dev;
 	pt->data_dev = data_dev;
 	pt->low_water_blocks = low_water_blocks;
-	pt->zero_new_blocks = pf.zero_new_blocks;
+	pt->pf = pf;
 	ti->num_flush_requests = 1;
-	ti->num_discard_requests = 1;
-	ti->discards_supported = 1;
+	if (pf.discard_enabled && pf.discard_passdown) {
+		ti->discards_supported = 1;
+		ti->num_discard_requests = 1;
+	}
 	ti->private = pt;
 
 	pt->callbacks.congested_fn = pool_is_congested;
@@ -2241,7 +2261,7 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 static int pool_status(struct dm_target *ti, status_type_t type,
 		       char *result, unsigned maxlen)
 {
-	int r;
+	int r, count;
 	unsigned sz = 0;
 	uint64_t transaction_id;
 	dm_block_t nr_free_blocks_data;
@@ -2304,10 +2324,18 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		       (unsigned long)pool->sectors_per_block,
 		       (unsigned long long)pt->low_water_blocks);
 
-		DMEMIT("%u ", !pool->zero_new_blocks);
+		count = !pool->pf.zero_new_blocks + !pool->pf.discard_enabled + !pool->pf.discard_passdown;
+		DMEMIT("%u ", count);
 
-		if (!pool->zero_new_blocks)
+		if (!pool->pf.zero_new_blocks)
 			DMEMIT("skip_block_zeroing ");
+
+		if (!pool->pf.discard_enabled)
+			DMEMIT("skip_discard ");
+
+		if (!pool->pf.discard_passdown)
+			DMEMIT("skip_discard_passdown");
+
 		break;
 	}
 
@@ -2345,6 +2373,7 @@ static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
 	 * bios that overlap 2 blocks.
 	 */
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
+	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
@@ -2354,7 +2383,8 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	blk_limits_io_min(limits, 0);
 	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
-	set_discard_limits(pool, limits);
+	if (pool->pf.discard_enabled)
+		set_discard_limits(pool, limits);
 }
 
 static struct target_type pool_target = {
@@ -2403,6 +2433,8 @@ static void thin_dtr(struct dm_target *ti)
  * pool_dev: the path to the pool (eg, /dev/mapper/my_pool)
  * dev_id: the internal device identifier
  * origin_dev: a device external to the pool that should act as the origin
+ *
+ * If the pool has discards disabled, they get disabled for the thin as well.
  */
 static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -2471,8 +2503,12 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	ti->split_io = tc->pool->sectors_per_block;
 	ti->num_flush_requests = 1;
-	ti->num_discard_requests = 1;
-	ti->discards_supported = 1;
+
+	/* In case the pool supports discards, pass them on. */
+	if (tc->pool->pf.discard_enabled) {
+		ti->discards_supported = 1;
+		ti->num_discard_requests = 1;
+	}
 
 	dm_put(pool_md);
 
-- 
1.7.9.1
