From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/14] barriers
Date: Mon, 23 Feb 2009 14:21:16 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231421080.23293@hs20-bc2-1.build.redhat.com>
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

Move content of __flush_deferred_io to the calling function: dm_wq_work.

There's no need to have a function that has only one caller.

It makes further patches more clean (i.e. no more dropping a lock inside a
subfunction that was took by the parent function)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:51:29.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:52:11.000000000 +0100
@@ -1398,14 +1398,19 @@ static int dm_wait_for_completion(struct
 /*
  * Process the deferred bios
  */
-static void __flush_deferred_io(struct mapped_device *md)
+static void dm_wq_work(struct work_struct *work)
 {
+	struct mapped_device *md = container_of(work, struct mapped_device, work);
 	struct bio *c;
 
+	down_write(&md->io_lock);
+
 	while ((c = bio_list_pop(&md->deferred)))
 		__process_bio(md, c);
 
 	clear_bit(DMF_BLOCK_IO, &md->flags);
+
+	up_write(&md->io_lock);
 }
 
 static void __merge_pushback_list(struct mapped_device *md)
@@ -1419,14 +1424,6 @@ static void __merge_pushback_list(struct
 	spin_unlock_irqrestore(&md->pushback_lock, flags);
 }
 
-static void dm_wq_work(struct work_struct *work)
-{
-	struct mapped_device *md = container_of(work, struct mapped_device, work);
-
-	down_write(&md->io_lock);
-	__flush_deferred_io(md);
-	up_write(&md->io_lock);
-}
 
 static void dm_queue_flush(struct mapped_device *md)
 {
