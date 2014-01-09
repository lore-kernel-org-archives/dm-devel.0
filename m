From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14] dm btree: add dm_btree_find_lowest_key
Date: Thu,  9 Jan 2014 16:30:53 -0500
Message-ID: <1389303053-31684-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: ejt@redhat.com, joe.thornber@gmail.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

dm_btree_find_lowest_key is the reciprocal of dm_btree_find_highest_key.
Factor out common code for dm_btree_find_{highest,lowest}_key.

dm_btree_find_lowest_key is needed for an upcoming DM target, as such it
is best to get this interface in place.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-btree.c | 33 ++++++++++++++++++++++++++-------
 drivers/md/persistent-data/dm-btree.h |  8 ++++++++
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 468e371..416060c 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -770,8 +770,8 @@ EXPORT_SYMBOL_GPL(dm_btree_insert_notify);
 
 /*----------------------------------------------------------------*/
 
-static int find_highest_key(struct ro_spine *s, dm_block_t block,
-			    uint64_t *result_key, dm_block_t *next_block)
+static int find_key(struct ro_spine *s, dm_block_t block, bool find_highest,
+		    uint64_t *result_key, dm_block_t *next_block)
 {
 	int i, r;
 	uint32_t flags;
@@ -788,7 +788,11 @@ static int find_highest_key(struct ro_spine *s, dm_block_t block,
 		else
 			i--;
 
-		*result_key = le64_to_cpu(ro_node(s)->keys[i]);
+		if (find_highest)
+			*result_key = le64_to_cpu(ro_node(s)->keys[i]);
+		else
+			*result_key = le64_to_cpu(ro_node(s)->keys[0]);
+
 		if (next_block || flags & INTERNAL_NODE)
 			block = value64(ro_node(s), i);
 
@@ -799,16 +803,16 @@ static int find_highest_key(struct ro_spine *s, dm_block_t block,
 	return 0;
 }
 
-int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
-			      uint64_t *result_keys)
+static int dm_btree_find_key(struct dm_btree_info *info, dm_block_t root,
+			     bool find_highest, uint64_t *result_keys)
 {
 	int r = 0, count = 0, level;
 	struct ro_spine spine;
 
 	init_ro_spine(&spine, info);
 	for (level = 0; level < info->levels; level++) {
-		r = find_highest_key(&spine, root, result_keys + level,
-				     level == info->levels - 1 ? NULL : &root);
+		r = find_key(&spine, root, find_highest, result_keys + level,
+			     level == info->levels - 1 ? NULL : &root);
 		if (r == -ENODATA) {
 			r = 0;
 			break;
@@ -822,8 +826,23 @@ int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
 
 	return r ? r : count;
 }
+
+int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
+			      uint64_t *result_keys)
+{
+	return dm_btree_find_key(info, root, true, result_keys);
+}
 EXPORT_SYMBOL_GPL(dm_btree_find_highest_key);
 
+int dm_btree_find_lowest_key(struct dm_btree_info *info, dm_block_t root,
+			     uint64_t *result_keys)
+{
+	return dm_btree_find_key(info, root, false, result_keys);
+}
+EXPORT_SYMBOL_GPL(dm_btree_find_lowest_key);
+
+/*----------------------------------------------------------------*/
+
 /*
  * FIXME: We shouldn't use a recursive algorithm when we have limited stack
  * space.  Also this only works for single level trees.
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index 8672d15..dacfc34 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -137,6 +137,14 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 /*
  * Returns < 0 on failure.  Otherwise the number of key entries that have
  * been filled out.  Remember trees can have zero entries, and as such have
+ * no lowest key.
+ */
+int dm_btree_find_lowest_key(struct dm_btree_info *info, dm_block_t root,
+			     uint64_t *result_keys);
+
+/*
+ * Returns < 0 on failure.  Otherwise the number of key entries that have
+ * been filled out.  Remember trees can have zero entries, and as such have
  * no highest key.
  */
 int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
-- 
1.8.1.4
