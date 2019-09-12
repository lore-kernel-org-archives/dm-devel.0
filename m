From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 1/2] dm clone metadata: Rename md to cmd
Date: Thu, 12 Sep 2019 15:11:36 +0300
Message-ID: <20190912121137.26567-2-ntsironis@arrikto.com>
References: <20190912121137.26567-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190912121137.26567-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: vkoukis@arrikto.com, ntsironis@arrikto.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

Rename md to cmd to be consistent with dm-clone-metadata.c

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-metadata.h | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-clone-metadata.h b/drivers/md/dm-clone-metadata.h
index 7b8063ea70c3..434bff08508b 100644
--- a/drivers/md/dm-clone-metadata.h
+++ b/drivers/md/dm-clone-metadata.h
@@ -29,24 +29,24 @@ struct dm_clone_metadata;
 /*
  * Set region status to hydrated.
  *
- * @md: The dm-clone metadata
+ * @cmd: The dm-clone metadata
  * @region_nr: The region number
  *
  * This function doesn't block, so it's safe to call it from interrupt context.
  */
-int dm_clone_set_region_hydrated(struct dm_clone_metadata *md, unsigned long region_nr);
+int dm_clone_set_region_hydrated(struct dm_clone_metadata *cmd, unsigned long region_nr);
 
 /*
  * Set status of all regions in the provided range to hydrated, if not already
  * hydrated.
  *
- * @md: The dm-clone metadata
+ * @cmd: The dm-clone metadata
  * @start: Starting region number
  * @nr_regions: Number of regions in the range
  *
  * This function doesn't block, so it's safe to call it from interrupt context.
  */
-int dm_clone_cond_set_range(struct dm_clone_metadata *md, unsigned long start,
+int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
 			    unsigned long nr_regions);
 
 /*
@@ -69,12 +69,12 @@ struct dm_clone_metadata *dm_clone_metadata_open(struct block_device *bdev,
 /*
  * Free the resources related to metadata management.
  */
-void dm_clone_metadata_close(struct dm_clone_metadata *md);
+void dm_clone_metadata_close(struct dm_clone_metadata *cmd);
 
 /*
  * Commit dm-clone metadata to disk.
  */
-int dm_clone_metadata_commit(struct dm_clone_metadata *md);
+int dm_clone_metadata_commit(struct dm_clone_metadata *cmd);
 
 /*
  * Reload the in core copy of the on-disk bitmap.
@@ -93,18 +93,18 @@ int dm_clone_metadata_commit(struct dm_clone_metadata *md);
  * dm_clone_set_region_hydrated() and dm_clone_cond_set_range() refuse to touch
  * the region bitmap, after calling dm_clone_metadata_set_read_only().
  */
-int dm_clone_reload_in_core_bitset(struct dm_clone_metadata *md);
+int dm_clone_reload_in_core_bitset(struct dm_clone_metadata *cmd);
 
 /*
  * Check whether dm-clone's metadata changed this transaction.
  */
-bool dm_clone_changed_this_transaction(struct dm_clone_metadata *md);
+bool dm_clone_changed_this_transaction(struct dm_clone_metadata *cmd);
 
 /*
  * Abort current metadata transaction and rollback metadata to the last
  * committed transaction.
  */
-int dm_clone_metadata_abort(struct dm_clone_metadata *md);
+int dm_clone_metadata_abort(struct dm_clone_metadata *cmd);
 
 /*
  * Switches metadata to a read only mode. Once read-only mode has been entered
@@ -115,44 +115,44 @@ int dm_clone_metadata_abort(struct dm_clone_metadata *md);
  *   dm_clone_cond_set_range()
  *   dm_clone_metadata_abort()
  */
-void dm_clone_metadata_set_read_only(struct dm_clone_metadata *md);
-void dm_clone_metadata_set_read_write(struct dm_clone_metadata *md);
+void dm_clone_metadata_set_read_only(struct dm_clone_metadata *cmd);
+void dm_clone_metadata_set_read_write(struct dm_clone_metadata *cmd);
 
 /*
  * Returns true if the hydration of the destination device is finished.
  */
-bool dm_clone_is_hydration_done(struct dm_clone_metadata *md);
+bool dm_clone_is_hydration_done(struct dm_clone_metadata *cmd);
 
 /*
  * Returns true if region @region_nr is hydrated.
  */
-bool dm_clone_is_region_hydrated(struct dm_clone_metadata *md, unsigned long region_nr);
+bool dm_clone_is_region_hydrated(struct dm_clone_metadata *cmd, unsigned long region_nr);
 
 /*
  * Returns true if all the regions in the range are hydrated.
  */
-bool dm_clone_is_range_hydrated(struct dm_clone_metadata *md,
+bool dm_clone_is_range_hydrated(struct dm_clone_metadata *cmd,
 				unsigned long start, unsigned long nr_regions);
 
 /*
  * Returns the number of hydrated regions.
  */
-unsigned long dm_clone_nr_of_hydrated_regions(struct dm_clone_metadata *md);
+unsigned long dm_clone_nr_of_hydrated_regions(struct dm_clone_metadata *cmd);
 
 /*
  * Returns the first unhydrated region with region_nr >= @start
  */
-unsigned long dm_clone_find_next_unhydrated_region(struct dm_clone_metadata *md,
+unsigned long dm_clone_find_next_unhydrated_region(struct dm_clone_metadata *cmd,
 						   unsigned long start);
 
 /*
  * Get the number of free metadata blocks.
  */
-int dm_clone_get_free_metadata_block_count(struct dm_clone_metadata *md, dm_block_t *result);
+int dm_clone_get_free_metadata_block_count(struct dm_clone_metadata *cmd, dm_block_t *result);
 
 /*
  * Get the total number of metadata blocks.
  */
-int dm_clone_get_metadata_dev_size(struct dm_clone_metadata *md, dm_block_t *result);
+int dm_clone_get_metadata_dev_size(struct dm_clone_metadata *cmd, dm_block_t *result);
 
 #endif /* DM_CLONE_METADATA_H */
-- 
2.11.0
