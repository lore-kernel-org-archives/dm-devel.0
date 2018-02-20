From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 15/20] libmultipath: API for foreign
	multipath handling
Date: Tue, 20 Feb 2018 14:26:53 +0100
Message-ID: <20180220132658.22295-16-mwilck@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180220132658.22295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Add an API for "foreign" multipaths. Foreign libraries are loaded
from ${multipath_dir}/libforeign-*.so, as we do for checkers.

Refer to "foreign.h" for details about the API itself. Like we do for
checkers, high-level multipath code isn't supposed to call the API directly,
but rather the wrapper functions declared in "foreign.h".

This API is used only for displaying information and for logging. An extension to
other functionality (such as monitoring or administration) might be feasible,
but is not planned.

Foreign libraries communicate with libmultipath through the API defined in
"foreign.h". The foreign library can implement multipath maps, pathgroups,
and paths as it likes, they just need to provide the simple interfaces
defined in "generic.h" to libmultipath. These interfaces are used in libmultipath's
"print" implementation to convey various bits of information to users. By
using the same interfaces for printing that libmultipath uses internally,
foreign library implementations can focus on the technical side without
worrying about output formatting compatibility.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile  |   2 +-
 libmultipath/foreign.c | 471 +++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/foreign.h | 322 +++++++++++++++++++++++++++++++++
 3 files changed, 794 insertions(+), 1 deletion(-)
 create mode 100644 libmultipath/foreign.c
 create mode 100644 libmultipath/foreign.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 0099d9d6cc39..806aaa24f84e 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -43,7 +43,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
-	io_err_stat.o dm-generic.o generic.o
+	io_err_stat.o dm-generic.o generic.o foreign.o
 
 all: $(LIBS)
 
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
new file mode 100644
index 000000000000..f429e2759df3
--- /dev/null
+++ b/libmultipath/foreign.c
@@ -0,0 +1,471 @@
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
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <limits.h>
+#include <glob.h>
+#include <dlfcn.h>
+#include <libudev.h>
+#include "vector.h"
+#include "debug.h"
+#include "util.h"
+#include "foreign.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "print.h"
+
+static vector foreigns;
+
+#define get_dlsym(foreign, sym, lbl)					\
+	do {								\
+		foreign->sym =	dlsym(foreign->handle, #sym);		\
+		if (foreign->sym == NULL) {				\
+			condlog(0, "%s: symbol \"%s\" not found in \"%s\"", \
+				__func__, #sym, foreign->name);		\
+			goto lbl;					\
+		}							\
+	} while(0)
+
+static void free_foreign(struct foreign **fgn)
+{
+	if (fgn == NULL || *fgn == NULL)
+		return;
+	if ((*fgn)->context != NULL)
+		(*fgn)->cleanup((*fgn)->context);
+	if ((*fgn)->handle != NULL)
+		dlclose((*fgn)->handle);
+	free(*fgn);
+}
+
+void cleanup_foreign(void)
+{
+	struct foreign *fgn;
+	int i;
+
+	vector_foreach_slot(foreigns, fgn, i)
+		free_foreign(&fgn);
+	vector_free(foreigns);
+	foreigns = NULL;
+}
+
+int init_foreign(const char *multipath_dir)
+{
+	char pathbuf[PATH_MAX];
+	static const char base[] = "libforeign-";
+	static const char suffix[] = ".so";
+	glob_t globbuf;
+	int ret = -EINVAL, r, i;
+
+	if (foreigns != NULL) {
+		condlog(0, "%s: already initialized", __func__);
+		return -EEXIST;
+	}
+	foreigns = vector_alloc();
+
+	if (snprintf(pathbuf, sizeof(pathbuf), "%s/%s*%s",
+		     multipath_dir, base, suffix) >= sizeof(pathbuf)) {
+		condlog(1, "%s: path length overflow", __func__);
+		goto err;
+	}
+
+	condlog(4, "%s: looking for %s\n", __func__, pathbuf);
+	memset(&globbuf, 0, sizeof(globbuf));
+	r = glob(pathbuf, 0, NULL, &globbuf);
+
+	if (r == GLOB_NOMATCH) {
+		condlog(3, "%s: no foreign multipath libraries found",
+			__func__);
+		globfree(&globbuf);
+		return 0;
+	} else if (r != 0) {
+		char *msg;
+
+		if (errno != 0) {
+			ret = -errno;
+			msg = strerror(errno);
+		} else {
+			ret = -1;
+			msg = (r == GLOB_ABORTED ? "read error" :
+			       "out of memory");
+		}
+		condlog(0, "%s: search for foreign libraries failed: %d (%s)",
+			__func__, r, msg);
+		globfree(&globbuf);
+		goto err;
+	}
+
+	for (i = 0; i < globbuf.gl_pathc; i++) {
+		char *msg, *fn;
+		struct foreign *fgn;
+		int len, namesz;
+
+		fn = strrchr(globbuf.gl_pathv[i], '/');
+		if (fn == NULL)
+			fn = globbuf.gl_pathv[i];
+		else
+			fn++;
+
+		len = strlen(fn);
+		if (len <= sizeof(base) + sizeof(suffix) - 2) {
+			condlog(0, "%s: internal error: filename too short: %s",
+				__func__, globbuf.gl_pathv[i]);
+			continue;
+		}
+
+		condlog(4, "%s: found %s", __func__, fn);
+
+		namesz = len + 3 - sizeof(base) - sizeof(suffix);
+		fgn = malloc(sizeof(*fgn) + namesz);
+		if (fgn == NULL)
+			continue;
+		memset(fgn, 0, sizeof(*fgn));
+
+		strlcpy((char*)fgn + sizeof(*fgn), fn + sizeof(base) - 1,
+			namesz);
+		fgn->name = (const char*)fgn + sizeof(*fgn);
+
+		fgn->handle = dlopen(globbuf.gl_pathv[i], RTLD_NOW|RTLD_LOCAL);
+		msg = dlerror();
+		if (fgn->handle == NULL) {
+			condlog(1, "%s: failed to open %s: %s", __func__,
+				fn, msg);
+			free_foreign(&fgn);
+			continue;
+		}
+
+		get_dlsym(fgn, init, dl_err);
+		get_dlsym(fgn, cleanup, dl_err);
+		get_dlsym(fgn, add, dl_err);
+		get_dlsym(fgn, change, dl_err);
+		get_dlsym(fgn, delete, dl_err);
+		get_dlsym(fgn, delete_all, dl_err);
+		get_dlsym(fgn, check, dl_err);
+		get_dlsym(fgn, lock, dl_err);
+		get_dlsym(fgn, unlock, dl_err);
+		get_dlsym(fgn, get_multipaths, dl_err);
+		get_dlsym(fgn, release_multipaths, dl_err);
+		get_dlsym(fgn, get_paths, dl_err);
+		get_dlsym(fgn, release_paths, dl_err);
+
+		fgn->context = fgn->init(LIBMP_FOREIGN_API, fgn->name);
+		if (fgn->context == NULL) {
+			condlog(0, "%s: init() failed for %s", __func__, fn);
+			free_foreign(&fgn);
+			continue;
+		}
+
+		if (vector_alloc_slot(foreigns) == NULL) {
+			free_foreign(&fgn);
+			continue;
+		}
+		vector_set_slot(foreigns, fgn);
+		condlog(3, "foreign library \"%s\" loaded successfully", fgn->name);
+
+		continue;
+
+	dl_err:
+		free_foreign(&fgn);
+	}
+	globfree(&globbuf);
+
+	return 0;
+err:
+	cleanup_foreign();
+	return ret;
+}
+
+int add_foreign(struct udev_device *udev)
+{
+	struct foreign *fgn;
+	dev_t dt;
+	int j;
+
+	if (udev == NULL) {
+		condlog(1, "%s called with NULL udev", __func__);
+		return FOREIGN_ERR;
+	}
+	dt = udev_device_get_devnum(udev);
+	vector_foreach_slot(foreigns, fgn, j) {
+		int r = fgn->add(fgn->context, udev);
+
+		if (r == FOREIGN_CLAIMED) {
+			condlog(3, "%s: foreign \"%s\" claims device %d:%d",
+				__func__, fgn->name, major(dt), minor(dt));
+			return r;
+		} else if (r == FOREIGN_OK) {
+			condlog(4, "%s: foreign \"%s\" owns device %d:%d",
+				__func__, fgn->name, major(dt), minor(dt));
+			return r;
+		} else if (r != FOREIGN_IGNORED) {
+			condlog(1, "%s: unexpected return value %d from \"%s\"",
+				__func__, r, fgn->name);
+		}
+	}
+	return FOREIGN_IGNORED;
+}
+
+int change_foreign(struct udev_device *udev)
+{
+	struct foreign *fgn;
+	int j;
+	dev_t dt;
+
+	if (udev == NULL) {
+		condlog(1, "%s called with NULL udev", __func__);
+		return FOREIGN_ERR;
+	}
+	dt = udev_device_get_devnum(udev);
+	vector_foreach_slot(foreigns, fgn, j) {
+		int r = fgn->change(fgn->context, udev);
+
+		if (r == FOREIGN_OK) {
+			condlog(4, "%s: foreign \"%s\" completed %d:%d",
+				__func__, fgn->name, major(dt), minor(dt));
+			return r;
+		} else if (r != FOREIGN_IGNORED) {
+			condlog(1, "%s: unexpected return value %d from \"%s\"",
+				__func__, r, fgn->name);
+		}
+	}
+	return FOREIGN_IGNORED;
+}
+
+int delete_foreign(struct udev_device *udev)
+{
+	struct foreign *fgn;
+	int j;
+	dev_t dt;
+
+	if (udev == NULL) {
+		condlog(1, "%s called with NULL udev", __func__);
+		return FOREIGN_ERR;
+	}
+	dt = udev_device_get_devnum(udev);
+	vector_foreach_slot(foreigns, fgn, j) {
+		int r = fgn->delete(fgn->context, udev);
+
+		if (r == FOREIGN_OK) {
+			condlog(3, "%s: foreign \"%s\" deleted device %d:%d",
+				__func__, fgn->name, major(dt), minor(dt));
+			return r;
+		} else if (r != FOREIGN_IGNORED) {
+			condlog(1, "%s: unexpected return value %d from \"%s\"",
+				__func__, r, fgn->name);
+		}
+	}
+	return FOREIGN_IGNORED;
+}
+
+int delete_all_foreign(void)
+{
+	struct foreign *fgn;
+	int j;
+
+	vector_foreach_slot(foreigns, fgn, j) {
+		int r;
+
+		r = fgn->delete_all(fgn->context);
+		if (r != FOREIGN_IGNORED && r != FOREIGN_OK) {
+			condlog(1, "%s: unexpected return value %d from \"%s\"",
+				__func__, r, fgn->name);
+		}
+	}
+	return FOREIGN_OK;
+}
+
+void check_foreign(void)
+{
+	struct foreign *fgn;
+	int j;
+
+	vector_foreach_slot(foreigns, fgn, j) {
+		fgn->check(fgn->context);
+	}
+}
+
+/* Call this after get_path_layout */
+void foreign_path_layout(void)
+{
+	struct foreign *fgn;
+	int i;
+
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+
+		fgn->lock(fgn->context);
+		vec = fgn->get_paths(fgn->context);
+		if (vec != NULL) {
+			_get_path_layout(vec, LAYOUT_RESET_NOT);
+		}
+		fgn->release_paths(fgn->context, vec);
+		fgn->unlock(fgn->context);
+	}
+}
+
+/* Call this after get_multipath_layout */
+void foreign_multipath_layout(void)
+{
+	struct foreign *fgn;
+	int i;
+
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+
+		fgn->lock(fgn->context);
+		pthread_cleanup_push(fgn->unlock, fgn->context);
+		vec = fgn->get_multipaths(fgn->context);
+		if (vec != NULL) {
+			_get_multipath_layout(vec, LAYOUT_RESET_NOT);
+		}
+		fgn->release_multipaths(fgn->context, vec);
+		pthread_cleanup_pop(1);
+	}
+}
+
+int snprint_foreign_topology(char *buf, int len, int verbosity)
+{
+	struct foreign *fgn;
+	int i;
+	char *c = buf;
+
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+		const struct gen_multipath *gm;
+		int j;
+
+		fgn->lock(fgn->context);
+		pthread_cleanup_push(fgn->unlock, fgn->context);
+
+		vec = fgn->get_multipaths(fgn->context);
+		if (vec != NULL) {
+			vector_foreach_slot(vec, gm, j) {
+
+				c += _snprint_multipath_topology(gm, c,
+								 buf + len - c,
+								 verbosity);
+				if (c >= buf + len - 1)
+					break;
+			}
+			if (c >= buf + len - 1)
+				break;
+		}
+		fgn->release_multipaths(fgn->context, vec);
+		pthread_cleanup_pop(1);
+	}
+
+	return c - buf;
+}
+
+void print_foreign_topology(int verbosity)
+{
+	int buflen = MAX_LINE_LEN * MAX_LINES;
+	char *buf = NULL, *tmp = NULL;
+
+	buf = malloc(buflen);
+	buf[0] = '\0';
+	while (buf != NULL) {
+		char *c = buf;
+
+		c += snprint_foreign_topology(buf, buflen,
+						   verbosity);
+		if (c < buf + buflen - 1)
+			break;
+
+		buflen *= 2;
+		tmp = buf;
+		buf = realloc(buf, buflen);
+	}
+
+	if (buf == NULL && tmp != NULL)
+		buf = tmp;
+
+	if (buf != NULL) {
+		printf("%s", buf);
+		free(buf);
+	}
+}
+
+int snprint_foreign_paths(char *buf, int len, const char *style, int pretty)
+{
+	struct foreign *fgn;
+	int i;
+	char *c = buf;
+
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+		const struct gen_path *gp;
+		int j;
+
+		fgn->lock(fgn->context);
+		pthread_cleanup_push(fgn->unlock, fgn->context);
+
+		vec = fgn->get_paths(fgn->context);
+		if (vec != NULL) {
+			vector_foreach_slot(vec, gp, j) {
+				c += _snprint_path(gp, c, buf + len - c,
+						   style, pretty);
+				if (c >= buf + len - 1)
+					break;
+			}
+			if (c >= buf + len - 1)
+				break;
+		}
+		fgn->release_paths(fgn->context, vec);
+		pthread_cleanup_pop(1);
+	}
+
+	return c - buf;
+}
+
+int snprint_foreign_multipaths(char *buf, int len,
+			       const char *style, int pretty)
+{
+	struct foreign *fgn;
+	int i;
+	char *c = buf;
+
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+		const struct gen_multipath *gm;
+		int j;
+
+		fgn->lock(fgn->context);
+		pthread_cleanup_push(fgn->unlock, fgn->context);
+
+		vec = fgn->get_multipaths(fgn->context);
+		if (vec != NULL) {
+			vector_foreach_slot(vec, gm, j) {
+				c += _snprint_multipath(gm, c, buf + len - c,
+							style, pretty);
+				if (c >= buf + len - 1)
+					break;
+			}
+			if (c >= buf + len - 1)
+				break;
+		}
+		fgn->release_multipaths(fgn->context, vec);
+		pthread_cleanup_pop(1);
+	}
+
+	return c - buf;
+}
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
new file mode 100644
index 000000000000..4e96ff812ebf
--- /dev/null
+++ b/libmultipath/foreign.h
@@ -0,0 +1,322 @@
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
+#ifndef _FOREIGN_H
+#define _FOREIGN_H
+#include <stdbool.h>
+#include <libudev.h>
+
+#define LIBMP_FOREIGN_API ((1 << 8) | 0)
+
+struct context;
+
+/* return codes of functions below returning "int" */
+enum foreign_retcode {
+	FOREIGN_OK,
+	FOREIGN_CLAIMED,
+	FOREIGN_IGNORED,
+	FOREIGN_UNCLAIMED,
+	FOREIGN_NODEV,
+	FOREIGN_ERR,
+	__LAST_FOREIGN_RETCODE,
+};
+
+/**
+ * Foreign multipath library API
+ * Foreign libraries must implement the following methods.
+ */
+struct foreign {
+	/**
+	 * method: init(api, name)
+	 * Initialize foreign library, and check API compatibility
+	 * return pointer to opaque internal data strucure if successful,
+	 * NULL otherwise.
+	 *
+	 * @param[in] api: API version
+	 * @param[in] name: name to use for references to self in log messages,
+	 *     doesn't need to be strdup'd
+	 * @returns context pointer to use in future method calls.
+	 */
+	struct context* (*init)(unsigned int api, const char *name);
+
+	/**
+	 * method: cleanup(context)
+	 * Free data structures used by foreign library, including
+	 * context itself.
+	 *
+	 * @param[in] context foreign library context. This shouldn't be
+	 * referenced any more after calling cleanup().
+	 */
+	void (*cleanup)(struct context *);
+
+	/**
+	 * method: add(context, udev)
+	 * This is called during path detection, and for udev ADD events.
+	 *
+	 * @param[in] context foreign library context
+	 * @param[in] udev udev device to add
+	 * @returns status code
+	 * @retval FOREIGN_CLAIMED: device newly claimed
+	 * @retval FOREIGN_OK: device already registered, no action taken
+	 * @retval FOREIGN_IGNORED: device is ignored, no action taken
+	 * @retval FOREIGN_ERR: an error occured (e.g. out-of-memory)
+	 */
+	int (*add)(struct context *, struct udev_device *);
+
+	/**
+	 * method: change
+	 * This is called on udev CHANGE events.
+	 *
+	 * @param[in] context foreign library context
+	 * @param[in] udev udev device that has generated the event
+	 * @returns status code
+	 * @retval FOREIGN_OK: event processed
+	 * @retval FOREIGN_IGNORED: the device is ignored
+	 * @retval FOREIGN_ERR: an error occured (e.g. out-of-memory)
+	 *
+	 * Note: theoretically it can happen that the status of a foreign device
+	 * (claimed vs. not claimed) changes in a change event.
+	 * Supporting this correctly would require big efforts. For now, we
+	 * don't support it. "multipathd reconfigure" starts foreign device
+	 * detection from scratch and should be able to handle this situation.
+	 */
+	int (*change)(struct context *, struct udev_device *);
+
+	/**
+	 * method: delete
+	 * This is called on udev DELETE events.
+	 *
+	 * @param[in] context foreign library context
+	 * @param[in] udev udev device that has generated the event and
+	 *	should be deleted
+	 * @returns status code
+	 * @retval FOREIGN_OK: processed correctly (device deleted)
+	 * @retval FOREIGN_IGNORED: device wasn't registered internally
+	 * @retval FOREIGN_ERR: error occured.
+	 */
+	int (*delete)(struct context *, struct udev_device *);
+
+	/**
+	 * method: delete_all
+	 * This is called if multipathd reconfigures itself.
+	 * Deletes all registered devices (maps and paths)
+	 *
+	 * @param[in] context foreign library context
+	 * @returns status code
+	 * @retval FOREIGN_OK: processed correctly
+	 * @retval FOREIGN_IGNORED: nothing to delete
+	 * @retval FOREIGN_ERR: error occured
+	 */
+	int (*delete_all)(struct context*);
+
+	/**
+	 * method: check
+	 * This is called from multipathd's checker loop.
+	 *
+	 * Check status of managed devices, update internal status, and print
+	 * log messages if appropriate.
+	 * @param[in] context foreign library context
+	 */
+	void (*check)(struct context *);
+
+	/**
+	 * lock internal data stuctures.
+	 * @param[in] ctx: foreign context
+	 */
+	void (*lock)(struct context *ctx);
+
+	/**
+	 * unlock internal data stuctures.
+	 * @param[in] ctx: foreign context (void* in order to use the function
+	 *	as argument to pthread_cleanup_push())
+	 */
+	void (*unlock)(void *ctx);
+
+	/**
+	 * method: get_multipaths(context)
+	 * Returned vector must be freed by calling release_multipaths().
+	 * Lock must be held until release_multipaths() is called.
+	 *
+	 * @param[in] context foreign library context
+	 * @returns a vector of "struct gen_multipath*" with the map devices
+	 * belonging to this library (see generic.h).
+	 */
+	const struct _vector* (*get_multipaths)(const struct context *);
+
+	/**
+	 * method: release_multipaths(context, mpvec)
+	 * release data structures obtained with get_multipaths (if any)
+	 *
+	 * @param[in] ctx the foreign context
+	 * @param[in] mpvec the vector allocated with get_multipaths()
+	 */
+	void (*release_multipaths)(const struct context *ctx,
+				   const struct _vector* mpvec);
+
+	/**
+	 * method: get_paths
+	 * Returned vector must be freed by calling release_paths().
+	 * Lock must be held until release_paths() is called.
+	 *
+	 * @param[in] context foreign library context
+	 * @returns a vector of "struct gen_path*" with the path devices
+	 * belonging to this library (see generic.h)
+	 */
+	const struct _vector* (*get_paths)(const struct context *);
+
+	/**
+	 * release data structures obtained with get_multipaths (if any)
+	 *
+	 * @param[in] ctx the foreign context
+	 * @param[in] ppvec the vector allocated with get_paths()
+	 */
+	void (*release_paths)(const struct context *ctx,
+			      const struct _vector* ppvec);
+
+	const char *name;
+	void *handle;
+	struct context *context;
+};
+
+/**
+ * init_foreign(dir)
+ * load and initialize foreign multipath libraries in dir (libforeign-*.so).
+ * @param dir: directory to search
+ * @returns: 0 on success, negative value on failure.
+ */
+int init_foreign(const char *multipath_dir);
+
+/**
+ * cleanup_foreign(dir)
+ * cleanup and free all data structures owned by foreign libraries
+ */
+void cleanup_foreign(void);
+
+/**
+ * add_foreign(udev)
+ * check if a device belongs to any foreign library.
+ * calls add() for all known foreign libs, in the order registered,
+ * until the first one returns FOREIGN_CLAIMED or FOREIGN_OK.
+ * @param udev: udev device to check
+ * @returns: status code
+ * @retval FOREIGN_CLAIMED: newly claimed by a foreign lib
+ * @retval FOREIGN_OK: already claimed by a foreign lib
+ * @retval FOREIGN_IGNORED: ignored by all foreign libs
+ * @retval FOREIGN_ERR: an error occured
+ */
+int add_foreign(struct udev_device *);
+
+/**
+ * change_foreign(udev)
+ * Notify foreign libraries of an udev CHANGE event
+ * @param udev: udev device to check
+ * @returns: status code (see change() method above).
+ */
+int change_foreign(struct udev_device *);
+
+/**
+ * delete_foreign(udev)
+ * @param udev: udev device being removed
+ * @returns: status code (see remove() above)
+ */
+int delete_foreign(struct udev_device *);
+
+/**
+ * delete_all_foreign()
+ * call delete_all() for all foreign libraries
+ * @returns: status code (see delete_all() above)
+ */
+int delete_all_foreign(void);
+
+/**
+ * check_foreign()
+ * call check() (see above) for all foreign libraries
+ */
+void check_foreign(void);
+
+/**
+ * foreign_path_layout()
+ * call this before printing paths, after get_path_layout(), to determine
+ * output field width.
+ */
+void foreign_path_layout(void);
+
+/**
+ * foreign_multipath_layout()
+ * call this before printing maps, after get_multipath_layout(), to determine
+ * output field width.
+ */
+void foreign_multipath_layout(void);
+
+/**
+ * snprint_foreign_topology(buf, len, verbosity);
+ * prints topology information from foreign libraries into buffer,
+ * '\0' - terminated.
+ * @param buf: output buffer
+ * @param len: size of output buffer
+ * @param verbosity: verbosity level
+ * @returns: number of printed characters excluding trailing '\0'.
+ */
+int snprint_foreign_topology(char *buf, int len, int verbosity);
+
+/**
+ * snprint_foreign_paths(buf, len, style, pad);
+ * prints formatted path information from foreign libraries into buffer,
+ * '\0' - terminated.
+ * @param buf: output buffer
+ * @param len: size of output buffer
+ * @param style: format string
+ * @param pad: whether to pad field width
+ * @returns: number of printed characters excluding trailing '\0'.
+ */
+int snprint_foreign_paths(char *buf, int len, const char *style, int pad);
+
+/**
+ * snprint_foreign_multipaths(buf, len, style, pad);
+ * prints formatted map information from foreign libraries into buffer,
+ * '\0' - terminated.
+ * @param buf: output buffer
+ * @param len: size of output buffer
+ * @param style: format string
+ * @param pad: whether to pad field width
+ * @returns: number of printed characters excluding trailing '\0'.
+ */
+int snprint_foreign_multipaths(char *buf, int len,
+			       const char *style, int pretty);
+
+/**
+ * print_foreign_topology(v)
+ * print foreign topology to stdout
+ * @param verbosity: verbosity level
+ */
+void print_foreign_topology(int verbosity);
+
+/**
+ * is_claimed_by_foreign(ud)
+ * @param udev: udev device
+ * @returns: true iff device is (newly or already) claimed by a foreign lib
+ */
+static inline bool
+is_claimed_by_foreign(struct udev_device *ud)
+{
+	int rc = add_foreign(ud);
+
+	return (rc == FOREIGN_CLAIMED || rc == FOREIGN_OK);
+}
+
+#endif /*  _FOREIGN_H */
-- 
2.16.1
