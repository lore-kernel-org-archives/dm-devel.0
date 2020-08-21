From: mwilck@suse.com
Subject: [PATCH 3/3] multipath-tools tests: fix small bitfield
	tests for big endian
Date: Sat, 22 Aug 2020 00:42:24 +0200
Message-ID: <20200821224224.13536-4-mwilck@suse.com>
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

This is the opposite case of the previous patch: 64 bit bitfield_t,
tested with 32 bit words.

Fixes: "libmultipath: create bitfield abstraction"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 60 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index ec38c55..21311b2 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -22,6 +22,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
+#include <endian.h>
 #include "util.h"
 
 #include "globals.c"
@@ -295,11 +296,25 @@ static void test_bitmask_len_0(void **state)
 	assert_null(bf);
 }
 
+/*
+ * We use uint32_t in the "small bitmask" tests below.
+ * This means that we may have to swap 32bit words if bitfield_t
+ * is 64bit wide.
+ */
+static unsigned int maybe_swap_idx(unsigned int i)
+{
+	if (BYTE_ORDER == LITTLE_ENDIAN || sizeof(bitfield_t) == 4)
+		return i;
+	else
+		/* 0<->1, 2<->3, ... */
+		return i + (i % 2 == 0 ? 1 : -1);
+}
+
 static void _test_bitmask_small(unsigned int n)
 {
 	struct bitfield *bf;
 	uint32_t *arr;
-	unsigned int size = (n - 1) / 32 + 1, i;
+	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
 	assert(sizeof(bitfield_t) == 4 || sizeof(bitfield_t) == 8);
 	assert(n <= 64);
@@ -325,11 +340,12 @@ static void _test_bitmask_small(unsigned int n)
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
+		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k)
-			assert_int_equal(arr[i], 1UL << j);
+			assert_int_equal(arr[i1], 1UL << j);
 		else
-			assert_int_equal(arr[i], 0);
+			assert_int_equal(arr[i1], 0);
 	}
 
 	clear_bit_in_bitfield(n - 1, bf);
@@ -337,9 +353,9 @@ static void _test_bitmask_small(unsigned int n)
 		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(0, bf);
-	assert_int_equal(arr[0], 1);
+	assert_int_equal(arr[maybe_swap_idx(0)], 1);
 	for (i = 1; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_int_equal(arr[maybe_swap_idx(i)], 0);
 
 	free(bf);
 }
@@ -348,7 +364,7 @@ static void _test_bitmask_small_2(unsigned int n)
 {
 	struct bitfield *bf;
 	uint32_t *arr;
-	unsigned int size = (n - 1) / 32 + 1, i;
+	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
 	assert(n <= 128);
 	assert(n >= 65);
@@ -374,56 +390,60 @@ static void _test_bitmask_small_2(unsigned int n)
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
+		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k)
-			assert_int_equal(arr[i], 1UL << j);
+			assert_int_equal(arr[i1], 1UL << j);
 		else
-			assert_int_equal(arr[i], 0);
+			assert_int_equal(arr[i1], 0);
 	}
 
 	set_bit_in_bitfield(0, bf);
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
+		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && k == 0)
-			assert_int_equal(arr[i], (1UL << j) | 1);
+			assert_int_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i], 1UL << j);
+			assert_int_equal(arr[i1], 1UL << j);
 		else if (i == 0)
-			assert_int_equal(arr[i], 1);
+			assert_int_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i], 0);
+			assert_int_equal(arr[i1], 0);
 	}
 
 	set_bit_in_bitfield(64, bf);
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
+		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && (k == 0 || k == 2))
-			assert_int_equal(arr[i], (1UL << j) | 1);
+			assert_int_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i], 1UL << j);
+			assert_int_equal(arr[i1], 1UL << j);
 		else if (i == 2 || i == 0)
-			assert_int_equal(arr[i], 1);
+			assert_int_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i], 0);
+			assert_int_equal(arr[i1], 0);
 	}
 
 	clear_bit_in_bitfield(0, bf);
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
+		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && k == 2)
-			assert_int_equal(arr[i], (1UL << j) | 1);
+			assert_int_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i], 1UL << j);
+			assert_int_equal(arr[i1], 1UL << j);
 		else if (i == 2)
-			assert_int_equal(arr[i], 1);
+			assert_int_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i], 0);
+			assert_int_equal(arr[i1], 0);
 	}
 
 	free(bf);
-- 
2.28.0
