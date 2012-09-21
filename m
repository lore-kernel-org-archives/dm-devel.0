From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3] dm: re-use live table's limits if next table
 has no data devices
Date: Fri, 21 Sep 2012 11:37:44 -0400
Message-ID: <20120921153744.GA5967@redhat.com>
References: <20120914204133.GA376@redhat.com>
	<213748621.1049831.1347911069189.JavaMail.root@redhat.com>
	<20120918114022.GA17356@agk-dp.fab.redhat.com>
	<20120918130226.GA8065@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120918130226.GA8065@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

DM recalculates queue limits based only on devices which currently exist
in the table.  This creates a problem in the event all devices are
temporarily removed such as all paths being lost in multipath.  DM will
reset the limits to the maximum permissible, which can then assemble
requests which exceed the limits of the paths when the paths are
restored.  The request will fail the blk_rq_check_limits() test when
sent to a path with lower limits, and will be retried without end by
multipath.  This became a much bigger issue after commit fe86cdcef
("block: do not artificially constrain max_sectors for stacking
drivers").

Add a safety net that will re-use the DM device's existing limits in the
event that DM device has a temporary table that doesn't have any
component devices.

Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   30 ++++++++++++++++++++++++++++++
 drivers/md/dm.c       |    8 +++++++-
 drivers/md/dm.h       |    1 +
 3 files changed, 38 insertions(+), 1 deletion(-)

Index: linux/drivers/md/dm-table.c
===================================================================
--- linux.orig/drivers/md/dm-table.c
+++ linux/drivers/md/dm-table.c
@@ -1212,6 +1212,36 @@ struct dm_target *dm_table_find_target(s
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+static int count_device(struct dm_target *ti, struct dm_dev *dev,
+			sector_t start, sector_t len, void *data)
+{
+	unsigned *num_devices_p = data;
+	*num_devices_p += 1;
+	return 0;
+}
+
+bool dm_table_has_no_data_devices(struct dm_table *table)
+{
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0, num_devices = 0;
+
+	while (i < dm_table_get_num_targets(table)) {
+		ti = dm_table_get_target(table, i++);
+
+		if (!ti->type->iterate_devices) {
+			/* unfortunately, must assume there are devices */
+			num_devices = 1;
+			break;
+		}
+
+		ti->type->iterate_devices(ti, count_device, &num_devices);
+		if (num_devices)
+			break;
+	}
+
+	return num_devices == 0;
+}
+
 /*
  * Establish the new table's queue_limits and validate them.
  */
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c
+++ linux/drivers/md/dm.c
@@ -2422,7 +2422,7 @@ static void dm_queue_flush(struct mapped
  */
 struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
-	struct dm_table *map = ERR_PTR(-EINVAL);
+	struct dm_table *live_map, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
 	int r;
 
@@ -2432,6 +2432,12 @@ struct dm_table *dm_swap_table(struct ma
 	if (!dm_suspended_md(md))
 		goto out;
 
+	/* re-use live table's limits if next table has no data devices */
+	live_map = dm_get_live_table(md);
+	if (live_map && dm_table_has_no_data_devices(table))
+		limits = md->queue->limits;
+	dm_table_put(live_map);
+
 	r = dm_calculate_queue_limits(table, &limits);
 	if (r) {
 		map = ERR_PTR(r);
Index: linux/drivers/md/dm.h
===================================================================
--- linux.orig/drivers/md/dm.h
+++ linux/drivers/md/dm.h
@@ -54,6 +54,7 @@ void dm_table_event_callback(struct dm_t
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
+bool dm_table_has_no_data_devices(struct dm_table *table);
 int dm_calculate_queue_limits(struct dm_table *table,
 			      struct queue_limits *limits);
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
