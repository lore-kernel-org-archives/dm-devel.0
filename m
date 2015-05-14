From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 10/14] dm thin metadata: add
	dm_thin_remove_range()
Date: Thu, 14 May 2015 17:05:08 -0400
Message-ID: <1431637512-64245-11-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Removes a range of blocks from the btree.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  2 ++
 2 files changed, 56 insertions(+)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index edcf4fb..40359e9 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1528,6 +1528,47 @@ static int __remove(struct dm_thin_device *td, dm_block_t block)
 	return 0;
 }
 
+static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_t end)
+{
+	int r;
+	unsigned count;
+	struct dm_pool_metadata *pmd = td->pmd;
+	dm_block_t keys[1] = { td->id };
+	__le64 value;
+	dm_block_t mapping_root;
+
+	/*
+	 * Find the mapping tree
+	 */
+	r = dm_btree_lookup(&pmd->tl_info, pmd->root, keys, &value);
+	if (r)
+		return r;
+
+	/*
+	 * Remove from the mapping tree, taking care to inc the
+	 * ref count so it doesn't get deleted.
+	 */
+	mapping_root = le64_to_cpu(value);
+	dm_tm_inc(pmd->tm, mapping_root);
+	r = dm_btree_remove(&pmd->tl_info, pmd->root, keys, &pmd->root);
+	if (r)
+		return r;
+
+	r = dm_btree_remove_leaves(&pmd->bl_info, mapping_root, &begin, end, &mapping_root, &count);
+	if (r)
+		return r;
+
+	td->mapped_blocks -= count;
+	td->changed = 1;
+
+	/*
+	 * Reinsert the mapping tree.
+	 */
+	value = cpu_to_le64(mapping_root);
+	__dm_bless_for_disk(&value);
+	return dm_btree_insert(&pmd->tl_info, pmd->root, keys, &value, &pmd->root);
+}
+
 int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block)
 {
 	int r = -EINVAL;
@@ -1540,6 +1581,19 @@ int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block)
 	return r;
 }
 
+int dm_thin_remove_range(struct dm_thin_device *td,
+			 dm_block_t begin, dm_block_t end)
+{
+	int r = -EINVAL;
+
+	down_write(&td->pmd->root_lock);
+	if (!td->pmd->fail_io)
+		r = __remove_range(td, begin, end);
+	up_write(&td->pmd->root_lock);
+
+	return r;
+}
+
 int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *result)
 {
 	int r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index f11f140..a938bab 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -167,6 +167,8 @@ int dm_thin_insert_block(struct dm_thin_device *td, dm_block_t block,
 			 dm_block_t data_block);
 
 int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
+int dm_thin_remove_range(struct dm_thin_device *td,
+			 dm_block_t begin, dm_block_t end);
 
 /*
  * Queries.
-- 
2.3.2 (Apple Git-55)
