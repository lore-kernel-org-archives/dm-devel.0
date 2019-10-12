From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 11/72] multipath tests: alias: add tests for
 allocate_binding()
Date: Sat, 12 Oct 2019 21:27:50 +0000
Message-ID: <20191012212703.12989-12-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tests/alias.c b/tests/alias.c
index 32fdc697..170ebbeb 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -5,6 +5,7 @@
 #include "util.h"
 #include "alias.h"
 #include "test-log.h"
+#include <errno.h>
 
 #include "globals.c"
 #include "../libmultipath/alias.c"
@@ -30,6 +31,36 @@ char *__wrap_fgets(char *buf, int n, FILE *stream)
 	return buf;
 }
 
+static int __set_errno(int err)
+{
+	if (err >= 0) {
+		errno = 0;
+		return err;
+	} else {
+		errno = -err;
+		return -1;
+	}
+}
+
+off_t __wrap_lseek(int fd, off_t offset, int whence)
+{
+	return __set_errno(mock_type(int));
+
+}
+
+ssize_t __wrap_write(int fd, const void *buf, size_t count)
+{
+	check_expected(count);
+	check_expected(buf);
+	return __set_errno(mock_type(int));
+}
+
+int __wrap_ftruncate(int fd, off_t length)
+{
+	check_expected(length);
+	return __set_errno(mock_type(int));
+}
+
 static void fd_mpatha(void **state)
 {
 	char buf[32];
@@ -577,6 +608,98 @@ static int test_rlookup_binding(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static void al_a(void **state)
+{
+	static const char ln[] = "MPATHa WWIDa\n";
+	char *alias;
+
+	will_return(__wrap_lseek, 0);
+	expect_value(__wrap_write, count, strlen(ln));
+	expect_string(__wrap_write, buf, ln);
+	will_return(__wrap_write, strlen(ln));
+	expect_condlog(3, "Created new binding [MPATHa] for WWID [WWIDa]\n");
+
+	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
+	assert_ptr_not_equal(alias, NULL);
+	assert_string_equal(alias, "MPATHa");
+}
+
+static void al_zz(void **state)
+{
+	static const char ln[] = "MPATHzz WWIDzz\n";
+	char *alias;
+
+	will_return(__wrap_lseek, 0);
+	expect_value(__wrap_write, count, strlen(ln));
+	expect_string(__wrap_write, buf, ln);
+	will_return(__wrap_write, strlen(ln));
+	expect_condlog(3, "Created new binding [MPATHzz] for WWID [WWIDzz]\n");
+
+	alias = allocate_binding(0, "WWIDzz", 26*26 + 26, "MPATH");
+	assert_ptr_not_equal(alias, NULL);
+	assert_string_equal(alias, "MPATHzz");
+}
+
+static void al_0(void **state)
+{
+	char *alias;
+
+	expect_condlog(0, "allocate_binding: cannot allocate new binding for id 0\n");
+	alias = allocate_binding(0, "WWIDa", 0, "MPATH");
+	assert_ptr_equal(alias, NULL);
+}
+
+static void al_m2(void **state)
+{
+	char *alias;
+
+	expect_condlog(0, "allocate_binding: cannot allocate new binding for id -2\n");
+	alias = allocate_binding(0, "WWIDa", -2, "MPATH");
+	assert_ptr_equal(alias, NULL);
+}
+
+static void al_lseek_err(void **state)
+{
+	char *alias;
+
+	will_return(__wrap_lseek, -ENODEV);
+	expect_condlog(0, "Cannot seek to end of bindings file : No such device\n");
+	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
+	assert_ptr_equal(alias, NULL);
+}
+
+static void al_write_err(void **state)
+{
+	static const char ln[] = "MPATHa WWIDa\n";
+	const int offset = 20;
+	char *alias;
+
+	will_return(__wrap_lseek, offset);
+	expect_value(__wrap_write, count, strlen(ln));
+	expect_string(__wrap_write, buf, ln);
+	will_return(__wrap_write, strlen(ln) - 1);
+	expect_value(__wrap_ftruncate, length, offset);
+	will_return(__wrap_ftruncate, 0);
+	expect_condlog(0, "Cannot write binding to bindings file : Success\n");
+
+	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
+	assert_ptr_equal(alias, NULL);
+}
+
+static int test_allocate_binding(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(al_a),
+		cmocka_unit_test(al_zz),
+		cmocka_unit_test(al_0),
+		cmocka_unit_test(al_m2),
+		cmocka_unit_test(al_lseek_err),
+		cmocka_unit_test(al_write_err),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 int main(void)
 {
 	int ret = 0;
@@ -585,6 +708,7 @@ int main(void)
 	ret += test_scan_devname();
 	ret += test_lookup_binding();
 	ret += test_rlookup_binding();
+	ret += test_allocate_binding();
 
 	return ret;
 }
-- 
2.23.0
