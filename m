From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] dm mpath: reduce memory pressure when
	requeuing
Date: Tue,  4 Feb 2014 11:54:38 +0100
Message-ID: <1391511280-29325-6-git-send-email-hare@suse.de>
References: <1391511280-29325-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391511280-29325-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When multipath needs to requeue I/O in the block layer the per-request
context shouldn't be allocated, as it will be freed immediately
afterwards anyway.  Avoiding this memory allocation will reduce memory
pressure during requeuing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0355adc..4f14445 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -378,12 +378,12 @@ static int __must_push_back(struct multipath *m)
 static int map_io(struct multipath *m, struct request *clone,
 		  union map_info *map_context)
 {
-	int r = DM_MAPIO_REMAPPED;
+	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = blk_rq_bytes(clone);
 	unsigned long flags;
 	struct pgpath *pgpath;
 	struct block_device *bdev;
-	struct dm_mpath_io *mpio = map_context->ptr;
+	struct dm_mpath_io *mpio;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -396,27 +396,29 @@ static int map_io(struct multipath *m, struct request *clone,
 
 	if (pgpath) {
 		if (pg_ready(m)) {
+			if (set_mapinfo(m, map_context) < 0)
+				/* ENOMEM, requeue */
+				goto out_unlock;
+
 			bdev = pgpath->path.dev->bdev;
 			clone->q = bdev_get_queue(bdev);
 			clone->rq_disk = bdev->bd_disk;
+			clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+			mpio = map_context->ptr;
 			mpio->pgpath = pgpath;
 			mpio->nr_bytes = nr_bytes;
 			if (pgpath->pg->ps.type->start_io)
 				pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 							      &pgpath->path,
 							      nr_bytes);
-		} else {
-			__pg_init_all_paths(m, 0);
-			r = DM_MAPIO_REQUEUE;
+			r = DM_MAPIO_REMAPPED;
+			goto out_unlock;
 		}
-	} else {
-		/* No path */
-		if (__must_push_back(m))
-			r = DM_MAPIO_REQUEUE;
-		else
-			r = -EIO;	/* Failed */
-	}
+		__pg_init_all_paths(m, 0);
+	} else if (!__must_push_back(m))
+		r = -EIO;	/* Failed */
 
+out_unlock:
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return r;
@@ -912,19 +914,9 @@ static void multipath_dtr(struct dm_target *ti)
 static int multipath_map(struct dm_target *ti, struct request *clone,
 			 union map_info *map_context)
 {
-	int r;
 	struct multipath *m = (struct multipath *) ti->private;
 
-	if (set_mapinfo(m, map_context) < 0)
-		/* ENOMEM, requeue */
-		return DM_MAPIO_REQUEUE;
-
-	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	r = map_io(m, clone, map_context);
-	if (r < 0 || r == DM_MAPIO_REQUEUE)
-		clear_mapinfo(m, map_context);
-
-	return r;
+	return map_io(m, clone, map_context);
 }
 
 /*
-- 
1.7.12.4
