From: Alasdair G Kergon <agk@redhat.com>
Subject: dm: keep old table until after resume succeeded
Date: Wed, 11 Nov 2009 02:48:23 +0000
Message-ID: <20091111024823.GL17055@agk-dp.fab.redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<20091111012040.GP6208@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091111012040.GP6208@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Follow-up patch which moves the table destruction after the resume.
__unbind() becomes redundant when followed by __bind().

Alasdair


From: Alasdair G Kergon <agk@redhat.com>

When swapping a new table into place, retain the old table until 
its replacement is in place.

An old check for an empty table is removed because this is enforced
in populate_table().

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c         |   10 ++++++----
 drivers/md/dm.c               |   34 +++++++++++++++++-----------------
 include/linux/device-mapper.h |    4 +++-
 3 files changed, 26 insertions(+), 22 deletions(-)

Index: linux-2.6.32-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.32-rc6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.32-rc6/drivers/md/dm-ioctl.c
@@ -855,7 +855,7 @@ static int do_resume(struct dm_ioctl *pa
 	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
-	struct dm_table *new_map;
+	struct dm_table *new_map, *old_map = NULL;
 
 	down_write(&_hash_lock);
 
@@ -884,11 +884,11 @@ static int do_resume(struct dm_ioctl *pa
 		if (!dm_suspended(md))
 			dm_suspend(md, suspend_flags);
 
-		r = dm_swap_table(md, new_map);
-		if (r) {
+		old_map = dm_swap_table(md, new_map);
+		if (IS_ERR(old_map)) {
 			dm_table_destroy(new_map);
 			dm_put(md);
-			return r;
+			return PTR_ERR(old_map);
 		}
 
 		if (dm_table_get_mode(new_map) & FMODE_WRITE)
@@ -900,6 +900,8 @@ static int do_resume(struct dm_ioctl *pa
 	if (dm_suspended(md))
 		r = dm_resume(md);
 
+	if (old_map)
+		dm_table_destroy(old_map);
 
 	if (!r) {
 		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
Index: linux-2.6.32-rc6/drivers/md/dm.c
===================================================================
--- linux-2.6.32-rc6.orig/drivers/md/dm.c
+++ linux-2.6.32-rc6/drivers/md/dm.c
@@ -2026,9 +2026,13 @@ static void __set_size(struct mapped_dev
 	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
-static int __bind(struct mapped_device *md, struct dm_table *t,
-		  struct queue_limits *limits)
+/*
+ * Returns old map, which caller must destroy.
+ */
+static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
+			       struct queue_limits *limits)
 {
+	struct dm_table *old_map;
 	struct request_queue *q = md->queue;
 	sector_t size;
 	unsigned long flags;
@@ -2043,11 +2047,6 @@ static int __bind(struct mapped_device *
 
 	__set_size(md, size);
 
-	if (!size) {
-		dm_table_destroy(t);
-		return 0;
-	}
-
 	dm_table_event_callback(t, event_callback, md);
 
 	/*
@@ -2063,11 +2062,12 @@ static int __bind(struct mapped_device *
 	__bind_mempools(md, t);
 
 	write_lock_irqsave(&md->map_lock, flags);
+	old_map = md->map;
 	md->map = t;
 	dm_table_set_restrictions(t, q, limits);
 	write_unlock_irqrestore(&md->map_lock, flags);
 
-	return 0;
+	return old_map;
 }
 
 /*
@@ -2361,13 +2361,13 @@ static void dm_rq_barrier_work(struct wo
 }
 
 /*
- * Swap in a new table (destroying old one).
+ * Swap in a new table, returning the old one for the caller to destroy.
  */
-int dm_swap_table(struct mapped_device *md, struct dm_table *table)
+struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
-	struct dm_table *map;
+	struct dm_table *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
-	int r = -EINVAL;
+	int r;
 
 	mutex_lock(&md->suspend_lock);
 
@@ -2376,8 +2376,10 @@ int dm_swap_table(struct mapped_device *
 		goto out;
 
 	r = dm_calculate_queue_limits(table, &limits);
-	if (r)
+	if (r) {
+		map = ERR_PTR(r);
 		goto out;
+	}
 
 	/* cannot change the device type, once a table is bound */
 	if (md->map &&
@@ -2386,13 +2388,11 @@ int dm_swap_table(struct mapped_device *
 		goto out;
 	}
 
-	map = __unbind(md);
-	r = __bind(md, table, &limits);
-	dm_table_destroy(map);
+	map = __bind(md, table, &limits);
 
 out:
 	mutex_unlock(&md->suspend_lock);
-	return r;
+	return map;
 }
 
 /*
Index: linux-2.6.32-rc6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.32-rc6.orig/include/linux/device-mapper.h
+++ linux-2.6.32-rc6/include/linux/device-mapper.h
@@ -295,8 +295,10 @@ void dm_table_event(struct dm_table *t);
 
 /*
  * The device must be suspended before calling this method.
+ * Returns the previous table, which the caller must destroy.
  */
-int dm_swap_table(struct mapped_device *md, struct dm_table *t);
+struct dm_table *dm_swap_table(struct mapped_device *md,
+			       struct dm_table *t);
 
 /*
  * A wrapper around vmalloc.
