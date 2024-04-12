Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC95E53378
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914397; cv=none; b=ENTUo9S+coik1Q3VzNZNHM8H1sDl7eWhjvtuCtvX+0CQyWhNWozbY1IO7trbx1vtPFpqqD2MKnmpzbf8jh8rZEw3CYTzxvPdSkfksk/Y4xwTelz9YYL+AIREInl8WLRsTMN4ZVOyiPrAO7uLf13KCz+g/K1ApUAPzI6bto1ubE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914397; c=relaxed/simple;
	bh=d1pwQXatpuek1ghjv9QAIhuS1zlhLF58gPE64sFXZ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9LSJ2ozL0/EQo49PKB0PAZUkWYbKvB6oVYHOoyeqF/ghH3vnycuQ1v4IkQzrti35IY79jAeWQ5yWBmIZ+2AjFqq7Rj7YPRnoetcTx86IGRWyAaiYBbQSFjR+iqWpERJqBZyWFKuq2kaaUldxDDMsJaSm1yvXEqIyxzG6cyc448=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BTrhKxni; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BTrhKxni"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41551500a7eso5030715e9.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712914393; x=1713519193; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duYBR9AuWDsKu3xpXoQgQvw3BcMZ2ppWsuLjU/1FzDE=;
        b=BTrhKxniEkvgSPMdBBYOnwDmLb1XRVLK9ygtaEdXcF63cf2fJIqLdM9XOe0ihmDPXh
         Ud/kVBM2QIAfK5uaKCm2ICNJCxxSAeJMcvz7GWm6nrS56AwFmGyBFFFH1iT8j+iGBF5X
         ML0PUDyxDkQ78bHHY7dOK6AuNrdXnuI3kz0lat+3QXa4/uVoThJZv5/xCjr3TnmNALzw
         aUNBWMSzM496t7owEo0YVAxjmpN6/rL9eXmw+d8pBDUvFbbXSo4lHGpqJj2rQSCIqAT8
         nhmKFh4Drwdl2hfndIZ210KrikkyqSElM6PgTOa84Soe5tJKOBJcX7z1LTSnRXaaAZbr
         Gapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712914393; x=1713519193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duYBR9AuWDsKu3xpXoQgQvw3BcMZ2ppWsuLjU/1FzDE=;
        b=ZCmJa/yBfCmAEiVXMIZRv1Poh3Cu1IFaSNuiDaiuVlY8f9K1oMFbIUci1D4cJH6oAJ
         3PySIIVw29UXHQm3TqJF2fDLFrPMNq+L7rLXPuOcQlXhiFBLaAoM3d9FPHPZ19SV7qe+
         N5aTQ7LD7XoruK48O3zzLZGBQIzHZAhqcY1z37Uc42eTsZSZYYpVeDKsbkTkVjpCtNfU
         Bnaxhap/q+1G7G28A56axhCdcsFVJKzW7vF7kX1pVXwqTexG/PpTXdW/6IHpEjdY4phb
         /aH6c7BGwcCH0QQ7wV2yLzgW26CWszM8k/ynVvMufqQvF00vUEX5tDtpT/D7jcP2LZrf
         ZkmA==
X-Gm-Message-State: AOJu0YwJ27x6tVfME1vwIud9C7xJCZ5DA6HIY945aT7hjfYipBOTikza
	aULAqZbNSXJzMgw/UXgBiHrNgLSVqkuiN5qcLBr1g6fFTVgwc6nFItK3iSpbhjTFuJeXO44dE/7
	f
X-Google-Smtp-Source: AGHT+IFzkRfcoUA9oN8YOld+9LAgken6JI+2rKLY+tth1DbxUQEnVfDC7R3Dd0cog79T6mj1FTc0EA==
X-Received: by 2002:a05:600c:4f44:b0:413:3941:d9ae with SMTP id m4-20020a05600c4f4400b004133941d9aemr1666852wmq.31.1712914393242;
        Fri, 12 Apr 2024 02:33:13 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id h8-20020a05600c350800b0041488978873sm8220327wmq.44.2024.04.12.02.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 02:33:13 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/2] multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37
Date: Fri, 12 Apr 2024 11:32:57 +0200
Message-ID: <20240412093258.20037-2-mwilck@suse.com>
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

glibc 2.37 has added several new wrappers around the ioctl and
io_getevents system calls on 32 bit systems, to deal with 64bit
time_t. These aren't resolved with cmocka's wrapping technique.

Fix this with C preprocessor trickery, similar to
7b217f8 ("multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64").

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/directio.c | 22 +++++++++++-----------
 tests/vpd.c      | 35 ++++++++++++++++++-----------------
 tests/wrap64.h   | 23 ++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 29 deletions(-)

diff --git a/tests/directio.c b/tests/directio.c
index cbedcc9..a5a5c0e 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -41,9 +41,9 @@ struct timespec full_timeout = { .tv_sec = -1 };
 #define ioctl_request_t int
 #endif
 
-int __real_ioctl(int fd, ioctl_request_t request, void *argp);
+int REAL_IOCTL(int fd, ioctl_request_t request, void *argp);
 
-int __wrap_ioctl(int fd, ioctl_request_t request, void *argp)
+int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
 {
 #ifdef DIO_TEST_DEV
 	mock_type(int);
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
index 8c91d27..6b92751 100644
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
@@ -39,6 +43,23 @@
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
+
+#if defined(__NR_io_pgetevents) && __BITS_PER_LONG == 32 && defined(_TIME_BITS) && _TIME_BITS == 64
+#define WRAP_IO_GETEVENTS_NAME io_getevents_time64
+#else
+#define WRAP_IO_GETEVENTS_NAME io_getevents
+#endif
+#define WRAP_IO_GETEVENTS CONCAT2(__wrap_, WRAP_IO_GETEVENTS_NAME)
+
 /*
  * will_return() is itself a macro that uses CPP "stringizing". We need a
  * macro indirection to make sure the *value* of WRAP_FUNC() is stringized
-- 
2.44.0

