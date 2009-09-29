From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 18/18] dm-exstore-persistent-allow-metadata-reread
Date: Tue, 29 Sep 2009 18:53:43 -0400
Message-ID: <1254264823-11538-19-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Jon Brassow <jbrassow@redhat.com>

This patch allows the persistent exception store to re-read
exception data from disk without adding duplicate entries
to the cache.  Being able to re-read the metadata is especially
useful when trying to pick-up new data that may have been added.

This means the persistent exception store can be used as the
starting point for a cluster-aware exception store, which leads
to shared-storage cluster-aware snapshots.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-snap-persistent.c |  129 +++++++++++++++++++++++++++++++-------
 1 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index d920f69..528832a 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -299,7 +299,7 @@ static int zero_disk_area(struct pstore *ps, chunk_t area)
 	return chunk_io(ps, ps->zero_area, area_location(ps, area), WRITE, 0);
 }
 
-static int read_header(struct pstore *ps, int *new_snapshot)
+static int initial_read_header(struct pstore *ps, int *new_snapshot)
 {
 	int r;
 	struct disk_header *dh;
@@ -344,7 +344,6 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 		goto bad;
 	}
 
-	*new_snapshot = 0;
 	ps->valid = le32_to_cpu(dh->valid);
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
@@ -382,6 +381,51 @@ bad:
 	return r;
 }
 
+/*
+ * Re-reading the header is all about checking the 'valid'
+ * field to ensure that this exception store has not been
+ * marked invalid.  We can also do some sanity checks while
+ * we are at it.
+ */
+static int reread_header(struct pstore *ps)
+{
+	int r;
+	struct disk_header *dh;
+
+	r = chunk_io(ps, ps->header_area, 0, READ, 1);
+	if (r)
+		return r;
+
+	dh = (struct disk_header *) ps->header_area;
+
+	/*
+	 * If any of these conditions is true it means that the
+	 * exception store underneath us has changed in ways we
+	 * cannot handle.  What's worse, if we proceed, we can
+	 * corrupt the exception store.
+	 */
+	if ((le32_to_cpu(dh->magic) != SNAP_MAGIC) ||
+	    (ps->version != le32_to_cpu(dh->version)) ||
+	    (ps->store->chunk_size != le32_to_cpu(dh->chunk_size))) {
+		DMERR("Exception store parameters changed while in use.");
+		ps->valid = 0;
+		return -EINVAL;
+	}
+
+	ps->valid = le32_to_cpu(dh->valid);
+
+	return 0;
+}
+
+static int read_header(struct pstore *ps, int *new_snapshot)
+{
+	*new_snapshot = 0;
+	if (ps->io_client)
+		return reread_header(ps);
+
+	return initial_read_header(ps, new_snapshot);
+}
+
 static int write_header(struct pstore *ps)
 {
 	struct disk_header *dh;
@@ -457,7 +501,18 @@ static int insert_exceptions(struct pstore *ps, int *full)
 	/* presume the area is full */
 	*full = 1;
 
-	for (i = 0; i < ps->exceptions_per_area; i++) {
+	/*
+	 * We start the loop at ps->current_committed.  If this is a full
+	 * read of the metadata area, it will be zero until we
+	 * are finished reading.  If this is a partial read to catch
+	 * any updates to the metadata area, then we will start at
+	 * the position that was last known to be empty.  (We must reset
+	 * ps->current_committed, otherwise metadata updates involving
+	 * more than one area will skip over some exceptions.
+	 */
+	i = ps->current_committed;
+	ps->current_committed = 0;
+	for (; i < ps->exceptions_per_area; i++) {
 		read_exception(ps, i, &de);
 
 		/*
@@ -494,10 +549,12 @@ static int read_exceptions(struct pstore *ps)
 	int r, full = 1;
 
 	/*
-	 * Keeping reading chunks and inserting exceptions until
-	 * we find a partially full area.
+	 * We start from 'ps->current_area' and keep reading chunks
+	 * and inserting exceptions until we find a partially full
+	 * area.  ('ps->current_area' must be initialized to 0 for the
+	 * first complete read.)
 	 */
-	for (ps->current_area = 0; full; ps->current_area++) {
+	for (; full; ps->current_area++) {
 		r = area_io(ps, READ);
 		if (r)
 			return r;
@@ -543,23 +600,17 @@ static void persistent_dtr(struct dm_exception_store *store)
 	kfree(ps);
 }
 
-static int persistent_read_metadata(struct dm_exception_store *store)
+static int do_initial_metadata_read(struct dm_exception_store *store,
+				    int new_snapshot)
 {
-	int r, uninitialized_var(new_snapshot);
+	int r;
 	struct pstore *ps = get_info(store);
 
 	/*
-	 * Read the snapshot header.
-	 */
-	r = read_header(ps, &new_snapshot);
-	if (r)
-		return r;
-
-	/*
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
-				  sizeof(struct disk_exception);
+		sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 			sizeof(*ps->callbacks));
 	if (!ps->callbacks)
@@ -572,24 +623,48 @@ static int persistent_read_metadata(struct dm_exception_store *store)
 		r = write_header(ps);
 		if (r) {
 			DMWARN("write_header failed");
-			return r;
+			goto fail;
 		}
 
 		ps->current_area = 0;
 		zero_memory_area(ps);
 		r = zero_disk_area(ps, 0);
-		if (r)
+		if (r) {
 			DMWARN("zero_disk_area(0) failed");
-		return r;
+			goto fail;
+		}
 	}
+
 	/*
 	 * Sanity checks.
 	 */
-	if (ps->version != SNAPSHOT_DISK_VERSION) {
-		DMWARN("unable to handle snapshot disk version %d",
-		       ps->version);
-		return -EINVAL;
-	}
+	if (ps->version == SNAPSHOT_DISK_VERSION)
+		return 0;
+
+	DMWARN("unable to handle snapshot disk version %d",
+	       ps->version);
+	r = -EINVAL;
+
+fail:
+	vfree(ps->callbacks);
+	ps->callbacks = NULL;
+	ps->exceptions_per_area = 0;
+	ps->valid = 0;
+
+	return r;
+}
+
+static int persistent_read_metadata(struct dm_exception_store *store)
+{
+	int r, uninitialized_var(new_snapshot);
+	struct pstore *ps = get_info(store);
+
+	/*
+	 * Read the snapshot header.
+	 */
+	r = read_header(ps, &new_snapshot);
+	if (r)
+		return r;
 
 	/*
 	 * Metadata are valid, but snapshot is invalidated
@@ -597,6 +672,12 @@ static int persistent_read_metadata(struct dm_exception_store *store)
 	if (!ps->valid)
 		return 1;
 
+	if (!ps->callbacks) {
+		r = do_initial_metadata_read(store, new_snapshot);
+		if (r)
+			return r;
+	}
+
 	/*
 	 * Read the metadata.
 	 */
-- 
1.6.2.5
