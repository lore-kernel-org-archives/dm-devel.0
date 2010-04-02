From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/7] Avoid struct members with the name 'dm'
Date: Fri,  2 Apr 2010 01:17:55 -0400
Message-ID: <1270185478-8870-5-git-send-email-snitzer@redhat.com>
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

  perl -pi -e 's|ps->dm|ps->s|g' dm-multi*.[ch]

Could just as easily use 'multisnap' rather than 's' for the
'struct dm_multisnap' snapshot pointer.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-multisnap-alloc.c    |   32 +++++++-------
 drivers/md/dm-multisnap-blocks.c   |   14 +++---
 drivers/md/dm-multisnap-btree.c    |   34 ++++++++--------
 drivers/md/dm-multisnap-commit.c   |   26 ++++++------
 drivers/md/dm-multisnap-daniel.c   |   32 +++++++-------
 drivers/md/dm-multisnap-delete.c   |   14 +++---
 drivers/md/dm-multisnap-freelist.c |   20 +++++-----
 drivers/md/dm-multisnap-io.c       |   12 +++---
 drivers/md/dm-multisnap-mikulas.c  |   78 +++++++++++++++++------------------
 drivers/md/dm-multisnap-mikulas.h  |    6 +--
 drivers/md/dm-multisnap-snaps.c    |   62 ++++++++++++++--------------
 drivers/md/dm-multisnap.h          |    2 +-
 12 files changed, 163 insertions(+), 169 deletions(-)

diff --git a/drivers/md/dm-multisnap-alloc.c b/drivers/md/dm-multisnap-alloc.c
index dd9b1d4..1e5a2d0 100644
--- a/drivers/md/dm-multisnap-alloc.c
+++ b/drivers/md/dm-multisnap-alloc.c
@@ -26,13 +26,13 @@ void dm_multisnap_create_bitmaps(struct dm_exception_store *ps, chunk_t *writing
 		(*writing_block)++;
 
 	if (*writing_block >= ps->dev_size) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 				       ("%s: device is too small", __func__));
 		return;
 	}
 
 	if (*writing_block >= ps->chunk_size << BITS_PER_BYTE_SHIFT) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 				       ("%s: invalid block to write: %llx",
 					__func__, (unsigned long long)*writing_block));
 		return;
@@ -40,7 +40,7 @@ void dm_multisnap_create_bitmaps(struct dm_exception_store *ps, chunk_t *writing
 
 	bmp = dm_bufio_new(ps->bufio, *writing_block, &bp);
 	if (IS_ERR(bmp)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(bmp),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(bmp),
 				       ("%s: can't create direct bitmap block at %llx",
 					__func__, (unsigned long long)*writing_block));
 		return;
@@ -49,9 +49,9 @@ void dm_multisnap_create_bitmaps(struct dm_exception_store *ps, chunk_t *writing
 	memset(bmp, 0, ps->chunk_size);
 	for (i = 0; i <= *writing_block; i++) {
 		generic___set_le_bit(i, bmp);
-		dm_multisnap_status_lock(ps->dm);
+		dm_multisnap_status_lock(ps->s);
 		ps->total_allocated++;
-		dm_multisnap_status_unlock(ps->dm);
+		dm_multisnap_status_unlock(ps->s);
 		cond_resched();
 	}
 	ps->bitmap_root = *writing_block;
@@ -81,7 +81,7 @@ void dm_multisnap_extend_bitmaps(struct dm_exception_store *ps, chunk_t new_size
 		chunk_t c = ps->dev_size;
 		if (!i) {
 			dm_multisnap_add_bitmap(ps);
-			if (unlikely(dm_multisnap_has_error(ps->dm)))
+			if (unlikely(dm_multisnap_has_error(ps->s)))
 				return;
 		}
 		bmp = dm_multisnap_map_bitmap(ps, bitmap_no, &bp, NULL, NULL);
@@ -331,7 +331,7 @@ bit_find_failed:
 				bitmap_no = 0;
 				wrap_around++;
 				if (wrap_around >= 2) {
-					DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+					DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 							       ("%s: snapshot overflow", __func__));
 					return -1;
 				}
@@ -343,7 +343,7 @@ bit_find_failed:
 		dm_bufio_release(bp);
 
 		c = dm_multisnap_check_allocated_block(ps, results[i]);
-		if (dm_multisnap_has_error(ps->dm))
+		if (dm_multisnap_has_error(ps->s))
 			return -1;
 
 		bmp = dm_multisnap_read_block(ps, block, &bp);
@@ -369,7 +369,7 @@ find_another_bit_for_bitmap:
 
 		dm_bufio_release(bp);
 		c = dm_multisnap_check_allocated_block(ps, new_block);
-		if (dm_multisnap_has_error(ps->dm))
+		if (dm_multisnap_has_error(ps->s))
 			return -1;
 
 		bmp = dm_multisnap_read_block(ps, block, &bp);
@@ -393,16 +393,16 @@ find_another_bit_for_bitmap:
 			return -1;
 
 		generic___set_le_bit(bit, bmp);
-		dm_multisnap_status_lock(ps->dm);
+		dm_multisnap_status_lock(ps->s);
 		ps->total_allocated++;
-		dm_multisnap_status_unlock(ps->dm);
+		dm_multisnap_status_unlock(ps->s);
 	}
 
 	for (i = 0; i < n_blocks; i++)
 		generic___set_le_bit(results[i] & ((ps->chunk_size << BITS_PER_BYTE_SHIFT) - 1), bmp);
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	ps->total_allocated += n_blocks;
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 
 	dm_bufio_mark_buffer_dirty(bp);
 
@@ -488,7 +488,7 @@ void dm_multisnap_free_blocks_immediate(struct dm_exception_store *ps, chunk_t b
 		return;
 
 	if (unlikely(block + n_blocks > ps->dev_size)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: freeing invalid blocks %llx, %x",
 					__func__, (unsigned long long)block, n_blocks));
 		return;
@@ -506,9 +506,9 @@ void dm_multisnap_free_blocks_immediate(struct dm_exception_store *ps, chunk_t b
 
 		do {
 			generic___clear_le_bit(block & ((ps->chunk_size << BITS_PER_BYTE_SHIFT) - 1), bmp);
-			dm_multisnap_status_lock(ps->dm);
+			dm_multisnap_status_lock(ps->s);
 			ps->total_allocated--;
-			dm_multisnap_status_unlock(ps->dm);
+			dm_multisnap_status_unlock(ps->s);
 			n_blocks--;
 			block++;
 			cond_resched();
diff --git a/drivers/md/dm-multisnap-blocks.c b/drivers/md/dm-multisnap-blocks.c
index 40150e5..d83ee80 100644
--- a/drivers/md/dm-multisnap-blocks.c
+++ b/drivers/md/dm-multisnap-blocks.c
@@ -16,7 +16,7 @@ static int check_invalid(struct dm_exception_store *ps, chunk_t block)
 	if (unlikely(block >= ps->dev_size) ||
 	    unlikely(block == SB_BLOCK) ||
 	    unlikely(dm_multisnap_is_commit_block(ps, block))) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: access to invalid part of the device: "
 					"%llx, size %llx",
 					__func__, (unsigned long long)block,
@@ -73,7 +73,7 @@ void *dm_multisnap_read_block(struct dm_exception_store *ps, chunk_t block,
 
 	buf = dm_bufio_read(ps->bufio, block, bp);
 	if (unlikely(IS_ERR(buf))) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(buf),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(buf),
 				       ("%s: error read chunk %llx",
 					__func__, (unsigned long long)block));
 		return NULL;
@@ -192,7 +192,7 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *ps, chunk_t old_ch
 	t = find_tmp_remap(ps, old_chunk);
 	if (t) {
 		if (unlikely(t->bitmap_idx != bitmap_idx)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: bitmap_idx doesn't match, %X != %X",
 						__func__, t->bitmap_idx, bitmap_idx));
 			return NULL;
@@ -201,7 +201,7 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *ps, chunk_t old_ch
 		t->new = new_chunk;
 	} else {
 		if (unlikely(list_empty(&ps->free_tmp_remaps))) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: all remap blocks used", __func__));
 			return NULL;
 		}
@@ -225,7 +225,7 @@ void *dm_multisnap_duplicate_block(struct dm_exception_store *ps, chunk_t old_ch
 
 	buf = dm_bufio_read(ps->bufio, new_chunk, bp);
 	if (IS_ERR(buf)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(buf),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(buf),
 				       ("%s: error reading chunk %llx",
 					__func__, (unsigned long long)new_chunk));
 		return NULL;
@@ -261,7 +261,7 @@ void *dm_multisnap_make_block(struct dm_exception_store *ps, chunk_t new_chunk,
 
 	buf = dm_bufio_new(ps->bufio, new_chunk, bp);
 	if (unlikely(IS_ERR(buf))) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(buf),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(buf),
 				       ("%s: error creating new block at chunk %llx",
 					__func__, (unsigned long long)new_chunk));
 		return NULL;
@@ -324,7 +324,7 @@ int dm_multisnap_stop_cycles(struct dm_exception_store *ps,
 			     struct stop_cycles *cy, chunk_t key)
 {
 	if (unlikely(cy->key == key) && unlikely(cy->count != 0)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: cycle detected at chunk %llx",
 					__func__, (unsigned long long)key));
 		return -1;
diff --git a/drivers/md/dm-multisnap-btree.c b/drivers/md/dm-multisnap-btree.c
index 2d73851..626940c 100644
--- a/drivers/md/dm-multisnap-btree.c
+++ b/drivers/md/dm-multisnap-btree.c
@@ -26,7 +26,7 @@ dm_multisnap_read_btnode(struct dm_exception_store *ps, int depth,
 
 	if (unlikely(node->signature != BT_SIGNATURE)) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad signature on btree node %llx",
 					__func__, (unsigned long long)block));
 		return NULL;
@@ -35,7 +35,7 @@ dm_multisnap_read_btnode(struct dm_exception_store *ps, int depth,
 	if (unlikely((unsigned)(le32_to_cpu(node->n_entries) - 1) >= ps->btree_entries) ||
 	    (want_entries && unlikely(le32_to_cpu(node->n_entries) != want_entries))) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad number of entries in btree node "
 					"%llx: %x, wanted %x", __func__,
 					(unsigned long long)block,
@@ -92,14 +92,14 @@ void dm_multisnap_create_btree(struct dm_exception_store *ps, chunk_t *writing_b
 		(*writing_block)++;
 
 	if (*writing_block >= ps->dev_size) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 				       ("%s: device is too small", __func__));
 		return;
 	}
 
 	node = dm_bufio_new(ps->bufio, *writing_block, &bp);
 	if (IS_ERR(node)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(node),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(node),
 				       ("%s: cannot create direct bitmap block at %llx",
 					__func__, (unsigned long long)*writing_block));
 		return;
@@ -219,7 +219,7 @@ static int walk_btree(struct dm_exception_store *ps, struct bt_key *key,
 		if (unlikely(last_chunk != want_last_chunk) ||
 		    unlikely(last_snapid != want_last_snapid)) {
 			dm_bufio_release(*bp);
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: invalid last entry in node %llx/%llx: "
 						"last_chunk %llx, want_last_chunk %llx, last_snapid: %llx, "
 						"want_last_snapid: %llx, searching for %llx, %llx-%llx",
@@ -327,7 +327,7 @@ list_next_node:
 			r = compare_key(&node->entries[idx], key);
 			if (unlikely(r <= 0)) {
 				dm_bufio_release(bp);
-				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 						       ("%s: non-monotonic btree: node "
 							"%llx, index %x", __func__,
 							(unsigned long long)path[depth].block, idx));
@@ -374,7 +374,7 @@ void dm_multisnap_add_to_btree(struct dm_exception_store *ps, struct bt_key *key
 	if (unlikely(r)) {
 		if (r > 0) {
 			dm_bufio_release(bp);
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: adding key that already exists: "
 						"%llx, %llx-%llx", __func__,
 						(unsigned long long)key->chunk,
@@ -450,7 +450,7 @@ go_up:
 	}
 
 	if (ps->bt_depth >= MAX_BT_DEPTH) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: max b+-tree depth reached", __func__));
 		return;
 	}
@@ -508,7 +508,7 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *ps,
 		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_from) != old_snapid) ||
 		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_to) != old_snapid)) {
 			dm_bufio_release(bp);
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: btree limit does not match, block %llx, "
 						"idx %x, orig_chunk %llx, snap_from %llx, "
 						"snap_to %llx, want %llx, %llx",
@@ -531,7 +531,7 @@ static void dm_multisnap_fixup_backlimits(struct dm_exception_store *ps,
 		if (path[depth].idx != path[depth].n_entries - 1)
 			return;
 	}
-	DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+	DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 			       ("%s: the last entry modified, %llx/%llx -> %llx/%llx",
 				__func__,
 				(unsigned long long)old_chunk,
@@ -560,7 +560,7 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *ps, struct bt_
 
 	if (!r) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
@@ -584,7 +584,7 @@ void dm_multisnap_restrict_btree_entry(struct dm_exception_store *ps, struct bt_
 		entry->snap_to = cpu_to_mikulas_snapid(new_to);
 	} else {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: invalid range to restrict: "
 					"%llx, %llx-%llx %llx-%llx",
 					__func__,
@@ -623,7 +623,7 @@ void dm_multisnap_extend_btree_entry(struct dm_exception_store *ps, struct bt_ke
 
 	if (!r) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
@@ -679,7 +679,7 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 
 	if (unlikely(!r)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: unknown key: %llx, %llx-%llx",
 					__func__,
 					(unsigned long long)key->chunk,
@@ -696,7 +696,7 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 	to = mikulas_snapid_to_cpu(entry->snap_to);
 	if (unlikely(from != key->snap_from) || unlikely(to != key->snap_to)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: invalid range to restrict: "
 					"%llx, %llx-%llx %llx-%llx",
 					__func__,
@@ -711,7 +711,7 @@ void dm_multisnap_delete_from_btree(struct dm_exception_store *ps, struct bt_key
 	while (unlikely((n_entries = le32_to_cpu(node->n_entries)) == 1)) {
 		dm_bufio_release(bp);
 		if (unlikely(!depth)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: b-tree is empty", __func__));
 			return;
 		}
@@ -805,7 +805,7 @@ void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *ps,
 	      (unsigned long long)key.snap_from);
 	for (i = 0; i < ps->bt_depth; i++)
 		DMERR("path[%d]: %llx/%x", i, (unsigned long long)path[i].block, path[i].idx);
-	dm_multisnap_set_error(ps->dm, -EFSERROR);
+	dm_multisnap_set_error(ps->s, -EFSERROR);
 	return;
 
 found:
diff --git a/drivers/md/dm-multisnap-commit.c b/drivers/md/dm-multisnap-commit.c
index 61bb82f..57c72c5 100644
--- a/drivers/md/dm-multisnap-commit.c
+++ b/drivers/md/dm-multisnap-commit.c
@@ -17,7 +17,7 @@ static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *ps)
 	int i;
 
 	while (ps->n_used_tmp_remaps) {
-		if (dm_multisnap_has_error(ps->dm))
+		if (dm_multisnap_has_error(ps->s))
 			return;
 		if (ps->n_used_tmp_remaps < N_REMAPS - 1) {
 			/*
@@ -41,14 +41,14 @@ static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *ps)
 			dm_multisnap_free_tmp_remap(ps, t);
 			continue;
 		} else {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: no bitmap tmp_remaps, n_used_tmp_remaps %u",
 						__func__, ps->n_used_tmp_remaps));
 			return;
 		}
 	}
 
-	if (dm_multisnap_has_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s))
 		return;
 
 	for (i = ps->n_preallocated_blocks - 1; i >= 0; i--)
@@ -84,7 +84,7 @@ void dm_multisnap_prepare_for_commit(struct dm_exception_store *ps)
 
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: error writing data", __func__));
 		return;
 	}
@@ -114,8 +114,8 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 
 	dm_multisnap_flush_freelist_before_commit(ps);
 
-	if (dm_multisnap_has_error(ps->dm)) {
-		if (!dm_multisnap_drop_on_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s)) {
+		if (!dm_multisnap_drop_on_error(ps->s))
 			return;
 
 		sb = dm_bufio_read(ps->bufio, SB_BLOCK, &bp);
@@ -123,7 +123,7 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 			return;
 
 		if (!le32_to_cpu(sb->error)) {
-			sb->error = cpu_to_le32(dm_multisnap_has_error(ps->dm));
+			sb->error = cpu_to_le32(dm_multisnap_has_error(ps->s));
 			dm_bufio_mark_buffer_dirty(bp);
 		}
 
@@ -139,7 +139,7 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: error writing data", __func__));
 		return;
 	}
@@ -156,7 +156,7 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 
 	cb = dm_bufio_new(ps->bufio, cb_addr, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(cb),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(cb),
 				       ("%s: can't allocate new commit block at %llx",
 					__func__, (unsigned long long)cb_addr));
 		return;
@@ -202,7 +202,7 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 	dm_bufio_release(bp);
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: can't write commit block at %llx",
 					__func__, (unsigned long long)cb_addr));
 		return;
@@ -214,14 +214,14 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 
 	sb = dm_bufio_read(ps->bufio, SB_BLOCK, &bp);
 	if (IS_ERR(sb)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(sb),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(sb),
 				       ("%s: can't read super block", __func__));
 		return;
 	}
 
 	if (unlikely(sb->signature != SB_SIGNATURE)) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: invalid super block signature when committing",
 					__func__));
 		return;
@@ -233,7 +233,7 @@ void dm_multisnap_commit(struct dm_exception_store *ps)
 	dm_bufio_release(bp);
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (unlikely(r < 0)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r, ("%s: can't write super block", __func__));
+		DM_MULTISNAP_SET_ERROR(ps->s, r, ("%s: can't write super block", __func__));
 		return;
 	}
 
diff --git a/drivers/md/dm-multisnap-daniel.c b/drivers/md/dm-multisnap-daniel.c
index 0d6c1b0..4cde432 100644
--- a/drivers/md/dm-multisnap-daniel.c
+++ b/drivers/md/dm-multisnap-daniel.c
@@ -106,7 +106,7 @@ struct commit_callback {
  * The top level structure for a persistent exception store.
  */
 struct dm_exception_store {
-	struct dm_multisnap *dm;
+	struct dm_multisnap *s;
 
 	void *area;
 
@@ -178,7 +178,7 @@ static void free_area(struct dm_exception_store *ps)
 static int chunk_io(struct dm_exception_store *ps, chunk_t chunk, int rw, void *data)
 {
 	struct dm_io_region where = {
-		.bdev = dm_multisnap_snapshot_bdev(ps->dm),
+		.bdev = dm_multisnap_snapshot_bdev(ps->s),
 		.sector = (ps->chunk_size >> SECTOR_SHIFT) * chunk,
 		.count = (ps->chunk_size >> SECTOR_SHIFT),
 	};
@@ -192,7 +192,7 @@ static int chunk_io(struct dm_exception_store *ps, chunk_t chunk, int rw, void *
 
 	int r = dm_io(&io_req, 1, &where, NULL);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r, ("%s: io error when %s %llx: %d",
+		DM_MULTISNAP_SET_ERROR(ps->s, r, ("%s: io error when %s %llx: %d",
 						   __func__,
 						   rw == WRITE ? "writing" : "reading",
 						   (unsigned long long)chunk, r));
@@ -208,8 +208,8 @@ static int write_header(struct dm_exception_store *ps)
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
-	dh->valid = cpu_to_le32(dm_multisnap_drop_on_error(ps->dm) &&
-				dm_multisnap_has_error(ps->dm));
+	dh->valid = cpu_to_le32(dm_multisnap_drop_on_error(ps->s) &&
+				dm_multisnap_has_error(ps->s));
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->chunk_size >> SECTOR_SHIFT);
 
@@ -282,7 +282,7 @@ static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *ps)
 	/* Mikulas: changed to GFP_NOIO */
 	b = kzalloc(sizeof(*b), GFP_NOIO);
 	if (!b) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOMEM,
 				       ("%s %d: out of memory", __func__, __LINE__));
 		return NULL;
 	}
@@ -291,7 +291,7 @@ static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *ps)
 	b->data = __vmalloc(ps->chunk_size, GFP_NOIO | __GFP_HIGHMEM, PAGE_KERNEL);
 	if (!b->data) {
 		kfree(b);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOMEM,
 				       ("%s %d: out of memory", __func__, __LINE__));
 		return NULL;
 	}
@@ -360,7 +360,7 @@ again:
 
 		/* todo: check # free chunks */
 		if (start_chunk == ps->cur_bitmap_chunk) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+			DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 					       ("%s %d: fail to find a new chunk",
 						__func__, __LINE__));
 			return 0;
@@ -385,7 +385,7 @@ static int shared_free_chunk(struct dm_exception_store *ps, chunk_t chunk)
 	chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
 
 	if (!ext2_test_bit(idx, ps->bitmap)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: trying to free free block %lld %lld %u", __func__,
 					(unsigned long long)chunk,
 					(unsigned long long)ps->cur_bitmap_chunk, idx));
@@ -578,7 +578,7 @@ static int shared_read_header(struct dm_exception_store *ps, int *new_snapshot)
 
 	*new_snapshot = 0;
 	if (le32_to_cpu(dh->valid))
-		dm_multisnap_set_error(ps->dm, -EINVAL);
+		dm_multisnap_set_error(ps->s, -EINVAL);
 	ps->version = le32_to_cpu(dh->version);
 
 	ps->root_tree_chunk = le64_to_cpu(dh->root_tree_chunk);
@@ -616,7 +616,7 @@ static void shared_drop_header(struct dm_exception_store *ps)
 static int shared_read_metadata(struct dm_exception_store *ps, char **error)
 {
 	int i, r, uninitialized_var(new_snapshot);
-	size_t size = i_size_read(dm_multisnap_snapshot_bdev(ps->dm)->bd_inode);
+	size_t size = i_size_read(dm_multisnap_snapshot_bdev(ps->s)->bd_inode);
 	chunk_t bitmap_chunk_bytes;
 	unsigned chunk_bytes = ps->chunk_size;
 
@@ -1121,7 +1121,7 @@ static void check_leaf(struct dm_exception_store *ps, struct leaf *leaf, u64 sna
 		for (p = emap(leaf, i); p < emap(leaf, i+1); p++) {
 			/* !!! should also check for any zero sharemaps here */
 			if (le64_to_cpu(p->share) & snapmask) {
-				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 						       ("%s: nonzero bits %016llx outside snapmask %016llx",
 							__func__,
 							(unsigned long long)p->share,
@@ -1444,7 +1444,7 @@ found:
 	return 0;
 }
 
-static int shared_init(struct dm_multisnap *dm, struct dm_exception_store **sp,
+static int shared_init(struct dm_multisnap *s, struct dm_exception_store **sp,
 		       unsigned argc, char **argv, char **error)
 {
 	int r;
@@ -1458,8 +1458,8 @@ static int shared_init(struct dm_multisnap *dm, struct dm_exception_store **sp,
 	}
 	*sp = ps;
 
-	ps->dm = dm;
-	ps->chunk_size = dm_multisnap_chunk_size(dm);
+	ps->s = s;
+	ps->chunk_size = dm_multisnap_chunk_size(s);
 	ps->chunk_shift = ffs(ps->chunk_size) - 1;
 
 	if (argc != 0) {
@@ -1631,7 +1631,7 @@ static void shared_add_next_remap(struct dm_exception_store *ps,
 
 	ret = origin_chunk_unique(buffer2leaf(cb), chunk, ps->snapmask);
 	if (ret) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s %d: bug %llu %d", __func__, __LINE__,
 					(unsigned long long)chunk, ret));
 		return;
diff --git a/drivers/md/dm-multisnap-delete.c b/drivers/md/dm-multisnap-delete.c
index f8a5f67..3644629 100644
--- a/drivers/md/dm-multisnap-delete.c
+++ b/drivers/md/dm-multisnap-delete.c
@@ -87,12 +87,12 @@ static void delete_step(struct dm_exception_store *ps)
 		ps->flags &= ~DM_MULTISNAP_FLAG_DELETING;
 
 		/* If we finished the job and there is no pending I/O, commit */
-		if (dm_multisnap_can_commit(ps->dm))
-			dm_multisnap_call_commit(ps->dm);
+		if (dm_multisnap_can_commit(ps->s))
+			dm_multisnap_call_commit(ps->s);
 
 		return;
 	case RET_DO_FREE:
-		if (unlikely(dm_multisnap_has_error(ps->dm)))
+		if (unlikely(dm_multisnap_has_error(ps->s)))
 			return;
 
 		dm_multisnap_delete_from_btree(ps, &lc.key);
@@ -103,10 +103,10 @@ static void delete_step(struct dm_exception_store *ps)
 
 		/* fall through */
 	case RET_RESCHEDULE:
-		if (dm_multisnap_can_commit(ps->dm)) {
+		if (dm_multisnap_can_commit(ps->s)) {
 			if (++ps->delete_commit_count >= COMMIT_AFTER) {
 				ps->delete_commit_count = 0;
-				dm_multisnap_call_commit(ps->dm);
+				dm_multisnap_call_commit(ps->s);
 			}
 		}
 		return;
@@ -120,7 +120,7 @@ static void delete_step(struct dm_exception_store *ps)
 void dm_multisnap_background_delete(struct dm_exception_store *ps,
 				    struct dm_multisnap_background_work *bw)
 {
-	if (unlikely(dm_multisnap_has_error(ps->dm)))
+	if (unlikely(dm_multisnap_has_error(ps->s)))
 		return;
 
 	if (ps->flags & DM_MULTISNAP_FLAG_DELETING) {
@@ -133,5 +133,5 @@ void dm_multisnap_background_delete(struct dm_exception_store *ps,
 	} else
 		return;
 
-	dm_multisnap_queue_work(ps->dm, &ps->delete_work);
+	dm_multisnap_queue_work(ps->s, &ps->delete_work);
 }
diff --git a/drivers/md/dm-multisnap-freelist.c b/drivers/md/dm-multisnap-freelist.c
index 57e5a1e..2eb6da6 100644
--- a/drivers/md/dm-multisnap-freelist.c
+++ b/drivers/md/dm-multisnap-freelist.c
@@ -37,7 +37,7 @@ static int add_to_freelist(struct dm_exception_store *ps, chunk_t block, unsigne
 		unsigned r = le16_to_cpu(fl->entries[i].run_length) & FREELIST_RL_MASK;
 		unsigned f = le16_to_cpu(fl->entries[i].run_length) & FREELIST_DATA_FLAG;
 		if (block >= x && block < x + r) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: freeing already free block %llx (%llx - %x)",
 						__func__,
 						(unsigned long long)block,
@@ -77,21 +77,21 @@ read_freelist(struct dm_exception_store *ps, chunk_t block, struct dm_buffer **b
 	struct dm_multisnap_freelist *fl;
 	fl = dm_bufio_read(ps->bufio, block, bp);
 	if (IS_ERR(fl)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(fl),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(fl),
 				       ("%s: can't read freelist block %llx",
 					__func__, (unsigned long long)block));
 		return NULL;
 	}
 	if (fl->signature != FL_SIGNATURE) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad signature freelist block %llx",
 					__func__, (unsigned long long)block));
 		return NULL;
 	}
 	if (le32_to_cpu(fl->n_entries) > dm_multisnap_freelist_entries(ps->chunk_size)) {
 		dm_bufio_release(*bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad number of entries in freelist block %llx",
 					__func__, (unsigned long long)block));
 		return NULL;
@@ -114,7 +114,7 @@ static void alloc_write_freelist(struct dm_exception_store *ps)
 
 	fl = dm_bufio_new(ps->bufio, new_block, &bp);
 	if (IS_ERR(fl)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(fl),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(fl),
 				       ("%s: can't make new freelist block %llx",
 					__func__, (unsigned long long)new_block));
 		return;
@@ -140,7 +140,7 @@ void dm_multisnap_free_block(struct dm_exception_store *ps, chunk_t block, unsig
 		return;
 
 	alloc_write_freelist(ps);
-	if (unlikely(dm_multisnap_has_error(ps->dm)))
+	if (unlikely(dm_multisnap_has_error(ps->s)))
 		return;
 
 	if (likely(add_to_freelist(ps, block, flags)))
@@ -229,7 +229,7 @@ void dm_multisnap_flush_freelist_before_commit(struct dm_exception_store *ps)
 {
 	alloc_write_freelist(ps);
 
-	if (dm_multisnap_has_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s))
 		return;
 
 	ps->freelist_ptr = read_48(ps->freelist, backlink);
@@ -248,9 +248,9 @@ static void free_blocks_in_freelist(struct dm_exception_store *ps,
 		unsigned f = le16_to_cpu(fl->entries[i].run_length) & FREELIST_DATA_FLAG;
 		dm_multisnap_free_blocks_immediate(ps, x, r);
 		if (likely(f & FREELIST_DATA_FLAG)) {
-			dm_multisnap_status_lock(ps->dm);
+			dm_multisnap_status_lock(ps->s);
 			ps->data_allocated -= r;
-			dm_multisnap_status_unlock(ps->dm);
+			dm_multisnap_status_unlock(ps->s);
 		}
 		cond_resched();
 	}
@@ -277,7 +277,7 @@ void dm_multisnap_load_freelist(struct dm_exception_store *ps)
 		if (dm_multisnap_stop_cycles(ps, &cy, fl_block))
 			break;
 
-		if (dm_multisnap_has_error(ps->dm))
+		if (dm_multisnap_has_error(ps->s))
 			break;
 
 		fl = read_freelist(ps, fl_block, &bp);
diff --git a/drivers/md/dm-multisnap-io.c b/drivers/md/dm-multisnap-io.c
index 790b636..398184c 100644
--- a/drivers/md/dm-multisnap-io.c
+++ b/drivers/md/dm-multisnap-io.c
@@ -104,7 +104,7 @@ int dm_multisnap_query_next_remap(struct dm_exception_store *ps, chunk_t chunk)
 	while (dm_multisnap_find_next_snapid_range(ps, ps->query_snapid, &from, &to)) {
 		struct bt_key key;
 next_btree_search:
-		if (dm_multisnap_has_error(ps->dm))
+		if (dm_multisnap_has_error(ps->s))
 			return -1;
 		key.chunk = chunk;
 		key.snap_from = from;
@@ -158,9 +158,9 @@ void dm_multisnap_add_next_remap(struct dm_exception_store *ps,
 	if (unlikely(r < 0))
 		return;
 
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	ps->data_allocated++;
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 
 	dm_multisnap_add_to_btree(ps, &ps->query_new_key, *new_chunk);
 	dm_multisnap_transition_mark(ps);
@@ -184,14 +184,14 @@ void dm_multisnap_make_chunk_writeable(struct dm_exception_store *ps,
 	if (unlikely(r < 0))
 		return;
 
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	ps->data_allocated++;
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 
 	dm_multisnap_restrict_btree_entry(ps, &ps->query_new_key);
 	dm_multisnap_transition_mark(ps);
 
-	if (unlikely(dm_multisnap_has_error(ps->dm)))
+	if (unlikely(dm_multisnap_has_error(ps->s)))
 		return;
 
 	dm_multisnap_add_to_btree(ps, &ps->query_new_key, *new_chunk);
diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
index 5ad2035..076068a 100644
--- a/drivers/md/dm-multisnap-mikulas.c
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -62,7 +62,7 @@ static void load_commit_block(struct dm_exception_store *ps)
 
 	cb = dm_bufio_read(ps->bufio, ps->valid_commit_block, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(cb),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(cb),
 				       ("%s: can't re-read commit block %llx",
 					__func__,
 					(unsigned long long)ps->valid_commit_block));
@@ -70,7 +70,7 @@ static void load_commit_block(struct dm_exception_store *ps)
 	}
 	if (cb->signature != CB_SIGNATURE) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad signature when re-reading commit block %llx",
 					__func__,
 					(unsigned long long)ps->valid_commit_block));
@@ -94,7 +94,7 @@ static void load_commit_block(struct dm_exception_store *ps)
 
 	if (ps->bt_depth > MAX_BT_DEPTH || !ps->bt_depth) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: invalid b+-tree depth in commit block %llx",
 					__func__, (unsigned long long)ps->valid_commit_block));
 		return;
@@ -122,14 +122,14 @@ static void load_commit_block(struct dm_exception_store *ps)
 	dm_bufio_release(bp);
 
 	if ((chunk_t)(dev_size + ps->cb_stride) < (chunk_t)dev_size) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ERANGE,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ERANGE,
 				       ("%s: device is too large. Compile kernel with 64-bit sector numbers",
 					__func__));
 		return;
 	}
 	bitmap_depth = dm_multisnap_bitmap_depth(ps->chunk_shift, dev_size);
 	if (bitmap_depth < 0) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, bitmap_depth,
+		DM_MULTISNAP_SET_ERROR(ps->s, bitmap_depth,
 				       ("%s: device is too large", __func__));
 		return;
 	}
@@ -159,14 +159,14 @@ static void find_commit_block(struct dm_exception_store *ps)
 try_next:
 	cb = dm_bufio_read(ps->bufio, cb_addr, &bp);
 	if (IS_ERR(cb)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(cb),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(cb),
 				       ("%s: can't read commit block %llx",
 					__func__, (unsigned long long)cb_addr));
 		return;
 	}
 	if (cb->signature != CB_SIGNATURE) {
 		dm_bufio_release(bp);
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad signature on commit block %llx",
 					__func__, (unsigned long long)cb_addr));
 		return;
@@ -186,7 +186,7 @@ try_next:
 		}
 	}
 	if (!ps->valid_commit_block) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: no valid commit block", __func__));
 		return;
 	}
@@ -198,7 +198,7 @@ try_next:
 static int get_size(struct dm_exception_store *ps, chunk_t *size)
 {
 	__u64 dev_size;
-	dev_size = i_size_read(dm_multisnap_snapshot_bdev(ps->dm)->bd_inode) >> ps->chunk_shift;
+	dev_size = i_size_read(dm_multisnap_snapshot_bdev(ps->s)->bd_inode) >> ps->chunk_shift;
 	*size = dev_size;
 	if ((chunk_t)(dev_size + ps->cb_stride) < dev_size)
 		return -EFBIG;
@@ -222,7 +222,7 @@ static void initialize_device(struct dm_exception_store *ps)
 
 	r = get_size(ps, &ps->dev_size);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: device is too large. Compile kernel with 64-bit sector numbers",
 					__func__));
 		return;
@@ -235,26 +235,26 @@ static void initialize_device(struct dm_exception_store *ps)
 
 	/* Write btree */
 	dm_multisnap_create_btree(ps, &block_to_write);
-	if (dm_multisnap_has_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s))
 		return;
 
 	/* Write bitmaps */
 	dm_multisnap_create_bitmaps(ps, &block_to_write);
-	if (dm_multisnap_has_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s))
 		return;
 
 	ps->dev_size = block_to_write;
 
 	/* Write commit blocks */
 	if (FIRST_CB_BLOCK >= ps->dev_size) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOSPC,
 				       ("%s: device is too small", __func__));
 		return;
 	}
 	for (cb_block = FIRST_CB_BLOCK; cb_block < ps->dev_size; cb_block += ps->cb_stride) {
 		cb = dm_bufio_new(ps->bufio, cb_block, &bp);
 		if (IS_ERR(cb)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(cb),
+			DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(cb),
 					       ("%s: can't allocate commit block at %llx",
 						__func__, (unsigned long long)cb_block));
 			return;
@@ -279,7 +279,7 @@ static void initialize_device(struct dm_exception_store *ps)
 	}
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: write error when initializing device", __func__));
 		return;
 	}
@@ -287,7 +287,7 @@ static void initialize_device(struct dm_exception_store *ps)
 	/* Write super block */
 	sb = dm_bufio_new(ps->bufio, SB_BLOCK, &bp);
 	if (IS_ERR(sb)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(sb),
+		DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(sb),
 				       ("%s: can't allocate super block", __func__));
 		return;
 	}
@@ -301,7 +301,7 @@ static void initialize_device(struct dm_exception_store *ps)
 	dm_bufio_release(bp);
 	r = dm_bufio_write_dirty_buffers(ps->bufio);
 	if (r) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, r,
+		DM_MULTISNAP_SET_ERROR(ps->s, r,
 				       ("%s: can't write super block", __func__));
 		return;
 	}
@@ -325,7 +325,7 @@ static void extend_exception_store(struct dm_exception_store *ps, chunk_t new_si
 			continue;
 		cb = dm_bufio_new(ps->bufio, cb_block, &bp);
 		if (IS_ERR(cb)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, PTR_ERR(cb),
+			DM_MULTISNAP_SET_ERROR(ps->s, PTR_ERR(cb),
 					       ("%s: can't allocate commit block at %llx",
 						__func__, (unsigned long long)cb_block));
 			return;
@@ -384,9 +384,9 @@ re_read:
 		}
 		dm_bufio_release(bp);
 		initialize_device(ps);
-		if (dm_multisnap_has_error(ps->dm)) {
+		if (dm_multisnap_has_error(ps->s)) {
 			*error = "Can't initialize device";
-			return dm_multisnap_has_error(ps->dm);
+			return dm_multisnap_has_error(ps->s);
 		}
 		initialized = 1;
 		goto re_read;
@@ -408,36 +408,36 @@ re_read:
 
 	find_commit_block(ps);
 
-	if (dm_multisnap_has_error(ps->dm)) {
-		if (dm_multisnap_drop_on_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s)) {
+		if (dm_multisnap_drop_on_error(ps->s))
 			return 0;
 		*error = "Unable to find commit block";
-		return dm_multisnap_has_error(ps->dm);
+		return dm_multisnap_has_error(ps->s);
 	}
 
 	load_commit_block(ps);
 
-	if (dm_multisnap_has_error(ps->dm)) {
-		if (dm_multisnap_drop_on_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s)) {
+		if (dm_multisnap_drop_on_error(ps->s))
 			return 0;
 		*error = "Unable to load commit block";
-		return dm_multisnap_has_error(ps->dm);
+		return dm_multisnap_has_error(ps->s);
 	}
 
 	if (e < 0) {
 		/* Don't read the B+-tree if there was an error */
-		DM_MULTISNAP_SET_ERROR(ps->dm, e,
+		DM_MULTISNAP_SET_ERROR(ps->s, e,
 				       ("%s: activating invalidated snapshot store, error %d",
 					__func__, e));
 		return 0;
 	}
 
 	dm_multisnap_read_snapshots(ps);
-	if (dm_multisnap_has_error(ps->dm)) {
-		if (dm_multisnap_drop_on_error(ps->dm))
+	if (dm_multisnap_has_error(ps->s)) {
+		if (dm_multisnap_drop_on_error(ps->s))
 			return 0;
 		*error = "Could not read snapshot list";
-		return dm_multisnap_has_error(ps->dm);
+		return dm_multisnap_has_error(ps->s);
 	}
 
 	return 0;
@@ -459,7 +459,7 @@ static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *ps, in
 	int r;
 	chunk_t new_size;
 
-	if (!dm_multisnap_can_commit(ps->dm))
+	if (!dm_multisnap_can_commit(ps->s))
 		return;
 
 	r = get_size(ps, &new_size);
@@ -468,7 +468,7 @@ static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *ps, in
 
 	if (unlikely(new_size != ps->dev_size)) {
 		if (unlikely(new_size < ps->dev_size)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EINVAL,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EINVAL,
 					       ("%s: device shrank", __func__));
 			return;
 		}
@@ -537,9 +537,7 @@ static void print_bitmaps(struct dm_exception_store *ps)
  * Parse arguments, allocate structures and call read_super to read the data
  * from the disk.
  */
-/* FIXME rename all 'struct dm_multisnap *dm' to be using 's' for snapshot, e.g.: */
-/* dm-multisnap-private.h:dm_multisnap_snap uses 'struct dm_multisnap *s' */
-static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
+static int dm_multisnap_mikulas_init(struct dm_multisnap *s,
 				     struct dm_exception_store **psp,
 				     unsigned argc, char **argv, char **error)
 {
@@ -554,8 +552,8 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
 	}
 	*psp = ps;
 
-	ps->dm = dm;
-	ps->chunk_size = dm_multisnap_chunk_size(dm);
+	ps->s = s;
+	ps->chunk_size = dm_multisnap_chunk_size(s);
 	ps->chunk_shift = ffs(ps->chunk_size) - 1;
 
 	ps->active_snapshots = RB_ROOT;
@@ -609,7 +607,7 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
 		goto bad_freelist;
 	}
 
-	ps->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(ps->dm),
+	ps->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(ps->s),
 					   ps->chunk_size);
 	if (IS_ERR(ps->bufio)) {
 		*error = "Can't create bufio client";
@@ -623,7 +621,7 @@ static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
 
 	if (ps->flags & (DM_MULTISNAP_FLAG_DELETING |
 			DM_MULTISNAP_FLAG_PENDING_DELETE))
-		dm_multisnap_queue_work(ps->dm, &ps->delete_work);
+		dm_multisnap_queue_work(ps->s, &ps->delete_work);
 
 	/* Extend the snapshot store */
 	dm_multisnap_mikulas_lock_acquired(ps, 0);
@@ -657,7 +655,7 @@ static void dm_multisnap_mikulas_exit(struct dm_exception_store *ps)
 {
 	int i;
 
-	dm_multisnap_cancel_work(ps->dm, &ps->delete_work);
+	dm_multisnap_cancel_work(ps->s, &ps->delete_work);
 
 	i = 0;
 	while (!list_empty(&ps->used_bitmap_tmp_remaps)) {
diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
index 3fd78b0..446f37a 100644
--- a/drivers/md/dm-multisnap-mikulas.h
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -60,12 +60,8 @@ struct path_element {
 	unsigned n_entries;
 };
 
-/* FIXME reusing 'dm_exception_store' name lends itself to confusion with legacy snapshots? */
-/* FIXME not to mention, each multisnap stores' 'dm_exception_store' is different */
-/* FIXME rename: dm_multisnap_persistent_exception_store? */
 struct dm_exception_store {
-	/* FIXME rename: multisnap? or just 's' for snapshot? */
-	struct dm_multisnap *dm;
+	struct dm_multisnap *s;
 	/* FIXME rename: bufio_client? */
 	struct dm_bufio_client *bufio;
 
diff --git a/drivers/md/dm-multisnap-snaps.c b/drivers/md/dm-multisnap-snaps.c
index dbac594..8bde4c4 100644
--- a/drivers/md/dm-multisnap-snaps.c
+++ b/drivers/md/dm-multisnap-snaps.c
@@ -48,7 +48,7 @@ go_left:
 					goto go_left;
 				break;
 			} else {
-				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 						       ("%s: inserting overlapping entry: "
 							"(%llx,%llx) overlaps (%llx,%llx)",
 							__func__,
@@ -64,11 +64,11 @@ go_left:
 	if (!add)
 		return found;
 
-	dm_multisnap_status_assert_locked(ps->dm);
+	dm_multisnap_status_assert_locked(ps->s);
 
 	new = kmalloc(sizeof(struct snapshot_range), GFP_KERNEL);
 	if (!new) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+		DM_MULTISNAP_SET_ERROR(ps->s, -ENOMEM,
 				       ("%s: can't allocate memory for snapshot descriptor",
 					__func__));
 		return NULL;
@@ -115,9 +115,9 @@ static int rb_insert_snapshot(struct dm_exception_store *ps,
 			      mikulas_snapid_t from, mikulas_snapid_t to)
 {
 	int r;
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	r = rb_insert_snapshot_unlocked(ps, from, to);
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 	return r;
 }
 
@@ -131,22 +131,22 @@ static int rb_extend_range(struct dm_exception_store *ps,
 	struct snapshot_range *rn;
 	rn = rb_find_insert_snapshot(ps, from, from, 0);
 	if (!rn) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: snapshot %llx not found",
 					__func__, (unsigned long long)from));
 		return -1;
 	}
 	if (rn->to != from) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: bad attempt to extend range: "
 					"%llx >= %llx", __func__,
 					(unsigned long long)rn->to,
 					(unsigned long long)from));
 		return -1;
 	}
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	rn->to = to;
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 	return 0;
 }
 
@@ -162,7 +162,7 @@ static int rb_delete_range(struct dm_exception_store *ps,
 	struct snapshot_range *sr = rb_find_snapshot(ps, from, from);
 
 	if (!sr || sr->to < to) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: deleting non-existing snapid "
 					"%llx-%llx", __func__,
 					(unsigned long long)from,
@@ -170,14 +170,14 @@ static int rb_delete_range(struct dm_exception_store *ps,
 		return -1;
 	}
 
-	dm_multisnap_status_lock(ps->dm);
+	dm_multisnap_status_lock(ps->s);
 	if (sr->from < from) {
 		mikulas_snapid_t orig_to = sr->to;
 		sr->to = from - 1;
 		if (orig_to > to) {
 			if (rb_insert_snapshot_unlocked(ps, to + 1, orig_to)) {
 				sr->to = orig_to;
-				dm_multisnap_status_unlock(ps->dm);
+				dm_multisnap_status_unlock(ps->s);
 				return -1;
 			}
 		}
@@ -189,7 +189,7 @@ static int rb_delete_range(struct dm_exception_store *ps,
 			kfree(sr);
 		}
 	}
-	dm_multisnap_status_unlock(ps->dm);
+	dm_multisnap_status_unlock(ps->s);
 	return 0;
 }
 
@@ -298,7 +298,7 @@ find_next:
 
 	if (r) {
 		if (unlikely(snap_key.snap_to > DM_SNAPID_T_MAX)) {
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: invalid snapshot id", __func__));
 			return;
 		}
@@ -355,13 +355,13 @@ static int dm_multisnap_create_snapid_range(struct dm_exception_store *ps,
 	int r;
 	struct bt_key snap_key;
 
-	if (from && dm_multisnap_snapshot_exists(ps->dm, from - 1)) {
+	if (from && dm_multisnap_snapshot_exists(ps->s, from - 1)) {
 		/* Extend existing key range */
 
 		r = rb_extend_range(ps, from - 1, to);
 
 		if (r < 0)
-			return dm_multisnap_has_error(ps->dm);
+			return dm_multisnap_has_error(ps->s);
 
 		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
 		snap_key.snap_from = from - 1;
@@ -372,15 +372,15 @@ static int dm_multisnap_create_snapid_range(struct dm_exception_store *ps,
 
 		r = rb_insert_snapshot(ps, from, to);
 		if (r < 0)
-			return dm_multisnap_has_error(ps->dm);
+			return dm_multisnap_has_error(ps->s);
 
 		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
 		snap_key.snap_from = from;
 		snap_key.snap_to = to;
 		dm_multisnap_add_to_btree(ps, &snap_key, 0);
 	}
-	if (dm_multisnap_has_error(ps->dm))
-		return dm_multisnap_has_error(ps->dm);
+	if (dm_multisnap_has_error(ps->s))
+		return dm_multisnap_has_error(ps->s);
 
 	dm_multisnap_transition_mark(ps);
 
@@ -399,7 +399,7 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 
 	r = rb_delete_range(ps, from, to);
 	if (r < 0)
-		return dm_multisnap_has_error(ps->dm);
+		return dm_multisnap_has_error(ps->s);
 
 	snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
 	snap_key.snap_from = from;
@@ -408,13 +408,13 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 	r = dm_multisnap_find_in_btree(ps, &snap_key, &ignore);
 	if (r <= 0) {
 		if (!r)
-			DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+			DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 					       ("%s: snapshot id %llx not found in b-tree",
 						__func__, (unsigned long long)from));
-		return dm_multisnap_has_error(ps->dm);
+		return dm_multisnap_has_error(ps->s);
 	}
 	if (snap_key.snap_to < to) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: snapshot id %llx-%llx not found in b-tree",
 					__func__, (unsigned long long)from,
 					(unsigned long long)to));
@@ -427,8 +427,8 @@ static int dm_multisnap_delete_snapid_range(struct dm_exception_store *ps,
 
 		dm_multisnap_transition_mark(ps);
 
-		if (dm_multisnap_has_error(ps->dm))
-			return dm_multisnap_has_error(ps->dm);
+		if (dm_multisnap_has_error(ps->s))
+			return dm_multisnap_has_error(ps->s);
 
 		if (snap_key.snap_to > to) {
 			snap_key.snap_from = to + 1;
@@ -458,7 +458,7 @@ static int dm_multisnap_create_subsnapshot(struct dm_exception_store *ps,
 	snapid_t master, next_sub;
 
 	master = snapid | DM_MIKULAS_SUBSNAPID_MASK;
-	if (!dm_multisnap_snapshot_exists(ps->dm, master)) {
+	if (!dm_multisnap_snapshot_exists(ps->s, master)) {
 		DMERR("%s: master snapshot with id %llx doesn't exist",
 		      __func__, (unsigned long long)snapid);
 		return -EINVAL;
@@ -507,7 +507,7 @@ int dm_multisnap_create_snapshot(struct dm_exception_store *ps, snapid_t snapid)
 		      (unsigned long long)DM_SNAPID_T_MAX);
 		return -EINVAL;
 	}
-	if (dm_multisnap_snapshot_exists(ps->dm, snapid)) {
+	if (dm_multisnap_snapshot_exists(ps->s, snapid)) {
 		DMERR("%s: snapshot with id %llx already exists",
 		      __func__, (unsigned long long)snapid);
 		return -EINVAL;
@@ -531,8 +531,8 @@ int dm_multisnap_delete_snapshot(struct dm_exception_store *ps, snapid_t snapid)
 {
 	int r;
 
-	if (!dm_multisnap_snapshot_exists(ps->dm, snapid)) {
-		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+	if (!dm_multisnap_snapshot_exists(ps->s, snapid)) {
+		DM_MULTISNAP_SET_ERROR(ps->s, -EFSERROR,
 				       ("%s: snapshot id %llx not found in rb-tree",
 					__func__, (unsigned long long)snapid));
 		return -EFSERROR;
@@ -543,7 +543,7 @@ int dm_multisnap_delete_snapshot(struct dm_exception_store *ps, snapid_t snapid)
 		return r;
 
 	ps->flags |= DM_MULTISNAP_FLAG_PENDING_DELETE;
-	dm_multisnap_queue_work(ps->dm, &ps->delete_work);
+	dm_multisnap_queue_work(ps->s, &ps->delete_work);
 
 	dm_multisnap_commit(ps);
 
@@ -583,7 +583,7 @@ void dm_multisnap_get_space(struct dm_exception_store *ps,
 			    unsigned long long *chunks_allocated,
 			    unsigned long long *chunks_metadata_allocated)
 {
-	dm_multisnap_status_assert_locked(ps->dm);
+	dm_multisnap_status_assert_locked(ps->s);
 	*chunks_total = ps->dev_size;
 	*chunks_allocated = ps->total_allocated;
 	*chunks_metadata_allocated = ps->total_allocated - ps->data_allocated;
diff --git a/drivers/md/dm-multisnap.h b/drivers/md/dm-multisnap.h
index 6c7af89..50ce4d8 100644
--- a/drivers/md/dm-multisnap.h
+++ b/drivers/md/dm-multisnap.h
@@ -49,7 +49,7 @@ struct dm_multisnap_exception_store {
 	const char *name;
 
 	/* < 0 - error */
-	int (*init_exception_store)(struct dm_multisnap *dm, struct dm_exception_store **psp,
+	int (*init_exception_store)(struct dm_multisnap *s, struct dm_exception_store **psp,
 				    unsigned argc, char **argv, char **error);
 
 	void (*exit_exception_store)(struct dm_exception_store *ps);
-- 
1.6.6.1
