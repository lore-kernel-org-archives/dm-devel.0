From: mwilck@suse.com
Subject: [PATCH 1/3] multipath-tools tests: fix bitfield tests
	for small fields
Date: Sat, 22 Aug 2020 00:42:22 +0200
Message-ID: <20200821224224.13536-2-mwilck@suse.com>
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

The bitmask tests may fail if sizeof(bitfield_t) is 32, depending
on compiler options and other circumstances.
This is because allocation of the bitfield with calloc() only zeroes
out the actual length of the bitfield rounded to 32, and thus
the assertion *((uint64_t *)bf->bits) == 0 may fail.

Use uint32_t in the tests instead of uint64_t.

Fixes: "libmultipath: create bitfield abstraction"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 104 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 81 insertions(+), 23 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index 16774df..63a5f59 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -282,32 +282,48 @@ static void test_bitmask_len_0(void **state)
 static void _test_bitmask_small(unsigned int n)
 {
 	struct bitfield *bf;
-	uint64_t *arr;
+	uint32_t *arr;
+	unsigned int size = (n - 1) / 32 + 1, i;
 
+	assert(sizeof(bitfield_t) == 4 || sizeof(bitfield_t) == 8);
 	assert(n <= 64);
 	assert(n >= 1);
 
 	bf = alloc_bitfield(n);
 	assert_non_null(bf);
 	assert_int_equal(bf->len, n);
-	arr = (uint64_t *)bf->bits;
+	arr = (uint32_t *)bf->bits;
 
-	assert_int_equal(*arr, 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n + 1, bf);
-	assert_int_equal(*arr, 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n, bf);
-	assert_int_equal(*arr, 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n - 1, bf);
-	assert_int_equal(*arr, 1ULL << (n - 1));
+	for (i = 0; i < size; i++) {
+		unsigned int k = (n - 1) / 32;
+		unsigned int j = (n - 1) - k * 32;
+
+		if (i == k)
+			assert_int_equal(arr[i], 1UL << j);
+		else
+			assert_int_equal(arr[i], 0);
+	}
 
 	clear_bit_in_bitfield(n - 1, bf);
-	assert_int_equal(*arr, 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(0, bf);
-	assert_int_equal(*arr, 1);
+	assert_int_equal(arr[0], 1);
+	for (i = 1; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	free(bf);
 }
@@ -315,7 +331,8 @@ static void _test_bitmask_small(unsigned int n)
 static void _test_bitmask_small_2(unsigned int n)
 {
 	struct bitfield *bf;
-	uint64_t *arr;
+	uint32_t *arr;
+	unsigned int size = (n - 1) / 32 + 1, i;
 
 	assert(n <= 128);
 	assert(n >= 65);
@@ -323,34 +340,75 @@ static void _test_bitmask_small_2(unsigned int n)
 	bf = alloc_bitfield(n);
 	assert_non_null(bf);
 	assert_int_equal(bf->len, n);
-	arr = (uint64_t *)bf->bits;
+	arr = (uint32_t *)bf->bits;
 
-	assert_int_equal(arr[0], 0);
-	assert_int_equal(arr[1], 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n + 1, bf);
-	assert_int_equal(arr[0], 0);
-	assert_int_equal(arr[1], 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n, bf);
-	assert_int_equal(arr[0], 0);
-	assert_int_equal(arr[1], 0);
+	for (i = 0; i < size; i++)
+		assert_int_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n - 1, bf);
 	assert_int_equal(arr[0], 0);
-	assert_int_equal(arr[1], 1ULL << (n - 65));
+	for (i = 0; i < size; i++) {
+		unsigned int k = (n - 1) / 32;
+		unsigned int j = (n - 1) - k * 32;
+
+		if (i == k)
+			assert_int_equal(arr[i], 1UL << j);
+		else
+			assert_int_equal(arr[i], 0);
+	}
 
 	set_bit_in_bitfield(0, bf);
-	assert_int_equal(arr[0], 1);
-	assert_int_equal(arr[1], 1ULL << (n - 65));
+	for (i = 0; i < size; i++) {
+		unsigned int k = (n - 1) / 32;
+		unsigned int j = (n - 1) - k * 32;
+
+		if (i == k && k == 0)
+			assert_int_equal(arr[i], (1UL << j) | 1);
+		else if (i == k)
+			assert_int_equal(arr[i], 1UL << j);
+		else if (i == 0)
+			assert_int_equal(arr[i], 1);
+		else
+			assert_int_equal(arr[i], 0);
+	}
 
 	set_bit_in_bitfield(64, bf);
-	assert_int_equal(arr[0], 1);
-	assert_int_equal(arr[1], (1ULL << (n - 65)) | 1);
+	for (i = 0; i < size; i++) {
+		unsigned int k = (n - 1) / 32;
+		unsigned int j = (n - 1) - k * 32;
+
+		if (i == k && (k == 0 || k == 2))
+			assert_int_equal(arr[i], (1UL << j) | 1);
+		else if (i == k)
+			assert_int_equal(arr[i], 1UL << j);
+		else if (i == 2 || i == 0)
+			assert_int_equal(arr[i], 1);
+		else
+			assert_int_equal(arr[i], 0);
+	}
 
 	clear_bit_in_bitfield(0, bf);
-	assert_int_equal(arr[0], 0);
-	assert_int_equal(arr[1], (1ULL << (n - 65)) | 1);
+	for (i = 0; i < size; i++) {
+		unsigned int k = (n - 1) / 32;
+		unsigned int j = (n - 1) - k * 32;
+
+		if (i == k && k == 2)
+			assert_int_equal(arr[i], (1UL << j) | 1);
+		else if (i == k)
+			assert_int_equal(arr[i], 1UL << j);
+		else if (i == 2)
+			assert_int_equal(arr[i], 1);
+		else
+			assert_int_equal(arr[i], 0);
+	}
 
 	free(bf);
 }
-- 
2.28.0
