From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 13/13] dm snapshot: report merge failure in
	status
Date: Sat, 5 Dec 2009 13:44:38 -0500
Message-ID: <20091205184437.GA21045@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
	<1259893434-10792-14-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1259893434-10792-14-git-send-email-snitzer@redhat.com>
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

Set 'merge_failed' flag if a snapshot fails to merge.  Update
snapshot_status() to report "Merge failed" if 'merge_failed' is set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
NOTE: Revised slightly so all other merge failures in merge_callback()
properly set 'merge_failed'
---
 drivers/md/dm-snap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6-dev/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-snap.c
+++ linux-2.6-dev/drivers/md/dm-snap.c
@@ -102,6 +102,9 @@ struct dm_snapshot {
 	spinlock_t tracked_chunk_lock;
 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
 
+	/* Merge operation failed if this is set */
+	int merge_failed;
+
 	/* Merge operation is in progress */
 	int merge_running;
 
@@ -775,9 +778,13 @@ static void snapshot_merge_process(struc
 	linear_chunks = s->store->type->prepare_merge(s->store,
 						      &old_chunk, &new_chunk);
 	if (linear_chunks <= 0) {
-		if (linear_chunks < 0)
+		if (linear_chunks < 0) {
 			DMERR("Read error in exception store, "
 			      "shutting down merge");
+			down_write(&s->lock);
+			s->merge_failed = 1;
+			up_write(&s->lock);
+		}
 		goto shut;
 	}
 	/* Adjust old_chunk and new_chunk to reflect start of linear region */
@@ -914,6 +921,7 @@ static void merge_callback(int read_err,
 
 shut:
 	down_write(&s->lock);
+	s->merge_failed = 1;
 	release_write_interlock(s, 1);
 	s->merge_running = 0;
 }
@@ -1002,6 +1010,7 @@ static int snapshot_ctr(struct dm_target
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
+	s->merge_failed = 0;
 	s->merge_running = 0;
 	s->merge_shutdown = 0;
 	s->merge_write_interlock = 0;
@@ -1741,6 +1750,8 @@ static int snapshot_status(struct dm_tar
 
 		if (!snap->valid)
 			DMEMIT("Invalid");
+		else if (snap->merge_failed)
+			DMEMIT("Merge failed");
 		else {
 			if (snap->store->type->usage) {
 				sector_t total_sectors, sectors_allocated,
