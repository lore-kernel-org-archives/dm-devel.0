Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD7FC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X5yEiZb2UEn4M0jDWZbC3CGSnAMB2GvDc3BXAHOK4M8=;
	b=ZvavWMnSyXKofzXrAFUnhye88FeTxI3hIl2tmvRE4IMu5AH6EJ1hu00laY21Xi5UYEwEzY
	YzZha592UeZXlb+jn0eO15/GLfW27xiMyk5lTZWfkxLKaE3efQqTYU9G74WX3nexHs8xb6
	SsnTkIZT/S4O143F3hR8PlVxOGUSlQw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-fu5aL6HeM_-Ft8Qksn_IVg-1; Wed, 06 Jul 2022 10:38:51 -0400
X-MC-Unique: fu5aL6HeM_-Ft8Qksn_IVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D63D580D2A2;
	Wed,  6 Jul 2022 14:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFEB21121320;
	Wed,  6 Jul 2022 14:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 98D4D1947065;
	Wed,  6 Jul 2022 14:38:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CE9B1947065
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E3FE40315A; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A107492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E29E18E0050
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-9_h_4foVMm6Yj6Ipbc_Cjw-1; Wed, 06 Jul 2022 10:38:44 -0400
X-MC-Unique: 9_h_4foVMm6Yj6Ipbc_Cjw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 84BEF1FF5D;
 Wed,  6 Jul 2022 14:38:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5411C134CF;
 Wed,  6 Jul 2022 14:38:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id OD4NE3CexWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:40 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:21 +0200
Message-Id: <20220706143822.30182-14-mwilck@suse.com>
In-Reply-To: <20220706143822.30182-1-mwilck@suse.com>
References: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 13/14] multipath tests: add sysfs test
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile |   5 +-
 tests/sysfs.c  | 494 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 498 insertions(+), 1 deletion(-)
 create mode 100644 tests/sysfs.c

diff --git a/tests/Makefile b/tests/Makefile
index d20ef23..95a9990 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -16,7 +16,7 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
 LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf
+	 alias directio valid devt mpathvalid strbuf sysfs
 HELPERS := test-lib.o test-log.o
 
 .SILENT: $(TESTS:%=%.o)
@@ -70,6 +70,9 @@ ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
 strbuf-test_OBJDEPS := ../libmultipath/strbuf.o
+sysfs-test_TESTDEPS := test-log.o
+sysfs-test_OBJDEPS := ../libmultipath/sysfs.o ../libmultipath/util.o
+sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 
 %.o: %.c
 	$(CC) $(CPPFLAGS) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
diff --git a/tests/sysfs.c b/tests/sysfs.c
new file mode 100644
index 0000000..0ec135b
--- /dev/null
+++ b/tests/sysfs.c
@@ -0,0 +1,494 @@
+/*
+ * Copyright (c) 2021 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-only
+ */
+
+#define _GNU_SOURCE
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <cmocka.h>
+#include <libudev.h>
+#include <fcntl.h>
+#include <errno.h>
+#include "debug.h"
+#include "globals.c"
+#include "test-log.h"
+#include "sysfs.h"
+#include "util.h"
+
+#define TEST_FD 123
+
+char *__wrap_udev_device_get_syspath(struct udev_device *ud)
+{
+	char *val  = mock_ptr_type(char *);
+
+	return val;
+}
+
+int __wrap_open(const char *pathname, int flags)
+{
+	int ret;
+
+	check_expected(pathname);
+	check_expected(flags);
+	ret = mock_type(int);
+	return ret;
+}
+
+ssize_t __wrap_read(int fd, void *buf, size_t count)
+{
+	ssize_t ret;
+	char *val;
+
+	check_expected(fd);
+	check_expected(count);
+	ret = mock_type(int);
+	val = mock_ptr_type(char *);
+	if (ret >= (ssize_t)count)
+		ret = count;
+	if (ret >= 0 && val) {
+		fprintf(stderr, "%s: '%s' -> %zd\n", __func__, val, ret);
+		memcpy(buf, val, ret);
+	}
+	return ret;
+}
+
+ssize_t __wrap_write(int fd, void *buf, size_t count)
+{
+	ssize_t ret;
+
+	check_expected(fd);
+	check_expected(count);
+	ret = mock_type(int);
+	if (ret >= (ssize_t)count)
+		ret = count;
+	return ret;
+}
+
+int __real_close(int fd);
+int __wrap_close(int fd) {
+	if (fd != TEST_FD)
+		return __real_close(fd);
+	return mock_type(int);
+}
+
+static int setup(void **state)
+{
+	udev = udev_new();
+	return 0;
+}
+
+static int teardown(void **state)
+{
+	udev_unref(udev);
+	return 0;
+}
+
+static void expect_sagv_invalid(void)
+{
+	expect_condlog(1, "__sysfs_attr_get_value: invalid parameters");
+}
+
+static void test_sagv_invalid(void **state)
+{
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_attr_get_value(NULL, NULL, NULL, 0), -EINVAL);
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_bin_attr_get_value(NULL, NULL, NULL, 0), -EINVAL);
+
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_attr_get_value(NULL, (void *)state, (void *)state, 1),
+			 -EINVAL);
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_bin_attr_get_value(NULL, (void *)state, (void *)state, 1),
+			 -EINVAL);
+
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_attr_get_value((void *)state, NULL, (void *)state, 1),
+			 -EINVAL);
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, NULL, (void *)state, 1),
+			 -EINVAL);
+
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_attr_get_value((void *)state, (void *)state, NULL, 1),
+			 -EINVAL);
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, (void *)state, NULL, 1),
+			 -EINVAL);
+
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_attr_get_value((void *)state, (void *)state,
+					      (void *)state, 0), -EINVAL);
+	expect_sagv_invalid();
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, (void *)state,
+						  (void *)state, 0), -EINVAL);
+}
+
+static void test_sagv_bad_udev(void **state)
+{
+	will_return(__wrap_udev_device_get_syspath, NULL);
+	expect_condlog(3, "__sysfs_attr_get_value: invalid udevice");
+	assert_int_equal(sysfs_attr_get_value((void *)state, (void *)state,
+					      (void *)state, 1), -EINVAL);
+
+	will_return(__wrap_udev_device_get_syspath, NULL);
+	expect_condlog(3, "__sysfs_attr_get_value: invalid udevice");
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, (void *)state,
+						  (void *)state, 1), -EINVAL);
+}
+
+static void test_sagv_bad_snprintf(void **state)
+{
+	char longstr[PATH_MAX + 1];
+	char buf[1];
+
+	memset(longstr, 'a', sizeof(longstr) - 1);
+	longstr[sizeof(longstr) - 1] = '\0';
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(3, "__sysfs_attr_get_value: devpath overflow");
+	assert_int_equal(sysfs_attr_get_value((void *)state, longstr,
+					      buf, sizeof(buf)), -EOVERFLOW);
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(3, "__sysfs_attr_get_value: devpath overflow");
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, longstr,
+						  (unsigned char *)buf, sizeof(buf)),
+			 -EOVERFLOW);
+}
+
+static void test_sagv_open_fail(void **state)
+{
+	char buf[1];
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	errno = ENOENT;
+	will_return(__wrap_open, -1);
+	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' can not be opened");
+	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
+					      buf, sizeof(buf)), -ENOENT);
+}
+
+static void test_sagv_read_fail(void **state)
+{
+	char buf[1];
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_read, fd, TEST_FD);
+	expect_value(__wrap_read, count, sizeof(buf));
+	errno = EISDIR;
+	will_return(__wrap_read, -1);
+	will_return(__wrap_read, NULL);
+	expect_condlog(3, "__sysfs_attr_get_value: read from /foo/bar failed:");
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
+					      buf, sizeof(buf)), -EISDIR);
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/baz'");
+	expect_string(__wrap_open, pathname, "/foo/baz");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_read, fd, TEST_FD);
+	expect_value(__wrap_read, count, sizeof(buf));
+	errno = EPERM;
+	will_return(__wrap_read, -1);
+	will_return(__wrap_read, NULL);
+	expect_condlog(3, "__sysfs_attr_get_value: read from /foo/baz failed:");
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, "baz",
+						  (unsigned char *)buf, sizeof(buf)),
+			 -EPERM);
+
+}
+
+static void _test_sagv_read(void **state, unsigned int bufsz)
+{
+	char buf[16];
+	char input[] = "01234567";
+	unsigned int n, trunc;
+
+	assert_in_range(bufsz, 1, sizeof(buf));
+	memset(buf, '.', sizeof(buf));
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_read, fd, TEST_FD);
+	expect_value(__wrap_read, count, bufsz);
+	will_return(__wrap_read, sizeof(input) - 1);
+	will_return(__wrap_read, input);
+
+	/* If the buffer is too small, input will be truncated by a 0 byte */
+	if (bufsz <= sizeof(input) - 1) {
+		n = bufsz;
+		trunc = 1;
+		expect_condlog(3, "__sysfs_attr_get_value: overflow reading from /foo/bar");
+	} else {
+		n = sizeof(input) - 1;
+		trunc = 0;
+	}
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
+					      buf, bufsz), n);
+	assert_memory_equal(buf, input, n - trunc);
+	assert_int_equal(buf[n - trunc], '\0');
+
+	/* Binary input is not truncated */
+	memset(buf, '.', sizeof(buf));
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/baz'");
+	expect_string(__wrap_open, pathname, "/foo/baz");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_read, fd, TEST_FD);
+	expect_value(__wrap_read, count, bufsz);
+	will_return(__wrap_read, sizeof(input) - 1);
+	will_return(__wrap_read, input);
+	will_return(__wrap_close, 0);
+	n = bufsz < sizeof(input) - 1 ? bufsz : sizeof(input) - 1;
+	assert_int_equal(sysfs_bin_attr_get_value((void *)state, "baz",
+						  (unsigned char *)buf,
+						  bufsz),
+			 n);
+	assert_memory_equal(buf, input, n);
+}
+
+static void test_sagv_read_overflow_8(void **state)
+{
+	_test_sagv_read(state, 8);
+}
+
+static void test_sagv_read_overflow_4(void **state)
+{
+	_test_sagv_read(state, 4);
+}
+
+static void test_sagv_read_overflow_1(void **state)
+{
+	_test_sagv_read(state, 1);
+}
+
+static void test_sagv_read_good_9(void **state)
+{
+	_test_sagv_read(state, 9);
+}
+
+static void test_sagv_read_good_15(void **state)
+{
+	_test_sagv_read(state, 15);
+}
+
+static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
+{
+	char buf[16];
+	char input[] = { '\0','\0','\0','\0','\0','\0','\0','\0' };
+	unsigned int n;
+
+	assert_in_range(bufsz, 1, sizeof(buf));
+	memset(buf, '.', sizeof(buf));
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_RDONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_read, fd, TEST_FD);
+	expect_value(__wrap_read, count, bufsz);
+	will_return(__wrap_read, sizeof(input) - 1);
+	will_return(__wrap_read, input);
+
+	if (bufsz <= sizeof(input) - 1) {
+		n = bufsz;
+		expect_condlog(3, "__sysfs_attr_get_value: overflow reading from /foo/bar");
+	} else
+		n = 0;
+
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
+					      buf, bufsz), n);
+
+	/*
+	 * The return value of sysfs_attr_get_value ignores zero bytes,
+	 * but the read data should have been copied to the buffer
+	 */
+	assert_memory_equal(buf, input, n == 0 ? bufsz : n);
+}
+
+static void test_sagv_read_zeroes_4(void **state)
+{
+	_test_sagv_read_zeroes(state, 4);
+}
+
+static void expect_sasv_invalid(void)
+{
+	expect_condlog(1, "sysfs_attr_set_value: invalid parameters");
+}
+
+static void test_sasv_invalid(void **state)
+{
+	expect_sasv_invalid();
+	assert_int_equal(sysfs_attr_set_value(NULL, NULL, NULL, 0), -EINVAL);
+
+	expect_sasv_invalid();
+	assert_int_equal(sysfs_attr_set_value(NULL, (void *)state, (void *)state, 1),
+			 -EINVAL);
+
+	expect_sasv_invalid();
+	assert_int_equal(sysfs_attr_set_value((void *)state, NULL, (void *)state, 1),
+			 -EINVAL);
+
+	expect_sasv_invalid();
+	assert_int_equal(sysfs_attr_set_value((void *)state, (void *)state, NULL, 1),
+			 -EINVAL);
+
+	expect_sasv_invalid();
+	assert_int_equal(sysfs_attr_set_value((void *)state, (void *)state,
+					      (void *)state, 0), -EINVAL);
+}
+
+static void test_sasv_bad_udev(void **state)
+{
+	will_return(__wrap_udev_device_get_syspath, NULL);
+	expect_condlog(3, "sysfs_attr_set_value: invalid udevice");
+	assert_int_equal(sysfs_attr_set_value((void *)state, (void *)state,
+					      (void *)state, 1), -EINVAL);
+}
+
+static void test_sasv_bad_snprintf(void **state)
+{
+	char longstr[PATH_MAX + 1];
+	char buf[1];
+
+	memset(longstr, 'a', sizeof(longstr) - 1);
+	longstr[sizeof(longstr) - 1] = '\0';
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(3, "sysfs_attr_set_value: devpath overflow");
+	assert_int_equal(sysfs_attr_set_value((void *)state, longstr,
+					      buf, sizeof(buf)), -EOVERFLOW);
+}
+
+static void test_sasv_open_fail(void **state)
+{
+	char buf[1];
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_WRONLY);
+	errno = EPERM;
+	will_return(__wrap_open, -1);
+	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' can not be opened");
+	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
+					      buf, sizeof(buf)), -EPERM);
+}
+
+static void test_sasv_write_fail(void **state)
+{
+	char buf[1];
+
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_WRONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_write, fd, TEST_FD);
+	expect_value(__wrap_write, count, sizeof(buf));
+	errno = EISDIR;
+	will_return(__wrap_write, -1);
+	expect_condlog(3, "sysfs_attr_set_value: write to /foo/bar failed:");
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
+					      buf, sizeof(buf)), -EISDIR);
+
+}
+
+static void _test_sasv_write(void **state, unsigned int n_written)
+{
+	char buf[8];
+
+	assert_in_range(n_written, 0, sizeof(buf));
+	will_return(__wrap_udev_device_get_syspath, "/foo");
+	expect_condlog(4, "open '/foo/bar'");
+	expect_string(__wrap_open, pathname, "/foo/bar");
+	expect_value(__wrap_open, flags, O_WRONLY);
+	will_return(__wrap_open, TEST_FD);
+	expect_value(__wrap_write, fd, TEST_FD);
+	expect_value(__wrap_write, count, sizeof(buf));
+	will_return(__wrap_write, n_written);
+
+	if (n_written < sizeof(buf))
+		expect_condlog(3, "sysfs_attr_set_value: underflow writing");
+	will_return(__wrap_close, 0);
+	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
+					      buf, sizeof(buf)),
+			 n_written);
+}
+
+static void test_sasv_write_0(void **state)
+{
+	_test_sasv_write(state, 0);
+}
+
+static void test_sasv_write_4(void **state)
+{
+	_test_sasv_write(state, 4);
+}
+
+static void test_sasv_write_7(void **state)
+{
+	_test_sasv_write(state, 7);
+}
+
+static void test_sasv_write_8(void **state)
+{
+	_test_sasv_write(state, 8);
+}
+
+static int test_sysfs(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_sagv_invalid),
+		cmocka_unit_test(test_sagv_bad_udev),
+		cmocka_unit_test(test_sagv_bad_snprintf),
+		cmocka_unit_test(test_sagv_open_fail),
+		cmocka_unit_test(test_sagv_read_fail),
+		cmocka_unit_test(test_sagv_read_overflow_1),
+		cmocka_unit_test(test_sagv_read_overflow_4),
+		cmocka_unit_test(test_sagv_read_overflow_8),
+		cmocka_unit_test(test_sagv_read_good_9),
+		cmocka_unit_test(test_sagv_read_good_15),
+		cmocka_unit_test(test_sagv_read_zeroes_4),
+		cmocka_unit_test(test_sasv_invalid),
+		cmocka_unit_test(test_sasv_bad_udev),
+		cmocka_unit_test(test_sasv_bad_snprintf),
+		cmocka_unit_test(test_sasv_open_fail),
+		cmocka_unit_test(test_sasv_write_fail),
+		cmocka_unit_test(test_sasv_write_0),
+		cmocka_unit_test(test_sasv_write_4),
+		cmocka_unit_test(test_sasv_write_7),
+		cmocka_unit_test(test_sasv_write_8),
+	};
+
+	return cmocka_run_group_tests(tests, setup, teardown);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(4);
+	ret += test_sysfs();
+	return ret;
+}
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

