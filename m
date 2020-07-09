From: mwilck@suse.com
Subject: [PATCH 08/35] libmultipath: create bitfield abstraction
Date: Thu,  9 Jul 2020 12:15:53 +0200
Message-ID: <20200709101620.6786-9-mwilck@suse.com>
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

In e32d521d ("libmultipath: coalesce_paths: fix size mismatch handling"),
we introduced simple bitmap handling functions. We can do better. This
patch introduces a bitfield type with overflow detection and a
find_first_set() method.

Use this in coalesce_paths(), and adapt the unit tests. Also, add
unit tests for "odd" bitfield sizes; so far we tested only multiples
of 64.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |   9 +-
 libmultipath/util.c      |  35 ++++++
 libmultipath/util.h      |  57 ++++++++-
 tests/util.c             | 263 +++++++++++++++++++++++++++++++++++----
 4 files changed, 327 insertions(+), 37 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 96c7961..fe590f4 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1092,7 +1092,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 	vector pathvec = vecs->pathvec;
 	struct config *conf;
 	int allow_queueing;
-	uint64_t *size_mismatch_seen;
+	struct bitfield *size_mismatch_seen;
 
 	/* ignore refwwid if it's empty */
 	if (refwwid && !strlen(refwwid))
@@ -1106,8 +1106,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 	if (VECTOR_SIZE(pathvec) == 0)
 		return CP_OK;
-	size_mismatch_seen = calloc((VECTOR_SIZE(pathvec) - 1) / 64 + 1,
-				    sizeof(uint64_t));
+	size_mismatch_seen = alloc_bitfield(VECTOR_SIZE(pathvec));
 	if (size_mismatch_seen == NULL)
 		return CP_FAIL;
 
@@ -1131,7 +1130,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		}
 
 		/* 2. if path already coalesced, or seen and discarded */
-		if (pp1->mpp || is_bit_set_in_array(k, size_mismatch_seen))
+		if (pp1->mpp || is_bit_set_in_bitfield(k, size_mismatch_seen))
 			continue;
 
 		/* 3. if path has disappeared */
@@ -1183,7 +1182,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 					"Discard", pp2->dev, pp2->size,
 					mpp->size);
 				mpp->action = ACT_REJECT;
-				set_bit_in_array(i, size_mismatch_seen);
+				set_bit_in_bitfield(i, size_mismatch_seen);
 			}
 		}
 		verify_paths(mpp, vecs);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 3c43f28..46cacd4 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -404,3 +404,38 @@ void close_fd(void *arg)
 {
 	close((long)arg);
 }
+
+struct bitfield *alloc_bitfield(unsigned int maxbit)
+{
+	unsigned int n;
+	struct bitfield *bf;
+
+	n = maxbit > 0 ? (maxbit - 1) / bits_per_slot + 1 : 0;
+	bf = calloc(1, sizeof(struct bitfield) + n * sizeof(bitfield_t));
+	bf->len = maxbit;
+	return bf;
+}
+
+void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len)
+{
+	condlog(0, "%s: bitfield overflow: %u >= %u", f, bit, len);
+}
+
+unsigned int find_first_set(const struct bitfield *bf)
+{
+	unsigned int b = 0, i, n;
+
+	for (i = 0; i < bf->len; i+= bits_per_slot) {
+		b = _ffs(bf->bits[i / bits_per_slot]);
+		if (b != 0)
+			break;
+	};
+	if (b == 0)
+		return 0;
+
+	n = i + b;
+	if (n <= bf->len)
+		return n;
+
+	return 0;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index df75c4f..ec6de6d 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -1,6 +1,9 @@
 #ifndef _UTIL_H
 #define _UTIL_H
 
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
 #include <sys/types.h>
 /* for rlim_t */
 #include <sys/resource.h>
@@ -51,19 +54,61 @@ struct scandir_result {
 };
 void free_scandir_result(struct scandir_result *);
 
-static inline bool is_bit_set_in_array(unsigned int bit, const uint64_t *arr)
+/*
+ * ffsll() is also available on glibc < 2.27 if _GNU_SOURCE is defined.
+ * But relying on that would require that every program using this header file
+ * set _GNU_SOURCE during compilation, because otherwise the library and the
+ * program would use different types for bitfield_t, causing errors.
+ * That's too error prone, so if in doubt, use ffs().
+ */
+#if __GLIBC_PREREQ(2, 27)
+typedef unsigned long long int bitfield_t;
+#define _ffs(x) ffsll(x)
+#else
+typedef unsigned int bitfield_t;
+#define _ffs(x) ffs(x)
+#endif
+#define bits_per_slot (sizeof(bitfield_t) * CHAR_BIT)
+
+struct bitfield {
+	unsigned int len;
+	bitfield_t bits[];
+};
+
+struct bitfield *alloc_bitfield(unsigned int maxbit);
+
+void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len);
+#define log_bitfield_overflow(bit, len) \
+	_log_bitfield_overflow(__func__, bit, len)
+
+static inline bool is_bit_set_in_bitfield(unsigned int bit,
+				       const struct bitfield *bf)
 {
-	return arr[bit / 64] & (1ULL << (bit % 64)) ? 1 : 0;
+	if (bit >= bf->len) {
+		log_bitfield_overflow(bit, bf->len);
+		return false;
+	}
+	return !!(bf->bits[bit / bits_per_slot] &
+		  (1ULL << (bit % bits_per_slot)));
 }
 
-static inline void set_bit_in_array(unsigned int bit, uint64_t *arr)
+static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 {
-	arr[bit / 64] |= (1ULL << (bit % 64));
+	if (bit >= bf->len) {
+		log_bitfield_overflow(bit, bf->len);
+		return;
+	}
+	bf->bits[bit / bits_per_slot] |= (1ULL << (bit % bits_per_slot));
 }
 
-static inline void clear_bit_in_array(unsigned int bit, uint64_t *arr)
+static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 {
-	arr[bit / 64] &= ~(1ULL << (bit % 64));
+	if (bit >= bf->len) {
+		log_bitfield_overflow(bit, bf->len);
+		return;
+	}
+	bf->bits[bit / bits_per_slot] &= ~(1ULL << (bit % bits_per_slot));
 }
 
+unsigned int find_first_set(const struct bitfield *bf);
 #endif /* _UTIL_H */
diff --git a/tests/util.c b/tests/util.c
index 6d12fda..db7c05f 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -164,19 +164,25 @@ static int test_basenamecpy(void)
 
 static void test_bitmask_1(void **state)
 {
-	uint64_t arr[BITARR_SZ];
+	struct bitfield *bf;
+	uint64_t *arr;
 	int i, j, k, m, b;
 
-	memset(arr, 0, sizeof(arr));
+	bf = alloc_bitfield(BITARR_SZ * 64);
+	assert_non_null(bf);
+	assert_int_equal(bf->len, BITARR_SZ * 64);
+	arr = (uint64_t *)bf->bits;
 
 	for (j = 0; j < BITARR_SZ; j++) {
 		for (i = 0; i < 64; i++) {
 			b = 64 * j + i;
-			assert(!is_bit_set_in_array(b, arr));
-			set_bit_in_array(b, arr);
+			assert(!is_bit_set_in_bitfield(b, bf));
+			set_bit_in_bitfield(b, bf);
 			for (k = 0; k < BITARR_SZ; k++) {
+#if 0
 				printf("b = %d j = %d k = %d a = %"PRIx64"\n",
 				       b, j, k, arr[k]);
+#endif
 				if (k == j)
 					assert_int_equal(arr[j], 1ULL << i);
 				else
@@ -184,39 +190,46 @@ static void test_bitmask_1(void **state)
 			}
 			for (m = 0; m < 64; m++)
 				if (i == m)
-					assert(is_bit_set_in_array(64 * j + m,
-								   arr));
+					assert(is_bit_set_in_bitfield(64 * j + m,
+								      bf));
 				else
-					assert(!is_bit_set_in_array(64 * j + m,
-								    arr));
-			clear_bit_in_array(b, arr);
-			assert(!is_bit_set_in_array(b, arr));
+					assert(!is_bit_set_in_bitfield(64 * j + m,
+								       bf));
+			assert_int_equal(find_first_set(bf), b + 1);
+			clear_bit_in_bitfield(b, bf);
+			assert(!is_bit_set_in_bitfield(b, bf));
 			for (k = 0; k < BITARR_SZ; k++)
 				assert_int_equal(arr[k], 0ULL);
 		}
 	}
+	free(bf);
 }
 
 static void test_bitmask_2(void **state)
 {
-	uint64_t arr[BITARR_SZ];
+	struct bitfield *bf;
+	uint64_t *arr;
 	int i, j, k, m, b;
 
-	memset(arr, 0, sizeof(arr));
+	bf = alloc_bitfield(BITARR_SZ * 64);
+	assert_non_null(bf);
+	assert_int_equal(bf->len, BITARR_SZ * 64);
+	arr = (uint64_t *)bf->bits;
 
 	for (j = 0; j < BITARR_SZ; j++) {
 		for (i = 0; i < 64; i++) {
 			b = 64 * j + i;
-			assert(!is_bit_set_in_array(b, arr));
-			set_bit_in_array(b, arr);
+			assert(!is_bit_set_in_bitfield(b, bf));
+			set_bit_in_bitfield(b, bf);
 			for (m = 0; m < 64; m++)
 				if (m <= i)
-					assert(is_bit_set_in_array(64 * j + m,
-								   arr));
+					assert(is_bit_set_in_bitfield(64 * j + m,
+								      bf));
 				else
-					assert(!is_bit_set_in_array(64 * j + m,
-								    arr));
-			assert(is_bit_set_in_array(b, arr));
+					assert(!is_bit_set_in_bitfield(64 * j + m,
+								       bf));
+			assert(is_bit_set_in_bitfield(b, bf));
+			assert_int_equal(find_first_set(bf), 1);
 			for (k = 0; k < BITARR_SZ; k++) {
 				if (k < j || (k == j && i == 63))
 					assert_int_equal(arr[k], ~0ULL);
@@ -232,16 +245,20 @@ static void test_bitmask_2(void **state)
 	for (j = 0; j < BITARR_SZ; j++) {
 		for (i = 0; i < 64; i++) {
 			b = 64 * j + i;
-			assert(is_bit_set_in_array(b, arr));
-			clear_bit_in_array(b, arr);
+			assert(is_bit_set_in_bitfield(b, bf));
+			clear_bit_in_bitfield(b, bf);
 			for (m = 0; m < 64; m++)
 				if (m <= i)
-					assert(!is_bit_set_in_array(64 * j + m,
-								    arr));
+					assert(!is_bit_set_in_bitfield(64 * j + m,
+								       bf));
 				else
-					assert(is_bit_set_in_array(64 * j + m,
-								   arr));
-			assert(!is_bit_set_in_array(b, arr));
+					assert(is_bit_set_in_bitfield(64 * j + m,
+								      bf));
+			assert(!is_bit_set_in_bitfield(b, bf));
+			if (b == 64 * BITARR_SZ - 1)
+				assert_int_equal(find_first_set(bf), 0);
+			else
+				assert_int_equal(find_first_set(bf), b + 2);
 			for (k = 0; k < BITARR_SZ; k++) {
 				if (k < j || (k == j && i == 63))
 					assert_int_equal(arr[k], 0ULL);
@@ -254,13 +271,207 @@ static void test_bitmask_2(void **state)
 			}
 		}
 	}
+	free(bf);
 }
 
+/*
+ *  Test operations on a 0-length bitfield
+ */
+static void test_bitmask_len_0(void **state)
+{
+	struct bitfield *bf;
+
+	bf = alloc_bitfield(0);
+	assert_non_null(bf);
+	assert_int_equal(bf->len, 0);
+	assert_int_equal(is_bit_set_in_bitfield(0, bf), 0);
+	assert_int_equal(is_bit_set_in_bitfield(1, bf), 0);
+	assert_int_equal(find_first_set(bf), 0);
+	set_bit_in_bitfield(0, bf);
+	assert_int_equal(is_bit_set_in_bitfield(0, bf), 0);
+	assert_int_equal(find_first_set(bf), 0);
+	clear_bit_in_bitfield(0, bf);
+	assert_int_equal(is_bit_set_in_bitfield(0, bf), 0);
+	set_bit_in_bitfield(11, bf);
+	assert_int_equal(find_first_set(bf), 0);
+	assert_int_equal(is_bit_set_in_bitfield(11, bf), 0);
+	clear_bit_in_bitfield(11, bf);
+	assert_int_equal(is_bit_set_in_bitfield(11, bf), 0);
+	free(bf);
+}
+
+static void _test_bitmask_small(unsigned int n)
+{
+	struct bitfield *bf;
+	uint64_t *arr;
+
+	assert(n <= 64);
+	assert(n >= 1);
+
+	bf = alloc_bitfield(n);
+	assert_non_null(bf);
+	assert_int_equal(bf->len, n);
+	arr = (uint64_t *)bf->bits;
+
+	assert_int_equal(*arr, 0);
+
+	set_bit_in_bitfield(n + 1, bf);
+	assert_int_equal(*arr, 0);
+	assert_int_equal(find_first_set(bf), 0);
+
+	set_bit_in_bitfield(n, bf);
+	assert_int_equal(*arr, 0);
+	assert_int_equal(find_first_set(bf), 0);
+
+	set_bit_in_bitfield(n - 1, bf);
+	assert_int_equal(*arr, 1ULL << (n - 1));
+	assert_int_equal(find_first_set(bf), n);
+
+	clear_bit_in_bitfield(n - 1, bf);
+	assert_int_equal(*arr, 0);
+	assert_int_equal(find_first_set(bf), 0);
+
+	set_bit_in_bitfield(0, bf);
+	assert_int_equal(*arr, 1);
+	assert_int_equal(find_first_set(bf), 1);
+
+	free(bf);
+}
+
+static void _test_bitmask_small_2(unsigned int n)
+{
+	struct bitfield *bf;
+	uint64_t *arr;
+
+	assert(n <= 128);
+	assert(n >= 65);
+
+	bf = alloc_bitfield(n);
+	assert_non_null(bf);
+	assert_int_equal(bf->len, n);
+	arr = (uint64_t *)bf->bits;
+
+	assert_int_equal(arr[0], 0);
+	assert_int_equal(arr[1], 0);
+
+	set_bit_in_bitfield(n + 1, bf);
+	assert_int_equal(arr[0], 0);
+	assert_int_equal(arr[1], 0);
+	assert_int_equal(find_first_set(bf), 0);
+
+	set_bit_in_bitfield(n, bf);
+	assert_int_equal(arr[0], 0);
+	assert_int_equal(arr[1], 0);
+	assert_int_equal(find_first_set(bf), 0);
+
+	set_bit_in_bitfield(n - 1, bf);
+	assert_int_equal(arr[0], 0);
+	assert_int_equal(arr[1], 1ULL << (n - 65));
+	assert_int_equal(find_first_set(bf), n);
+
+	set_bit_in_bitfield(0, bf);
+	assert_int_equal(arr[0], 1);
+	assert_int_equal(arr[1], 1ULL << (n - 65));
+	assert_int_equal(find_first_set(bf), 1);
+
+	set_bit_in_bitfield(64, bf);
+	assert_int_equal(arr[0], 1);
+	assert_int_equal(arr[1], (1ULL << (n - 65)) | 1);
+	assert_int_equal(find_first_set(bf), 1);
+
+	clear_bit_in_bitfield(0, bf);
+	assert_int_equal(arr[0], 0);
+	assert_int_equal(arr[1], (1ULL << (n - 65)) | 1);
+	assert_int_equal(find_first_set(bf), 65);
+
+	free(bf);
+}
+
+static void test_bitmask_len_1(void **state)
+{
+	_test_bitmask_small(1);
+}
+
+static void test_bitmask_len_2(void **state)
+{
+	_test_bitmask_small(2);
+}
+
+static void test_bitmask_len_3(void **state)
+{
+	_test_bitmask_small(3);
+}
+
+static void test_bitmask_len_23(void **state)
+{
+	_test_bitmask_small(23);
+}
+
+static void test_bitmask_len_63(void **state)
+{
+	_test_bitmask_small(63);
+}
+
+static void test_bitmask_len_64(void **state)
+{
+	_test_bitmask_small(63);
+}
+
+static void test_bitmask_len_65(void **state)
+{
+	_test_bitmask_small_2(65);
+}
+
+static void test_bitmask_len_66(void **state)
+{
+	_test_bitmask_small_2(66);
+}
+
+static void test_bitmask_len_67(void **state)
+{
+	_test_bitmask_small_2(67);
+}
+
+static void test_bitmask_len_103(void **state)
+{
+	_test_bitmask_small_2(103);
+}
+
+static void test_bitmask_len_126(void **state)
+{
+	_test_bitmask_small_2(126);
+}
+
+static void test_bitmask_len_127(void **state)
+{
+	_test_bitmask_small_2(127);
+}
+
+static void test_bitmask_len_128(void **state)
+{
+	_test_bitmask_small_2(128);
+}
+
+
 static int test_bitmasks(void)
 {
 	const struct CMUnitTest tests[] = {
 		cmocka_unit_test(test_bitmask_1),
 		cmocka_unit_test(test_bitmask_2),
+		cmocka_unit_test(test_bitmask_len_0),
+		cmocka_unit_test(test_bitmask_len_1),
+		cmocka_unit_test(test_bitmask_len_2),
+		cmocka_unit_test(test_bitmask_len_3),
+		cmocka_unit_test(test_bitmask_len_23),
+		cmocka_unit_test(test_bitmask_len_63),
+		cmocka_unit_test(test_bitmask_len_64),
+		cmocka_unit_test(test_bitmask_len_65),
+		cmocka_unit_test(test_bitmask_len_66),
+		cmocka_unit_test(test_bitmask_len_67),
+		cmocka_unit_test(test_bitmask_len_103),
+		cmocka_unit_test(test_bitmask_len_126),
+		cmocka_unit_test(test_bitmask_len_127),
+		cmocka_unit_test(test_bitmask_len_128),
 	};
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
-- 
2.26.2
