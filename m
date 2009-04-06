From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 23 of 33] DM Exception Store: add suspend to API
Date: Mon, 6 Apr 2009 16:36:20 -0500
Message-ID: <200904062136.n36LaKjM021389@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-suspend-to-API.patch

Add [pre|post]suspend functions to the exception store API.
These will become important for future exception stores.  Current
exception store implementations will not alter metadata after
a 'commit_exception' completes.  However, future stores may do
journaling or other actions.  They might return from 'commit_exception'
when the request hits the journal, but continue flushing after.
This could be bad, because we expect them to not do anything once
a 'suspend' is issued.  Adding these functions to the API allows
them to finish what they are doing and conform to device-mapper
requirements.  (The above was just one example...  Cluster-aware
exception stores will also require the notification of when they
need to suspend their activity.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -32,6 +32,8 @@ struct dm_exception_store_type {
 	void (*dtr) (struct dm_exception_store *store);
 
 	int (*resume) (struct dm_exception_store *store);
+	void (*presuspend) (struct dm_exception_store *store);
+	void (*postsuspend) (struct dm_exception_store *store);
 
 	/*
 	 * Find somewhere to store the next exception.
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1009,6 +1009,22 @@ static void snapshot_resume(struct dm_ta
 	up_write(&s->lock);
 }
 
+static void snapshot_presuspend(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	if (s->store->type->presuspend)
+		s->store->type->presuspend(s->store);
+}
+
+static void snapshot_postsuspend(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	if (s->store->type->postsuspend)
+		s->store->type->postsuspend(s->store);
+}
+
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
@@ -1311,6 +1327,8 @@ static struct target_type snapshot_targe
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
+	.presuspend = snapshot_presuspend,
+	.postsuspend = snapshot_postsuspend,
 	.status  = snapshot_status,
 };
 
