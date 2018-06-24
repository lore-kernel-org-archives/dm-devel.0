From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 05/10] multipath-tools/tests: add tests for
	get_unaligned_beXX
Date: Sun, 24 Jun 2018 21:09:39 +0200
Message-ID: <20180624190944.27158-6-mwilck@suse.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile    |  2 +-
 tests/unaligned.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 1 deletion(-)
 create mode 100644 tests/unaligned.c

diff --git a/tests/Makefile b/tests/Makefile
index 78755edd..2685a206 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -3,7 +3,7 @@ include ../Makefile.inc
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
 LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
 
-TESTS := uevent parser util dmevents hwtable
+TESTS := uevent parser util dmevents hwtable unaligned
 
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
diff --git a/tests/unaligned.c b/tests/unaligned.c
new file mode 100644
index 00000000..7ece1de8
--- /dev/null
+++ b/tests/unaligned.c
@@ -0,0 +1,96 @@
+#include <inttypes.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <cmocka.h>
+#include "unaligned.h"
+
+#define SIZE 16
+static const char memory[8] = {
+	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef
+};
+
+static const uint64_t intval64 = 0x0123456789abcdef;
+static const uint32_t intval32 = 0x01234567;
+static const uint16_t intval16 = 0x0123;
+
+#include "globals.c"
+
+static int setup(void **state)
+{
+	return posix_memalign(state, 16, 2 * SIZE);
+}
+
+static int teardown(void **state)
+{
+	free(*state);
+	return 0;
+}
+
+
+#define make_test(bits, offset) \
+	static void test_ ## bits ## _ ## offset(void **state)	\
+{								\
+	int len = bits/8;					\
+	uint8_t *c = *state;					\
+	uint8_t *p = *state + SIZE;				\
+	uint64_t u;						\
+								\
+	assert_in_range(len, 1, SIZE);				\
+	assert_in_range(offset + len, 1, SIZE);			\
+	memset(c, 0, 2 * SIZE);					\
+	memcpy(c + offset, memory, len);			\
+								\
+	u = get_unaligned_be##bits(c + offset);			\
+	assert_int_equal(u, intval##bits);			\
+	put_unaligned_be##bits(u, p + offset);			\
+	assert_memory_equal(c + offset, p  + offset, len);	\
+}
+
+make_test(16, 0);
+make_test(16, 1);
+make_test(32, 0);
+make_test(32, 1);
+make_test(32, 2);
+make_test(32, 3);
+make_test(64, 0);
+make_test(64, 1);
+make_test(64, 2);
+make_test(64, 3);
+make_test(64, 4);
+make_test(64, 5);
+make_test(64, 6);
+make_test(64, 7);
+
+int test_unaligned(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_16_0),
+		cmocka_unit_test(test_16_1),
+		cmocka_unit_test(test_32_0),
+		cmocka_unit_test(test_32_1),
+		cmocka_unit_test(test_32_2),
+		cmocka_unit_test(test_32_3),
+		cmocka_unit_test(test_64_0),
+		cmocka_unit_test(test_64_1),
+		cmocka_unit_test(test_64_2),
+		cmocka_unit_test(test_64_3),
+		cmocka_unit_test(test_64_4),
+		cmocka_unit_test(test_64_5),
+		cmocka_unit_test(test_64_6),
+		cmocka_unit_test(test_64_7),
+	};
+	return cmocka_run_group_tests(tests, setup, teardown);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	ret += test_unaligned();
+	return ret;
+}
-- 
2.17.1
