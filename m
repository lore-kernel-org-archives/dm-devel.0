From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] 64-bit fixes
Date: Fri, 28 Jan 2005 16:13:34 +0000
Message-ID: <20050128161334.GD14093@agk.surrey.redhat.com>
References: <20050127205420.GZ14093@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050127205420.GZ14093@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Fixes to dm_div_up / dm_round_up for 64-bit sector_t.
[The previous 2 patches I sent out are also required - 
the sector_t cast in stripe_map() and sector_t stripe_width.]

NOT TESTED YET.

region_size restricted to 32 bits.  [This is the unit of data for mirroring.]

dm_div_up & dm_round_up inlines replaced with macros using sector_div()
where necessary (only in two places now, though stripe_map should use it 
one day for ~100TB stripes).

--- diff/drivers/md/dm-crypt.c	2005-01-12 15:21:22.000000000 +0000
+++ source/drivers/md/dm-crypt.c	2005-01-28 15:30:22.000000000 +0000
@@ -329,7 +329,7 @@
                    struct bio *base_bio, unsigned int *bio_vec_idx)
 {
 	struct bio *bio;
-	unsigned int nr_iovecs = dm_div_up(size, PAGE_SIZE);
+	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
 	unsigned long flags = current->flags;
 	unsigned int i;
--- diff/drivers/md/dm-log.c	2005-01-28 15:26:35.000000000 +0000
+++ source/drivers/md/dm-log.c	2005-01-28 15:31:18.000000000 +0000
@@ -129,7 +129,7 @@
 struct log_c {
 	struct dm_target *ti;
 	int touched;
-	sector_t region_size;
+	uint32_t region_size;
 	unsigned int region_count;
 	region_t sync_count;
 
@@ -292,7 +292,7 @@
 	enum sync sync = DEFAULTSYNC;
 
 	struct log_c *lc;
-	sector_t region_size;
+	uint32_t region_size;
 	unsigned int region_count;
 	size_t bitset_size;
 
@@ -313,12 +313,12 @@
 		}
 	}
 
-	if (sscanf(argv[0], SECTOR_FORMAT, &region_size) != 1) {
+	if (sscanf(argv[0], "%u", &region_size) != 1) {
 		DMWARN("invalid region size string");
 		return -EINVAL;
 	}
 
-	region_count = dm_div_up(ti->len, region_size);
+	region_count = dm_sector_div_up(ti->len, region_size);
 
 	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
 	if (!lc) {
@@ -508,7 +508,7 @@
 	return write_header(lc);
 }
 
-static sector_t core_get_region_size(struct dirty_log *log)
+static uint32_t core_get_region_size(struct dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return lc->region_size;
@@ -616,7 +616,7 @@
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u " SECTOR_FORMAT " ", log->type->name,
+		DMEMIT("%s %u %u ", log->type->name,
 		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
 		DMEMIT_SYNC;
 	}
@@ -637,7 +637,7 @@
 
 	case STATUSTYPE_TABLE:
 		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
-		DMEMIT("%s %u %s " SECTOR_FORMAT " ", log->type->name,
+		DMEMIT("%s %u %s %u ", log->type->name,
 		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
 		       lc->region_size);
 		DMEMIT_SYNC;
--- diff/drivers/md/dm-log.h	2005-01-12 15:21:22.000000000 +0000
+++ source/drivers/md/dm-log.h	2005-01-28 15:30:32.000000000 +0000
@@ -39,7 +39,7 @@
 	 * Retrieves the smallest size of region that the log can
 	 * deal with.
 	 */
-	sector_t (*get_region_size)(struct dirty_log *log);
+	uint32_t (*get_region_size)(struct dirty_log *log);
 
         /*
 	 * A predicate to say whether a region is clean or not.
--- diff/drivers/md/dm-raid1.c	2005-01-28 15:26:59.000000000 +0000
+++ source/drivers/md/dm-raid1.c	2005-01-28 15:31:18.000000000 +0000
@@ -67,7 +67,7 @@
 struct mirror_set;
 struct region_hash {
 	struct mirror_set *ms;
-	sector_t region_size;
+	uint32_t region_size;
 	unsigned region_shift;
 
 	/* holds persistent region state */
@@ -135,7 +135,7 @@
 #define MIN_REGIONS 64
 #define MAX_RECOVERY 1
 static int rh_init(struct region_hash *rh, struct mirror_set *ms,
-		   struct dirty_log *log, sector_t region_size,
+		   struct dirty_log *log, uint32_t region_size,
 		   region_t nr_regions)
 {
 	unsigned int nr_buckets, max_buckets;
@@ -871,7 +871,7 @@
  * Target functions
  *---------------------------------------------------------------*/
 static struct mirror_set *alloc_context(unsigned int nr_mirrors,
-					sector_t region_size,
+					uint32_t region_size,
 					struct dm_target *ti,
 					struct dirty_log *dl)
 {
@@ -894,7 +894,7 @@
 
 	ms->ti = ti;
 	ms->nr_mirrors = nr_mirrors;
-	ms->nr_regions = dm_div_up(ti->len, region_size);
+	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
@@ -916,7 +916,7 @@
 	kfree(ms);
 }
 
-static inline int _check_region_size(struct dm_target *ti, sector_t size)
+static inline int _check_region_size(struct dm_target *ti, uint32_t size)
 {
 	return !(size % (PAGE_SIZE >> 9) || (size & (size - 1)) ||
 		 size > ti->len);
--- diff/drivers/md/dm-table.c	2005-01-28 15:26:59.000000000 +0000
+++ source/drivers/md/dm-table.c	2005-01-28 15:30:22.000000000 +0000
@@ -58,7 +58,7 @@
 /*
  * Similar to ceiling(log_size(n))
  */
-static unsigned int int_log(unsigned long n, unsigned long base)
+static unsigned int int_log(unsigned int n, unsigned int base)
 {
 	int result = 0;
 
--- diff/drivers/md/dm.c	2005-01-28 15:26:59.000000000 +0000
+++ source/drivers/md/dm.c	2005-01-28 15:31:32.000000000 +0000
@@ -331,8 +331,8 @@
 	 */
 	if (ti->split_io) {
 		sector_t boundary;
-		boundary = dm_round_up(offset + 1, ti->split_io) - offset;
-
+		boundary = ((offset + ti->split_io) & ~(ti->split_io - 1))
+			   - offset;
 		if (len > boundary)
 			len = boundary;
 	}
--- diff/drivers/md/dm.h	2005-01-28 15:26:59.000000000 +0000
+++ source/drivers/md/dm.h	2005-01-28 15:31:28.000000000 +0000
@@ -143,21 +143,22 @@
 }
 
 /*
- * ceiling(n / size) * size
+ * Ceiling(n / sz)
  */
-static inline unsigned long dm_round_up(unsigned long n, unsigned long size)
-{
-	unsigned long r = n % size;
-	return n + (r ? (size - r) : 0);
-}
+#define dm_div_up(n, sz) (((n) + (sz) - 1) / (sz))
+
+#define dm_sector_div_up(n, sz) ( \
+{ \
+	sector_t _r = ((n) + (sz) - 1); \
+	sector_div(_r, (sz)); \
+	_r; \
+} \
+)
 
 /*
- * Ceiling(n / size)
+ * ceiling(n / size) * size
  */
-static inline unsigned long dm_div_up(unsigned long n, unsigned long size)
-{
-	return dm_round_up(n, size) / size;
-}
+#define dm_round_up(n, sz) (dm_div_up((n), (sz)) * (sz))
 
 static inline sector_t to_sector(unsigned long n)
 {
--- diff/include/linux/device-mapper.h	2005-01-28 15:26:59.000000000 +0000
+++ source/include/linux/device-mapper.h	2005-01-28 15:46:17.000000000 +0000
@@ -108,6 +108,7 @@
 	sector_t len;
 
 	/* FIXME: turn this into a mask, and merge with io_restrictions */
+	/* Always a power of 2 */
 	sector_t split_io;
 
 	/*

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
