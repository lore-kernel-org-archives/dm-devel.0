From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 21/23] libmultipath: foreign/nvme: implement
	path display
Date: Tue,  6 Mar 2018 00:15:05 +0100
Message-ID: <20180305231507.10386-22-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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

implement display of path information for NVMe foreign paths and maps.
With this patch, I get output like this for Linux NVMe soft targets:

nvme-submultipathd show topology
sys0:NQN:subsysname (uuid.96926ba3-b207-437c-902c-4a4df6538c3f) [nvme] nvme0n1 NVMe,Linux,4.15.0-r
size=2097152 features='n/a' hwhandler='n/a' wp=rw
`-+- policy='n/a' prio=n/a status=n/a
  |- 0:1:1 nvme0c1n1 0:0 n/a n/a live
  |- 0:2:1 nvme0c2n1 0:0 n/a n/a live
  |- 0:3:1 nvme0c3n1 0:0 n/a n/a live
  `- 0:4:1 nvme0c4n1 0:0 n/a n/a live

multipathd show paths format '%G %d %i %o %z %m %N'
foreign dev       hcil  dev_st serial           multipath host WWNN
[nvme]  nvme0c1n1 0:1:1 live   1c2c86659503a02f nvme0n1   rdma:traddr=192.168.201.101,trsvcid=4420
[nvme]  nvme0c2n1 0:2:1 live   1c2c86659503a02f nvme0n1   rdma:traddr=192.168.202.101,trsvcid=4420
[nvme]  nvme0c3n1 0:3:1 live   1c2c86659503a02f nvme0n1   rdma:traddr=192.168.203.101,trsvcid=4420
[nvme]  nvme0c4n1 0:4:1 live   1c2c86659503a02f nvme0n1   rdma:traddr=192.168.204.101,trsvcid=4420

(admittedly, I abused the 'WWNN' wildcard here a bit to display information
which is helpful for NVMe over RDMA).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 334 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 320 insertions(+), 14 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 32bd5c96c44a..235f75dd2add 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -25,42 +25,98 @@
 #include <stdbool.h>
 #include <libudev.h>
 #include <pthread.h>
+#include <limits.h>
+#include <dirent.h>
+#include <errno.h>
 #include "vector.h"
 #include "generic.h"
 #include "foreign.h"
 #include "debug.h"
+#include "structs.h"
+#include "sysfs.h"
 
+static const char nvme_vendor[] = "NVMe";
+static const char N_A[] = "n/a";
 const char *THIS;
 
+struct nvme_map;
+struct nvme_path {
+	struct gen_path gen;
+	struct udev_device *udev;
+	struct udev_device *ctl;
+	struct nvme_map *map;
+	bool seen;
+};
+
+struct nvme_pathgroup {
+	struct gen_pathgroup gen;
+	vector pathvec;
+};
+
 struct nvme_map {
 	struct gen_multipath gen;
 	struct udev_device *udev;
 	struct udev_device *subsys;
 	dev_t devt;
+	/* Just one static pathgroup for NVMe for now */
+	struct nvme_pathgroup pg;
+	struct gen_pathgroup *gpg;
+	struct _vector pgvec;
+	vector pathvec;
+	int nr_live;
 };
 
-#define NAME_LEN 64 /* buffer length temp model name */
+#define NAME_LEN 64 /* buffer length for temp attributes */
 #define const_gen_mp_to_nvme(g) ((const struct nvme_map*)(g))
 #define gen_mp_to_nvme(g) ((struct nvme_map*)(g))
 #define nvme_mp_to_gen(n) &((n)->gen)
+#define const_gen_pg_to_nvme(g) ((const struct nvme_pathgroup*)(g))
+#define gen_pg_to_nvme(g) ((struct nvme_pathgroup*)(g))
+#define nvme_pg_to_gen(n) &((n)->gen)
+#define const_gen_path_to_nvme(g) ((const struct nvme_path*)(g))
+#define gen_path_to_nvme(g) ((struct nvme_path*)(g))
+#define nvme_path_to_gen(n) &((n)->gen)
+
+static void cleanup_nvme_path(struct nvme_path *path)
+{
+	condlog(5, "%s: %p %p", __func__, path, path->udev);
+	if (path->udev)
+		udev_device_unref(path->udev);
+	/* ctl is implicitly referenced by udev, no need to unref */
+	free(path);
+}
 
 static void cleanup_nvme_map(struct nvme_map *map)
 {
+	if (map->pathvec) {
+		struct nvme_path *path;
+		int i;
+
+		vector_foreach_slot_backwards(map->pathvec, path, i) {
+			condlog(5, "%s: %d %p", __func__, i, path);
+			cleanup_nvme_path(path);
+			vector_del_slot(map->pathvec, i);
+		}
+	}
+	vector_free(map->pathvec);
 	if (map->udev)
 		udev_device_unref(map->udev);
-	if (map->subsys)
-		udev_device_unref(map->subsys);
+	/* subsys is implicitly referenced by udev, no need to unref */
 	free(map);
 }
 
 static const struct _vector*
 nvme_mp_get_pgs(const struct gen_multipath *gmp) {
-	return NULL;
+	const struct nvme_map *nvme = const_gen_mp_to_nvme(gmp);
+
+	/* This is all used under the lock, no need to copy */
+	return &nvme->pgvec;
 }
 
 static void
 nvme_mp_rel_pgs(const struct gen_multipath *gmp, const struct _vector *v)
 {
+	/* empty */
 }
 
 static void rstrip(char *str)
@@ -75,7 +131,6 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 			    char *buff, int len, char wildcard)
 {
 	const struct nvme_map *nvm = const_gen_mp_to_nvme(gmp);
-	static const char nvme_vendor[] = "NVMe";
 	char fld[NAME_LEN];
 	const char *val;
 
@@ -92,6 +147,8 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 		return snprintf(buff, len, "%s",
 				udev_device_get_sysattr_value(nvm->udev,
 							      "wwid"));
+	case 'N':
+		return snprintf(buff, len, "%u", nvm->nr_live);
 	case 'S':
 		return snprintf(buff, len, "%s",
 				udev_device_get_sysattr_value(nvm->udev,
@@ -122,7 +179,7 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 	case 'G':
 		return snprintf(buff, len, "%s", THIS);
 	default:
-		return snprintf(buff, len, "N/A");
+		return snprintf(buff, len, N_A);
 		break;
 	}
 	return 0;
@@ -130,27 +187,101 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 
 static const struct _vector*
 nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
-	return NULL;
+	const struct nvme_pathgroup *gp = const_gen_pg_to_nvme(gpg);
+
+	/* This is all used under the lock, no need to copy */
+	return gp->pathvec;
 }
 
 static void
 nvme_pg_rel_paths(const struct gen_pathgroup *gpg, const struct _vector *v)
 {
+	/* empty */
 }
 
 static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
 			   char *buff, int len, char wildcard)
 {
-	return 0;
+	return snprintf(buff, len, N_A);
 }
 
-static int snprint_nvme_path(const struct gen_path *gmp,
+static int snprint_hcil(const struct nvme_path *np, char *buf, int len)
+{
+	unsigned int nvmeid, ctlid, nsid;
+	int rc;
+	const char *sysname = udev_device_get_sysname(np->udev);
+
+	rc = sscanf(sysname, "nvme%uc%un%u", &nvmeid, &ctlid, &nsid);
+	if (rc != 3) {
+		condlog(1, "%s: failed to scan %s", __func__, sysname);
+		rc = snprintf(buf, len, "(ERR:%s)", sysname);
+	} else
+		rc = snprintf(buf, len, "%u:%u:%u", nvmeid, ctlid, nsid);
+	return (rc < len ? rc : len);
+}
+
+static int snprint_nvme_path(const struct gen_path *gp,
 			     char *buff, int len, char wildcard)
 {
+	const struct nvme_path *np = const_gen_path_to_nvme(gp);
+	dev_t devt;
+	char fld[NAME_LEN];
+	struct udev_device *pci;
+
 	switch (wildcard) {
+	case 'w':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysattr_value(np->udev,
+							      "wwid"));
+	case 'd':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysname(np->udev));
+	case 'i':
+		return snprint_hcil(np, buff, len);
+	case 'D':
+		devt = udev_device_get_devnum(np->udev);
+		return snprintf(buff, len, "%u:%u", major(devt), minor(devt));
+	case 'o':
+		sysfs_attr_get_value(np->ctl, "state", fld, sizeof(fld));
+		return snprintf(buff, len, "%s", fld);
+	case 's':
+		snprintf(fld, sizeof(fld), "%s",
+			 udev_device_get_sysattr_value(np->ctl,
+						      "model"));
+		rstrip(fld);
+		return snprintf(buff, len, "%s,%s,%s", nvme_vendor, fld,
+				udev_device_get_sysattr_value(np->ctl,
+							      "firmware_rev"));
+	case 'S':
+		return snprintf(buff, len, "%s",
+			udev_device_get_sysattr_value(np->udev,
+						      "size"));
+	case 'z':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysattr_value(np->ctl,
+							      "serial"));
+	case 'm':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysname(np->map->udev));
+	case 'N':
 	case 'R':
-		return snprintf(buff, len, "[foreign: %s]", THIS);
+		return snprintf(buff, len, "%s:%s",
+			udev_device_get_sysattr_value(np->ctl,
+						      "transport"),
+			udev_device_get_sysattr_value(np->ctl,
+						      "address"));
+	case 'G':
+		return snprintf(buff, len, "[%s]", THIS);
+	case 'a':
+		pci = udev_device_get_parent_with_subsystem_devtype(np->ctl,
+								    "pci",
+								    NULL);
+		if (pci != NULL)
+			return snprintf(buff, len, "PCI:%s",
+					udev_device_get_sysname(pci));
+		/* fall through */
 	default:
+		return snprintf(buff, len, "%s", N_A);
 		break;
 	}
 	return 0;
@@ -176,6 +307,7 @@ static const struct gen_path_ops nvme_path_ops __attribute__((unused)) = {
 struct context {
 	pthread_mutex_t mutex;
 	vector mpvec;
+	struct udev *udev;
 };
 
 void lock(struct context *ctx)
@@ -257,6 +389,10 @@ struct context *init(unsigned int api, const char *name)
 
 	pthread_mutex_init(&ctx->mutex, NULL);
 
+	ctx->udev = udev_new();
+	if (ctx->udev == NULL)
+		goto err;
+
 	ctx->mpvec = vector_alloc();
 	if (ctx->mpvec == NULL)
 		goto err;
@@ -285,6 +421,138 @@ static struct nvme_map *_find_nvme_map_by_devt(const struct context *ctx,
 	return NULL;
 }
 
+static struct nvme_path *
+_find_path_by_syspath(struct nvme_map *map, const char *syspath)
+{
+	struct nvme_path *path;
+	char real[PATH_MAX];
+	const char *ppath;
+	int i;
+
+	ppath = realpath(syspath, real);
+	if (ppath == NULL) {
+		condlog(1, "%s: %s: error in realpath", __func__, THIS);
+		ppath = syspath;
+	}
+
+	vector_foreach_slot(map->pathvec, path, i) {
+		if (!strcmp(ppath,
+			    udev_device_get_syspath(path->udev)))
+			return path;
+	}
+	condlog(4, "%s: %s: %s not found", __func__, THIS, ppath);
+	return NULL;
+}
+
+static int no_dotfiles(const struct dirent *di)
+{
+	return di->d_name[0] != '.';
+}
+
+static void _find_slaves(struct context *ctx, struct nvme_map *map)
+{
+	char pathbuf[PATH_MAX];
+	struct dirent **di = NULL;
+	struct nvme_path *path;
+	int r, i;
+
+	if (map == NULL || map->udev == NULL)
+		return;
+
+	vector_foreach_slot(map->pathvec, path, i)
+		path->seen = false;
+
+	snprintf(pathbuf, sizeof(pathbuf),
+		"%s/slaves",
+		udev_device_get_syspath(map->udev));
+
+	r = scandir(pathbuf, &di, no_dotfiles, alphasort);
+
+	if (r == 0) {
+		condlog(3, "%s: %s: no paths for %s", __func__, THIS,
+			udev_device_get_sysname(map->udev));
+		return;
+	} else if (r < 0) {
+		condlog(1, "%s: %s: error %d scanning paths of %s", __func__,
+			THIS, errno, udev_device_get_sysname(map->udev));
+		return;
+	}
+
+	pthread_cleanup_push(free, di);
+	for (i = 0; i < r; i++) {
+		char *fn = di[i]->d_name;
+		struct udev_device *udev;
+
+		if (snprintf(pathbuf, sizeof(pathbuf), "%s/slaves/%s",
+			     udev_device_get_syspath(map->udev), fn)
+		    >= sizeof(pathbuf))
+			continue;
+
+		path = _find_path_by_syspath(map, pathbuf);
+		if (path != NULL) {
+			path->seen = true;
+			condlog(4, "%s: %s already known",
+				__func__, fn);
+			continue;
+		}
+
+		udev = udev_device_new_from_syspath(ctx->udev, pathbuf);
+		if (udev == NULL) {
+			condlog(1, "%s: %s: failed to get udev device for %s",
+				__func__, THIS, fn);
+			continue;
+		}
+
+		path = calloc(1, sizeof(*path));
+		if (path == NULL)
+			continue;
+
+		path->gen.ops = &nvme_path_ops;
+		path->udev = udev;
+		path->seen = true;
+		path->map = map;
+		path->ctl = udev_device_get_parent_with_subsystem_devtype
+			(udev, "nvme", NULL);
+		if (path->ctl == NULL) {
+			condlog(1, "%s: %s: failed to get controller for %s",
+				__func__, THIS, fn);
+			cleanup_nvme_path(path);
+			continue;
+		}
+
+		if (vector_alloc_slot(map->pathvec) == NULL) {
+			cleanup_nvme_path(path);
+			continue;
+		}
+		condlog(3, "%s: %s: new path %s added to %s",
+			__func__, THIS, udev_device_get_sysname(udev),
+			udev_device_get_sysname(map->udev));
+		vector_set_slot(map->pathvec, path);
+	}
+	pthread_cleanup_pop(1);
+
+	map->nr_live = 0;
+	vector_foreach_slot_backwards(map->pathvec, path, i) {
+		if (!path->seen) {
+			condlog(1, "path %d not found in %s any more",
+				i, udev_device_get_sysname(map->udev));
+			vector_del_slot(map->pathvec, i);
+			cleanup_nvme_path(path);
+		} else {
+			static const char live_state[] = "live";
+			char state[16];
+
+			if ((sysfs_attr_get_value(path->ctl, "state", state,
+						  sizeof(state)) > 0) &&
+			    !strncmp(state, live_state, sizeof(live_state) - 1))
+				map->nr_live++;
+		}
+	}
+	condlog(3, "%s: %s: map %s has %d/%d live paths", __func__, THIS,
+		udev_device_get_sysname(map->udev), map->nr_live,
+		VECTOR_SIZE(map->pathvec));
+}
+
 static int _add_map(struct context *ctx, struct udev_device *ud,
 		    struct udev_device *subsys)
 {
@@ -307,12 +575,25 @@ static int _add_map(struct context *ctx, struct udev_device *ud,
 	map->subsys = subsys;
 	map->gen.ops = &nvme_map_ops;
 
-	if (vector_alloc_slot(ctx->mpvec) == NULL) {
+	map->pathvec = vector_alloc();
+	if (map->pathvec == NULL) {
 		cleanup_nvme_map(map);
 		return FOREIGN_ERR;
 	}
 
+	map->pg.gen.ops = &nvme_pg_ops;
+	map->pg.pathvec = map->pathvec;
+	map->gpg = nvme_pg_to_gen(&map->pg);
+
+	map->pgvec.allocated = 1;
+	map->pgvec.slot = (void**)&map->gpg;
+
+	if (vector_alloc_slot(ctx->mpvec) == NULL) {
+		cleanup_nvme_map(map);
+		return FOREIGN_ERR;
+	}
 	vector_set_slot(ctx->mpvec, map);
+	_find_slaves(ctx, map);
 
 	return FOREIGN_CLAIMED;
 }
@@ -401,9 +682,25 @@ int delete(struct context *ctx, struct udev_device *ud)
 	return rc;
 }
 
+void _check(struct context *ctx)
+{
+	struct gen_multipath *gm;
+	int i;
+
+	vector_foreach_slot(ctx->mpvec, gm, i) {
+		struct nvme_map *map = gen_mp_to_nvme(gm);
+
+		_find_slaves(ctx, map);
+	}
+}
+
 void check(struct context *ctx)
 {
-	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	condlog(4, "%s called for \"%s\"", __func__, THIS);
+	lock(ctx);
+	pthread_cleanup_push(unlock, ctx);
+	_check(ctx);
+	pthread_cleanup_pop(1);
 	return;
 }
 
@@ -427,14 +724,23 @@ void release_multipaths(const struct context *ctx, const struct _vector *mpvec)
  */
 const struct _vector * get_paths(const struct context *ctx)
 {
+	vector paths = NULL;
+	const struct gen_multipath *gm;
+	int i;
+
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
-	return NULL;
+	vector_foreach_slot(ctx->mpvec, gm, i) {
+		const struct nvme_map *nm = const_gen_mp_to_nvme(gm);
+		paths = vector_convert(paths, nm->pathvec,
+				       struct gen_path, identity);
+	}
+	return paths;
 }
 
 void release_paths(const struct context *ctx, const struct _vector *mpvec)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
-	/* NOP */
+	vector_free_const(mpvec);
 }
 
 /* compile-time check whether all methods are present and correctly typed */
-- 
2.16.1
