From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/14] dm-multisnap-mikulas-io
Date: Mon,  1 Mar 2010 19:23:54 -0500
Message-ID: <1267489438-6271-11-git-send-email-snitzer@redhat.com>
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

Callbacks from dm-multisnap.c

These functions are called directly from exception-store-neutral code.
The find the chunk or perform chunk reallocations.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-io.c |  209 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-io.c

diff --git a/drivers/md/dm-multisnap-io.c b/drivers/md/dm-multisnap-io.c
new file mode 100644
index 0000000..7620ebe
--- /dev/null
+++ b/drivers/md/dm-multisnap-io.c
@@ -0,0 +1,209 @@
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
+ * This function will check if there is remapping for a given snapid/chunk.
+ * It returns 1 if remapping exists and is read-only (shared by other snapshots)
+ * and 2 if it exists and is read-write (not shared by anyone).
+ */
+int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s,
+				     snapid_t snapid, chunk_t chunk,
+				     int write, chunk_t *result)
+{
+	int r;
+	struct bt_key key;
+	mikulas_snapid_t from, to;
+	mikulas_snapid_t find_from, find_to;
+
+	from = dm_multisnap_find_next_subsnapshot(s, snapid);
+	to = snapid;
+
+	key.chunk = chunk;
+	key.snap_from = snapid;
+	key.snap_to = snapid;
+	r = dm_multisnap_find_in_btree(s, &key, result);
+	if (unlikely(r < 0))
+		return r;
+
+	if (!r) {
+		s->query_new_key.chunk = chunk;
+		s->query_new_key.snap_from = from;
+		s->query_new_key.snap_to = to;
+		s->query_active = 1;
+		return 0;
+	}
+
+	if (!write)
+		return 1;
+
+	/*
+	 * We are writing to a snapshot --- check if anything outside <from-to>
+	 * range exists, if it does, it needs to be copied.
+	 */
+	if (key.snap_from < from) {
+		if (likely(dm_multisnap_find_next_snapid_range(s, key.snap_from,
+							       &find_from, &find_to))) {
+			if (find_from < from) {
+				s->query_new_key.chunk = chunk;
+				s->query_new_key.snap_from = from;
+				s->query_new_key.snap_to = key.snap_to;
+				s->query_block_from = key.snap_from;
+				s->query_block_to = key.snap_to;
+				s->query_active = 2;
+				return 1;
+			}
+			if (unlikely(find_from > from))
+				BUG(); /* SNAPID not in our tree */
+		} else
+			BUG(); /* we're asking for a SNAPID not in our tree */
+	}
+	if (key.snap_to > to) {
+		if (likely(dm_multisnap_find_next_snapid_range(s, to + 1,
+							       &find_from, &find_to))) {
+			if (find_from <= key.snap_to) {
+				s->query_new_key.chunk = chunk;
+				s->query_new_key.snap_from = key.snap_from;
+				s->query_new_key.snap_to = to;
+				s->query_block_from = key.snap_from;
+				s->query_block_to = key.snap_to;
+				s->query_active = 2;
+				return 1;
+			}
+		}
+	}
+	return 2;
+}
+
+/*
+ * Reset the query/remap state machine.
+ */
+void dm_multisnap_reset_query(struct dm_exception_store *s)
+{
+	s->query_active = 0;
+	s->query_snapid = 0;
+}
+
+/*
+ * Find the next snapid range to remap.
+ */
+int dm_multisnap_query_next_remap(struct dm_exception_store *s, chunk_t chunk)
+{
+	int r;
+	chunk_t sink;
+	mikulas_snapid_t from, to;
+
+	s->query_active = 0;
+
+	while (dm_multisnap_find_next_snapid_range(s, s->query_snapid, &from, &to)) {
+		struct bt_key key;
+next_btree_search:
+		if (dm_multisnap_has_error(s->dm))
+			return -1;
+		key.chunk = chunk;
+		key.snap_from = from;
+		key.snap_to = to;
+		r = dm_multisnap_find_in_btree(s, &key, &sink);
+		if (unlikely(r < 0))
+			return -1;
+
+		if (!r) {
+			s->query_new_key.chunk = chunk;
+			s->query_new_key.snap_from = from;
+			s->query_new_key.snap_to = to;
+			s->query_active = 1;
+			return 1;
+		}
+
+		if (key.snap_from > from) {
+			s->query_new_key.chunk = chunk;
+			s->query_new_key.snap_from = from;
+			s->query_new_key.snap_to = key.snap_from - 1;
+			s->query_active = 1;
+			return 1;
+		}
+
+		if (key.snap_to < to) {
+			from = key.snap_to + 1;
+			goto next_btree_search;
+		}
+
+		s->query_snapid = to + 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Perform the remap on the range returned by dm_multisnap_query_next_remap.
+ */
+void dm_multisnap_add_next_remap(struct dm_exception_store *s,
+				 union chunk_descriptor *cd, chunk_t *new_chunk)
+{
+	int r;
+
+	BUG_ON(s->query_active != 1);
+	s->query_active = 0;
+
+	cd->range.from = s->query_new_key.snap_from;
+	cd->range.to = s->query_new_key.snap_to;
+
+	r = dm_multisnap_alloc_blocks(s, new_chunk, 1, 0);
+	if (unlikely(r < 0))
+		return;
+
+	dm_multisnap_status_lock(s->dm);
+	s->data_allocated++;
+	dm_multisnap_status_unlock(s->dm);
+
+	dm_multisnap_add_to_btree(s, &s->query_new_key, *new_chunk);
+	dm_multisnap_transition_mark(s);
+}
+
+/*
+ * Make the chunk writeable (i.e. unshare multiple snapshots).
+ */
+void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s,
+				       union chunk_descriptor *cd, chunk_t *new_chunk)
+{
+	int r;
+
+	BUG_ON(s->query_active != 2);
+	s->query_active = 0;
+
+	cd->range.from = s->query_block_from;
+	cd->range.to = s->query_block_to;
+
+	r = dm_multisnap_alloc_blocks(s, new_chunk, 1, 0);
+	if (unlikely(r < 0))
+		return;
+
+	dm_multisnap_status_lock(s->dm);
+	s->data_allocated++;
+	dm_multisnap_status_unlock(s->dm);
+
+	dm_multisnap_restrict_btree_entry(s, &s->query_new_key);
+	dm_multisnap_transition_mark(s);
+
+	if (unlikely(dm_multisnap_has_error(s->dm)))
+		return;
+
+	dm_multisnap_add_to_btree(s, &s->query_new_key, *new_chunk);
+	dm_multisnap_transition_mark(s);
+}
+
+/*
+ * Check if the snapshot belongs to the remap range specified by "cd".
+ */
+int dm_multisnap_check_conflict(struct dm_exception_store *s,
+				union chunk_descriptor *cd, snapid_t snapid)
+{
+	return snapid >= cd->range.from && snapid <= cd->range.to;
+}
+
-- 
1.6.5.2
