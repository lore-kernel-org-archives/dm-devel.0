From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC Patch 3/3] multipath: add libmpathvalid library
Date: Mon, 30 Mar 2020 21:00:55 -0500
Message-ID: <1585620055-27112-4-git-send-email-bmarzins@redhat.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This library allows other programs to check if a path should be claimed
by multipath.  Currently, it only includes one function,
mpath_is_path(), which takes a device name, mode to for checking the
path, and an optional info structure, to return the wwid. The modes work
mostly like they do for "multipath -c/-u", with a few exceptions.

1. If a device is currently multipathed, it is always VALID. This
perhaps should be true for the existing path valid code.

2. There is no seperate "on" mode. It is instead treated like "smart".
This is because the library only looks at a single path, so it can only
say that a device could be multpathed, if there was another path.  It is
the caller's job to check if another path exists, or to wait for another
path appear.

3. The library does check if there already is an existing multipath
device with the same wwid, and if so, will declare the path valid.

In order to act more library-like, libmpathvalid doesn't set its own
device-mapper log functions. It leaves this to the caller. It currently
keeps condlog() from printing anything, but should eventually include a
function to allow the caller set the logging. It also uses a statically
compiled version of libmultipath, both to keep that library from
polluting the namespace of the caller, and to avoid the caller needing
to set up the variables and functions (like logsink, and
get_multipath_config) that it expects.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile                            |   1 +
 Makefile.inc                        |   1 +
 libmpathvalid/Makefile              |  38 +++++++
 libmpathvalid/libmpathvalid.version |   6 +
 libmpathvalid/mpath_valid.c         | 171 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         |  53 +++++++++
 libmultipath/Makefile               |   1 +
 libmultipath/devmapper.c            |  49 ++++++++
 libmultipath/devmapper.h            |   1 +
 9 files changed, 321 insertions(+)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

diff --git a/Makefile b/Makefile
index 1dee3680..462d6655 100644
--- a/Makefile
+++ b/Makefile
@@ -9,6 +9,7 @@ BUILDDIRS := \
 	libmultipath/checkers \
 	libmultipath/foreign \
 	libmpathpersist \
+	libmpathvalid \
 	multipath \
 	multipathd \
 	mpathpersist \
diff --git a/Makefile.inc b/Makefile.inc
index d4d1e0dd..7e0e8203 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -66,6 +66,7 @@ libdir		= $(prefix)/$(LIB)/multipath
 unitdir		= $(prefix)/$(SYSTEMDPATH)/systemd/system
 mpathpersistdir	= $(TOPDIR)/libmpathpersist
 mpathcmddir	= $(TOPDIR)/libmpathcmd
+mpathvaliddir	= $(TOPDIR)/libmpathvalid
 thirdpartydir	= $(TOPDIR)/third-party
 libdmmpdir	= $(TOPDIR)/libdmmp
 nvmedir		= $(TOPDIR)/libmultipath/nvme
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
new file mode 100644
index 00000000..5fc97022
--- /dev/null
+++ b/libmpathvalid/Makefile
@@ -0,0 +1,38 @@
+include ../Makefile.inc
+
+SONAME = 0
+DEVLIB = libmpathvalid.so
+LIBS = $(DEVLIB).$(SONAME)
+
+CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
+
+LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) \
+	   -lmultipath_nonshared -L$(mpathcmddir) -lmpathcmd -ludev
+
+OBJS = mpath_valid.o
+
+all: $(LIBS)
+
+$(LIBS): $(OBJS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
+	$(LN) $(LIBS) $(DEVLIB)
+
+install: $(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
+	$(INSTALL_PROGRAM) -m 644 mpath_valid.h $(DESTDIR)$(includedir)
+
+uninstall:
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
+
+clean: dep_clean
+	$(RM) core *.a *.o *.so *.so.* *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmpathvalid/libmpathvalid.version b/libmpathvalid/libmpathvalid.version
new file mode 100644
index 00000000..e8967951
--- /dev/null
+++ b/libmpathvalid/libmpathvalid.version
@@ -0,0 +1,6 @@
+MPATH_1.0 {
+	global:
+		mpath_is_path;
+	local:
+		*;
+};
diff --git a/libmpathvalid/mpath_valid.c b/libmpathvalid/mpath_valid.c
new file mode 100644
index 00000000..3d96c32f
--- /dev/null
+++ b/libmpathvalid/mpath_valid.c
@@ -0,0 +1,171 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <libdevmapper.h>
+#include <libudev.h>
+#include <errno.h>
+
+#include "devmapper.h"
+#include "structs.h"
+#include "util.h"
+#include "config.h"
+#include "discovery.h"
+#include "wwids.h"
+#include "sysfs.h"
+#include "mpath_cmd.h"
+#include "mpath_valid.h"
+
+struct udev *udev;
+int logsink = -1;
+static struct config default_config = { .verbosity = -1 };
+static struct config *multipath_conf;
+
+struct config *get_multipath_config(void)
+{
+	return (multipath_conf)? multipath_conf : &default_config;
+}
+
+void put_multipath_config(__attribute__((unused))void *conf)
+{
+	/* Noop */
+}
+
+static int get_conf_mode(struct config *conf)
+{
+	if (conf->find_multipaths == FIND_MULTIPATHS_ON ||
+	    conf->find_multipaths == FIND_MULTIPATHS_SMART)
+		return MPATH_SMART;
+	if (conf->find_multipaths == FIND_MULTIPATHS_GREEDY)
+		return MPATH_GREEDY;
+	return MPATH_STRICT;
+}
+
+
+/*
+ * Return
+ *  2: possible path (only in MPATH_GREEDY mode)
+ *  1: mpath path
+ *  0: not mpath path
+ * -1: Failure
+ */
+int
+mpath_is_path(const char *name, unsigned int mode, struct mpath_info *info)
+{
+	struct config *conf;
+	struct path * pp;
+	int r = MPATH_IS_ERROR;
+	int fd = -1;
+	unsigned int version[3];
+	bool already_multipathed = false;
+
+	if (info)
+		memset(info, 0, sizeof(struct mpath_info));
+
+	if (!name || mode >= MPATH_MAX_MODE)
+		return r;
+
+	skip_libmp_dm_init();
+	udev = udev_new();
+	if (!udev)
+		goto out;
+	conf = load_config(DEFAULT_CONFIGFILE);
+	if (!conf)
+		goto out_udev;
+	conf->verbosity = -1;
+	if (mode == MPATH_DEFAULT)
+		mode = get_conf_mode(conf);
+
+	if (dm_prereq(version))
+		goto out_config;
+	memcpy(conf->version, version, sizeof(version));
+	multipath_conf = conf;
+
+	pp = alloc_path();
+	if (!pp)
+		goto out_config;
+
+	if (safe_sprintf(pp->dev, "%s", name))
+		goto out_path;
+
+	if (sysfs_is_multipathed(pp, true)) {
+		if (!info || pp->wwid[0] != '\0') {
+			r = MPATH_IS_VALID;
+			goto out_path;
+		}
+		already_multipathed = true;
+	}
+
+	fd = __mpath_connect(1);
+	if (fd < 0) {
+		if (errno != EAGAIN && !systemd_service_enabled(name)) {
+			r = MPATH_IS_NOT_VALID;
+			goto out_path;
+		}
+	} else
+		mpath_disconnect(fd);
+
+	pp->udev = udev_device_new_from_subsystem_sysname(udev, "block", name);
+	if (!pp->udev)
+		goto out_path;
+
+	r = pathinfo(pp, conf, DI_SYSFS | DI_WWID | DI_BLACKLIST);
+	if (r) {
+		if (r == PATHINFO_SKIPPED)
+			r = MPATH_IS_NOT_VALID;
+		else
+			r = MPATH_IS_ERROR;
+		goto out_path;
+	}
+
+	if (pp->wwid[0] == '\0') {
+		r = MPATH_IS_NOT_VALID;
+		goto out_path;
+	}
+
+	if (already_multipathed)
+		goto out_path;
+
+	if (dm_is_mpath_uuid(pp->wwid) == 1) {
+		r = MPATH_IS_VALID;
+		goto out_path;
+	}
+
+	r = is_failed_wwid(pp->wwid);
+	if (r != WWID_IS_NOT_FAILED) {
+		if (r == WWID_IS_FAILED)
+			r = MPATH_IS_NOT_VALID;
+		else
+			r = MPATH_IS_ERROR;
+		goto out_path;
+	}
+
+	if (mode == MPATH_GREEDY) {
+		r = MPATH_IS_VALID;
+		goto out_path;
+	}
+
+	if (check_wwids_file(pp->wwid, 0) == 0) {
+		r = MPATH_IS_VALID;
+		goto out_path;
+	}
+
+	if (mode == MPATH_STRICT) {
+		r = MPATH_IS_NOT_VALID;
+		goto out_path;
+	}
+
+	/* mode == SMART */
+	r = MPATH_IS_MAYBE_VALID;
+
+out_path:
+	if (already_multipathed)
+		r = MPATH_IS_VALID;
+	if (info && (r == MPATH_IS_VALID || r == MPATH_IS_MAYBE_VALID))
+		strlcpy(info->wwid, pp->wwid, 128);
+	free_path(pp);
+out_config:
+	free_config(conf);
+out_udev:
+	udev_unref(udev);
+out:
+	return r;
+}
diff --git a/libmpathvalid/mpath_valid.h b/libmpathvalid/mpath_valid.h
new file mode 100644
index 00000000..b9e420a8
--- /dev/null
+++ b/libmpathvalid/mpath_valid.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2015 Red Hat, Inc.
+ *
+ * This file is part of the device-mapper multipath userspace tools.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef LIB_MPATH_VALID_H
+#define LIB_MPATH_VALID_H
+
+#ifdef __cpluscplus
+extern "C" {
+#endif
+
+enum mpath_valid_mode {
+	MPATH_DEFAULT,
+	MPATH_STRICT,
+	MPATH_SMART,
+	MPATH_GREEDY,
+	MPATH_MAX_MODE,  /* used only for bounds checking */
+};
+
+enum mpath_valid_result {
+	MPATH_IS_ERROR = -1,
+	MPATH_IS_NOT_VALID,
+	MPATH_IS_VALID,
+	MPATH_IS_MAYBE_VALID,
+};
+
+struct mpath_info {
+	char wwid[128];
+};
+
+int mpath_is_path(const char *name, unsigned int mode, struct mpath_info *info);
+
+
+#ifdef __cplusplus
+}
+#endif
+#endif /* LIB_PATH_VALID_H */
+
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ad690a49..7e2c00cf 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -69,6 +69,7 @@ nvme-ioctl.h: nvme/nvme-ioctl.h
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
+	ar rcs libmultipath_nonshared.a $(OBJS)
 	$(LN) $@ $(DEVLIB)
 
 install:
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 7ed494a1..27d4f61f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -770,6 +770,55 @@ out:
 	return r;
 }
 
+/*
+ * Return
+ *   1 : map with uuid exists
+ *   0 : map with uuid doesn't exist
+ *  -1 : error
+ */
+int
+dm_is_mpath_uuid(const char *uuid)
+{
+	struct dm_task *dmt;
+	struct dm_info info;
+	char prefixed_uuid[WWID_SIZE + UUID_PREFIX_LEN];
+	int r = -1;
+
+	if (!uuid || uuid[0] == '\0')
+		return 0;
+
+	if (safe_sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid))
+		goto out;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_set_uuid(dmt, prefixed_uuid))
+		goto out_task;
+
+	if (!dm_task_run(dmt))
+		goto out_task;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out_task;
+
+	r = 0;
+
+	if (!info.exists)
+		goto out_task;
+
+	r = 1;
+out_task:
+	dm_task_destroy(dmt);
+out:
+	if (r < 0)
+		condlog(3, "%s: dm command failed in %s: %s", uuid,
+			__FUNCTION__, strerror(errno));
+	return r;
+}
+
 static int
 dm_dev_t (const char * mapname, char * dev_t, int len)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 17fc9faf..fa2513c2 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -43,6 +43,7 @@ int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(const char *, char *);
 int dm_type(const char *, char *);
 int dm_is_mpath(const char *);
+int dm_is_mpath_uuid(const char *uuid);
 int _dm_flush_map (const char *, int, int, int, int);
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
-- 
2.17.2
