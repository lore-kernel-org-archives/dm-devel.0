From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 05/14] dm_btree: remove redundant arg from
	value_ptr()
Date: Fri, 16 Mar 2012 15:22:28 +0000
Message-ID: <1331911358-8848-5-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Now that the value_size is held within every node of the btrees we can
remove this argument from value_ptr().

For the last few months a BUG_ON has been checking this argument is
the same as that held in the node.  No issues were reported.  So this
is a safe change.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-btree-internal.h |    7 +----
 drivers/md/persistent-data/dm-btree-remove.c   |   28 ++++++++++++------------
 drivers/md/persistent-data/dm-btree.c          |   27 +++++++++++------------
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index d279c76..5709bfe 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -108,12 +108,9 @@ static inline void *value_base(struct node *n)
 	return &n->keys[le32_to_cpu(n->header.max_entries)];
 }
 
-/*
- * FIXME: Now that value size is stored in node we don't need the third parm.
- */
-static inline void *value_ptr(struct node *n, uint32_t index, size_t value_size)
+static inline void *value_ptr(struct node *n, uint32_t index)
 {
-	BUG_ON(value_size != le32_to_cpu(n->header.value_size));
+	uint32_t value_size = le32_to_cpu(n->header.value_size);
 	return value_base(n) + (value_size * index);
 }
 
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 023fbc2..8576d56 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -61,20 +61,20 @@ static void node_shift(struct node *n, int shift)
 	if (shift < 0) {
 		shift = -shift;
 		BUG_ON(shift > nr_entries);
-		BUG_ON((void *) key_ptr(n, shift) >= value_ptr(n, shift, value_size));
+		BUG_ON((void *) key_ptr(n, shift) >= value_ptr(n, shift));
 		memmove(key_ptr(n, 0),
 			key_ptr(n, shift),
 			(nr_entries - shift) * sizeof(__le64));
-		memmove(value_ptr(n, 0, value_size),
-			value_ptr(n, shift, value_size),
+		memmove(value_ptr(n, 0),
+			value_ptr(n, shift),
 			(nr_entries - shift) * value_size);
 	} else {
 		BUG_ON(nr_entries + shift > le32_to_cpu(n->header.max_entries));
 		memmove(key_ptr(n, shift),
 			key_ptr(n, 0),
 			nr_entries * sizeof(__le64));
-		memmove(value_ptr(n, shift, value_size),
-			value_ptr(n, 0, value_size),
+		memmove(value_ptr(n, shift),
+			value_ptr(n, 0),
 			nr_entries * value_size);
 	}
 }
@@ -91,16 +91,16 @@ static void node_copy(struct node *left, struct node *right, int shift)
 		memcpy(key_ptr(left, nr_left),
 		       key_ptr(right, 0),
 		       shift * sizeof(__le64));
-		memcpy(value_ptr(left, nr_left, value_size),
-		       value_ptr(right, 0, value_size),
+		memcpy(value_ptr(left, nr_left),
+		       value_ptr(right, 0),
 		       shift * value_size);
 	} else {
 		BUG_ON(shift > le32_to_cpu(right->header.max_entries));
 		memcpy(key_ptr(right, 0),
 		       key_ptr(left, nr_left - shift),
 		       shift * sizeof(__le64));
-		memcpy(value_ptr(right, 0, value_size),
-		       value_ptr(left, nr_left - shift, value_size),
+		memcpy(value_ptr(right, 0),
+		       value_ptr(left, nr_left - shift),
 		       shift * value_size);
 	}
 }
@@ -120,8 +120,8 @@ static void delete_at(struct node *n, unsigned index)
 			key_ptr(n, index + 1),
 			nr_to_copy * sizeof(__le64));
 
-		memmove(value_ptr(n, index, value_size),
-			value_ptr(n, index + 1, value_size),
+		memmove(value_ptr(n, index),
+			value_ptr(n, index + 1),
 			nr_to_copy * value_size);
 	}
 
@@ -175,7 +175,7 @@ static int init_child(struct dm_btree_info *info, struct node *parent,
 	if (inc)
 		inc_children(info->tm, result->n, &le64_type);
 
-	*((__le64 *) value_ptr(parent, index, sizeof(__le64))) =
+	*((__le64 *) value_ptr(parent, index)) =
 		cpu_to_le64(dm_block_location(result->block));
 
 	return 0;
@@ -496,7 +496,7 @@ static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 		 */
 		if (shadow_has_parent(s)) {
 			__le64 location = cpu_to_le64(dm_block_location(shadow_current(s)));
-			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i, sizeof(__le64)),
+			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i),
 			       &location, sizeof(__le64));
 		}
 
@@ -553,7 +553,7 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 
 		if (info->value_type.dec)
 			info->value_type.dec(info->value_type.context,
-					     value_ptr(n, index, info->value_type.size));
+					     value_ptr(n, index));
 
 		delete_at(n, index);
 	}
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index bd1e7ff..d12b2cc 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -74,8 +74,7 @@ void inc_children(struct dm_transaction_manager *tm, struct node *n,
 			dm_tm_inc(tm, value64(n, i));
 	else if (vt->inc)
 		for (i = 0; i < nr_entries; i++)
-			vt->inc(vt->context,
-				value_ptr(n, i, vt->size));
+			vt->inc(vt->context, value_ptr(n, i));
 }
 
 static int insert_at(size_t value_size, struct node *node, unsigned index,
@@ -281,7 +280,7 @@ int dm_btree_del(struct dm_btree_info *info, dm_block_t root)
 
 				for (i = 0; i < f->nr_children; i++)
 					info->value_type.dec(info->value_type.context,
-							     value_ptr(f->n, i, info->value_type.size));
+							     value_ptr(f->n, i));
 			}
 			f->current_child = f->nr_children;
 		}
@@ -320,7 +319,7 @@ static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t key,
 	} while (!(flags & LEAF_NODE));
 
 	*result_key = le64_to_cpu(ro_node(s)->keys[i]);
-	memcpy(v, value_ptr(ro_node(s), i, value_size), value_size);
+	memcpy(v, value_ptr(ro_node(s), i), value_size);
 
 	return 0;
 }
@@ -432,7 +431,7 @@ static int btree_split_sibling(struct shadow_spine *s, dm_block_t root,
 
 	size = le32_to_cpu(ln->header.flags) & INTERNAL_NODE ?
 		sizeof(uint64_t) : s->info->value_type.size;
-	memcpy(value_ptr(rn, 0, size), value_ptr(ln, nr_left, size),
+	memcpy(value_ptr(rn, 0), value_ptr(ln, nr_left),
 	       size * nr_right);
 
 	/*
@@ -443,7 +442,7 @@ static int btree_split_sibling(struct shadow_spine *s, dm_block_t root,
 	pn = dm_block_data(parent);
 	location = cpu_to_le64(dm_block_location(left));
 	__dm_bless_for_disk(&location);
-	memcpy_disk(value_ptr(pn, parent_index, sizeof(__le64)),
+	memcpy_disk(value_ptr(pn, parent_index),
 		    &location, sizeof(__le64));
 
 	location = cpu_to_le64(dm_block_location(right));
@@ -529,8 +528,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 
 	size = le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
 		sizeof(__le64) : s->info->value_type.size;
-	memcpy(value_ptr(ln, 0, size), value_ptr(pn, 0, size), nr_left * size);
-	memcpy(value_ptr(rn, 0, size), value_ptr(pn, nr_left, size),
+	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
+	memcpy(value_ptr(rn, 0), value_ptr(pn, nr_left),
 	       nr_right * size);
 
 	/* new_parent should just point to l and r now */
@@ -545,12 +544,12 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 	val = cpu_to_le64(dm_block_location(left));
 	__dm_bless_for_disk(&val);
 	pn->keys[0] = ln->keys[0];
-	memcpy_disk(value_ptr(pn, 0, sizeof(__le64)), &val, sizeof(__le64));
+	memcpy_disk(value_ptr(pn, 0), &val, sizeof(__le64));
 
 	val = cpu_to_le64(dm_block_location(right));
 	__dm_bless_for_disk(&val);
 	pn->keys[1] = rn->keys[0];
-	memcpy_disk(value_ptr(pn, 1, sizeof(__le64)), &val, sizeof(__le64));
+	memcpy_disk(value_ptr(pn, 1), &val, sizeof(__le64));
 
 	/*
 	 * rejig the spine.  This is ugly, since it knows too
@@ -595,7 +594,7 @@ static int btree_insert_raw(struct shadow_spine *s, dm_block_t root,
 			__le64 location = cpu_to_le64(dm_block_location(shadow_current(s)));
 
 			__dm_bless_for_disk(&location);
-			memcpy_disk(value_ptr(dm_block_data(shadow_parent(s)), i, sizeof(uint64_t)),
+			memcpy_disk(value_ptr(dm_block_data(shadow_parent(s)), i),
 				    &location, sizeof(__le64));
 		}
 
@@ -710,12 +709,12 @@ static int insert(struct dm_btree_info *info, dm_block_t root,
 		    (!info->value_type.equal ||
 		     !info->value_type.equal(
 			     info->value_type.context,
-			     value_ptr(n, index, info->value_type.size),
+			     value_ptr(n, index),
 			     value))) {
 			info->value_type.dec(info->value_type.context,
-					     value_ptr(n, index, info->value_type.size));
+					     value_ptr(n, index));
 		}
-		memcpy_disk(value_ptr(n, index, info->value_type.size),
+		memcpy_disk(value_ptr(n, index),
 			    value, info->value_type.size);
 	}
 
-- 
1.7.9.1
