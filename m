From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/14] dm-multisnap-mikulas-snaps
Date: Mon,  1 Mar 2010 19:23:55 -0500
Message-ID: <1267489438-6271-12-git-send-email-snitzer@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

The management of snapshot ID map.

Red-black tree is used to hold the snapshot ID ranges in memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-snaps.c |  636 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 636 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-snaps.c

diff --git a/drivers/md/dm-multisnap-snaps.c b/drivers/md/dm-multisnap-snaps.c
new file mode 100644
index 0000000..9947673
--- /dev/null
+++ b/drivers/md/dm-multisnap-snaps.c
@@ -0,0 +1,636 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-multisnap-mikulas.h"
+
+/*
+ * In-memory red-black tree denoting the used snapshot IDs.
+ */
+struct snapshot_range {
+	struct rb_node node;
+	mikulas_snapid_t from;
+	mikulas_snapid_t to;
+};
+
+/*
+ * Find a leftmost key in rbtree in the specified range (if add == 0)
+ * or create a new key (if add != 0).
+ */
+static struct snapshot_range *
+rb_find_insert_snapshot(struct dm_exception_store *s,
+			mikulas_snapid_t from, mikulas_snapid_t to, int add)
+{
+	struct snapshot_range *new;
+	struct snapshot_range *found = NULL;
+	struct rb_node **p = &s->active_snapshots.rb_node;
+	struct rb_node *parent = NULL;
+	while (*p) {
+		parent = *p;
+#define rn	rb_entry(parent, struct snapshot_range, node)
+		if (to < rn->from) {
+go_left:
+			p = &rn->node.rb_left;
+		} else if (from > rn->to) {
+			p = &rn->node.rb_right;
+		} else {
+			if (!add) {
+				found = rn;
+		/* If there is range query, we need to find the leftmost node */
+				if (from < rn->from)
+					goto go_left;
+				break;
+			} else {
+				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+						       ("rb_insert_snapshot: inserting overlapping entry: "
+							"(%llx,%llx) overlaps (%llx,%llx)",
+							(unsigned long long)from,
+							(unsigned long long)to,
+							(unsigned long long)rn->from,
+							(unsigned long long)rn->to));
+				return NULL;
+			}
+		}
+#undef rn
+	}
+	if (!add)
+		return found;
+
+	dm_multisnap_status_assert_locked(s->dm);
+
+	new = kmalloc(sizeof(struct snapshot_range), GFP_KERNEL);
+	if (!new) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOMEM,
+				       ("rb_insert_snapshot: can't allocate memory for snapshot descriptor"));
+		return NULL;
+	}
+
+	new->from = from;
+	new->to = to;
+
+	rb_link_node(&new->node, parent, p);
+	rb_insert_color(&new->node, &s->active_snapshots);
+
+	return new;
+}
+
+/*
+ * Find a leftmost key in rbtree in the specified range.
+ */
+static struct snapshot_range *
+rb_find_snapshot(struct dm_exception_store *s,
+		 mikulas_snapid_t from, mikulas_snapid_t to)
+{
+	return rb_find_insert_snapshot(s, from, to, 0);
+}
+
+/*
+ * Insert a range to rbtree. It must not overlap with existing entries.
+ */
+static int rb_insert_snapshot_unlocked(struct dm_exception_store *s,
+				       mikulas_snapid_t from,
+				       mikulas_snapid_t to)
+{
+	struct snapshot_range *rn;
+	rn = rb_find_insert_snapshot(s, from, to, 1);
+	if (!rn)
+		return -1;
+	return 0;
+}
+
+/*
+ * Hold the lock and insert a range to rbtree. It must not overlap with
+ * existing entries.
+ */
+static int rb_insert_snapshot(struct dm_exception_store *s,
+			      mikulas_snapid_t from, mikulas_snapid_t to)
+{
+	int r;
+	dm_multisnap_status_lock(s->dm);
+	r = rb_insert_snapshot_unlocked(s, from, to);
+	dm_multisnap_status_unlock(s->dm);
+	return r;
+}
+
+/*
+ * "from" must be last entry in the existing range. This function extends the
+ * range. The extended area must not overlap with another entry.
+ */
+static int rb_extend_range(struct dm_exception_store *s,
+			   mikulas_snapid_t from, mikulas_snapid_t to)
+{
+	struct snapshot_range *rn;
+	rn = rb_find_insert_snapshot(s, from, from, 0);
+	if (!rn) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_extend_range: snapshot %llx not found",
+					(unsigned long long)from));
+		return -1;
+	}
+	if (rn->to != from) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_extend_range: bad attempt to extend range: "
+					"%llx >= %llx",
+					(unsigned long long)rn->to,
+					(unsigned long long)from));
+		return -1;
+	}
+	dm_multisnap_status_lock(s->dm);
+	rn->to = to;
+	dm_multisnap_status_unlock(s->dm);
+	return 0;
+}
+
+/*
+ * Delete range from the rbtree. The range must be already allocated.
+ *
+ * It is valid to specify a subset of existing range, in this case, the range
+ * is trimmed and possible split to two ranges.
+ */
+static int rb_delete_range(struct dm_exception_store *s,
+			   mikulas_snapid_t from, mikulas_snapid_t to)
+{
+	struct snapshot_range *sr = rb_find_snapshot(s, from, from);
+
+	if (!sr || sr->to < to) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("rb_delete_range: deleting non-existing snapid "
+					"%llx-%llx",
+					(unsigned long long)from,
+					(unsigned long long)to));
+		return -1;
+	}
+
+	dm_multisnap_status_lock(s->dm);
+	if (sr->from < from) {
+		mikulas_snapid_t orig_to = sr->to;
+		sr->to = from - 1;
+		if (orig_to > to) {
+			if (rb_insert_snapshot_unlocked(s, to + 1, orig_to)) {
+				sr->to = orig_to;
+				dm_multisnap_status_unlock(s->dm);
+				return -1;
+			}
+		}
+	} else {
+		if (sr->to > to) {
+			sr->from = to + 1;
+		} else {
+			rb_erase(&sr->node, &s->active_snapshots);
+			kfree(sr);
+		}
+	}
+	dm_multisnap_status_unlock(s->dm);
+	return 0;
+}
+
+/*
+ * If "snapid" is valid snapshot ID, return snapid.
+ * Otherwise, return the next valid snapshot ID.
+ * If there is no next valid snapshot ID, return DM_SNAPID_T_ORIGIN.
+ */
+snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s,
+				      snapid_t snapid)
+{
+	struct snapshot_range *rn;
+
+	rn = rb_find_snapshot(s, snapid, DM_SNAPID_T_MAX);
+	if (!rn)
+		return DM_SNAPID_T_ORIGIN;
+	if (rn->from > snapid)
+		snapid = rn->from;
+	if (rn->to >= (snapid | DM_MIKULAS_SUBSNAPID_MASK))
+		return snapid | DM_MIKULAS_SUBSNAPID_MASK;
+	return snapid;
+}
+
+/*
+ * Find next range.
+ * A wrapper around rb_find_snapshot that is useable in other object files
+ * that don't know about struct snapshot_range.
+ */
+int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s,
+					snapid_t snapid, snapid_t *from,
+					snapid_t *to)
+{
+	struct snapshot_range *rn;
+	rn = rb_find_snapshot(s, snapid, DM_SNAPID_T_MAX);
+	if (!rn)
+		return 0;
+	*from = rn->from;
+	*to = rn->to;
+	return 1;
+}
+
+/*
+ * Return true, if the snapid is master (not subsnapshot).
+ */
+static int dm_multisnap_snapid_is_master(snapid_t snapid)
+{
+	return (snapid & DM_MIKULAS_SUBSNAPID_MASK) == DM_MIKULAS_SUBSNAPID_MASK;
+}
+
+/*
+ * Find the next subsnapshot that is to be created for a snapshot with snapid.
+ *
+ * If it returns snapid, then no subsnapshot can be created.
+ */
+snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s,
+					    snapid_t snapid)
+{
+#ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+	mikulas_snapid_t find_from, find_to;
+	if (unlikely(!dm_multisnap_snapid_is_master(snapid)))
+		return snapid;
+	if (!dm_multisnap_find_next_snapid_range(s, snapid,
+						 &find_from, &find_to))
+		BUG();
+	snapid &= ~DM_MIKULAS_SUBSNAPID_MASK;
+	if (snapid < find_from)
+		snapid = find_from;
+#endif
+	return snapid;
+}
+
+/*
+ * Deallocate the whole rbtree.
+ */
+void dm_multisnap_destroy_snapshot_tree(struct dm_exception_store *s)
+{
+	struct rb_node *root;
+	while ((root = s->active_snapshots.rb_node)) {
+#define rn	rb_entry(root, struct snapshot_range, node)
+		rb_erase(root, &s->active_snapshots);
+		kfree(rn);
+#undef rn
+	}
+}
+
+/*
+ * Populate in-memory rbtree from on-disk b+tree.
+ */
+void dm_multisnap_read_snapshots(struct dm_exception_store *s)
+{
+	struct bt_key snap_key;
+	chunk_t ignore;
+	int r;
+
+	dm_multisnap_destroy_snapshot_tree(s);
+
+	snap_key.snap_from = 0;
+find_next:
+	snap_key.snap_to = DM_SNAPID_T_MAX;
+	snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
+
+	r = dm_multisnap_find_in_btree(s, &snap_key, &ignore);
+
+	if (unlikely(r < 0))
+		return;
+
+	if (r) {
+		if (unlikely(snap_key.snap_to > DM_SNAPID_T_MAX)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_read_snapshots: invalid snapshot id"));
+			return;
+		}
+		r = rb_insert_snapshot(s, snap_key.snap_from, snap_key.snap_to);
+		if (unlikely(r < 0))
+			return;
+		snap_key.snap_from = snap_key.snap_to + 1;
+		goto find_next;
+	}
+}
+
+/*
+ * Allocate next snapshot ID.
+ * If snap_of_snap != 0, allocate a subsnapshot ID for snapshot "master".
+ * Otherwise, allocate a new master snapshot ID.
+ */
+int dm_multisnap_allocate_snapid(struct dm_exception_store *s,
+				 snapid_t *snapid, int snap_of_snap, snapid_t master)
+{
+	if (snap_of_snap) {
+#ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+		if (!dm_multisnap_snapid_is_master(master)) {
+			DMERR("dm_multisnap_allocate_snapid: only two levels of snapshots are supported");
+			return -EOPNOTSUPP;
+		}
+		*snapid = dm_multisnap_find_next_subsnapshot(s, master);
+		if (*snapid == master) {
+			DMERR("dm_multisnap_allocate_snapid: 2^32 snapshots-of-snapshot limit reached");
+			return -ENOSPC;
+		}
+		return 0;
+#else
+		DMERR("dm_multisnap_allocate_snapid: snapshots of snapshots not supported with 32-bit snapshot IDs");
+		return -EOPNOTSUPP;
+#endif
+	}
+	*snapid = ((mikulas_snapid_t)s->snapshot_num << DM_MIKULAS_SNAPID_STEP_BITS) | DM_MIKULAS_SUBSNAPID_MASK;
+	if (s->snapshot_num == 0xffffffff || *snapid > DM_SNAPID_T_MAX) {
+		DMERR("dm_multisnap_allocate_snapid: 2^32 snapshot limit reached");
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+/*
+ * Add a snapid range to in-memory rbtree and on-disk b+tree.
+ * Optionally, merge with the previous range. Don't merge with the next.
+ */
+static int dm_multisnap_create_snapid_range(struct dm_exception_store *s,
+					    snapid_t from, snapid_t to)
+{
+	int r;
+	struct bt_key snap_key;
+
+	if (from && dm_multisnap_snapshot_exists(s->dm, from - 1)) {
+		/* Extend existing key range */
+
+		r = rb_extend_range(s, from - 1, to);
+
+		if (r < 0)
+			return dm_multisnap_has_error(s->dm);
+
+		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
+		snap_key.snap_from = from - 1;
+		snap_key.snap_to = to;
+		dm_multisnap_extend_btree_entry(s, &snap_key);
+	} else {
+		/* Add new entry */
+
+		r = rb_insert_snapshot(s, from, to);
+		if (r < 0)
+			return dm_multisnap_has_error(s->dm);
+
+		snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
+		snap_key.snap_from = from;
+		snap_key.snap_to = to;
+		dm_multisnap_add_to_btree(s, &snap_key, 0);
+	}
+	if (dm_multisnap_has_error(s->dm))
+		return dm_multisnap_has_error(s->dm);
+
+	dm_multisnap_transition_mark(s);
+
+	return 0;
+}
+
+/*
+ * Delete a snapid range from in-memory rbtree and on-disk b+tree.
+ */
+static int dm_multisnap_delete_snapid_range(struct dm_exception_store *s,
+					    snapid_t from, snapid_t to)
+{
+	int r;
+	struct bt_key snap_key;
+	chunk_t ignore;
+
+	r = rb_delete_range(s, from, to);
+	if (r < 0)
+		return dm_multisnap_has_error(s->dm);
+
+	snap_key.chunk = DM_CHUNK_T_SNAP_PRESENT;
+	snap_key.snap_from = from;
+	snap_key.snap_to = from;
+
+	r = dm_multisnap_find_in_btree(s, &snap_key, &ignore);
+	if (r <= 0) {
+		if (!r)
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_delete_snapshot: snapshot id %llx not found in b-tree",
+						(unsigned long long)from));
+		return dm_multisnap_has_error(s->dm);
+	}
+	if (snap_key.snap_to < to) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_snapshot: snapshot id %llx-%llx not found in b-tree",
+					(unsigned long long)from, (unsigned long long)to));
+		return -EFSERROR;
+	}
+
+	if (snap_key.snap_from < from) {
+		snap_key.snap_from = from;
+		dm_multisnap_restrict_btree_entry(s, &snap_key);
+
+		dm_multisnap_transition_mark(s);
+
+		if (dm_multisnap_has_error(s->dm))
+			return dm_multisnap_has_error(s->dm);
+
+		if (snap_key.snap_to > to) {
+			snap_key.snap_from = to + 1;
+			dm_multisnap_add_to_btree(s, &snap_key, 0);
+		}
+	} else {
+		if (snap_key.snap_to > to) {
+			snap_key.snap_to = to;
+			dm_multisnap_restrict_btree_entry(s, &snap_key);
+		} else {
+			dm_multisnap_delete_from_btree(s, &snap_key);
+		}
+	}
+
+	dm_multisnap_transition_mark(s);
+
+	return 0;
+}
+
+/*
+ * Create a subsnapshot.
+ */
+static int dm_multisnap_create_subsnapshot(struct dm_exception_store *s, snapid_t snapid)
+{
+	int r;
+	snapid_t master, next_sub;
+
+	master = snapid | DM_MIKULAS_SUBSNAPID_MASK;
+	if (!dm_multisnap_snapshot_exists(s->dm, master)) {
+		DMERR("dm_multisnap_create_subsnapshot: master snapshot with id %llx doesn't exist",
+		      (unsigned long long)snapid);
+		return -EINVAL;
+	}
+
+	next_sub = dm_multisnap_find_next_subsnapshot(s, master);
+	if (snapid < next_sub) {
+		DMERR("dm_multisnap_create_subsnapshot: invalid subsnapshot id %llx "
+		      "(allowed range %llx - %llx)",
+		      (unsigned long long)snapid,
+		      (unsigned long long)next_sub,
+		      (unsigned long long)master - 1);
+		return -EINVAL;
+	}
+
+	r = dm_multisnap_delete_snapid_range(s, next_sub, snapid);
+	if (r)
+		return r;
+
+	r = dm_multisnap_create_snapid_range(s, snapid, snapid);
+	if (r)
+		return r;
+
+	dm_multisnap_commit(s);
+
+	return 0;
+}
+
+/*
+ * Create a snapshot or subsnapshot with a given snapid.
+ */
+int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid)
+{
+	int r;
+
+	if (!dm_multisnap_snapid_is_master(snapid))
+		return dm_multisnap_create_subsnapshot(s, snapid);
+
+	if ((snapid >> DM_MIKULAS_SNAPID_STEP_BITS) < s->snapshot_num || snapid > DM_SNAPID_T_MAX) {
+		DMERR("dm_multisnap_create_snapshot: invalid snapshot id %llx (allowed range %llx - %llx)",
+			(unsigned long long)snapid,
+			(unsigned long long)s->snapshot_num,
+			(unsigned long long)DM_SNAPID_T_MAX);
+		return -EINVAL;
+	}
+	if (dm_multisnap_snapshot_exists(s->dm, snapid)) {
+		DMERR("dm_multisnap_create_snapshot: snapshot with id %llx already exists",
+		      (unsigned long long)snapid);
+		return -EINVAL;
+	}
+
+	r = dm_multisnap_create_snapid_range(s, snapid - DM_MIKULAS_SUBSNAPID_MASK, snapid);
+	if (r)
+		return r;
+
+	s->snapshot_num = (snapid >> DM_MIKULAS_SNAPID_STEP_BITS) + 1;
+	dm_multisnap_commit(s);
+
+	return 0;
+}
+
+/*
+ * Delete a snapshot or subsnapshot with a given snapid.
+ * Spawn background scanning for entries to delete.
+ */
+int dm_multisnap_delete_snapshot(struct dm_exception_store *s, snapid_t snapid)
+{
+	int r;
+
+	if (!dm_multisnap_snapshot_exists(s->dm, snapid)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_snapshot: snapshot id %llx not found in rb-tree",
+					(unsigned long long)snapid));
+		return -EFSERROR;
+	}
+
+	r = dm_multisnap_delete_snapid_range(s, dm_multisnap_find_next_subsnapshot(s, snapid), snapid);
+	if (r)
+		return r;
+
+	s->flags |= DM_MULTISNAP_FLAG_PENDING_DELETE;
+	dm_multisnap_queue_work(s->dm, &s->delete_work);
+
+	dm_multisnap_commit(s);
+
+	return 0;
+}
+
+/*
+ * Sort the snapids for creating. Sort them linearly except that the master
+ * goes before all subsnapshots.
+ */
+int dm_multisnap_compare_snapids_for_create(const void *p1, const void *p2)
+{
+	mikulas_snapid_t s1 = *(const snapid_t *)p1;
+	mikulas_snapid_t s2 = *(const snapid_t *)p2;
+	mikulas_snapid_t ms1 = s1 >> DM_MIKULAS_SNAPID_STEP_BITS;
+	mikulas_snapid_t ms2 = s2 >> DM_MIKULAS_SNAPID_STEP_BITS;
+	int m1 = dm_multisnap_snapid_is_master(s1);
+	int m2 = dm_multisnap_snapid_is_master(s2);
+	if (ms1 < ms2)
+		return -1;
+	if (ms1 > ms2)
+		return 1;
+	if (m1 != m2)
+		return m2 - m1;
+	if (s1 < s2)
+		return -1;
+	if (s1 > s2)
+		return 1;
+	return 0;
+}
+
+/*
+ * Return the number of total, allocated and metadata chunks.
+ */
+void dm_multisnap_get_space(struct dm_exception_store *s,
+			    unsigned long long *chunks_total,
+			    unsigned long long *chunks_allocated,
+			    unsigned long long *chunks_metadata_allocated)
+{
+	dm_multisnap_status_assert_locked(s->dm);
+	*chunks_total = s->dev_size;
+	*chunks_allocated = s->total_allocated;
+	*chunks_metadata_allocated = s->total_allocated - s->data_allocated;
+}
+
+#ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+
+/*
+ * Convert snapid to user-friendly format (so that he won't see things like
+ * 4294967296).
+ */
+void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string,
+			       unsigned maxlen, snapid_t snapid)
+{
+	unsigned master = snapid >> DM_MIKULAS_SNAPID_STEP_BITS;
+	unsigned subsnap = snapid & DM_MIKULAS_SUBSNAPID_MASK;
+	if (dm_multisnap_snapid_is_master(snapid))
+		snprintf(string, maxlen, "%u", master);
+	else
+		snprintf(string, maxlen, "%u.%u", master, subsnap);
+}
+
+/*
+ * Convert snapid from user-friendly format to the internal 64-bit number.
+ */
+int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string,
+			     snapid_t *snapid, char **error)
+{
+	unsigned long master;
+	unsigned long subsnap;
+	if (!string[0]) {
+err:
+		*error = "Invalid snapshot id";
+		return -EINVAL;
+	}
+
+	master = simple_strtoul(string, &string, 10);
+
+	if (!string[0])
+		subsnap = DM_MIKULAS_SUBSNAPID_MASK;
+	else {
+		if (string[0] != '.' || !string[1])
+			goto err;
+		string++;
+		subsnap = simple_strtoul(string, &string, 10);
+		if (string[0])
+			goto err;
+		if (subsnap >= DM_MIKULAS_SUBSNAPID_MASK) {
+bad_number:
+			*error = "Number out of range";
+			return -EINVAL;
+		}
+	}
+
+	if (master >= DM_SNAPID_T_MAX >> DM_MIKULAS_SNAPID_STEP_BITS)
+		goto bad_number;
+
+	*snapid = (mikulas_snapid_t)master << DM_MIKULAS_SNAPID_STEP_BITS | subsnap;
+	return 0;
+}
+
+#endif
-- 
1.6.5.2
