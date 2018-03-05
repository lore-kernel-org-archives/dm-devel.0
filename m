From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/23] libmultipath/foreign: nvme foreign
	library
Date: Tue,  6 Mar 2018 00:15:01 +0100
Message-ID: <20180305231507.10386-18-mwilck@suse.com>
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

This still contains stubs for path handling and checking, but it's functional
for printing already.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile                      |   1 +
 libmultipath/foreign/Makefile |  30 +++
 libmultipath/foreign/nvme.c   | 455 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 486 insertions(+)
 create mode 100644 libmultipath/foreign/Makefile
 create mode 100644 libmultipath/foreign/nvme.c

diff --git a/Makefile b/Makefile
index 11c46eb4dbc9..4b145c593605 100644
--- a/Makefile
+++ b/Makefile
@@ -7,6 +7,7 @@ BUILDDIRS = \
 	libmultipath \
 	libmultipath/prioritizers \
 	libmultipath/checkers \
+	libmultipath/foreign \
 	libmpathpersist \
 	multipath \
 	multipathd \
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
new file mode 100644
index 000000000000..dfba11e86d76
--- /dev/null
+++ b/libmultipath/foreign/Makefile
@@ -0,0 +1,30 @@
+#
+# Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
+#
+include ../../Makefile.inc
+
+CFLAGS += $(LIB_CFLAGS) -I..
+
+# If you add or remove a checker also update multipath/multipath.conf.5
+LIBS= \
+	libforeign-nvme.so
+
+all: $(LIBS)
+
+libforeign-%.so: %.o
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+
+install:
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
+
+uninstall:
+	for file in $(LIBS); do $(RM) $(DESTDIR)$(libdir)/$$file; done
+
+clean: dep_clean
+	$(RM) core *.a *.o *.gz *.so
+
+OBJS := $(LIBS:libforeign-%.so=%.o)
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
new file mode 100644
index 000000000000..32bd5c96c44a
--- /dev/null
+++ b/libmultipath/foreign/nvme.c
@@ -0,0 +1,455 @@
+/*
+  Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU General Public License
+  as published by the Free Software Foundation; either version 2
+  of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+  USA.
+*/
+
+#include <sys/sysmacros.h>
+#include <libudev.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <libudev.h>
+#include <pthread.h>
+#include "vector.h"
+#include "generic.h"
+#include "foreign.h"
+#include "debug.h"
+
+const char *THIS;
+
+struct nvme_map {
+	struct gen_multipath gen;
+	struct udev_device *udev;
+	struct udev_device *subsys;
+	dev_t devt;
+};
+
+#define NAME_LEN 64 /* buffer length temp model name */
+#define const_gen_mp_to_nvme(g) ((const struct nvme_map*)(g))
+#define gen_mp_to_nvme(g) ((struct nvme_map*)(g))
+#define nvme_mp_to_gen(n) &((n)->gen)
+
+static void cleanup_nvme_map(struct nvme_map *map)
+{
+	if (map->udev)
+		udev_device_unref(map->udev);
+	if (map->subsys)
+		udev_device_unref(map->subsys);
+	free(map);
+}
+
+static const struct _vector*
+nvme_mp_get_pgs(const struct gen_multipath *gmp) {
+	return NULL;
+}
+
+static void
+nvme_mp_rel_pgs(const struct gen_multipath *gmp, const struct _vector *v)
+{
+}
+
+static void rstrip(char *str)
+{
+	int n;
+
+	for (n = strlen(str) - 1; n >= 0 && str[n] == ' '; n--);
+	str[n+1] = '\0';
+}
+
+static int snprint_nvme_map(const struct gen_multipath *gmp,
+			    char *buff, int len, char wildcard)
+{
+	const struct nvme_map *nvm = const_gen_mp_to_nvme(gmp);
+	static const char nvme_vendor[] = "NVMe";
+	char fld[NAME_LEN];
+	const char *val;
+
+	switch (wildcard) {
+	case 'd':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysname(nvm->udev));
+	case 'n':
+		return snprintf(buff, len, "%s:NQN:%s",
+				udev_device_get_sysname(nvm->subsys),
+				udev_device_get_sysattr_value(nvm->subsys,
+							      "subsysnqn"));
+	case 'w':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysattr_value(nvm->udev,
+							      "wwid"));
+	case 'S':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysattr_value(nvm->udev,
+							      "size"));
+	case 'v':
+		return snprintf(buff, len, "%s", nvme_vendor);
+	case 's':
+	case 'p':
+		snprintf(fld, sizeof(fld), "%s",
+			 udev_device_get_sysattr_value(nvm->subsys,
+						      "model"));
+		rstrip(fld);
+		if (wildcard == 'p')
+			return snprintf(buff, len, "%s", fld);
+		return snprintf(buff, len, "%s,%s,%s", nvme_vendor, fld,
+				udev_device_get_sysattr_value(nvm->subsys,
+							      "firmware_rev"));
+	case 'e':
+		return snprintf(buff, len, "%s",
+				udev_device_get_sysattr_value(nvm->subsys,
+							      "firmware_rev"));
+	case 'r':
+		val = udev_device_get_sysattr_value(nvm->udev, "ro");
+		if (val[0] == 1)
+			return snprintf(buff, len, "%s", "ro");
+		else
+			return snprintf(buff, len, "%s", "rw");
+	case 'G':
+		return snprintf(buff, len, "%s", THIS);
+	default:
+		return snprintf(buff, len, "N/A");
+		break;
+	}
+	return 0;
+}
+
+static const struct _vector*
+nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
+	return NULL;
+}
+
+static void
+nvme_pg_rel_paths(const struct gen_pathgroup *gpg, const struct _vector *v)
+{
+}
+
+static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
+			   char *buff, int len, char wildcard)
+{
+	return 0;
+}
+
+static int snprint_nvme_path(const struct gen_path *gmp,
+			     char *buff, int len, char wildcard)
+{
+	switch (wildcard) {
+	case 'R':
+		return snprintf(buff, len, "[foreign: %s]", THIS);
+	default:
+		break;
+	}
+	return 0;
+}
+
+static const struct gen_multipath_ops nvme_map_ops = {
+	.get_pathgroups = nvme_mp_get_pgs,
+	.rel_pathgroups = nvme_mp_rel_pgs,
+	.style = generic_style,
+	.snprint = snprint_nvme_map,
+};
+
+static const struct gen_pathgroup_ops nvme_pg_ops __attribute__((unused)) = {
+	.get_paths = nvme_pg_get_paths,
+	.rel_paths = nvme_pg_rel_paths,
+	.snprint = snprint_nvme_pg,
+};
+
+static const struct gen_path_ops nvme_path_ops __attribute__((unused)) = {
+	.snprint = snprint_nvme_path,
+};
+
+struct context {
+	pthread_mutex_t mutex;
+	vector mpvec;
+};
+
+void lock(struct context *ctx)
+{
+	pthread_mutex_lock(&ctx->mutex);
+}
+
+void unlock(void *arg)
+{
+	struct context *ctx = arg;
+
+	pthread_mutex_unlock(&ctx->mutex);
+}
+
+static int _delete_all(struct context *ctx)
+{
+	struct nvme_map *nm;
+	int n = VECTOR_SIZE(ctx->mpvec), i;
+
+	if (n == 0)
+		return FOREIGN_IGNORED;
+
+	vector_foreach_slot_backwards(ctx->mpvec, nm, i) {
+		vector_del_slot(ctx->mpvec, i);
+		cleanup_nvme_map(nm);
+	}
+	return FOREIGN_OK;
+}
+
+int delete_all(struct context *ctx)
+{
+	int rc;
+
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+
+	lock(ctx);
+	pthread_cleanup_push(unlock, ctx);
+	rc = _delete_all(ctx);
+	pthread_cleanup_pop(1);
+
+	return rc;
+}
+
+void cleanup(struct context *ctx)
+{
+	(void)delete_all(ctx);
+
+	lock(ctx);
+	/*
+	 * Locking is not strictly necessary here, locking in foreign.c
+	 * makes sure that no other code is called with this ctx any more.
+	 * But this should make static checkers feel better.
+	 */
+	pthread_cleanup_push(unlock, ctx);
+	if (ctx->udev)
+		udev_unref(ctx->udev);
+	if (ctx->mpvec)
+		vector_free(ctx->mpvec);
+	ctx->mpvec = NULL;
+	ctx->udev = NULL;
+	pthread_cleanup_pop(1);
+	pthread_mutex_destroy(&ctx->mutex);
+
+	free(ctx);
+}
+
+struct context *init(unsigned int api, const char *name)
+{
+	struct context *ctx;
+
+	if (api > LIBMP_FOREIGN_API) {
+		condlog(0, "%s: api version mismatch: %08x > %08x\n",
+			__func__, api, LIBMP_FOREIGN_API);
+		return NULL;
+	}
+
+	if ((ctx = calloc(1, sizeof(*ctx)))== NULL)
+		return NULL;
+
+	pthread_mutex_init(&ctx->mutex, NULL);
+
+	ctx->mpvec = vector_alloc();
+	if (ctx->mpvec == NULL)
+		goto err;
+
+	THIS = name;
+	return ctx;
+err:
+	cleanup(ctx);
+	return NULL;
+}
+
+static struct nvme_map *_find_nvme_map_by_devt(const struct context *ctx,
+					      dev_t devt)
+{
+	struct nvme_map *nm;
+	int i;
+
+	if (ctx->mpvec == NULL)
+		return NULL;
+
+	vector_foreach_slot(ctx->mpvec, nm, i) {
+		if (nm->devt == devt)
+			return nm;
+	}
+
+	return NULL;
+}
+
+static int _add_map(struct context *ctx, struct udev_device *ud,
+		    struct udev_device *subsys)
+{
+	dev_t devt = udev_device_get_devnum(ud);
+	struct nvme_map *map;
+
+	if (_find_nvme_map_by_devt(ctx, devt) != NULL)
+		return FOREIGN_OK;
+
+	map = calloc(1, sizeof(*map));
+	if (map == NULL)
+		return FOREIGN_ERR;
+
+	map->devt = devt;
+	map->udev = udev_device_ref(ud);
+	/*
+	 * subsys is implicitly referenced by map->udev,
+	 * no need to take a reference here.
+	 */
+	map->subsys = subsys;
+	map->gen.ops = &nvme_map_ops;
+
+	if (vector_alloc_slot(ctx->mpvec) == NULL) {
+		cleanup_nvme_map(map);
+		return FOREIGN_ERR;
+	}
+
+	vector_set_slot(ctx->mpvec, map);
+
+	return FOREIGN_CLAIMED;
+}
+
+int add(struct context *ctx, struct udev_device *ud)
+{
+	struct udev_device *subsys;
+	int rc;
+
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+
+	if (ud == NULL)
+		return FOREIGN_ERR;
+	if (strcmp("disk", udev_device_get_devtype(ud)))
+		return FOREIGN_IGNORED;
+
+	subsys = udev_device_get_parent_with_subsystem_devtype(ud,
+							       "nvme-subsystem",
+							       NULL);
+	if (subsys == NULL)
+		return FOREIGN_IGNORED;
+
+	lock(ctx);
+	pthread_cleanup_push(unlock, ctx);
+	rc = _add_map(ctx, ud, subsys);
+	pthread_cleanup_pop(1);
+
+	if (rc == FOREIGN_CLAIMED)
+		condlog(3, "%s: %s: added map %s", __func__, THIS,
+			udev_device_get_sysname(ud));
+	else if (rc != FOREIGN_OK)
+		condlog(1, "%s: %s: retcode %d adding %s",
+			__func__, THIS, rc, udev_device_get_sysname(ud));
+
+	return rc;
+}
+
+int change(struct context *ctx, struct udev_device *ud)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	return FOREIGN_IGNORED;
+}
+
+static int _delete_map(struct context *ctx, struct udev_device *ud)
+{
+	int k;
+	struct nvme_map *map;
+	dev_t devt = udev_device_get_devnum(ud);
+
+	map = _find_nvme_map_by_devt(ctx, devt);
+	if (map ==NULL)
+		return FOREIGN_IGNORED;
+
+	k = find_slot(ctx->mpvec, map);
+	if (k == -1)
+		return FOREIGN_ERR;
+	else
+		vector_del_slot(ctx->mpvec, k);
+
+	cleanup_nvme_map(map);
+
+	return FOREIGN_OK;
+}
+
+int delete(struct context *ctx, struct udev_device *ud)
+{
+	int rc;
+
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+
+	if (ud == NULL)
+		return FOREIGN_ERR;
+
+	lock(ctx);
+	pthread_cleanup_push(unlock, ctx);
+	rc = _delete_map(ctx, ud);
+	pthread_cleanup_pop(1);
+
+	if (rc == FOREIGN_OK)
+		condlog(3, "%s: %s: map %s deleted", __func__, THIS,
+			udev_device_get_sysname(ud));
+	else if (rc != FOREIGN_IGNORED)
+		condlog(1, "%s: %s: retcode %d deleting map %s", __func__,
+			THIS, rc, udev_device_get_sysname(ud));
+
+	return rc;
+}
+
+void check(struct context *ctx)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	return;
+}
+
+/*
+ * It's safe to pass our internal pointer, this is only used under the lock.
+ */
+const struct _vector *get_multipaths(const struct context *ctx)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	return ctx->mpvec;
+}
+
+void release_multipaths(const struct context *ctx, const struct _vector *mpvec)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	/* NOP */
+}
+
+/*
+ * It's safe to pass our internal pointer, this is only used under the lock.
+ */
+const struct _vector * get_paths(const struct context *ctx)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	return NULL;
+}
+
+void release_paths(const struct context *ctx, const struct _vector *mpvec)
+{
+	condlog(5, "%s called for \"%s\"", __func__, THIS);
+	/* NOP */
+}
+
+/* compile-time check whether all methods are present and correctly typed */
+#define _METHOD_INIT(x) .x = x
+static struct foreign __methods __attribute__((unused)) = {
+	_METHOD_INIT(init),
+	_METHOD_INIT(cleanup),
+	_METHOD_INIT(change),
+	_METHOD_INIT(delete),
+	_METHOD_INIT(delete_all),
+	_METHOD_INIT(check),
+	_METHOD_INIT(lock),
+	_METHOD_INIT(unlock),
+	_METHOD_INIT(get_multipaths),
+	_METHOD_INIT(release_multipaths),
+	_METHOD_INIT(get_paths),
+	_METHOD_INIT(release_paths),
+};
-- 
2.16.1
