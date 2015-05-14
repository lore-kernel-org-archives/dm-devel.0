From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 14/14] dm thin metadata: remove in-core
	'read_only' flag
Date: Thu, 14 May 2015 17:05:12 -0400
Message-ID: <1431637512-64245-15-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Leverage the block manager's read_only flag instead of duplicating it;
access with new dm_bm_is_read_only() method.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c                 | 6 +-----
 drivers/md/persistent-data/dm-block-manager.c | 6 ++++++
 drivers/md/persistent-data/dm-block-manager.h | 1 +
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 40359e9..8b521e3 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -184,7 +184,6 @@ struct dm_pool_metadata {
 	uint64_t trans_id;
 	unsigned long flags;
 	sector_t data_block_size;
-	bool read_only:1;
 
 	/*
 	 * Set if a transaction has to be aborted but the attempt to roll back
@@ -836,7 +835,6 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	init_rwsem(&pmd->root_lock);
 	pmd->time = 0;
 	INIT_LIST_HEAD(&pmd->thin_devices);
-	pmd->read_only = false;
 	pmd->fail_io = false;
 	pmd->bdev = bdev;
 	pmd->data_block_size = data_block_size;
@@ -880,7 +878,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 		return -EBUSY;
 	}
 
-	if (!pmd->read_only && !pmd->fail_io) {
+	if (!dm_bm_is_read_only(pmd->bm) && !pmd->fail_io) {
 		r = __commit_transaction(pmd);
 		if (r < 0)
 			DMWARN("%s: __commit_transaction() failed, error = %d",
@@ -1850,7 +1848,6 @@ int dm_pool_resize_metadata_dev(struct dm_pool_metadata *pmd, dm_block_t new_cou
 void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd)
 {
 	down_write(&pmd->root_lock);
-	pmd->read_only = true;
 	dm_bm_set_read_only(pmd->bm);
 	up_write(&pmd->root_lock);
 }
@@ -1858,7 +1855,6 @@ void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd)
 void dm_pool_metadata_read_write(struct dm_pool_metadata *pmd)
 {
 	down_write(&pmd->root_lock);
-	pmd->read_only = false;
 	dm_bm_set_read_write(pmd->bm);
 	up_write(&pmd->root_lock);
 }
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 087411c..4d6c9b6 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -609,6 +609,12 @@ void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
 	dm_bufio_prefetch(bm->bufio, b, 1);
 }
 
+bool dm_bm_is_read_only(struct dm_block_manager *bm)
+{
+	return bm->read_only;
+}
+EXPORT_SYMBOL_GPL(dm_bm_is_read_only);
+
 void dm_bm_set_read_only(struct dm_block_manager *bm)
 {
 	bm->read_only = true;
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index 1b95dfc..84330f5 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -123,6 +123,7 @@ void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b);
  * Additionally you should not use dm_bm_unlock_move, however no error will
  * be returned if you do.
  */
+bool dm_bm_is_read_only(struct dm_block_manager *bm);
 void dm_bm_set_read_only(struct dm_block_manager *bm);
 void dm_bm_set_read_write(struct dm_block_manager *bm);
 
-- 
2.3.2 (Apple Git-55)
