From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 08/14] dm-multisnap-mikulas-delete
Date: Mon,  1 Mar 2010 19:23:52 -0500
Message-ID: <1267489438-6271-9-git-send-email-snitzer@redhat.com>
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

Background delete operation.

Scan the b+tree on background and find entries that have unused snapshot IDs.
Delete these entries and the associated chunks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-delete.c |  137 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-delete.c

diff --git a/drivers/md/dm-multisnap-delete.c b/drivers/md/dm-multisnap-delete.c
new file mode 100644
index 0000000..22705a3
--- /dev/null
+++ b/drivers/md/dm-multisnap-delete.c
@@ -0,0 +1,137 @@
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
+ * Commit after this number of deleted entries.
+ * Too big number causes spurious overflows on nearly-full device.
+ * Too small number degrades delete performance.
+ */
+#define COMMIT_AFTER		128
+
+struct list_cookie {
+	struct bt_key key;
+	chunk_t new_chunk;
+};
+
+#define RET_END			1
+#define RET_DO_FREE		2
+#define RET_RESCHEDULE		3
+
+static int list_callback(struct dm_exception_store *s,
+			 struct dm_multisnap_bt_node *node,
+			 struct dm_multisnap_bt_entry *bt, void *cookie)
+{
+	struct list_cookie *lc = cookie;
+	mikulas_snapid_t found_from, found_to;
+
+	lc->key.chunk = read_48(bt, orig_chunk);
+	lc->key.snap_from = mikulas_snapid_to_cpu(bt->snap_from);
+	lc->key.snap_to = mikulas_snapid_to_cpu(bt->snap_to);
+
+	if (unlikely(lc->key.chunk > DM_CHUNK_T_MAX))
+		return RET_END;
+
+	s->delete_rover_chunk = lc->key.chunk;
+	s->delete_rover_snapid = lc->key.snap_to + 1;
+	if (unlikely(!s->delete_rover_snapid))
+		s->delete_rover_chunk++;
+
+	if (!dm_multisnap_find_next_snapid_range(s, lc->key.snap_from,
+						 &found_from, &found_to) ||
+	    found_from > lc->key.snap_to) {
+		/*
+		 * This range maps unused snapshots, delete it.
+		 * But we can't do it now, so submit it to the caller;
+		 */
+		lc->new_chunk = read_48(bt, new_chunk);
+		return RET_DO_FREE;
+	}
+
+	/*
+	 * If we are at a last entry in the btree node, drop the lock and
+	 * allow other requests to be processed.
+	 *
+	 * This avoids a starvation when there are no nodes to delete.
+	 */
+	if (bt == &node->entries[le32_to_cpu(node->n_entries) - 1])
+		return RET_RESCHEDULE;
+
+	return 0;
+}
+
+static void delete_step(struct dm_exception_store *s)
+{
+	struct bt_key key;
+	int r;
+	struct list_cookie lc;
+
+	key.chunk = s->delete_rover_chunk;
+	key.snap_from = s->delete_rover_snapid;
+	key.snap_to = s->delete_rover_snapid;
+
+	r = dm_multisnap_list_btree(s, &key, list_callback, &lc);
+
+	if (unlikely(r < 0))
+		return;
+
+	switch (r) {
+
+	case RET_END:
+		s->flags &= ~DM_MULTISNAP_FLAG_DELETING;
+
+		/* If we finished the job and there is no pending I/O, commit */
+		if (dm_multisnap_can_commit(s->dm))
+			dm_multisnap_call_commit(s->dm);
+
+		return;
+	case RET_DO_FREE:
+		if (unlikely(dm_multisnap_has_error(s->dm)))
+			return;
+
+		dm_multisnap_delete_from_btree(s, &lc.key);
+
+		dm_multisnap_transition_mark(s);
+
+		dm_multisnap_free_block(s, lc.new_chunk, FREELIST_DATA_FLAG);
+
+		/* fall through */
+	case RET_RESCHEDULE:
+		if (dm_multisnap_can_commit(s->dm)) {
+			if (++s->delete_commit_count >= COMMIT_AFTER) {
+				s->delete_commit_count = 0;
+				dm_multisnap_call_commit(s->dm);
+			}
+		}
+		return;
+	default:
+		printk(KERN_CRIT "delete_step: invalid return value %d", r);
+		BUG();
+
+	}
+}
+
+void dm_multisnap_background_delete(struct dm_exception_store *s,
+				    struct dm_multisnap_background_work *bw)
+{
+	if (unlikely(dm_multisnap_has_error(s->dm)))
+		return;
+
+	if (s->flags & DM_MULTISNAP_FLAG_DELETING) {
+		delete_step(s);
+	} else if (s->flags & DM_MULTISNAP_FLAG_PENDING_DELETE) {
+		s->flags &= ~DM_MULTISNAP_FLAG_PENDING_DELETE;
+		s->flags |= DM_MULTISNAP_FLAG_DELETING;
+		s->delete_rover_chunk = 0;
+		s->delete_rover_snapid = 0;
+	} else
+		return;
+
+	dm_multisnap_queue_work(s->dm, &s->delete_work);
+}
-- 
1.6.5.2
