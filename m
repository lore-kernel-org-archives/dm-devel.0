Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAB03AF643
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468292; cv=none; b=EZL04UcSFCuikssC5cjbNhb7wQLar5gqr686hZ+6fm+Cf2k1iIb9tPgle/gJx4pT2JAJsnbZ7A9PnsQGeHOjobQIdPSn36MxEtiIoDWqt5/0se1zydudaLo+G37VEHyAgGWcDEI/bFANAct4PmDywU7IzcxIX3mP12pHMGib4cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468292; c=relaxed/simple;
	bh=ym2UBYpOV8cVLmPutzvgIUVurmFvSI2CD3rqt0F2H7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJt94mBC+Ya07gN2GRkliQY24OZrkWp/m5MjzN99i094bkwZiw2bX/IVwiCdznFTWJp3ffeVpbmg9eT3zRLn4CERrLKyfdGiBN5WRqwl0MWM/JOaPvQA+puGugFZzQnMcQSPutECWsNhpVSG/Zdbp6f/w+ct9i58/MXjYdCbmCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E+9F9N/0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E+9F9N/0"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so13201845e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468286; x=1780073086; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eXnf85ip145qwYDQreHB73+m6+MZphLuVdN282ULZ0=;
        b=E+9F9N/0lBwJACdcMJ3cMX47Rh/gPEh4cxKIxL/zGzwi/r6lnuvCgt9Yvu12rScZDf
         P8w7/wxww2vlLlgDVNk9nIRroR8AG102cqVv3jDObnETQCHW2l47i9Gk3GSwCjZsJ/98
         buhVo4amb143ajPwhYGGq0UbtsZw8d87CC7IxY9vS/zYFxUqJgXXG7Ay1d4WUm5iu0Q4
         vYZcmHbn+7IIR5nxEslyTq9ZKkcnnAzcL7JGDrTAY1YBlOQU4zlekIsAHUyHpp9PnxAv
         XltA15xgYQHWP3CkAfpcTDkA4Wxpmfx/N1xgptFhLMkNM1WBvf4D/N7PRcjH+Ey8G6/a
         LtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468286; x=1780073086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8eXnf85ip145qwYDQreHB73+m6+MZphLuVdN282ULZ0=;
        b=g4QPeHtKe0U/3N9eakXiyfhW1aoahDPPwtTdaa3gCzQdlxDmVWLiXDY2i4DMvMwuS8
         b7H5TDJTZSz6pwaso2eiW7mg0fBUaojDaa6Vjmwjhlxm+rT2IKrN0w/AmjjT2wx/4riT
         c1bwU/l9ZyuHsuO16UCwvyx0qUoFSal01dGRZeM/81rKU+/HKaAHddjA1u/7iQ+71HNj
         iJgjeu/iuAsWiImi4bmP9z6qdoQGSBQxL3zi53UPUE9KmN5E04rY+mcPYJE83JIP4fC7
         Yc8Z4J7B617YXilvgk/kDDnMZu+ISq0nk/OV4FkYYOEVM7KB0ZS5ZIJz5Ectw2Cjzb3V
         jcdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ifHmEAuRZz2gdJ/MM9eNevN1VXUGguD5swsHe3edGGsl2gtWLH3YnB1kDxi5ey6x2W+OrSuVZ0w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyzm4FufQ0XE4v2EyFFGNpRV6nXvBRiZJDj7mgijfwcNc4iybe2
	g80G+WdrZ2qcj8Q6bA0Sk9vDaSKIiumCGKPFmXDNfFzaE7peIVT0QK296SsCQ4X2xwls5L9N2g4
	fUKQRWjU=
X-Gm-Gg: Acq92OFtHwd9sTH4r3znE+wQYcv+ES8CqP75ge37qkdR/ckZ+Ee2dTNzFr1FDDPGbRw
	14A2SxQ30Imwiy0O8HMhr8PzR/TtnXDgr757kLyW0GXb/p0adj7VkL3pJuF2oJ3G6h4RrhtM4DB
	r0S9loMN1UC51eh0c60AC/Ld17oIEQPeCFI8V1ydigmsfczjlCnxA2ucJkBVQD6mSazOVxBSCeV
	wAbmGf7l7fEzeG0fOiKm/RTBQ8ogcIU6yDyfY9EcWdzPC7HMI/Tu2YRzn53NQ9a+ZqGDTLjmPvr
	AYkRL+7U+sZk8PlCinGcnVZUJKTQ4hXqPo4lGSq7hREuX+1FlXmOHZhFl3nFi4M+FD9I/JxLymr
	Thi6TteE5JcyC7t99uu7vQtmM65pJS8RP6Poz9vqWGgKR8uNMVsB/6wtmDRP0KneMJob042l+DI
	pfBw0KRZ8ehO/a6SwknpFJn9qg395m4veuUf9aA8ifwMuyVWPitGGDwuFDRqIwB4VV5QfJ8MZb1
	5XqpE4esjaPP4a7B/WOR6D+
X-Received: by 2002:a05:600c:c1c8:10b0:48f:d5d7:df89 with SMTP id 5b1f17b1804b1-490426d9906mr48770605e9.25.1779468286218;
        Fri, 22 May 2026 09:44:46 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904527dbf3sm50073995e9.6.2026.05.22.09.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/19] multipath-tools tests: add tests for shared pointer code
Date: Fri, 22 May 2026 18:44:01 +0200
Message-ID: <20260522164415.846589-6-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a few tests (mostly meaningful with valgrind or ASAN) to test the
shared pointer code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile     |   4 +-
 tests/shared_ptr.c | 120 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 tests/shared_ptr.c

diff --git a/tests/Makefile b/tests/Makefile
index f0e5dd3..fc2a7ed 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -9,7 +9,8 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter -Wno-unused-function $(W_MISSING_I
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo runner
+	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo runner \
+	 shared_ptr
 HELPERS := test-lib.o test-log.o
 
 .PRECIOUS: $(TESTS:%=%-test)
@@ -66,6 +67,7 @@ features-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
 cli-test_OBJDEPS := $(daemondir)/cli.o
 mapinfo-test_LIBDEPS = -lpthread -ldevmapper
 runner-test_LIBDEPS = -lpthread
+shared_ptr-test_LIBDEPS = -lpthread
 
 %.o: %.c
 	@echo building $@ because of $?
diff --git a/tests/shared_ptr.c b/tests/shared_ptr.c
new file mode 100644
index 0000000..2194ddd
--- /dev/null
+++ b/tests/shared_ptr.c
@@ -0,0 +1,120 @@
+#include <inttypes.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <pthread.h>
+#include <urcu/uatomic.h>
+#include "cmocka-compat.h"
+#include "util.h"
+#include "globals.c"
+
+struct s_4 {
+	uint32_t val;
+};
+
+struct s_8 {
+	char pad[4];
+	uint32_t val;
+};
+
+struct s_64 {
+	char pad[60];
+	uint32_t val;
+};
+
+// clang-format off
+#define make_destruct(n, size)	     \
+static void destruct_ ## n ## _ ## size(void *ptr) \
+{						  \
+	struct s_##size *s = ptr;		  \
+						  \
+	assert_ptr_not_equal(ptr, NULL);	  \
+	assert_int_equal(s->val, n);		  \
+}
+
+#define make_fn(size) \
+static void *thread_##size(void *arg)		\
+{						\
+	struct s_##size *s = arg;		\
+						\
+	get_shared_ptr(s);			\
+	uatomic_add(&s->val, 1);		\
+	put_shared_ptr(s);			\
+	return NULL;				\
+}
+
+make_fn(4)
+make_fn(8)
+make_fn(64)
+
+#define make_test(n, size)					\
+make_destruct(n, size)						\
+								\
+static void test_ ## n ## _ ## size(void **state)		\
+{								\
+	pthread_attr_t attr;					\
+	pthread_t threads[n];					\
+	struct s_##size *s;					\
+	int i, rc;						\
+								\
+	rc = pthread_attr_init(&attr);				\
+	assert_int_equal(rc, 0);				\
+	rc = pthread_attr_setstacksize(&attr,			\
+			PTHREAD_STACK_MIN + 4096);		\
+	assert_int_equal(rc, 0);				\
+	s = alloc_shared_ptr(size, destruct_ ## n## _ ## size);	\
+	assert_ptr_not_equal(s, NULL);				\
+	s->val = 0;						\
+	for (i = 0; i < n; i++) {				\
+		rc = pthread_create(&threads[i], &attr,		\
+				    thread_##size, s);		\
+		assert_int_equal(rc, 0);			\
+	}							\
+	pthread_attr_destroy(&attr);				\
+	for (i = 0; i < n; i++) {				\
+		rc = pthread_join(threads[i], NULL);		\
+		assert_int_equal(rc, 0);			\
+	}							\
+	assert_int_equal(uatomic_read(&s->val), n);		\
+	put_shared_ptr(s);					\
+}
+
+make_test(0, 4)
+make_test(100, 4)
+make_test(1000, 4)
+make_test(0, 8)
+make_test(100, 8)
+make_test(1000, 8)
+make_test(0, 64)
+make_test(100, 64)
+make_test(1000, 64)
+	// clang-format on
+
+	int test_shared_ptr(void)
+{
+	// clang-format off
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_0_4),
+		cmocka_unit_test(test_100_4),
+		cmocka_unit_test(test_1000_4),
+		cmocka_unit_test(test_0_8),
+		cmocka_unit_test(test_100_8),
+		cmocka_unit_test(test_1000_8),
+		cmocka_unit_test(test_0_64),
+		cmocka_unit_test(test_100_64),
+		cmocka_unit_test(test_1000_64),
+	};
+	// clang-format on
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(-1);
+	ret += test_shared_ptr();
+	return ret;
+}
-- 
2.54.0

