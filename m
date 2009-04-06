From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 29 of 33] DM Snapshot: get rid of
	__free_exceptions fn
Date: Mon, 6 Apr 2009 16:37:21 -0500
Message-ID: <200904062137.n36LbLE8021832@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-get-rid-of-__free_exceptions-fn.patch

The __free_exceptions function is only three lines long and
used in only one place.  We'll need to break-up and re-order those
lines in later patches, so we get rid of the function entirely.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -578,14 +578,6 @@ bad_snap:
 	return r;
 }
 
-static void __free_exceptions(struct dm_snapshot *s)
-{
-	dm_kcopyd_client_destroy(s->kcopyd_client);
-	s->kcopyd_client = NULL;
-
-	dm_exception_table_destroy(s->pending);
-}
-
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
@@ -614,7 +606,10 @@ static void snapshot_dtr(struct dm_targe
 
 	mempool_destroy(s->tracked_chunk_pool);
 
-	__free_exceptions(s);
+	dm_kcopyd_client_destroy(s->kcopyd_client);
+	s->kcopyd_client = NULL;
+
+	dm_exception_table_destroy(s->pending);
 
 	mempool_destroy(s->pending_pool);
 
