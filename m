Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8314A29
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914398; cv=none; b=ThWlUaTg8nDahYHJcAFEJ7bAPoXj1PiJU2SiwYKssUvdVQzu7u3fgte2Wlx3wguD6+0KC4OL/8PyvlClcIaX8tPLVlfciA6gFeSfyg5nI8+eGtEcMzs1sSMPY51b36IZG3vWNkXzFAQC1uO3WoC9BfIHL/N2kCadym3oVXfmkJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914398; c=relaxed/simple;
	bh=VI2sO4h1GaNHPPi9LVpZZOCN28YlR9Ohzk3uCZU865A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlWA9z0MIEdvHQfGfZpQgbkcmZgegPnGg1Tuh3NkuApFgODK6kUe5YuhV44I4ECH9GI0UlyU9LcKQGlpPERBZ350cjjUOPFKXllYdk0m6HoQa4f7qkhPZcZzaLsyJRuyAQoXfxVO9aWqoc4KYEcIW7jrZZWwC7v3SxyjxmB44u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rpa9p7xu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rpa9p7xu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41802e8db9aso1702575e9.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 02:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712914394; x=1713519194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laxZthAT14Ys1lXVHK7FSG7VaF3hcgFDnlQOj0da+YY=;
        b=Rpa9p7xuKk27YuAJeS+AxfcvybMUOx7F+iADFREbU7NfqjCHhps8bpoU78S8ea78N3
         D/gW5+UbnzZOV54UNXioKSVI+lWwaTp95XFl/WptZC+tpTMM5oHBH4n7Kldl+kYgfuCQ
         O4iPEifsrm7pG9TS1+wak53OYubI6XngRq5d1T/HIxOpsvWOTsm7Kf3zvGIar8rN9pck
         ACZ8UVCmLFnH5csybsRvBpdNyUUdDpGKIRtql7DbA9317LY4ljaNEiQN6uPL0+fcZ5L2
         VuppPyq8A0tD+BnxljVXCJaZVUg9NxA04tcE5qZVzHzwSrMJiJ/F7MyStFYyFF/ttq95
         EWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712914394; x=1713519194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=laxZthAT14Ys1lXVHK7FSG7VaF3hcgFDnlQOj0da+YY=;
        b=kNkgznuzboYXxkj/D/NE4cCQu2KjjaHWjEtHumzm0pmjGUzQaziTxi8BP+jTKisAZw
         A5lYT5dtL5BmFZiGryzn8jaH6kCaKcrxdVgtUOtvMQnX8zxWUIFz48ysw/6niDejXUp8
         L0CYkLoIXi/j+Q3lqWAxw+TmNHDj1aZpVRn2pRRCs1fBVyWUuYpdrW3Btmd+01ghWUB2
         ok1STf1jpkBq4pa8CqbyoltvsrYHzJY7lsZM39Giy47bhhHY/P/b0yWl9/YkOL+mt99i
         Vc2HbP9CTJBWw/b1RLwHdGIUTpuY2PgQ50CMUX6CzESjKU7g/g3DhSPD13JoLAn87JBJ
         LRPg==
X-Gm-Message-State: AOJu0Yyyd8X6pTk1J7oPRRheONqSZBD6yFwiobZ1dkJDzVF9nf2V2zCz
	2ttV/tRxTGr4VDA5ReRzt9DpEXj71/2UvFWWy7P4BpALbrWVUX2opgXK1Ez/GvbsBFo8qKAAmM/
	+
X-Google-Smtp-Source: AGHT+IHJxDmgQJQlACWZRyY75clXg2PvYv1vDsFGviuaLkUZN5ylJsGKz5+Q62e/iTSPxyG4H5/hZQ==
X-Received: by 2002:a05:600c:4746:b0:417:fa7c:e96e with SMTP id w6-20020a05600c474600b00417fa7ce96emr1100614wmo.7.1712914394375;
        Fri, 12 Apr 2024 02:33:14 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id m38-20020a05600c3b2600b00417fdf4677asm1439746wms.14.2024.04.12.02.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 02:33:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] multipath-tools tests: fix CI failures with clang on Fedora Rawhide
Date: Fri, 12 Apr 2024 11:32:58 +0200
Message-ID: <20240412093258.20037-3-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240412093258.20037-1-mwilck@suse.com>
References: <20240412093258.20037-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fedora's glibc 2.39 includes the following patch:

https://patches.linaro.org/project/libc-alpha/patch/20240208184622.332678-10-adhemerval.zanella@linaro.org/

It causes open("file", O_RDONLY) to resolve to __open64_2(),
whereas it resolves to open64() with gcc, causing CI failures because of
wrong wrapper substitutions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/dmevents.c |  6 ++---
 tests/sysfs.c    | 58 ++++++++++++++++++++++++------------------------
 tests/test-lib.c |  6 ++---
 tests/wrap64.h   | 14 ++++++++++++
 4 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/tests/dmevents.c b/tests/dmevents.c
index 540bf0d..395b16d 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -207,7 +207,7 @@ static int teardown(void **state)
 	return 0;
 }
 
-int WRAP_FUNC(open)(const char *pathname, int flags)
+int WRAP_OPEN(const char *pathname, int flags)
 {
 	assert_ptr_equal(pathname, "/dev/mapper/control");
 	assert_int_equal(flags, O_RDWR);
@@ -389,7 +389,7 @@ static void test_init_waiter_bad1(void **state)
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
-	wrap_will_return(WRAP_FUNC(open), -1);
+	wrap_will_return(WRAP_OPEN, -1);
 	assert_int_equal(init_dmevent_waiter(&datap->vecs), -1);
 	assert_ptr_equal(waiter, NULL);
 }
@@ -400,7 +400,7 @@ static void test_init_waiter_good0(void **state)
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
-	wrap_will_return(WRAP_FUNC(open), 2);
+	wrap_will_return(WRAP_OPEN, 2);
 	assert_int_equal(init_dmevent_waiter(&datap->vecs), 0);
 	assert_ptr_not_equal(waiter, NULL);
 }
diff --git a/tests/sysfs.c b/tests/sysfs.c
index fc256d8..c623d1b 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -29,7 +29,7 @@ char *__wrap_udev_device_get_syspath(struct udev_device *ud)
 	return val;
 }
 
-int WRAP_FUNC(open)(const char *pathname, int flags)
+int WRAP_OPEN(const char *pathname, int flags)
 {
 	int ret;
 
@@ -167,10 +167,10 @@ static void test_sagv_open_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
 	errno = ENOENT;
-	wrap_will_return(WRAP_FUNC(open), -1);
+	wrap_will_return(WRAP_OPEN, -1);
 	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' cannot be opened");
 	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
 					      buf, sizeof(buf)), -ENOENT);
@@ -182,9 +182,9 @@ static void test_sagv_read_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, sizeof(buf));
 	errno = EISDIR;
@@ -197,9 +197,9 @@ static void test_sagv_read_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/baz");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, sizeof(buf));
 	errno = EPERM;
@@ -223,9 +223,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -250,9 +250,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/baz");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -301,9 +301,9 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_read, fd, TEST_FD);
 	expect_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
@@ -386,10 +386,10 @@ static void test_sasv_open_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_WRONLY);
 	errno = EPERM;
-	wrap_will_return(WRAP_FUNC(open), -1);
+	wrap_will_return(WRAP_OPEN, -1);
 	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' cannot be opened");
 	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
 					      buf, sizeof(buf)), -EPERM);
@@ -401,9 +401,9 @@ static void test_sasv_write_fail(void **state)
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_WRONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_write, fd, TEST_FD);
 	expect_value(__wrap_write, count, sizeof(buf));
 	errno = EISDIR;
@@ -422,9 +422,9 @@ static void _test_sasv_write(void **state, unsigned int n_written)
 	assert_in_range(n_written, 0, sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
-	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
-	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
-	wrap_will_return(WRAP_FUNC(open), TEST_FD);
+	expect_string(WRAP_OPEN, pathname, "/foo/bar");
+	expect_value(WRAP_OPEN, flags, O_WRONLY);
+	wrap_will_return(WRAP_OPEN, TEST_FD);
 	expect_value(__wrap_write, fd, TEST_FD);
 	expect_value(__wrap_write, count, sizeof(buf));
 	will_return(__wrap_write, n_written);
@@ -489,7 +489,7 @@ int main(void)
 {
 	int ret = 0;
 
-	init_test_verbosity(4);
+	init_test_verbosity(5);
 	ret += test_sysfs();
 	return ret;
 }
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 665d438..cdb2780 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -40,17 +40,17 @@ const char default_wwid_1[] = "TEST-WWID-1";
  */
 
 
-int REAL_FUNC(open)(const char *path, int flags, int mode);
+int REAL_OPEN(const char *path, int flags, int mode);
 
 static const char _mocked_filename[] = "mocked_path";
 
-int WRAP_FUNC(open)(const char *path, int flags, int mode)
+int WRAP_OPEN(const char *path, int flags, int mode)
 {
 	condlog(4, "%s: %s", __func__, path);
 
 	if (!strcmp(path, _mocked_filename))
 		return 111;
-	return REAL_FUNC(open)(path, flags, mode);
+	return REAL_OPEN(path, flags, mode);
 }
 
 int __wrap_libmp_get_version(int which, unsigned int version[3])
diff --git a/tests/wrap64.h b/tests/wrap64.h
index 6b92751..b1dfa38 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -29,6 +29,20 @@
 #define WRAP_FUNC(x) CONCAT2(__wrap_, WRAP_NAME(x))
 #define REAL_FUNC(x) CONCAT2(__real_, WRAP_NAME(x))
 
+/*
+ * With clang, glibc 2.39, and _FILE_OFFSET_BITS==64,
+ * open() resolves to __open64_2().
+ */
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 39) && \
+	defined(__clang__) && __clang__ == 1 && \
+	defined(__fortify_use_clang) && __fortify_use_clang == 1
+#define WRAP_OPEN_NAME __open64_2
+#else
+#define WRAP_OPEN_NAME WRAP_NAME(open)
+#endif
+#define WRAP_OPEN CONCAT2(__wrap_, WRAP_OPEN_NAME)
+#define REAL_OPEN CONCAT2(__real_, WRAP_OPEN_NAME)
+
 /*
  * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
  * https://savannah.gnu.org/forum/forum.php?forum_id=9205
-- 
2.44.0

