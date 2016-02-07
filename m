From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 15/15] dm mpath: remove unnecessary
	casts in front of ti->private
Date: Sun,  7 Feb 2016 10:53:37 -0500
Message-ID: <1454860417-3203-16-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 199d3d3..177a016 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -402,7 +402,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 			   union map_info *map_context,
 			   struct request *rq, struct request **__clone)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
 	struct pgpath *pgpath;
@@ -1350,7 +1350,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
  */
 static void multipath_presuspend(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	queue_if_no_path(m, 0, 1);
 }
@@ -1369,7 +1369,7 @@ static void multipath_postsuspend(struct dm_target *ti)
  */
 static void multipath_resume(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1398,7 +1398,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 {
 	int sz = 0;
 	unsigned long flags;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1506,7 +1506,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r = -EINVAL;
 	struct dm_dev *dev;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	action_fn action;
 
 	mutex_lock(&m->work_mutex);
-- 
2.5.4 (Apple Git-61)
