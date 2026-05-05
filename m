Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF948AE15
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995834; cv=none; b=ZZ853c67S94B7eKlS3y2yMTSpc5PiLTFwucJ47nqpHr6OfMM1B9q5h+dTsAp7ttUIQuLWR32/oy63xTgcVI+598pqD+EF2INXOF6EC0iFmbtUVEjHeFRBQtsOrfgCFyz/hFajJebbT5rDig4426G0It5oPyTio/+ba3mqSL6huE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995834; c=relaxed/simple;
	bh=/Mm7trq/mT8DD8mntXQf2PbfFAzyfDeIG7vGXSgKRbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY5x8zYnIVVBzfyMDerw172ZxbBdPVAZUSVCI6Dg1a6VoFHntFLo/2kqEjnkCxX1nvbjlgYfM3WJGxPHGmYZB4GBef+aaOO+qq32fWRwsZWbPUAXIP/gH1LEFPq05N2Rev8AfrG6UdZeZ3xGu+0H1iCtVq8PfpgySx92yHtmBZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZVqeQVDz; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZVqeQVDz"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso66741155e9.1
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995831; x=1778600631; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOW7IJZ/qMozYgLb/ho7YQQV6uG38ZuVRnGrIhjpvT8=;
        b=ZVqeQVDzxc8iUz+5t+ABDRNaBMg8Y3L1YIFF3e2yFs9unxt3C3gjBO8uopYzLITXBO
         3v2UjMgmdC40No/G5IgTDK6ZYBajAros3H0MXseplNSL4UDtim2weQsQUDvqR7AxUnlP
         mlxey+0toBepUbXz6jCOEOvQ9CZoUpnpuaYV9UhfC2/vWYiiwjd2H4HATQuG1aBiW4E0
         A1lXWQEmzpkjgZSvCSXV/vaFafguK5SPsOfh4krv6Dn/GLI7ZDayFFm8hbXxN78JDj7S
         8ViscxSETUYJwobebbS+TiZbjSNAZZMa4mNBc/MZgZljAbBwx1te0KnHjkjS5yVIGs/q
         dvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995831; x=1778600631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NOW7IJZ/qMozYgLb/ho7YQQV6uG38ZuVRnGrIhjpvT8=;
        b=J1tqHMJEOf0lN1jxmrrBEIHz1kKk7aWm9PMMl6131mWtPjej6/rEoh17/4QJdcqoz+
         mM4+B7humDMX6Ym8aC0O3JH1DwJK/JALsd2TRfdnxkHxMPXhKVthbOFztnTNVflait9b
         +d6KcPNrkg7kzbdOzgsN7ytf9VP+LPBVnTrJi7p0iR2WSsJEnfYqp6PT9mYO5gz3fa9m
         swBlkDwK7hfGOqHZnBfIe0pvv4ebrcOCdrgx5cpQVFQFFzqzM5lMfuYJjmRwyuSDHSqM
         mP5G1sCO1OXtC2mbl/xlZHoi8J7Bw92gpjQ5CN+O/dD0GzoxE7i0+D7q/418E6dBSs/d
         W7fQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Dxf6zYyuax01q6cQ9iwh9wbcRHigfCCwFo8nc12sTXgPEHVcb5o00AqXpaUBd/W7Rr6lSW+jHew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6ElxlSRBObjWxm4HGTT2MB1hpWrlo/StTCKS1pgb2qPJ5q79d
	1VNAyvSDmX88xlnBc4I5DjiZaTxTT2GJac8lIl4eLV57KGSdiudbk+uOGs6P+xVF0ZE=
X-Gm-Gg: AeBDievGpXflna+yBlSYyAUOd95a5PyaGjJ2WDjroL8Uxu1hynOYEZXOR0UGZpsHD41
	+pd9SffPWVvm3KeptjhwwgvzIKGI1+rb8vVuZqf8sD2DecMRfQc94ohuISR8uSRZupLniAbxWOi
	XOMDPY5zhk/VWPS2P3oe0s3Nsg0HLiStsAUL+SfL1girwAt6UlIrMCtP2H9Wn12UEasnQ7cYj5H
	jHZeYoQ68GNFljjcvT+AlAq5q6YqeH/zTOXYROgeRvw2b/yA7hjUCgXMTsPuf2wq4cpXI4Dk2qM
	ZFL/AU9grBLK7OTCT7OP6eyzJj2VUr6QZOi2DDMsilT81C8wzSkp3E+vNaWJDRKBCDzG2pN/vii
	eQfGYn4Zjzdo6WiRxbZxbPmcjbcL5PkGXiXfrIMV+nIFQNiJoLtw3uKcvLQ4ReqljnP9CmNzDYw
	7lJ54i2ntgBxivlWTyPmCWmruQxqjgUsgaCQIjhxApNvPpUvObhxYhix836WoLnCPeOH9Z/lP4n
	C7ykgP+5AgIxWvLPnlnZ/Bo
X-Received: by 2002:a05:600c:c058:b0:48a:58ae:992f with SMTP id 5b1f17b1804b1-48a9865f831mr183619705e9.16.1777995830826;
        Tue, 05 May 2026 08:43:50 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48e510f10c0sm5472675e9.0.2026.05.05.08.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:49 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/18] multipath-tools tests: add tests for shared pointer code
Date: Tue,  5 May 2026 17:43:19 +0200
Message-ID: <20260505154332.448054-6-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
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
 tests/shared_ptr.c | 111 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 1 deletion(-)
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
index 0000000..ca5aa1a
--- /dev/null
+++ b/tests/shared_ptr.c
@@ -0,0 +1,111 @@
+#include <inttypes.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <pthread.h>
+#include "cmocka-compat.h"
+#include "util.h"
+
+#include "globals.c"
+
+struct s_8 {
+	uint64_t val;
+};
+
+struct s_4 {
+	uint32_t val;
+};
+
+struct s_2 {
+	uint16_t val;
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
+	s->val++;				\
+	put_shared_ptr(s);			\
+	return NULL;				\
+}
+
+make_fn(2)
+make_fn(4)
+make_fn(8)
+
+#define make_test(n, size)					\
+make_destruct(n, size)						\
+								\
+static void test_ ## n ## _ ## size(void **state)		\
+{								\
+	pthread_t threads[n];					\
+	struct s_##size *s;					\
+	int i, rc;						\
+								\
+	s = alloc_shared_ptr(size, destruct_ ## n## _ ## size);	\
+	assert_ptr_not_equal(s, NULL);				\
+	s->val = 0;						\
+	for (i = 0; i < n; i++) {				\
+		rc = pthread_create(&threads[i], NULL,		\
+				    thread_##size, s);		\
+		assert_int_equal(rc, 0);			\
+	}							\
+	for (i = 0; i < n; i++) {				\
+		rc = pthread_join(threads[i], NULL);		\
+		assert_int_equal(rc, 0);			\
+	}							\
+	assert_int_equal(s->val, n);				\
+	put_shared_ptr(s);					\
+}
+
+make_test(0, 2)
+make_test(0, 4)
+make_test(0, 8)
+make_test(100, 2)
+make_test(100, 4)
+make_test(100, 8)
+make_test(1000, 2)
+make_test(1000, 4)
+make_test(1000, 8)
+	// clang-format on
+
+	int test_shared_ptr(void)
+{
+	// clang-format off
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_0_2),
+		cmocka_unit_test(test_0_4),
+		cmocka_unit_test(test_0_8),
+		cmocka_unit_test(test_100_2),
+		cmocka_unit_test(test_100_4),
+		cmocka_unit_test(test_100_8),
+		cmocka_unit_test(test_1000_2),
+		cmocka_unit_test(test_1000_4),
+		cmocka_unit_test(test_1000_8),
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

