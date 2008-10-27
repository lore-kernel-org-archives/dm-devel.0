From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 8/9] dm snapshot: add shared_origin_target
Date: Mon, 27 Oct 2008 21:07:55 +0900
Message-ID: <1225109276-16491-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.c |  175 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 165 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c234d0d..1b9c1ef 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -575,8 +575,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cow_path = argv[1];
 	persistent = toupper(*argv[2]);
 
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
+	if (persistent != 'P' && persistent != 'N' && persistent != 'S') {
+		ti->error = "Persistent flag is not P, N, or S";
 		r = -EINVAL;
 		goto bad1;
 	}
@@ -624,7 +624,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	s->store.snap = s;
 
-	if (persistent == 'P')
+	if (persistent == 'S')
+		r = dm_create_shared(&s->store);
+	else if (persistent == 'P')
 		r = dm_create_persistent(&s->store);
 	else
 		r = dm_create_transient(&s->store);
@@ -1388,6 +1390,136 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 	return 0;
 }
 
+/*
+ * shared exception origin code
+ */
+
+struct dm_shared_origin {
+	struct dm_dev *origin;
+
+	struct dm_snapshot *origin_snap;
+};
+
+/*
+ * Construct a shared origin mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
+ */
+static int shared_origin_ctr(struct dm_target *ti, unsigned int argc,
+			     char **argv)
+{
+	int r;
+	struct dm_shared_origin *dso;
+	struct dm_snapshot *s;
+
+	if (argc != 4) {
+		ti->error = "origin: incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	dso = kzalloc(sizeof(*dso), GFP_KERNEL);
+	if (!dso)
+		return -ENOMEM;
+
+	r = snapshot_ctr(ti, argc, argv);
+	if (r)
+		goto out;
+
+	s = ti->private;
+
+	if (s->chunk_size != 16) {
+		r = -EINVAL;
+		ti->error = "invalid chunk size";
+		snapshot_dtr(ti);
+		goto out;
+	}
+
+	s->active = 1;
+
+	dso->origin = s->origin;
+	dso->origin_snap = s;
+	ti->private = dso;
+
+	return 0;
+out:
+	kfree(dso);
+	return r;
+}
+
+static void shared_origin_dtr(struct dm_target *ti)
+{
+	struct dm_shared_origin *dso = ti->private;
+
+	ti->private = dso->origin_snap;
+	snapshot_dtr(ti);
+	kfree(dso);
+}
+
+static int shared_origin_map(struct dm_target *ti, struct bio *bio,
+			     union map_info *map_context)
+{
+	struct dm_shared_origin *dso = ti->private;
+	struct dm_dev *dev = dso->origin;
+
+	bio->bi_bdev = dev->bdev;
+
+	/* Only tell snapshots if this is a write */
+	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
+}
+
+static int shared_origin_status(struct dm_target *ti, status_type_t type,
+				char *result, unsigned int maxlen)
+{
+	struct dm_shared_origin *dso = ti->private;
+	struct dm_snapshot *snap = dso->origin_snap;
+	struct exception_store *store = &snap->store;
+	unsigned long map[DIV_ROUND_UP(MAX_SNAPSHOTS, BITS_PER_LONG)];
+	int r, nr, i;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+
+		memset(map, 0, sizeof(map));
+
+		down_write(&store->snap->lock);
+		nr = store->get_snapshot_info(store, map, sizeof(map));
+		up_write(&store->snap->lock);
+
+		if (nr) {
+			r = snprintf(result, maxlen, "%d ", nr);
+			result += r;
+			maxlen -= min_t(int, r, maxlen);
+
+			for (i = 0; maxlen && i < MAX_SNAPSHOTS; i++) {
+				if (test_bit(i, map)) {
+					r = snprintf(result, maxlen, "%d ", i);
+					result += r;
+					maxlen -= min_t(int, r, maxlen);
+				}
+			}
+		} else
+			snprintf(result, maxlen, ": no snapshot");
+
+		break;
+
+	case STATUSTYPE_TABLE:
+		r = snprintf(result, maxlen, "%s", snap->origin->name);
+		if (r > 0 && r < maxlen)
+			snprintf(result + r, maxlen - r, "%s %s %llu",
+				 snap->origin->name, snap->cow->name,
+				 (unsigned long long)snap->chunk_size);
+		break;
+	}
+
+	return 0;
+}
+
+static int shared_origin_message(struct dm_target *ti, unsigned argc,
+				 char **argv)
+{
+	struct dm_shared_origin *dso = ti->private;
+	struct dm_snapshot *snap = dso->origin_snap;
+	return snap->store.message(&snap->store, argc, argv);
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
 	.version = {1, 6, 0},
@@ -1411,6 +1543,17 @@ static struct target_type snapshot_target = {
 	.status  = snapshot_status,
 };
 
+static struct target_type shared_origin_target = {
+	.name    = "s-snap-origin",
+	.version = {1, 0, 0},
+	.module  = THIS_MODULE,
+	.ctr     = shared_origin_ctr,
+	.dtr     = shared_origin_dtr,
+	.map     = shared_origin_map,
+	.status  = shared_origin_status,
+	.message = shared_origin_message,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1427,31 +1570,37 @@ static int __init dm_snapshot_init(void)
 		goto bad1;
 	}
 
+	r = dm_register_target(&shared_origin_target);
+	if (r) {
+		DMERR("shared origin target register failed %d", r);
+		goto bad2;
+	}
+
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
-		goto bad2;
+		goto bad3;
 	}
 
 	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
-		goto bad3;
+		goto bad4;
 	}
 
 	pending_cache = KMEM_CACHE(dm_snap_pending_exception, 0);
 	if (!pending_cache) {
 		DMERR("Couldn't create pending cache.");
 		r = -ENOMEM;
-		goto bad4;
+		goto bad5;
 	}
 
 	tracked_chunk_cache = KMEM_CACHE(dm_snap_tracked_chunk, 0);
 	if (!tracked_chunk_cache) {
 		DMERR("Couldn't create cache to track chunks in use.");
 		r = -ENOMEM;
-		goto bad5;
+		goto bad6;
 	}
 
 	ksnapd = create_singlethread_workqueue("ksnapd");
@@ -1465,12 +1614,14 @@ static int __init dm_snapshot_init(void)
 
       bad_pending_pool:
 	kmem_cache_destroy(tracked_chunk_cache);
-      bad5:
+      bad6:
 	kmem_cache_destroy(pending_cache);
-      bad4:
+      bad5:
 	kmem_cache_destroy(exception_cache);
-      bad3:
+      bad4:
 	exit_origin_hash();
+      bad3:
+	dm_unregister_target(&shared_origin_target);
       bad2:
 	dm_unregister_target(&origin_target);
       bad1:
@@ -1492,6 +1643,10 @@ static void __exit dm_snapshot_exit(void)
 	if (r)
 		DMERR("origin unregister failed %d", r);
 
+	r = dm_unregister_target(&shared_origin_target);
+	if (r)
+		DMERR("shared origin unregister failed %d", r);
+
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
 	kmem_cache_destroy(exception_cache);
-- 
1.5.5.GIT
