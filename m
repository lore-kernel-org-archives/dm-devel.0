From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 11/20] dm thin: handle metadata failures
	more consistently
Date: Fri, 20 Dec 2013 18:37:24 -0500
Message-ID: <1387582653-13647-12-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Introduce metadata_operation_failed() wrappers, around set_pool_mode(),
to assist with improving the consistency of how metadata failures are
handled.  Logging is improved and metadata operation failures trigger
read-only mode immediately.

Also, eliminate redundant set_pool_mode() calls in the two
alloc_data_block() caller's error paths.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3420ebe5..ccd917f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -198,7 +198,7 @@ struct pool {
 };
 
 static enum pool_mode get_pool_mode(struct pool *pool);
-static void set_pool_mode(struct pool *pool, enum pool_mode mode);
+static void metadata_operation_failed(struct pool *pool, const char *op, int r);
 
 /*
  * Target context for a pool.
@@ -641,9 +641,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 */
 	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
 	if (r) {
-		DMERR_LIMIT("%s: dm_thin_insert_block() failed: error = %d",
-			    dm_device_name(pool->pool_md), r);
-		set_pool_mode(pool, PM_READ_ONLY);
+		metadata_operation_failed(pool, "dm_thin_insert_block", r);
 		cell_error(pool, m->cell);
 		goto out;
 	}
@@ -904,11 +902,8 @@ static int commit(struct pool *pool)
 		return -EINVAL;
 
 	r = dm_pool_commit_metadata(pool->pmd);
-	if (r) {
-		DMERR_LIMIT("%s: dm_pool_commit_metadata failed: error = %d",
-			    dm_device_name(pool->pool_md), r);
-		set_pool_mode(pool, PM_READ_ONLY);
-	}
+	if (r)
+		metadata_operation_failed(pool, "dm_pool_commit_metadata", r);
 
 	return r;
 }
@@ -945,8 +940,10 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 		return -EINVAL;
 
 	r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
-	if (r)
+	if (r) {
+		metadata_operation_failed(pool, "dm_pool_get_free_block_count", r);
 		return r;
+	}
 
 	check_low_water_mark(pool, free_blocks);
 
@@ -960,8 +957,10 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 			return r;
 
 		r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
-		if (r)
+		if (r) {
+			metadata_operation_failed(pool, "dm_pool_get_free_block_count", r);
 			return r;
+		}
 
 		/*
 		 * If we still have no space we set a flag to avoid
@@ -984,11 +983,11 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 	if (r) {
 		if (r == -ENOSPC &&
 		    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
-		    !free_blocks) {
+		    !free_blocks)
 			DMWARN("%s: no free metadata space available.",
 			       dm_device_name(pool->pool_md));
-			set_pool_mode(pool, PM_READ_ONLY);
-		}
+
+		metadata_operation_failed(pool, "dm_pool_alloc_data_block", r);
 		return r;
 	}
 
@@ -1130,7 +1129,6 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 	default:
 		DMERR_LIMIT("%s: alloc_data_block() failed: error = %d",
 			    __func__, r);
-		set_pool_mode(pool, PM_READ_ONLY);
 		cell_error(pool, cell);
 		break;
 	}
@@ -1209,7 +1207,6 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	default:
 		DMERR_LIMIT("%s: alloc_data_block() failed: error = %d",
 			    __func__, r);
-		set_pool_mode(pool, PM_READ_ONLY);
 		cell_error(pool, cell);
 		break;
 	}
@@ -1453,6 +1450,18 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 	}
 }
 
+/*
+ * Rather than calling set_pool_mode directly, use these which describe the
+ * reason for mode degradation.
+ */
+static void metadata_operation_failed(struct pool *pool, const char *op, int r)
+{
+	DMERR_LIMIT("%s: metadata operation '%s' failed: error = %d",
+		    dm_device_name(pool->pool_md), op, r);
+
+	set_pool_mode(pool, PM_READ_ONLY);
+}
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -2213,9 +2222,7 @@ static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
 	} else if (data_size > sb_data_size) {
 		r = dm_pool_resize_data_dev(pool->pmd, data_size);
 		if (r) {
-			DMERR("%s: failed to resize data device",
-			      dm_device_name(pool->pool_md));
-			set_pool_mode(pool, PM_READ_ONLY);
+			metadata_operation_failed(pool, "dm_pool_resize_data_dev", r);
 			return r;
 		}
 
@@ -2252,8 +2259,7 @@ static int maybe_resize_metadata_dev(struct dm_target *ti, bool *need_commit)
 	} else if (metadata_dev_size > sb_metadata_dev_size) {
 		r = dm_pool_resize_metadata_dev(pool->pmd, metadata_dev_size);
 		if (r) {
-			DMERR("%s: failed to resize metadata device",
-			      dm_device_name(pool->pool_md));
+			metadata_operation_failed(pool, "dm_pool_resize_metadata_dev", r);
 			return r;
 		}
 
-- 
1.8.1.4
