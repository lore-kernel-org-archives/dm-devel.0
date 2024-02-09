Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8593739AD8
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521280; cv=none; b=jAs2dJNPSZa+4JAqRjgsOTKmQo3wr9LRDrgbjzfT/QN50acVzUcV34Y85Uxw7De+O37vBQ06Tm0PDPboFu2YdGjLHhDROErDcWxD1K1oauQJWPGp5iIeConGK59cVTHq2INyxM0/8AskFOZCTYu0lNtXTqPwDcA4HY+4+j+k0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521280; c=relaxed/simple;
	bh=XmfUws+oeyOISEqJNNOoqfuX9Z3znjTIsViLY8A4CV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwgpMh9FTYJ3bsWFDBK76fU4pOrQv2uFh20zp0vn2jbD69Txk3ROc1uwISt+F1AjX4hwAJTcFohUxXNdxhUrgVJk0B1hUe3+JCZOMrpsz/1JRjpQFVRXKTems5TGXoItUeiTTKSexzVb58COcvqVGx+Maj1k14jRYMUstsgniLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MZscERst; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MZscERst"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33b65b2e43eso735145f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521276; x=1708126076; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEjWJXUyvIA+QGAomrtyrXXlSTIk0reYqWcesBPAmOE=;
        b=MZscERstG746/EC6x68aKQKJviZuQo+tnQ9fYymgNZYEcv6cAL9lGfbZmXb01yJtPT
         CgObe7cYpKguz1iQTVv7MJZo1Rhn/uTShebcsOsHM4wQaojn9OY/2M1SsA1+YgBsMEdW
         RXEIC2t2peMUgVUhIq2z4gV/mHkpnSpUb2kc29L7lGBdxd8Lv+PUlk0nDIpNvbnvA0dF
         9Y7qtT9Nwe9R6Fi3e1F79T1SgoFU7pl2v/oNhLhY8/YTrXLe9QF082LIxXL0NpskNcWY
         GuMn13AkZvo3UEdTnPk7fAe0y1S8ynIeQ0jpLdS6ufi3fb4IpWvkB4qbKhwfoW9kfluk
         j3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521276; x=1708126076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEjWJXUyvIA+QGAomrtyrXXlSTIk0reYqWcesBPAmOE=;
        b=lCl7GrDPu1acw7lMkj/ekmWOPs+919IY7yFKFDVZe3V+RMKwrsWgWq8SiI6Qb2kTnZ
         q70LoVl+0odS7VT4pGhGvfzKIZE1MKVo9Y1pykAfeZ2p7l3qbDSO3jfIzXDFqPu3p19e
         DMdd6Nvl+TCFM7Z61fQh6PCHCBEWDKzidTqfl6rLujKAFr420wXlhLe/I75awvMfu3t1
         p+SrfGCinrhnl5Vdeznu2xqhzd+eT/H+Z+j5zKrku6UyPrnmiJW88+l+X5PoZfQKFycg
         814jH6isgIjLdozflrHmWLeZtHLIG6+hbuSsvu6CXtV1mWH2zvkFDdKWKA5QbNc0j4Ck
         ML2A==
X-Gm-Message-State: AOJu0YyP8q47IDF3NaQX5ZVRKrm5vYtgh2z9i25eRp8EvepgGZuvh1s7
	/nrNW89b+oZRwTsDz1RJpKeym67B5ViY206j7QKhbM2aJRW+HmY14EnTsFASWVY=
X-Google-Smtp-Source: AGHT+IGSSLxk0L5D7P5puUHUyPvxJd496LTB8d6YAW2DlfpWWlOnfjQ2qdyY6XgY/zJNmZVpdLBONg==
X-Received: by 2002:a5d:6d82:0:b0:33a:e526:3a49 with SMTP id l2-20020a5d6d82000000b0033ae5263a49mr349267wrs.23.1707521275947;
        Fri, 09 Feb 2024 15:27:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5gG2SF6yT8WUL+4vv7+uFebppTrWyIrbkPYcG1Ikb8Eroht6+PTGG50Fo77XTqdcMvlNmYQ4RulqbZG7B0swklZi7I8zivoeAdHOYwiaQzK9qKM8B2VALnjFaNa1HC8bkY7JNCpg8292YaqxlNULkiP2omF9BWweLz145QPPaagaMw2YJDggg
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id y2-20020a056000108200b0033b5afd7f4dsm371009wrw.91.2024.02.09.15.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 7/7] multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64
Date: Sat, 10 Feb 2024 00:27:35 +0100
Message-ID: <20240209232735.9791-8-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209232735.9791-1-mwilck@suse.com>
References: <20240209232735.9791-1-mwilck@suse.com>
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

