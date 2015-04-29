From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix blk-mq request-based DM queue
	initialization
Date: Tue, 28 Apr 2015 20:59:13 -0400
Message-ID: <1430269153-647-1-git-send-email-snitzer@redhat.com>
References: <20150425092358.GA15550@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150425092358.GA15550@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Commit bfebd1cdb4 ("dm: add full blk-mq support to request-based DM")
didn't properly account for the need to short-circuit re-initializing
DM's blk-mq request_queue if it was already initialized.

Fix dm_init_request_based_blk_mq_queue() to return early if the
mapped_device's tag_set already has its driver_data set to the
mapped_device pointer.

Otherwise, reloading a blk-mq request-based DM table (either manually or
via multipathd) resulted in errors like the following:

WARNING: CPU: 9 PID: 2836 at lib/list_debug.c:36 __list_add+0x92/0xc0()
...
kobject (ffff880035625fd0): tried to init an initialized object, something is seriously wrong.
...
sysfs: cannot create duplicate filename '/devices/virtual/block/dm-13/mq'
...
kobject_add_internal failed for mq with -EEXIST, don't try to register things with the same name in the same directory.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1567f6c..c834a94 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2704,6 +2704,9 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	struct request_queue *q;
 	int err;
 
+	if (md->tag_set.driver_data == md)
+		return 0;
+
 	memset(&md->tag_set, 0, sizeof(md->tag_set));
 	md->tag_set.ops = &dm_mq_ops;
 	md->tag_set.queue_depth = BLKDEV_MAX_RQ;
@@ -2719,7 +2722,7 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 
 	err = blk_mq_alloc_tag_set(&md->tag_set);
 	if (err)
-		return err;
+		goto out;
 
 	q = blk_mq_init_allocated_queue(&md->tag_set, md->queue);
 	if (IS_ERR(q)) {
@@ -2739,6 +2742,8 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 
 out_tag_set:
 	blk_mq_free_tag_set(&md->tag_set);
+out:
+	memset(&md->tag_set, 0, sizeof(md->tag_set));
 	return err;
 }
 
-- 
2.3.2 (Apple Git-55)
