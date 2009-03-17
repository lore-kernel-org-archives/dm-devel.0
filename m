From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 25 of 29]
	dm-snap-get-rid-of-__free_exceptions-fn.patch
Date: Tue, 17 Mar 2009 09:06:21 -0500
Message-ID: <200903171406.n2HE6LNQ017526@hydrogen.msp.redhat.com>
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
 
