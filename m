From: mwilck@suse.com
Subject: [PATCH 2/3] multipath-tools tests: fix bitfield tests
	for big endian
Date: Sat, 22 Aug 2020 00:42:23 +0200
Message-ID: <20200821224224.13536-3-mwilck@suse.com>
References: <20200821224224.13536-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821224224.13536-1-mwilck@suse.com>
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

On big endian systems, the 32bit words need to be swapped in
the test code to get the byte ordering right.

Fixes: "libmultipath: create bitfield abstraction"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index 63a5f59..ec38c55 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -162,6 +162,22 @@ static int test_basenamecpy(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+/*
+ * On big endian systems, if bitfield_t is 32bit, we need
+ * to swap the two 32 bit parts of a 64bit value to make
+ * the tests below work.
+ */
+static uint64_t maybe_swap(uint64_t v)
+{
+	uint32_t *s = (uint32_t *)&v;
+
+	if (sizeof(bitfield_t) == 4)
+		/* this is identity for little endian */
+		return ((uint64_t)s[1] << 32) | s[0];
+	else
+		return v;
+}
+
 static void test_bitmask_1(void **state)
 {
 	struct bitfield *bf;
@@ -184,7 +200,7 @@ static void test_bitmask_1(void **state)
 				       b, j, k, arr[k]);
 #endif
 				if (k == j)
-					assert_int_equal(arr[j], 1ULL << i);
+					assert_int_equal(maybe_swap(arr[j]), 1ULL << i);
 				else
 					assert_int_equal(arr[k], 0ULL);
 			}
@@ -235,7 +251,7 @@ static void test_bitmask_2(void **state)
 					assert_int_equal(arr[k], 0ULL);
 				else
 					assert_int_equal(
-						arr[k],
+						maybe_swap(arr[k]),
 						(1ULL << (i + 1)) - 1);
 			}
 		}
@@ -260,7 +276,7 @@ static void test_bitmask_2(void **state)
 					assert_int_equal(arr[k], ~0ULL);
 				else
 					assert_int_equal(
-						arr[k],
+						maybe_swap(arr[k]),
 						~((1ULL << (i + 1)) - 1));
 			}
 		}
-- 
2.28.0
