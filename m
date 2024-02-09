Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0625A7C0A9
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497735; cv=none; b=EDj4kCwTGINbLubPeeBQcqcIgl/uB0uHqXDQ62jU/2Qpq82dkpC3bwF715YfEUxv7kROfraqHmaWCf7/eKBqTQw4mWl3hr90w/qqPZI28LexW1CZtuGxB8IfWgBsUllvpkT00ri9af0/6ftPHb0fc5nuU9KNj7uy0eXw/jzP0O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497735; c=relaxed/simple;
	bh=XmfUws+oeyOISEqJNNOoqfuX9Z3znjTIsViLY8A4CV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcQJ/TdG3sckRbxpd20S8uaXjkFTcvil+beWdoqIBsKMC8e9XJi8PWizwbKcHyO8e/9e/phorxJDc6aKFGPVoF+gWkivHZ3n0iZYLCI5PYQK7viUadSDcKXFejUbSvMLyS99o3dlG1B7VuJEpw+8TibKKN/l05XeN7I8Xjp0iSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gEhG3TwI; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gEhG3TwI"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41060e5b664so7944325e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497731; x=1708102531; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEjWJXUyvIA+QGAomrtyrXXlSTIk0reYqWcesBPAmOE=;
        b=gEhG3TwIAZrCRpiAmn6JBWCvfyXU4N1+utzf3IGsp2JAWVy9FI7UQ2QOoSxrsRscTJ
         Hj1w3IwS1WQAhbDorI/Jk03IB53acJVOHeXvq+eiQi/4lxTYxjIWub5oZzGkOw1ob1DK
         eCbxp7uXRx7STQB93Ezl722GYrmDX3RQXW78aN/QManHK17K+4L+k8bCe4qzWcUu1Bz0
         TWjsEicfeagSSvyVtV4ZlAcsdO4pKaIXeR+o8p0OrTFmYrPVy6VlJ/rEN3MIDg7bN0lH
         9p1pTx156pKMmlGJrel/iNTACZTdWkGB8n4sZOzeTXh+ytzLmmeLMZpBqO4MT2gZBLk7
         2YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497731; x=1708102531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEjWJXUyvIA+QGAomrtyrXXlSTIk0reYqWcesBPAmOE=;
        b=OqiN1lRQg2zQImpY5nE1fdjrkYdDJxET7/YDEial6imufVEfUbxa8AiV49HiB+8uIW
         3Jt+LykQJqb78ZlS0RTFLJLCzcuYvkbVihZj8fYPGjgnUL6AvLVtzZwsJeLDwbRLBli1
         SLPu5/Bze9BM61kw/QEcwuZ3055OsOeMSVkVivAjf7tw+w/uEbF4WvsOBqA0j0xbivQF
         zbWjXd7jo4MCI7syxcIfW0EN/9I0LB5jFngYJqbj78Mz7VmbyDN4aHSQNbLmql17uKYo
         nlz/phmVnmQnLI2e0JWvNAZEYb8FfEQ6VhG82VH/HTfOSQw6QAF7ZlWXpGPF9NL1ZjWP
         2Gyg==
X-Gm-Message-State: AOJu0YyeQoJdPlXH5VpuMl/ItxYyKKd63Ly38m+uYhxwu+I1uUtoa9LO
	yq6Gtko1GcyYD8ZXOJl14kjEq/IGS2JMVfG5AHTxC3my3Fm9HUYQvMLt12qjNpE=
X-Google-Smtp-Source: AGHT+IGM57mhy1jDp1rz8QEh7seht6VA/HdX+Xk9vmSmrPJIc9ByX0a/iDnm/p02It6pht927g6ZPw==
X-Received: by 2002:a05:600c:600b:b0:40e:ac46:7568 with SMTP id az11-20020a05600c600b00b0040eac467568mr1666877wmb.13.1707497731237;
        Fri, 09 Feb 2024 08:55:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXgPD1wHA+Nps0WVrQoN9Y4DP7MeZS4GpvJXz2WwbJfu6CpE8faavJcBILXrL5fn6j2l377EWvXXfRyA2z3PvfQlbmHkvDpSP2KU4LxwW8PObhf8zRZBnbNAq+I0vA9UCjPD+jxsOizASqA4qojN4EL3i/GfEoy9o9Nn67CKSwF8LilXLzi+bXv
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id jx6-20020a05600c578600b0040ffd94cd27sm1106991wmb.45.2024.02.09.08.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 6/6] multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64
Date: Fri,  9 Feb 2024 17:55:13 +0100
Message-ID: <20240209165513.7661-7-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209165513.7661-1-mwilck@suse.com>
References: <20240209165513.7661-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set _FILE_OFFSET_BITS=64 in order to avoid EOVERFLOW error for getdents()
syscalls on some file systems (in particular, ext4) in emultated 32bit
environments on 64 bit kernel, e.g. when running in qemu. This error occured
in arm/v7 CI runs on Ubuntu runners on GitHub, which can be enabled after
applying this change.  See
e.g. https://sourceware.org/bugzilla/show_bug.cgi?id=23960.

This change requires fixes for the unit tests: If -D_FILE_OFFSET_BITS=64 is
set, glibc headers replace some functions with their 64bit equivalents. open()
is replaced by open64(), etc. cmocka wrappers for these functions must have
correct name: defining __wrap_open() has no effect for calls to open64(). Unit
tests using the wrongly named wrapper functions will fail in non-obvious ways.

Use CPP macros to substitute the correct name for affected functions. Also,
the Makefile rule that builds the -Wl,wrap= options must parse the C preprocessor
output to generate suitable command line parameters for the linker.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc     |  1 +
 tests/Makefile   |  5 ++++-
 tests/alias.c    |  4 ++--
 tests/directio.c |  7 +++---
 tests/dmevents.c |  8 +++----
 tests/sysfs.c    | 57 ++++++++++++++++++++++++------------------------
 tests/test-lib.c |  9 +++++---
 tests/wrap64.h   | 48 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 98 insertions(+), 41 deletions(-)
 create mode 100644 tests/wrap64.h

diff --git a/Makefile.inc b/Makefile.inc
index a0e36c4..5668e63 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -100,6 +100,7 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
 CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
+		   -D_FILE_OFFSET_BITS=64 \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
diff --git a/tests/Makefile b/tests/Makefile
index 7dac8a8..7dde8bd 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -105,8 +105,11 @@ include $(wildcard $(OBJS:.o=.d))
 dep_clean:
 	$(Q)$(RM) $(OBJS:.o=.d)
 
+# Parse the C code for __wrap_xyz() functions and generate linker options from them.
+# See comment in wrap64.h
 %.o.wrap:	%.c
-	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
+	$(Q)$(CC) $(CPPFLAGS) $($*-test_FLAGS) -E $< | \
+		sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' | \
 		sort -u | tr '\n' ' ' >$@
 
 # Pass the original values of CFLAGS etc. to the sub-make, which will include
diff --git a/tests/alias.c b/tests/alias.c
index c2ae915..95ce994 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -9,7 +9,7 @@
 #include "test-log.h"
 #include <errno.h>
 #include <string.h>
-
+#include "wrap64.h"
 #include "globals.c"
 #include "../libmultipath/alias.c"
 
@@ -71,7 +71,7 @@ int __wrap_rename(const char *old, const char *new)
 	return __set_errno(mock_type(int));
 }
 
-int __wrap_mkstemp(char *template)
+int WRAP_FUNC(mkstemp)(char *template)
 {
 	return 10;
 }
diff --git a/tests/directio.c b/tests/directio.c
index 5201d21..cbedcc9 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -24,6 +24,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
+#include "wrap64.h"
 #include "globals.c"
 #include "../libmultipath/checkers/directio.c"
 
@@ -66,12 +67,12 @@ int __wrap_ioctl(int fd, ioctl_request_t request, void *argp)
 #endif
 }
 
-int __real_fcntl(int fd, int cmd, long arg);
+int REAL_FCNTL (int fd, int cmd, long arg);
 
-int __wrap_fcntl(int fd, int cmd, long arg)
+int WRAP_FCNTL (int fd, int cmd, long arg)
 {
 #ifdef DIO_TEST_DEV
-	return __real_fcntl(fd, cmd, arg);
+	return REAL_FCNTL(fd, cmd, arg);
 #else
 	assert_int_equal(fd, test_fd);
 	assert_int_equal(cmd, F_GETFL);
diff --git a/tests/dmevents.c b/tests/dmevents.c
index f08e649..540bf0d 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -29,7 +29,7 @@
 #include <fcntl.h>
 #include "structs.h"
 #include "structs_vec.h"
-
+#include "wrap64.h"
 #include "globals.c"
 /* I have to do this to get at the static variables */
 #include "../multipathd/dmevents.c"
@@ -207,7 +207,7 @@ static int teardown(void **state)
 	return 0;
 }
 
-int __wrap_open(const char *pathname, int flags)
+int WRAP_FUNC(open)(const char *pathname, int flags)
 {
 	assert_ptr_equal(pathname, "/dev/mapper/control");
 	assert_int_equal(flags, O_RDWR);
@@ -389,7 +389,7 @@ static void test_init_waiter_bad1(void **state)
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
-	will_return(__wrap_open, -1);
+	wrap_will_return(WRAP_FUNC(open), -1);
 	assert_int_equal(init_dmevent_waiter(&datap->vecs), -1);
 	assert_ptr_equal(waiter, NULL);
 }
@@ -400,7 +400,7 @@ static void test_init_waiter_good0(void **state)
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
-	will_return(__wrap_open, 2);
+	wrap_will_return(WRAP_FUNC(open), 2);
 	assert_int_equal(init_dmevent_waiter(&datap->vecs), 0);
 	assert_ptr_not_equal(waiter, NULL);
 }
diff --git a/tests/sysfs.c b/tests/sysfs.c
index 6e07efd..fc256d8 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -18,6 +18,7 @@
 #include "test-log.h"
 #include "sysfs.h"
 #include "util.h"
+#include "wrap64.h"
 
 #define TEST_FD 123
 
@@ -28,7 +29,7 @@ char *__wrap_udev_device_get_syspath(struct udev_device *ud)
 	return val;
 }
 
-int __wrap_open(const char *pathname, int flags)
+int WRAP_FUNC(open)(const char *pathname, int flags)
 {
 	int ret;
 
@@ -166,10 +167,10 @@ static void test_sagv_open_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_RDONLY);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
 	errno = ENOENT;
-	will_return(__wrap_open, -1);
+	wrap_will_return(WRAP_FUNC(open), -1);
 	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' cannot be opened");
 	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
 					      buf, sizeof(buf)), -ENOENT);
@@ -181,9 +182,9 @@ static void test_sagv_read_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_RDONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, sizeof(buf));
 	errno = EISDIR;
@@ -196,9 +197,9 @@ static void test_sagv_read_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
-	expect_string(__wrap_open, pathname, "/foo/baz");
-	expect_value(__wrap_open, flags, O_RDONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, sizeof(buf));
 	errno = EPERM;
@@ -222,9 +223,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_RDONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -249,9 +250,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
-	expect_string(__wrap_open, pathname, "/foo/baz");
-	expect_value(__wrap_open, flags, O_RDONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -300,9 +301,9 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_RDONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -385,10 +386,10 @@ static void test_sasv_open_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_WRONLY);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
 	errno = EPERM;
-	will_return(__wrap_open, -1);
+	wrap_will_return(WRAP_FUNC(open), -1);
 	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' cannot be opened");
 	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
 					      buf, sizeof(buf)), -EPERM);
@@ -400,9 +401,9 @@ static void test_sasv_write_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_WRONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_write, fd, TEST_FD);
 	expect_value(__wrap_write, count, sizeof(buf));
 	errno = EISDIR;
@@ -421,9 +422,9 @@ static void _test_sasv_write(void **state, unsigned int n_written)
 	assert_in_range(n_written, 0, sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(__wrap_open, pathname, "/foo/bar");
-	expect_value(__wrap_open, flags, O_WRONLY);
-	will_return(__wrap_open, TEST_FD);
+	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
+	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
+	wrap_will_return(WRAP_FUNC(open), TEST_FD);
 	expect_value(__wrap_write, fd, TEST_FD);
 	expect_value(__wrap_write, count, sizeof(buf));
 	will_return(__wrap_write, n_written);
diff --git a/tests/test-lib.c b/tests/test-lib.c
index f75ea31..665d438 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -16,6 +16,7 @@
 #include "propsel.h"
 #include "unaligned.h"
 #include "test-lib.h"
+#include "wrap64.h"
 
 const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO|DI_SERIAL);
 const char default_devnode[] = "sdxTEST";
@@ -38,16 +39,18 @@ const char default_wwid_1[] = "TEST-WWID-1";
  * resolved by the assembler before the linking stage.
  */
 
-int __real_open(const char *path, int flags, int mode);
+
+int REAL_FUNC(open)(const char *path, int flags, int mode);
 
 static const char _mocked_filename[] = "mocked_path";
-int __wrap_open(const char *path, int flags, int mode)
+
+int WRAP_FUNC(open)(const char *path, int flags, int mode)
 {
 	condlog(4, "%s: %s", __func__, path);
 
 	if (!strcmp(path, _mocked_filename))
 		return 111;
-	return __real_open(path, flags, mode);
+	return REAL_FUNC(open)(path, flags, mode);
 }
 
 int __wrap_libmp_get_version(int which, unsigned int version[3])
diff --git a/tests/wrap64.h b/tests/wrap64.h
new file mode 100644
index 0000000..8c91d27
--- /dev/null
+++ b/tests/wrap64.h
@@ -0,0 +1,48 @@
+#ifndef _WRAP64_H
+#define _WRAP64_H 1
+#include "util.h"
+
+/*
+ * Make cmocka work with _FILE_OFFSET_BITS == 64
+ *
+ * If -D_FILE_OFFSET_BITS=64 is set, glibc headers replace some functions with
+ * their 64bit equivalents. "open()" is replaced by "open64()", etc. cmocka
+ * wrappers for these functions must have correct name __wrap_open() doesn't
+ * work if the function called is not open() but open64(). Consequently, unit
+ * tests using such wrappers will fail.
+ * Use some CPP trickery to insert the correct name. The Makefile rule that
+ * creates the .wrap file must parse the C preprocessor output to generate the
+ * correct -Wl,wrap= option.
+ */
+
+/* Without this indirection, WRAP_FUNC(x) would be expanded to __wrap_WRAP_NAME(x) */
+#define CONCAT2_(x, y) x ## y
+#define CONCAT2(x, y) CONCAT2_(x, y)
+
+#if defined(__GLIBC__) && _FILE_OFFSET_BITS == 64
+#define WRAP_NAME(x) x ## 64
+#else
+#define WRAP_NAME(x) x
+#endif
+#define WRAP_FUNC(x) CONCAT2(__wrap_, WRAP_NAME(x))
+#define REAL_FUNC(x) CONCAT2(__real_, WRAP_NAME(x))
+
+/*
+ * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
+ * https://savannah.gnu.org/forum/forum.php?forum_id=9205
+ */
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
+#define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
+#else
+#define WRAP_FCNTL_NAME fcntl
+#endif
+#define WRAP_FCNTL CONCAT2(__wrap_, WRAP_FCNTL_NAME)
+#define REAL_FCNTL CONCAT2(__real_, WRAP_FCNTL_NAME)
+
+/*
+ * will_return() is itself a macro that uses CPP "stringizing". We need a
+ * macro indirection to make sure the *value* of WRAP_FUNC() is stringized
+ * (see https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html).
+ */
+#define wrap_will_return(x, y) will_return(x, y)
+#endif
-- 
2.43.0

