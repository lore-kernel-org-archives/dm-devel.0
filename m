From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/19] tests: add unit tests for bitmask functions
Date: Wed, 21 Nov 2018 11:18:37 +0100
Message-ID: <20181121101839.30784-18-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Add unit tests for the bitmask management functions the previous
patch added in util.h.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tests/util.c b/tests/util.c
index 839effd2..e6d4b9ab 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -26,6 +26,8 @@
 
 #include "globals.c"
 
+#define BITARR_SZ 4
+
 static void test_basenamecpy_good0(void **state)
 {
 	char dst[10];
@@ -139,6 +141,100 @@ static void test_basenamecpy_bad5(void **state)
         assert_int_equal(basenamecpy("baz/qux", NULL, sizeof(dst)), 0);
 }
 
+static void test_bitmask_1(void **state)
+{
+	uint64_t arr[BITARR_SZ];
+	int i, j, k, m, b;
+
+	memset(arr, 0, sizeof(arr));
+
+	for (j = 0; j < BITARR_SZ; j++) {
+		for (i = 0; i < 64; i++) {
+			b = 64 * j + i;
+			assert(!is_bit_set_in_array(b, arr));
+			set_bit_in_array(b, arr);
+			for (k = 0; k < BITARR_SZ; k++) {
+				printf("b = %d j = %d k = %d a = %"PRIx64"\n",
+				       b, j, k, arr[k]);
+				if (k == j)
+					assert_int_equal(arr[j], 1ULL << i);
+				else
+					assert_int_equal(arr[k], 0ULL);
+			}
+			for (m = 0; m < 64; m++)
+				if (i == m)
+					assert(is_bit_set_in_array(64 * j + m,
+								   arr));
+				else
+					assert(!is_bit_set_in_array(64 * j + m,
+								    arr));
+			clear_bit_in_array(b, arr);
+			assert(!is_bit_set_in_array(b, arr));
+			for (k = 0; k < BITARR_SZ; k++)
+				assert_int_equal(arr[k], 0ULL);
+		}
+	}
+}
+
+static void test_bitmask_2(void **state)
+{
+	uint64_t arr[BITARR_SZ];
+	int i, j, k, m, b;
+
+	memset(arr, 0, sizeof(arr));
+
+	for (j = 0; j < BITARR_SZ; j++) {
+		for (i = 0; i < 64; i++) {
+			b = 64 * j + i;
+			assert(!is_bit_set_in_array(b, arr));
+			set_bit_in_array(b, arr);
+			for (m = 0; m < 64; m++)
+				if (m <= i)
+					assert(is_bit_set_in_array(64 * j + m,
+								   arr));
+				else
+					assert(!is_bit_set_in_array(64 * j + m,
+								    arr));
+			assert(is_bit_set_in_array(b, arr));
+			for (k = 0; k < BITARR_SZ; k++) {
+				if (k < j || (k == j && i == 63))
+					assert_int_equal(arr[k], ~0ULL);
+				else if (k > j)
+					assert_int_equal(arr[k], 0ULL);
+				else
+					assert_int_equal(
+						arr[k],
+						(1ULL << (i + 1)) - 1);
+			}
+		}
+	}
+	for (j = 0; j < BITARR_SZ; j++) {
+		for (i = 0; i < 64; i++) {
+			b = 64 * j + i;
+			assert(is_bit_set_in_array(b, arr));
+			clear_bit_in_array(b, arr);
+			for (m = 0; m < 64; m++)
+				if (m <= i)
+					assert(!is_bit_set_in_array(64 * j + m,
+								    arr));
+				else
+					assert(is_bit_set_in_array(64 * j + m,
+								   arr));
+			assert(!is_bit_set_in_array(b, arr));
+			for (k = 0; k < BITARR_SZ; k++) {
+				if (k < j || (k == j && i == 63))
+					assert_int_equal(arr[k], 0ULL);
+				else if (k > j)
+					assert_int_equal(arr[k], ~0ULL);
+				else
+					assert_int_equal(
+						arr[k],
+						~((1ULL << (i + 1)) - 1));
+			}
+		}
+	}
+}
+
 int test_basenamecpy(void)
 {
 	const struct CMUnitTest tests[] = {
@@ -156,6 +252,8 @@ int test_basenamecpy(void)
 		cmocka_unit_test(test_basenamecpy_bad3),
 		cmocka_unit_test(test_basenamecpy_bad4),
 		cmocka_unit_test(test_basenamecpy_bad5),
+		cmocka_unit_test(test_bitmask_1),
+		cmocka_unit_test(test_bitmask_2),
 	};
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
-- 
2.19.1
