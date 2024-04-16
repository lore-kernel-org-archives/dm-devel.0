Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9547B1369B0
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293648; cv=none; b=Ml00sOChG6WX8YZQG4Axwj+bjepDq0Lx6rIx5hPe7htw20Cdpr6ZVBSehlVhPsGR2V/aI6G2J/pKIR0YHNzYjRPcm9LgO2Wsr797zeaR8m4CKAs3/vziJA1O00R4vX7dYrLAYXxl/T6QWhYl1Nj9ulrr+q/tA3XXGERcF4WUMrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293648; c=relaxed/simple;
	bh=aPutquwu1R/3g533v2aa4OVFQSFA9b9AXQ1OocFAK8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRhcv2rEmSGnferFU630gWD9kS88bF6zYJE7lEwp4MAYkf/iLk/tfjyV8BbU4wPc1HNc0+yB2mswJzMMBOKKpA0r8B69VJ7802Uj5ANs0tf1uPiNGVlabo1ls8sRxRLJax4FN5d1E50FmH0fTvnRIHlZBrOtkAkwxNrAL2jfFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tc/J/+f2; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tc/J/+f2"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a4715991c32so615784966b.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 11:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713293644; x=1713898444; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KP12xynkO/z/PwrnABbZ/fJSFteQnEUCK8gSBFnJWw=;
        b=Tc/J/+f2+EUuVA3BbiczI4AxcqSAqINThupMgEy9G/0U3G4bnTkQ0pwKSNPFXOA4SU
         OmWYLRxc3HJccBKpQ3+9re4feno8WBOCSJaGgX5WG0OA909/QaC97r/9V4EXhvEAZs0T
         tlOzVj9urcM/aB+iPvpy358ya2ZiCeSRlm66OUDPK4aHDZbp5maGydciGzez7r5zo41k
         zWx5Kn/RPQPct0bXbKkTwlwx57vrCpUS9E0mv6Sbud6UkQOEPd/Y4cIXM2sKmim/ghG7
         Y9ibhG/aB3BsUw2pdqLB8pba2EaLW5JEBUotPK/nMb5sueM+0YSoORHCmnBCC9PMiYha
         qdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293644; x=1713898444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KP12xynkO/z/PwrnABbZ/fJSFteQnEUCK8gSBFnJWw=;
        b=gsEElG3Gv7R79eWuKkfa0wohB8VBba14AMHX2peHtD7PrvrnHpquD3bxdLNL9MOe1m
         NKmvtWBWNgBBzGwtGOodgTJZ8Znco/nqHoDyCMHoNOiw8klHIOpspfYmGZefIcSX06Ix
         tkdS5wBpjgLrJ3PBcwc6gU6DQkgpUiYI3ym8UqXcpYJJYg/QxUF1rqMAyVa5o8ut/E12
         hOHDl+IZniApKDa7/574CpYuw6s/mmKtAGiDwlH6VRNhHVBMUUtiuh0NF00o97ALgwlR
         t48p1K0A92Q3rFlKwH0Ir01rvVdYEj7m6iKPr3KhDTr9z4YuWXHcfV8+Oo3ojMsZVzrz
         7UhA==
X-Gm-Message-State: AOJu0YyvVRR9MRBLbe3J0TUbXVlWa9L/ltm9dH2+RgTA8jjqGlDZv/L7
	VKqZ3Ccr79m9igEEfvT0pP71LpppPfvBqSXFih+DBBG9BqB975JbFdmEb+H1ISo=
X-Google-Smtp-Source: AGHT+IESu6Pds9jNrG7S1GlLEWDn1ti42HqHMeJdZr4Yl+Jla0c8doIoG5FAd+0EpcTcOquWjdWIiA==
X-Received: by 2002:a17:906:3a85:b0:a51:fa56:4fc7 with SMTP id y5-20020a1709063a8500b00a51fa564fc7mr8573920ejd.21.1713293643706;
        Tue, 16 Apr 2024 11:54:03 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id bw21-20020a170906c1d500b00a5242e285aesm5293377ejb.184.2024.04.16.11.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 11:54:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v2 2/2] multipath-tools tests: fix CI failures with clang on Fedora Rawhide
Date: Tue, 16 Apr 2024 20:53:51 +0200
Message-ID: <20240416185351.30670-3-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416185351.30670-1-mwilck@suse.com>
References: <20240416185351.30670-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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
index b0a4d83..7e43420 100644
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

