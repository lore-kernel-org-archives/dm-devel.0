From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/2] dm: prevent table type changes after
	initial table load
Date: Mon, 24 May 2010 19:46:34 -0400
Message-ID: <1274744795-9825-2-git-send-email-snitzer@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Before table_load() stages an inactive table atomically check if its
type conflicts with a previously established device type (md->type).

Introduce 'type_lock' in mapped_device structure and use it to protect
md->type access.  table_load() sets md->type without concern for:
- another table_load() racing to set conflicting md->type.
- do_resume() making a conflicting table live.

Allowed transitions:
UNKNOWN_MD_TYPE => BIO_BASED_MD_TYPE
UNKNOWN_MD_TYPE => REQUEST_BASED_MD_TYPE

Once a table load occurs the DM device's type is completely immutable.

This prevents a table reload from switching the inactive table directly
to a conflicting type (even if the table is explicitly cleared before
load).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   29 ++++++++++++++++++++
 drivers/md/dm.c       |   71 +++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm.h       |    6 ++++
 3 files changed, 99 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1176,12 +1176,39 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	/*
+	 * Protect md->type against concurrent table loads.
+	 * Locking strategy:
+	 * + Leverage fact that md's type cannot change after initial table load.
+	 *   - Only protect type in table_load() -- not in do_resume().
+	 *
+	 * + Protect type while working to stage an inactive table:
+	 *   - check if table's type conflicts with md->type
+	 *     (holding: md->type_lock)
+	 *   - stage inactive table (hc->new_map)
+	 *     (holding: md->type_lock + _hash_lock)
+	 */
+	dm_lock_md_type(md);
+
+	if (dm_unknown_md_type(md)) {
+		/* initial table load, set md's type based on table's type */
+		dm_set_md_type(md, t);
+	} else if (!dm_md_type_matches_table(md, t)) {
+		DMWARN("can't change device type after initial table load.");
+		dm_table_destroy(t);
+		dm_unlock_md_type(md);
+		r = -EINVAL;
+		goto out;
+	}
+
+	/* stage inactive table */
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
 		dm_table_destroy(t);
 		up_write(&_hash_lock);
+		dm_unlock_md_type(md);
 		r = -ENXIO;
 		goto out;
 	}
@@ -1191,6 +1218,8 @@ static int table_load(struct dm_ioctl *p
 	hc->new_map = t;
 	up_write(&_hash_lock);
 
+	dm_unlock_md_type(md);
+
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	__dev_status(md, param);
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -111,6 +111,15 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_QUEUE_IO_TO_THREAD 6
 
 /*
+ * Type for md->type field.
+ */
+enum mapped_device_type {
+	UNKNOWN_MD_TYPE,
+	BIO_BASED_MD_TYPE,
+	REQUEST_BASED_MD_TYPE,
+};
+
+/*
  * Work processed by per-device workqueue.
  */
 struct mapped_device {
@@ -123,6 +132,12 @@ struct mapped_device {
 	unsigned long flags;
 
 	struct request_queue *queue;
+	enum mapped_device_type type;
+	/*
+	 * Protect type from concurrent access.
+	 */
+	struct mutex type_lock;
+
 	struct gendisk *disk;
 	char name[16];
 
@@ -1874,8 +1889,10 @@ static struct mapped_device *alloc_dev(i
 	if (r < 0)
 		goto bad_minor;
 
+	md->type = UNKNOWN_MD_TYPE;
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->type_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -2128,6 +2145,53 @@ int dm_create(int minor, struct mapped_d
 	return 0;
 }
 
+/*
+ * Functions to manage md->type.
+ * All are required to hold md->type_lock.
+ */
+void dm_lock_md_type(struct mapped_device *md)
+{
+	mutex_lock(&md->type_lock);
+}
+
+void dm_unlock_md_type(struct mapped_device *md)
+{
+	mutex_unlock(&md->type_lock);
+}
+
+void dm_set_md_type(struct mapped_device *md, struct dm_table* t)
+{
+	if (dm_table_request_based(t))
+		md->type = REQUEST_BASED_MD_TYPE;
+	else
+		md->type = BIO_BASED_MD_TYPE;
+}
+
+bool dm_unknown_md_type(struct mapped_device *md)
+{
+	return md->type == UNKNOWN_MD_TYPE;
+}
+
+static bool dm_bio_based_md_type(struct mapped_device *md)
+{
+	return md->type == BIO_BASED_MD_TYPE;
+}
+
+static bool dm_request_based_md_type(struct mapped_device *md)
+{
+	return md->type == REQUEST_BASED_MD_TYPE;
+}
+
+bool dm_md_type_matches_table(struct mapped_device *md, struct dm_table* t)
+{
+	if (dm_request_based_md_type(md))
+		return dm_table_request_based(t);
+	else if (dm_bio_based_md_type(md))
+		return !dm_table_request_based(t);
+
+	return 0;
+}
+
 static struct mapped_device *dm_find_md(dev_t dev)
 {
 	struct mapped_device *md;
@@ -2403,13 +2467,6 @@ struct dm_table *dm_swap_table(struct ma
 		goto out;
 	}
 
-	/* cannot change the device type, once a table is bound */
-	if (md->map &&
-	    (dm_table_get_type(md->map) != dm_table_get_type(table))) {
-		DMWARN("can't change the device type after a table is bound");
-		goto out;
-	}
-
 	map = __bind(md, table, &limits);
 
 out:
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -66,6 +66,12 @@ int dm_table_alloc_md_mempools(struct dm
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
+void dm_lock_md_type(struct mapped_device *md);
+void dm_unlock_md_type(struct mapped_device *md);
+void dm_set_md_type(struct mapped_device *md, struct dm_table* t);
+bool dm_unknown_md_type(struct mapped_device *md);
+bool dm_md_type_matches_table(struct mapped_device *md, struct dm_table* t);
+
 /*
  * To check the return value from dm_table_find_target().
  */
