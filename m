From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] dm thin: add blocks_per_allocation feature
Date: Thu, 16 Jan 2014 21:12:45 -0500
Message-ID: <20140117021244.GA32673@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Allow user to provision multiple blocks rather than an individual block
when a given block needs to be allocated from the pool.  This larger
allocation unit is controlled with the 'blocks_per_allocation' feature.

After hacking device-mapper-test-suite support for blocks_per_allocation
the bulk of the tests pass.  The few that are failing are due to
expecting fewer blocks than are currently allocated (due to increased
block allocation).

I haven't written tests that try to showcase performance gains for
certain workloads (e.g. reads after write).  Before I do so I want to
make sure I'm not missing something fundamental (which I likely am).

There are a few FIXMEs in the new alloc_data_blocks() method that I
could really use your insight on.  Your review of my use of the
bio-prison code in alloc_data_blocks() would be especially appreciated.

Also, I'm hooking alloc_data_block() to perform the extra
'blocks_per_allocation' -- it calls alloc_data_blocks().  This seems
right for non-snapshot use-cases but it runs counter to the original
goal you had to effectively have 2 allocation units: 1) thinp allocation
blocksize 2) snapshot blocksize. break_sharing() also uses
alloc_data_block(): should it not be allowed to do multiple block
allocations?

---
 drivers/md/dm-thin.c |  168 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 150 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 726228b..cbe61ff 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -145,6 +145,8 @@ struct pool_features {
 	bool discard_enabled:1;
 	bool discard_passdown:1;
 	bool error_if_no_space:1;
+
+	dm_block_t blocks_per_allocation;
 };
 
 struct thin_c;
@@ -619,6 +621,23 @@ static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 	mempool_free(m, m->tc->pool->mapping_pool);
 }
 
+static int commit_prepared_block(struct thin_c *tc,
+				 dm_block_t virt_block, dm_block_t data_block)
+{
+	int r;
+
+	/*
+	 * Commit the prepared block into the mapping btree.
+	 * Any I/O for this block arriving after this point will get
+	 * remapped to it directly.
+	 */
+	r = dm_thin_insert_block(tc->td, virt_block, data_block);
+	if (r)
+		metadata_operation_failed(tc->pool, "dm_thin_insert_block", r);
+
+	return r;
+}
+
 static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
@@ -635,14 +654,8 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 		goto out;
 	}
 
-	/*
-	 * Commit the prepared block into the mapping btree.
-	 * Any I/O for this block arriving after this point will get
-	 * remapped to it directly.
-	 */
-	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
+	r = commit_prepared_block(tc, m->virt_block, m->data_block);
 	if (r) {
-		metadata_operation_failed(pool, "dm_thin_insert_block", r);
 		cell_error(pool, m->cell);
 		goto out;
 	}
@@ -919,7 +932,91 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 	}
 }
 
-static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
+static dm_block_t get_first_allocation_group_aligned_block(dm_block_t virt_block, struct pool *pool)
+{
+	if (pool->pf.blocks_per_allocation == 1)
+		return virt_block;
+
+	/* FIXME: improve efficiency here */
+	(void) sector_div(virt_block, pool->pf.blocks_per_allocation);
+	return virt_block * pool->pf.blocks_per_allocation;
+}
+
+static int alloc_data_blocks(struct thin_c *tc, dm_block_t bio_virt_block, dm_block_t *result)
+{
+	int r;
+	dm_block_t first_virt_block, last_virt_block, virt_block, data_block;
+	struct pool *pool = tc->pool;
+	struct dm_cell_key key;
+	struct dm_thin_lookup_result lookup_result;
+
+	/*
+	 * FIXME: should a new per-pool (or per-thin-dev?) multi-block mutex be used
+	 * to limit the potential to interleave simulateous multi-block allocations?
+	 */
+
+	first_virt_block = get_first_allocation_group_aligned_block(bio_virt_block, pool);
+	last_virt_block = first_virt_block + pool->pf.blocks_per_allocation - 1;
+
+	/*
+	 * Important to allocate data_blocks in-order, to have contiguous allocation
+	 * from pool, e.g.: <bio-less blocks> <bio-full block> <more bio-less blocks>
+	 */
+	for (virt_block = first_virt_block; virt_block <= last_virt_block; virt_block++) {
+		struct dm_bio_prison_cell *cell = NULL;
+
+		/*
+		 * Must lock bio-less virt_block(s) in a cell for this thin device;
+		 * the caller already has the bio-full @bio_virt_block locked in a cell.
+		 */
+		if (virt_block != bio_virt_block) {
+			build_virtual_key(tc->td, virt_block, &key);
+			if (bio_detain(pool, &key, NULL, &cell))
+				continue; /* data block is already being allocated */
+
+			/*
+			 *  FIXME: if cell->holder is NULL then process_bio() must know to
+			 *  handle that case.. otherwise process_bio's "nothing further
+			 *  to do here" case when cell is already occupied will break!?
+			 *  - or does cell release already handle cell->holder = NULL
+			 *    but non-holder bios existing as inmates?
+			 */
+
+			r = dm_thin_find_block(tc->td, virt_block, 1, &lookup_result);
+			if (r != -ENODATA) {
+				cell_defer(tc, cell);
+				continue; /* data block already exists */
+			}
+		}
+
+		r = dm_pool_alloc_data_block(pool->pmd, &data_block);
+		if (r) {
+			metadata_operation_failed(pool, "dm_pool_alloc_data_block", r);
+			if (cell)
+				cell_error(pool, cell);
+			return r;
+		}
+
+		if (virt_block == bio_virt_block) {
+			/* process_prepared_mapping() will save data_block to mapping btree */
+			*result = data_block;
+			continue;
+		}
+
+		/* Must commit preallocated data_block to the thin device's mapping btree */
+		r = commit_prepared_block(tc, virt_block, data_block);
+		if (r) {
+			cell_error(pool, cell);
+			return r;
+		}
+
+		cell_defer(tc, cell);
+	}
+
+	return 0;
+}
+
+static int alloc_data_block(struct thin_c *tc, dm_block_t bio_virt_block, dm_block_t *result)
 {
 	int r;
 	dm_block_t free_blocks;
@@ -957,6 +1054,9 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 		}
 	}
 
+	if (pool->pf.blocks_per_allocation > 1)
+		return alloc_data_blocks(tc, bio_virt_block, result);
+
 	r = dm_pool_alloc_data_block(pool->pmd, result);
 	if (r) {
 		metadata_operation_failed(pool, "dm_pool_alloc_data_block", r);
@@ -1101,7 +1201,7 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 	dm_block_t data_block;
 	struct pool *pool = tc->pool;
 
-	r = alloc_data_block(tc, &data_block);
+	r = alloc_data_block(tc, block, &data_block);
 	switch (r) {
 	case 0:
 		schedule_internal_copy(tc, block, lookup_result->block,
@@ -1177,7 +1277,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 		return;
 	}
 
-	r = alloc_data_block(tc, &data_block);
+	r = alloc_data_block(tc, block, &data_block);
 	switch (r) {
 	case 0:
 		if (tc->origin_dev)
@@ -1726,6 +1826,8 @@ static void pool_features_init(struct pool_features *pf)
 	pf->discard_enabled = true;
 	pf->discard_passdown = true;
 	pf->error_if_no_space = false;
+
+	pf->blocks_per_allocation = 1;
 }
 
 static void __pool_destroy(struct pool *pool)
@@ -1941,7 +2043,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 6, "Invalid number of pool feature arguments"},
 	};
 
 	/*
@@ -1973,6 +2075,20 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 		else if (!strcasecmp(arg_name, "error_if_no_space"))
 			pf->error_if_no_space = true;
 
+		else if (!strcasecmp(arg_name, "blocks_per_allocation")) {
+			dm_block_t allocation_blocks;
+			arg_name = dm_shift_arg(as);
+			argc--;
+
+			if (kstrtoull(arg_name, 10, (unsigned long long *)&allocation_blocks)) {
+				ti->error = "Invalid blocks_per_allocation value";
+				r = -EINVAL;
+				break;
+			}
+
+			pf->blocks_per_allocation = allocation_blocks;
+		}
+
 		else {
 			ti->error = "Unrecognised pool feature requested";
 			r = -EINVAL;
@@ -2045,6 +2161,7 @@ static dm_block_t calc_metadata_threshold(struct pool_c *pt)
  *	     no_discard_passdown: don't pass discards down to the data device
  *	     read_only: Don't allow any changes to be made to the pool metadata.
  *	     error_if_no_space: error IOs, instead of queueing, if no space.
+ *	     blocks_per_allocation <blocks>: provision multiple blocks at once.
  */
 static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -2214,17 +2331,27 @@ static int pool_map(struct dm_target *ti, struct bio *bio)
 	return r;
 }
 
+static dm_block_t pool_data_device_size(struct pool *pool, sector_t table_length)
+{
+	dm_block_t blocks = table_length;
+
+	/* round length to a blocks_per_allocation multiple */
+	(void) dm_sector_div64(blocks, pool->sectors_per_block * pool->pf.blocks_per_allocation);
+	blocks *= pool->pf.blocks_per_allocation;
+
+	return blocks;
+}
+
 static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
 {
 	int r;
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
-	sector_t data_size = ti->len;
-	dm_block_t sb_data_size;
+	dm_block_t data_size, sb_data_size;
 
 	*need_commit = false;
 
-	(void) sector_div(data_size, pool->sectors_per_block);
+	data_size = pool_data_device_size(pool, ti->len);
 
 	r = dm_pool_get_data_dev_size(pool->pmd, &sb_data_size);
 	if (r) {
@@ -2562,7 +2689,7 @@ static void emit_flags(struct pool_features *pf, char *result,
 {
 	unsigned count = !pf->zero_new_blocks + !pf->discard_enabled +
 		!pf->discard_passdown + (pf->mode == PM_READ_ONLY) +
-		pf->error_if_no_space;
+		pf->error_if_no_space + 2*(pf->blocks_per_allocation > 1);
 	DMEMIT("%u ", count);
 
 	if (!pf->zero_new_blocks)
@@ -2579,6 +2706,9 @@ static void emit_flags(struct pool_features *pf, char *result,
 
 	if (pf->error_if_no_space)
 		DMEMIT("error_if_no_space ");
+
+	if (pf->blocks_per_allocation > 1)
+		DMEMIT("blocks_per_allocation %llu", pf->blocks_per_allocation);
 }
 
 /*
@@ -2684,6 +2814,9 @@ static void pool_status(struct dm_target *ti, status_type_t type,
 		else
 			DMEMIT("queue_if_no_space ");
 
+		if (pool->pf.blocks_per_allocation > 1)
+			DMEMIT("blocks_per_allocation %llu ", pool->pf.blocks_per_allocation);
+
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -3047,7 +3180,7 @@ err:
 static int thin_iterate_devices(struct dm_target *ti,
 				iterate_devices_callout_fn fn, void *data)
 {
-	sector_t blocks;
+	dm_block_t blocks;
 	struct thin_c *tc = ti->private;
 	struct pool *pool = tc->pool;
 
@@ -3058,8 +3191,7 @@ static int thin_iterate_devices(struct dm_target *ti,
 	if (!pool->ti)
 		return 0;	/* nothing is bound */
 
-	blocks = pool->ti->len;
-	(void) sector_div(blocks, pool->sectors_per_block);
+	blocks = pool_data_device_size(pool, pool->ti->len);
 	if (blocks)
 		return fn(ti, tc->pool_dev, 0, pool->sectors_per_block * blocks, data);
 
