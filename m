From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/7] dm mpath: remove extra nesting in map
	function when path exists
Date: Mon,  3 Feb 2014 15:28:46 -0500
Message-ID: <1391459326-21569-8-git-send-email-snitzer@redhat.com>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Return early for case when no path exists, this eliminates the need for
extra nesting for the case when a path exists (the common case).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 971fbec..272e7d4 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -392,32 +392,35 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 
 	pgpath = m->current_pgpath;
 
-	if (pgpath) {
-		if (__pgpath_busy(pgpath))
-			goto out_unlock;
+	if (!pgpath) {
+		if (!__must_push_back(m))
+			r = -EIO;	/* Failed */
+		goto out_unlock;
+	}
+
+	if (__pgpath_busy(pgpath))
+		goto out_unlock;
 
-		if (pg_ready(m)) {
-			if (set_mapinfo(m, map_context) < 0)
-				/* ENOMEM, requeue */
-				goto out_unlock;
-
-			bdev = pgpath->path.dev->bdev;
-			clone->q = bdev_get_queue(bdev);
-			clone->rq_disk = bdev->bd_disk;
-			clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-			mpio = map_context->ptr;
-			mpio->pgpath = pgpath;
-			mpio->nr_bytes = nr_bytes;
-			if (pgpath->pg->ps.type->start_io)
-				pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
-							      &pgpath->path,
-							      nr_bytes);
-			r = DM_MAPIO_REMAPPED;
+	if (pg_ready(m)) {
+		if (set_mapinfo(m, map_context) < 0)
+			/* ENOMEM, requeue */
 			goto out_unlock;
-		}
-		__pg_init_all_paths(m, 0);
-	} else if (!__must_push_back(m))
-		r = -EIO;	/* Failed */
+
+		bdev = pgpath->path.dev->bdev;
+		clone->q = bdev_get_queue(bdev);
+		clone->rq_disk = bdev->bd_disk;
+		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+		mpio = map_context->ptr;
+		mpio->pgpath = pgpath;
+		mpio->nr_bytes = nr_bytes;
+		if (pgpath->pg->ps.type->start_io)
+			pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
+						      &pgpath->path,
+						      nr_bytes);
+		r = DM_MAPIO_REMAPPED;
+		goto out_unlock;
+	}
+	__pg_init_all_paths(m, 0);
 
 out_unlock:
 	spin_unlock_irqrestore(&m->lock, flags);
-- 
1.8.1.4
