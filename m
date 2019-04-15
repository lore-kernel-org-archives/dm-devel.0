From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm thin metadata: do not write metadata if
	no changes occurred
Date: Mon, 15 Apr 2019 17:17:16 -0400
Message-ID: <20190415211717.18737-3-snitzer@redhat.com>
References: <20190415211717.18737-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190415211717.18737-1-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Otherwise, just loading a thin-pool and then removing it will cause its
metadata to be changed (e.g. superblock written) -- even without any
thin devices being made active or metadata snapshot being manipulated.

Add 'changed' flag to struct dm_pool_metadata.  Set both td->changed and
pmd->changed using __set_thin_changed() -- this assures pmd->changed is
always set when td->changed is.  For methods that don't involve changing
a td, set pmd->changed directly.

Rename __delete_device() to __delete_thin() -- improves symmetry with
__create_thin().

Update dm_pool_changed_this_transaction() to simply return pmd->changed.

Fix dm_pool_commit_metadata() to open the next transaction if the return
from __commit_transaction() is 0.  Not seeing why the early return ever
made since for a return of 0 given that dm-io's async_io(), as used by
bufio, always returns 0.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 56 ++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index ed3caceaed07..f4e8327abc75 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -201,6 +201,12 @@ struct dm_pool_metadata {
 	 */
 	bool fail_io:1;
 
+	/*
+	 * Set if metadata has changed, particularly important for methods that
+	 * alter metadata without the ability to reflect the change in td->changed.
+	 */
+	bool changed:1;
+
 	/*
 	 * Reading the space map roots can fail, so we read it into these
 	 * buffers before the superblock is locked and updated.
@@ -769,7 +775,7 @@ static int __write_changed_details(struct dm_pool_metadata *pmd)
 			return r;
 
 		if (td->open_count)
-			td->changed = 0;
+			td->changed = false;
 		else {
 			list_del(&td->list);
 			kfree(td);
@@ -779,6 +785,14 @@ static int __write_changed_details(struct dm_pool_metadata *pmd)
 	return 0;
 }
 
+static void __set_thin_changed(struct dm_thin_device *td)
+{
+	struct dm_pool_metadata *pmd = td->pmd;
+
+	td->changed = true;
+	pmd->changed = true;
+}
+
 static int __commit_transaction(struct dm_pool_metadata *pmd)
 {
 	int r;
@@ -790,6 +804,9 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	 */
 	BUILD_BUG_ON(sizeof(struct thin_disk_superblock) > 512);
 
+	if (!pmd->changed)
+		return 0;
+
 	r = __write_changed_details(pmd);
 	if (r < 0)
 		return r;
@@ -819,6 +836,8 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 
 	copy_sm_roots(pmd, disk_super);
 
+	pmd->changed = false;
+
 	return dm_tm_commit(pmd->tm, sblock);
 }
 
@@ -853,6 +872,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
 	pmd->time = 0;
 	INIT_LIST_HEAD(&pmd->thin_devices);
 	pmd->fail_io = false;
+	pmd->changed = false;
 	pmd->bdev = bdev;
 	pmd->data_block_size = data_block_size;
 
@@ -967,7 +987,8 @@ static int __open_device(struct dm_pool_metadata *pmd,
 	(*td)->pmd = pmd;
 	(*td)->id = dev;
 	(*td)->open_count = 1;
-	(*td)->changed = changed;
+	if (changed)
+		__set_thin_changed(*td);
 	(*td)->aborted_with_changes = false;
 	(*td)->mapped_blocks = le64_to_cpu(details_le.mapped_blocks);
 	(*td)->transaction_id = le64_to_cpu(details_le.transaction_id);
@@ -1051,7 +1072,7 @@ static int __set_snapshot_details(struct dm_pool_metadata *pmd,
 	if (r)
 		return r;
 
-	td->changed = 1;
+	__set_thin_changed(td);
 	td->snapshotted_time = time;
 
 	snap->mapped_blocks = td->mapped_blocks;
@@ -1131,7 +1152,7 @@ int dm_pool_create_snap(struct dm_pool_metadata *pmd,
 	return r;
 }
 
-static int __delete_device(struct dm_pool_metadata *pmd, dm_thin_id dev)
+static int __delete_thin(struct dm_pool_metadata *pmd, dm_thin_id dev)
 {
 	int r;
 	uint64_t key = dev;
@@ -1158,6 +1179,8 @@ static int __delete_device(struct dm_pool_metadata *pmd, dm_thin_id dev)
 	if (r)
 		return r;
 
+	pmd->changed = true;
+
 	return 0;
 }
 
@@ -1168,7 +1191,7 @@ int dm_pool_delete_thin_device(struct dm_pool_metadata *pmd,
 
 	down_write(&pmd->root_lock);
 	if (!pmd->fail_io)
-		r = __delete_device(pmd, dev);
+		r = __delete_thin(pmd, dev);
 	up_write(&pmd->root_lock);
 
 	return r;
@@ -1276,6 +1299,9 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	disk_super = dm_block_data(sblock);
 	disk_super->held_root = cpu_to_le64(held_root);
 	dm_bm_unlock(sblock);
+
+	pmd->changed = true;
+
 	return 0;
 }
 
@@ -1324,6 +1350,8 @@ static int __release_metadata_snap(struct dm_pool_metadata *pmd)
 
 	dm_tm_unlock(pmd->tm, copy);
 
+	pmd->changed = true;
+
 	return 0;
 }
 
@@ -1558,7 +1586,7 @@ static int __insert(struct dm_thin_device *td, dm_block_t block,
 	if (r)
 		return r;
 
-	td->changed = 1;
+	__set_thin_changed(td);
 	if (inserted)
 		td->mapped_blocks++;
 
@@ -1589,7 +1617,7 @@ static int __remove(struct dm_thin_device *td, dm_block_t block)
 		return r;
 
 	td->mapped_blocks--;
-	td->changed = 1;
+	__set_thin_changed(td);
 
 	return 0;
 }
@@ -1643,7 +1671,7 @@ static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_
 	}
 
 	td->mapped_blocks -= total_count;
-	td->changed = 1;
+	__set_thin_changed(td);
 
 	/*
 	 * Reinsert the mapping tree.
@@ -1735,16 +1763,10 @@ bool dm_thin_changed_this_transaction(struct dm_thin_device *td)
 
 bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd)
 {
-	bool r = false;
-	struct dm_thin_device *td, *tmp;
+	bool r;
 
 	down_read(&pmd->root_lock);
-	list_for_each_entry_safe(td, tmp, &pmd->thin_devices, list) {
-		if (td->changed) {
-			r = td->changed;
-			break;
-		}
-	}
+	r = pmd->changed;
 	up_read(&pmd->root_lock);
 
 	return r;
@@ -1782,7 +1804,7 @@ int dm_pool_commit_metadata(struct dm_pool_metadata *pmd)
 		goto out;
 
 	r = __commit_transaction(pmd);
-	if (r <= 0)
+	if (r < 0)
 		goto out;
 
 	/*
-- 
2.18.0
