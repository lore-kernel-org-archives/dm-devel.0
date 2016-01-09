From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-snapshot: fix hung bios when copy error
	happens
Date: Fri, 8 Jan 2016 19:07:55 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601081906170.693@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When there is error copying chunk, dm-snapshot may errorneously keep some
bios forever, never finishing them. The bug is reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=889368

The function copy_callback sets pe->error if there was error copying the
chunk, and then calls complete exception. complete_exception calls
pending_complete on error, otherwise it calls commit_exception with
commit_callback (and commit_callback calls complete_exception).

The persistent exception store (dm-snap-persistent.c) assumes that calls
to prepare_exception and commit_exception are paired.
persistent_prepare_exception increases ps->pending_count and
persistent_commit_exception decreases.

If there is copy error, persistent_prepare_exception is called, but
persistent_commit_exception is not. This causes that the variable
ps->pending_count does not return to zero and that causes that some
pending exceptions are held forever and never finished (and bios
associated to them are held too).

This patch fixes the bug - commit_exception is called unconditionally
regardless of whether the copy was successful. I added a new parameter
"valid" to commit_exception - when the copy was unsuccessful, this
parameter is set to zero, so that the unsuccessful chunk (and all
following chunks) is not recorded in the snapshot store.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-exception-store.h |    2 +-
 drivers/md/dm-snap-persistent.c |    5 ++++-
 drivers/md/dm-snap-transient.c  |    4 ++--
 drivers/md/dm-snap.c            |   10 +++-------
 4 files changed, 10 insertions(+), 11 deletions(-)

Index: linux-4.4-rc8/drivers/md/dm-exception-store.h
===================================================================
--- linux-4.4-rc8.orig/drivers/md/dm-exception-store.h	2016-01-08 20:58:59.000000000 +0100
+++ linux-4.4-rc8/drivers/md/dm-exception-store.h	2016-01-08 20:59:06.000000000 +0100
@@ -69,7 +69,7 @@ struct dm_exception_store_type {
 	 * Update the metadata with this exception.
 	 */
 	void (*commit_exception) (struct dm_exception_store *store,
-				  struct dm_exception *e,
+				  struct dm_exception *e, int valid,
 				  void (*callback) (void *, int success),
 				  void *callback_context);
 
Index: linux-4.4-rc8/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-4.4-rc8.orig/drivers/md/dm-snap-persistent.c	2016-01-08 20:56:59.000000000 +0100
+++ linux-4.4-rc8/drivers/md/dm-snap-persistent.c	2016-01-08 20:58:27.000000000 +0100
@@ -695,7 +695,7 @@ static int persistent_prepare_exception(
 }
 
 static void persistent_commit_exception(struct dm_exception_store *store,
-					struct dm_exception *e,
+					struct dm_exception *e, int valid,
 					void (*callback) (void *, int success),
 					void *callback_context)
 {
@@ -704,6 +704,9 @@ static void persistent_commit_exception(
 	struct core_exception ce;
 	struct commit_callback *cb;
 
+	if (!valid)
+		ps->valid = 0;
+
 	ce.old_chunk = e->old_chunk;
 	ce.new_chunk = e->new_chunk;
 	write_exception(ps, ps->current_committed++, &ce);
Index: linux-4.4-rc8/drivers/md/dm-snap-transient.c
===================================================================
--- linux-4.4-rc8.orig/drivers/md/dm-snap-transient.c	2016-01-08 20:58:34.000000000 +0100
+++ linux-4.4-rc8/drivers/md/dm-snap-transient.c	2016-01-08 20:58:44.000000000 +0100
@@ -52,12 +52,12 @@ static int transient_prepare_exception(s
 }
 
 static void transient_commit_exception(struct dm_exception_store *store,
-				       struct dm_exception *e,
+				       struct dm_exception *e, int valid,
 				       void (*callback) (void *, int success),
 				       void *callback_context)
 {
 	/* Just succeed */
-	callback(callback_context, 1);
+	callback(callback_context, valid);
 }
 
 static void transient_usage(struct dm_exception_store *store,
Index: linux-4.4-rc8/drivers/md/dm-snap.c
===================================================================
--- linux-4.4-rc8.orig/drivers/md/dm-snap.c	2016-01-08 20:59:10.000000000 +0100
+++ linux-4.4-rc8/drivers/md/dm-snap.c	2016-01-08 20:59:38.000000000 +0100
@@ -1517,13 +1517,9 @@ static void complete_exception(struct dm
 {
 	struct dm_snapshot *s = pe->snap;
 
-	if (unlikely(pe->copy_error))
-		pending_complete(pe, 0);
-
-	else
-		/* Update the metadata if we are persistent */
-		s->store->type->commit_exception(s->store, &pe->e,
-						 commit_callback, pe);
+	/* Update the metadata if we are persistent */
+	s->store->type->commit_exception(s->store, &pe->e, !pe->copy_error,
+					 commit_callback, pe);
 }
 
 /*
