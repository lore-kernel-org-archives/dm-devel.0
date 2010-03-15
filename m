From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] Open origin before exception store
	initialization
Date: Mon, 15 Mar 2010 02:00:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003150200290.12526@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Open origin before exception store initialization

Further patch for chunk size validation requires that the origin
is open when initializing an exception store.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6.34-rc1-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.34-rc1-devel.orig/drivers/md/dm-snap.c	2010-03-12 16:32:47.000000000 +0100
+++ linux-2.6.34-rc1-devel/drivers/md/dm-snap.c	2010-03-12 16:36:21.000000000 +0100
@@ -1065,10 +1065,6 @@ static int snapshot_ctr(struct dm_target
 		origin_mode = FMODE_WRITE;
 	}
 
-	origin_path = argv[0];
-	argv++;
-	argc--;
-
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error = "Cannot allocate snapshot context private "
@@ -1077,6 +1073,16 @@ static int snapshot_ctr(struct dm_target
 		goto bad;
 	}
 
+	origin_path = argv[0];
+	argv++;
+	argc--;
+
+	r = dm_get_device(ti, origin_path, origin_mode, &s->origin);
+	if (r) {
+		ti->error = "Cannot get origin device";
+		goto bad_origin;
+	}
+
 	cow_path = argv[0];
 	argv++;
 	argc--;
@@ -1097,12 +1103,6 @@ static int snapshot_ctr(struct dm_target
 	argv += args_used;
 	argc -= args_used;
 
-	r = dm_get_device(ti, origin_path, origin_mode, &s->origin);
-	if (r) {
-		ti->error = "Cannot get origin device";
-		goto bad_origin;
-	}
-
 	s->ti = ti;
 	s->valid = 1;
 	s->active = 0;
@@ -1212,15 +1212,15 @@ bad_kcopyd:
 	dm_exception_table_exit(&s->complete, exception_cache);
 
 bad_hash_tables:
-	dm_put_device(ti, s->origin);
-
-bad_origin:
 	dm_exception_store_destroy(s->store);
 
 bad_store:
 	dm_put_device(ti, s->cow);
 
 bad_cow:
+	dm_put_device(ti, s->origin);
+
+bad_origin:
 	kfree(s);
 
 bad:
@@ -1314,12 +1314,12 @@ static void snapshot_dtr(struct dm_targe
 
 	mempool_destroy(s->pending_pool);
 
-	dm_put_device(ti, s->origin);
-
 	dm_exception_store_destroy(s->store);
 
 	dm_put_device(ti, s->cow);
 
+	dm_put_device(ti, s->origin);
+
 	kfree(s);
 }
 
