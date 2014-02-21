From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 6/8] dm thin: fix
	pool_preresume resize with heavy IO races
Date: Thu, 20 Feb 2014 21:56:03 -0500
Message-ID: <1392951365-9829-7-git-send-email-snitzer@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
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
to the normal writable operations.  These were established before
pool_resume() was able to actually resize either the metadata or data
device and resulted in the resize failing.  This failure occurred due to
the thin device calling wake_worker() which kicked do_worker() during
pool_preresume() -- which caused calls to the writable process_* methods
to occur during the resize.

Now, the pool is forced to stay in read-only mode if it was already in
read-only mode.  This prevents bouncing the pool's mode and associated
process_* methods and consistently keeps read-only processing in place
until the resize(s) complete.  To achieve this the pool can now be in a
PM_READ_ONLY state but the metadata's is !read_only -- so as to allow
the commit() the follows the resize to take place.  Differentiate
between commit_metadata_superblock() and commit() since different
negative checks apply (but factor out a common __commit that each
calls).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 44 ++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  3 ++
 drivers/md/dm-thin.c          | 78 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 112 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 21f3998..bea6db6 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1631,6 +1631,39 @@ bool dm_pool_is_metadata_out_of_space(struct dm_pool_metadata *pmd)
 	return r;
 }
 
+static int dm_pool_is_data_out_of_space(struct dm_pool_metadata *pmd, bool *result)
+{
+	int r;
+	dm_block_t free_blocks;
+
+	*result = false;
+
+	r = dm_pool_get_free_block_count(pmd, &free_blocks);
+	if (r)
+		return r;
+	if (!free_blocks)
+		*result = true;
+
+	return 0;
+}
+
+int dm_pool_is_out_of_space(struct dm_pool_metadata *pmd, bool *result)
+{
+	int r;
+
+	*result = false;
+
+	r = dm_pool_is_data_out_of_space(pmd, result);
+	if (r)
+		return r;
+	if (*result)
+		return 0;
+
+	*result = dm_pool_is_metadata_out_of_space(pmd);
+
+	return 0;
+}
+
 int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 				  dm_block_t *result)
 {
@@ -1757,6 +1790,17 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_cou
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
index cc78fbb..520dd34 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -192,6 +192,8 @@ int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *resu
 
 bool dm_pool_is_metadata_out_of_space(struct dm_pool_metadata *pmd);
 
+int dm_pool_is_out_of_space(struct dm_pool_metadata *pmd, bool *result);
+
 /*
  * Returns -ENOSPC if the new size is too small and already allocated
  * blocks would be lost.
@@ -203,6 +205,7 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_siz
  * Flicks the underlying block manager into read only mode, so you know
  * that nothing is changing.
  */
+bool dm_pool_metadata_is_read_only(struct dm_pool_metadata *pmd);
 void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd);
 void dm_pool_metadata_read_write(struct dm_pool_metadata *pmd);
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7db53d7..e560416 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -894,22 +894,43 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
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
@@ -1440,7 +1461,11 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
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
@@ -1715,12 +1740,17 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
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
 
@@ -2338,6 +2368,7 @@ static int pool_preresume(struct dm_target *ti)
 	bool need_commit1, need_commit2;
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
+	bool out_of_space = false;
 
 	/*
 	 * Take control of the pool object.
@@ -2346,6 +2377,12 @@ static int pool_preresume(struct dm_target *ti)
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
@@ -2354,8 +2391,23 @@ static int pool_preresume(struct dm_target *ti)
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
1.8.3.1
