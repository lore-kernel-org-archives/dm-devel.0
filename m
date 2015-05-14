From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 08/14] dm btree: add
	dm_btree_remove_leaves()
Date: Thu, 14 May 2015 17:05:06 -0400
Message-ID: <1431637512-64245-9-git-send-email-snitzer@redhat.com>
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

Removes a range of leaf values from the tree.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-btree-remove.c | 127 +++++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h        |   9 ++
 2 files changed, 136 insertions(+)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index b88757c..e04cfd2 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -590,3 +590,130 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 	return r;
 }
 EXPORT_SYMBOL_GPL(dm_btree_remove);
+
+/*----------------------------------------------------------------*/
+
+static int remove_nearest(struct shadow_spine *s, struct dm_btree_info *info,
+			  struct dm_btree_value_type *vt, dm_block_t root,
+			  uint64_t key, int *index)
+{
+	int i = *index, r;
+	struct btree_node *n;
+
+	for (;;) {
+		r = shadow_step(s, root, vt);
+		if (r < 0)
+			break;
+
+		/*
+		 * We have to patch up the parent node, ugly, but I don't
+		 * see a way to do this automatically as part of the spine
+		 * op.
+		 */
+		if (shadow_has_parent(s)) {
+			__le64 location = cpu_to_le64(dm_block_location(shadow_current(s)));
+			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i),
+			       &location, sizeof(__le64));
+		}
+
+		n = dm_block_data(shadow_current(s));
+
+		if (le32_to_cpu(n->header.flags) & LEAF_NODE) {
+			*index = lower_bound(n, key);
+			return 0;
+		}
+
+		r = rebalance_children(s, info, vt, key);
+		if (r)
+			break;
+
+		n = dm_block_data(shadow_current(s));
+		if (le32_to_cpu(n->header.flags) & LEAF_NODE) {
+			*index = lower_bound(n, key);
+			return 0;
+		}
+
+		i = lower_bound(n, key);
+
+		/*
+		 * We know the key is present, or else
+		 * rebalance_children would have returned
+		 * -ENODATA
+		 */
+		root = value64(n, i);
+	}
+
+	return r;
+}
+
+static int remove_one(struct dm_btree_info *info, dm_block_t root,
+		      uint64_t *keys, uint64_t end_key,
+		      dm_block_t *new_root, unsigned *nr_removed)
+{
+	unsigned level, last_level = info->levels - 1;
+	int index = 0, r = 0;
+	struct shadow_spine spine;
+	struct btree_node *n;
+	uint64_t k;
+
+	init_shadow_spine(&spine, info);
+	for (level = 0; level < last_level; level++) {
+		r = remove_raw(&spine, info, &le64_type,
+			       root, keys[level], (unsigned *) &index);
+		if (r < 0)
+			goto out;
+
+		n = dm_block_data(shadow_current(&spine));
+		root = value64(n, index);
+	}
+
+	r = remove_nearest(&spine, info, &info->value_type,
+			   root, keys[last_level], &index);
+	if (r < 0)
+		goto out;
+
+	n = dm_block_data(shadow_current(&spine));
+
+	if (index < 0)
+		index = 0;
+
+	if (index >= le32_to_cpu(n->header.nr_entries)) {
+		r = -ENODATA;
+		goto out;
+	}
+
+	k = le64_to_cpu(n->keys[index]);
+	if (k >= keys[last_level] && k < end_key) {
+		if (info->value_type.dec)
+			info->value_type.dec(info->value_type.context,
+					     value_ptr(n, index));
+
+		delete_at(n, index);
+
+	} else
+		r = -ENODATA;
+
+out:
+	*new_root = shadow_root(&spine);
+	exit_shadow_spine(&spine);
+
+	return r;
+}
+
+int dm_btree_remove_leaves(struct dm_btree_info *info, dm_block_t root,
+			   uint64_t *first_key, uint64_t end_key,
+			   dm_block_t *new_root, unsigned *nr_removed)
+{
+	int r;
+
+	*nr_removed = 0;
+	do {
+		r = remove_one(info, root, first_key, end_key, &root, nr_removed);
+		if (!r)
+			(*nr_removed)++;
+	} while (!r);
+
+	*new_root = root;
+	return r == -ENODATA ? 0 : r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_remove_leaves);
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index dacfc34..11d8cf7 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -135,6 +135,15 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		    uint64_t *keys, dm_block_t *new_root);
 
 /*
+ * Removes values between 'keys' and keys2, where keys2 is keys with the
+ * final key replaced with 'end_key'.  'end_key' is the one-past-the-end
+ * value.  'keys' may be altered.
+ */
+int dm_btree_remove_leaves(struct dm_btree_info *info, dm_block_t root,
+			   uint64_t *keys, uint64_t end_key,
+			   dm_block_t *new_root, unsigned *nr_removed);
+
+/*
  * Returns < 0 on failure.  Otherwise the number of key entries that have
  * been filled out.  Remember trees can have zero entries, and as such have
  * no lowest key.
-- 
2.3.2 (Apple Git-55)
