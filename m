From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 04/17] dm thin metadata: change
	dm_thin_find_block to allow blocking, but not issuing, IO
Date: Fri, 17 Oct 2014 02:06:54 -0400
Message-ID: <1413526027-21630-5-git-send-email-snitzer@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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

From: Joe Thornber <ejt@redhat.com>

This change is a prerequisite for allowing metadata to be prefetched.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 30 +++++++++++++-----------------
 drivers/md/dm-thin-metadata.h |  4 ++--
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index e9d33ad..ee42d1c 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1384,42 +1384,38 @@ static bool __snapshotted_since(struct dm_thin_device *td, uint32_t time)
 }
 
 int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
-		       int can_block, struct dm_thin_lookup_result *result)
+		       int can_issue_io, struct dm_thin_lookup_result *result)
 {
-	int r = -EINVAL;
-	uint64_t block_time = 0;
+	int r;
 	__le64 value;
 	struct dm_pool_metadata *pmd = td->pmd;
 	dm_block_t keys[2] = { td->id, block };
 	struct dm_btree_info *info;
 
-	if (can_block) {
-		down_read(&pmd->root_lock);
-		info = &pmd->info;
-	} else if (down_read_trylock(&pmd->root_lock))
-		info = &pmd->nb_info;
-	else
-		return -EWOULDBLOCK;
-
 	if (pmd->fail_io)
-		goto out;
+		return -EINVAL;
 
-	r = dm_btree_lookup(info, pmd->root, keys, &value);
-	if (!r)
-		block_time = le64_to_cpu(value);
+	down_read(&pmd->root_lock);
 
-out:
-	up_read(&pmd->root_lock);
+	if (can_issue_io) {
+		info = &pmd->info;
+	} else
+		info = &pmd->nb_info;
 
+	r = dm_btree_lookup(info, pmd->root, keys, &value);
 	if (!r) {
+		uint64_t block_time = 0;
 		dm_block_t exception_block;
 		uint32_t exception_time;
+
+		block_time = le64_to_cpu(value);
 		unpack_block_time(block_time, &exception_block,
 				  &exception_time);
 		result->block = exception_block;
 		result->shared = __snapshotted_since(td, exception_time);
 	}
 
+	up_read(&pmd->root_lock);
 	return r;
 }
 
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index e3c857d..efedd5a 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -139,12 +139,12 @@ struct dm_thin_lookup_result {
 
 /*
  * Returns:
- *   -EWOULDBLOCK iff @can_block is set and would block.
+ *   -EWOULDBLOCK iff @can_issue_io is set and would issue IO
  *   -ENODATA iff that mapping is not present.
  *   0 success
  */
 int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
-		       int can_block, struct dm_thin_lookup_result *result);
+		       int can_issue_io, struct dm_thin_lookup_result *result);
 
 /*
  * Obtain an unused block.
-- 
1.9.3
