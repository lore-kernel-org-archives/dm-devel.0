From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 18/20] dm thin: fix pool_preresume
	resize with heavy IO races
Date: Fri, 20 Dec 2013 18:37:31 -0500
Message-ID: <1387582653-13647-19-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Before, when a pool is being resized, on resume the pool's mode was
being immediately set to PM_WRITE and the process_* methods would be set
to the normal writeable operations.  This was occuring before
pool_resume() was able to actually resize either the metadata or data
device and resulted in the resize failing.

Now, the pool is forced to stay in read-only mode if it was already in
read-only mode.  This prevents bouncing the pool's mode and associated
process_* methods and consistently keeps read-only processing in place
until the resize(s) complete.  To achieve this the pool can now be in a
PM_READ_ONLY state but the metadata's is !read_only -- so as to allow
the commit() the follows the resize to take place.  Differentiate
between commit_metadata_superblock() and commit() since different
negative checks apply (but factor out a common __commit that each
calls).

With this patch the resize_io test passes (on fast storage):
 dmtest run --suite thin-provisioning -n /resize_io/

Otherwise, problems like the following 2 examples were seen (again when
testing on really fast PCIe SSD storage):

1)
kernel: device-mapper: thin: 253:2: growing the data device from 2048 to 4096 blocks
kernel: device-mapper: thin: 253:2: reached low water mark for data device: sending event.
kernel: device-mapper: thin: 253:2: no free data space available.
kernel: device-mapper: thin: 253:2: switching pool to read-only mode
kernel: device-mapper: thin: 253:2: switching pool to write mode (from PM_WRITE)
kernel: device-mapper: thin: 253:2: growing the data device from 4096 to 6144 blocks
kernel: device-mapper: thin: 253:2: reached low water mark for data device: sending event.
kernel: device-mapper: thin: 253:2: no free data space available.
kernel: device-mapper: thin: 253:2: switching pool to read-only mode
kernel: device-mapper: thin: 253:2: switching pool to write mode (from PM_WRITE)
kernel: device-mapper: thin: 253:2: metadata operation 'dm_pool_commit_metadata' failed: error = -1
kernel: device-mapper: thin: 253:2: switching pool to read-only mode
kernel: device-mapper: thin: 253:2: growing the data device from 6144 to 8192 blocks
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 22083 at drivers/md/dm-thin.c:934 alloc_data_block+0x171/0x1a0 [dm_thin_pool]()

dm-thin.c:934 was a WARN_ON() I added if alloc_data_block() was
called when pool mode != PM_WRITE.

The above clearly illustrated that alloc_data_block was still getting
called like crazy even though the pool went read-only waiting for a
resize.  This, and the following example, occurred due to the thin
device calling wake_worker() which kicked do_worker() during
pool_preresume() -- which caused calls to prcess_* methods to occur
during the resize.

2)
And this failure offers a clear indicator we weren't properly resizing,
but we were operating like we did:

kernel: device-mapper: thin: 253:2: switching pool to write mode
kernel: device-mapper: thin: 253:2: growing the data device from 6144 to 8192 blocks
kernel: device-mapper: thin: 253:2: no free data space available.
kernel: device-mapper: thin: 253:2: switching pool to read-only mode
kernel: device-mapper: thin: 253:2: switching pool to write mode
kernel: device-mapper: thin: 253:2: growing the data device from 6144 to 10240 blocks
kernel: attempt to access beyond end of device
kernel: dm-2: rw=17, want=1310848, limit=1310720
kernel: attempt to access beyond end of device
kernel: dm-2: rw=17, want=1310976, limit=1310720

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 35 +++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  3 ++
 drivers/md/dm-thin.c          | 78 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 103 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 7da3476..974e2cf 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1586,6 +1586,30 @@ int dm_pool_get_free_metadata_block_count(struct dm_pool_metadata *pmd,
 	return r;
 }
 
+int dm_pool_is_out_of_space(struct dm_pool_metadata *pmd, bool *result)
+{
+	int r;
+	dm_block_t free_blocks;
+
+	*result = false;
+
+	r = dm_pool_get_free_block_count(pmd, &free_blocks);
+	if (r)
+		return r;
+	if (!free_blocks) {
+		*result = true;
+		return 0;
+	}
+
+	r = dm_pool_get_free_metadata_block_count(pmd, &free_blocks);
+	if (r)
+		return r;
+	if (!free_blocks)
+		*result = true;
+
+	return 0;
+}
+
 int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 				  dm_block_t *result)
 {
@@ -1709,6 +1733,17 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_cou
 	return r;
 }
 
+bool dm_pool_metadata_is_read_only(struct dm_pool_metadata *pmd)
+{
+	bool r;
+
+	down_read(&pmd->root_lock);
+	r = pmd->read_only;
+	up_read(&pmd->root_lock);
+
+	return r;
+}
+
 void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd)
 {
 	down_write(&pmd->root_lock);
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 9a36856..dcbd08c 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -177,6 +177,8 @@ int dm_pool_get_free_metadata_block_count(struct dm_pool_metadata *pmd,
 int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 				  dm_block_t *result);
 
+int dm_pool_is_out_of_space(struct dm_pool_metadata *pmd, bool *result);
+
 int dm_pool_get_data_block_size(struct dm_pool_metadata *pmd, sector_t *result);
 
 int dm_pool_get_data_dev_size(struct dm_pool_metadata *pmd, dm_block_t *result);
@@ -194,6 +196,7 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_siz
  * Flicks the underlying block manager into read only mode, so you know
  * that nothing is changing.
  */
+bool dm_pool_metadata_is_read_only(struct dm_pool_metadata *pmd);
 void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd);
 void dm_pool_metadata_read_write(struct dm_pool_metadata *pmd);
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4a2432a..53dcdfb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -891,22 +891,43 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	}
 }
 
+static int __commit(struct pool *pool)
+{
+	int r = dm_pool_commit_metadata(pool->pmd);
+	if (r)
+		metadata_operation_failed(pool, "dm_pool_commit_metadata", r);
+
+	return r;
+}
+
+/*
+ * Commit that is confined to the metadata superblock due to pool
+ * being in PM_READ_ONLY mode (read-only process_* functions).
+ * A non-zero return indicates metadata is not writable.
+ */
+static int commit_metadata_superblock(struct pool *pool)
+{
+	WARN_ON_ONCE(get_pool_mode(pool) != PM_READ_ONLY);
+
+	if (dm_pool_metadata_is_read_only(pool->pmd)) {
+		DMERR_LIMIT("%s: commit failed: pool metadata is not writable",
+			    dm_device_name(pool->pool_md));
+		return -EINVAL;
+	}
+
+	return __commit(pool);
+}
+
 /*
  * A non-zero return indicates read_only or fail_io mode.
  * Many callers don't care about the return value.
  */
 static int commit(struct pool *pool)
 {
-	int r;
-
 	if (get_pool_mode(pool) != PM_WRITE)
 		return -EINVAL;
 
-	r = dm_pool_commit_metadata(pool->pmd);
-	if (r)
-		metadata_operation_failed(pool, "dm_pool_commit_metadata", r);
-
-	return r;
+	return __commit(pool);
 }
 
 static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
@@ -1424,7 +1445,11 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 			new_mode = PM_FAIL;
 			set_pool_mode(pool, new_mode);
 		} else {
-			dm_pool_metadata_read_only(pool->pmd);
+			bool out_of_space;
+			if (!dm_pool_is_out_of_space(pool->pmd, &out_of_space) && out_of_space)
+				dm_pool_metadata_read_write(pool->pmd);
+			else
+				dm_pool_metadata_read_only(pool->pmd);
 			pool->process_bio = process_bio_read_only;
 			pool->process_discard = process_discard;
 			pool->process_prepared_mapping = process_prepared_mapping_fail;
@@ -1701,12 +1726,17 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	/*
 	 * If we were in PM_FAIL mode, rollback of metadata failed.  We're
 	 * not going to recover without a thin_repair.  So we never let the
-	 * pool move out of the old mode.  On the other hand a PM_READ_ONLY
-	 * may have been due to a lack of metadata or data space, and may
-	 * now work (ie. if the underlying devices have been resized).
+	 * pool move out of the old mode.  Similarly, if in PM_READ_ONLY mode
+	 * and the pool doesn't have free space we must not switch modes here;
+	 * pool_preresume() will transition to PM_WRITE mode if a resize succeeds.
 	 */
 	if (old_mode == PM_FAIL)
 		new_mode = old_mode;
+	else if (old_mode == PM_READ_ONLY) {
+		bool out_of_space;
+		if (!dm_pool_is_out_of_space(pool->pmd, &out_of_space) && out_of_space)
+			new_mode = old_mode;
+	}
 
 	set_pool_mode(pool, new_mode);
 
@@ -2317,6 +2347,7 @@ static int pool_preresume(struct dm_target *ti)
 	bool need_commit1, need_commit2;
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
+	bool out_of_space = false;
 
 	/*
 	 * Take control of the pool object.
@@ -2325,6 +2356,12 @@ static int pool_preresume(struct dm_target *ti)
 	if (r)
 		return r;
 
+	if (get_pool_mode(pool) == PM_READ_ONLY) {
+		r = dm_pool_is_out_of_space(pool->pmd, &out_of_space);
+		if (r)
+			metadata_operation_failed(pool, "dm_pool_is_out_of_space", r);
+	}
+
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
 		return r;
@@ -2333,8 +2370,23 @@ static int pool_preresume(struct dm_target *ti)
 	if (r)
 		return r;
 
-	if (need_commit1 || need_commit2)
-		(void) commit(pool);
+	if (need_commit1 || need_commit2) {
+		if (out_of_space) {
+			/*
+			 * Must update metadata's superblock despite read-only mode.
+			 */
+			r = commit_metadata_superblock(pool);
+			if (r || pt->requested_pf.mode == PM_READ_ONLY)
+				dm_pool_metadata_read_only(pool->pmd);
+			else {
+				/*
+				 * If resize succeeded transition the pool to write mode.
+				 */
+				set_pool_mode(pool, PM_WRITE);
+			}
+		} else
+			(void) commit(pool);
+	}
 
 	return 0;
 }
-- 
1.8.1.4
