From: mwilck@suse.com
Subject: [PATCH 04/35] multipath tools tests: add strchop() test
Date: Thu,  9 Jul 2020 12:15:49 +0200
Message-ID: <20200709101620.6786-5-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tests/util.c b/tests/util.c
index 48de384..6d12fda 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -408,6 +408,68 @@ static int test_strlcpy(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static void test_strchop_nochop(void **state)
+{
+	char hello[] = "hello";
+
+	assert_int_equal(strchop(hello), 5);
+	assert_string_equal(hello, "hello");
+}
+
+static void test_strchop_newline(void **state)
+{
+	char hello[] = "hello\n";
+
+	assert_int_equal(strchop(hello), 5);
+	assert_string_equal(hello, "hello");
+}
+
+static void test_strchop_space(void **state)
+{
+	char hello[] = " ello      ";
+
+	assert_int_equal(strchop(hello), 5);
+	assert_string_equal(hello, " ello");
+}
+
+static void test_strchop_mix(void **state)
+{
+	char hello[] = " el\no \t  \n\n \t    \n";
+
+	assert_int_equal(strchop(hello), 5);
+	assert_string_equal(hello, " el\no");
+}
+
+static void test_strchop_blank(void **state)
+{
+	char hello[] = "  \t  \n\n \t    \n";
+
+	assert_int_equal(strchop(hello), 0);
+	assert_string_equal(hello, "");
+}
+
+static void test_strchop_empty(void **state)
+{
+	char hello[] = "";
+
+	assert_int_equal(strchop(hello), 0);
+	assert_string_equal(hello, "");
+}
+
+static int test_strchop(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_strchop_nochop),
+		cmocka_unit_test(test_strchop_newline),
+		cmocka_unit_test(test_strchop_space),
+		cmocka_unit_test(test_strchop_mix),
+		cmocka_unit_test(test_strchop_blank),
+		cmocka_unit_test(test_strchop_empty),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 int main(void)
 {
 	int ret = 0;
@@ -415,5 +477,6 @@ int main(void)
 	ret += test_basenamecpy();
 	ret += test_bitmasks();
 	ret += test_strlcpy();
+	ret += test_strchop();
 	return ret;
 }
-- 
2.26.2
