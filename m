From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/3] libmultipath: fix parser issue with
	comments in strings
Date: Tue,  9 Jun 2020 16:35:28 -0500
Message-ID: <1591738529-26810-3-git-send-email-bmarzins@redhat.com>
References: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If a quoted string starts with '#' or '!', the parser will stop
parsing the line, thinking that it's a comment.  It should only
be checking for comments outside of quoted strings. Fixed this and
added unit tests to verify it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c |  4 +++-
 tests/parser.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index d478b177..11a6168c 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -300,8 +300,10 @@ alloc_strvec(char *string)
 			(isspace((int) *cp) || !isascii((int) *cp)))
 		       && *cp != '\0')
 			cp++;
-		if (*cp == '\0' || *cp == '!' || *cp == '#')
+		if (*cp == '\0' ||
+		    (!in_string && (*cp == '!' || *cp == '#'))) {
 			return strvec;
+		}
 	}
 out:
 	vector_free(strvec);
diff --git a/tests/parser.c b/tests/parser.c
index 29859dac..5772391e 100644
--- a/tests/parser.c
+++ b/tests/parser.c
@@ -440,6 +440,46 @@ static void test18(void **state)
 	free_strvec(v);
 }
 
+static void test19(void **state)
+{
+#define QUOTED19 "!value"
+	vector v = alloc_strvec("key \"" QUOTED19 "\"");
+	char *val;
+
+	assert_int_equal(VECTOR_SIZE(v), 4);
+	assert_string_equal(VECTOR_SLOT(v, 0), "key");
+	assert_true(is_quote(VECTOR_SLOT(v, 1)));
+	assert_string_equal(VECTOR_SLOT(v, 2), QUOTED19);
+	assert_true(is_quote(VECTOR_SLOT(v, 3)));
+	assert_int_equal(validate_config_strvec(v, test_file), 0);
+
+	val = set_value(v);
+	assert_string_equal(val, QUOTED19);
+
+	free(val);
+	free_strvec(v);
+}
+
+static void test20(void **state)
+{
+#define QUOTED20 "#value"
+	vector v = alloc_strvec("key \"" QUOTED20 "\"");
+	char *val;
+
+	assert_int_equal(VECTOR_SIZE(v), 4);
+	assert_string_equal(VECTOR_SLOT(v, 0), "key");
+	assert_true(is_quote(VECTOR_SLOT(v, 1)));
+	assert_string_equal(VECTOR_SLOT(v, 2), QUOTED20);
+	assert_true(is_quote(VECTOR_SLOT(v, 3)));
+	assert_int_equal(validate_config_strvec(v, test_file), 0);
+
+	val = set_value(v);
+	assert_string_equal(val, QUOTED20);
+
+	free(val);
+	free_strvec(v);
+}
+
 int test_config_parser(void)
 {
 	const struct CMUnitTest tests[] = {
@@ -461,6 +501,8 @@ int test_config_parser(void)
 		cmocka_unit_test(test16),
 		cmocka_unit_test(test17),
 		cmocka_unit_test(test18),
+		cmocka_unit_test(test19),
+		cmocka_unit_test(test20),
 	};
 	return cmocka_run_group_tests(tests, setup, teardown);
 }
-- 
2.17.2
