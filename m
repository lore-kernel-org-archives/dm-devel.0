Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51729137748
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293647; cv=none; b=WABMjIhvjbgNRnuiIn/1lOs/J/ek5yKdxQp4hgp0h6byktrtT+Hw4VI+xRnHf/cSHqYzIQ1Stk2zlCjqausH8/daDRzAKoP19Z5e8WWuHM9Q7+VIUYinE9tJyvdSyNivh6P6bKdJXU455Qf/0m5xYP/3w5l59QHn90znukaqtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293647; c=relaxed/simple;
	bh=eKFv9h+yPEfAA6tv/lK1CROfmNnrEW+0ka/0hUvvVqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv2O4YNi6ZdcSiqn3M8ti40yHWa0ymOatZScTOk1M23CfvMI/OB0MSYJjWbpQhafsE60Wlk9g1h8Gh+n8msMhwrtQzw1xPC50bcNErp5iK7ngbrLjgHflMzoax4ZFbIgkAOC5QH29L0Csbs6eWE9THmilczxKwdWTRzjv+l3IKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X5SfkZRK; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X5SfkZRK"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e1bbdb362so5251368a12.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 11:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713293642; x=1713898442; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=951K15BIYW6lcnuujbMJ/8rk/0uy0PhJmao36unuogY=;
        b=X5SfkZRKWKg1NYFi0VnNxgG/zG0QrU5mZozcC2cM6mGkJu8V9fqGGUrMWBsk4CUyHc
         P9JCgDPQN8Ut8Ke+GdenBBJ1q30IxoYsm9ntJ6Ti6TlT15PSY0bf/5GfSc0vRvoSB0bm
         GIFpdbrUaReiGyl9vLLWKCI2rtxsFSRJqpoIFVpMzyeEH1pukkeVfOvH43ijUVuSdrgw
         AE1bn2bzKzbOJkdz0OQIOee0xETJK0Ts/SkbjRnaPt4U/AeXo/1EbvmvHmmOTjUukQGq
         KChWmbmPvvy4L94XSxldaIK293AHX5L/rdJw8s2HN4tBJM8MrFxG5BlEKR/iOu84oG0D
         Rsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293642; x=1713898442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=951K15BIYW6lcnuujbMJ/8rk/0uy0PhJmao36unuogY=;
        b=URSAg7o1zkBK3YzKApBKmrGrhX+rHhg7fZjb0CglixGcAXIA/vUaFigvsoziIWxTW4
         wn6KXLJeqy38xip6dG6TiUsg3NFwkX6kgPKAHFihPAxvYagFfTfG1eA0CH4A67uxEZSk
         aWRlrNVdQqPnPpKW4V4DlG65fvTRX5D7C79RY3fwWuGUNwUq+Lcv5q3oNRLxGe71dbuG
         Z21MjpTQtvYt7xu2UoZ+JuuqD7lPAq+RDZOqx2Y/C2DgQqeW20TZyjggU78BzGx3CnEy
         cSPmjgHF/RrwwuWGNkc94vYTQS9+i87+4I4l8cGQC9u8zOOJbiCfkmJBWeYkWvUw+P2n
         bGcw==
X-Gm-Message-State: AOJu0Yx0MqFuDTX9OlFNqhbzhD3QYTIYnKKTqmLaRl2Ixm5Ydc3ao9lA
	oUyyvzM1/WELRV5qgACHkKhRNhIASf3r7+V43YVP8lR++ajkFP55vTusXEiKA2k=
X-Google-Smtp-Source: AGHT+IFS8MlDRG+czLQvRzkCHlBQhRlYfpBGG6ZB/cDbBn24vg+LfCamqtcDe54hTQaGiSXqjaFipg==
X-Received: by 2002:a50:8754:0:b0:56b:cecb:a4c8 with SMTP id 20-20020a508754000000b0056bcecba4c8mr12694600edv.39.1713293642605;
        Tue, 16 Apr 2024 11:54:02 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id ij5-20020a056402158500b0056e598155fasm6239502edb.64.2024.04.16.11.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 11:54:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v2 1/2] multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37
Date: Tue, 16 Apr 2024 20:53:50 +0200
Message-ID: <20240416185351.30670-2-mwilck@suse.com>
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

glibc 2.37 has added several new wrappers around the ioctl and
io_getevents system calls on 32 bit systems, to deal with 64bit
time_t. These aren't resolved with cmocka's wrapping technique.

Fix this with C preprocessor trickery, similar to
7b217f8 ("multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64").

Note: the directio test with DIO_TEST_DEV for fails under qemu-linux-user
with foreign-arch binfmt, because aio-related system calls are unsupported
by qemu-linux-user. See https://gitlab.com/qemu-project/qemu/-/issues/210.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/directio.c | 28 ++++++++++++++--------------
 tests/vpd.c      | 35 ++++++++++++++++++-----------------
 tests/wrap64.h   | 25 ++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/tests/directio.c b/tests/directio.c
index cbedcc9..d5f84f1 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -41,13 +41,13 @@ struct timespec full_timeout = { .tv_sec = -1 };
 #define ioctl_request_t int
 #endif
 
-int __real_ioctl(int fd, ioctl_request_t request, void *argp);
+int REAL_IOCTL(int fd, ioctl_request_t request, void *argp);
 
-int __wrap_ioctl(int fd, ioctl_request_t request, void *argp)
+int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
 {
 #ifdef DIO_TEST_DEV
 	mock_type(int);
-	return __real_ioctl(fd, request, argp);
+	return REAL_IOCTL(fd, request, argp);
 #else
 	int *blocksize = (int *)argp;
 
@@ -148,10 +148,10 @@ int __wrap_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt)
 #endif
 }
 
-int __real_io_getevents(io_context_t ctx, long min_nr, long nr,
+int REAL_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 			struct io_event *events, struct timespec *timeout);
 
-int __wrap_io_getevents(io_context_t ctx, long min_nr, long nr,
+int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 			struct io_event *events, struct timespec *timeout)
 {
 	int nr_evs;
@@ -169,8 +169,8 @@ int __wrap_io_getevents(io_context_t ctx, long min_nr, long nr,
 #ifdef DIO_TEST_DEV
 	mock_ptr_type(struct timespec *);
 	mock_ptr_type(struct io_event *);
-	assert_int_equal(nr_evs, __real_io_getevents(ctx, min_nr, nr_evs,
-						     events, timeout));
+	assert_int_equal(nr_evs, REAL_IO_GETEVENTS(ctx, min_nr, nr_evs,
+						   events, timeout));
 #else
 	sleep_tmo = mock_ptr_type(struct timespec *);
 	if (sleep_tmo) {
@@ -193,7 +193,7 @@ int __wrap_io_getevents(io_context_t ctx, long min_nr, long nr,
 
 static void return_io_getevents_none(void)
 {
-	will_return(__wrap_io_getevents, 0);
+	wrap_will_return(WRAP_IO_GETEVENTS, 0);
 }
 
 static void return_io_getevents_nr(struct timespec *ts, int nr,
@@ -207,15 +207,15 @@ static void return_io_getevents_nr(struct timespec *ts, int nr,
 			mock_events[i + ev_off].res = reqs[i]->blksize;
 	}
 	while (nr > 0) {
-		will_return(__wrap_io_getevents, (nr > 128)? 128 : nr);
-		will_return(__wrap_io_getevents, ts);
-		will_return(__wrap_io_getevents, &mock_events[off + ev_off]);
+		wrap_will_return(WRAP_IO_GETEVENTS, (nr > 128)? 128 : nr);
+		wrap_will_return(WRAP_IO_GETEVENTS, ts);
+		wrap_will_return(WRAP_IO_GETEVENTS, &mock_events[off + ev_off]);
 		ts = NULL;
 		off += 128;
 		nr -= 128;
 	}
 	if (nr == 0)
-		will_return(__wrap_io_getevents, 0);
+		wrap_will_return(WRAP_IO_GETEVENTS, 0);
 	ev_off += i;
 }
 
@@ -251,7 +251,7 @@ static void do_libcheck_init(struct checker *c, int blocksize,
 	struct directio_context * ct;
 
 	c->fd = test_fd;
-	will_return(__wrap_ioctl, blocksize);
+	wrap_will_return(WRAP_IOCTL, blocksize);
 	assert_int_equal(libcheck_init(c), 0);
 	ct = (struct directio_context *)c->context;
 	assert_non_null(ct);
@@ -762,7 +762,7 @@ int main(void)
 {
 	int ret = 0;
 
-	init_test_verbosity(2);
+	init_test_verbosity(5);
 	ret += test_directio();
 	return ret;
 }
diff --git a/tests/vpd.c b/tests/vpd.c
index 1b2d62d..e3212e6 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -20,6 +20,7 @@
 #include "vector.h"
 #include "structs.h"
 #include "discovery.h"
+#include "wrap64.h"
 #include "globals.c"
 
 #define VPD_BUFSIZ 4096
@@ -58,7 +59,7 @@ static const char vendor_id[] = "Linux";
 static const char test_id[] =
 	"A123456789AbcDefB123456789AbcDefC123456789AbcDefD123456789AbcDef";
 
-int __wrap_ioctl(int fd, unsigned long request, void *param)
+int WRAP_IOCTL(int fd, unsigned long request, void *param)
 {
 	int len;
 	struct sg_io_hdr *io_hdr;
@@ -428,8 +429,8 @@ static void test_vpd_vnd_ ## len ## _ ## wlen(void **state)             \
 	/* Replace spaces, like code under test */			\
 	exp_subst = subst_spaces(exp_wwid);				\
 	free(exp_wwid);							\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_vnd_" #len "_" #wlen,		\
 			    exp_len, ret, '1', 0, false,		\
@@ -458,8 +459,8 @@ static void test_vpd_str_ ## typ ## _ ## len ## _ ## wlen(void **state) \
 		exp_len--;						\
 	if (exp_len >= wlen)						\
 		exp_len = wlen - 1;					\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_str_" #typ "_" #len "_" #wlen,	\
 			    exp_len, ret, byte0[type], 0,		\
@@ -495,8 +496,8 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
 									\
 	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id,	\
 			 3, naa, 0);					\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_naa_" #naa "_" #wlen,		\
 			    exp_len, ret, '3', '0' + naa, true,		\
@@ -518,8 +519,8 @@ static void test_vpd_naa_##NAA##_badlen_##BAD(void **state)	\
 	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 3, NAA, 0); \
 									\
 	vt->vpdbuf[7] = BAD;						\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
 	assert_int_equal(-ret, -ERR);					\
 }
@@ -545,11 +546,11 @@ static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
 		/* overwrite the page size to DEFAULT_SGIO_LEN + 1 */	\
 		put_unaligned_be16(255, vt->vpdbuf + 2);		\
 		/* this causes get_vpd_sgio to do a second ioctl */	\
-		will_return(__wrap_ioctl, n);				\
-		will_return(__wrap_ioctl, vt->vpdbuf);			\
+		wrap_will_return(WRAP_IOCTL, n);			\
+		wrap_will_return(WRAP_IOCTL, vt->vpdbuf);		\
 	}								\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd_eui_" #len "_" #wlen "_" #sml,	\
 			    exp_len, ret, '2', 0, true,			\
@@ -571,8 +572,8 @@ static void test_vpd_eui_badlen_##LEN##_##BAD(void **state)	\
 	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 2, 0, LEN); \
 									\
 	vt->vpdbuf[7] = BAD;						\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
 	assert_int_equal(ret, ERR);					\
 	if (ERR >= 0)							\
@@ -600,8 +601,8 @@ static void test_vpd80_ ## size ## _ ## len ## _ ## wlen(void **state)  \
 		exp_len = wlen - 1;					\
 	n = create_vpd80(vt->vpdbuf, sizeof(vt->vpdbuf), input,		\
 			 size, len);					\
-	will_return(__wrap_ioctl, n);					\
-	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	wrap_will_return(WRAP_IOCTL, n);				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
 	ret = get_vpd_sgio(10, 0x80, 0, vt->wwid, wlen);		\
 	assert_correct_wwid("test_vpd80_" #size "_" #len "_" #wlen,	\
 			    exp_len, ret, 0, 0, false,			\
diff --git a/tests/wrap64.h b/tests/wrap64.h
index 8c91d27..b0a4d83 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -1,5 +1,7 @@
 #ifndef _WRAP64_H
 #define _WRAP64_H 1
+#include <syscall.h>
+#include <linux/types.h>
 #include "util.h"
 
 /*
@@ -31,7 +33,9 @@
  * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
  * https://savannah.gnu.org/forum/forum.php?forum_id=9205
  */
-#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#define WRAP_FCNTL_NAME __fcntl_time64
+#elif defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
 #define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
 #else
 #define WRAP_FCNTL_NAME fcntl
@@ -39,6 +43,25 @@
 #define WRAP_FCNTL CONCAT2(__wrap_, WRAP_FCNTL_NAME)
 #define REAL_FCNTL CONCAT2(__real_, WRAP_FCNTL_NAME)
 
+/*
+ * glibc 2.37 uses __ioctl_time64 for ioctl
+ */
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#define WRAP_IOCTL_NAME __ioctl_time64
+#else
+#define WRAP_IOCTL_NAME ioctl
+#endif
+#define WRAP_IOCTL CONCAT2(__wrap_, WRAP_IOCTL_NAME)
+#define REAL_IOCTL CONCAT2(__real_, WRAP_IOCTL_NAME)
+
+#if defined(__NR_io_pgetevents) && __BITS_PER_LONG == 32 && defined(_TIME_BITS) && _TIME_BITS == 64
+#define WRAP_IO_GETEVENTS_NAME io_getevents_time64
+#else
+#define WRAP_IO_GETEVENTS_NAME io_getevents
+#endif
+#define WRAP_IO_GETEVENTS CONCAT2(__wrap_, WRAP_IO_GETEVENTS_NAME)
+#define REAL_IO_GETEVENTS CONCAT2(__real_, WRAP_IO_GETEVENTS_NAME)
+
 /*
  * will_return() is itself a macro that uses CPP "stringizing". We need a
  * macro indirection to make sure the *value* of WRAP_FUNC() is stringized
-- 
2.44.0

