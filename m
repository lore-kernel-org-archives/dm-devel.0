From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/1] dm-mpath: don't fail paths on first error
Date: Mon, 2 Jun 2008 02:50:41 -0500
Message-ID: <20080613101812.5F8BB8E08A1@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

If we get a transient error then we may not want to fail the path
right away. This patch fails the path after X seconds.

I am not sure how valuable this is. If users just set the no_path_retry
option then we end up with similar results. Without the patch + no_path_retry
then the IO is quickly sent to the new path and has a smaller chance of
getting sent to a queue that is blocked. With the patch we might avoid
some of the path failure messages that scare users. But most users
are not setting no_path_retry. Will they set this new timer?

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e7ee59e..4a24219 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -25,12 +25,19 @@
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
 
+/*
+ * TODO: pass this in instead of hard coding it
+ */
+#define DM_DEV_LOSS_TMO 5 * HZ
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
 
 	struct priority_group *pg;	/* Owning PG */
 	unsigned fail_count;		/* Cumulative failure count */
+	unsigned curr_fail_count;
+	unsigned long fail_start;
 
 	struct dm_path path;
 };
@@ -313,6 +320,14 @@ static int map_io(struct multipath *m, struct bio *bio,
 
 	spin_lock_irqsave(&m->lock, flags);
 
+	/*
+	 * If the path is experiencing problems but is not marked failed,
+	 * then throttle it until IO starts to execute correctly again.
+	 */
+	if (m->current_pgpath && m->current_pgpath->curr_fail_count > 0 &&
+	    m->repeat_count > 1)
+		m->repeat_count = 2;
+
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
@@ -847,7 +862,15 @@ static int fail_path(struct pgpath *pgpath)
 	if (!pgpath->path.is_active)
 		goto out;
 
-	DMWARN("Failing path %s.", pgpath->path.dev->name);
+	if (!pgpath->curr_fail_count) {
+		pgpath->fail_start = jiffies;
+		goto choose_new_path;
+	} else if (time_after_eq(pgpath->fail_start + DM_DEV_LOSS_TMO,
+				 jiffies))
+		goto choose_new_path;
+
+	DMWARN("Failing Path %s current fail count %d.",
+		pgpath->path.dev->name, pgpath->curr_fail_count);
 
 	pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
 	pgpath->path.is_active = 0;
@@ -855,6 +878,9 @@ static int fail_path(struct pgpath *pgpath)
 
 	m->nr_valid_paths--;
 
+choose_new_path:
+	pgpath->curr_fail_count++;
+
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
@@ -880,6 +906,9 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	spin_lock_irqsave(&m->lock, flags);
 
+	pgpath->fail_start = 0;
+	pgpath->curr_fail_count = 0;
+
 	if (pgpath->path.is_active)
 		goto out;
 
@@ -1073,8 +1102,11 @@ static int do_end_io(struct multipath *m, struct bio *bio,
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
 
-	if (!error)
+	if (!error) {
+		mpio->pgpath->curr_fail_count = 0;
+		mpio->pgpath->fail_start = 0;
 		return 0;	/* I/O complete */
+	}
 
 	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
 		return error;
-- 
1.5.4.1


--------------070800010905090700030600--
