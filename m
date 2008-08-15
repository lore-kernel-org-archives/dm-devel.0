From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/10] dm snapshot: add shared_snapshot_target
Date: Fri, 15 Aug 2008 15:42:51 +0900
Message-ID: <1218782571-15290-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1218782571-15290-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1218782571-15290-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.c |  199 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 181 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ae8bb34..aceb143 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1145,11 +1145,9 @@ static void snapshot_resume(struct dm_target *ti)
 	up_write(&s->lock);
 }
 
-static int snapshot_status(struct dm_target *ti, status_type_t type,
-			   char *result, unsigned int maxlen)
+static int do_snapshot_status(struct dm_snapshot *snap, status_type_t type,
+			      char *result, unsigned int maxlen, u64 snapid)
 {
-	struct dm_snapshot *snap = ti->private;
-
 	switch (type) {
 	case STATUSTYPE_INFO:
 		if (!snap->valid)
@@ -1175,16 +1173,31 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		snprintf(result, maxlen, "%s %s %c %llu",
-			 snap->origin->name, snap->cow->name,
-			 snap->type,
-			 (unsigned long long)snap->chunk_size);
+		if (snap->type == 'S')
+			snprintf(result, maxlen, "%s %s %c %llu %llu",
+				 snap->origin->name, snap->cow->name,
+				 snap->type,
+				 (unsigned long long)snap->chunk_size,
+				 snapid);
+		else
+			snprintf(result, maxlen, "%s %s %c %llu",
+				 snap->origin->name, snap->cow->name,
+				 snap->type,
+				 (unsigned long long)snap->chunk_size);
 		break;
 	}
 
 	return 0;
 }
 
+static int snapshot_status(struct dm_target *ti, status_type_t type,
+			   char *result, unsigned int maxlen)
+{
+	struct dm_snapshot *snap = ti->private;
+
+	return do_snapshot_status(snap, type, result, maxlen, 0);
+}
+
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
@@ -1398,7 +1411,6 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 /*
  * shared exception origin code
  */
-
 struct dm_shared_origin {
 	struct dm_dev *origin;
 
@@ -1525,6 +1537,134 @@ static int shared_origin_message(struct dm_target *ti, unsigned argc,
 	return snap->store.message(&snap->store, argc, argv);
 }
 
+/*
+ * shared exception snapshot code
+ */
+
+struct dm_shared_snapshot {
+	struct dm_dev *origin;
+
+	struct dm_snapshot *snap;
+	u64 snapid;
+};
+
+/*
+ * Construct a shared origin mapping: <origin_dev> <snapshot id>
+ */
+static int shared_snapshot_ctr(struct dm_target *ti, unsigned int argc,
+			       char **argv)
+{
+	int r;
+	struct dm_shared_origin *dso;
+	struct dm_shared_snapshot *dss;
+	struct dm_snapshot *origin_snap;
+	struct dm_dev *dev;
+	struct origin *o;
+	u64 id;
+
+	if (argc != 2) {
+		ti->error = "snapshot: incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	dss = kzalloc(sizeof(*dss), GFP_KERNEL);
+	if (!dss)
+		return -ENOMEM;
+
+	id = simple_strtoul(argv[1], NULL, 10);
+	if (id >= 64) {
+		r = -EINVAL;
+		ti->error = "Invalid snapid";
+		goto out;
+	}
+
+	r = dm_get_device(ti, argv[0], 0, ti->len, FMODE_READ, &dev);
+	if (r) {
+		ti->error = "Cannot get origin device";
+		goto out;
+	}
+
+	r = -EINVAL;
+	down_read(&_origins_lock);
+	o = __lookup_origin(dev->bdev);
+	if (o && !list_empty(&o->snapshots)) {
+		int nr;
+		unsigned long map[DIV_ROUND_UP(MAX_SNAPSHOTS, BITS_PER_LONG)];
+		struct exception_store *store;
+
+		memset(map, 0, sizeof(map));
+
+		origin_snap = list_first_entry(&o->snapshots,
+					       struct dm_snapshot, list);
+		store = &origin_snap->store;
+		dso = origin_snap->ti->private;
+
+		down_write(&store->snap->lock);
+		nr = store->get_snapshot_info(store, map, sizeof(map));
+		up_write(&store->snap->lock);
+
+		if (test_bit(id, map)) {
+			dm_table_get(origin_snap->ti->table);
+			ti->private = dss;
+			dss->snap = origin_snap;
+			dss->snapid = id;
+			dss->origin = dev;
+
+			ti->split_io = origin_snap->chunk_size;
+			r = 0;
+
+			printk("%s %d: %lld\n", __FUNCTION__, __LINE__,
+			       (unsigned long long)id);
+
+		} else {
+			ti->error = "non-exist snapshot";
+			r = -EINVAL;
+		}
+	}
+	up_read(&_origins_lock);
+
+	if (r)
+		dm_put_device(ti, dev);
+out:
+	if (r)
+		kfree(dss);
+
+	return r;
+}
+
+static void shared_snapshot_dtr(struct dm_target *ti)
+{
+	struct dm_shared_snapshot *dss = ti->private;
+
+	dm_table_put(dss->snap->ti->table);
+	dm_put_device(ti, dss->origin);
+	kfree(dss);
+}
+
+static int shared_snapshot_map(struct dm_target *ti, struct bio *bio,
+			       union map_info *map_context)
+{
+	struct dm_shared_snapshot *dss = ti->private;
+
+	return do_snapshot_map(dss->snap, bio, map_context, dss->snapid);
+}
+
+static int shared_snapshot_end_io(struct dm_target *ti, struct bio *bio,
+				  int error, union map_info *map_context)
+{
+	struct dm_shared_snapshot *dss = ti->private;
+
+	return do_snapshot_end_io(dss->snap, bio, error, map_context);
+}
+
+static int shared_snapshot_status(struct dm_target *ti, status_type_t type,
+				  char *result, unsigned int maxlen)
+{
+	struct dm_shared_snapshot *dss = ti->private;
+
+	return do_snapshot_status(dss->snap, type, result, maxlen, dss->snapid);
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
 	.version = {1, 6, 0},
@@ -1559,6 +1699,17 @@ static struct target_type shared_origin_target = {
 	.message = shared_origin_message,
 };
 
+static struct target_type shared_snapshot_target = {
+	.name    = "s-snap",
+	.version = {1, 0, 0},
+	.module  = THIS_MODULE,
+	.ctr     = shared_snapshot_ctr,
+	.dtr     = shared_snapshot_dtr,
+	.map     = shared_snapshot_map,
+	.end_io  = shared_snapshot_end_io,
+	.status  = shared_snapshot_status,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1575,37 +1726,43 @@ static int __init dm_snapshot_init(void)
 		goto bad1;
 	}
 
+	r = dm_register_target(&shared_snapshot_target);
+	if (r) {
+		DMERR("shared snapshot target register failed %d", r);
+		goto bad2;
+	}
+
 	r = dm_register_target(&shared_origin_target);
 	if (r) {
 		DMERR("shared origin target register failed %d", r);
-		goto bad2;
+		goto bad3;
 	}
 
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
-		goto bad3;
+		goto bad4;
 	}
 
 	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
-		goto bad4;
+		goto bad5;
 	}
 
 	pending_cache = KMEM_CACHE(dm_snap_pending_exception, 0);
 	if (!pending_cache) {
 		DMERR("Couldn't create pending cache.");
 		r = -ENOMEM;
-		goto bad5;
+		goto bad6;
 	}
 
 	tracked_chunk_cache = KMEM_CACHE(dm_snap_tracked_chunk, 0);
 	if (!tracked_chunk_cache) {
 		DMERR("Couldn't create cache to track chunks in use.");
 		r = -ENOMEM;
-		goto bad6;
+		goto bad7;
 	}
 
 	ksnapd = create_singlethread_workqueue("ksnapd");
@@ -1619,14 +1776,16 @@ static int __init dm_snapshot_init(void)
 
       bad_pending_pool:
 	kmem_cache_destroy(tracked_chunk_cache);
-      bad6:
+      bad7:
 	kmem_cache_destroy(pending_cache);
-      bad5:
+      bad6:
 	kmem_cache_destroy(exception_cache);
-      bad4:
+      bad5:
 	exit_origin_hash();
-      bad3:
+      bad4:
 	dm_unregister_target(&shared_origin_target);
+      bad3:
+	dm_unregister_target(&shared_snapshot_target);
       bad2:
 	dm_unregister_target(&origin_target);
       bad1:
@@ -1648,6 +1807,10 @@ static void __exit dm_snapshot_exit(void)
 	if (r)
 		DMERR("origin unregister failed %d", r);
 
+	r = dm_unregister_target(&shared_snapshot_target);
+	if (r)
+		DMERR("shared snapshot unregister failed %d", r);
+
 	r = dm_unregister_target(&shared_origin_target);
 	if (r)
 		DMERR("shared origin unregister failed %d", r);
-- 
1.5.5.GIT
