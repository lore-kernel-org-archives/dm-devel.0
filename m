From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 03/10] dm snapshot: Add exception store methods
	for merging
Date: Tue,  1 Apr 2008 09:32:50 +0200
Message-ID: <1207035177-7156-4-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-3-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add prepare_merge() and commit_merge() methods to the exception store to
allow for snapshot chunks to be removed from the exception store as the
chunks are merged back into the origin.

prepare_merge() retrieves the details of the last exception in the store
in preparation for that chunk to be merged back into the origin.

commit_merge() is then later used to remove that same exception from the
store once the merge has completed.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-exception-store.c |   69 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-snap.h            |   12 +++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 02fd3e9..4fd5381 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -624,6 +624,71 @@ static void persistent_commit(struct exception_store *store,
 	}
 }
 
+/* Given an exception index within a certain area, return the
+ * corresponding chunk index.
+ */
+static inline uint32_t exception_to_chunk(uint32_t area,
+					  uint32_t exceptions_per_area,
+					  uint32_t exception)
+{
+	/* Header followed by sets of (metadata chunk, exceptions_per_area chunks)
+	 */
+	return 1 + (area * (1 + exceptions_per_area)) + 1 + exception;
+}
+
+static int persistent_prepare_merge(struct exception_store *store,
+				    struct dm_snap_exception *e,
+				    int *empty)
+{
+	struct pstore *ps = get_info(store);
+	struct disk_exception de;
+	int r;
+
+	*empty = 0;
+
+	if (ps->current_committed == 0) {
+		if (ps->current_area == 0) {
+			*empty = 1;
+			return 0;
+		}
+
+		r = area_io(ps, ps->current_area - 1, READ);
+		if (r)
+			return r;
+
+		ps->current_committed = ps->exceptions_per_area - 1;
+	} else {
+		ps->current_committed--;
+	}
+
+	read_exception(ps, ps->current_committed, &de);
+
+	e->old_chunk = de.old_chunk;
+	e->new_chunk = de.new_chunk;
+
+	ps->next_free = exception_to_chunk(ps->current_area,
+					   ps->exceptions_per_area,
+					   ps->current_committed);
+
+	return 0;
+}
+
+static void persistent_commit_merge(struct exception_store *store)
+{
+	struct pstore *ps = get_info(store);
+	struct disk_exception de;
+	int r;
+
+	read_exception(ps, ps->current_committed, &de);
+
+	de.new_chunk = 0;
+	write_exception(ps, ps->current_committed, &de);
+
+	r = area_io(ps, ps->current_area, WRITE);
+	if (r)
+		ps->valid = 0;
+}
+
 static void persistent_drop(struct exception_store *store)
 {
 	struct pstore *ps = get_info(store);
@@ -664,6 +729,8 @@ int dm_create_persistent(struct exception_store *store)
 	store->read_metadata = persistent_read_metadata;
 	store->prepare_exception = persistent_prepare;
 	store->commit_exception = persistent_commit;
+	store->prepare_merge = persistent_prepare_merge;
+	store->commit_merge = persistent_commit_merge;
 	store->drop_snapshot = persistent_drop;
 	store->fraction_full = persistent_fraction_full;
 	store->context = ps;
@@ -727,6 +794,8 @@ int dm_create_transient(struct exception_store *store)
 	store->read_metadata = transient_read_metadata;
 	store->prepare_exception = transient_prepare;
 	store->commit_exception = transient_commit;
+	store->prepare_merge = NULL;
+	store->commit_merge = NULL;
 	store->drop_snapshot = NULL;
 	store->fraction_full = transient_fraction_full;
 
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 93bce5d..8b02a42 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -115,6 +115,18 @@ struct exception_store {
 				  void *callback_context);
 
 	/*
+	 * Prepare the next exception for merging.
+	 */
+	int (*prepare_merge) (struct exception_store *store,
+			      struct dm_snap_exception *e,
+			      int *empty);
+
+	/*
+	 * Remove the currently merging exception.
+	 */
+	void (*commit_merge) (struct exception_store *store);
+
+	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
 	void (*drop_snapshot) (struct exception_store *store);
-- 
1.5.4.1
