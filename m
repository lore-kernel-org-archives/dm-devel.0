From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/14] barriers
Date: Mon, 23 Feb 2009 14:22:17 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231422050.23293@hs20-bc2-1.build.redhat.com>
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

Merge pushback and deferred lists into one list --- use deferred list
for both deferred and pushed-back bios.

This will be needed for proper support of barrier bios, it is impossible to
support ordering correctly with two lists because the requests on both lists
will be mixed up.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:52:23.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:53:01.000000000 +0100
@@ -102,7 +102,6 @@ union map_info *dm_get_mapinfo(struct bi
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct mutex suspend_lock;
-	spinlock_t pushback_lock;
 	rwlock_t map_lock;
 	atomic_t holders;
 	atomic_t open_count;
@@ -122,7 +121,7 @@ struct mapped_device {
 	wait_queue_head_t wait;
 	struct work_struct work;
 	struct bio_list deferred;
-	struct bio_list pushback;
+	spinlock_t deferred_lock;
 
 	/*
 	 * Processing queue (flush/barriers)
@@ -445,7 +444,9 @@ static int queue_io(struct mapped_device
 		return 1;
 	}
 
+	spin_lock_irq(&md->deferred_lock);
 	bio_list_add(&md->deferred, bio);
+	spin_unlock_irq(&md->deferred_lock);
 
 	up_write(&md->io_lock);
 	return 0;		/* deferred successfully */
@@ -526,16 +527,14 @@ static void dec_pending(struct dm_io *io
 		if (io->error == DM_ENDIO_REQUEUE) {
 			/*
 			 * Target requested pushing back the I/O.
-			 * This must be handled before the sleeper on
-			 * suspend queue merges the pushback list.
 			 */
-			spin_lock_irqsave(&io->md->pushback_lock, flags);
+			spin_lock_irqsave(&io->md->deferred_lock, flags);
 			if (__noflush_suspending(io->md))
-				bio_list_add(&io->md->pushback, io->bio);
+				bio_list_add(&io->md->deferred, io->bio);
 			else
 				/* noflush suspend was interrupted. */
 				io->error = -EIO;
-			spin_unlock_irqrestore(&io->md->pushback_lock, flags);
+			spin_unlock_irqrestore(&io->md->deferred_lock, flags);
 		}
 
 		end_io_acct(io);
@@ -1090,7 +1089,7 @@ static struct mapped_device *alloc_dev(i
 
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
-	spin_lock_init(&md->pushback_lock);
+	spin_lock_init(&md->deferred_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1412,26 +1411,21 @@ static void dm_wq_work(struct work_struc
 
 	down_write(&md->io_lock);
 
-	while ((c = bio_list_pop(&md->deferred)))
+next_bio:
+	spin_lock_irq(&md->deferred_lock);
+	c = bio_list_pop(&md->deferred);
+	spin_unlock_irq(&md->deferred_lock);
+
+	if (c) {
 		__process_bio(md, c);
+		goto next_bio;
+	}
 
 	clear_bit(DMF_BLOCK_IO, &md->flags);
 
 	up_write(&md->io_lock);
 }
 
-static void __merge_pushback_list(struct mapped_device *md)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&md->pushback_lock, flags);
-	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
-	bio_list_merge_head(&md->deferred, &md->pushback);
-	bio_list_init(&md->pushback);
-	spin_unlock_irqrestore(&md->pushback_lock, flags);
-}
-
-
 static void dm_queue_flush(struct mapped_device *md)
 {
 	queue_work(md->wq, &md->work);
@@ -1556,7 +1550,7 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 
 	if (noflush)
-		__merge_pushback_list(md);
+		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 	up_write(&md->io_lock);
 
 	/* were we interrupted ? */
