Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609AA176AAD
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804555; cv=none; b=GHfjvcrhWhD/imPKUlhUm8WVqmQbavw50WHWt14dB9IchiLemVtL4Y57cEYlFKu8zB2lS8DqIc/CCVuqrAQCGeiHjl0bdR1dvATL4rEYwzh8J7o9X7WjVKVzXd0ThI1/5CzuqjIgMdyQpYsVWRyNoUnD3Gbrs3dUl876PPR+K58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804555; c=relaxed/simple;
	bh=+SETk7/NYbUTUVzSVuSJXDkEI3nxRFYPazbLUKUyFc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVF0LzYpLeud/udiyLZkOKaLHHCIt3kL+v2Q+8PzTobvL+QUSCnY2t6F2MwXGaqIdRrV5muiuXjACPYuUq7cPvxTkVBT9bxd9Dg4BSnZAyvG4NxopAI3wAJCPm10GAfXXQK9o8S/6Ho58UQaSLHdESsAg5WweDPd0xjEbgMfo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WkVEPQs7; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WkVEPQs7"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so3190525a12.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804551; x=1721409351; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0g7S5N57ybsPOWQVQANTF292ofgfH7Tv5VKS9orJXM=;
        b=WkVEPQs7AKsuc86OZ5uLVS+0EkyXHAOOKVFbI5Xa/XKGTFIdQUGmeEnRBq2mB/9j+h
         jjCfV4dYbjTOPvwnja7thPFl8P7T2B95raDOLTfT2/1DcV44aFq35Ln+huLwPjSFwheT
         WBoukppDs91ixe7OmCmMk0e2FGMo7McCBnd8mcku5zbfOowNX5zUNNk3I2ZsgYt5Bt53
         McTzHG3dGnQomCbtcGZNoxsXA8q27BcLpgeU+gPPtvT0dV+l6571jev9m3rqZfYwIlnP
         S/FEIYUdRHAd03BZfRY8EkvI+6M2KEIPB/gyYoICSO9Mah2wvnyAX7XnUHKifn8SffmM
         zXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804551; x=1721409351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0g7S5N57ybsPOWQVQANTF292ofgfH7Tv5VKS9orJXM=;
        b=G0JrGfxTZZlmupv8455K9Rf99yOVLzuH3jOKSKfk5U65BLjb81+9JVu+C2AttcjybG
         +qHj/n67/PBpNmrFzRX2sDcdWQCx6tma1u5+MZ0C9ml7uKjCs1PEjzVaDYfAzCJG+ZHF
         8Yfvw4ia1WLhWs9H1wxNtLNSZxbANz9l/yTkqQy3KPxhtffbbhWBsKEIKFrZWBr/gyWM
         xVqmC6pSnrD7Mt+R6dXQgz7zebfCAHrj+6EE8YXZnH999pKVEj8jMzNVPHPpGrKr5igf
         L0afTB/YQOvSDkynkoRmXjgpvjglZq1Ljm9kxXq6qqKoh3ovTEfUwvcyBPbVMgHQsqy7
         aCbA==
X-Gm-Message-State: AOJu0YyvHVEwbYWywDzD2niyTGyeGbPhFHcMJqw+GA2KNkkvSbtG78Au
	6rgteW+ClofSmsKCmqR5CQgtHaSSilMo6G4NYGOwSLSkaQbXPUISaDfkR1Lgzek=
X-Google-Smtp-Source: AGHT+IFmU3domEu02vC1iGcKaxAAOCVwZ/jI1XgwbN5wEXpWGRWYsxUk1Z9n6q4PAE+ZqZFDg5OlPg==
X-Received: by 2002:a05:6402:210f:b0:58b:6096:5554 with SMTP id 4fb4d7f45d1cf-594bcba7e40mr10101129a12.37.1720804550406;
        Fri, 12 Jul 2024 10:15:50 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bb9604d4sm4727995a12.20.2024.07.12.10.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:50 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/49] libmultipath tests: add tests for libmp_mapinfo()
Date: Fri, 12 Jul 2024 19:14:28 +0200
Message-ID: <20240712171458.77611-21-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unfortunately, we need several ugly compatibility macros again
in order to make these tests work with the entire set of compilers
and libraries supported by multipath-tools. Details are found in
comments in the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.h |    1 +
 tests/Makefile           |    3 +-
 tests/mapinfo.c          | 1175 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 1178 insertions(+), 1 deletion(-)
 create mode 100644 tests/mapinfo.c

diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 725889b..62f50de 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,5 +1,6 @@
 #ifndef _DEVMAPPER_H
 #define _DEVMAPPER_H
+#include <sys/sysmacros.h>
 #include <linux/dm-ioctl.h>
 #include "autoconfig.h"
 #include "structs.h"
diff --git a/tests/Makefile b/tests/Makefile
index 8afa8c6..55fbf0f 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -9,7 +9,7 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf sysfs features cli
+	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo
 HELPERS := test-lib.o test-log.o
 
 .PRECIOUS: $(TESTS:%=%-test)
@@ -68,6 +68,7 @@ sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o
 sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 features-test_LIBDEPS := -ludev -lpthread
 cli-test_OBJDEPS := $(daemondir)/cli.o
+mapinfo-test_LIBDEPS = -lpthread -ldevmapper
 
 %.o: %.c
 	@echo building $@ because of $?
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
new file mode 100644
index 0000000..f3a8440
--- /dev/null
+++ b/tests/mapinfo.c
@@ -0,0 +1,1175 @@
+/*
+ * Copyright (c) 2024 Martin Wilck, SUSE
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+/*
+ * glibc <= 2.19 (Ubuntu Trusty, Debian Jessie) uses macros to inline strdup(),
+ * which makes our strdup wrapper fail.
+ */
+#define _GNU_SOURCE 1
+#include <features.h>
+#include <linux/types.h>
+#ifndef __GLIBC_PREREQ
+#define __GLIBC_PREREQ(x, y) 0
+#endif
+#if defined(__GLIBC__) && !(__GLIBC_PREREQ(2, 20))
+#define __NO_STRING_INLINES 1
+#endif
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <cmocka.h>
+#include "util.h"
+#include "devmapper.h"
+#include "globals.c"
+/*
+ * We can't just use mapinfo-test_OBJDEPS because
+ */
+#include "../libmultipath/devmapper.c"
+
+static const struct dm_info __attribute__((unused)) MPATH_DMI_01 = {
+	.exists = 1,
+	.live_table = 1,
+	.open_count = 1,
+	.target_count = 1,
+	.major = 254,
+	.minor = 123,
+};
+
+static const char MPATH_NAME_01[] = "mpathx";
+static const char MPATH_UUID_01[] = "mpath-3600a098038302d414b2b4d4453474f62";
+static const char MPATH_TARGET_01[] =
+	"2 pg_init_retries 50 1 alua 2 1 "
+	"service-time 0 3 2 65:32 1 1 67:64 1 1 69:96 1 1 "
+	"service-time 0 3 2 8:16 1 1 66:48 1 1 68:80 1 1 ";
+static const char MPATH_STATUS_01[] =
+	"2 0 1 0 2 1 "
+	"A 0 3 2 65:32 A 0 0 1 67:64 A 0 0 1 69:96 A 0 0 1 "
+	"E 0 3 2 8:16 A 0 0 1 66:48 A 0 0 1 68:80 A 0 0 1 ";
+
+char *__real_strdup(const char *str);
+char *__wrap_strdup(const char *str)
+{
+	if (mock_type(int))
+		return __real_strdup(str);
+	return NULL;
+}
+
+void __wrap_dm_task_destroy(struct dm_task *t)
+{
+}
+
+struct dm_task *__wrap_dm_task_create(int task)
+{
+	check_expected(task);
+	return mock_ptr_type(void *);
+}
+
+int __wrap_dm_task_run(struct dm_task *t)
+{
+	return mock_type(int);
+}
+
+/*
+ * Hack for older versions of libdevmapper, where dm_task_get_errno()
+ * is not available.
+ */
+#ifndef LIBDM_API_GET_ERRNO
+#define WILL_RETURN_GET_ERRNO(y) do { errno = y; } while (0)
+#else
+int __wrap_dm_task_get_errno(struct dm_task *t)
+{
+	return mock_type(int);
+}
+#define WILL_RETURN_GET_ERRNO(y) will_return(__wrap_dm_task_get_errno, y)
+#endif
+
+int __wrap_dm_task_set_name(struct dm_task *t, const char *name)
+{
+	check_expected(name);
+	return mock_type(int);
+}
+
+int __wrap_dm_task_set_uuid(struct dm_task *t, const char *uuid)
+{
+	check_expected(uuid);
+	return mock_type(int);
+}
+
+int __wrap_dm_task_set_major(struct dm_task *t, int val)
+{
+	check_expected(val);
+	return mock_type(int);
+}
+
+int __wrap_dm_task_set_minor(struct dm_task *t, int val)
+{
+	check_expected(val);
+	return mock_type(int);
+}
+
+/* between LVM2 2.02.110 and 2.02.112, dm_task_get_info was a macro */
+#ifdef dm_task_get_info
+#define WRAP_DM_TASK_GET_INFO(x) \
+	will_return(__wrap_dm_task_get_info_with_deferred_remove, x)
+int __wrap_dm_task_get_info_with_deferred_remove(struct dm_task *t, struct dm_info *dmi)
+#else
+#define WRAP_DM_TASK_GET_INFO(x) \
+	will_return(__wrap_dm_task_get_info, x)
+int __wrap_dm_task_get_info(struct dm_task *t, struct dm_info *dmi)
+#endif
+{
+	int rc = mock_type(int);
+
+	assert_non_null(dmi);
+	if (rc) {
+		struct dm_info *info = mock_ptr_type(struct dm_info *);
+
+		memcpy(dmi, info, sizeof(*dmi));
+	}
+	return rc;
+}
+
+void * __wrap_dm_get_next_target(struct dm_task *dmt, void *next,
+				uint64_t *start, uint64_t *length,
+				char **target_type, char **params)
+{
+	*start = 0;
+	*length = mock_type(uint64_t);
+	*target_type = mock_ptr_type(char *);
+	*params = mock_ptr_type(char *);
+	return mock_ptr_type(void *);
+}
+
+static void mock_dm_get_next_target(uint64_t len, const char *target_type,
+				    const char *params, void *next)
+{
+	will_return(__wrap_dm_get_next_target, len);
+	will_return(__wrap_dm_get_next_target, target_type);
+	will_return(__wrap_dm_get_next_target, params);
+	will_return(__wrap_dm_get_next_target, next);
+}
+
+const char *__wrap_dm_task_get_name(struct dm_task *t)
+{
+	return mock_ptr_type(const char *);
+}
+
+const char *__wrap_dm_task_get_uuid(struct dm_task *t)
+{
+	return mock_ptr_type(const char *);
+}
+
+static void mock_mapinfo_name_1(int ioctl_nr, int create_rc, const char *name,
+				int name_rc, int run_rc, int err)
+{
+	expect_value(__wrap_dm_task_create, task, ioctl_nr);
+	will_return(__wrap_dm_task_create, create_rc);
+	if (create_rc == 0)
+		return;
+	expect_value(__wrap_dm_task_set_name, name, name);
+	will_return(__wrap_dm_task_set_name, name_rc);
+	if (name_rc == 0)
+		return;
+	will_return(__wrap_dm_task_run, run_rc);
+	if (run_rc == 0) {
+		WILL_RETURN_GET_ERRNO(err);
+		/* for dm_log_error() */
+		WILL_RETURN_GET_ERRNO(err);
+	}
+}
+
+static void test_mapinfo_bad_task_create_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 0, NULL, 0, 0, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_mapid(void **state)
+{
+	int rc;
+
+	/* can't use mock_mapinfo_name() here because of invalid id type */
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME + 100,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_set_name(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 0, 0, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_task_run_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_task_run_02(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 0, ENXIO);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+/* libmp_mapinfo must choose DM_DEVICE_STATUS */
+static void test_mapinfo_bad_task_run_03(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_task_run_04(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, ENXIO);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+/* If target is set, libmp_mapinfo must choose DM_DEVICE_TABLE */
+static void test_mapinfo_bad_task_run_05(void **state)
+{
+	int rc;
+	char *params = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &params });
+	assert_int_equal(rc, DMP_ERR);
+	assert_ptr_equal(params, NULL);
+}
+
+static void test_mapinfo_bad_task_run_06(void **state)
+{
+	int rc;
+	char *params = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 0, ENXIO);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &params });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+	assert_ptr_equal(params, NULL);
+}
+
+/* If status is set, libmp_mapinfo must choose DM_DEVICE_STATUS */
+static void test_mapinfo_bad_task_run_07(void **state)
+{
+	int rc;
+	char *params = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &params });
+	assert_int_equal(rc, DMP_ERR);
+	assert_ptr_equal(params, NULL);
+}
+
+static void test_mapinfo_bad_task_run_08(void **state)
+{
+	int rc;
+	char *params = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, ENXIO);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &params });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+	assert_ptr_equal(params, NULL);
+}
+
+static void test_mapinfo_bad_task_run_09(void **state)
+{
+	int rc;
+	char *params = NULL, *status = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &params, .status = &status });
+	assert_int_equal(rc, DMP_ERR);
+	assert_ptr_equal(params, NULL);
+	assert_ptr_equal(status, NULL);
+}
+
+static void test_mapinfo_bad_task_run_10(void **state)
+{
+	int rc;
+	char *params = NULL, *status = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 0, ENXIO);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &params, .status = &status });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+	assert_ptr_equal(params, NULL);
+	assert_ptr_equal(status, NULL);
+}
+
+static void test_mapinfo_bad_get_info_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(0);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_get_info_02(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&dmi);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+static void test_mapinfo_bad_get_info_03(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(0);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_get_info_04(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&dmi);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+static void test_mapinfo_good_exists(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_bad_set_uuid(void **state)
+{
+	int rc;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_uuid, uuid, "foo");
+	will_return(__wrap_dm_task_set_uuid, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_set_dev_01(void **state)
+{
+	int rc;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_DEV,
+			   (mapid_t) { ._u = { 254, 123 } },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_set_dev_02(void **state)
+{
+	int rc;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 1);
+	expect_value(__wrap_dm_task_set_minor, val, 123);
+	will_return(__wrap_dm_task_set_minor, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_DEV,
+			   (mapid_t) { ._u = { 254, 123 } },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_set_dev_03(void **state)
+{
+	int rc;
+	dev_t devt = makedev(254, 123);
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_DEVT,
+			   (mapid_t) { .devt = devt },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_set_dev_04(void **state)
+{
+	int rc;
+	dev_t devt = makedev(254, 123);
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 1);
+	expect_value(__wrap_dm_task_set_minor, val, 123);
+	will_return(__wrap_dm_task_set_minor, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_DEVT,
+			   (mapid_t) { .devt = devt },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_good_info(void **state)
+{
+	int rc;
+	struct dm_info dmi;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+}
+
+static void test_mapinfo_good_by_uuid_info(void **state)
+{
+	int rc;
+	struct dm_info dmi;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_uuid, uuid, "foo");
+	will_return(__wrap_dm_task_set_uuid, 1);
+	will_return(__wrap_dm_task_run, 1);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	rc = libmp_mapinfo(DM_MAP_BY_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+}
+
+static void test_mapinfo_good_by_dev_info(void **state)
+{
+	int rc;
+	struct dm_info dmi;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 1);
+	expect_value(__wrap_dm_task_set_minor, val, 123);
+	will_return(__wrap_dm_task_set_minor, 1);
+	will_return(__wrap_dm_task_run, 1);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	rc = libmp_mapinfo(DM_MAP_BY_DEV,
+			   (mapid_t) { ._u = { 254, 123 } },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+}
+
+static void test_mapinfo_good_by_devt_info(void **state)
+{
+	dev_t devt = makedev(254, 123);
+	int rc;
+	struct dm_info dmi;
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_INFO);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_major, val, 254);
+	will_return(__wrap_dm_task_set_major, 1);
+	expect_value(__wrap_dm_task_set_minor, val, 123);
+	will_return(__wrap_dm_task_set_minor, 1);
+	will_return(__wrap_dm_task_run, 1);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	rc = libmp_mapinfo(DM_MAP_BY_DEVT,
+			   (mapid_t) { .devt = devt },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+}
+
+static void test_mapinfo_bad_name(void **state)
+{
+	int rc;
+	char name[WWID_SIZE] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_name, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = name });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_good_name(void **state)
+{
+	int rc;
+	char name[WWID_SIZE] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = name });
+	assert_int_equal(rc, DMP_OK);
+	assert_true(!strcmp(name, MPATH_NAME_01));
+}
+
+static void test_mapinfo_bad_uuid(void **state)
+{
+	int rc;
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .uuid = uuid });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_good_uuid(void **state)
+{
+	int rc;
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .uuid = uuid });
+	assert_int_equal(rc, DMP_OK);
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
+}
+
+/* If size is set, libmp_mapinfo needs to do a DM_DEVICE_STATUS ioctl */
+static void test_mapinfo_good_size(void **state)
+{
+	int rc;
+	unsigned long long size;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, NULL, MPATH_TARGET_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .size = &size });
+	assert_int_equal(rc, DMP_OK);
+	assert_int_equal(size, 12345);
+}
+
+static void test_mapinfo_bad_next_target_01(void **state)
+{
+	int rc;
+	unsigned long long size;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	/* multiple targets */
+	mock_dm_get_next_target(12345, NULL, MPATH_STATUS_01, (void *)1);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .size = &size });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+static void test_mapinfo_bad_next_target_02(void **state)
+{
+	int rc;
+	unsigned long long size;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	/* no targets */
+	mock_dm_get_next_target(12345, NULL, NULL, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .size = &size });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+}
+
+/* libmp_mapinfo needs to do a DM_DEVICE_STATUS ioctl */
+static void test_mapinfo_bad_target_type_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, "linear", MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_target_type_02(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_target_type_03(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_PART, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	/* make sure memory content is not changed */
+	assert_memory_equal(&dmi, &((struct dm_info) { .exists = 0 }), sizeof(dmi));
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+}
+
+static void test_mapinfo_bad_target_type_04(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &status });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_null(status);
+}
+
+static void test_mapinfo_bad_target_type_05(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *target = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &target });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_null(target);
+}
+
+static void test_mapinfo_good_target_type_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_target_type_02(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_PART, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_target_type_03(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+}
+
+/* test for returning multiple parameters */
+static void test_mapinfo_good_target_type_04(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid });
+	assert_int_equal(rc, DMP_OK);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
+}
+
+static void test_mapinfo_good_status_01(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_strdup, 1);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &status });
+	assert_int_equal(rc, DMP_OK);
+	assert_non_null(status);
+	assert_true(!strcmp(status, MPATH_STATUS_01));
+}
+
+static void test_mapinfo_bad_strdup_01(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	will_return(__wrap_strdup, 0);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &status, .uuid = uuid, .name = name });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+
+}
+
+static void test_mapinfo_bad_get_name_01(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &status, .uuid = uuid, .name = name });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+
+}
+
+static void test_mapinfo_bad_get_uuid_01(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .status = &status, .uuid = uuid, .name = name });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+
+}
+
+static void test_mapinfo_bad_task_run_11(void **state)
+{
+	int rc;
+	char *params = NULL, *status = NULL;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, NULL, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 1);
+	/* error in 2nd dm_task_run */
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, EINVAL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &params, .status = &status });
+	assert_int_equal(rc, DMP_ERR);
+	assert_ptr_equal(params, NULL);
+	assert_ptr_equal(status, NULL);
+}
+
+static void test_mapinfo_bad_get_name_02(void **state)
+{
+	int rc;
+	char *target = NULL, *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 1);
+	/* 2nd ioctl */
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, NULL);
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) {
+				   .target = &target, .status = &status,
+				   .uuid = uuid, .name = name, .dmi = &dmi });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_null(target);
+	assert_memory_equal(&dmi, &((struct dm_info) { .suspended = 0 }), sizeof(dmi));
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+}
+
+static void test_mapinfo_bad_get_uuid_02(void **state)
+{
+	int rc;
+	char *target = NULL, *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 1);
+	/* 2nd ioctl */
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, NULL);
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) {
+				   .target = &target, .status = &status,
+				   .uuid = uuid, .name = name, .dmi = &dmi });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_null(target);
+	assert_memory_equal(&dmi, &((struct dm_info) { .suspended = 0 }), sizeof(dmi));
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+}
+
+static void test_mapinfo_bad_strdup_02(void **state)
+{
+	int rc;
+	char *target = NULL, *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 1);
+	/* 2nd ioctl */
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	will_return(__wrap_strdup, 0);
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) {
+				   .target = &target, .status = &status,
+				   .uuid = uuid, .name = name, .dmi = &dmi });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_null(target);
+	assert_memory_equal(&dmi, &((struct dm_info) { .suspended = 0 }), sizeof(dmi));
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+}
+
+static void test_mapinfo_bad_strdup_03(void **state)
+{
+	int rc;
+	char *target = NULL, *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 0);
+	/* No 2nd ioctl, as there was an error in the 1st */
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) {
+				   .target = &target, .status = &status,
+				   .uuid = uuid, .name = name, .dmi = &dmi });
+	assert_int_equal(rc, DMP_ERR);
+	assert_null(status);
+	assert_null(target);
+	assert_memory_equal(&dmi, &((struct dm_info) { .suspended = 0 }), sizeof(dmi));
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+}
+
+static void test_mapinfo_good_all_01(void **state)
+{
+	int rc;
+	char __attribute__((cleanup(cleanup_charp))) *target = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+	unsigned long long size;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_TARGET_01, NULL);
+	will_return(__wrap_strdup, 1);
+	/* 2nd ioctl */
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	will_return(__wrap_strdup, 1);
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) {
+				   .target = &target, .status = &status,
+				   .uuid = uuid, .name = name,
+				   .dmi = &dmi, .size = &size });
+	assert_int_equal(rc, DMP_OK);
+	assert_non_null(status);
+	assert_non_null(target);
+	assert_int_equal(size, 12345);
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+	assert_true(!strcmp(target, MPATH_TARGET_01));
+	assert_true(!strcmp(status, MPATH_STATUS_01));
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
+}
+
+static int test_mapinfo(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_mapinfo_bad_task_create_01),
+		cmocka_unit_test(test_mapinfo_bad_mapid),
+		cmocka_unit_test(test_mapinfo_bad_set_name),
+		cmocka_unit_test(test_mapinfo_bad_task_run_01),
+		cmocka_unit_test(test_mapinfo_bad_task_run_02),
+		cmocka_unit_test(test_mapinfo_bad_task_run_03),
+		cmocka_unit_test(test_mapinfo_bad_task_run_04),
+		cmocka_unit_test(test_mapinfo_bad_task_run_05),
+		cmocka_unit_test(test_mapinfo_bad_task_run_06),
+		cmocka_unit_test(test_mapinfo_bad_task_run_07),
+		cmocka_unit_test(test_mapinfo_bad_task_run_08),
+		cmocka_unit_test(test_mapinfo_bad_task_run_09),
+		cmocka_unit_test(test_mapinfo_bad_task_run_10),
+		cmocka_unit_test(test_mapinfo_bad_task_run_11),
+		cmocka_unit_test(test_mapinfo_bad_get_info_01),
+		cmocka_unit_test(test_mapinfo_bad_get_info_02),
+		cmocka_unit_test(test_mapinfo_bad_get_info_03),
+		cmocka_unit_test(test_mapinfo_bad_get_info_04),
+		cmocka_unit_test(test_mapinfo_good_exists),
+		cmocka_unit_test(test_mapinfo_bad_set_uuid),
+		cmocka_unit_test(test_mapinfo_bad_set_dev_01),
+		cmocka_unit_test(test_mapinfo_bad_set_dev_02),
+		cmocka_unit_test(test_mapinfo_bad_set_dev_03),
+		cmocka_unit_test(test_mapinfo_bad_set_dev_04),
+		cmocka_unit_test(test_mapinfo_good_info),
+		cmocka_unit_test(test_mapinfo_good_by_uuid_info),
+		cmocka_unit_test(test_mapinfo_good_by_dev_info),
+		cmocka_unit_test(test_mapinfo_good_by_devt_info),
+		cmocka_unit_test(test_mapinfo_bad_name),
+		cmocka_unit_test(test_mapinfo_good_name),
+		cmocka_unit_test(test_mapinfo_bad_uuid),
+		cmocka_unit_test(test_mapinfo_good_uuid),
+		cmocka_unit_test(test_mapinfo_good_size),
+		cmocka_unit_test(test_mapinfo_bad_next_target_01),
+		cmocka_unit_test(test_mapinfo_bad_next_target_02),
+		cmocka_unit_test(test_mapinfo_bad_target_type_01),
+		cmocka_unit_test(test_mapinfo_bad_target_type_02),
+		cmocka_unit_test(test_mapinfo_bad_target_type_03),
+		cmocka_unit_test(test_mapinfo_bad_target_type_04),
+		cmocka_unit_test(test_mapinfo_bad_target_type_05),
+		cmocka_unit_test(test_mapinfo_good_target_type_01),
+		cmocka_unit_test(test_mapinfo_good_target_type_02),
+		cmocka_unit_test(test_mapinfo_good_target_type_03),
+		cmocka_unit_test(test_mapinfo_good_target_type_04),
+		cmocka_unit_test(test_mapinfo_good_status_01),
+		cmocka_unit_test(test_mapinfo_bad_get_name_01),
+		cmocka_unit_test(test_mapinfo_bad_get_uuid_01),
+		cmocka_unit_test(test_mapinfo_bad_strdup_01),
+		cmocka_unit_test(test_mapinfo_bad_get_name_02),
+		cmocka_unit_test(test_mapinfo_bad_get_uuid_02),
+		cmocka_unit_test(test_mapinfo_bad_strdup_02),
+		cmocka_unit_test(test_mapinfo_bad_strdup_03),
+		cmocka_unit_test(test_mapinfo_good_all_01),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(4);
+	skip_libmp_dm_init();
+	ret += test_mapinfo();
+	return ret;
+}
-- 
2.45.2

