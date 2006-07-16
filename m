From: Ishai Rabinovitz <ishai@mellanox.co.il>
Subject: [PATCH] Fix a bug in error path in alloc_dev
Date: Sun, 16 Jul 2006 22:30:30 +0300
Message-ID: <20060716193030.GA2486@mellanox.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

While reading the code I found a bug in the error path in alloc_dev in dm.c

When blk_alloc_queue fails there is no call to free_minor.

This patch fixes the problem.

Signed-off-by: Ishai Rabinovitz <ishai@mellanox.co.il>

Index: linux-2.6.18-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.18-devel.orig/drivers/md/dm.c
+++ linux-2.6.18-devel/drivers/md/dm.c
@@ -903,7 +903,7 @@ static struct mapped_device *alloc_dev(i
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
-		goto bad1;
+		goto bad1_free_minor;
 
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
@@ -953,6 +953,7 @@ static struct mapped_device *alloc_dev(i
 	mempool_destroy(md->io_pool);
  bad2:
 	blk_cleanup_queue(md->queue);
+ bad1_free_minor:
 	free_minor(minor);
  bad1:
 	module_put(THIS_MODULE);
-- 
Ishai Rabinovitz
