From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH] [dm-thin] experimental erase-log patch.
Date: Wed, 22 Feb 2012 14:25:50 +0000
Message-ID: <1329920750-29291-1-git-send-email-ejt@redhat.com>
References: <20120222141442.GA28145@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120222141442.GA28145@ubuntu>
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

This is just to let me get an idea of the costs involved with
implementing an erase log.
---
 drivers/md/dm-thin-metadata.c |   56 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |    6 ++++
 drivers/md/dm-thin.c          |   38 ++++++++++++++++++++-------
 3 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index f3ba61d..c392068 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -124,6 +124,11 @@ struct thin_disk_superblock {
 	__le32 compat_flags;
 	__le32 compat_ro_flags;
 	__le32 incompat_flags;
+
+	/*
+	 * Hold's blocks that will need to be zeroed as part of recovery from crash.
+	 */
+	__le64 erase_root;
 } __packed;
 
 struct disk_device_details {
@@ -170,11 +175,17 @@ struct dm_pool_metadata {
 	 */
 	struct dm_btree_info details_info;
 
+	/*
+	 * Blocks that need erasing on recovery.
+	 */
+	struct dm_btree_info erase_info;
+
 	struct rw_semaphore root_lock;
 	uint32_t time;
 	int need_commit;
 	dm_block_t root;
 	dm_block_t details_root;
+	dm_block_t erase_root;
 	struct list_head thin_devices;
 	uint64_t trans_id;
 	unsigned long flags;
@@ -465,6 +476,14 @@ static int init_pmd(struct dm_pool_metadata *pmd,
 	pmd->details_info.value_type.dec = NULL;
 	pmd->details_info.value_type.equal = NULL;
 
+	pmd->erase_info.tm = tm;
+	pmd->erase_info.levels = 1;
+	pmd->erase_info.value_type.context = NULL;
+	pmd->erase_info.value_type.size = sizeof(__le64);
+	pmd->erase_info.value_type.inc = NULL;
+	pmd->erase_info.value_type.dec = NULL;
+	pmd->erase_info.value_type.equal = NULL;
+
 	pmd->root = 0;
 
 	init_rwsem(&pmd->root_lock);
@@ -735,6 +754,12 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 		goto bad;
 	}
 
+	r = dm_btree_empty(&pmd->erase_info, &pmd->erase_root);
+	if (r < 0) {
+		DMERR("couldn't create erase journal");
+		goto bad;
+	}
+
 	pmd->flags = 0;
 	pmd->need_commit = 1;
 	r = dm_pool_commit_metadata(pmd);
@@ -1332,6 +1357,37 @@ int dm_pool_alloc_data_block(struct dm_pool_metadata *pmd, dm_block_t *result)
 	return r;
 }
 
+int dm_pool_mark_erase(struct dm_pool_metadata *pmd, dm_block_t b)
+{
+	int r;
+	uint64_t key = b;
+	__le64 value = cpu_to_le64(pmd->time);
+
+	down_write(&pmd->root_lock);
+	r = dm_btree_insert(&pmd->erase_info, pmd->erase_root,
+			    &key, &value, &pmd->erase_root);
+	if (!r)
+		pmd->need_commit = 1;
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
+int dm_pool_clear_erase(struct dm_pool_metadata *pmd, dm_block_t b)
+{
+	int r;
+	uint64_t key = b;
+
+	down_write(&pmd->root_lock);
+	r = dm_btree_remove(&pmd->erase_info, pmd->erase_root,
+			    &key, &pmd->erase_root);
+	if (!r)
+		pmd->need_commit = 1;
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
 int dm_pool_commit_metadata(struct dm_pool_metadata *pmd)
 {
 	int r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index cfc7d0b..42a4268 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -126,6 +126,12 @@ int dm_thin_insert_block(struct dm_thin_device *td, dm_block_t block,
 int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
 
 /*
+ * Erase log
+ */
+int dm_pool_mark_erase(struct dm_pool_metadata *pmd, dm_block_t b);
+int dm_pool_clear_erase(struct dm_pool_metadata *pmd, dm_block_t b);
+
+/*
  * Queries.
  */
 int dm_thin_get_highest_mapped_block(struct dm_thin_device *td,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 0da0db2..7536db1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -539,6 +539,7 @@ struct pool {
 	struct bio_list deferred_flush_bios;
 	struct list_head prepared_mappings;
 	struct list_head prepared_discards;
+	struct list_head copy_jobs;
 
 	struct bio_list retry_on_resume_list;
 
@@ -809,14 +810,6 @@ static void overwrite_endio(struct bio *bio, int err)
 /*----------------------------------------------------------------*/
 
 /*
- * Workqueue.
- */
-
-/*
- * Prepared mapping jobs.
- */
-
-/*
  * This sends the bios in the cell back to the deferred_bios list.
  */
 static void cell_defer(struct thin_c *tc, struct cell *cell,
@@ -878,6 +871,13 @@ static void process_prepared_mapping(struct new_mapping *m)
 		return;
 	}
 
+	r = dm_pool_clear_erase(tc->pool->pmd, m->data_block);
+	if (r) {
+		DMERR("dm_pool_clear_erase() failed");
+		cell_error(m->cell);
+		return;
+	}
+
 	/*
 	 * Release any bios held while the block was being provisioned.
 	 * If we are processing a write bio that completely covers the block,
@@ -996,6 +996,13 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	if (!ds_add_work(&pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
 
+	r = dm_pool_mark_erase(pool->pmd, data_dest);
+	if (r) {
+		mempool_free(m, pool->mapping_pool);
+		DMERR("dm_kcopyd_copy() failed");
+		cell_error(cell);
+	}
+
 	/*
 	 * IO to pool_dev remaps to the pool target's data_dev.
 	 *
@@ -1007,8 +1014,15 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 		h->overwrite_mapping = m;
 		m->bio = bio;
 		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		remap_and_issue(tc, bio, data_dest);
+		remap(tc, bio, data_dest);
+		bio_list_add(&pool->deferred_flush_bios, bio);
+
 	} else {
+		/*
+		 * FIXME: this shouldn't be done until after the commit of
+		 * the erase state change.  No point doing it now, for this
+		 * little experiment.  Just use small block sizes.
+		 */
 		struct dm_io_region from, to;
 
 		from.bdev = origin->bdev;
@@ -1062,6 +1076,8 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	m->err = 0;
 	m->bio = NULL;
 
+	dm_pool_mark_erase(pool->pmd, data_block);
+
 	/*
 	 * If the whole block of data is being overwritten or we are not
 	 * zeroing pre-existing data, we can issue the bio immediately.
@@ -1075,7 +1091,8 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 		h->overwrite_mapping = m;
 		m->bio = bio;
 		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		remap_and_issue(tc, bio, data_block);
+		remap(tc, bio, data_block);
+		bio_list_add(&pool->deferred_flush_bios, bio);
 
 	} else {
 		int r;
@@ -1087,6 +1104,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 
 		r = dm_kcopyd_zero(pool->copier, 1, &to, 0, copy_complete, m);
 		if (r < 0) {
+			dm_pool_clear_erase(pool->pmd, data_block);
 			mempool_free(m, pool->mapping_pool);
 			DMERR("dm_kcopyd_zero() failed");
 			cell_error(cell);
-- 
1.7.5.4
