From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/14] barriers
Date: Mon, 23 Feb 2009 14:20:00 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231419300.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Remove "type" argument of dm_wq_req because it can have only one value.
And it won't be used later.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:37:44.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:38:27.000000000 +0100
@@ -100,9 +100,6 @@ union map_info *dm_get_mapinfo(struct bi
  * Work processed by per-device workqueue.
  */
 struct dm_wq_req {
-	enum {
-		DM_WQ_FLUSH_DEFERRED,
-	} type;
 	struct work_struct work;
 	struct mapped_device *md;
 	void *context;
@@ -1431,32 +1428,24 @@ static void dm_wq_work(struct work_struc
 	struct mapped_device *md = req->md;
 
 	down_write(&md->io_lock);
-	switch (req->type) {
-	case DM_WQ_FLUSH_DEFERRED:
-		__flush_deferred_io(md);
-		break;
-	default:
-		DMERR("dm_wq_work: unrecognised work type %d", req->type);
-		BUG();
-	}
+	__flush_deferred_io(md);
 	up_write(&md->io_lock);
 }
 
-static void dm_wq_queue(struct mapped_device *md, int type, void *context,
+static void dm_wq_queue(struct mapped_device *md, void *context,
 			struct dm_wq_req *req)
 {
-	req->type = type;
 	req->md = md;
 	req->context = context;
 	INIT_WORK(&req->work, dm_wq_work);
 	queue_work(md->wq, &req->work);
 }
 
-static void dm_queue_flush(struct mapped_device *md, int type, void *context)
+static void dm_queue_flush(struct mapped_device *md, void *context)
 {
 	struct dm_wq_req req;
 
-	dm_wq_queue(md, type, context, &req);
+	dm_wq_queue(md, context, &req);
 	flush_workqueue(md->wq);
 }
 
@@ -1590,7 +1579,7 @@ int dm_suspend(struct mapped_device *md,
 
 	/* were we interrupted ? */
 	if (r < 0) {
-		dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
+		dm_queue_flush(md, NULL);
 
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
@@ -1625,7 +1614,7 @@ int dm_resume(struct mapped_device *md)
 	if (r)
 		goto out;
 
-	dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
+	dm_queue_flush(md, NULL);
 
 	unlock_fs(md);
 
