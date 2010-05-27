From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 1/2] dm: prevent table type changes after
	initial table load
Date: Thu, 27 May 2010 08:47:48 -0400
Message-ID: <1274964469-22289-2-git-send-email-snitzer@redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
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
DM_TYPE_NONE => DM_TYPE_BIO_BASED
DM_TYPE_NONE => DM_TYPE_REQUEST_BASED

Once a table load occurs the DM device's type is completely immutable.

This prevents a table reload from switching the inactive table directly
to a conflicting type (even if the table is explicitly cleared before
load).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 drivers/md/dm-ioctl.c |   15 +++++++++++++++
 drivers/md/dm.c       |   37 ++++++++++++++++++++++++++++++-------
 drivers/md/dm.h       |    5 +++++
 3 files changed, 50 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1176,6 +1176,21 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	/* Protect md->type against concurrent table loads. */
+	dm_lock_md_type(md);
+	if (dm_get_md_type(md) == DM_TYPE_NONE) {
+		/* initial table load, set md's type based on table's type */
+		dm_set_md_type(md, dm_table_get_type(t));
+	} else if (dm_get_md_type(md) != dm_table_get_type(t)) {
+		DMWARN("can't change device type after initial table load.");
+		dm_table_destroy(t);
+		dm_unlock_md_type(md);
+		r = -EINVAL;
+		goto out;
+	}
+	dm_unlock_md_type(md);
+
+	/* stage inactive table */
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -123,6 +123,10 @@ struct mapped_device {
 	unsigned long flags;
 
 	struct request_queue *queue;
+	unsigned type;
+	/* Protect type against concurrent access. */
+	struct mutex type_lock;
+
 	struct gendisk *disk;
 	char name[16];
 
@@ -1874,8 +1878,10 @@ static struct mapped_device *alloc_dev(i
 	if (r < 0)
 		goto bad_minor;
 
+	md->type = DM_TYPE_NONE;
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->type_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -2128,6 +2134,30 @@ int dm_create(int minor, struct mapped_d
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
+void dm_set_md_type(struct mapped_device *md, unsigned type)
+{
+	md->type = type;
+}
+
+unsigned dm_get_md_type(struct mapped_device *md)
+{
+	return md->type;
+}
+
 static struct mapped_device *dm_find_md(dev_t dev)
 {
 	struct mapped_device *md;
@@ -2403,13 +2433,6 @@ struct dm_table *dm_swap_table(struct ma
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
@@ -66,6 +66,11 @@ int dm_table_alloc_md_mempools(struct dm
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
+void dm_lock_md_type(struct mapped_device *md);
+void dm_unlock_md_type(struct mapped_device *md);
+void dm_set_md_type(struct mapped_device *md, unsigned type);
+unsigned dm_get_md_type(struct mapped_device *md);
+
 /*
  * To check the return value from dm_table_find_target().
  */
