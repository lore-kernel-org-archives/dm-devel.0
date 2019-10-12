From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 70/72] multipath tests: Makefile: avoid gcc 4.8
 missing initializers failure
Date: Sat, 12 Oct 2019 21:29:04 +0000
Message-ID: <20191012212703.12989-71-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

With -Wmissing-field-initializers (implied by our current compiler flags),
gcc 4.8 errors out if nested initializers are missing:

struct A {
       int a, b;
};

struct B {
       struct A a;
       int c;
} b = { .a.a = 1; }

Later gcc versions and clang accept it just fine.
Add a test to tests/Makefile and use -Wno-missing-initializers if gcc 4.8
behavior is detected.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index c70b8399..c9406e75 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -1,6 +1,15 @@
 include ../Makefile.inc
 
-CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) -Wno-unused-parameter
+# Test special behavior of gcc 4.8 with nested initializers
+# gcc 4.8 compiles blacklist.c only with -Wno-missing-field-initializers
+TEST_MISSING_INITIALIZERS = $(shell \
+	echo 'struct A {int a, b;}; struct B {struct A a; int b;} b = {.a.a=1};' | \
+		$(CC) -c -Werror -Wmissing-field-initializers -o /dev/null -xc - >/dev/null 2>&1 \
+	|| echo -Wno-missing-field-initializers)
+W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
+
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
+	-Wno-unused-parameter $(W_MISSING_INITIALIZERS)
 LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy alias
-- 
2.23.0
