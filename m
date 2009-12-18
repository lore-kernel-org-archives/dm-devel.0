From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm: eliminate some holes in data structures
Date: Fri, 18 Dec 2009 17:40:56 -0500
Message-ID: <1261176056-30520-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

Eliminate 1 4-byte hole in 'struct dm_io_memory' by moving 'offset'
above the 'ptr' to which it applies (size reduced from 24 to 16 bytes).
And by association, 1-4 byte hole is eliminated in 'struct
dm_io_request' (size reduced from 56 to 48 bytes).

Eliminate all (6 4-byte) holes (and 1 cache-line) in 'struct
dm_snapshot' (size reduced from 392 to 368 bytes).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c  |   26 +++++++++++++-------------
 include/linux/dm-io.h |    4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ee8eb28..ab9822e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -83,10 +83,10 @@ struct dm_snapshot {
 	/* Whether or not owning mapped_device is suspended */
 	int suspended;
 
-	mempool_t *pending_pool;
-
 	atomic_t pending_exceptions_count;
 
+	mempool_t *pending_pool;
+
 	struct dm_exception_table pending;
 	struct dm_exception_table complete;
 
@@ -96,6 +96,11 @@ struct dm_snapshot {
 	 */
 	spinlock_t pe_lock;
 
+	/* Chunks with outstanding reads */
+	spinlock_t tracked_chunk_lock;
+	mempool_t *tracked_chunk_pool;
+	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
@@ -105,10 +110,12 @@ struct dm_snapshot {
 	struct bio_list queued_bios;
 	struct work_struct queued_bios_work;
 
-	/* Chunks with outstanding reads */
-	mempool_t *tracked_chunk_pool;
-	spinlock_t tracked_chunk_lock;
-	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+	/* Wait for events based on state_bits */
+	unsigned long state_bits;
+
+	/* Range of chunks currently being merged. */
+	chunk_t first_merging_chunk;
+	int num_merging_chunks;
 
 	/*
 	 * The merge operation failed if this flag is set.
@@ -125,13 +132,6 @@ struct dm_snapshot {
 	 */
 	int merge_failed;
 
-	/* Wait for events based on state_bits */
-	unsigned long state_bits;
-
-	/* Range of chunks currently being merged. */
-	chunk_t first_merging_chunk;
-	int num_merging_chunks;
-
 	/*
 	 * Incoming bios that overlap with chunks being merged must wait
 	 * for them to be committed.
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index b6bf17e..5c9186b 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -37,14 +37,14 @@ enum dm_io_mem_type {
 struct dm_io_memory {
 	enum dm_io_mem_type type;
 
+	unsigned offset;
+
 	union {
 		struct page_list *pl;
 		struct bio_vec *bvec;
 		void *vma;
 		void *addr;
 	} ptr;
-
-	unsigned offset;
 };
 
 struct dm_io_notify {
