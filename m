From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: Introduce DMF_MERGE_IS_OPTIONAL flag
Date: Wed, 22 Jun 2011 19:57:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106221956590.9934@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the updated patch, as we discussed on irc.

Mikulas

---

dm: Introduce DMF_MERGE_IS_OPTIONAL flag

DMF_MERGE_IS_OPTIONAL flag is set in "struct mapped_device". It means that
bvec_merge_fn function is only a hint and can be ignored for performance
reasons (for example, when we need to write to the whole chunk in snapshots).

DMF_MERGE_IS_OPTIONAL is set if: for every underlying device, the device
either doesn't have a bvec_merge_fn function or has a bvec_merge_fn function
and has DMF_MERGE_IS_OPTIONAL set.

We change logic in dm_set_device_limits:
Before the patch, dm_set_device_limits restricted bio size to page size if
the underlying device had a merge function and the target didn't provide a merge
function.
After the patch, dm_set_device_limits restricts bio size to page size if
the underlying device has a merge function, doesn't have DMF_MERGE_IS_OPTIONAL
flag and the target doesn't provide a merge function.

The snapshot target can't provide a merge function (because when the merge
function is called, it is impossible to determine where the bio will be
remapped).

This patch removes 4k limit for snapshots if the snapshot store is located
on a device without merge function. Thus (together with a previous patch for
optimizing full chunk write), it improves performance from 29MB/s to 40MB/s
when writing to the filesystem on snapshot store.

If the snapshot store is placed on a device with merge function (such as
md-raid), device mapper still limits all bios to page size. There is no easy
workaround possible.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    2 -
 drivers/md/dm.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.h       |    2 +
 3 files changed, 64 insertions(+), 1 deletion(-)

Index: linux-2.6.39-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm.c	2011-06-23 01:21:54.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm.c	2011-06-23 01:36:36.000000000 +0200
@@ -109,6 +109,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_MERGE_IS_OPTIONAL 6
 
 /*
  * Work processed by per-device workqueue.
@@ -1986,6 +1987,59 @@ static void __set_size(struct mapped_dev
 }
 
 /*
+ * Return 1 if the request queue have compulsory merge_bvec_fn function.
+ *
+ * If this function returns 0, then merge_bvec_fn is only a hint and may
+ * be ignored.
+ */
+int dm_queue_merge_is_compulsory(struct request_queue *q)
+{
+	if (!q->merge_bvec_fn)
+		return 0;
+
+	if (q->make_request_fn == dm_request) {
+		struct mapped_device *dev_md = q->queuedata;
+		if (test_bit(DMF_MERGE_IS_OPTIONAL, &dev_md->flags))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int dm_device_merge_is_compulsory(struct dm_target *ti,
+					 struct dm_dev *dev, sector_t start,
+					 sector_t len, void *data)
+{
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return dm_queue_merge_is_compulsory(q);
+}
+
+/*
+ * Return 1 if merge_bvec_fn is an optional hint and can be ignored.
+ */
+static int dm_table_merge_is_optional(struct dm_table *table)
+{
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(table)) {
+		struct dm_target *ti;
+
+		ti = dm_table_get_target(table, i++);
+
+		if (!ti->type->iterate_devices)
+			continue;
+
+		if (ti->type->iterate_devices(ti, dm_device_merge_is_compulsory,
+					      NULL))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
  * Returns old map, which caller must destroy.
  */
 static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
@@ -1995,6 +2049,7 @@ static struct dm_table *__bind(struct ma
 	struct request_queue *q = md->queue;
 	sector_t size;
 	unsigned long flags;
+	int merge_is_optional;
 
 	size = dm_table_get_size(t);
 
@@ -2020,10 +2075,16 @@ static struct dm_table *__bind(struct ma
 
 	__bind_mempools(md, t);
 
+	merge_is_optional = dm_table_merge_is_optional(t);
+
 	write_lock_irqsave(&md->map_lock, flags);
 	old_map = md->map;
 	md->map = t;
 	dm_table_set_restrictions(t, q, limits);
+	if (merge_is_optional)
+		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
+	else
+		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	write_unlock_irqrestore(&md->map_lock, flags);
 
 	return old_map;
Index: linux-2.6.39-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-table.c	2011-06-23 01:21:54.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-table.c	2011-06-23 01:23:59.000000000 +0200
@@ -523,7 +523,7 @@ int dm_set_device_limits(struct dm_targe
 	 * smaller I/O, just to be safe.
 	 */
 
-	if (q->merge_bvec_fn && !ti->type->merge)
+	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
 		blk_limits_max_hw_sectors(limits,
 					  (unsigned int) (PAGE_SIZE >> 9));
 	return 0;
Index: linux-2.6.39-fast/drivers/md/dm.h
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm.h	2011-06-23 01:21:54.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm.h	2011-06-23 01:23:59.000000000 +0200
@@ -66,6 +66,8 @@ int dm_table_alloc_md_mempools(struct dm
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
+int dm_queue_merge_is_compulsory(struct request_queue *q);
+
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, unsigned type);
