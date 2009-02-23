From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/14] barriers
Date: Mon, 23 Feb 2009 14:20:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231420180.23293@hs20-bc2-1.build.redhat.com>
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

Remove struct dm_wq_req and move "work" directly to struct mapped_device.

In the new implementation, the thread will do just one type of work (processing
the queue), there is no need for separate work requests for it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:38:32.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:38:36.000000000 +0100
@@ -99,11 +99,6 @@ union map_info *dm_get_mapinfo(struct bi
 /*
  * Work processed by per-device workqueue.
  */
-struct dm_wq_req {
-	struct work_struct work;
-	struct mapped_device *md;
-};
-
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct mutex suspend_lock;
@@ -125,6 +120,7 @@ struct mapped_device {
 	 */
 	atomic_t pending;
 	wait_queue_head_t wait;
+	struct work_struct work;
 	struct bio_list deferred;
 	struct bio_list pushback;
 
@@ -1064,6 +1060,8 @@ out:
 
 static struct block_device_operations dm_blk_dops;
 
+static void dm_wq_work(struct work_struct *work);
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -1130,6 +1128,7 @@ static struct mapped_device *alloc_dev(i
 
 	atomic_set(&md->pending, 0);
 	init_waitqueue_head(&md->wait);
+	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
 
 	md->disk->major = _major;
@@ -1423,26 +1422,16 @@ static void __merge_pushback_list(struct
 
 static void dm_wq_work(struct work_struct *work)
 {
-	struct dm_wq_req *req = container_of(work, struct dm_wq_req, work);
-	struct mapped_device *md = req->md;
+	struct mapped_device *md = container_of(work, struct mapped_device, work);
 
 	down_write(&md->io_lock);
 	__flush_deferred_io(md);
 	up_write(&md->io_lock);
 }
 
-static void dm_wq_queue(struct mapped_device *md, struct dm_wq_req *req)
-{
-	req->md = md;
-	INIT_WORK(&req->work, dm_wq_work);
-	queue_work(md->wq, &req->work);
-}
-
 static void dm_queue_flush(struct mapped_device *md)
 {
-	struct dm_wq_req req;
-
-	dm_wq_queue(md, &req);
+	queue_work(md->wq, &md->work);
 	flush_workqueue(md->wq);
 }
 
