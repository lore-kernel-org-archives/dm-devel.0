From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/7] tests: cmocka-based unit test for
	uevent_get_XXX
Date: Wed, 17 Jan 2018 08:49:34 +0100
Message-ID: <20180117074939.7795-3-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch starts a simple unit test framework for multipath-tools
based on the cmocka framework (https://cmocka.org/). As a start,
it adds unit tests for the uevent_get_XXX set of functions.

Note that some tests currently fail. This will be fixed by the
following patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore      |   3 +
 Makefile        |   4 +
 tests/Makefile  |  23 ++++++
 tests/globals.c |  17 ++++
 tests/uevent.c  | 241 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 288 insertions(+)
 create mode 100644 tests/Makefile
 create mode 100644 tests/globals.c
 create mode 100644 tests/uevent.c

diff --git a/.gitignore b/.gitignore
index 57cf7e6a31a5..371b8758c0a1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,3 +18,6 @@ libdmmp/docs/man/*.3.gz
 libdmmp/*.so.*
 libdmmp/test/libdmmp_test
 libdmmp/test/libdmmp_speed_test
+tests/*-test
+tests/*.out
+
diff --git a/Makefile b/Makefile
index bfb168fb172c..11c46eb4dbc9 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,7 @@ recurse_clean:
 	@for dir in $(BUILDDIRS); do \
 	$(MAKE) -C $$dir clean || exit $?; \
 	done
+	$(MAKE) -C tests clean
 
 recurse_install:
 	@for dir in $(BUILDDIRS); do \
@@ -44,6 +45,9 @@ install: recurse_install
 
 uninstall: recurse_uninstall
 
+test:	all
+	$(MAKE) -C tests
+
 .PHONY:	TAGS
 TAGS:
 	etags -a libmultipath/*.c
diff --git a/tests/Makefile b/tests/Makefile
new file mode 100644
index 000000000000..ff58cb8bb207
--- /dev/null
+++ b/tests/Makefile
@@ -0,0 +1,23 @@
+include ../Makefile.inc
+
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
+LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
+
+TESTS := uevent
+
+.SILENT: $(TESTS:%=%.o)
+.PRECIOUS: $(TESTS:%=%-test)
+
+%-test:	%.o globals.c $(multipathdir)/libmultipath.so
+	@$(CC) -o $@ $< $(LDFLAGS) $(LIBDEPS)
+
+%.out:	%-test
+	@echo == running $< ==
+	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
+
+all:	$(TESTS:%=%.out)
+
+clean:
+	rm -f $(TESTS:%=%-test) $(TESTS:%=%.out) $(TESTS:%=%.o)
+
+
diff --git a/tests/globals.c b/tests/globals.c
new file mode 100644
index 000000000000..96a56515fd09
--- /dev/null
+++ b/tests/globals.c
@@ -0,0 +1,17 @@
+#include "structs.h"
+#include "config.h"
+
+/* Required globals */
+struct udev *udev;
+int logsink = 0;
+struct config conf = {
+	.uid_attrs = "sd:ID_BOGUS",
+};
+
+struct config *get_multipath_config(void)
+{
+	return &conf;
+}
+
+void put_multipath_config(struct config* c)
+{}
diff --git a/tests/uevent.c b/tests/uevent.c
new file mode 100644
index 000000000000..a8edd710f653
--- /dev/null
+++ b/tests/uevent.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (c) 2018 SUSE Linux GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ *
+ */
+
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <cmocka.h>
+#include "list.h"
+#include "uevent.h"
+
+#include "globals.c"
+
+/* Private prototypes missing in uevent.h */
+struct uevent * alloc_uevent(void);
+void uevent_get_wwid(struct uevent *uev);
+
+/* Stringify helpers */
+#define _str_(x) #x
+#define str(x) _str_(x)
+
+#define MAJOR 17
+#define MINOR 217
+#define DISK_RO 0
+#define DM_NAME "spam"
+#define WWID "foo"
+
+static int setup_uev(void **state)
+{
+	struct uevent *uev = alloc_uevent();
+
+	if (uev == NULL)
+		return -1;
+
+	*state = uev;
+	uev->kernel = "sdo";
+	uev->envp[0] = "MAJOR=" str(MAJOR);
+	uev->envp[1] = "ID_BOGUS=" WWID;
+	uev->envp[2] = "MINOR=" str(MINOR);
+	uev->envp[3] = "DM_NAME=" DM_NAME;
+	uev->envp[4] = "DISK_RO=" str(DISK_RO);
+	uev->envp[5] = NULL;
+	return 0;
+}
+
+static int teardown(void **state)
+{
+	free(*state);
+	return 0;
+}
+
+static void test_major_good(void **state)
+{
+	struct uevent *uev = *state;
+
+	assert_int_equal(uevent_get_major(uev), MAJOR);
+}
+
+static void test_minor_good(void **state)
+{
+	struct uevent *uev = *state;
+
+	assert_int_equal(uevent_get_minor(uev), MINOR);
+}
+
+static void test_ro_good(void **state)
+{
+	struct uevent *uev = *state;
+
+	assert_int_equal(uevent_get_disk_ro(uev), DISK_RO);
+}
+
+static void test_wwid(void **state)
+{
+	struct uevent *uev = *state;
+	uevent_get_wwid(uev);
+
+	assert_string_equal(uev->wwid, WWID);
+}
+
+static void test_major_bad_0(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR" str(MAJOR);
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_1(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOr=" str(MAJOR);
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_2(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJORIE=" str(MAJOR);
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_3(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR=max";
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_4(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR=0x10";
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_5(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJO=" str(MAJOR);
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_6(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR=" str(-MAJOR);
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_7(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR=";
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_major_bad_8(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[0] = "MAJOR";
+	assert_int_equal(uevent_get_major(uev), -1);
+}
+
+static void test_dm_name_good(void **state)
+{
+	struct uevent *uev = *state;
+	const char *name = uevent_get_dm_name(uev);
+
+	assert_string_equal(name, DM_NAME);
+	free((void*)name);
+}
+
+static void test_dm_name_bad_0(void **state)
+{
+	struct uevent *uev = *state;
+	const char *name;
+
+	uev->envp[3] = "DM_NAME" DM_NAME;
+	name = uevent_get_dm_name(uev);
+	assert_ptr_equal(name, NULL);
+	free((void*)name);
+}
+
+static void test_dm_name_bad_1(void **state)
+{
+	struct uevent *uev = *state;
+	const char *name;
+
+	uev->envp[3] = "DM_NAMES=" DM_NAME;
+	name = uevent_get_dm_name(uev);
+	assert_ptr_equal(name, NULL);
+	free((void*)name);
+}
+
+static void test_dm_name_good_1(void **state)
+{
+	struct uevent *uev = *state;
+	const char *name;
+
+	/* Note we change index 2 here */
+	uev->envp[2] = "DM_NAME=" DM_NAME;
+	name = uevent_get_dm_name(uev);
+	assert_string_equal(name, DM_NAME);
+	free((void*)name);
+}
+
+int test_uevent_get_XXX(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_major_good),
+		cmocka_unit_test(test_minor_good),
+		cmocka_unit_test(test_ro_good),
+		cmocka_unit_test(test_dm_name_good),
+		cmocka_unit_test(test_wwid),
+		cmocka_unit_test(test_major_bad_0),
+		cmocka_unit_test(test_major_bad_1),
+		cmocka_unit_test(test_major_bad_2),
+		cmocka_unit_test(test_major_bad_3),
+		cmocka_unit_test(test_major_bad_4),
+		cmocka_unit_test(test_major_bad_5),
+		cmocka_unit_test(test_major_bad_6),
+		cmocka_unit_test(test_major_bad_7),
+		cmocka_unit_test(test_major_bad_8),
+		cmocka_unit_test(test_dm_name_bad_0),
+		cmocka_unit_test(test_dm_name_bad_1),
+		cmocka_unit_test(test_dm_name_good_1),
+	};
+	return cmocka_run_group_tests(tests, setup_uev, teardown);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	ret += test_uevent_get_XXX();
+	return ret;
+}
-- 
2.15.1
