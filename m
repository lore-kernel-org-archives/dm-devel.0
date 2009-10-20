From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 05/17] dm exception store: do not read
	metadata if going to handover exceptions
Date: Tue, 20 Oct 2009 18:46:53 -0400
Message-ID: <1256078825-11331-6-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

This saves memory (without the patch, the exception store would consume twice
more memory while doing handover).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-exception-store.h |    6 +++++-
 drivers/md/dm-snap-persistent.c |    5 +++--
 drivers/md/dm-snap-transient.c  |    2 +-
 drivers/md/dm-snap.c            |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index bb88746..a96a40a 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -54,11 +54,15 @@ struct dm_exception_store_type {
 	 * The target shouldn't read the COW device until this is
 	 * called.  As exceptions are read from the COW, they are
 	 * reported back via the callback.
+	 *
+	 * will_handover means that there is another snapshot active;
+	 * chunk size must be setup but no exceptions need to be read
+	 * because they will be handed over from the active snapshot.
 	 */
 	int (*read_metadata) (struct dm_exception_store *store,
 			      int (*callback)(void *callback_context,
 					      chunk_t old, chunk_t new),
-			      void *callback_context);
+			      void *callback_context, int will_handover);
 
 	/*
 	 * Find somewhere to store the next exception.
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 157999e..e0f526a 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -529,7 +529,7 @@ static void persistent_dtr(struct dm_exception_store *store)
 static int persistent_read_metadata(struct dm_exception_store *store,
 				    int (*callback)(void *callback_context,
 						    chunk_t old, chunk_t new),
-				    void *callback_context)
+				    void *callback_context, int will_handover)
 {
 	int r, uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
@@ -586,7 +586,8 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 	/*
 	 * Read the metadata.
 	 */
-	r = read_exceptions(ps, callback, callback_context);
+	if (!will_handover)
+		r = read_exceptions(ps, callback, callback_context);
 
 	return r;
 }
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index a0898a6..341231a 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -30,7 +30,7 @@ static void transient_dtr(struct dm_exception_store *store)
 static int transient_read_metadata(struct dm_exception_store *store,
 				   int (*callback)(void *callback_context,
 						   chunk_t old, chunk_t new),
-				   void *callback_context)
+				   void *callback_context, int will_handover)
 {
 	return 0;
 }
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5414e66..1f0a57c 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -739,7 +739,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Metadata must only be loaded into one table at once */
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
-					  (void *)s);
+					  (void *)s, s->handover);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad_load_and_register;
-- 
1.6.5.rc2
