From: mwilck@suse.com
Subject: [PATCH 11/35] multipath-tools tests: add unit tests for
	strlcat
Date: Thu,  9 Jul 2020 12:15:56 +0200
Message-ID: <20200709101620.6786-12-mwilck@suse.com>
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

Also, use some constants for both strlcpy and strlcat tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 222 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 210 insertions(+), 12 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index db7c05f..3c4113e 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -476,48 +476,54 @@ static int test_bitmasks(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
-static const char src_str[] = "Hello";
+#define DST_STR "Hello"
+static const char dst_str[] = DST_STR;
+/* length of src_str and dst_str should be different */
+static const char src_str[] = " World";
+/* Must be big enough to hold dst_str and src_str */
+#define ARRSZ 16
+#define FILL '@'
 
 /* strlcpy with length 0 */
 static void test_strlcpy_0(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	int rc;
 
 	rc = strlcpy(tst, src_str, 0);
 	assert_int_equal(rc, strlen(src_str));
-	assert_string_equal(tst, "word");
+	assert_string_equal(tst, dst_str);
 }
 
 /* strlcpy with length 1 */
 static void test_strlcpy_1(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	int rc;
 
 	rc = strlcpy(tst, src_str, 1);
 	assert_int_equal(rc, strlen(src_str));
 	assert_int_equal(tst[0], '\0');
-	assert_string_equal(tst + 1, "ord");
+	assert_string_equal(tst + 1, dst_str + 1);
 }
 
 /* strlcpy with length 2 */
 static void test_strlcpy_2(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	int rc;
 
 	rc = strlcpy(tst, src_str, 2);
 	assert_int_equal(rc, strlen(src_str));
 	assert_int_equal(tst[0], src_str[0]);
 	assert_int_equal(tst[1], '\0');
-	assert_string_equal(tst + 2, "rd");
+	assert_string_equal(tst + 2, dst_str + 2);
 }
 
 /* strlcpy with dst length < src length */
 static void test_strlcpy_3(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	int rc;
 
 	rc = strlcpy(tst, src_str, sizeof(tst));
@@ -580,26 +586,26 @@ static void test_strlcpy_6(void **state)
 /* strlcpy with empty src */
 static void test_strlcpy_7(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	static const char empty[] = "";
 	int rc;
 
 	rc = strlcpy(tst, empty, sizeof(tst));
 	assert_int_equal(rc, strlen(empty));
 	assert_string_equal(empty, tst);
-	assert_string_equal(tst + 1, "ord");
+	assert_string_equal(tst + 1, dst_str + 1);
 }
 
 /* strlcpy with empty src, length 0 */
 static void test_strlcpy_8(void **state)
 {
-	char tst[] = "word";
+	char tst[] = DST_STR;
 	static const char empty[] = "";
 	int rc;
 
 	rc = strlcpy(tst, empty, 0);
 	assert_int_equal(rc, strlen(empty));
-	assert_string_equal("word", tst);
+	assert_string_equal(dst_str, tst);
 }
 
 static int test_strlcpy(void)
@@ -619,6 +625,197 @@ static int test_strlcpy(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+
+/* 0-terminated string, filled with non-0 after the terminator */
+static void prep_buf(char *buf, size_t size, const char *word)
+{
+	memset(buf, FILL, size);
+	assert_in_range(strlen(word), 0, size - 1);
+	memcpy(buf, word, strlen(word) + 1);
+}
+
+/* strlcat with size 0, dst not 0-terminated  */
+static void test_strlcat_0(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, 0);
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(tst, dst_str);
+	assert_int_equal(tst[sizeof(dst_str)], FILL);
+}
+
+/* strlcat with length 1, dst not 0-terminated */
+static void test_strlcat_1(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, 1);
+	assert_int_equal(rc, 1 + strlen(src_str));
+	assert_string_equal(tst, dst_str);
+	assert_int_equal(tst[sizeof(dst_str)], FILL);
+}
+
+/* strlcat with length = dst - 1 */
+static void test_strlcat_2(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, strlen(dst_str));
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_string_equal(tst, dst_str);
+	assert_int_equal(tst[sizeof(dst_str)], FILL);
+}
+
+/* strlcat with length = dst */
+static void test_strlcat_3(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, strlen(dst_str) + 1);
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_string_equal(tst, dst_str);
+	assert_int_equal(tst[sizeof(dst_str)], FILL);
+}
+
+/* strlcat with len = dst + 1 */
+static void test_strlcat_4(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, strlen(dst_str) + 2);
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_false(strncmp(tst, dst_str, strlen(dst_str)));
+	assert_int_equal(tst[strlen(dst_str)], src_str[0]);
+	assert_int_equal(tst[strlen(dst_str) + 1], '\0');
+	assert_int_equal(tst[strlen(dst_str) + 2], FILL);
+}
+
+/* strlcat with len = needed - 1 */
+static void test_strlcat_5(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, strlen(dst_str) + strlen(src_str));
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_false(strncmp(tst, dst_str, strlen(dst_str)));
+	assert_false(strncmp(tst + strlen(dst_str), src_str,
+			     strlen(src_str) - 1));
+	assert_int_equal(tst[strlen(dst_str) + strlen(src_str) - 1], '\0');
+	assert_int_equal(tst[strlen(dst_str) + strlen(src_str)], FILL);
+}
+
+/* strlcat with exactly sufficient space */
+static void test_strlcat_6(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, strlen(dst_str) + strlen(src_str) + 1);
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_false(strncmp(tst, dst_str, strlen(dst_str)));
+	assert_string_equal(tst + strlen(dst_str), src_str);
+	assert_int_equal(tst[strlen(dst_str) + strlen(src_str) + 1], FILL);
+}
+
+/* strlcat with sufficient space */
+static void test_strlcat_7(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, src_str, sizeof(tst));
+	assert_int_equal(rc, strlen(src_str) + strlen(dst_str));
+	assert_false(strncmp(tst, dst_str, strlen(dst_str)));
+	assert_string_equal(tst + strlen(dst_str), src_str);
+}
+
+/* strlcat with 0-length string */
+static void test_strlcat_8(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), dst_str);
+	rc = strlcat(tst, "", sizeof(tst));
+	assert_int_equal(rc, strlen(dst_str));
+	assert_string_equal(tst, dst_str);
+	assert_int_equal(tst[sizeof(dst_str)], FILL);
+}
+
+/* strlcat with empty dst */
+static void test_strlcat_9(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), "");
+	rc = strlcat(tst, src_str, ARRSZ);
+	assert_int_equal(rc, strlen(src_str));
+	assert_string_equal(tst, src_str);
+	assert_int_equal(tst[sizeof(src_str)], FILL);
+}
+
+/* strlcat with empty dst and src */
+static void test_strlcat_10(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), "");
+	rc = strlcat(tst, "", ARRSZ);
+	assert_int_equal(rc, 0);
+	assert_string_equal(tst, "");
+	assert_int_equal(tst[1], FILL);
+}
+
+/* strlcat with no space to store 0 */
+static void test_strlcat_11(void **state)
+{
+	char tst[ARRSZ];
+	int rc;
+
+	prep_buf(tst, sizeof(tst), "");
+	tst[0] = FILL;
+	rc = strlcat(tst, src_str, 0);
+	assert_int_equal(rc, strlen(src_str));
+	assert_int_equal(tst[0], FILL);
+}
+
+static int test_strlcat(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_strlcat_0),
+		cmocka_unit_test(test_strlcat_1),
+		cmocka_unit_test(test_strlcat_2),
+		cmocka_unit_test(test_strlcat_3),
+		cmocka_unit_test(test_strlcat_4),
+		cmocka_unit_test(test_strlcat_5),
+		cmocka_unit_test(test_strlcat_6),
+		cmocka_unit_test(test_strlcat_7),
+		cmocka_unit_test(test_strlcat_8),
+		cmocka_unit_test(test_strlcat_9),
+		cmocka_unit_test(test_strlcat_10),
+		cmocka_unit_test(test_strlcat_11),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 static void test_strchop_nochop(void **state)
 {
 	char hello[] = "hello";
@@ -688,6 +885,7 @@ int main(void)
 	ret += test_basenamecpy();
 	ret += test_bitmasks();
 	ret += test_strlcpy();
+	ret += test_strlcat();
 	ret += test_strchop();
 	return ret;
 }
-- 
2.26.2
