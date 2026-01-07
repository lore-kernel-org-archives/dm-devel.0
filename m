Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB9F339865
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817155; cv=none; b=kQ8lFLivUQ7GABbKpZQ5LYuwJAEeflF1wA7bQM4jcYgoz5tPHGOaYfmwYei49W6/8/9YVSHzHRVuG7ybP85UIMgSoIz/KM//c8Dm0Dph9WGRgcQhfG7i8s/Tg3/VvpHHxDrThhcBZKV2av7HJExEgU8qbVDwzhlH/PU2dWRY5n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817155; c=relaxed/simple;
	bh=Mn0s7lOKC2k2bcua2vf1TKjmvsI9b17VrxMSuJxre6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UL31r9zhY27oXOvT6wt/Henpp5kt1hZBgYeHwQqXO65NCF9GnKlYzYWM+g2fJtW3YenKbWq64PPj75D3IfXu/Luw8ufXzwxJkJMAMbqbXiSTZwcERFMPjF4edKj/gEjGnSACHseDrGrNIGqn85OCsR/M8HhMzX18ziNsVyO6Kvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GgR7rmPU; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GgR7rmPU"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso3794131a12.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817148; x=1768421948; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7uLpOFVh3wqN+PVGzFHkXbT0tKfgSzS2EIt6PleDpw=;
        b=GgR7rmPUw1b0w3gaM0ZIAE4jy1NOJH3/5UPTRqdhaUe0J2QWZE7Lc+HpLXwjaDNUtl
         gQEJti9f9mi4G0tpVm4P7K5/BdbfXuEuOX9AN/Pn57aQkXQxVe2rGtKkl6Up8aGXx+8t
         jMI8gMZ/MX1xAcXpX5PU7YloeEC1Jvzx1OYOJUnbPXGYylsRigyoqNV95JNcMNRyu7Z4
         LLBRD1NhnwtCE3MlPfiJ0npUj3iWbRRnaIn1byaSSk8aBkFqPVSIK/NBCTrjy4fqd5IW
         BfmbhHpVSyEakUaub2NrHHgoXwLAWZIykcrIqmQmSo84sQAaWJBzhGAAdBGSvJ1oYh40
         rDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817148; x=1768421948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y7uLpOFVh3wqN+PVGzFHkXbT0tKfgSzS2EIt6PleDpw=;
        b=pJhm6fFTiyZII1X69/WvajqdXDYI0ZWTSZgM9YqbHcTdUmXVptwPu5rNG3A4WrC47W
         ZNeXd1TXyrg98MD5dSdGClbiaQXlenkE6qwVceiuBPN0zqBAmFYUXT6B3TpHLePH/Gse
         +nkKfTawiEuWPXoba1gTf3JuH5KHmRwWP8Ao6Za6Xtp4EuhYinNVijlst1TjQh96iA2I
         5tLVndjODmKGVTXwG+bLB8imLJUtDybmC9iNru43QfjjQ8qor8NUMT1ZCu6O0XK65Sfh
         IvZ0xUzf/1ibb/FqdCMI0w9QMUjn0/HHoJGtDs8V6MTaqst4hcVkk4r5njMsmDx1x4bC
         hhUQ==
X-Gm-Message-State: AOJu0YwwBYGBaQ3MxAG4lwdmihDUSF6cBWbdAJ0/ov98RlGsPpRwV7/4
	Pk+EB3u+1UJRnarRuMnW7GlVl4+JlfPNJnOcY6RCpShSFLEMPbT1Pw1Gvi8zDDyrYEk=
X-Gm-Gg: AY/fxX5gI5a7kj5DxtFdr4Kk2Gagvg4+yzehfto01rRUyWrIavl+YHZLy+6Uy2X/wfY
	qTd2LA9mJUqlAuWURBuz6LrbHAI7litY3ts1R7Uke4gCTLTIk9pm3TXLYRuFTtbF6rnPD8YHWId
	hfPno6qdFLnHCxzZMN1/0TUY/KfT8Xyd9YHx5voobP3XLtUcBuA5+vxHscmI0niA6TDgeWRISel
	PLKlSefMrobhDS5posIlxaFLtL1rmgnk4hhdeUmHdtB2RgGtq2Je09yRH2d40jCB5nAscHOj2Mn
	XtZrOaq9nALD9MC7c1ZcVhTVUwBs/Lcd/PtjKq7hcy6ZcC2lZnR/s6PsQYy9SvRUwt732hoPoLA
	gpV5zsbOJ83YqebQ0jaYCgS6G/8eMMC28b1EPesmjpCtkXtlgy2r8zBDhUhyGOzo3+R6ryU6zcS
	3R7d+4Zv9dM9rGC84T35/TyCp0WLiHREuIEeQagMXbT1XavtizT4vWwxOsKRNv1SXKTMcx0n9wL
	g==
X-Google-Smtp-Source: AGHT+IEA6AXT448wjdrBGAoIo08oNMHryGHMMEN2be3bTD/nWbZB+X179joKFXAo9Y6k16GVLQJ42A==
X-Received: by 2002:a17:907:807:b0:b83:37eb:34f8 with SMTP id a640c23a62f3a-b844532ae51mr394899466b.35.1767817147943;
        Wed, 07 Jan 2026 12:19:07 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a5118e1sm601163666b.54.2026.01.07.12.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:07 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 26/26] multipath-tools tests: adaptations for cmocka 2.0
Date: Wed,  7 Jan 2026 21:18:26 +0100
Message-ID: <20260107201826.323977-27-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cmocka 2.0 has deprecated a number of previously defined functions
and macros, and introduced others instead. Adapt our tests to work with
both cmocka 1.1.x and 2.0.x.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/alias.c         |  50 +++++++++-------
 tests/blacklist.c     |   2 +-
 tests/cli.c           |   8 +--
 tests/cmocka-compat.h |  16 ++++++
 tests/devt.c          |   4 +-
 tests/directio.c      |  23 +++++---
 tests/dmevents.c      |  74 ++++++++++++------------
 tests/features.c      |   2 +-
 tests/hwtable.c       |   4 +-
 tests/mapinfo.c       |  85 +++++++++++++--------------
 tests/mpathvalid.c    |  16 +++---
 tests/parser.c        |   2 +-
 tests/pgpolicy.c      |   2 +-
 tests/strbuf.c        | 131 ++++++++++++++++++++++--------------------
 tests/sysfs.c         |  74 ++++++++++++------------
 tests/test-lib.c      |  88 ++++++++++++++--------------
 tests/test-log.c      |  10 ++--
 tests/uevent.c        |   2 +-
 tests/unaligned.c     |   8 +--
 tests/util.c          | 113 ++++++++++++++++++------------------
 tests/valid.c         |  30 +++++-----
 tests/vpd.c           |  12 ++--
 22 files changed, 396 insertions(+), 360 deletions(-)
 create mode 100644 tests/cmocka-compat.h

diff --git a/tests/alias.c b/tests/alias.c
index 163d9a7..faafcd2 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -2,7 +2,7 @@
 #include <stdint.h>
 #include <setjmp.h>
 #include <stdio.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "strbuf.h"
 #include "util.h"
 #include "alias.h"
@@ -59,9 +59,9 @@ ssize_t __wrap_write(int fd, const void *buf, size_t count)
 		start = (const char *)buf + sizeof(BINDINGS_FILE_HEADER) - 1;
 	else
 		start = buf;
-	binding = mock_ptr_type(char *);
+	binding = mock_ptr_type(const char *);
 	start = strstr(start, binding);
-	check_expected(count);
+	check_expected_uint(count);
 	assert_ptr_not_equal(start, NULL);
 	return set_errno__(mock_type(int));
 }
@@ -80,12 +80,12 @@ int __wrap_dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	int ret;
 
-	check_expected(name);
-	check_expected(uuid_len);
+	check_expected_ptr(name);
+	check_expected_int(uuid_len);
 	assert_non_null(uuid);
 	ret = mock_type(int);
 	if (ret == DMP_OK)
-		strcpy(uuid, mock_ptr_type(char *));
+		strcpy(uuid, mock_ptr_type(const char *));
 	return ret;
 }
 
@@ -389,7 +389,7 @@ static void sd_fd_many(void **state)
 
 	for (i = 1; i < 5000; i++) {
 		rc = format_devname__(buf, i, sizeof(buf), "MPATH");
-		assert_in_range(rc, 6, 8);
+		assert_int_in_range(rc, 6, 8);
 		rc = scan_devname(buf, "MPATH");
 		assert_int_equal(rc, i);
 	}
@@ -404,7 +404,7 @@ static void sd_fd_random(void **state)
 	for (i = 1; i < 1000; i++) {
 		n = random() & 0xffff;
 		rc = format_devname__(buf, n, sizeof(buf), "MPATH");
-		assert_in_range(rc, 6, 9);
+		assert_int_in_range(rc, 6, 9);
 		rc = scan_devname(buf, "MPATH");
 		assert_int_equal(rc, n);
 	}
@@ -437,14 +437,14 @@ static int test_scan_devname(void)
 static void mock_unused_alias(const char *alias)
 {
 	expect_string(__wrap_dm_get_wwid, name, alias);
-	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
+	expect_int_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
 	will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);
 }
 
 static void mock_self_alias(const char *alias, const char *wwid)
 {
 	expect_string(__wrap_dm_get_wwid, name, alias);
-	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
+	expect_int_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
 	will_return(__wrap_dm_get_wwid, DMP_OK);
 	will_return(__wrap_dm_get_wwid, wwid);
 }
@@ -470,14 +470,14 @@ static void mock_self_alias(const char *alias, const char *wwid)
 #define mock_failed_alias(alias, wwid)					\
 	do {								\
 		expect_string(__wrap_dm_get_wwid, name, alias);		\
-		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
+		expect_int_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
 		will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);		\
 	} while (0)
 
 #define mock_used_alias(alias, wwid)					\
 	do {								\
 		expect_string(__wrap_dm_get_wwid, name, alias);		\
-		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
+		expect_int_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
 		will_return(__wrap_dm_get_wwid, DMP_OK);		\
 		will_return(__wrap_dm_get_wwid, "WWID_USED");		\
 		expect_condlog(3, USED_STR(alias, wwid));		\
@@ -504,7 +504,7 @@ static void mock_bindings_file__(const char *content, bool conflict_ok)
 			continue;
 
 		rc = add_binding(&global_bindings, alias, wwid);
-		assert_in_set(rc, values, conflict_ok ? 2 : 1);
+		assert_int_in_set(rc, values, (conflict_ok ? 2 : 1));
 	}
 }
 
@@ -1260,7 +1260,8 @@ static void al_a(void **state)
 	static const char ln[] = "MPATHa WWIDa\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_rename, 0);
@@ -1279,7 +1280,8 @@ static void al_zz(void **state)
 	static const char ln[] = "MPATHzz WWIDzz\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_rename, 0);
@@ -1318,10 +1320,11 @@ static void al_write_partial(void **state)
 	static const char ln[] = "MPATHa WWIDa\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln) - 1);
-	expect_value(__wrap_write, count, 1);
+	expect_uint_value(__wrap_write, count, 1);
 	will_return(__wrap_write, ln + sizeof(ln) - 2);
 	will_return(__wrap_write, 1);
 	will_return(__wrap_rename, 0);
@@ -1340,10 +1343,11 @@ static void al_write_short(void **state)
 	static const char ln[] = "MPATHa WWIDa\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln) - 1);
-	expect_value(__wrap_write, count, 1);
+	expect_uint_value(__wrap_write, count, 1);
 	will_return(__wrap_write, ln + sizeof(ln) - 2);
 	will_return(__wrap_write, 0);
 	expect_condlog(2, "write_bindings_file: short write");
@@ -1360,7 +1364,8 @@ static void al_write_err(void **state)
 	static const char ln[] = "MPATHa WWIDa\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, -EPERM);
 	expect_condlog(1, "failed to write new bindings file");
@@ -1376,7 +1381,8 @@ static void al_rename_err(void **state)
 	static const char ln[] = "MPATHa WWIDa\n";
 	char *alias;
 
-	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
+	expect_uint_value(__wrap_write, count,
+			  strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_write, ln);
 	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
 	will_return(__wrap_rename, -EROFS);
@@ -1408,7 +1414,7 @@ static int test_allocate_binding(void)
 	do {								\
 		static const char ln[] = BINDING_STR(alias, wwid);	\
 									\
-		expect_value(__wrap_write, count,			\
+		expect_uint_value(__wrap_write, count,			\
 			     strlen(BINDINGS_FILE_HEADER) + (len) + strlen(ln)); \
 		will_return(__wrap_write, ln);				\
 		will_return(__wrap_write,				\
diff --git a/tests/blacklist.c b/tests/blacklist.c
index ab3da61..5bf2fd1 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -5,7 +5,7 @@
 #include <stdarg.h>
 #include <stddef.h>
 #include <setjmp.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "globals.c"
 #include "blacklist.h"
 #include "test-log.h"
diff --git a/tests/cli.c b/tests/cli.c
index 9e2ad3c..f008d26 100644
--- a/tests/cli.c
+++ b/tests/cli.c
@@ -8,7 +8,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 
 #include <errno.h>
 
@@ -49,7 +49,7 @@ static void client_test_##NAME(void **state)			\
 	assert_int_equal(get_cmdvec(cmd, &v, false), R);	\
 	if (R == 0) {						\
 		assert_ptr_not_equal(v, NULL);			\
-		assert_int_equal(fingerprint(v), FPR);		\
+		assert_uint_equal(fingerprint(v), FPR);		\
 		if (GOOD)					\
 			assert_ptr_not_equal(find_handler_for_cmdvec(v), NULL); \
 		else						\
@@ -73,7 +73,7 @@ static void client_param_##NAME(void **state)			\
 								\
 	assert_int_equal(get_cmdvec(cmd, &v, false), 0);	\
 	assert_ptr_not_equal(v, NULL);				\
-	assert_int_equal(fingerprint(v), FPR);			\
+	assert_uint_equal(fingerprint(v), FPR);			\
 	assert_ptr_not_equal(find_handler_for_cmdvec(v), NULL);	\
 	assert_string_equal(((struct key *)VECTOR_SLOT(v, 1))->param, PAR); \
 	free_keys(v);						\
@@ -95,7 +95,7 @@ static void client_2param_##NAME(void **state)			\
 								\
 	assert_int_equal(get_cmdvec(cmd, &v, false), 0);	\
 	assert_ptr_not_equal(v, NULL);				\
-	assert_int_equal(fingerprint(v), FPR);			\
+	assert_uint_equal(fingerprint(v), FPR);			\
 	assert_ptr_not_equal(find_handler_for_cmdvec(v), NULL);	\
 	assert_string_equal(((struct key *)VECTOR_SLOT(v, 1))->param, PAR1); \
 	assert_string_equal(((struct key *)VECTOR_SLOT(v, N))->param, PARN); \
diff --git a/tests/cmocka-compat.h b/tests/cmocka-compat.h
new file mode 100644
index 0000000..8ec6ed2
--- /dev/null
+++ b/tests/cmocka-compat.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2015 Martin Wilck, SUSE LLC
+ */
+#include <cmocka.h>
+
+#if CMOCKA_VERSION < 0x020000
+#define assert_int_in_range(x, low, high) assert_in_range(x, low, high)
+#define assert_uint_in_range(x, low, high) assert_in_range(x, low, high)
+#define assert_uint_equal(x, y) assert_int_equal(x, y)
+#define check_expected_int(x) check_expected(x)
+#define check_expected_uint(x) check_expected(x)
+#define expect_int_value(f, x, y) expect_value(f, x, y)
+#define expect_uint_value(f, x, y) expect_value(f, x, y)
+#define assert_int_in_set(x, vals, count) assert_in_set(x, vals, count)
+#endif
diff --git a/tests/devt.c b/tests/devt.c
index 32edf51..3b322df 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -8,7 +8,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "mt-udev-wrap.h"
 #include <sys/sysmacros.h>
 #include <fcntl.h>
@@ -173,7 +173,7 @@ static void test_devt2devname_real(void **state)
 	enm = udev_enumerate_new(udev);
 	assert_non_null(enm);
 	r = udev_enumerate_add_match_subsystem(enm, "block");
-	assert_in_range(r, 0, INT_MAX);
+	assert_int_in_range(r, 0, INT_MAX);
 	r = udev_enumerate_scan_devices(enm);
 	first = udev_enumerate_get_list_entry(enm);
 	udev_list_entry_foreach(item, first) {
diff --git a/tests/directio.c b/tests/directio.c
index 5344434..fa1e553 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -10,7 +10,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "wrap64.h"
 #include "globals.c"
 #include "../libmultipath/checkers/directio.c"
@@ -38,7 +38,7 @@ int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
 	int *blocksize = (int *)argp;
 
 	if (test_dev) {
-		mock_type(int);
+		(void)mock_type(int);
 		return REAL_IOCTL(fd, request, argp);
 	}
 
@@ -51,7 +51,12 @@ int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
 	 * BLKSZGET must be cast to "int" and back to "unsigned long",
 	 * otherwise the assertion below will fail.
 	 */
+#ifdef __GLIBC__
+	assert_uint_equal(request, (ioctl_request_t)BLKBSZGET);
+#else
 	assert_int_equal(request, (ioctl_request_t)BLKBSZGET);
+#endif
+
 	assert_non_null(blocksize);
 	*blocksize = mock_type(int);
 	return 0;
@@ -138,9 +143,9 @@ int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 			struct io_event *events, struct timespec *timeout)
 {
 	int nr_evs;
-	struct timespec *sleep_tmo;
+	const struct timespec *sleep_tmo;
 	int i;
-	struct io_event *evs;
+	const struct io_event *evs;
 
 	assert_non_null(timeout);
 	nr_evs = mock_type(int);
@@ -149,8 +154,8 @@ int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 		return 0;
 	if (test_dev) {
 		int n = 0;
-		mock_ptr_type(struct timespec *);
-		mock_ptr_type(struct io_event *);
+		(void)mock_ptr_type(const struct timespec *);
+		(void)mock_ptr_type(const struct io_event *);
 
 		condlog(2, "min_nr = %ld nr_evs = %d", min_nr, nr_evs);
 		while (n < nr_evs) {
@@ -160,7 +165,7 @@ int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 		}
 		assert_int_equal(nr_evs, n);
 	} else {
-		sleep_tmo = mock_ptr_type(struct timespec *);
+		sleep_tmo = mock_ptr_type(const struct timespec *);
 		if (sleep_tmo) {
 			if (sleep_tmo->tv_sec < 0)
 				nanosleep(timeout, NULL);
@@ -171,7 +176,7 @@ int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
 			errno = -nr_evs;
 			return -1;
 		}
-		evs = mock_ptr_type(struct io_event *);
+		evs = mock_ptr_type(const struct io_event *);
 		for (i = 0; i < nr_evs; i++)
 			events[i] = evs[i];
 	}
@@ -259,7 +264,7 @@ static void do_libcheck_init(struct checker *c, int blocksize, int timeout,
 		*req = ct->req;
 	if (!test_dev)
 		/* don't check fake blocksize on real devices */
-		assert_int_equal(ct->req->blksize, blocksize);
+		assert_uint_equal(ct->req->blksize, blocksize);
 }
 
 static int is_checker_running(struct checker *c)
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 6df4f03..c94ab01 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -10,7 +10,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -244,7 +244,7 @@ int WRAP_IOCTL(int fd, unsigned long request, void *argp)
 {
 	condlog(1, "%s %ld", __func__, request);
 	assert_int_equal(fd, waiter->fd);
-	assert_int_equal(request, DM_DEV_ARM_POLL);
+	assert_uint_equal(request, DM_DEV_ARM_POLL);
 	return mock_type(int);
 }
 
@@ -295,7 +295,7 @@ void __wrap_dm_task_destroy(struct dm_task *dmt)
 
 int __wrap_poll(struct pollfd *fds, nfds_t nfds, int timeout)
 {
-	assert_int_equal(nfds, 1);
+	assert_uint_equal(nfds, 1);
 	assert_int_equal(timeout, -1);
 	assert_int_equal(fds->fd, waiter->fd);
 	assert_int_equal(fds->events, POLLIN);
@@ -304,7 +304,7 @@ int __wrap_poll(struct pollfd *fds, nfds_t nfds, int timeout)
 
 void __wrap_remove_map_by_alias(const char *alias, struct vectors * vecs)
 {
-	check_expected(alias);
+	check_expected_ptr(alias);
 	assert_ptr_equal(vecs, waiter->vecs);
 }
 
@@ -315,7 +315,7 @@ int __wrap_update_multipath(struct vectors *vecs, char *mapname)
 {
 	int fail;
 
-	check_expected(mapname);
+	check_expected_ptr(mapname);
 	assert_ptr_equal(vecs, waiter->vecs);
 	fail = mock_type(int);
 	if (fail) {
@@ -435,7 +435,7 @@ static void test_watch_dmevents_good0(void **state)
 	/* verify foo is being watched */
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_int_equal(VECTOR_SIZE(waiter->events), 1);
 	unwatch_dmevents("foo");
@@ -459,14 +459,14 @@ static void test_watch_dmevents_good1(void **state)
 	assert_int_equal(watch_dmevents("foo"), 0);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_int_equal(add_dm_device_event("foo", 1, 6), 0);
 	will_return(__wrap_dm_geteventnr, 0);
 	assert_int_equal(watch_dmevents("foo"), 0);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 6);
+	assert_uint_equal(dev_evt->evt_nr, 6);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_int_equal(VECTOR_SIZE(waiter->events), 1);
 	unwatch_dmevents("foo");
@@ -490,18 +490,18 @@ static void test_watch_dmevents_good2(void **state)
 	assert_int_equal(watch_dmevents("foo"), 0);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_ptr_equal(find_dmevents("bar"), NULL);
 	will_return(__wrap_dm_geteventnr, 0);
 	assert_int_equal(watch_dmevents("bar"), 0);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev_evt = find_dmevents("bar");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 7);
+	assert_uint_equal(dev_evt->evt_nr, 7);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_int_equal(VECTOR_SIZE(waiter->events), 2);
 	unwatch_all_dmevents();
@@ -597,15 +597,15 @@ static void test_get_events_good1(void **state)
 	assert_int_equal(dm_get_events(), 0);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 6);
+	assert_uint_equal(dev_evt->evt_nr, 6);
 	assert_int_equal(dev_evt->action, EVENT_UPDATE);
 	dev_evt = find_dmevents("bar");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 7);
+	assert_uint_equal(dev_evt->evt_nr, 7);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev_evt = find_dmevents("xyzzy");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 8);
+	assert_uint_equal(dev_evt->evt_nr, 8);
 	assert_int_equal(dev_evt->action, EVENT_REMOVE);
 	assert_ptr_equal(find_dmevents("baz"), NULL);
 	assert_ptr_equal(find_dmevents("qux"), NULL);
@@ -632,12 +632,12 @@ static void test_dmevent_loop_bad0(void **state)
 	assert_int_equal(dmevent_loop(), 1);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("foo");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 6);
-	assert_int_equal(dev->update_nr, 5);
+	assert_uint_equal(dev->evt_nr, 6);
+	assert_uint_equal(dev->update_nr, 5);
 }
 
 /* arm_dm_event_poll's ioctl fails. Nothing happens */
@@ -654,12 +654,12 @@ static void test_dmevent_loop_bad1(void **state)
 	assert_int_equal(dmevent_loop(), 1);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("foo");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 6);
-	assert_int_equal(dev->update_nr, 5);
+	assert_uint_equal(dev->evt_nr, 6);
+	assert_uint_equal(dev->update_nr, 5);
 }
 
 /* dm_get_events fails. Nothing happens */
@@ -677,12 +677,12 @@ static void test_dmevent_loop_bad2(void **state)
 	assert_int_equal(dmevent_loop(), 1);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 5);
+	assert_uint_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("foo");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 6);
-	assert_int_equal(dev->update_nr, 5);
+	assert_uint_equal(dev->evt_nr, 6);
+	assert_uint_equal(dev->update_nr, 5);
 }
 
 /* verify dmevent_loop runs successfully when no devices are being
@@ -743,20 +743,20 @@ static void test_dmevent_loop_good1(void **state)
 	assert_int_equal(VECTOR_SIZE(data.dm_devices), 3);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 6);
+	assert_uint_equal(dev_evt->evt_nr, 6);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("foo");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 6);
-	assert_int_equal(dev->update_nr, 6);
+	assert_uint_equal(dev->evt_nr, 6);
+	assert_uint_equal(dev->update_nr, 6);
 	dev_evt = find_dmevents("bar");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 7);
+	assert_uint_equal(dev_evt->evt_nr, 7);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("bar");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 7);
-	assert_int_equal(dev->update_nr, 7);
+	assert_uint_equal(dev->evt_nr, 7);
+	assert_uint_equal(dev->update_nr, 7);
 	assert_ptr_equal(find_dmevents("xyzzy"), NULL);
 	assert_ptr_equal(find_dm_device("xyzzy"), NULL);
 }
@@ -791,20 +791,20 @@ static void test_dmevent_loop_good2(void **state)
 	assert_int_equal(VECTOR_SIZE(data.dm_devices), 2);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 6);
+	assert_uint_equal(dev_evt->evt_nr, 6);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("foo");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 6);
-	assert_int_equal(dev->update_nr, 6);
+	assert_uint_equal(dev->evt_nr, 6);
+	assert_uint_equal(dev->update_nr, 6);
 	dev_evt = find_dmevents("bar");
 	assert_ptr_not_equal(dev_evt, NULL);
-	assert_int_equal(dev_evt->evt_nr, 9);
+	assert_uint_equal(dev_evt->evt_nr, 9);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	dev = find_dm_device("bar");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 9);
-	assert_int_equal(dev->update_nr, 9);
+	assert_uint_equal(dev->evt_nr, 9);
+	assert_uint_equal(dev->update_nr, 9);
 	assert_ptr_equal(find_dmevents("baz"), NULL);
 	assert_ptr_equal(find_dm_device("baz"), NULL);
 }
@@ -831,8 +831,8 @@ static void test_dmevent_loop_good3(void **state)
 	assert_int_equal(VECTOR_SIZE(data.dm_devices), 1);
 	dev = find_dm_device("bar");
 	assert_ptr_not_equal(dev, NULL);
-	assert_int_equal(dev->evt_nr, 9);
-	assert_int_equal(dev->update_nr, 9);
+	assert_uint_equal(dev->evt_nr, 9);
+	assert_uint_equal(dev->update_nr, 9);
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 	assert_ptr_equal(find_dmevents("bar"), NULL);
 	assert_ptr_equal(find_dm_device("foo"), NULL);
diff --git a/tests/features.c b/tests/features.c
index 31f978f..35f15de 100644
--- a/tests/features.c
+++ b/tests/features.c
@@ -2,7 +2,7 @@
 #include <stddef.h>
 #include <stdarg.h>
 #include <setjmp.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 
 #include "../libmultipath/propsel.c"
 #include "globals.c"
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 631b882..6021bfd 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -7,7 +7,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "mt-udev-wrap.h"
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -505,7 +505,7 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
 	DUMP_CFG_STR(cfg2);
 #endif
 
-	assert_int_equal(strlen(cfg2), strlen(cfg1));
+	assert_uint_equal(strlen(cfg2), strlen(cfg1));
 	assert_string_equal(cfg2, cfg1);
 	free(cfg1);
 	free(cfg2);
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index 3651160..d8461b4 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -25,7 +25,7 @@
 #include <stdlib.h>
 #include <fcntl.h>
 #include <errno.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "util.h"
 #include "devmapper.h"
 #include "globals.c"
@@ -87,10 +87,10 @@ void __wrap_dm_task_destroy(struct dm_task *t)
 {
 }
 
-struct dm_task *__wrap_dm_task_create(int task)
+const struct dm_task *__wrap_dm_task_create(int task)
 {
-	check_expected(task);
-	return mock_ptr_type(void *);
+	check_expected_int(task);
+	return mock_ptr_type(const struct dm_task *);
 }
 
 int __wrap_dm_task_run(struct dm_task *t)
@@ -114,25 +114,25 @@ int __wrap_dm_task_get_errno(struct dm_task *t)
 
 int __wrap_dm_task_set_name(struct dm_task *t, const char *name)
 {
-	check_expected(name);
+	check_expected_ptr(name);
 	return mock_type(int);
 }
 
 int __wrap_dm_task_set_uuid(struct dm_task *t, const char *uuid)
 {
-	check_expected(uuid);
+	check_expected_ptr(uuid);
 	return mock_type(int);
 }
 
 int __wrap_dm_task_set_major(struct dm_task *t, int val)
 {
-	check_expected(val);
+	check_expected_int(val);
 	return mock_type(int);
 }
 
 int __wrap_dm_task_set_minor(struct dm_task *t, int val)
 {
-	check_expected(val);
+	check_expected_int(val);
 	return mock_type(int);
 }
 
@@ -151,22 +151,23 @@ int __wrap_dm_task_get_info(struct dm_task *t, struct dm_info *dmi)
 
 	assert_non_null(dmi);
 	if (rc) {
-		struct dm_info *info = mock_ptr_type(struct dm_info *);
+		const struct dm_info *info = mock_ptr_type(const struct dm_info *);
 
 		memcpy(dmi, info, sizeof(*dmi));
 	}
 	return rc;
 }
 
-void * __wrap_dm_get_next_target(struct dm_task *dmt, void *next,
-				uint64_t *start, uint64_t *length,
-				char **target_type, char **params)
+const void *
+__wrap_dm_get_next_target(struct dm_task *dmt, void *next, uint64_t *start,
+			  uint64_t *length, const char **target_type,
+			  const char **params)
 {
 	*start = 0;
 	*length = mock_type(uint64_t);
-	*target_type = mock_ptr_type(char *);
-	*params = mock_ptr_type(char *);
-	return mock_ptr_type(void *);
+	*target_type = mock_ptr_type(const char *);
+	*params = mock_ptr_type(const char *);
+	return mock_ptr_type(const void *);
 }
 
 static void mock_dm_get_next_target(uint64_t len, const char *target_type,
@@ -191,11 +192,11 @@ const char *__wrap_dm_task_get_uuid(struct dm_task *t)
 static void mock_mapinfo_name_1(int ioctl_nr, int create_rc, const char *name,
 				int name_rc, int run_rc, int err)
 {
-	expect_value(__wrap_dm_task_create, task, ioctl_nr);
+	expect_int_value(__wrap_dm_task_create, task, ioctl_nr);
 	will_return(__wrap_dm_task_create, create_rc);
 	if (create_rc == 0)
 		return;
-	expect_value(__wrap_dm_task_set_name, name, name);
+	expect_string(__wrap_dm_task_set_name, name, name);
 	will_return(__wrap_dm_task_set_name, name_rc);
 	if (name_rc == 0)
 		return;
@@ -223,7 +224,7 @@ static void test_mapinfo_bad_mapid(void **state)
 	int rc;
 
 	/* can't use mock_mapinfo_name() here because of invalid id type */
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME + 100,
 			   (mapid_t) { .str = "foo", },
@@ -646,9 +647,9 @@ static void test_mapinfo_bad_set_uuid(void **state)
 {
 	int rc;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_uuid, uuid, "foo");
+	expect_string(__wrap_dm_task_set_uuid, uuid, "foo");
 	will_return(__wrap_dm_task_set_uuid, 0);
 	rc = libmp_mapinfo(DM_MAP_BY_UUID,
 			   (mapid_t) { .str = "foo", },
@@ -660,9 +661,9 @@ static void test_mapinfo_bad_set_dev_01(void **state)
 {
 	int rc;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 0);
 	rc = libmp_mapinfo(DM_MAP_BY_DEV,
 			   (mapid_t) { ._u = { 254, 123 } },
@@ -674,11 +675,11 @@ static void test_mapinfo_bad_set_dev_02(void **state)
 {
 	int rc;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 1);
-	expect_value(__wrap_dm_task_set_minor, val, 123);
+	expect_int_value(__wrap_dm_task_set_minor, val, 123);
 	will_return(__wrap_dm_task_set_minor, 0);
 	rc = libmp_mapinfo(DM_MAP_BY_DEV,
 			   (mapid_t) { ._u = { 254, 123 } },
@@ -691,9 +692,9 @@ static void test_mapinfo_bad_set_dev_03(void **state)
 	int rc;
 	dev_t devt = makedev(254, 123);
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 0);
 	rc = libmp_mapinfo(DM_MAP_BY_DEVT,
 			   (mapid_t) { .devt = devt },
@@ -706,11 +707,11 @@ static void test_mapinfo_bad_set_dev_04(void **state)
 	int rc;
 	dev_t devt = makedev(254, 123);
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 1);
-	expect_value(__wrap_dm_task_set_minor, val, 123);
+	expect_int_value(__wrap_dm_task_set_minor, val, 123);
 	will_return(__wrap_dm_task_set_minor, 0);
 	rc = libmp_mapinfo(DM_MAP_BY_DEVT,
 			   (mapid_t) { .devt = devt },
@@ -738,9 +739,9 @@ static void test_mapinfo_good_by_uuid_info(void **state)
 	int rc;
 	struct dm_info dmi;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_uuid, uuid, "foo");
+	expect_string(__wrap_dm_task_set_uuid, uuid, "foo");
 	will_return(__wrap_dm_task_set_uuid, 1);
 	will_return(__wrap_dm_task_run, 1);
 	WRAP_DM_TASK_GET_INFO(1);
@@ -757,11 +758,11 @@ static void test_mapinfo_good_by_dev_info(void **state)
 	int rc;
 	struct dm_info dmi;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 1);
-	expect_value(__wrap_dm_task_set_minor, val, 123);
+	expect_int_value(__wrap_dm_task_set_minor, val, 123);
 	will_return(__wrap_dm_task_set_minor, 1);
 	will_return(__wrap_dm_task_run, 1);
 	WRAP_DM_TASK_GET_INFO(1);
@@ -779,11 +780,11 @@ static void test_mapinfo_good_by_devt_info(void **state)
 	int rc;
 	struct dm_info dmi;
 
-	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	expect_int_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
 	will_return(__wrap_dm_task_create, 1);
-	expect_value(__wrap_dm_task_set_major, val, 254);
+	expect_int_value(__wrap_dm_task_set_major, val, 254);
 	will_return(__wrap_dm_task_set_major, 1);
-	expect_value(__wrap_dm_task_set_minor, val, 123);
+	expect_int_value(__wrap_dm_task_set_minor, val, 123);
 	will_return(__wrap_dm_task_set_minor, 1);
 	will_return(__wrap_dm_task_run, 1);
 	WRAP_DM_TASK_GET_INFO(1);
@@ -871,7 +872,7 @@ static void test_mapinfo_good_size(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .size = &size });
 	assert_int_equal(rc, DMP_OK);
-	assert_int_equal(size, 12345);
+	assert_uint_equal(size, 12345);
 }
 
 static void test_mapinfo_bad_next_target_01(void **state)
@@ -909,7 +910,7 @@ static void test_mapinfo_bad_next_target_02(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid, .size = &size });
 	assert_int_equal(rc, DMP_EMPTY);
-	assert_int_equal(size, 0);
+	assert_uint_equal(size, 0);
 	assert_memory_equal(&dmi, &MPATH_DMI_02, sizeof(dmi));
 	assert_true(!strcmp(name, MPATH_NAME_01));
 	assert_true(!strcmp(uuid, MPATH_UUID_01));
@@ -1102,7 +1103,7 @@ static void test_mapinfo_no_table_02(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid, .size = &size });
 	assert_int_equal(rc, DMP_EMPTY);
-	assert_int_equal(size, 0);
+	assert_uint_equal(size, 0);
 	assert_memory_equal(&dmi, &MPATH_DMI_02, sizeof(dmi));
 	assert_true(!strcmp(name, MPATH_NAME_01));
 	assert_true(!strcmp(uuid, MPATH_UUID_01));
@@ -1369,7 +1370,7 @@ static void test_mapinfo_good_all_01(void **state)
 	assert_int_equal(rc, DMP_OK);
 	assert_non_null(status);
 	assert_non_null(target);
-	assert_int_equal(size, 12345);
+	assert_uint_equal(size, 12345);
 	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
 	assert_true(!strcmp(target, MPATH_TARGET_01));
 	assert_true(!strcmp(status, MPATH_STATUS_01));
diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
index 699dce5..1b060fe 100644
--- a/tests/mpathvalid.c
+++ b/tests/mpathvalid.c
@@ -10,7 +10,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include "mt-udev-wrap.h"
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "structs.h"
 #include "config.h"
 #include "mpath_valid.h"
@@ -66,11 +66,11 @@ int __wrap_is_path_valid(const char *name, struct config *conf, struct path *pp,
 	assert_ptr_not_equal(pp, NULL);
 	assert_true(check_multipathd);
 
-	assert_int_equal(findmp, conf->find_multipaths);	
+	assert_int_equal(findmp, conf->find_multipaths);
 	if (r == MPATH_IS_ERROR || r == MPATH_IS_NOT_VALID)
 		return r;
-	
-	strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
+
+	strlcpy(pp->wwid, mock_ptr_type(const char *), WWID_SIZE);
 	return r;
 }
 
@@ -223,7 +223,7 @@ static void check_mpathvalid_init(int findmp, int prio, int log_style)
 	check_config(true);
 	assert_int_equal(logsink, log_style);
 	assert_int_equal(libmp_verbosity, prio);
-	assert_int_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
+	assert_uint_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
 }
 
 static void check_mpathvalid_exit(void)
@@ -262,9 +262,9 @@ static void test_mpathvalid_exit(void **state)
 static void test_mpathvalid_get_mode_bad(void **state)
 {
 #if 1
-	assert_int_equal(mpathvalid_get_mode(), MPATH_MODE_ERROR);
+	assert_uint_equal(mpathvalid_get_mode(), MPATH_MODE_ERROR);
 #else
-	assert_int_equal(mpathvalid_get_mode(), 1);
+	assert_uint_equal(mpathvalid_get_mode(), 1);
 #endif
 }
 
@@ -298,7 +298,7 @@ static void check_mpathvalid_reload_config(int findmp)
 	will_return(__wrap_init_config, findmp);
 	assert_int_equal(mpathvalid_reload_config(), 0);
 	check_config(true);
-	assert_int_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
+	assert_uint_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
 }
 
 static void test_mpathvalid_reload_config_good(void **state)
diff --git a/tests/parser.c b/tests/parser.c
index efa7bf2..0e718c9 100644
--- a/tests/parser.c
+++ b/tests/parser.c
@@ -8,7 +8,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 // #include "list.h"
 #include "parser.h"
 #include "vector.h"
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index ed050fa..aec16ec 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -9,7 +9,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <stdio.h>
 
 #include "globals.c"
diff --git a/tests/strbuf.c b/tests/strbuf.c
index 1cc1618..06fa71c 100644
--- a/tests/strbuf.c
+++ b/tests/strbuf.c
@@ -9,7 +9,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <errno.h>
 #include "strbuf.h"
 #include "debug.h"
@@ -24,7 +24,11 @@ void *__wrap_realloc(void *ptr, size_t size)
 	if (!mock_realloc)
 		return __real_realloc(ptr, size);
 
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wcast-qual"
 	p = mock_ptr_type(void *);
+#pragma GCC diagnostic pop
+
 	condlog(4, "%s: %p, %zu -> %p", __func__, ptr, size, p);
 	return p;
 }
@@ -35,44 +39,44 @@ static void test_strbuf_00(void **state)
 	char *p;
 
 	assert_ptr_equal(buf.buf, NULL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 	p = steal_strbuf_str(&buf);
 	assert_ptr_equal(p, NULL);
 
 	assert_ptr_equal(buf.buf, NULL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	assert_int_equal(append_strbuf_str(&buf, "moin"), 4);
-	assert_int_equal(get_strbuf_len(&buf), 4);
-	assert_in_range(buf.size, 5, SIZE_MAX);
+	assert_uint_equal(get_strbuf_len(&buf), 4);
+	assert_uint_in_range(buf.size, 5, SIZE_MAX);
 	assert_string_equal(get_strbuf_str(&buf), "moin");
 	p = steal_strbuf_str(&buf);
 	assert_string_equal(p, "moin");
 	free(p);
 
 	assert_ptr_equal(buf.buf, NULL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	assert_int_equal(append_strbuf_str(&buf, NULL), -EINVAL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	assert_int_equal(append_strbuf_str(&buf, ""), 0);
 	/* appending a 0-length string allocates memory */
-	assert_in_range(buf.size, 1, SIZE_MAX);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_in_range(buf.size, 1, SIZE_MAX);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 	p = steal_strbuf_str(&buf);
 	assert_string_equal(p, "");
@@ -80,9 +84,9 @@ static void test_strbuf_00(void **state)
 
 	assert_int_equal(append_strbuf_str__(&buf, "x", 0), 0);
 	/* appending a 0-length string allocates memory */
-	assert_in_range(buf.size, 1, SIZE_MAX);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_in_range(buf.size, 1, SIZE_MAX);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 }
 
@@ -95,17 +99,17 @@ static void test_strbuf_alloc_err(void **state)
 	mock_realloc = true;
 	will_return(__wrap_realloc, NULL);
 	assert_int_equal(append_strbuf_str(&buf, "moin"), -ENOMEM);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	mock_realloc = false;
 	assert_int_equal(append_strbuf_str(&buf, "moin"), 4);
 	sz = buf.size;
-	assert_in_range(sz, 5, SIZE_MAX);
-	assert_int_equal(buf.offs, 4);
-	assert_int_equal(get_strbuf_len(&buf), 4);
+	assert_uint_in_range(sz, 5, SIZE_MAX);
+	assert_uint_equal(buf.offs, 4);
+	assert_uint_equal(get_strbuf_len(&buf), 4);
 	assert_string_equal(get_strbuf_str(&buf), "moin");
 
 	mock_realloc = true;
@@ -114,22 +118,22 @@ static void test_strbuf_alloc_err(void **state)
 	while ((rc = append_strbuf_str(&buf, " hello")) >= 0) {
 		condlog(3, "%s", get_strbuf_str(&buf));
 		assert_int_equal(rc, 6);
-		assert_int_equal(get_strbuf_len(&buf), ofs + 6);
+		assert_uint_equal(get_strbuf_len(&buf), ofs + 6);
 		assert_memory_equal(get_strbuf_str(&buf), "moin", 4);
 		assert_string_equal(get_strbuf_str(&buf) + ofs, " hello");
 		ofs = get_strbuf_len(&buf);
 	}
 	assert_int_equal(rc, -ENOMEM);
-	assert_int_equal(buf.size, sz);
-	assert_int_equal(get_strbuf_len(&buf), ofs);
+	assert_uint_equal(buf.size, sz);
+	assert_uint_equal(get_strbuf_len(&buf), ofs);
 	assert_memory_equal(get_strbuf_str(&buf), "moin", 4);
 	assert_string_equal(get_strbuf_str(&buf) + ofs - 6, " hello");
 
 	reset_strbuf(&buf);
 	assert_ptr_equal(buf.buf, NULL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	mock_realloc = false;
@@ -158,7 +162,8 @@ static void test_strbuf_big(void **state)
 		if (i % 1000 == 0)
 			condlog(4, "%d", i);
 		assert_int_equal(append_strbuf_str(&buf, big), sizeof(big) - 1);
-		assert_int_equal(get_strbuf_len(&buf), (sizeof(big) - 1) * (i + 1));
+		assert_uint_equal(get_strbuf_len(&buf),
+				  (sizeof(big) - 1) * (i + 1));
 		assert_memory_equal(get_strbuf_str(&buf), big, sizeof(big) - 1);
 		assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf)
 				    - (sizeof(big) - 1), big);
@@ -166,12 +171,12 @@ static void test_strbuf_big(void **state)
 	bbig = steal_strbuf_str(&buf);
 
 	assert_ptr_equal(buf.buf, NULL);
-	assert_int_equal(buf.size, 0);
-	assert_int_equal(buf.offs, 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(buf.size, 0);
+	assert_uint_equal(buf.offs, 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
-	assert_int_equal(strlen(bbig), i * (sizeof(big) - 1));
+	assert_uint_equal(strlen(bbig), i * (sizeof(big) - 1));
 	assert_memory_equal(bbig, big, sizeof(big) - 1);
 	free(bbig);
 }
@@ -190,23 +195,23 @@ static void test_strbuf_nul(void **state)
 	greet[5] = '\0';
 	reset_strbuf(&buf);
 	assert_int_equal(append_strbuf_str(&buf, greet), 5);
-	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_uint_equal(get_strbuf_len(&buf), 5);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
 	assert_int_equal(append_strbuf_str(&buf, greet), 5);
-	assert_int_equal(get_strbuf_len(&buf), 10);
+	assert_uint_equal(get_strbuf_len(&buf), 10);
 	assert_string_equal(get_strbuf_str(&buf), "hellohello");
 
 	/* append_strbuf_str__() appends full memory, including NUL bytes */
 	reset_strbuf(&buf);
 	assert_int_equal(append_strbuf_str__(&buf, greet, sizeof(greet) - 1),
 			 sizeof(greet) - 1);
-	assert_int_equal(get_strbuf_len(&buf), sizeof(greet) - 1);
+	assert_uint_equal(get_strbuf_len(&buf), sizeof(greet) - 1);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
 	assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf) - 5, " sir!");
 	assert_int_equal(append_strbuf_str__(&buf, greet, sizeof(greet) - 1),
 			 sizeof(greet) - 1);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
-	assert_int_equal(get_strbuf_len(&buf), 2 * (sizeof(greet) - 1));
+	assert_uint_equal(get_strbuf_len(&buf), 2 * (sizeof(greet) - 1));
 	assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf) - 5, " sir!");
 }
 
@@ -318,7 +323,7 @@ static void test_print_strbuf_3(void **state)
 
 	s = get_strbuf_str(&buf);
 	condlog(3, "%s", s);
-	assert_int_equal(strlen(s), repeat * (sizeof(sentence) - 1));
+	assert_uint_equal(strlen(s), repeat * (sizeof(sentence) - 1));
 	for (i = 0; i < repeat; i++)
 		assert_int_equal(strncmp(s + i * (sizeof(sentence) - 1),
 					 sentence, sizeof(sentence) - 1), 0);
@@ -340,7 +345,7 @@ static void test_print_strbuf_4(void **state)
 
 	s = get_strbuf_str(&buf);
 	condlog(3, "%s", s);
-	assert_int_equal(strlen(s), repeat * (sizeof(sentence) - 1));
+	assert_uint_equal(strlen(s), repeat * (sizeof(sentence) - 1));
 	for (i = 0; i < repeat; i++)
 		assert_int_equal(strncmp(s + i * (sizeof(sentence) - 1),
 					 sentence, sizeof(sentence) - 1), 0);
@@ -356,24 +361,24 @@ static void test_truncate_strbuf(void **state)
 	assert_int_equal(truncate_strbuf(&buf, 0), -EFAULT);
 
 	assert_int_equal(append_strbuf_str(&buf, str), sizeof(str) - 1);
-	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_uint_equal(get_strbuf_len(&buf), sizeof(str) - 1);
 	assert_string_equal(get_strbuf_str(&buf), str);
 
 	assert_int_equal(truncate_strbuf(&buf, sizeof(str)), -ERANGE);
-	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_uint_equal(get_strbuf_len(&buf), sizeof(str) - 1);
 	assert_string_equal(get_strbuf_str(&buf), str);
 
 	assert_int_equal(truncate_strbuf(&buf, sizeof(str) - 1), 0);
-	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_uint_equal(get_strbuf_len(&buf), sizeof(str) - 1);
 	assert_string_equal(get_strbuf_str(&buf), str);
 
 	assert_int_equal(truncate_strbuf(&buf, sizeof(str) - 2), 0);
-	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 2);
+	assert_uint_equal(get_strbuf_len(&buf), sizeof(str) - 2);
 	assert_string_not_equal(get_strbuf_str(&buf), str);
 	assert_memory_equal(get_strbuf_str(&buf), str, sizeof(str) - 2);
 
 	assert_int_equal(truncate_strbuf(&buf, 5), 0);
-	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_uint_equal(get_strbuf_len(&buf), 5);
 	assert_string_not_equal(get_strbuf_str(&buf), str);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
 
@@ -385,7 +390,7 @@ static void test_truncate_strbuf(void **state)
 		assert_int_equal(append_strbuf_str(&buf, str), sizeof(str) - 1);
 
 	sz1  = buf.size;
-	assert_in_range(get_strbuf_len(&buf), sz + 1, SIZE_MAX);
+	assert_uint_in_range(get_strbuf_len(&buf), sz + 1, SIZE_MAX);
 	assert_string_equal(get_strbuf_str(&buf) +
 			    get_strbuf_len(&buf) - (sizeof(str) - 1), str);
 	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf) + 1),
@@ -393,20 +398,20 @@ static void test_truncate_strbuf(void **state)
 	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf)), 0);
 	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf)
 					 - (sizeof(str) - 1)), 0);
-	assert_in_range(get_strbuf_len(&buf), 1, sz);
+	assert_uint_in_range(get_strbuf_len(&buf), 1, sz);
 	assert_string_equal(get_strbuf_str(&buf) +
 			    get_strbuf_len(&buf) - (sizeof(str) - 1), str);
-	assert_int_equal(buf.size, sz1);
+	assert_uint_equal(buf.size, sz1);
 
 	assert_int_equal(truncate_strbuf(&buf, 5), 0);
-	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_uint_equal(get_strbuf_len(&buf), 5);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
-	assert_int_equal(buf.size, sz1);
+	assert_uint_equal(buf.size, sz1);
 
 	assert_int_equal(truncate_strbuf(&buf, 0), 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
-	assert_int_equal(buf.size, sz1);
+	assert_uint_equal(buf.size, sz1);
 }
 
 static void test_fill_strbuf(void **state)
@@ -418,31 +423,31 @@ static void test_fill_strbuf(void **state)
 	assert_int_equal(fill_strbuf(&buf, '+', -5), -EINVAL);
 
 	assert_int_equal(fill_strbuf(&buf, '+', 0), 0);
-	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_uint_equal(get_strbuf_len(&buf), 0);
 	assert_string_equal(get_strbuf_str(&buf), "");
 
 	assert_int_equal(fill_strbuf(&buf, '+', 1), 1);
-	assert_int_equal(get_strbuf_len(&buf), 1);
+	assert_uint_equal(get_strbuf_len(&buf), 1);
 	assert_string_equal(get_strbuf_str(&buf), "+");
 
 	assert_int_equal(fill_strbuf(&buf, '-', 3), 3);
-	assert_int_equal(get_strbuf_len(&buf), 4);
+	assert_uint_equal(get_strbuf_len(&buf), 4);
 	assert_string_equal(get_strbuf_str(&buf), "+---");
 
 	assert_int_equal(fill_strbuf(&buf, '\0', 3), 3);
-	assert_int_equal(get_strbuf_len(&buf), 7);
+	assert_uint_equal(get_strbuf_len(&buf), 7);
 	assert_string_equal(get_strbuf_str(&buf), "+---");
 
 	truncate_strbuf(&buf, 4);
 	assert_int_equal(fill_strbuf(&buf, '+', 4), 4);
-	assert_int_equal(get_strbuf_len(&buf), 8);
+	assert_uint_equal(get_strbuf_len(&buf), 8);
 	assert_string_equal(get_strbuf_str(&buf), "+---++++");
 
 	reset_strbuf(&buf);
 	assert_int_equal(fill_strbuf(&buf, 'x', 30000), 30000);
-	assert_int_equal(get_strbuf_len(&buf), 30000);
+	assert_uint_equal(get_strbuf_len(&buf), 30000);
 	p = steal_strbuf_str(&buf);
-	assert_int_equal(strlen(p), 30000);
+	assert_uint_equal(strlen(p), 30000);
 	for (i = 0; i < 30000; i++)
 		assert_int_equal(p[i], 'x');
 	free(p);
diff --git a/tests/sysfs.c b/tests/sysfs.c
index 13f985f..5f02942 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -9,7 +9,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "mt-udev-wrap.h"
 #include <fcntl.h>
 #include <errno.h>
@@ -22,9 +22,9 @@
 
 #define TEST_FD 123
 
-char *__wrap_udev_device_get_syspath(struct udev_device *ud)
+const char *__wrap_udev_device_get_syspath(struct udev_device *ud)
 {
-	char *val  = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	return val;
 }
@@ -33,8 +33,8 @@ int WRAP_OPEN(const char *pathname, int flags)
 {
 	int ret;
 
-	check_expected(pathname);
-	check_expected(flags);
+	check_expected_ptr(pathname);
+	check_expected_int(flags);
 	ret = mock_type(int);
 	return ret;
 }
@@ -42,12 +42,12 @@ int WRAP_OPEN(const char *pathname, int flags)
 ssize_t __wrap_read(int fd, void *buf, size_t count)
 {
 	ssize_t ret;
-	char *val;
+	const char *val;
 
-	check_expected(fd);
-	check_expected(count);
+	check_expected_int(fd);
+	check_expected_uint(count);
 	ret = mock_type(int);
-	val = mock_ptr_type(char *);
+	val = mock_ptr_type(const char *);
 	if (ret >= (ssize_t)count)
 		ret = count;
 	if (ret >= 0 && val) {
@@ -61,8 +61,8 @@ ssize_t __wrap_write(int fd, void *buf, size_t count)
 {
 	ssize_t ret;
 
-	check_expected(fd);
-	check_expected(count);
+	check_expected_int(fd);
+	check_expected_uint(count);
 	ret = mock_type(int);
 	if (ret >= (ssize_t)count)
 		ret = count;
@@ -168,7 +168,7 @@ static void test_sagv_open_fail(void **state)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	errno = ENOENT;
 	wrap_will_return(WRAP_OPEN, -1);
 	expect_condlog(3, "sysfs_attr_get_value__: attribute '/foo/bar' cannot be opened");
@@ -183,10 +183,10 @@ static void test_sagv_read_fail(void **state)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_read, fd, TEST_FD);
-	expect_value(__wrap_read, count, sizeof(buf));
+	expect_int_value(__wrap_read, fd, TEST_FD);
+	expect_uint_value(__wrap_read, count, sizeof(buf));
 	errno = EISDIR;
 	will_return(__wrap_read, -1);
 	will_return(__wrap_read, NULL);
@@ -198,10 +198,10 @@ static void test_sagv_read_fail(void **state)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
 	expect_string(WRAP_OPEN, pathname, "/foo/baz");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_read, fd, TEST_FD);
-	expect_value(__wrap_read, count, sizeof(buf));
+	expect_int_value(__wrap_read, fd, TEST_FD);
+	expect_uint_value(__wrap_read, count, sizeof(buf));
 	errno = EPERM;
 	will_return(__wrap_read, -1);
 	will_return(__wrap_read, NULL);
@@ -219,15 +219,15 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	char input[] = "01234567";
 	unsigned int n, trunc;
 
-	assert_in_range(bufsz, 1, sizeof(buf));
+	assert_uint_in_range(bufsz, 1, sizeof(buf));
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_read, fd, TEST_FD);
-	expect_value(__wrap_read, count, bufsz);
+	expect_int_value(__wrap_read, fd, TEST_FD);
+	expect_uint_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
 	will_return(__wrap_read, input);
 
@@ -251,10 +251,10 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/baz'");
 	expect_string(WRAP_OPEN, pathname, "/foo/baz");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_read, fd, TEST_FD);
-	expect_value(__wrap_read, count, bufsz);
+	expect_int_value(__wrap_read, fd, TEST_FD);
+	expect_uint_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
 	will_return(__wrap_read, input);
 	will_return(__wrap_close, 0);
@@ -297,15 +297,15 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
 	char input[] = { '\0','\0','\0','\0','\0','\0','\0','\0' };
 	unsigned int n;
 
-	assert_in_range(bufsz, 1, sizeof(buf));
+	assert_uint_in_range(bufsz, 1, sizeof(buf));
 	memset(buf, '.', sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_RDONLY);
+	expect_int_value(WRAP_OPEN, flags, O_RDONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_read, fd, TEST_FD);
-	expect_value(__wrap_read, count, bufsz);
+	expect_int_value(__wrap_read, fd, TEST_FD);
+	expect_uint_value(__wrap_read, count, bufsz);
 	will_return(__wrap_read, sizeof(input) - 1);
 	will_return(__wrap_read, input);
 
@@ -387,7 +387,7 @@ static void test_sasv_open_fail(void **state)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_WRONLY);
+	expect_int_value(WRAP_OPEN, flags, O_WRONLY);
 	errno = EPERM;
 	wrap_will_return(WRAP_OPEN, -1);
 	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' cannot be opened");
@@ -402,10 +402,10 @@ static void test_sasv_write_fail(void **state)
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_WRONLY);
+	expect_int_value(WRAP_OPEN, flags, O_WRONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_write, fd, TEST_FD);
-	expect_value(__wrap_write, count, sizeof(buf));
+	expect_int_value(__wrap_write, fd, TEST_FD);
+	expect_uint_value(__wrap_write, count, sizeof(buf));
 	errno = EISDIR;
 	will_return(__wrap_write, -1);
 	expect_condlog(3, "sysfs_attr_set_value: write to /foo/bar failed:");
@@ -419,14 +419,14 @@ static void _test_sasv_write(void **state, unsigned int n_written)
 {
 	char buf[8];
 
-	assert_in_range(n_written, 0, sizeof(buf));
+	assert_uint_in_range(n_written, 0, sizeof(buf));
 	will_return(__wrap_udev_device_get_syspath, "/foo");
 	expect_condlog(4, "open '/foo/bar'");
 	expect_string(WRAP_OPEN, pathname, "/foo/bar");
-	expect_value(WRAP_OPEN, flags, O_WRONLY);
+	expect_int_value(WRAP_OPEN, flags, O_WRONLY);
 	wrap_will_return(WRAP_OPEN, TEST_FD);
-	expect_value(__wrap_write, fd, TEST_FD);
-	expect_value(__wrap_write, count, sizeof(buf));
+	expect_int_value(__wrap_write, fd, TEST_FD);
+	expect_uint_value(__wrap_write, count, sizeof(buf));
 	will_return(__wrap_write, n_written);
 
 	if (n_written < sizeof(buf))
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 3f07567..ea99977 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -1,7 +1,7 @@
 #include <string.h>
 #include <setjmp.h>
 #include <stdarg.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "mt-udev-wrap.h"
 #include <sys/sysmacros.h>
 #include <linux/hdreg.h>
@@ -55,7 +55,7 @@ int WRAP_OPEN(const char *path, int flags, int mode)
 
 int __wrap_libmp_get_version(int which, unsigned int version[3])
 {
-	unsigned int *vers = mock_ptr_type(unsigned int *);
+	const unsigned int *vers = mock_ptr_type(const unsigned int *);
 
 	condlog(4, "%s: %d", __func__, which);
 	memcpy(version, vers, 3 * sizeof(unsigned int));
@@ -82,7 +82,7 @@ struct udev_list_entry
 
 const char *__wrap_udev_list_entry_get_name(struct udev_list_entry *udle)
 {
-	char *val = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	condlog(5, "%s: %s", __func__, val);
 	return val;
@@ -98,54 +98,67 @@ struct udev_device *__wrap_udev_device_unref(struct udev_device *ud)
 	return ud;
 }
 
-char *__wrap_udev_device_get_subsystem(struct udev_device *ud)
+/*
+ * cmocka 2.0 uses "const void *" for the pointer argument.
+ * As we have to return char *, we must accept casting
+ * (const void *) to (char *) here.
+ */
+const char *__wrap_udev_device_get_subsystem(struct udev_device *ud)
 {
-	char *val = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	condlog(5, "%s: %s", __func__, val);
 	return val;
 }
 
-char *__wrap_udev_device_get_sysname(struct udev_device *ud)
+const char *__wrap_udev_device_get_sysname(struct udev_device *ud)
 {
-	char *val  = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	condlog(5, "%s: %s", __func__, val);
 	return val;
 }
 
-char *__wrap_udev_device_get_devnode(struct udev_device *ud)
+const char *__wrap_udev_device_get_devnode(struct udev_device *ud)
 {
-	char *val  = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	condlog(5, "%s: %s", __func__, val);
 	return val;
 }
 
+const char *
+__wrap_udev_device_get_sysattr_value(struct udev_device *ud, const char *attr)
+{
+	const char *val = mock_ptr_type(const char *);
+
+	condlog(5, "%s: %s->%s", __func__, attr, val);
+	return val;
+}
+
+const char *
+__wrap_udev_device_get_property_value(struct udev_device *ud, const char *attr)
+{
+	const char *val = mock_ptr_type(const char *);
+
+	condlog(5, "%s: %s->%s", __func__, attr, val);
+	return val;
+}
+
+const void *__wrap_udev_device_get_parent(struct udev_device *ud)
+{
+	const void *val = mock_ptr_type(const void *);
+
+	condlog(5, "%s: %p", __func__, val);
+	return val;
+}
+
 dev_t __wrap_udev_device_get_devnum(struct udev_device *ud)
 {
 	condlog(5, "%s: %p", __func__, ud);
 	return makedev(17, 17);
 }
 
-char *__wrap_udev_device_get_sysattr_value(struct udev_device *ud,
-					     const char *attr)
-{
-	char *val  = mock_ptr_type(char *);
-
-	condlog(5, "%s: %s->%s", __func__, attr, val);
-	return val;
-}
-
-char *__wrap_udev_device_get_property_value(struct udev_device *ud,
-					    const char *attr)
-{
-	char *val  = mock_ptr_type(char *);
-
-	condlog(5, "%s: %s->%s", __func__, attr, val);
-	return val;
-}
-
 int __wrap_sysfs_get_size(struct path *pp, unsigned long long *sz)
 {
 	*sz = 12345678UL;
@@ -166,19 +179,10 @@ void *__wrap_udev_device_get_parent_with_subsystem_devtype(
 	return type;
 }
 
-void *__wrap_udev_device_get_parent(struct udev_device *ud)
+size_t __wrap_sysfs_attr_get_value(struct udev_device *dev,
+				   const char *attr_name, char *value, size_t sz)
 {
-	char *val  = mock_ptr_type(void *);
-
-	condlog(5, "%s: %p", __func__, val);
-	return val;
-}
-
-ssize_t __wrap_sysfs_attr_get_value(struct udev_device *dev,
-				    const char *attr_name,
-				    char *value, size_t sz)
-{
-	char *val  = mock_ptr_type(char *);
+	const char *val = mock_ptr_type(const char *);
 
 	condlog(5, "%s: %s", __func__, val);
 	strlcpy(value, val, sz);
@@ -193,7 +197,7 @@ ssize_t __wrap_sysfs_bin_attr_get_value(struct udev_device *dev,
 	static const char serial[] = "mptest_serial";
 
 	assert_string_equal(attr_name, "vpd_pg80");
-	assert_in_range(sz, sizeof(serial) + 3, INT_MAX);
+	assert_uint_in_range(sz, sizeof(serial) + 3, INT_MAX);
 	memset(buf, 0, sizeof(serial) + 3);
 	buf[1] = 0x80;
 	put_unaligned_be16(sizeof(serial) - 1, &buf[2]);
@@ -238,8 +242,8 @@ int __wrap_ioctl(int fd, unsigned long request, void *param)
 
 		if (hdr->interface_id == 'S' && hdr->cmdp[0] == 0x12
 		    && (hdr->cmdp[1] & 1) == 1 && hdr->cmdp[2] == HP3PAR_VPD) {
-			assert_in_range(hdr->dxfer_len,
-					sizeof(vpd_data) + 3, INT_MAX);
+			assert_uint_in_range(hdr->dxfer_len,
+					     sizeof(vpd_data) + 3, INT_MAX);
 			memset(buf, 0, hdr->dxfer_len);
 			buf[1] = HP3PAR_VPD;
 			put_unaligned_be16(sizeof(vpd_data), &buf[2]);
diff --git a/tests/test-log.c b/tests/test-log.c
index 9ace478..b907e7b 100644
--- a/tests/test-log.c
+++ b/tests/test-log.c
@@ -4,7 +4,7 @@
 #include <stdint.h>
 #include <stdio.h>
 #include <string.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "log.h"
 #include "test-log.h"
 #include "debug.h"
@@ -15,16 +15,16 @@ void __wrap_dlog (int prio, const char * fmt, ...)
 {
 	char buff[MAX_MSG_SIZE];
 	va_list ap;
-	char *expected;
+	const char *expected;
 
 	va_start(ap, fmt);
 	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
 	va_end(ap);
 	fprintf(stderr, "%s(%d): %s", __func__, prio, buff);
-	expected = mock_ptr_type(char *);
+	expected = mock_ptr_type(const char *);
 	if (memcmp(expected, buff, strlen(expected)))
 		fprintf(stderr, "%s(expected): %s", __func__, expected);
-	check_expected(prio);
+	check_expected_int(prio);
 	assert_memory_equal(buff, expected, strlen(expected));
 }
 
@@ -32,6 +32,6 @@ void expect_condlog(int prio, char *string)
 {
 	if (prio > MAX_VERBOSITY || prio > libmp_verbosity)
 		return;
-	expect_value(__wrap_dlog, prio, prio);
+	expect_int_value(__wrap_dlog, prio, prio);
 	will_return(__wrap_dlog, string);
 }
diff --git a/tests/uevent.c b/tests/uevent.c
index 39f5dbd..044d490 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -8,7 +8,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "list.h"
 #include "uevent.h"
 
diff --git a/tests/unaligned.c b/tests/unaligned.c
index e43b64d..252f8f4 100644
--- a/tests/unaligned.c
+++ b/tests/unaligned.c
@@ -6,7 +6,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include "unaligned.h"
 
 #define SIZE 16
@@ -40,13 +40,13 @@ static int teardown(void **state)
 	uint8_t *p = *state + SIZE;				\
 	uint64_t u;						\
 								\
-	assert_in_range(len, 1, SIZE);				\
-	assert_in_range(offset + len, 1, SIZE);			\
+	assert_int_in_range(len, 1, SIZE);				\
+	assert_int_in_range(offset + len, 1, SIZE);			\
 	memset(c, 0, 2 * SIZE);					\
 	memcpy(c + offset, memory, len);			\
 								\
 	u = get_unaligned_be##bits(c + offset);			\
-	assert_int_equal(u, intval##bits);			\
+	assert_uint_equal(u, intval##bits);			\
 	put_unaligned_be##bits(u, p + offset);			\
 	assert_memory_equal(c + offset, p  + offset, len);	\
 }
diff --git a/tests/util.c b/tests/util.c
index 67d8148..9f4a5d9 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -9,7 +9,7 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <endian.h>
 #include <string.h>
 #include "util.h"
@@ -204,7 +204,7 @@ static void test_bitmask_1(void **state)
 
 	bf = alloc_bitfield(BITARR_SZ * 64);
 	assert_non_null(bf);
-	assert_int_equal(bf->len, BITARR_SZ * 64);
+	assert_uint_equal(bf->len, BITARR_SZ * 64);
 	arr = (uint64_t *)bf->bits;
 
 	for (j = 0; j < BITARR_SZ; j++) {
@@ -218,9 +218,10 @@ static void test_bitmask_1(void **state)
 				       b, j, k, arr[k]);
 #endif
 				if (k == j)
-					assert_int_equal(maybe_swap(arr[j]), 1ULL << i);
+					assert_uint_equal(maybe_swap(arr[j]),
+							  1ULL << i);
 				else
-					assert_int_equal(arr[k], 0ULL);
+					assert_uint_equal(arr[k], 0ULL);
 			}
 			for (m = 0; m < 64; m++)
 				if (i == m)
@@ -232,7 +233,7 @@ static void test_bitmask_1(void **state)
 			clear_bit_in_bitfield(b, bf);
 			assert_false(is_bit_set_in_bitfield(b, bf));
 			for (k = 0; k < BITARR_SZ; k++)
-				assert_int_equal(arr[k], 0ULL);
+				assert_uint_equal(arr[k], 0ULL);
 		}
 	}
 	free(bf);
@@ -246,7 +247,7 @@ static void test_bitmask_2(void **state)
 
 	bf = alloc_bitfield(BITARR_SZ * 64);
 	assert_non_null(bf);
-	assert_int_equal(bf->len, BITARR_SZ * 64);
+	assert_uint_equal(bf->len, BITARR_SZ * 64);
 	arr = (uint64_t *)bf->bits;
 
 	for (j = 0; j < BITARR_SZ; j++) {
@@ -264,13 +265,12 @@ static void test_bitmask_2(void **state)
 			assert_true(is_bit_set_in_bitfield(b, bf));
 			for (k = 0; k < BITARR_SZ; k++) {
 				if (k < j || (k == j && i == 63))
-					assert_int_equal(arr[k], ~0ULL);
+					assert_uint_equal(arr[k], ~0ULL);
 				else if (k > j)
-					assert_int_equal(arr[k], 0ULL);
+					assert_uint_equal(arr[k], 0ULL);
 				else
-					assert_int_equal(
-						maybe_swap(arr[k]),
-						(1ULL << (i + 1)) - 1);
+					assert_uint_equal(maybe_swap(arr[k]),
+							  (1ULL << (i + 1)) - 1);
 			}
 		}
 	}
@@ -289,13 +289,12 @@ static void test_bitmask_2(void **state)
 			assert_false(is_bit_set_in_bitfield(b, bf));
 			for (k = 0; k < BITARR_SZ; k++) {
 				if (k < j || (k == j && i == 63))
-					assert_int_equal(arr[k], 0ULL);
+					assert_uint_equal(arr[k], 0ULL);
 				else if (k > j)
-					assert_int_equal(arr[k], ~0ULL);
+					assert_uint_equal(arr[k], ~0ULL);
 				else
-					assert_int_equal(
-						maybe_swap(arr[k]),
-						~((1ULL << (i + 1)) - 1));
+					assert_uint_equal(maybe_swap(arr[k]),
+							  ~((1ULL << (i + 1)) - 1));
 			}
 		}
 	}
@@ -334,23 +333,23 @@ static void _test_bitmask_small(unsigned int n)
 	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
 	assert_true(sizeof(bitfield_t) == 4 || sizeof(bitfield_t) == 8);
-	assert_in_range(n, 1, 64);
+	assert_uint_in_range(n, 1, 64);
 
 	bf = alloc_bitfield(n);
 	assert_non_null(bf);
-	assert_int_equal(bf->len, n);
+	assert_uint_equal(bf->len, n);
 	arr = (uint32_t *)bf->bits;
 
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n + 1, bf);
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n, bf);
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n - 1, bf);
 	for (i = 0; i < size; i++) {
@@ -359,19 +358,19 @@ static void _test_bitmask_small(unsigned int n)
 		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k)
-			assert_int_equal(arr[i1], 1UL << j);
+			assert_uint_equal(arr[i1], 1UL << j);
 		else
-			assert_int_equal(arr[i1], 0);
+			assert_uint_equal(arr[i1], 0);
 	}
 
 	clear_bit_in_bitfield(n - 1, bf);
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(0, bf);
-	assert_int_equal(arr[maybe_swap_idx(0)], 1);
+	assert_uint_equal(arr[maybe_swap_idx(0)], 1);
 	for (i = 1; i < size; i++)
-		assert_int_equal(arr[maybe_swap_idx(i)], 0);
+		assert_uint_equal(arr[maybe_swap_idx(i)], 0);
 
 	free(bf);
 }
@@ -382,35 +381,35 @@ static void _test_bitmask_small_2(unsigned int n)
 	uint32_t *arr;
 	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
-	assert_in_range(n, 65, 128);
+	assert_uint_in_range(n, 65, 128);
 
 	bf = alloc_bitfield(n);
 	assert_non_null(bf);
-	assert_int_equal(bf->len, n);
+	assert_uint_equal(bf->len, n);
 	arr = (uint32_t *)bf->bits;
 
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n + 1, bf);
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n, bf);
 	for (i = 0; i < size; i++)
-		assert_int_equal(arr[i], 0);
+		assert_uint_equal(arr[i], 0);
 
 	set_bit_in_bitfield(n - 1, bf);
-	assert_int_equal(arr[0], 0);
+	assert_uint_equal(arr[0], 0);
 	for (i = 0; i < size; i++) {
 		unsigned int k = (n - 1) / 32;
 		unsigned int j = (n - 1) - k * 32;
 		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k)
-			assert_int_equal(arr[i1], 1UL << j);
+			assert_uint_equal(arr[i1], 1UL << j);
 		else
-			assert_int_equal(arr[i1], 0);
+			assert_uint_equal(arr[i1], 0);
 	}
 
 	set_bit_in_bitfield(0, bf);
@@ -420,13 +419,13 @@ static void _test_bitmask_small_2(unsigned int n)
 		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && k == 0)
-			assert_int_equal(arr[i1], (1UL << j) | 1);
+			assert_uint_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i1], 1UL << j);
+			assert_uint_equal(arr[i1], 1UL << j);
 		else if (i == 0)
-			assert_int_equal(arr[i1], 1);
+			assert_uint_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i1], 0);
+			assert_uint_equal(arr[i1], 0);
 	}
 
 	set_bit_in_bitfield(64, bf);
@@ -436,13 +435,13 @@ static void _test_bitmask_small_2(unsigned int n)
 		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && (k == 0 || k == 2))
-			assert_int_equal(arr[i1], (1UL << j) | 1);
+			assert_uint_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i1], 1UL << j);
+			assert_uint_equal(arr[i1], 1UL << j);
 		else if (i == 2 || i == 0)
-			assert_int_equal(arr[i1], 1);
+			assert_uint_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i1], 0);
+			assert_uint_equal(arr[i1], 0);
 	}
 
 	clear_bit_in_bitfield(0, bf);
@@ -452,13 +451,13 @@ static void _test_bitmask_small_2(unsigned int n)
 		unsigned int i1 = maybe_swap_idx(i);
 
 		if (i == k && k == 2)
-			assert_int_equal(arr[i1], (1UL << j) | 1);
+			assert_uint_equal(arr[i1], (1UL << j) | 1);
 		else if (i == k)
-			assert_int_equal(arr[i1], 1UL << j);
+			assert_uint_equal(arr[i1], 1UL << j);
 		else if (i == 2)
-			assert_int_equal(arr[i1], 1);
+			assert_uint_equal(arr[i1], 1);
 		else
-			assert_int_equal(arr[i1], 0);
+			assert_uint_equal(arr[i1], 0);
 	}
 
 	free(bf);
@@ -568,7 +567,7 @@ static void test_strlcpy_0(void **state)
 	int rc;
 
 	rc = strlcpy(tst, src_str, 0);
-	assert_int_equal(rc, strlen(src_str));
+	assert_uint_equal(rc, strlen(src_str));
 	assert_string_equal(tst, dst_str);
 }
 
@@ -579,7 +578,7 @@ static void test_strlcpy_1(void **state)
 	int rc;
 
 	rc = strlcpy(tst, src_str, 1);
-	assert_int_equal(rc, strlen(src_str));
+	assert_uint_equal(rc, strlen(src_str));
 	assert_int_equal(tst[0], '\0');
 	assert_string_equal(tst + 1, dst_str + 1);
 }
@@ -591,7 +590,7 @@ static void test_strlcpy_2(void **state)
 	int rc;
 
 	rc = strlcpy(tst, src_str, 2);
-	assert_int_equal(rc, strlen(src_str));
+	assert_uint_equal(rc, strlen(src_str));
 	assert_int_equal(tst[0], src_str[0]);
 	assert_int_equal(tst[1], '\0');
 	assert_string_equal(tst + 2, dst_str + 2);
@@ -605,7 +604,7 @@ static void test_strlcpy_3(void **state)
 
 	rc = strlcpy(tst, src_str, sizeof(tst));
 	assert_int_equal(rc, strlen(src_str));
-	assert_int_equal(sizeof(tst) - 1, strlen(tst));
+	assert_uint_equal(sizeof(tst) - 1, strlen(tst));
 	assert_true(strncmp(tst, src_str, sizeof(tst) - 1) == 0);
 }
 
@@ -709,7 +708,7 @@ static int test_strlcpy(void)
 static void prep_buf(char *buf, size_t size, const char *word)
 {
 	memset(buf, FILL, size);
-	assert_in_range(strlen(word), 0, size - 1);
+	assert_uint_in_range(strlen(word), 0, size - 1);
 	memcpy(buf, word, strlen(word) + 1);
 }
 
@@ -899,7 +898,7 @@ static void test_strchop_nochop(void **state)
 {
 	char hello[] = "hello";
 
-	assert_int_equal(strchop(hello), 5);
+	assert_uint_equal(strchop(hello), 5);
 	assert_string_equal(hello, "hello");
 }
 
@@ -907,7 +906,7 @@ static void test_strchop_newline(void **state)
 {
 	char hello[] = "hello\n";
 
-	assert_int_equal(strchop(hello), 5);
+	assert_uint_equal(strchop(hello), 5);
 	assert_string_equal(hello, "hello");
 }
 
@@ -915,7 +914,7 @@ static void test_strchop_space(void **state)
 {
 	char hello[] = " ello      ";
 
-	assert_int_equal(strchop(hello), 5);
+	assert_uint_equal(strchop(hello), 5);
 	assert_string_equal(hello, " ello");
 }
 
@@ -923,7 +922,7 @@ static void test_strchop_mix(void **state)
 {
 	char hello[] = " el\no \t  \n\n \t    \n";
 
-	assert_int_equal(strchop(hello), 5);
+	assert_uint_equal(strchop(hello), 5);
 	assert_string_equal(hello, " el\no");
 }
 
@@ -931,7 +930,7 @@ static void test_strchop_blank(void **state)
 {
 	char hello[] = "  \t  \n\n \t    \n";
 
-	assert_int_equal(strchop(hello), 0);
+	assert_uint_equal(strchop(hello), 0);
 	assert_string_equal(hello, "");
 }
 
@@ -939,7 +938,7 @@ static void test_strchop_empty(void **state)
 {
 	char hello[] = "";
 
-	assert_int_equal(strchop(hello), 0);
+	assert_uint_equal(strchop(hello), 0);
 	assert_string_equal(hello, "");
 }
 
diff --git a/tests/valid.c b/tests/valid.c
index 3f15ce6..d6c8ee9 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -11,7 +11,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <errno.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <sys/sysmacros.h>
 
 #include "globals.c"
@@ -35,7 +35,7 @@ bool __wrap_sysfs_is_multipathed(struct path *pp, bool set_wwid)
 	assert_non_null(pp);
 	assert_int_not_equal(strlen(pp->dev), 0);
 	if (is_multipathed && set_wwid)
-		strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
+		strlcpy(pp->wwid, mock_ptr_type(const char *), WWID_SIZE);
 	return is_multipathed;
 }
 
@@ -59,7 +59,7 @@ int __wrap_mpath_disconnect(int fd)
 struct udev_device *__wrap_udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem, const char *sysname)
 {
 	bool passed = mock_type(bool);
-	assert_string_equal(sysname, mock_ptr_type(char *));
+	assert_string_equal(sysname, mock_ptr_type(const char *));
 	if (passed)
 		return &test_udev;
 	return NULL;
@@ -68,16 +68,16 @@ struct udev_device *__wrap_udev_device_new_from_subsystem_sysname(struct udev *u
 /* For devtype check */
 const char *__wrap_udev_device_get_property_value(struct udev_device *udev_device, const char *property)
 {
-	check_expected(property);
-	return mock_ptr_type(char *);
+	check_expected_ptr(property);
+	return mock_ptr_type(const char *);
 }
 
 /* For the "hidden" check in pathinfo() */
 const char *__wrap_udev_device_get_sysattr_value(struct udev_device *udev_device,
 					 const char *sysattr)
 {
-	check_expected(sysattr);
-	return mock_ptr_type(char *);
+	check_expected_ptr(sysattr);
+	return mock_ptr_type(const char *);
 }
 
 /* For pathinfo() -> is_claimed_by_foreign() */
@@ -89,7 +89,7 @@ int __wrap_add_foreign(struct udev_device *udev_device)
 /* For is_device_used() */
 const char *__wrap_udev_device_get_sysname(struct udev_device *udev_device)
 {
-	return mock_ptr_type(char *);
+	return mock_ptr_type(const char *);
 }
 
 /* called from pathinfo() */
@@ -121,7 +121,7 @@ int __wrap_sysfs_get_size(struct path *pp, unsigned long long * size)
 /* called in pathinfo() before filter_property() */
 int __wrap_select_getuid(struct config *conf, struct path *pp)
 {
-	pp->uid_attribute = mock_ptr_type(char *);
+	pp->uid_attribute = mock_ptr_type(const char *);
 	return 0;
 }
 
@@ -131,7 +131,7 @@ int __wrap_pathinfo(struct path *pp, struct config *conf, int mask)
 {
 	int ret = mock_type(int);
 
-	assert_string_equal(pp->dev, mock_ptr_type(char *));
+	assert_string_equal(pp->dev, mock_ptr_type(const char *));
 	assert_int_equal(mask, DI_SYSFS | DI_WWID | DI_BLACKLIST);
 	if (ret == PATHINFO_REAL) {
 		/* for test_filter_property() */
@@ -139,7 +139,7 @@ int __wrap_pathinfo(struct path *pp, struct config *conf, int mask)
 		return ret;
 	} else if (ret == PATHINFO_OK) {
 		pp->uid_attribute = "ID_TEST";
-		strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
+		strlcpy(pp->wwid, mock_ptr_type(const char *), WWID_SIZE);
 	} else
 		memset(pp->wwid, 0, WWID_SIZE);
 	return ret;
@@ -156,20 +156,20 @@ int __wrap_filter_property(struct config *conf, struct udev_device *udev,
 int __wrap_is_failed_wwid(const char *wwid)
 {
 	int ret = mock_type(int);
-	assert_string_equal(wwid, mock_ptr_type(char *));
+	assert_string_equal(wwid, mock_ptr_type(const char *));
 	return ret;
 }
 
 const char *__wrap_udev_device_get_syspath(struct udev_device *udevice)
 {
-	return mock_ptr_type(char *);
+	return mock_ptr_type(const char *);
 }
 
 int __wrap_check_wwids_file(char *wwid, int write_wwid)
 {
 	bool passed = mock_type(bool);
 	assert_int_equal(write_wwid, 0);
-	assert_string_equal(wwid, mock_ptr_type(char *));
+	assert_string_equal(wwid, mock_ptr_type(const char *));
 	if (passed)
 		return 0;
 	else
@@ -180,7 +180,7 @@ int __wrap_dm_find_map_by_wwid(const char *wwid, char *name,
 			       struct dm_info *dmi)
 {
 	int ret = mock_type(int);
-	assert_string_equal(wwid, mock_ptr_type(char *));
+	assert_string_equal(wwid, mock_ptr_type(const char *));
 	return ret;
 }
 
diff --git a/tests/vpd.c b/tests/vpd.c
index e3212e6..043b6aa 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -13,7 +13,7 @@
 #include <stdarg.h>
 #include <stddef.h>
 #include <setjmp.h>
-#include <cmocka.h>
+#include "cmocka-compat.h"
 #include <scsi/sg.h>
 #include "unaligned.h"
 #include "debug.h"
@@ -63,12 +63,12 @@ int WRAP_IOCTL(int fd, unsigned long request, void *param)
 {
 	int len;
 	struct sg_io_hdr *io_hdr;
-	unsigned char *val;
+	const unsigned char *val;
 
 	len = mock();
 	io_hdr = (struct sg_io_hdr *)param;
-	assert_in_range(len, 0, io_hdr->dxfer_len);
-	val = mock_ptr_type(unsigned char *);
+	assert_int_in_range(len, 0, io_hdr->dxfer_len);
+	val = mock_ptr_type(const unsigned char *);
 	io_hdr->status = 0;
 	memcpy(io_hdr->dxferp, val, len);
 	return 0;
@@ -260,7 +260,7 @@ static int create_scsi_string_desc(unsigned char *desc,
 	desc[1] = 8;
 	desc[2] = 0;
 
-	assert_in_range(type, STR_EUI, STR_IQN);
+	assert_int_in_range(type, STR_EUI, STR_IQN);
 	assert_true(maxlen % 4 == 0);
 	len = snprintf((char *)(desc + 4), maxlen, "%s%s",
 		       str_prefix[type], id);
@@ -354,7 +354,7 @@ static void assert_correct_wwid(const char *test,
 	}
 	/* check matching length, and length of WWID string */
 	assert_int_equal(expected, returned);
-	assert_int_equal(returned, strlen(wwid));
+	assert_uint_equal(returned, strlen(wwid));
 	/* check expected string value up to expected length */
 	for (i = 0; i < returned - ofs; i++)
 		assert_int_equal(wwid[ofs + i],
-- 
2.52.0

