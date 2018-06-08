From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/28] tests/test-lib: cmocka helpers to simulate
	path and map discovery
Date: Fri,  8 Jun 2018 12:20:22 +0200
Message-ID: <20180608102041.22904-10-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These functions simulate path discovery and multipath setup with cmocka. They will be
used in the hwtable test case, but may be useful for other future test cases,
too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-lib.c | 359 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/test-lib.h |  67 +++++++++
 2 files changed, 426 insertions(+)
 create mode 100644 tests/test-lib.c
 create mode 100644 tests/test-lib.h

diff --git a/tests/test-lib.c b/tests/test-lib.c
new file mode 100644
index 00000000..cff7a5d1
--- /dev/null
+++ b/tests/test-lib.c
@@ -0,0 +1,359 @@
+#include <string.h>
+#include <setjmp.h>
+#include <stdarg.h>
+#include <cmocka.h>
+#include <libudev.h>
+#include <sys/sysmacros.h>
+#include "debug.h"
+#include "util.h"
+#include "vector.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "config.h"
+#include "discovery.h"
+#include "propsel.h"
+#include "test-lib.h"
+
+const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO);
+const char default_devnode[] = "sdTEST";
+const char default_wwid[] = "TEST-WWID";
+/* default_wwid should be a substring of default_wwid_1! */
+const char default_wwid_1[] = "TEST-WWID-1";
+
+/*
+ * Helper wrappers for mock_path().
+ *
+ * We need to make pathinfo() think it has detected a device with
+ * certain vendor/product/rev. This requires faking lots of udev
+ * and sysfs function responses.
+ *
+ * This requires hwtable-test_OBJDEPS = ../libmultipath/discovery.o
+ * in the Makefile in order to wrap calls from discovery.o.
+ *
+ * Note that functions that are called and defined in discovery.o can't
+ * be wrapped this way (e.g. sysfs_get_vendor), because symbols are
+ * resolved by the assembler before the linking stage.
+ */
+
+int __real_open(const char *path, int flags, int mode);
+
+static const char _mocked_filename[] = "mocked_path";
+int __wrap_open(const char *path, int flags, int mode)
+{
+	condlog(4, "%s: %s", __func__, path);
+
+	if (!strcmp(path, _mocked_filename))
+		return 111;
+	return __real_open(path, flags, mode);
+}
+
+int __wrap_execute_program(char *path, char *value, int len)
+{
+	char *val = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	strlcpy(value, val, len);
+	return 0;
+}
+
+bool __wrap_is_claimed_by_foreign(struct udev_device *ud)
+{
+	condlog(5, "%s: %p", __func__, ud);
+	return false;
+}
+
+struct udev_list_entry
+*__wrap_udev_device_get_properties_list_entry(struct udev_device *ud)
+{
+	void *p = (void*)0x12345678;
+	condlog(5, "%s: %p", __func__, p);
+
+	return p;
+}
+
+struct udev_list_entry
+*__wrap_udev_list_entry_get_next(struct udev_list_entry *udle)
+{
+	void *p  = NULL;
+	condlog(5, "%s: %p", __func__, p);
+
+	return p;
+}
+
+const char *__wrap_udev_list_entry_get_name(struct udev_list_entry *udle)
+{
+	char *val = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	return val;
+}
+
+struct udev_device *__wrap_udev_device_ref(struct udev_device *ud)
+{
+	return ud;
+}
+
+struct udev_device *__wrap_udev_device_unref(struct udev_device *ud)
+{
+	return ud;
+}
+
+char *__wrap_udev_device_get_subsystem(struct udev_device *ud)
+{
+	char *val = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	return val;
+}
+
+char *__wrap_udev_device_get_sysname(struct udev_device *ud)
+{
+	char *val  = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	return val;
+}
+
+char *__wrap_udev_device_get_devnode(struct udev_device *ud)
+{
+	char *val  = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	return val;
+}
+
+dev_t __wrap_udev_device_get_devnum(struct udev_device *ud)
+{
+	condlog(5, "%s: %p", __func__, ud);
+	return makedev(17, 17);
+}
+
+char *__wrap_udev_device_get_sysattr_value(struct udev_device *ud,
+					     const char *attr)
+{
+	char *val  = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s->%s", __func__, attr, val);
+	return val;
+}
+
+char *__wrap_udev_device_get_property_value(struct udev_device *ud,
+					    const char *attr)
+{
+	char *val  = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s->%s", __func__, attr, val);
+	return val;
+}
+
+int __wrap_sysfs_get_size(struct path *pp, unsigned long long *sz)
+{
+	*sz = 12345678UL;
+	return 0;
+}
+
+void *__wrap_udev_device_get_parent_with_subsystem_devtype(
+	struct udev_device *ud, const char *subsys, char *type)
+{
+	/* return non-NULL for sysfs_get_tgt_nodename */
+	return type;
+}
+
+void *__wrap_udev_device_get_parent(struct udev_device *ud)
+{
+	char *val  = mock_ptr_type(void *);
+
+	condlog(5, "%s: %p", __func__, val);
+	return val;
+}
+
+ssize_t __wrap_sysfs_attr_get_value(struct udev_device *dev,
+				    const char *attr_name,
+				    char *value, size_t sz)
+{
+	char *val  = mock_ptr_type(char *);
+
+	condlog(5, "%s: %s", __func__, val);
+	strlcpy(value, val, sz);
+	return strlen(value);
+}
+
+int __wrap_checker_check(struct checker *c, int st)
+{
+	condlog(5, "%s: %d", __func__, st);
+	return st;
+}
+
+int __wrap_prio_getprio(struct prio *p, struct path *pp, unsigned int tmo)
+{
+	int pr = 5;
+
+	condlog(5, "%s: %d", __func__, pr);
+	return pr;
+}
+
+struct mocked_path *fill_mocked_path(struct mocked_path *mp,
+				     const char *vendor, const char *product,
+				     const char *rev, const char *wwid,
+				     const char *devnode, unsigned int flags)
+{
+	mp->vendor = (vendor ? vendor : "noname");
+	mp->product = (product ? product : "noprod");
+	mp->rev = (rev ? rev : "0");
+	mp->wwid = (wwid ? wwid : default_wwid);
+	mp->devnode = (devnode ? devnode : default_devnode);
+	mp->flags = flags|NEED_SELECT_PRIO|NEED_FD;
+	return mp;
+}
+
+struct mocked_path *mocked_path_from_path(struct mocked_path *mp,
+					  const struct path *pp)
+{
+	mp->vendor = pp->vendor_id;
+	mp->product = pp->product_id;
+	mp->rev = pp->rev;
+	mp->wwid = pp->wwid;
+	mp->devnode = pp->dev;
+	mp->flags = (prio_selected(&pp->prio) ? 0 : NEED_SELECT_PRIO) |
+		(pp->fd < 0 ? NEED_FD : 0) |
+		(pp->getuid ? USE_GETUID : 0);
+	return mp;
+}
+
+static void mock_sysfs_pathinfo(const struct mocked_path *mp)
+{
+	static const char hbtl[] = "4:0:3:1";
+
+	will_return(__wrap_udev_device_get_subsystem, "scsi");
+	will_return(__wrap_udev_device_get_sysname, hbtl);
+	will_return(__wrap_udev_device_get_sysname, hbtl);
+	will_return(__wrap_udev_device_get_sysattr_value, mp->vendor);
+	will_return(__wrap_udev_device_get_sysname, hbtl);
+	will_return(__wrap_udev_device_get_sysattr_value, mp->product);
+	will_return(__wrap_udev_device_get_sysname, hbtl);
+	will_return(__wrap_udev_device_get_sysattr_value, mp->rev);
+
+	/* sysfs_get_tgt_nodename */
+	will_return(__wrap_udev_device_get_sysattr_value, NULL);
+	will_return(__wrap_udev_device_get_parent, NULL);
+	will_return(__wrap_udev_device_get_parent, NULL);
+	will_return(__wrap_udev_device_get_sysname, "nofibre");
+	will_return(__wrap_udev_device_get_sysname, "noiscsi");
+	will_return(__wrap_udev_device_get_parent, NULL);
+	will_return(__wrap_udev_device_get_sysname, "ata25");
+}
+
+/*
+ * Pretend we detected a SCSI device with given vendor/prod/rev
+ */
+void mock_pathinfo(int mask, const struct mocked_path *mp)
+{
+	/* filter_property */
+	will_return(__wrap_udev_device_get_sysname, mp->devnode);
+	if (mp->flags & BL_BY_PROPERTY) {
+		will_return(__wrap_udev_list_entry_get_name, "BAZ");
+		return;
+	} else
+		will_return(__wrap_udev_list_entry_get_name,
+			    "SCSI_IDENT_LUN_NAA_EXT");
+	if (mask & DI_SYSFS)
+		mock_sysfs_pathinfo(mp);
+
+	if (mp->flags & BL_BY_DEVICE &&
+	    (mask & DI_BLACKLIST && mask & DI_SYSFS))
+		return;
+
+	/* path_offline */
+	will_return(__wrap_udev_device_get_subsystem, "scsi");
+	will_return(__wrap_sysfs_attr_get_value, "running");
+
+	if (mask & DI_NOIO)
+		return;
+
+	/* fake open() in pathinfo() */
+	if (mp->flags & NEED_FD)
+		will_return(__wrap_udev_device_get_devnode, _mocked_filename);
+	/* DI_SERIAL is unsupported */
+	assert_false(mask & DI_SERIAL);
+
+	if (mask & DI_WWID) {
+		if (mp->flags & USE_GETUID)
+			will_return(__wrap_execute_program, mp->wwid);
+		else
+			/* get_udev_uid() */
+			will_return(__wrap_udev_device_get_property_value,
+				    mp->wwid);
+	}
+
+	if (mask & DI_CHECKER) {
+		/* get_state -> sysfs_get_timeout  */
+		will_return(__wrap_udev_device_get_subsystem, "scsi");
+		will_return(__wrap_udev_device_get_sysattr_value, "180");
+	}
+
+	if (mask & DI_PRIO && mp->flags & NEED_SELECT_PRIO) {
+
+		/* sysfs_get_timeout, again (!?) */
+		will_return(__wrap_udev_device_get_subsystem, "scsi");
+		will_return(__wrap_udev_device_get_sysattr_value, "180");
+
+	}
+}
+
+void mock_store_pathinfo(int mask,  const struct mocked_path *mp)
+{
+	will_return(__wrap_udev_device_get_sysname, mp->devnode);
+	mock_pathinfo(mask, mp);
+}
+
+struct path *__mock_path(vector pathvec,
+			 const char *vnd, const char *prd,
+			 const char *rev, const char *wwid,
+			 const char *dev,
+			 unsigned int flags, int mask)
+{
+	struct mocked_path mop;
+	struct path *pp;
+	struct config *conf;
+	int r;
+
+	fill_mocked_path(&mop, vnd, prd, rev, wwid, dev, flags);
+	mock_store_pathinfo(mask, &mop);
+
+	conf = get_multipath_config();
+	r = store_pathinfo(pathvec, conf, (void *)&mop, mask, &pp);
+	put_multipath_config(conf);
+
+	if (flags & BL_MASK) {
+		assert_int_equal(r, PATHINFO_SKIPPED);
+		return NULL;
+	}
+	assert_int_equal(r, PATHINFO_OK);
+	assert_non_null(pp);
+	return pp;
+}
+
+
+struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp)
+{
+	struct multipath *mp;
+	struct config *conf;
+	struct mocked_path mop;
+
+	mocked_path_from_path(&mop, pp);
+	/* pathinfo() call in adopt_paths */
+	mock_pathinfo(DI_CHECKER|DI_PRIO, &mop);
+
+	mp = add_map_with_path(vecs, pp, 1);
+	assert_ptr_not_equal(mp, NULL);
+
+	/* TBD: mock setup_map() ... */
+	conf = get_multipath_config();
+	select_pgpolicy(conf, mp);
+	select_no_path_retry(conf, mp);
+	select_retain_hwhandler(conf, mp);
+	select_minio(conf, mp);
+	put_multipath_config(conf);
+
+	return mp;
+}
diff --git a/tests/test-lib.h b/tests/test-lib.h
new file mode 100644
index 00000000..d2745979
--- /dev/null
+++ b/tests/test-lib.h
@@ -0,0 +1,67 @@
+#ifndef __LIB_H
+#define __LIB_H
+
+extern const int default_mask;
+extern const char default_devnode[];
+extern const char default_wwid[];
+extern const char default_wwid_1[];
+
+enum {
+	BL_BY_DEVNODE	= (1 << 0),
+	BL_BY_DEVICE	= (1 << 1),
+	BL_BY_WWID	= (1 << 2),
+	BL_BY_PROPERTY	= (1 << 3),
+	BL_MASK = BL_BY_DEVNODE|BL_BY_DEVICE|BL_BY_WWID|BL_BY_PROPERTY,
+	NEED_SELECT_PRIO = (1 << 8),
+	NEED_FD		= (1 << 9),
+	USE_GETUID	= (1 << 10)
+};
+
+struct mocked_path {
+	const char *vendor;
+	const char *product;
+	const char *rev;
+	const char *wwid;
+	const char *devnode;
+	unsigned int flags;
+};
+
+struct mocked_path *fill_mocked_path(struct mocked_path *mp,
+				     const char *vendor,
+				     const char *product,
+				     const char *rev,
+				     const char *wwid,
+				     const char *devnode,
+				     unsigned int flags);
+
+struct mocked_path *mocked_path_from_path(struct mocked_path *mp,
+					  const struct path *pp);
+
+void mock_pathinfo(int mask, const struct mocked_path *mp);
+void mock_store_pathinfo(int mask, const struct mocked_path *mp);
+struct path *__mock_path(vector pathvec,
+			 const char *vnd, const char *prd,
+			 const char *rev, const char *wwid,
+			 const char *dev,
+			 unsigned int flags, int mask);
+
+#define mock_path(v, p) \
+	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL,	\
+		    0, default_mask)
+#define mock_path_flags(v, p, f) \
+	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
+		    (f), default_mask)
+#define mock_path_blacklisted(v, p) \
+	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
+		    BL_BY_DEVICE, default_mask)
+#define mock_path_wwid(v, p, w) \
+	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", (w), NULL,	\
+		    0, default_mask)
+#define mock_path_wwid_flags(v, p, w, f) \
+	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", (w),		\
+		    NULL, (f), default_mask)
+
+struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp);
+#define mock_multipath(pp) __mock_multipath(hwt->vecs, (pp))
+
+#endif
-- 
2.17.0
