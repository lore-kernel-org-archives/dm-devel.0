From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH] [dm-thin] Speed up discard of partially mapped
	volumes
Date: Thu,  5 Nov 2015 15:10:11 +0000
Message-ID: <1446736211-7491-1-git-send-email-ejt@redhat.com>
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
List-Id: dm-devel.ids

A new btree function, dm_btree_lookup_next(), is introduced which is
more efficiently able to skip over regions of the thin device which
aren't mapped.
---
 drivers/md/dm-thin-metadata.c         | 66 ++++++++++++++++-----------
 drivers/md/persistent-data/dm-btree.c | 84 +++++++++++++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h |  7 +++
 3 files changed, 132 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 7fd8309..2eff2ae 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1381,6 +1381,19 @@ static bool __snapshotted_since(struct dm_thin_device *td, uint32_t time)
 	return td->snapshotted_time > time;
 }
 
+static void unpack_lookup_result(struct dm_thin_device *td, __le64 value,
+				 struct dm_thin_lookup_result *result)
+{
+	uint64_t block_time = 0;
+	dm_block_t exception_block;
+	uint32_t exception_time;
+
+	block_time = le64_to_cpu(value);
+	unpack_block_time(block_time, &exception_block, &exception_time);
+	result->block = exception_block;
+	result->shared = __snapshotted_since(td, exception_time);
+}
+
 int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
 		       int can_issue_io, struct dm_thin_lookup_result *result)
 {
@@ -1402,23 +1415,36 @@ int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
 		info = &pmd->nb_info;
 
 	r = dm_btree_lookup(info, pmd->root, keys, &value);
-	if (!r) {
-		uint64_t block_time = 0;
-		dm_block_t exception_block;
-		uint32_t exception_time;
-
-		block_time = le64_to_cpu(value);
-		unpack_block_time(block_time, &exception_block,
-				  &exception_time);
-		result->block = exception_block;
-		result->shared = __snapshotted_since(td, exception_time);
+	if (!r)
+		unpack_lookup_result(td, value, result);
+
+	up_read(&pmd->root_lock);
+	return r;
+}
+
+static int dm_thin_find_next_mapped_block(struct dm_thin_device *td, dm_block_t block,
+					  dm_block_t *vblock,
+					  struct dm_thin_lookup_result *result)
+{
+	int r;
+	__le64 value;
+	struct dm_pool_metadata *pmd = td->pmd;
+	dm_block_t keys[2] = { td->id, block };
+
+	down_read(&pmd->root_lock);
+	if (pmd->fail_io) {
+		up_read(&pmd->root_lock);
+		return -EINVAL;
 	}
 
+	r = dm_btree_lookup_next(&pmd->info, pmd->root, keys, vblock, &value);
+	if (!r)
+		unpack_lookup_result(td, value, result);
+
 	up_read(&pmd->root_lock);
 	return r;
 }
 
-/* FIXME: write a more efficient one in btree */
 int dm_thin_find_mapped_range(struct dm_thin_device *td,
 			      dm_block_t begin, dm_block_t end,
 			      dm_block_t *thin_begin, dm_block_t *thin_end,
@@ -1431,21 +1457,11 @@ int dm_thin_find_mapped_range(struct dm_thin_device *td,
 	if (end < begin)
 		return -ENODATA;
 
-	/*
-	 * Find first mapped block.
-	 */
-	while (begin < end) {
-		r = dm_thin_find_block(td, begin, true, &lookup);
-		if (r) {
-			if (r != -ENODATA)
-				return r;
-		} else
-			break;
-
-		begin++;
-	}
+	r = dm_thin_find_next_mapped_block(td, begin, &begin, &lookup);
+	if (r)
+		return r;
 
-	if (begin == end)
+	if (begin >= end)
 		return -ENODATA;
 
 	*thin_begin = begin;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index a262fbc..ca07ce7 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -63,6 +63,11 @@ int lower_bound(struct btree_node *n, uint64_t key)
 	return bsearch(n, key, 0);
 }
 
+static int upper_bound(struct btree_node *n, uint64_t key)
+{
+	return bsearch(n, key, 1);
+}
+
 void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 		  struct dm_btree_value_type *vt)
 {
@@ -395,6 +400,85 @@ int dm_btree_lookup(struct dm_btree_info *info, dm_block_t root,
 }
 EXPORT_SYMBOL_GPL(dm_btree_lookup);
 
+static int dm_btree_lookup_next_single(struct dm_btree_info *info, dm_block_t root,
+				       uint64_t key, uint64_t *rkey, void *value_le)
+{
+	int r, i;
+	uint32_t flags, nr_entries;
+	struct dm_block *node;
+	struct btree_node *n;
+
+	r = bn_read_lock(info, root, &node);
+	if (r)
+		return r;
+
+	n = dm_block_data(node);
+	flags = le32_to_cpu(n->header.flags);
+	nr_entries = le32_to_cpu(n->header.nr_entries);
+
+	if (flags & INTERNAL_NODE) {
+		i = lower_bound(n, key);
+		if (i < 0 || i >= nr_entries) {
+			r = -ENODATA;
+			goto out;
+		}
+
+		r = dm_btree_lookup_next_single(info, value64(n, i), key, rkey, value_le);
+		if (r == -ENODATA && i < nr_entries) {
+			i++;
+			r = dm_btree_lookup_next_single(info, value64(n, i), key, rkey, value_le);
+		}
+
+	} else {
+		i = upper_bound(n, key);
+		if (i < 0 || i >= nr_entries) {
+			r = -ENODATA;
+			goto out;
+		}
+
+		*rkey = le64_to_cpu(n->keys[i]);
+		memcpy(value_le, value_ptr(n, i), info->value_type.size);
+	}
+
+out:
+	dm_tm_unlock(info->tm, node);
+	return r;
+}
+
+int dm_btree_lookup_next(struct dm_btree_info *info, dm_block_t root,
+			 uint64_t *keys, uint64_t *rkey, void *value_le)
+{
+	unsigned level;
+	int r = -ENODATA;
+	__le64 internal_value_le;
+	struct ro_spine spine;
+
+	init_ro_spine(&spine, info);
+	for (level = 0; level < info->levels - 1u; level++) {
+		r = btree_lookup_raw(&spine, root, keys[level],
+				     lower_bound, rkey,
+				     &internal_value_le, sizeof(uint64_t));
+
+		if (r)
+			goto out;
+
+		if (*rkey != keys[level]) {
+			r = -ENODATA;
+			goto out;
+		}
+
+		root = le64_to_cpu(internal_value_le);
+	}
+
+	r = dm_btree_lookup_next_single(info, root, keys[level], rkey, value_le);
+
+out:
+	exit_ro_spine(&spine);
+	return r;
+}
+
+EXPORT_SYMBOL_GPL(dm_btree_lookup_next);
+
 /*
  * Splits a node by creating a sibling node and shifting half the nodes
  * contents across.  Assumes there is a parent node, and it has room for
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index 11d8cf7..bf1f3db 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -110,6 +110,13 @@ int dm_btree_lookup(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, void *value_le);
 
 /*
+ * Tries to  find the first key  where the bottom level key is >= to that
+ * given.  Useful for skipping empty sections of the btree.
+ */
+int dm_btree_lookup_next(struct dm_btree_info *info, dm_block_t root,
+			 uint64_t *keys, uint64_t *rkey, void *value_le);
+
+/*
  * Insertion (or overwrite an existing value).  O(ln(n))
  */
 int dm_btree_insert(struct dm_btree_info *info, dm_block_t root,
-- 
2.5.0
