From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 02/13] dm-mpath: Avoid that path removal can trigger an infinite loop
Date: Thu, 27 Apr 2017 10:11:15 -0700
Message-ID: <20170427171126.26814-3-bart.vanassche@sandisk.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170427171126.26814-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: dm-devel.ids

If blk_get_request() fails check whether the failure is due to
a path being removed. If that is the case fail the path by
triggering a call to fail_path(). This patch avoids that the
following scenario can be encountered while removing paths:
* CPU usage of a kworker thread jumps to 100%.
* Removing the dm device becomes impossible.

Delay requeueing if blk_get_request() returns -EBUSY or
-EWOULDBLOCK because in these cases immediate requeuing is
inappropriate.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index eff7ecea1d2a..cc41e34607c3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -490,6 +490,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	struct pgpath *pgpath;
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio = get_mpio(map_context);
+	struct request_queue *q;
 	struct request *clone;
 
 	/* Do we need to select a new pgpath? */
@@ -512,13 +513,19 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	mpio->nr_bytes = nr_bytes;
 
 	bdev = pgpath->path.dev->bdev;
-
-	clone = blk_get_request(bdev_get_queue(bdev),
-			rq->cmd_flags | REQ_NOMERGE,
-			GFP_ATOMIC);
+	q = bdev_get_queue(bdev);
+	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
-		return r;
+		pr_debug("blk_get_request() returned %ld%s - requeuing\n",
+			 PTR_ERR(clone), blk_queue_dying(q) ?
+			 " (path offline)" : "");
+		if (blk_queue_dying(q)) {
+			atomic_inc(&m->pg_init_in_progress);
+			activate_or_offline_path(pgpath);
+			return DM_MAPIO_REQUEUE;
+		}
+		return DM_MAPIO_DELAY_REQUEUE;
 	}
 	clone->bio = clone->biotail = NULL;
 	clone->rq_disk = bdev->bd_disk;
-- 
2.12.2
