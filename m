From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 6/6] dm mpath: delay the requeue of blk-mq requests while all paths down
Date: Wed, 14 Sep 2016 12:29:36 -0400
Message-ID: <1473870576-54331-7-git-send-email-snitzer@redhat.com>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

Return DM_MAPIO_DELAY_REQUEUE from .clone_and_map_rq.  Also, return
false from .busy, if all paths are down, so that blk-mq requests get
mapped via .clone_and_map_rq -- which results in DM_MAPIO_DELAY_REQUEUE
being returned to dm-rq.

This change allows for a noticeable reduction in cpu utilization
(reduced kworker load) while all paths are down, e.g.:

system CPU idleness (as measured by fio's --idle-prof=system):
before: system: 86.58%
after:  system: 98.60%

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f69715b..f31fa13 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -550,9 +550,9 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (!must_push_back_rq(m))
-			r = -EIO;	/* Failed */
-		return r;
+		if (must_push_back_rq(m))
+			return DM_MAPIO_DELAY_REQUEUE;
+		return -EIO;	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		pg_init_all_paths(m);
@@ -1992,11 +1992,14 @@ static int multipath_busy(struct dm_target *ti)
 	struct priority_group *pg, *next_pg;
 	struct pgpath *pgpath;
 
-	/* pg_init in progress or no paths available */
-	if (atomic_read(&m->pg_init_in_progress) ||
-	    (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)))
+	/* pg_init in progress */
+	if (atomic_read(&m->pg_init_in_progress))
 		return true;
 
+	/* no paths available, for blk-mq: rely on IO mapping to delay requeue */
+	if (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
+		return (m->queue_mode != DM_TYPE_MQ_REQUEST_BASED);
+
 	/* Guess which priority_group will be used at next mapping time */
 	pg = lockless_dereference(m->current_pg);
 	next_pg = lockless_dereference(m->next_pg);
-- 
2.7.4 (Apple Git-66)

