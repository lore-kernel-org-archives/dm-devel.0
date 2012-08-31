From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] multipath queues build invalid requests when all
 paths are lost
Date: Fri, 31 Aug 2012 11:04:28 -0400
Message-ID: <20120831150428.GA31566@fury.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids


The DM module recalculates queue limits based only on devices which currently
exist in the table.  This creates a problem in the event all devices are
temporarily removed such as all fibre channel paths being lost in multipath.
DM will reset the limits to the maximum permissible, which can then assemble
requests which exceed the limits of the paths when the paths are restored.  The
request will fail the blk_rq_check_limits() test when sent to a path with
lower limits, and will be retried without end by multipath.

This becomes a much bigger issue after fe86cdcef73ba19a2246a124f0ddbd19b14fb549.
Previously, most storage had max_sector limits which exceeded the default
value used.  This meant most setups wouldn't trigger this issue as the default
values used when there were no paths were still less than the limits of the
underlying devices.  Now that the default stacking values are no longer
constrained, any hardware setup can potentially hit this issue.

This proposed patch alters the DM limit behavior.  With the patch, DM queue
limits only go one way: more restrictive.  As paths are removed, the queue's
limits will maintain their current settings.  As paths are added, the queue's
limits may become more restrictive.

Signed-off-by: David Jeffery <djeffery@redhat.com>

---
 dm-table.c |    2 --
 dm.c       |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f900690..5e7e3ca 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1222,8 +1222,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	struct queue_limits ti_limits;
 	unsigned i = 0;
 
-	blk_set_stacking_limits(limits);
-
 	while (i < dm_table_get_num_targets(table)) {
 		blk_set_stacking_limits(&ti_limits);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..fbf89d5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1832,6 +1832,7 @@ static void dm_init_md_queue(struct mapped_device *md)
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+	blk_set_stacking_limits(&md->queue->limits);
 }
 
 /*
@@ -2419,6 +2420,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 	if (!dm_suspended_md(md))
 		goto out;
 
+	limits = md->queue->limits;
 	r = dm_calculate_queue_limits(table, &limits);
 	if (r) {
 		map = ERR_PTR(r);
