From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 10 of 12]:
	dm-snapshot-move-status-to-exception-store.patch
Date: Tue, 20 Jan 2009 14:08:56 -0600
Message-ID: <1232482136.19993.43.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

 brassow

Let the exception store types print out their status through
the new API, rather than having the snapshot code do it.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -694,6 +694,14 @@ static int persistent_status(struct dm_e
 {
 	int sz = 0;
 
+	switch (status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s P %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
+	}
+
 	return sz;
 }
 
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -87,6 +87,14 @@ static int transient_status(struct dm_ex
 {
 	int sz = 0;
 
+	switch (status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s N %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
+	}
+
 	return sz;
 }
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -70,9 +70,6 @@ struct dm_snapshot {
 	/* Origin writes don't trigger exceptions until this is set */
 	int active;
 
-	/* Used for display of table */
-	char type;
-
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -1158,9 +1155,7 @@ static int snapshot_status(struct dm_tar
 		 * make sense.
 		 */
 		DMEMIT("%s", snap->origin->name);
-		DMEMIT(" %s %s %llu", snap->store->cow->name,
-		       snap->store->type->name,
-		       (unsigned long long)snap->store->chunk_size);
+		snap->store->type->status(snap->store, type, result, maxlen);
 		break;
 	}
 
