From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 01/12] Unit tests for basenamecpy
Date: Wed, 14 Mar 2018 12:46:34 -0500
Message-ID: <1521049605-22050-2-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

The current implementation of basenamecpy is broken, so some of these
tests currently fail. Fixes to follow.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/Makefile |   2 +-
 tests/util.c   | 167 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+), 1 deletion(-)
 create mode 100644 tests/util.c

diff --git a/tests/Makefile b/tests/Makefile
index 81f5518..3450b14 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -3,7 +3,7 @@ include ../Makefile.inc
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
 LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
 
-TESTS := uevent parser
+TESTS := uevent parser util
 
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
diff --git a/tests/util.c b/tests/util.c
new file mode 100644
index 0000000..e9a004f
--- /dev/null
+++ b/tests/util.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright (c) 2018 Benjamin Marzinski, Redhat
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
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <cmocka.h>
+#include "util.h"
+
+#include "globals.c"
+
+static void test_basenamecpy_good0(void **state)
+{
+	char dst[10];
+
+	assert_int_equal(basenamecpy("foobar", dst, sizeof(dst)), 6);
+	assert_string_equal(dst, "foobar");
+}
+
+static void test_basenamecpy_good1(void **state)
+{
+	char dst[10];
+
+	assert_int_equal(basenamecpy("foo/bar", dst, sizeof(dst)), 3);
+	assert_string_equal(dst, "bar");
+}
+
+static void test_basenamecpy_good2(void **state)
+{
+	char dst[10];
+
+	assert_int_equal(basenamecpy("/thud/blat", dst, sizeof(dst)), 4);
+	assert_string_equal(dst, "blat");
+}
+
+static void test_basenamecpy_good3(void **state)
+{
+	char dst[4];
+
+	assert_int_equal(basenamecpy("foo/bar", dst, sizeof(dst)), 3);
+	assert_string_equal(dst, "bar");
+}
+
+static void test_basenamecpy_good4(void **state)
+{
+	char dst[10];
+
+	assert_int_equal(basenamecpy("/xyzzy", dst, sizeof(dst)), 5);
+	assert_string_equal(dst, "xyzzy");
+}
+
+static void test_basenamecpy_good5(void **state)
+{
+	char dst[4];
+
+	assert_int_equal(basenamecpy("/foo/bar\n", dst, sizeof(dst)), 3);
+	assert_string_equal(dst, "bar");
+}
+
+static void test_basenamecpy_good6(void **state)
+{
+        char dst[6];
+
+        assert_int_equal(basenamecpy("/xyzzy/plugh   ", dst, sizeof(dst)), 5);
+        assert_string_equal(dst, "plugh");
+}
+
+static void test_basenamecpy_good7(void **state)
+{
+	char src[] = "/foo/bar";
+	char dst[10];
+
+	assert_int_equal(basenamecpy(src, dst, sizeof(dst)), 3);
+
+	strcpy(src, "badbadno");
+	assert_string_equal(dst, "bar");
+}
+
+/* buffer too small */
+static void test_basenamecpy_bad0(void **state)
+{
+        char dst[3];
+
+        assert_int_equal(basenamecpy("baz", dst, sizeof(dst)), 0);
+}
+
+/* ends in slash */
+static void test_basenamecpy_bad1(void **state)
+{
+        char dst[10];
+
+        assert_int_equal(basenamecpy("foo/bar/", dst, sizeof(dst)), 0);
+}
+
+static void test_basenamecpy_bad2(void **state)
+{
+        char dst[10];
+
+        assert_int_equal(basenamecpy(NULL, dst, sizeof(dst)), 0);
+}
+
+static void test_basenamecpy_bad3(void **state)
+{
+        char dst[10];
+
+        assert_int_equal(basenamecpy("", dst, sizeof(dst)), 0);
+}
+
+static void test_basenamecpy_bad4(void **state)
+{
+        char dst[10];
+
+        assert_int_equal(basenamecpy("/", dst, sizeof(dst)), 0);
+}
+
+static void test_basenamecpy_bad5(void **state)
+{
+        char dst[10];
+
+        assert_int_equal(basenamecpy("baz/qux", NULL, sizeof(dst)), 0);
+}
+
+int test_basenamecpy(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_basenamecpy_good0),
+		cmocka_unit_test(test_basenamecpy_good1),
+		cmocka_unit_test(test_basenamecpy_good2),
+		cmocka_unit_test(test_basenamecpy_good3),
+		cmocka_unit_test(test_basenamecpy_good4),
+		cmocka_unit_test(test_basenamecpy_good5),
+		cmocka_unit_test(test_basenamecpy_good6),
+		cmocka_unit_test(test_basenamecpy_good7),
+		cmocka_unit_test(test_basenamecpy_bad0),
+		cmocka_unit_test(test_basenamecpy_bad1),
+		cmocka_unit_test(test_basenamecpy_bad2),
+		cmocka_unit_test(test_basenamecpy_bad3),
+		cmocka_unit_test(test_basenamecpy_bad4),
+		cmocka_unit_test(test_basenamecpy_bad5),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	ret += test_basenamecpy();
+	return ret;
+}
-- 
2.7.4
