From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/5] libmultipath: nvme: fix path detection for
	kernel 4.16
Date: Fri, 14 Sep 2018 14:50:59 +0200
Message-ID: <20180914125103.1154-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The path detection logic of the NVMe code relies on the "slaves"
symlinks from NVMe subsys to controllers in sysfs, which have
been removed in the 4.16 kernel.

With this patch, we use the symlinks on the NVMe subsys level
instead.

Example: a multipathed NVMe subsystem with 2 controllers:

/sys/devices/virtual/nvme-subsystem/nvme-subsys2/nvme2n1
/sys/devices/virtual/nvme-fabrics/ctl/nvme2/nvme2c6n1
/sys/devices/virtual/nvme-fabrics/ctl/nvme3/nvme2c8n1

The controllers are found from the subsystem like this:

/sys/devices/virtual/nvme-subsystem/nvme-subsys2/nvme2 ->
    ../../nvme-fabrics/ctl/nvme2
/sys/devices/virtual/nvme-subsystem/nvme-subsys2/nvme3 ->
    ../../nvme-fabrics/ctl/nvme3

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 153 ++++++++++++++++++++++++++++++------
 1 file changed, 127 insertions(+), 26 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 280b6bd2..fca3235f 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -26,6 +26,7 @@
 #include <limits.h>
 #include <dirent.h>
 #include <errno.h>
+#include <ctype.h>
 #include "vector.h"
 #include "generic.h"
 #include "foreign.h"
@@ -442,17 +443,92 @@ _find_path_by_syspath(struct nvme_map *map, const char *syspath)
 	return NULL;
 }
 
-static int no_dotfiles(const struct dirent *di)
+static void _udev_device_unref(void *p)
 {
-	return di->d_name[0] != '.';
+	udev_device_unref(p);
 }
 
-static void _find_slaves(struct context *ctx, struct nvme_map *map)
+static void _udev_enumerate_unref(void *p)
 {
-	char pathbuf[PATH_MAX];
+	udev_enumerate_unref(p);
+}
+
+static int _dirent_controller(const struct dirent *di)
+{
+	static const char nvme_prefix[] = "nvme";
+	const char *p;
+
+#ifdef _DIRENT_HAVE_D_TYPE
+	if (di->d_type != DT_LNK)
+		return 0;
+#endif
+	if (strncmp(di->d_name, nvme_prefix, sizeof(nvme_prefix) - 1))
+		return 0;
+	p = di->d_name + sizeof(nvme_prefix) - 1;
+	if (*p == '\0' || !isdigit(*p))
+		return 0;
+	for (++p; *p != '\0'; ++p)
+		if (!isdigit(*p))
+			return 0;
+	return 1;
+}
+
+/* Find the block device for a given nvme controller */
+struct udev_device *get_ctrl_blkdev(const struct context *ctx,
+				    struct udev_device *ctrl)
+{
+	struct udev_list_entry *item;
+	struct udev_device *blkdev = NULL;
+	struct udev_enumerate *enm = udev_enumerate_new(ctx->udev);
+
+	if (enm == NULL)
+		return NULL;
+
+	pthread_cleanup_push(_udev_enumerate_unref, enm);
+	if (udev_enumerate_add_match_parent(enm, ctrl) < 0)
+		goto out;
+	if (udev_enumerate_add_match_subsystem(enm, "block"))
+		goto out;
+
+	if (udev_enumerate_scan_devices(enm) < 0) {
+		condlog(1, "%s: %s: error enumerating devices", __func__, THIS);
+		goto out;
+	}
+
+	for (item = udev_enumerate_get_list_entry(enm);
+	     item != NULL;
+	     item = udev_list_entry_get_next(item)) {
+		struct udev_device *tmp;
+
+		tmp = udev_device_new_from_syspath(ctx->udev,
+					   udev_list_entry_get_name(item));
+		if (tmp == NULL)
+			continue;
+		if (!strcmp(udev_device_get_devtype(tmp), "disk")) {
+			blkdev = tmp;
+			break;
+		} else
+			udev_device_unref(tmp);
+	}
+
+	if (blkdev == NULL)
+		condlog(1, "%s: %s: failed to get blockdev for %s",
+			__func__, THIS, udev_device_get_sysname(ctrl));
+	else
+		condlog(5, "%s: %s: got %s", __func__, THIS,
+			udev_device_get_sysname(blkdev));
+out:
+	pthread_cleanup_pop(1);
+	return blkdev;
+}
+
+static void _find_controllers(struct context *ctx, struct nvme_map *map)
+{
+	char pathbuf[PATH_MAX], realbuf[PATH_MAX];
 	struct dirent **di = NULL;
+	struct udev_device *subsys;
 	struct nvme_path *path;
-	int r, i;
+	int r, i, n;
 
 	if (map == NULL || map->udev == NULL)
 		return;
@@ -460,33 +536,65 @@ static void _find_slaves(struct context *ctx, struct nvme_map *map)
 	vector_foreach_slot(map->pathvec, path, i)
 		path->seen = false;
 
-	snprintf(pathbuf, sizeof(pathbuf),
-		"%s/slaves",
-		udev_device_get_syspath(map->udev));
+	subsys = udev_device_get_parent_with_subsystem_devtype(map->udev,
+							       "nvme-subsystem",
+							       NULL);
+	if (subsys == NULL) {
+		condlog(1, "%s: %s: BUG: no NVME subsys for %s", __func__, THIS,
+			udev_device_get_sysname(map->udev));
+		return;
+	}
 
-	r = scandir(pathbuf, &di, no_dotfiles, alphasort);
+	n = snprintf(pathbuf, sizeof(pathbuf), "%s",
+		     udev_device_get_syspath(subsys));
+	r = scandir(pathbuf, &di, _dirent_controller, alphasort);
 
 	if (r == 0) {
-		condlog(3, "%s: %s: no paths for %s", __func__, THIS,
+		condlog(3, "%s: %s: no controllers for %s", __func__, THIS,
 			udev_device_get_sysname(map->udev));
 		return;
 	} else if (r < 0) {
-		condlog(1, "%s: %s: error %d scanning paths of %s", __func__,
-			THIS, errno, udev_device_get_sysname(map->udev));
+		condlog(1, "%s: %s: error %d scanning controllers of %s",
+			__func__, THIS, errno,
+			udev_device_get_sysname(map->udev));
 		return;
 	}
 
 	pthread_cleanup_push(free, di);
 	for (i = 0; i < r; i++) {
 		char *fn = di[i]->d_name;
-		struct udev_device *udev;
+		struct udev_device *ctrl, *udev;
+
+		if (snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn)
+		    >= sizeof(pathbuf) - n)
+			continue;
+		if (realpath(pathbuf, realbuf) == NULL) {
+			condlog(3, "%s: %s: realpath: %s", __func__, THIS,
+				strerror(errno));
+			continue;
+		}
+		condlog(4, "%s: %s: found %s", __func__, THIS, realbuf);
 
-		if (snprintf(pathbuf, sizeof(pathbuf), "%s/slaves/%s",
-			     udev_device_get_syspath(map->udev), fn)
-		    >= sizeof(pathbuf))
+		ctrl = udev_device_new_from_syspath(ctx->udev, realbuf);
+		if (ctrl == NULL) {
+			condlog(1, "%s: %s: failed to get udev device for %s",
+				__func__, THIS, realbuf);
+			continue;
+		}
+
+		pthread_cleanup_push(_udev_device_unref, ctrl);
+		udev = get_ctrl_blkdev(ctx, ctrl);
+		/*
+		 * We give up the reference to the nvme device here and get
+		 * it back from the child below.
+		 * This way we don't need to worry about unreffing it.
+		 */
+		pthread_cleanup_pop(1);
+
+		if (udev == NULL)
 			continue;
 
-		path = _find_path_by_syspath(map, pathbuf);
+		path = _find_path_by_syspath(map, udev_device_get_syspath(udev));
 		if (path != NULL) {
 			path->seen = true;
 			condlog(4, "%s: %s already known",
@@ -494,13 +602,6 @@ static void _find_slaves(struct context *ctx, struct nvme_map *map)
 			continue;
 		}
 
-		udev = udev_device_new_from_syspath(ctx->udev, pathbuf);
-		if (udev == NULL) {
-			condlog(1, "%s: %s: failed to get udev device for %s",
-				__func__, THIS, fn);
-			continue;
-		}
-
 		path = calloc(1, sizeof(*path));
 		if (path == NULL)
 			continue;
@@ -591,7 +692,7 @@ static int _add_map(struct context *ctx, struct udev_device *ud,
 		return FOREIGN_ERR;
 	}
 	vector_set_slot(ctx->mpvec, map);
-	_find_slaves(ctx, map);
+	_find_controllers(ctx, map);
 
 	return FOREIGN_CLAIMED;
 }
@@ -688,7 +789,7 @@ void _check(struct context *ctx)
 	vector_foreach_slot(ctx->mpvec, gm, i) {
 		struct nvme_map *map = gen_mp_to_nvme(gm);
 
-		_find_slaves(ctx, map);
+		_find_controllers(ctx, map);
 	}
 }
 
-- 
2.18.0
