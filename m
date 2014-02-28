From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/8] dm mpath: remove extra nesting in map
	function
Date: Fri, 28 Feb 2014 15:33:48 +0100
Message-ID: <1393598029-67995-8-git-send-email-hare@suse.de>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393598029-67995-1-git-send-email-hare@suse.de>
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

From: Mike Snitzer <snitzer@redhat.com>

Return early for case when no path exists, and when the
pathgroup isn't ready. This eliminates the need for
extra nesting for the the common case.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5e92d51..eaf4855 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -398,29 +398,31 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 
 	pgpath = m->current_pgpath;
 
-	if (pgpath) {
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
-			goto out_unlock;
-		}
+	if (!pgpath) {
+		if (!__must_push_back(m))
+			r = -EIO;	/* Failed */
+		goto out_unlock;
+	}
+	if (!pg_ready(m)) {
 		__pg_init_all_paths(m);
-	} else if (!__must_push_back(m))
-		r = -EIO;	/* Failed */
+		goto out_unlock;
+	}
+	if (set_mapinfo(m, map_context) < 0)
+		/* ENOMEM, requeue */
+		goto out_unlock;
+
+	bdev = pgpath->path.dev->bdev;
+	clone->q = bdev_get_queue(bdev);
+	clone->rq_disk = bdev->bd_disk;
+	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	mpio = map_context->ptr;
+	mpio->pgpath = pgpath;
+	mpio->nr_bytes = nr_bytes;
+	if (pgpath->pg->ps.type->start_io)
+		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
+					      &pgpath->path,
+					      nr_bytes);
+	r = DM_MAPIO_REMAPPED;
 
 out_unlock:
 	spin_unlock_irqrestore(&m->lock, flags);
-- 
1.7.12.4
