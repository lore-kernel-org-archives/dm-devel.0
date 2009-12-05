From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: stop merging using a completion
Date: Sat,  5 Dec 2009 13:24:44 -0500
Message-ID: <1260037484-20905-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Switch stop_merge() from using a busy loop to a completion event.

stop_merge() now requests merging be shutdown using the
'merge_completion' pointer (instead of the 'merge_shutdown' flag).  This
is accomplished by testing if 'merge_completion' is not NULL in
snapshot_merge_process().  stop_merge() allocates its completion on the
stack and assigns it to the 'merge_completion' pointer in the snapshot.
'merge_completion' is protected by the snapshot's lock.

Also changed the 'merge_running' flag from int to atomic_t.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

Index: linux-2.6-dev/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-snap.c
+++ linux-2.6-dev/drivers/md/dm-snap.c
@@ -106,11 +106,10 @@ struct dm_snapshot {
 	int merge_failed;
 
 	/* Merge operation is in progress */
-	int merge_running;
+	atomic_t merge_running;
 
-	/* It is requested to shut down merging */
-	/* Cleared back to 0 when the merging is stopped */
-	int merge_shutdown;
+	/* Merge completion that is triggered when using stop_merge() */
+	struct completion *merge_completion;
 
 	/* Merging this area --- block any writes */
 	chunk_t merge_write_interlock;
@@ -776,9 +775,17 @@ static void snapshot_merge_process(struc
 	struct dm_io_region src, dest;
 	sector_t io_size;
 
-	BUG_ON(!s->merge_running);
-	if (s->merge_shutdown)
+	BUG_ON(!atomic_read(&s->merge_running));
+	if (s->merge_completion) {
+		/* stop_merge() has requested that merging be shutdown */
+		down_write(&s->lock);
+		if (s->merge_completion) {
+			complete(s->merge_completion);
+			s->merge_completion = NULL;
+		}
+		up_write(&s->lock);
 		goto shut;
+	}
 
 	if (!s->valid) {
 		DMERR("snapshot is invalid, can't merge");
@@ -849,7 +856,7 @@ test_again:
 	return;
 
 shut:
-	s->merge_running = 0;
+	atomic_set(&s->merge_running, 0);
 }
 
 /* This function drops s->lock */
@@ -932,13 +939,13 @@ static void merge_callback(int read_err,
 shut:
 	down_write(&s->lock);
 	release_write_interlock(s, 1);
-	s->merge_running = 0;
+	atomic_set(&s->merge_running, 0);
 }
 
 static void start_merge(struct dm_snapshot *s)
 {
-	if (!s->merge_running && !s->merge_shutdown) {
-		s->merge_running = 1;
+	if (!atomic_read(&s->merge_running)) {
+		atomic_set(&s->merge_running, 1);
 		snapshot_merge_process(s);
 	}
 }
@@ -948,11 +955,13 @@ static void start_merge(struct dm_snapsh
  */
 static void stop_merge(struct dm_snapshot *s)
 {
-	while (s->merge_running) {
-		s->merge_shutdown = 1;
-		msleep(1);
+	DECLARE_COMPLETION_ONSTACK(merge_stopped);
+	if (atomic_read(&s->merge_running)) {
+		down_write(&s->lock);
+		s->merge_completion = &merge_stopped;
+		up_write(&s->lock);
+		wait_for_completion(&merge_stopped);
 	}
-	s->merge_shutdown = 0;
 }
 
 /*
@@ -1020,8 +1029,8 @@ static int snapshot_ctr(struct dm_target
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->merge_failed = 0;
-	s->merge_running = 0;
-	s->merge_shutdown = 0;
+	atomic_set(&s->merge_running, 0);
+	s->merge_completion = NULL;
 	s->merge_write_interlock = 0;
 	s->merge_write_interlock_n = 0;
 	bio_list_init(&s->merge_write_list);
