From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-snapshot: merge functions commit_callback
 and pending_complete
Date: Fri, 8 Jan 2016 19:08:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601081907570.693@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch merges the functions commit_callback and pending_complete
because it is no longer needed to distinguish between them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-4.4-rc8/drivers/md/dm-snap.c
===================================================================
--- linux-4.4-rc8.orig/drivers/md/dm-snap.c	2016-01-08 23:38:54.000000000 +0100
+++ linux-4.4-rc8/drivers/md/dm-snap.c	2016-01-08 23:39:30.000000000 +0100
@@ -1437,8 +1437,9 @@ static void __invalidate_snapshot(struct
 	dm_table_event(s->ti->table);
 }
 
-static void pending_complete(struct dm_snap_pending_exception *pe, int success)
+static void pending_complete(void *context, int success)
 {
+	struct dm_snap_pending_exception *pe = context;
 	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
@@ -1506,20 +1507,13 @@ out:
 	free_pending_exception(pe);
 }
 
-static void commit_callback(void *context, int success)
-{
-	struct dm_snap_pending_exception *pe = context;
-
-	pending_complete(pe, success);
-}
-
 static void complete_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snapshot *s = pe->snap;
 
 	/* Update the metadata if we are persistent */
 	s->store->type->commit_exception(s->store, &pe->e, !pe->copy_error,
-					 commit_callback, pe);
+					 pending_complete, pe);
 }
 
 /*
