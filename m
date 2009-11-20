From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 03/13] dm exception store: add snapshot-merge
	specific methods
Date: Fri, 20 Nov 2009 15:27:43 -0500
Message-ID: <1258748873-24185-4-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

prepare_merge: returns the last chunk in the variables passed by reference.
	The return value is the number of consecutive chunks.
commit_merge: permanently removes 'n' chunks from the exception store.
	'n' is less or equal that the number returned by prepare_merge.

If the caller wishes, it can do the optimization of merging several consecutive
chunks at once. If it doesn't want to do this optimization, it just calls
commit_merge with n == 1.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |   16 +++++++++
 drivers/md/dm-snap-persistent.c |   70 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index bb88746..534427f 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -75,6 +75,22 @@ struct dm_exception_store_type {
 				  void *callback_context);
 
 	/*
+	 * Returns the last chunk in the pointers. (TODO: -ENOPARSE)
+	 * > 0:  the number of consecutive chunks that can
+	 *       be copied in one shot.
+	 * == 0: the exception store is empty.
+	 * < 0:  error.
+	 */
+	int (*prepare_merge) (struct dm_exception_store *store,
+			      chunk_t *old_chunk, chunk_t *new_chunk);
+
+	/*
+	 * Clear the last n exceptions.
+	 * n must be <= the value returned by prepare_merge.
+	 */
+	int (*commit_merge) (struct dm_exception_store *store, int n);
+
+	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
 	void (*drop_snapshot) (struct dm_exception_store *store);
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 157999e..1f5752e 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -409,6 +409,15 @@ static void write_exception(struct pstore *ps,
 	e->new_chunk = cpu_to_le64(de->new_chunk);
 }
 
+static void clear_exception(struct pstore *ps, uint32_t index)
+{
+	struct disk_exception *e = get_exception(ps, index);
+
+	/* clear it */
+	e->old_chunk = 0;
+	e->new_chunk = 0;
+}
+
 /*
  * Registers the exceptions that are present in the current area.
  * 'full' is filled in to indicate if the area has been
@@ -680,6 +689,63 @@ static void persistent_commit_exception(struct dm_exception_store *store,
 	ps->callback_count = 0;
 }
 
+static int persistent_prepare_merge(struct dm_exception_store *store,
+				    chunk_t *old_chunk, chunk_t *new_chunk)
+{
+	int r, i;
+	struct pstore *ps = get_info(store);
+	struct disk_exception de;
+
+	if (!ps->current_committed) {
+		if (!ps->current_area)
+			return 0;
+		ps->current_area--;
+		r = area_io(ps, READ);
+		if (r < 0)
+			return r;
+		ps->current_committed = ps->exceptions_per_area;
+	}
+
+	read_exception(ps, ps->current_committed - 1, &de);
+	*old_chunk = de.old_chunk;
+	*new_chunk = de.new_chunk;
+
+	for (i = 1; i < ps->current_committed; i++) {
+		read_exception(ps, ps->current_committed - 1 - i, &de);
+		if (de.old_chunk != *old_chunk - i ||
+		    de.new_chunk != *new_chunk - i)
+			break;
+	}
+
+	return i;
+}
+
+static int persistent_commit_merge(struct dm_exception_store *store, int n)
+{
+	int r, i;
+	struct pstore *ps = get_info(store);
+
+	BUG_ON(n > ps->current_committed);
+
+	for (i = 0; i < n; i++)
+		clear_exception(ps, ps->current_committed - 1 - i);
+
+	r = area_io(ps, WRITE);
+	if (r < 0)
+		return r;
+
+	ps->current_committed -= i;
+
+	/*
+	 * ps->next_free cannot really be reliably decreased here (because of
+	 * misordered chunks), so don't do it. We don't even need it, because
+	 * there is no situation where merging snapshot would become
+	 * non-merging.
+	 */
+
+	return 0;
+}
+
 static void persistent_drop_snapshot(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
@@ -748,6 +814,8 @@ static struct dm_exception_store_type _persistent_type = {
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.prepare_merge = persistent_prepare_merge,
+	.commit_merge = persistent_commit_merge,
 	.drop_snapshot = persistent_drop_snapshot,
 	.usage = persistent_usage,
 	.status = persistent_status,
@@ -761,6 +829,8 @@ static struct dm_exception_store_type _persistent_compat_type = {
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.prepare_merge = persistent_prepare_merge,
+	.commit_merge = persistent_commit_merge,
 	.drop_snapshot = persistent_drop_snapshot,
 	.usage = persistent_usage,
 	.status = persistent_status,
-- 
1.6.5.2
