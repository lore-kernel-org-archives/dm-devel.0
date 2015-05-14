From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 07/14] dm: factor out a common
	cleanup_mapped_device()
Date: Thu, 14 May 2015 17:05:05 -0400
Message-ID: <1431637512-64245-8-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Introduce a single common method for cleaning up a DM device's
mapped_device.  No functional change, just eliminates duplication of
delicate mapped_device cleanup code.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 78 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c894d13..d31f7a3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2167,6 +2167,40 @@ static void dm_init_old_md_queue(struct mapped_device *md)
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 }
 
+static void cleanup_mapped_device(struct mapped_device *md)
+{
+	cleanup_srcu_struct(&md->io_barrier);
+
+	if (md->wq)
+		destroy_workqueue(md->wq);
+	if (md->kworker_task)
+		kthread_stop(md->kworker_task);
+	if (md->io_pool)
+		mempool_destroy(md->io_pool);
+	if (md->rq_pool)
+		mempool_destroy(md->rq_pool);
+	if (md->bs)
+		bioset_free(md->bs);
+
+	if (md->disk) {
+		spin_lock(&_minor_lock);
+		md->disk->private_data = NULL;
+		spin_unlock(&_minor_lock);
+		if (blk_get_integrity(md->disk))
+			blk_integrity_unregister(md->disk);
+		del_gendisk(md->disk);
+		put_disk(md->disk);
+	}
+
+	if (md->queue)
+		blk_cleanup_queue(md->queue);
+
+	if (md->bdev) {
+		bdput(md->bdev);
+		md->bdev = NULL;
+	}
+}
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -2212,13 +2246,13 @@ static struct mapped_device *alloc_dev(int minor)
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
-		goto bad_queue;
+		goto bad;
 
 	dm_init_md_queue(md);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
-		goto bad_disk;
+		goto bad;
 
 	atomic_set(&md->pending[0], 0);
 	atomic_set(&md->pending[1], 0);
@@ -2239,11 +2273,11 @@ static struct mapped_device *alloc_dev(int minor)
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
 	if (!md->wq)
-		goto bad_thread;
+		goto bad;
 
 	md->bdev = bdget_disk(md->disk, 0);
 	if (!md->bdev)
-		goto bad_bdev;
+		goto bad;
 
 	bio_init(&md->flush_bio);
 	md->flush_bio.bi_bdev = md->bdev;
@@ -2260,15 +2294,8 @@ static struct mapped_device *alloc_dev(int minor)
 
 	return md;
 
-bad_bdev:
-	destroy_workqueue(md->wq);
-bad_thread:
-	del_gendisk(md->disk);
-	put_disk(md->disk);
-bad_disk:
-	blk_cleanup_queue(md->queue);
-bad_queue:
-	cleanup_srcu_struct(&md->io_barrier);
+bad:
+	cleanup_mapped_device(md);
 bad_io_barrier:
 	free_minor(minor);
 bad_minor:
@@ -2285,32 +2312,13 @@ static void free_dev(struct mapped_device *md)
 	int minor = MINOR(disk_devt(md->disk));
 
 	unlock_fs(md);
-	destroy_workqueue(md->wq);
 
-	if (md->kworker_task)
-		kthread_stop(md->kworker_task);
-	if (md->io_pool)
-		mempool_destroy(md->io_pool);
-	if (md->rq_pool)
-		mempool_destroy(md->rq_pool);
-	if (md->bs)
-		bioset_free(md->bs);
+	cleanup_mapped_device(md);
+	if (md->use_blk_mq)
+		blk_mq_free_tag_set(&md->tag_set);
 
-	cleanup_srcu_struct(&md->io_barrier);
 	free_table_devices(&md->table_devices);
 	dm_stats_cleanup(&md->stats);
-
-	spin_lock(&_minor_lock);
-	md->disk->private_data = NULL;
-	spin_unlock(&_minor_lock);
-	if (blk_get_integrity(md->disk))
-		blk_integrity_unregister(md->disk);
-	del_gendisk(md->disk);
-	put_disk(md->disk);
-	blk_cleanup_queue(md->queue);
-	if (md->use_blk_mq)
-		blk_mq_free_tag_set(&md->tag_set);
-	bdput(md->bdev);
 	free_minor(minor);
 
 	module_put(THIS_MODULE);
-- 
2.3.2 (Apple Git-55)
