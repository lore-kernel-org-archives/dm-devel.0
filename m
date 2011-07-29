From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: configure DM flush capabilities based
	on underlying devices
Date: Fri, 29 Jul 2011 12:34:57 -0400
Message-ID: <1311957297-20704-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

DM has always arvertised both REQ_FLUSH and REQ_FUA flush capabilities
regardless of whether or not a given DM device's underlying devices
also advertised a need for them.

Block's flush-merge changes from 2.6.39 have proven to be more costly
for DM devices.  Performance regressions have been reported even when
DM's underlying devices do not advertise that they have a write cache.

Fix the performance regressions by configuring a DM device's flushing
capabilities based on those of the underlying devices' capabilities.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |    1 -
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5e8e2f3..d082f2a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1270,9 +1270,13 @@ static void dm_table_set_integrity(struct dm_table *t)
 			       blk_get_integrity(template_disk));
 }
 
+bool dm_table_supports_flush(struct dm_table *t, unsigned flush);
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
+	unsigned flush = 0;
+
 	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
@@ -1283,6 +1287,13 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
+	if (dm_table_supports_flush(t, REQ_FLUSH)) {
+		flush |= REQ_FLUSH;
+		if (dm_table_supports_flush(t, REQ_FUA))
+			flush |= REQ_FUA;
+	}
+	blk_queue_flush(q, flush);
+
 	dm_table_set_integrity(t);
 
 	/*
@@ -1460,3 +1471,37 @@ bool dm_table_supports_discards(struct dm_table *t)
 
 	return 0;
 }
+
+static int device_flush_capable(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	unsigned flush = (*(unsigned *)data);
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && (q->flush_flags & flush);
+}
+
+bool dm_table_supports_flush(struct dm_table *t, unsigned flush)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	/*
+	 * Require at least one underlying device to support flushes.
+	 * t->devices includes internal dm devices such as mirror logs
+	 * so we need to use iterate_devices here, which targets
+	 * supporting flushes must provide.
+	 */
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->num_flush_requests)
+			continue;
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, device_flush_capable, &flush))
+			return 1;
+	}
+
+	return 0;
+}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 09fb4cd..58d5cae 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1802,7 +1802,6 @@ static void dm_init_md_queue(struct mapped_device *md)
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-	blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA);
 }
 
 /*
-- 
1.7.4.4
