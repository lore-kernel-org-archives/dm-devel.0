From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 3/8] dm thin: set flag if
	metadata is out of space
Date: Thu, 20 Feb 2014 21:56:00 -0500
Message-ID: <1392951365-9829-4-git-send-email-snitzer@redhat.com>
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

It is difficult for the metadata space map to accurately account for its
free space.  Manually establish a flag that reflects this out of space
condition -- until/unless dm_pool_get_free_metadata_block_count() can
return a known out of space value (either 0 or some fixed reserve
threshold we create).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 33 ++++++++++++++++++++++++++++++++-
 drivers/md/dm-thin-metadata.h |  7 +++++++
 drivers/md/dm-thin.c          |  8 +++-----
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 3bb4506..21f3998 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -192,6 +192,15 @@ struct dm_pool_metadata {
 	 * operation possible in this state is the closing of the device.
 	 */
 	bool fail_io:1;
+
+	/*
+	 * Set if metadata space has been exhausted.  It is difficult for the
+	 * metadata space map to accurately account for its free space.  So
+	 * until/unless dm_pool_get_free_metadata_block_count can return a known
+	 * out of space value (either 0 or some fixed reserve threshold we create)
+	 * manually establish a flag that reflects this out of space condition.
+	 */
+	bool metadata_out_of_space:1;
 };
 
 struct dm_thin_device {
@@ -815,6 +824,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	INIT_LIST_HEAD(&pmd->thin_devices);
 	pmd->read_only = false;
 	pmd->fail_io = false;
+	pmd->metadata_out_of_space = false;
 	pmd->bdev = bdev;
 	pmd->data_block_size = data_block_size;
 
@@ -1603,6 +1613,24 @@ int dm_pool_get_free_metadata_block_count(struct dm_pool_metadata *pmd,
 	return r;
 }
 
+void dm_pool_set_metadata_out_of_space(struct dm_pool_metadata *pmd)
+{
+	down_write(&pmd->root_lock);
+	pmd->metadata_out_of_space = true;
+	up_write(&pmd->root_lock);
+}
+
+bool dm_pool_is_metadata_out_of_space(struct dm_pool_metadata *pmd)
+{
+	bool r;
+
+	down_read(&pmd->root_lock);
+	r = pmd->metadata_out_of_space;
+	up_read(&pmd->root_lock);
+
+	return r;
+}
+
 int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 				  dm_block_t *result)
 {
@@ -1719,8 +1747,11 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_cou
 	int r = -EINVAL;
 
 	down_write(&pmd->root_lock);
-	if (!pmd->fail_io)
+	if (!pmd->fail_io) {
 		r = __resize_space_map(pmd->metadata_sm, new_count);
+		if (!r)
+			pmd->metadata_out_of_space = false;
+	}
 	up_write(&pmd->root_lock);
 
 	return r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index dd6088a..cc78fbb 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -91,6 +91,11 @@ int dm_pool_commit_metadata(struct dm_pool_metadata *pmd);
 int dm_pool_abort_metadata(struct dm_pool_metadata *pmd);
 
 /*
+ * Set if metadata space has been exhausted.
+ */
+void dm_pool_set_metadata_out_of_space(struct dm_pool_metadata *pmd);
+
+/*
  * Set/get userspace transaction id.
  */
 int dm_pool_set_metadata_transaction_id(struct dm_pool_metadata *pmd,
@@ -185,6 +190,8 @@ int dm_pool_get_data_dev_size(struct dm_pool_metadata *pmd, dm_block_t *result);
 
 int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *result);
 
+bool dm_pool_is_metadata_out_of_space(struct dm_pool_metadata *pmd);
+
 /*
  * Returns -ENOSPC if the new size is too small and already allocated
  * blocks would be lost.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 42d08eb..8e68831 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1464,16 +1464,14 @@ static void out_of_data_space(struct pool *pool)
 
 static void metadata_operation_failed(struct pool *pool, const char *op, int r)
 {
-	dm_block_t free_blocks;
-
 	DMERR_LIMIT("%s: metadata operation '%s' failed: error = %d",
 		    dm_device_name(pool->pool_md), op, r);
 
-	if (r == -ENOSPC &&
-	    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
-	    !free_blocks)
+	if (r == -ENOSPC) {
+		dm_pool_set_metadata_out_of_space(pool->pmd);
 		DMERR_LIMIT("%s: no free metadata space available.",
 			    dm_device_name(pool->pool_md));
+	}
 
 	set_pool_mode(pool, PM_READ_ONLY);
 }
-- 
1.8.3.1
