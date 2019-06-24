From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/30] multipath-tools tests: add strlcpy()
	tests
Date: Mon, 24 Jun 2019 11:27:38 +0200
Message-ID: <20190624092756.7769-14-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

As we're using strlcpy quite a bit, make sure it works as designed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/tests/util.c b/tests/util.c
index e6d4b9ab..4e04a480 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -258,10 +258,152 @@ int test_basenamecpy(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static const char src_str[] = "Hello";
+
+/* strlcpy with length 0 */
+static void test_strlcpy_0(void **state)
+{
+	char tst[] = "word";
+	int rc;
+
+	rc = strlcpy(tst, src_str, 0);
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(tst, "word");
+}
+
+/* strlcpy with length 1 */
+static void test_strlcpy_1(void **state)
+{
+	char tst[] = "word";
+	int rc;
+
+	rc = strlcpy(tst, src_str, 1);
+	assert_int_equal(rc, strlen(src_str));
+	assert_int_equal(tst[0], '\0');
+	assert_string_equal(tst + 1, "ord");
+}
+
+/* strlcpy with length 2 */
+static void test_strlcpy_2(void **state)
+{
+	char tst[] = "word";
+	int rc;
+
+	rc = strlcpy(tst, src_str, 2);
+	assert_int_equal(rc, strlen(src_str));
+	assert_int_equal(tst[0], src_str[0]);
+	assert_int_equal(tst[1], '\0');
+	assert_string_equal(tst + 2, "rd");
+}
+
+/* strlcpy with dst length < src length */
+static void test_strlcpy_3(void **state)
+{
+	char tst[] = "word";
+	int rc;
+
+	rc = strlcpy(tst, src_str, sizeof(tst));
+	assert_int_equal(rc, strlen(src_str));
+	assert_int_equal(sizeof(tst) - 1, strlen(tst));
+	assert_true(strncmp(tst, src_str, sizeof(tst) - 1) == 0);
+}
+
+/* strlcpy with dst length > src length */
+static void test_strlcpy_4(void **state)
+{
+	static const char old[] = "0123456789";
+	char *tst;
+	int rc;
+
+	tst = strdup(old);
+	rc = strlcpy(tst, src_str, sizeof(old));
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(src_str, tst);
+	assert_string_equal(tst + sizeof(src_str), old + sizeof(src_str));
+	free(tst);
+}
+
+/* strlcpy with dst length = src length, dst not terminated */
+static void test_strlcpy_5(void **state)
+{
+	char *tst;
+	int rc;
+
+	tst = malloc(sizeof(src_str));
+	memset(tst, 'f', sizeof(src_str));
+
+	rc = strlcpy(tst, src_str, sizeof(src_str));
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(src_str, tst);
+
+	free(tst);
+}
+
+/* strlcpy with dst length > src length, dst not terminated */
+static void test_strlcpy_6(void **state)
+{
+	char *tst;
+	int rc;
+
+	tst = malloc(sizeof(src_str) + 2);
+	memset(tst, 'f', sizeof(src_str) + 2);
+
+	rc = strlcpy(tst, src_str, sizeof(src_str) + 2);
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(src_str, tst);
+	assert_int_equal(tst[sizeof(src_str)], 'f');
+	assert_int_equal(tst[sizeof(src_str) + 1], 'f');
+
+	free(tst);
+}
+
+/* strlcpy with empty src */
+static void test_strlcpy_7(void **state)
+{
+	char tst[] = "word";
+	static const char empty[] = "";
+	int rc;
+
+	rc = strlcpy(tst, empty, sizeof(tst));
+	assert_int_equal(rc, strlen(empty));
+	assert_string_equal(empty, tst);
+	assert_string_equal(tst + 1, "ord");
+}
+
+/* strlcpy with empty src, length 0 */
+static void test_strlcpy_8(void **state)
+{
+	char tst[] = "word";
+	static const char empty[] = "";
+	int rc;
+
+	rc = strlcpy(tst, empty, 0);
+	assert_int_equal(rc, strlen(empty));
+	assert_string_equal("word", tst);
+}
+
+static int test_strlcpy(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_strlcpy_0),
+		cmocka_unit_test(test_strlcpy_1),
+		cmocka_unit_test(test_strlcpy_2),
+		cmocka_unit_test(test_strlcpy_3),
+		cmocka_unit_test(test_strlcpy_4),
+		cmocka_unit_test(test_strlcpy_5),
+		cmocka_unit_test(test_strlcpy_6),
+		cmocka_unit_test(test_strlcpy_7),
+		cmocka_unit_test(test_strlcpy_8),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 int main(void)
 {
 	int ret = 0;
 
 	ret += test_basenamecpy();
+	ret += test_strlcpy();
 	return ret;
 }
-- 
2.21.0
