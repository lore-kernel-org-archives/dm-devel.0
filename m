From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/7] rename snapid members to use 'snapid' names
Date: Fri,  2 Apr 2010 01:17:56 -0400
Message-ID: <1270185478-8870-6-git-send-email-snitzer@redhat.com>
References: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

perl -pi -e 's|snap_from|snapid_from|g' dm-multi*.[ch]
 perl -pi -e 's|snap_to|snapid_to|g' dm-multi*.[ch]

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-multisnap-btree.c          |  112 +++++++++++++++---------------
 drivers/md/dm-multisnap-delete.c         |   14 ++--
 drivers/md/dm-multisnap-io.c             |   54 +++++++-------
 drivers/md/dm-multisnap-mikulas-struct.h |    8 +-
 drivers/md/dm-multisnap-mikulas.c        |    4 +-
 drivers/md/dm-multisnap-mikulas.h        |    5 +-
 drivers/md/dm-multisnap-snaps.c          |   36 +++++-----
 7 files changed, 116 insertions(+), 117 deletions(-)

diff --git a/drivers/md/dm-multisnap-btree.c b/drivers/md/dm-multisnap-btree.c
index 626940c..35b43ec 100644
--- a/drivers/md/dm-multisnap-btree.c
+++ b/drivers/md/dm-multisnap-btree.c
@@ -72,8 +72,8 @@ static void add_at_idx(struct dm_multisnap_bt_node *node, unsigned index,
 		(le32_to_cpu(node->n_entries) - index) * sizeof(struct dm_multisnap_bt_entry));
 	write_orig_chunk(&node->entries[index], key->chunk);
 	write_48(&node->entries[index], new_chunk, new_chunk);
-	node->entries[index].snap_from = cpu_to_mikulas_snapid(key->snap_from);
-	node->entries[index].snap_to = cpu_to_mikulas_snapid(key->snap_to);
+	node->entries[index].snapid_from = cpu_to_mikulas_snapid(key->snapid_from);
+	node->entries[index].snapid_to = cpu_to_mikulas_snapid(key->snapid_to);
 	node->entries[index].flags = cpu_to_le32(0);
 	node->n_entries = cpu_to_le32(le32_to_cpu(node->n_entries) + 1);
 }
@@ -112,7 +112,7 @@ void dm_multisnap_create_btree(struct dm_exception_store *ps, chunk_t *writing_b
 	 * A btree node must have at least one entry --- so create this empty
 	 * one
 	 */
-	new_key.snap_from = new_key.snap_to = DM_SNAPID_T_LAST;
+	new_key.snapid_from = new_key.snapid_to = DM_SNAPID_T_LAST;
 	new_key.chunk = DM_CHUNK_T_LAST;
 	add_at_idx(node, 0, &new_key, 0);
 
@@ -138,9 +138,9 @@ static int compare_key(struct dm_multisnap_bt_entry *e, struct bt_key *key)
 	if (orig_chunk > key->chunk)
 		return 1;
 
-	if (mikulas_snapid_to_cpu(e->snap_to) < key->snap_from)
+	if (mikulas_snapid_to_cpu(e->snapid_to) < key->snapid_from)
 		return -1;
-	if (mikulas_snapid_to_cpu(e->snap_from) > key->snap_to)
+	if (mikulas_snapid_to_cpu(e->snapid_from) > key->snapid_to)
 		return 1;
 
 	return 0;
@@ -215,7 +215,7 @@ static int walk_btree(struct dm_exception_store *ps, struct bt_key *key,
 
 		/* Check consistency (can be commented out) */
 		last_chunk = read_48(&node->entries[path[d].n_entries - 1], orig_chunk);
-		last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].n_entries - 1].snap_to);
+		last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].n_entries - 1].snapid_to);
 		if (unlikely(last_chunk != want_last_chunk) ||
 		    unlikely(last_snapid != want_last_snapid)) {
 			dm_bufio_release(*bp);
@@ -231,15 +231,15 @@ static int walk_btree(struct dm_exception_store *ps, struct bt_key *key,
 						(unsigned long long)last_snapid,
 						(unsigned long long)want_last_snapid,
 						(unsigned long long)key->chunk,
-						(unsigned long long)key->snap_from,
-						(unsigned long long)key->snap_to));
+						(unsigned long long)key->snapid_from,
+						(unsigned long long)key->snapid_to));
 			return -1;
 		}
 
 		r = binary_search(node, key, &path[d].idx);
 
 		want_last_chunk = read_48(&node->entries[path[d].idx], orig_chunk);
-		want_last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].idx].snap_to);
+		want_last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].idx].snapid_to);
 
 		block = read_48(&node->entries[path[d].idx], new_chunk);
 		if (++d == ps->bt_depth)
@@ -274,8 +274,8 @@ int dm_multisnap_find_in_btree(struct dm_exception_store *ps, struct bt_key *key
 		struct dm_multisnap_bt_entry *entry = &node->entries[path[ps->bt_depth - 1].idx];
 		*result = read_48(entry, new_chunk);
 		key->chunk = read_48(entry, orig_chunk);
-		key->snap_from = mikulas_snapid_to_cpu(entry->snap_from);
-		key->snap_to = mikulas_snapid_to_cpu(entry->snap_to);
+		key->snapid_from = mikulas_snapid_to_cpu(entry->snapid_from);
+		key->snapid_to = mikulas_snapid_to_cpu(entry->snapid_to);
 	}
 	dm_bufio_release(bp);
 
@@ -378,8 +378,8 @@ void dm_multisnap_add_to_btree(struct dm_exception_store *ps, struct bt_key *key
 					       ("%s: adding key that already exists: "
 						"%llx, %llx-%llx", __func__,
 						(unsigned long long)key->chunk,
-						(unsigned long long)key->snap_from,
-						(unsigned long long)key->snap_to));
+						(unsigned long long)key->snapid_from,
+						(unsigned long long)key->snapid_to));
 		}
 		return;
 	}
@@ -433,8 +433,8 @@ go_up:
 
 	last_one = &node->entries[split_index - 1];
 	new_key.chunk = read_48(last_one, orig_chunk);
-	new_key.snap_from = mikulas_snapid_to_cpu(last_one->snap_to);
-	new_key.snap_to = mikulas_snapid_to_cpu(last_one->snap_to);
+	new_key.snapid_from = mikulas_snapid_to_cpu(last_one->snapid_to);
+	new_key.snapid_to = mikulas_snapid_to_cpu(last_one->snapid_to);
 
 	key = &new_key;
 
@@ -465,7 +465,7 @@ go_up:
 	node->signature = BT_SIGNATURE;
 	node->n_entries = cpu_to_le32(0);
 	add_at_idx(node, 0, &new_key, new_chunk);
-	new_key.snap_from = new_key.snap_to = DM_SNAPID_T_LAST;
+	new_key.snapid_from = new_key.snapid_to = DM_SNAPID_T_LAST;
 	new_key.chunk = DM_CHUNK_T_LAST;
 	add_at_idx(node, 1, &new_key, path[0].block);
 
@@ -505,25 +505,25 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *ps,
 		idx = path[depth].idx;
 
 		if (unlikely(read_48(&node->entries[idx], orig_chunk) != old_chunk) ||
-		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_from) != old_snapid) ||
-		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_to) != old_snapid)) {
+		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snapid_from) != old_snapid) ||
+		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snapid_to) != old_snapid)) {
 			dm_bufio_release(bp);
 			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: btree limit does not match, block %llx, "
-						"idx %x, orig_chunk %llx, snap_from %llx, "
-						"snap_to %llx, want %llx, %llx",
+						"idx %x, orig_chunk %llx, snapid_from %llx, "
+						"snapid_to %llx, want %llx, %llx",
 						__func__,
 						(unsigned long long)path[depth].block,
 						idx,
 						(unsigned long long)read_48(&node->entries[idx], orig_chunk),
-						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_from),
-						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_to),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snapid_from),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snapid_to),
 						(unsigned long long)old_chunk,
 						(unsigned long long)old_snapid));
 			return;
 		}
 		write_48(&node->entries[idx], orig_chunk, new_chunk);
-		node->entries[idx].snap_from = node->entries[idx].snap_to = cpu_to_mikulas_snapid(new_snapid);
+		node->entries[idx].snapid_from = node->entries[idx].snapid_to = cpu_to_mikulas_snapid(new_snapid);
 
 		dm_bufio_mark_buffer_dirty(bp);
 		dm_bufio_release(bp);
@@ -564,8 +564,8 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *ps, struct bt_
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
-					(unsigned long long)key->snap_from,
-					(unsigned long long)key->snap_to));
+					(unsigned long long)key->snapid_from,
+					(unsigned long long)key->snapid_to));
 		return;
 	}
 
@@ -575,13 +575,13 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *ps, struct bt_
 
 	idx = path[ps->bt_depth - 1].idx;
 	entry = &node->entries[idx];
-	from = mikulas_snapid_to_cpu(entry->snap_from);
-	to = new_to = mikulas_snapid_to_cpu(entry->snap_to);
-	if (key->snap_from == from && key->snap_to < to) {
-		entry->snap_from = cpu_to_mikulas_snapid(key->snap_to + 1);
-	} else if (key->snap_from > from && key->snap_to == to) {
-		new_to = key->snap_from - 1;
-		entry->snap_to = cpu_to_mikulas_snapid(new_to);
+	from = mikulas_snapid_to_cpu(entry->snapid_from);
+	to = new_to = mikulas_snapid_to_cpu(entry->snapid_to);
+	if (key->snapid_from == from && key->snapid_to < to) {
+		entry->snapid_from = cpu_to_mikulas_snapid(key->snapid_to + 1);
+	} else if (key->snapid_from > from && key->snapid_to == to) {
+		new_to = key->snapid_from - 1;
+		entry->snapid_to = cpu_to_mikulas_snapid(new_to);
 	} else {
 		dm_bufio_release(bp);
 		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
@@ -591,8 +591,8 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *ps, struct bt_
 					(unsigned long long)key->chunk,
 					(unsigned long long)from,
 					(unsigned long long)to,
-					(unsigned long long)key->snap_from,
-					(unsigned long long)key->snap_to));
+					(unsigned long long)key->snapid_from,
+					(unsigned long long)key->snapid_to));
 		return;
 	}
 
@@ -627,8 +627,8 @@ void dm_multisnap_extend_btree_entry(struct dm_exception_store *ps, struct bt_ke
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
-					(unsigned long long)key->snap_from,
-					(unsigned long long)key->snap_to));
+					(unsigned long long)key->snapid_from,
+					(unsigned long long)key->snapid_to));
 		return;
 	}
 
@@ -639,13 +639,13 @@ void dm_multisnap_extend_btree_entry(struct dm_exception_store *ps, struct bt_ke
 
 	idx = path[ps->bt_depth - 1].idx;
 	entry = &node->entries[idx];
-	from = mikulas_snapid_to_cpu(entry->snap_from);
-	to = new_to = mikulas_snapid_to_cpu(entry->snap_to);
-	if (key->snap_from < from)
-		entry->snap_from = cpu_to_mikulas_snapid(key->snap_from);
-	if (key->snap_to > to) {
-		new_to = key->snap_to;
-		entry->snap_to = cpu_to_mikulas_snapid(new_to);
+	from = mikulas_snapid_to_cpu(entry->snapid_from);
+	to = new_to = mikulas_snapid_to_cpu(entry->snapid_to);
+	if (key->snapid_from < from)
+		entry->snapid_from = cpu_to_mikulas_snapid(key->snapid_from);
+	if (key->snapid_to > to) {
+		new_to = key->snapid_to;
+		entry->snapid_to = cpu_to_mikulas_snapid(new_to);
 	}
 
 	dm_bufio_mark_buffer_dirty(bp);
@@ -671,7 +671,7 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 
 	struct dm_multisnap_bt_entry *last_one;
 	chunk_t last_one_chunk;
-	mikulas_snapid_t last_one_snap_to;
+	mikulas_snapid_t last_one_snapid_to;
 
 	int r = walk_btree(ps, key, &node, &bp, path);
 	if (unlikely(r < 0))
@@ -683,8 +683,8 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
-					(unsigned long long)key->snap_from,
-					(unsigned long long)key->snap_to));
+					(unsigned long long)key->snapid_from,
+					(unsigned long long)key->snapid_to));
 		return;
 	}
 
@@ -692,9 +692,9 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 
 	idx = path[depth].idx;
 	entry = &node->entries[idx];
-	from = mikulas_snapid_to_cpu(entry->snap_from);
-	to = mikulas_snapid_to_cpu(entry->snap_to);
-	if (unlikely(from != key->snap_from) || unlikely(to != key->snap_to)) {
+	from = mikulas_snapid_to_cpu(entry->snapid_from);
+	to = mikulas_snapid_to_cpu(entry->snapid_to);
+	if (unlikely(from != key->snapid_from) || unlikely(to != key->snapid_to)) {
 		dm_bufio_release(bp);
 		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: invalid range to restrict: "
@@ -703,8 +703,8 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 					(unsigned long long)key->chunk,
 					(unsigned long long)from,
 					(unsigned long long)to,
-					(unsigned long long)key->snap_from,
-					(unsigned long long)key->snap_to));
+					(unsigned long long)key->snapid_from,
+					(unsigned long long)key->snapid_to));
 		return;
 	}
 
@@ -740,15 +740,15 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 
 	last_one = &node->entries[n_entries - 1];
 	last_one_chunk = read_48(last_one, orig_chunk);
-	last_one_snap_to = mikulas_snapid_to_cpu(last_one->snap_to);
+	last_one_snapid_to = mikulas_snapid_to_cpu(last_one->snapid_to);
 
 	dm_bufio_mark_buffer_dirty(bp);
 	dm_bufio_release(bp);
 
 	if (unlikely(idx == n_entries))
 		dm_multisnap_fixup_backlimits(ps, path, depth, key->chunk,
-					      key->snap_to, last_one_chunk,
-					      last_one_snap_to);
+					      key->snapid_to, last_one_chunk,
+					      last_one_snapid_to);
 }
 
 /*
@@ -785,7 +785,7 @@ void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *ps,
 	if (!node)
 		return;
 	key.chunk = read_48(&node->entries[0], orig_chunk);
-	key.snap_from = key.snap_to = mikulas_snapid_to_cpu(node->entries[0].snap_from);
+	key.snapid_from = key.snapid_to = mikulas_snapid_to_cpu(node->entries[0].snapid_from);
 	dm_bufio_release(bp);
 
 	r = walk_btree(ps, &key, &node, &bp, path);
@@ -802,7 +802,7 @@ void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *ps,
 	      (unsigned long long)tmp_remap->old,
 	      (unsigned long long)tmp_remap->new,
 	      (unsigned long long)key.chunk,
-	      (unsigned long long)key.snap_from);
+	      (unsigned long long)key.snapid_from);
 	for (i = 0; i < ps->bt_depth; i++)
 		DMERR("path[%d]: %llx/%x", i, (unsigned long long)path[i].block, path[i].idx);
 	dm_multisnap_set_error(ps->s, -EFSERROR);
diff --git a/drivers/md/dm-multisnap-delete.c b/drivers/md/dm-multisnap-delete.c
index 3644629..faa4740 100644
--- a/drivers/md/dm-multisnap-delete.c
+++ b/drivers/md/dm-multisnap-delete.c
@@ -32,20 +32,20 @@ static int list_callback(struct dm_exception_store *ps,
 	mikulas_snapid_t found_from, found_to;
 
 	lc->key.chunk = read_48(bt, orig_chunk);
-	lc->key.snap_from = mikulas_snapid_to_cpu(bt->snap_from);
-	lc->key.snap_to = mikulas_snapid_to_cpu(bt->snap_to);
+	lc->key.snapid_from = mikulas_snapid_to_cpu(bt->snapid_from);
+	lc->key.snapid_to = mikulas_snapid_to_cpu(bt->snapid_to);
 
 	if (unlikely(lc->key.chunk > DM_CHUNK_T_MAX))
 		return RET_END;
 
 	ps->delete_rover_chunk = lc->key.chunk;
-	ps->delete_rover_snapid = lc->key.snap_to + 1;
+	ps->delete_rover_snapid = lc->key.snapid_to + 1;
 	if (unlikely(!ps->delete_rover_snapid))
 		ps->delete_rover_chunk++;
 
-	if (!dm_multisnap_find_next_snapid_range(ps, lc->key.snap_from,
+	if (!dm_multisnap_find_next_snapid_range(ps, lc->key.snapid_from,
 						 &found_from, &found_to) ||
-	    found_from > lc->key.snap_to) {
+	    found_from > lc->key.snapid_to) {
 		/*
 		 * This range maps unused snapshots, delete it.
 		 * But we can't do it now, so submit it to the caller;
@@ -73,8 +73,8 @@ static void delete_step(struct dm_exception_store *ps)
 	struct list_cookie lc;
 
 	key.chunk = ps->delete_rover_chunk;
-	key.snap_from = ps->delete_rover_snapid;
-	key.snap_to = ps->delete_rover_snapid;
+	key.snapid_from = ps->delete_rover_snapid;
+	key.snapid_to = ps->delete_rover_snapid;
 
 	r = dm_multisnap_list_btree(ps, &key, list_callback, &lc);
 
diff --git a/drivers/md/dm-multisnap-io.c b/drivers/md/dm-multisnap-io.c
index 398184c..9638b01 100644
--- a/drivers/md/dm-multisnap-io.c
+++ b/drivers/md/dm-multisnap-io.c
@@ -26,16 +26,16 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *ps,
 	to = snapid;
 
 	key.chunk = chunk;
-	key.snap_from = snapid;
-	key.snap_to = snapid;
+	key.snapid_from = snapid;
+	key.snapid_to = snapid;
 	r = dm_multisnap_find_in_btree(ps, &key, result);
 	if (unlikely(r < 0))
 		return r;
 
 	if (!r) {
 		ps->query_new_key.chunk = chunk;
-		ps->query_new_key.snap_from = from;
-		ps->query_new_key.snap_to = to;
+		ps->query_new_key.snapid_from = from;
+		ps->query_new_key.snapid_to = to;
 		ps->query_active = 1;
 		return 0;
 	}
@@ -47,15 +47,15 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *ps,
 	 * We are writing to a snapshot --- check if anything outside <from-to>
 	 * range exists, if it does, it needs to be copied.
 	 */
-	if (key.snap_from < from) {
-		if (likely(dm_multisnap_find_next_snapid_range(ps, key.snap_from,
+	if (key.snapid_from < from) {
+		if (likely(dm_multisnap_find_next_snapid_range(ps, key.snapid_from,
 							       &find_from, &find_to))) {
 			if (find_from < from) {
 				ps->query_new_key.chunk = chunk;
-				ps->query_new_key.snap_from = from;
-				ps->query_new_key.snap_to = key.snap_to;
-				ps->query_block_from = key.snap_from;
-				ps->query_block_to = key.snap_to;
+				ps->query_new_key.snapid_from = from;
+				ps->query_new_key.snapid_to = key.snapid_to;
+				ps->query_block_from = key.snapid_from;
+				ps->query_block_to = key.snapid_to;
 				ps->query_active = 2;
 				return 1;
 			}
@@ -64,15 +64,15 @@ int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *ps,
 		} else
 			BUG(); /* we're asking for a SNAPID not in our tree */
 	}
-	if (key.snap_to > to) {
+	if (key.snapid_to > to) {
 		if (likely(dm_multisnap_find_next_snapid_range(ps, to + 1,
 							       &find_from, &find_to))) {
-			if (find_from <= key.snap_to) {
+			if (find_from <= key.snapid_to) {
 				ps->query_new_key.chunk = chunk;
-				ps->query_new_key.snap_from = key.snap_from;
-				ps->query_new_key.snap_to = to;
-				ps->query_block_from = key.snap_from;
-				ps->query_block_to = key.snap_to;
+				ps->query_new_key.snapid_from = key.snapid_from;
+				ps->query_new_key.snapid_to = to;
+				ps->query_block_from = key.snapid_from;
+				ps->query_block_to = key.snapid_to;
 				ps->query_active = 2;
 				return 1;
 			}
@@ -107,30 +107,30 @@ next_btree_search:
 		if (dm_multisnap_has_error(ps->s))
 			return -1;
 		key.chunk = chunk;
-		key.snap_from = from;
-		key.snap_to = to;
+		key.snapid_from = from;
+		key.snapid_to = to;
 		r = dm_multisnap_find_in_btree(ps, &key, &sink);
 		if (unlikely(r < 0))
 			return -1;
 
 		if (!r) {
 			ps->query_new_key.chunk = chunk;
-			ps->query_new_key.snap_from = from;
-			ps->query_new_key.snap_to = to;
+			ps->query_new_key.snapid_from = from;
+			ps->query_new_key.snapid_to = to;
 			ps->query_active = 1;
 			return 1;
 		}
 
-		if (key.snap_from > from) {
+		if (key.snapid_from > from) {
 			ps->query_new_key.chunk = chunk;
-			ps->query_new_key.snap_from = from;
-			ps->query_new_key.snap_to = key.snap_from - 1;
+			ps->query_new_key.snapid_from = from;
+			ps->query_new_key.snapid_to = key.snapid_from - 1;
 			ps->query_active = 1;
 			return 1;
 		}
 
-		if (key.snap_to < to) {
-			from = key.snap_to + 1;
+		if (key.snapid_to < to) {
+			from = key.snapid_to + 1;
 			goto next_btree_search;
 		}
 
@@ -151,8 +151,8 @@ void dm_multisnap_add_next_remap(struct dm_exception_store *ps,
 	BUG_ON(ps->query_active != 1);
 	ps->query_active = 0;
 
-	cd->range.from = ps->query_new_key.snap_from;
-	cd->range.to = ps->query_new_key.snap_to;
+	cd->range.from = ps->query_new_key.snapid_from;
+	cd->range.to = ps->query_new_key.snapid_to;
 
 	r = dm_multisnap_alloc_blocks(ps, new_chunk, 1, 0);
 	if (unlikely(r < 0))
diff --git a/drivers/md/dm-multisnap-mikulas-struct.h b/drivers/md/dm-multisnap-mikulas-struct.h
index 39eaa16..b558429 100644
--- a/drivers/md/dm-multisnap-mikulas-struct.h
+++ b/drivers/md/dm-multisnap-mikulas-struct.h
@@ -109,7 +109,7 @@
  * so that the node fits into one chunk.
  *
  * The internal nodes have the same structure as the leaf nodes, except that:
- * Both snapshot ID range entries (snap_from and snap_to) must be equal.
+ * Both snapshot ID range entries (snapid_from and snapid_to) must be equal.
  * New_chunk is really pointer to the subordinate b+tree node.
  *
  * The pointer to the root node and the depth of the b+tree is stored in the
@@ -321,7 +321,7 @@ static inline int dm_multisnap_bitmap_depth(unsigned chunk_shift, __u64 device_s
 }
 
 
-/* B+-tree entry. Sorted by orig_chunk and snap_from/to */
+/* B+-tree entry. Sorted by orig_chunk and snapid_from/to */
 
 #define MAX_BT_DEPTH		12
 
@@ -331,8 +331,8 @@ struct dm_multisnap_bt_entry {
 	__u16 new_chunk2;
 	__u32 new_chunk1;
 	__u32 flags;
-	mikulas_snapid_t snap_from;
-	mikulas_snapid_t snap_to;
+	mikulas_snapid_t snapid_from;
+	mikulas_snapid_t snapid_to;
 };
 
 #define BT_SIGNATURE	cpu_to_be32(0xF6014254)
diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
index 076068a..182c4c3 100644
--- a/drivers/md/dm-multisnap-mikulas.c
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -489,8 +489,8 @@ static int print_btree_callback(struct dm_exception_store *ps,
 {
 	printk(KERN_DEBUG "entry: %llx, %llx-%llx -> %llx\n",
 		(unsigned long long)read_48(bt, orig_chunk),
-		(unsigned long long)cpu_to_mikulas_snapid(bt->snap_from),
-		(unsigned long long)cpu_to_mikulas_snapid(bt->snap_to),
+		(unsigned long long)cpu_to_mikulas_snapid(bt->snapid_from),
+		(unsigned long long)cpu_to_mikulas_snapid(bt->snapid_to),
 		(unsigned long long)read_48(bt, new_chunk));
 	return 0;
 }
diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
index 446f37a..fb5bf03 100644
--- a/drivers/md/dm-multisnap-mikulas.h
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -49,9 +49,8 @@ struct tmp_remap {
 
 struct bt_key {
 	chunk_t chunk;
-	/* FIXME rename: snapid_{from,to}? */
-	mikulas_snapid_t snap_from;
-	mikulas_snapid_t snap_to;
+	mikulas_snapid_t snapid_from;
+	mikulas_snapid_t snapid_to;
 };
 
 struct path_element {
diff --git a/drivers/md/dm-multisnap-snaps.c b/drivers/md/dm-multisnap-snaps.c
index 8bde4c4..0ae8db5 100644
--- a/drivers/md/dm-multisnap-snaps.c
+++ b/drivers/md/dm-multisnap-snaps.c
@@ -286,9 +286,9 @@ void dm_multisnap_read_snapshots(struct dm_exception_store *ps)
 
 	dm_multisnap_destroy_snapshot_tree(ps);
 
-	snap_key.snap_from = 0;
+	snap_key.snapid_from = 0;
 find_next:
-	snap_key.snap_to = DM_SNAPID_T_MAX;
+	snap_key.snapid_to = DM_SNAPID_T_MAX;
 	snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
 
 	r = dm_multisnap_find_in_btree(ps, &snap_key, &ignore);
@@ -297,15 +297,15 @@ find_next:
 		return;
 
 	if (r) {
-		if (unlikely(snap_key.snap_to > DM_SNAPID_T_MAX)) {
+		if (unlikely(snap_key.snapid_to > DM_SNAPID_T_MAX)) {
 			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: invalid snapshot id", __func__));
 			return;
 		}
-		r = rb_insert_snapshot(ps, snap_key.snap_from, snap_key.snap_to);
+		r = rb_insert_snapshot(ps, snap_key.snapid_from, snap_key.snapid_to);
 		if (unlikely(r < 0))
 			return;
-		snap_key.snap_from = snap_key.snap_to + 1;
+		snap_key.snapid_from = snap_key.snapid_to + 1;
 		goto find_next;
 	}
 }
@@ -364,8 +364,8 @@ static int dm_multisnap_create_snapid_range(struct dm_exception_store *ps,
 			return dm_multisnap_has_error(ps->s);
 
 		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
-		snap_key.snap_from = from - 1;
-		snap_key.snap_to = to;
+		snap_key.snapid_from = from - 1;
+		snap_key.snapid_to = to;
 		dm_multisnap_extend_btree_entry(ps, &snap_key);
 	} else {
 		/* Add new entry */
@@ -375,8 +375,8 @@ static int dm_multisnap_create_snapid_range(struct dm_exception_store *ps,
 			return dm_multisnap_has_error(ps->s);
 
 		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
-		snap_key.snap_from = from;
-		snap_key.snap_to = to;
+		snap_key.snapid_from = from;
+		snap_key.snapid_to = to;
 		dm_multisnap_add_to_btree(ps, &snap_key, 0);
 	}
 	if (dm_multisnap_has_error(ps->s))
@@ -402,8 +402,8 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 		return dm_multisnap_has_error(ps->s);
 
 	snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
-	snap_key.snap_from = from;
-	snap_key.snap_to = from;
+	snap_key.snapid_from = from;
+	snap_key.snapid_to = from;
 
 	r = dm_multisnap_find_in_btree(ps, &snap_key, &ignore);
 	if (r <= 0) {
@@ -413,7 +413,7 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 						__func__, (unsigned long long)from));
 		return dm_multisnap_has_error(ps->s);
 	}
-	if (snap_key.snap_to < to) {
+	if (snap_key.snapid_to < to) {
 		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: snapshot id %llx-%llx not found in b-tree",
 					__func__, (unsigned long long)from,
@@ -421,8 +421,8 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 		return -EFSERROR;
 	}
 
-	if (snap_key.snap_from < from) {
-		snap_key.snap_from = from;
+	if (snap_key.snapid_from < from) {
+		snap_key.snapid_from = from;
 		dm_multisnap_restrict_btree_entry(ps, &snap_key);
 
 		dm_multisnap_transition_mark(ps);
@@ -430,13 +430,13 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 		if (dm_multisnap_has_error(ps->s))
 			return dm_multisnap_has_error(ps->s);
 
-		if (snap_key.snap_to > to) {
-			snap_key.snap_from = to + 1;
+		if (snap_key.snapid_to > to) {
+			snap_key.snapid_from = to + 1;
 			dm_multisnap_add_to_btree(ps, &snap_key, 0);
 		}
 	} else {
-		if (snap_key.snap_to > to) {
-			snap_key.snap_to = to;
+		if (snap_key.snapid_to > to) {
+			snap_key.snapid_to = to;
 			dm_multisnap_restrict_btree_entry(ps, &snap_key);
 		} else {
 			dm_multisnap_delete_from_btree(ps, &snap_key);
-- 
1.6.6.1
