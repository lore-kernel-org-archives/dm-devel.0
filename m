From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-table: make dm_table_supports_discards static
Date: Thu, 10 Jul 2014 12:23:07 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407101220010.24163@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

The function dm_table_supports_discards is called only from dm-table.c - 
so make it static. The function is moved upward, just before 
dm_table_set_restrictions that calls it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |   72 +++++++++++++++++++++++++-------------------------
 drivers/md/dm.h       |    1 
 2 files changed, 36 insertions(+), 37 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2014-07-10 18:13:50.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2014-07-10 18:19:18.000000000 +0200
@@ -1430,6 +1430,42 @@ static bool dm_table_supports_write_same
 	return true;
 }
 
+static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && blk_queue_discard(q);
+}
+
+static bool dm_table_supports_discards(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	/*
+	 * Unless any target used by the table set discards_supported,
+	 * require at least one underlying device to support discards.
+	 * t->devices includes internal dm devices such as mirror logs
+	 * so we need to use iterate_devices here, which targets
+	 * supporting discard selectively must provide.
+	 */
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->num_discard_bios)
+			continue;
+
+		if (ti->discards_supported)
+			return 1;
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
+			return 1;
+	}
+
+	return 0;
+}
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1636,39 +1672,3 @@ void dm_table_run_md_queue_async(struct 
 }
 EXPORT_SYMBOL(dm_table_run_md_queue_async);
 
-static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
-{
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return q && blk_queue_discard(q);
-}
-
-bool dm_table_supports_discards(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i = 0;
-
-	/*
-	 * Unless any target used by the table set discards_supported,
-	 * require at least one underlying device to support discards.
-	 * t->devices includes internal dm devices such as mirror logs
-	 * so we need to use iterate_devices here, which targets
-	 * supporting discard selectively must provide.
-	 */
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (!ti->num_discard_bios)
-			continue;
-
-		if (ti->discards_supported)
-			return 1;
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
-			return 1;
-	}
-
-	return 0;
-}
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h	2014-07-10 18:13:50.000000000 +0200
+++ linux-2.6/drivers/md/dm.h	2014-07-10 18:19:18.000000000 +0200
@@ -72,7 +72,6 @@ int dm_table_any_busy_target(struct dm_t
 unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-bool dm_table_supports_discards(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
