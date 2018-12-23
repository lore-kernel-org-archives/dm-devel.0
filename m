From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/20] libmultipath/foreign/nvme: use failover
	topology
Date: Sun, 23 Dec 2018 23:21:23 +0100
Message-ID: <20181223222126.30882-18-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The native multipath driver does not use a multibus policy
as the current topology output of the NVMe foreign code
indicates. Rather, it uses failover policy, queueing all
IO to the current path until a failure occurs.

Change the data structures of the nvme foreign library
accordingly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 92 +++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index c753a747..11849889 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -40,17 +40,22 @@ static const char N_A[] = "n/a";
 const char *THIS;
 
 struct nvme_map;
+struct nvme_pathgroup {
+	struct gen_pathgroup gen;
+	struct _vector pathvec;
+};
+
 struct nvme_path {
 	struct gen_path gen;
 	struct udev_device *udev;
 	struct udev_device *ctl;
 	struct nvme_map *map;
 	bool seen;
-};
-
-struct nvme_pathgroup {
-	struct gen_pathgroup gen;
-	vector pathvec;
+	/*
+	 * The kernel works in failover mode.
+	 * Each path has a separate path group.
+	 */
+	struct nvme_pathgroup pg;
 };
 
 struct nvme_map {
@@ -58,11 +63,7 @@ struct nvme_map {
 	struct udev_device *udev;
 	struct udev_device *subsys;
 	dev_t devt;
-	/* Just one static pathgroup for NVMe for now */
-	struct nvme_pathgroup pg;
-	struct gen_pathgroup *gpg;
 	struct _vector pgvec;
-	vector pathvec;
 	int nr_live;
 };
 
@@ -76,29 +77,33 @@ struct nvme_map {
 #define const_gen_path_to_nvme(g) ((const struct nvme_path*)(g))
 #define gen_path_to_nvme(g) ((struct nvme_path*)(g))
 #define nvme_path_to_gen(n) &((n)->gen)
+#define nvme_pg_to_path(x) (VECTOR_SLOT(&((x)->pathvec), 0))
+#define nvme_path_to_pg(x) &((x)->pg)
 
 static void cleanup_nvme_path(struct nvme_path *path)
 {
 	condlog(5, "%s: %p %p", __func__, path, path->udev);
 	if (path->udev)
 		udev_device_unref(path->udev);
+	vector_reset(&path->pg.pathvec);
+
 	/* ctl is implicitly referenced by udev, no need to unref */
 	free(path);
 }
 
 static void cleanup_nvme_map(struct nvme_map *map)
 {
-	if (map->pathvec) {
-		struct nvme_path *path;
-		int i;
+	struct nvme_pathgroup *pg;
+	struct nvme_path *path;
+	int i;
 
-		vector_foreach_slot_backwards(map->pathvec, path, i) {
-			condlog(5, "%s: %d %p", __func__, i, path);
-			cleanup_nvme_path(path);
-			vector_del_slot(map->pathvec, i);
-		}
+	vector_foreach_slot_backwards(&map->pgvec, pg, i) {
+		path = nvme_pg_to_path(pg);
+		condlog(5, "%s: %d %p", __func__, i, path);
+		cleanup_nvme_path(path);
+		vector_del_slot(&map->pgvec, i);
 	}
-	vector_free(map->pathvec);
+	vector_reset(&map->pgvec);
 	if (map->udev)
 		udev_device_unref(map->udev);
 	/* subsys is implicitly referenced by udev, no need to unref */
@@ -190,7 +195,7 @@ nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
 	const struct nvme_pathgroup *gp = const_gen_pg_to_nvme(gpg);
 
 	/* This is all used under the lock, no need to copy */
-	return gp->pathvec;
+	return &gp->pathvec;
 }
 
 static void
@@ -432,7 +437,7 @@ static struct nvme_map *_find_nvme_map_by_devt(const struct context *ctx,
 static struct nvme_path *
 _find_path_by_syspath(struct nvme_map *map, const char *syspath)
 {
-	struct nvme_path *path;
+	struct nvme_pathgroup *pg;
 	char real[PATH_MAX];
 	const char *ppath;
 	int i;
@@ -443,7 +448,9 @@ _find_path_by_syspath(struct nvme_map *map, const char *syspath)
 		ppath = syspath;
 	}
 
-	vector_foreach_slot(map->pathvec, path, i) {
+	vector_foreach_slot(&map->pgvec, pg, i) {
+		struct nvme_path *path = nvme_pg_to_path(pg);
+
 		if (!strcmp(ppath,
 			    udev_device_get_syspath(path->udev)))
 			return path;
@@ -537,14 +544,17 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 	struct dirent **di = NULL;
 	struct scandir_result sr;
 	struct udev_device *subsys;
+	struct nvme_pathgroup *pg;
 	struct nvme_path *path;
 	int r, i, n;
 
 	if (map == NULL || map->udev == NULL)
 		return;
 
-	vector_foreach_slot(map->pathvec, path, i)
+	vector_foreach_slot(&map->pgvec, pg, i) {
+		path = nvme_pg_to_path(pg);
 		path->seen = false;
+	}
 
 	subsys = udev_device_get_parent_with_subsystem_devtype(map->udev,
 							       "nvme-subsystem",
@@ -606,7 +616,8 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		if (udev == NULL)
 			continue;
 
-		path = _find_path_by_syspath(map, udev_device_get_syspath(udev));
+		path = _find_path_by_syspath(map,
+					     udev_device_get_syspath(udev));
 		if (path != NULL) {
 			path->seen = true;
 			condlog(4, "%s: %s already known",
@@ -630,24 +641,30 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 			cleanup_nvme_path(path);
 			continue;
 		}
-
-		if (vector_alloc_slot(map->pathvec) == NULL) {
+		path->pg.gen.ops = &nvme_pg_ops;
+		if (vector_alloc_slot(&path->pg.pathvec) == NULL) {
 			cleanup_nvme_path(path);
 			continue;
 		}
+		vector_set_slot(&path->pg.pathvec, path);
+		if (vector_alloc_slot(&map->pgvec) == NULL) {
+			cleanup_nvme_path(path);
+			continue;
+		}
+		vector_set_slot(&map->pgvec, &path->pg);
 		condlog(3, "%s: %s: new path %s added to %s",
 			__func__, THIS, udev_device_get_sysname(udev),
 			udev_device_get_sysname(map->udev));
-		vector_set_slot(map->pathvec, path);
 	}
 	pthread_cleanup_pop(1);
 
 	map->nr_live = 0;
-	vector_foreach_slot_backwards(map->pathvec, path, i) {
+	vector_foreach_slot_backwards(&map->pgvec, pg, i) {
+		path = nvme_pg_to_path(pg);
 		if (!path->seen) {
 			condlog(1, "path %d not found in %s any more",
 				i, udev_device_get_sysname(map->udev));
-			vector_del_slot(map->pathvec, i);
+			vector_del_slot(&map->pgvec, i);
 			cleanup_nvme_path(path);
 		} else {
 			static const char live_state[] = "live";
@@ -661,7 +678,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 	}
 	condlog(3, "%s: %s: map %s has %d/%d live paths", __func__, THIS,
 		udev_device_get_sysname(map->udev), map->nr_live,
-		VECTOR_SIZE(map->pathvec));
+		VECTOR_SIZE(&map->pgvec));
 }
 
 static int _add_map(struct context *ctx, struct udev_device *ud,
@@ -686,19 +703,6 @@ static int _add_map(struct context *ctx, struct udev_device *ud,
 	map->subsys = subsys;
 	map->gen.ops = &nvme_map_ops;
 
-	map->pathvec = vector_alloc();
-	if (map->pathvec == NULL) {
-		cleanup_nvme_map(map);
-		return FOREIGN_ERR;
-	}
-
-	map->pg.gen.ops = &nvme_pg_ops;
-	map->pg.pathvec = map->pathvec;
-	map->gpg = nvme_pg_to_gen(&map->pg);
-
-	map->pgvec.allocated = 1;
-	map->pgvec.slot = (void**)&map->gpg;
-
 	if (vector_alloc_slot(ctx->mpvec) == NULL) {
 		cleanup_nvme_map(map);
 		return FOREIGN_ERR;
@@ -842,8 +846,8 @@ const struct _vector * get_paths(const struct context *ctx)
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	vector_foreach_slot(ctx->mpvec, gm, i) {
 		const struct nvme_map *nm = const_gen_mp_to_nvme(gm);
-		paths = vector_convert(paths, nm->pathvec,
-				       struct gen_path, identity);
+		paths = vector_convert(paths, &nm->pgvec,
+				       struct nvme_pathgroup, nvme_pg_to_path);
 	}
 	return paths;
 }
-- 
2.19.2
