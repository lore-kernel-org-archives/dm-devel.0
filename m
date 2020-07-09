From: mwilck@suse.com
Subject: [PATCH 01/35] multipath-tools tests/util: separate group
	for bitmask tests
Date: Thu,  9 Jul 2020 12:15:46 +0200
Message-ID: <20200709101620.6786-2-mwilck@suse.com>
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

Separate these more cleanly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index 7c486fc..48de384 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -141,6 +141,27 @@ static void test_basenamecpy_bad5(void **state)
         assert_int_equal(basenamecpy("baz/qux", NULL, sizeof(dst)), 0);
 }
 
+static int test_basenamecpy(void)
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
 static void test_bitmask_1(void **state)
 {
 	uint64_t arr[BITARR_SZ];
@@ -235,23 +256,9 @@ static void test_bitmask_2(void **state)
 	}
 }
 
-int test_basenamecpy(void)
+static int test_bitmasks(void)
 {
 	const struct CMUnitTest tests[] = {
-		cmocka_unit_test(test_basenamecpy_good0),
-		cmocka_unit_test(test_basenamecpy_good1),
-		cmocka_unit_test(test_basenamecpy_good2),
-		cmocka_unit_test(test_basenamecpy_good3),
-		cmocka_unit_test(test_basenamecpy_good4),
-		cmocka_unit_test(test_basenamecpy_good5),
-		cmocka_unit_test(test_basenamecpy_good6),
-		cmocka_unit_test(test_basenamecpy_good7),
-		cmocka_unit_test(test_basenamecpy_bad0),
-		cmocka_unit_test(test_basenamecpy_bad1),
-		cmocka_unit_test(test_basenamecpy_bad2),
-		cmocka_unit_test(test_basenamecpy_bad3),
-		cmocka_unit_test(test_basenamecpy_bad4),
-		cmocka_unit_test(test_basenamecpy_bad5),
 		cmocka_unit_test(test_bitmask_1),
 		cmocka_unit_test(test_bitmask_2),
 	};
@@ -406,6 +413,7 @@ int main(void)
 	int ret = 0;
 
 	ret += test_basenamecpy();
+	ret += test_bitmasks();
 	ret += test_strlcpy();
 	return ret;
 }
-- 
2.26.2
