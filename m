From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/72] multipath tests: move condlog test
 wrappers to separate file
Date: Sat, 12 Oct 2019 21:27:38 +0000
Message-ID: <20191012212703.12989-2-martin.wilck@suse.com>
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

These helpers can be useful in other tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile    |  1 +
 tests/blacklist.c | 20 +-------------------
 tests/test-log.c  | 26 ++++++++++++++++++++++++++
 tests/test-log.h  |  7 +++++++
 4 files changed, 35 insertions(+), 19 deletions(-)
 create mode 100644 tests/test-log.c
 create mode 100644 tests/test-log.h

diff --git a/tests/Makefile b/tests/Makefile
index a5cdf390..fb3c067b 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -23,6 +23,7 @@ hwtable-test_TESTDEPS := test-lib.o
 hwtable-test_OBJDEPS := ../libmultipath/discovery.o ../libmultipath/blacklist.o \
 	../libmultipath/prio.o ../libmultipath/callout.o ../libmultipath/structs.o
 hwtable-test_LIBDEPS := -ludev -lpthread -ldl
+blacklist-test_TESTDEPS := test-log.o
 blacklist-test_OBJDEPS := ../libmultipath/blacklist.o
 blacklist-test_LIBDEPS := -ludev
 vpd-test_OBJDEPS :=  ../libmultipath/discovery.o
diff --git a/tests/blacklist.c b/tests/blacklist.c
index 362c44d9..733ee398 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -21,7 +21,7 @@
 #include <cmocka.h>
 #include "globals.c"
 #include "blacklist.h"
-#include "log.h"
+#include "test-log.h"
 
 struct udev_device {
 	const char *sysname;
@@ -62,24 +62,6 @@ __wrap_udev_list_entry_get_name(struct udev_list_entry *list_entry)
 	return *(const char **)list_entry;
 }
 
-void __wrap_dlog (int sink, int prio, const char * fmt, ...)
-{
-	char buff[MAX_MSG_SIZE];
-	va_list ap;
-
-	assert_int_equal(prio, mock_type(int));
-	va_start(ap, fmt);
-	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
-	va_end(ap);
-	assert_string_equal(buff, mock_ptr_type(char *));
-}
-
-void expect_condlog(int prio, char *string)
-{
-	will_return(__wrap_dlog, prio);
-	will_return(__wrap_dlog, string);
-}
-
 vector blist_devnode_sdb;
 vector blist_all;
 vector blist_device_foo_bar;
diff --git a/tests/test-log.c b/tests/test-log.c
new file mode 100644
index 00000000..76a266eb
--- /dev/null
+++ b/tests/test-log.c
@@ -0,0 +1,26 @@
+#include <setjmp.h>
+#include <stddef.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <cmocka.h>
+#include "log.h"
+#include "test-log.h"
+
+void __wrap_dlog (int sink, int prio, const char * fmt, ...)
+{
+	char buff[MAX_MSG_SIZE];
+	va_list ap;
+
+	assert_int_equal(prio, mock_type(int));
+	va_start(ap, fmt);
+	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
+	va_end(ap);
+	assert_string_equal(buff, mock_ptr_type(char *));
+}
+
+void expect_condlog(int prio, char *string)
+{
+	will_return(__wrap_dlog, prio);
+	will_return(__wrap_dlog, string);
+}
+
diff --git a/tests/test-log.h b/tests/test-log.h
new file mode 100644
index 00000000..2c878c63
--- /dev/null
+++ b/tests/test-log.h
@@ -0,0 +1,7 @@
+#ifndef _TEST_LOG_H
+#define _TEST_LOG_H
+
+void __wrap_dlog (int sink, int prio, const char * fmt, ...);
+void expect_condlog(int prio, char *string);
+
+#endif
-- 
2.23.0
