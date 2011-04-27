From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] dm: relax discard restrictions
Date: Wed, 27 Apr 2011 11:06:23 -0400
Message-ID: <20110427150623.GC13487@infradead.org>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

With targets like dm-thinp we might want to allow discard even if the
underlying devices don't support them natively.  This patch is the
extreme variant of not restricting discard support at all, but maybe
there are other options.  Or maybe we should keep the old
dm_table_supports_discards function as a helper for targets that
want simple discard passthrough?

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2011-04-27 16:44:09.231032143 +0200
+++ linux-2.6/drivers/md/dm-table.c	2011-04-27 16:51:39.415259952 +0200
@@ -1136,10 +1136,10 @@ void dm_table_set_restrictions(struct dm
 	 */
 	q->limits = *limits;
 
-	if (!dm_table_supports_discards(t))
-		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
-	else
+	if (t->discards_supported)
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 
 	dm_table_set_integrity(t);
 
@@ -1303,39 +1303,6 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
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
-	if (!t->discards_supported)
-		return 0;
-
-	/*
-	 * Ensure that at least one underlying device supports discards.
-	 * t->devices includes internal dm devices such as mirror logs
-	 * so we need to use iterate_devices here, which targets
-	 * supporting discard must provide.
-	 */
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
-			return 1;
-	}
-
-	return 0;
-}
-
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h	2011-04-27 16:50:32.992286464 +0200
+++ linux-2.6/drivers/md/dm.h	2011-04-27 16:50:34.898942802 +0200
@@ -61,7 +61,6 @@ int dm_table_any_congested(struct dm_tab
 int dm_table_any_busy_target(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-bool dm_table_supports_discards(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
