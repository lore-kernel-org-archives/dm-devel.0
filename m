From: mwilck@suse.com
Subject: [PATCH 06/35] multipath-tools tests: add test for
	devt2devname
Date: Thu,  9 Jul 2020 12:15:51 +0200
Message-ID: <20200709101620.6786-7-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Two tests skipped because they fail, will be fixed with the following
patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile |   3 +-
 tests/devt.c   | 194 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 tests/devt.c

diff --git a/tests/Makefile b/tests/Makefile
index 125553b..5f00a3a 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -13,7 +13,7 @@ CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
 LIBDEPS += -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid
+	 alias directio valid devt
 
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
@@ -52,6 +52,7 @@ alias-test_TESTDEPS := test-log.o
 alias-test_LIBDEPS := -lpthread -ldl
 valid-test_OBJDEPS := ../libmultipath/valid.o
 valid-test_LIBDEPS := -ludev -lpthread -ldl
+devt-test_LIBDEPS := -ludev
 ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
diff --git a/tests/devt.c b/tests/devt.c
new file mode 100644
index 0000000..4be6d75
--- /dev/null
+++ b/tests/devt.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (c) 2020 Martin Wilck, SUSE
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <cmocka.h>
+#include <libudev.h>
+#include <sys/sysmacros.h>
+#include "util.h"
+#include "debug.h"
+
+#include "globals.c"
+
+static int get_one_devt(char *devt, size_t len)
+{
+	struct udev_enumerate *enm;
+	int r, ret = -1;
+	struct udev_list_entry *first;
+	struct udev_device *u_dev;
+	const char *path;
+	dev_t devnum;
+
+	enm = udev_enumerate_new(udev);
+	if (!enm)
+		return -1;
+	r = udev_enumerate_add_match_subsystem(enm, "block");
+	r = udev_enumerate_scan_devices(enm);
+	if (r < 0)
+		goto out;
+	first = udev_enumerate_get_list_entry(enm);
+	if (!first)
+		goto out;
+	path = udev_list_entry_get_name(first);
+	u_dev = udev_device_new_from_syspath(udev, path);
+	if (!u_dev)
+		goto out;
+	devnum = udev_device_get_devnum(u_dev);
+	snprintf(devt, len, "%d:%d",
+		 major(devnum), minor(devnum));
+	udev_device_unref(u_dev);
+	condlog(3, "found block device: %s", devt);
+	ret = 0;
+out:
+	udev_enumerate_unref(enm);
+	return ret;
+}
+
+int setup(void **state)
+{
+	static char dev_t[BLK_DEV_SIZE];
+
+	udev = udev_new();
+	if (udev == NULL)
+		return -1;
+	*state = dev_t;
+	return get_one_devt(dev_t, sizeof(dev_t));
+}
+
+int teardown(void **state)
+{
+	udev_unref(udev);
+	return 0;
+}
+
+static void test_devt2devname_devt_good(void **state)
+{
+	char dummy[BLK_DEV_SIZE];
+
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), *state), 0);
+}
+
+static void test_devt2devname_devname_null(void **state)
+{
+	assert_int_equal(devt2devname(NULL, 0, ""), 1);
+}
+
+/* buffer length 0 */
+static void test_devt2devname_length_0(void **state)
+{
+	char dummy[] = "";
+
+	assert_int_equal(devt2devname(dummy, 0, ""), 1);
+}
+
+/* buffer too small */
+static void test_devt2devname_length_1(void **state)
+{
+	char dummy[] = "";
+
+	skip();
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), *state), 1);
+}
+
+static void test_devt2devname_devt_null(void **state)
+{
+	char dummy[32];
+
+	skip();
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), NULL), 1);
+}
+
+static void test_devt2devname_devt_empty(void **state)
+{
+	char dummy[32];
+
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), ""), 1);
+}
+
+static void test_devt2devname_devt_invalid_1(void **state)
+{
+	char dummy[32];
+
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), "foo"), 1);
+}
+
+static void test_devt2devname_devt_invalid_2(void **state)
+{
+	char dummy[32];
+
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), "1234"), 1);
+}
+
+static void test_devt2devname_devt_invalid_3(void **state)
+{
+	char dummy[32];
+
+	assert_int_equal(devt2devname(dummy, sizeof(dummy), "0:0"), 1);
+}
+
+static void test_devt2devname_real(void **state)
+{
+	struct udev_enumerate *enm;
+	int r;
+	struct udev_list_entry *first, *item;
+	unsigned int i = 0;
+
+	enm = udev_enumerate_new(udev);
+	assert_non_null(enm);
+	r = udev_enumerate_add_match_subsystem(enm, "block");
+	assert_in_range(r, 0, INT_MAX);
+	r = udev_enumerate_scan_devices(enm);
+	first = udev_enumerate_get_list_entry(enm);
+	udev_list_entry_foreach(item, first) {
+		const char *path = udev_list_entry_get_name(item);
+		struct udev_device *u_dev;
+		dev_t devnum;
+		char devt[BLK_DEV_SIZE];
+		char devname[FILE_NAME_SIZE];
+
+		u_dev = udev_device_new_from_syspath(udev, path);
+		assert_non_null(u_dev);
+		devnum = udev_device_get_devnum(u_dev);
+		snprintf(devt, sizeof(devt), "%d:%d",
+			 major(devnum), minor(devnum));
+		r = devt2devname(devname, sizeof(devname), devt);
+		assert_int_equal(r, 0);
+		assert_string_equal(devname, udev_device_get_sysname(u_dev));
+		i++;
+		udev_device_unref(u_dev);
+	}
+	udev_enumerate_unref(enm);
+	condlog(2, "devt2devname test passed for %u block devices", i);
+}
+
+static int devt2devname_tests(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_devt2devname_devt_good),
+		cmocka_unit_test(test_devt2devname_devname_null),
+		cmocka_unit_test(test_devt2devname_length_0),
+		cmocka_unit_test(test_devt2devname_length_1),
+		cmocka_unit_test(test_devt2devname_devt_null),
+		cmocka_unit_test(test_devt2devname_devt_empty),
+		cmocka_unit_test(test_devt2devname_devt_invalid_1),
+		cmocka_unit_test(test_devt2devname_devt_invalid_2),
+		cmocka_unit_test(test_devt2devname_devt_invalid_3),
+		cmocka_unit_test(test_devt2devname_real),
+	};
+
+	return cmocka_run_group_tests(tests, setup, teardown);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	ret += devt2devname_tests();
+	return ret;
+}
-- 
2.26.2
