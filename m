Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3931EB5E1
	for <dm-devel@lists.linux.dev>; Sat,  7 Mar 2026 01:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845583; cv=none; b=drCwteSkh86kziV02CFFAHy6P/eaMMwfaQMykaWYdr4/V8Pq1lNvKBV5TBDySdzXTM7oozz2fzG3nsVMx341F9s/6bFdDTJENb/k9wTvFHMCugzFUMgHpokSTrCbR9YuPHEvGYWWFNW6Ki7nRYDrnxYQQ5kBB0c0HIugsl4V/L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845583; c=relaxed/simple;
	bh=gPdb8RulG26hlU+zefDlU4fZ0Eh9Wbcqb3khJpobHaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pHuYm7CGU1jYeAMEpUMjR0pSJZSMCHIfDaWcX/DvpAbF4eDS2OJWvb9mEMWeSjB1kGhLDMBXwy5ZQuOITJLQ0Pg+EMb3udSki8RZPiEfsUAGd3j4ISahO/G+M/QqGclPM30TKmc9HJXwE8YQF930wW/HdMxcVP6ovqyQEe2jyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XdjWqp9y; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XdjWqp9y"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2bdfc4b191fso5394763eec.1
        for <dm-devel@lists.linux.dev>; Fri, 06 Mar 2026 17:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772845581; x=1773450381; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IeJm7iucEni8JZQfQqnV98iB4bEYRzAaPigok/OL+bc=;
        b=XdjWqp9yRD/HMZGBUbstrh0Ra7r59WSKi2hn7xegYnWAi2VvXbNqta5bcDKpZyD+fm
         L+0YbTC5dCjUAcdUbhU8EgIHxj3fe/3T/2Wi9SGQcnIQKHfD55QFie/tbhbGiZcDx29k
         G7kwN9fs4gQuzQCp4cH1aSWqX/cW5kbuqmVcf2SkDznqMZW6C9qILZRaE4VTcQZTH8bC
         eCyeXmV5iseUwWzH3EGP/A1ZkeVQ+l3RfPRiEBQvHOR/+b1MerKAiLtt+klDuAsS9M16
         QnUQzRSC0JA/Yy5LG28WT/3BNkaz+FtiK4v+fuNiQX3O5v5Bj2ZR9i3E6af9eLsQMYKb
         dlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772845581; x=1773450381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IeJm7iucEni8JZQfQqnV98iB4bEYRzAaPigok/OL+bc=;
        b=GYSa/kRjOfA+p8jhT/7EpA/F32nD+ViLPEmp5bM9tJDZPYCmDBJJDTrHBltKAcLDfq
         wQDhg6IYHLfkXUCo6kf9QJeJQIK1cvVhzXuOy+vyGklOXL7SGIBIMpx2XtsgNSAFocwQ
         pzC5goGPRhCrmvvvxH6Ar9KDKA2R/2iuWlKVvaGGsYE9FIORXFhod+3AxAoqKBsd/Oh6
         30aLpuN+x2O57MrFlr0JvuP9q+cOalVyygt6uxk5ThutlrZhlJB51GXpPlKiFbYn6p8q
         NN/FO3RTku9PXUtvLrGRXC7/hEay5C+h3FyuHmSRgDTMRM3ykuL3yoy4uayAmXhLBUPv
         QFXg==
X-Forwarded-Encrypted: i=1; AJvYcCXdNduAREyOiXL7aT7mNjjxmlbfXofybvv9yAUdRs3iOaHTs6crG57bJ16S+97sos64PNdh8IO1hg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4ZfKUoQx+tD12g8ZOb/pXHz/XzBNrWdKRYjGf/BIcyz4tYx3N
	WLm4vI6wFUbj9qRMqO1W6TgIx03SYZmGpbyKlbInpUXvgZcabrIo6mcvxKZmSL5R1Tg=
X-Gm-Gg: ATEYQzzfSJjrWSybFNmHtVVbbAO1hVuC7vhmmCs5jqONyStXu5pfFDKEm+arsUOw3oB
	sMcZ7lNDvULPL5Uwm40mGLrqxiIZ3He250tTbOM0iJc+BTNADvhFt3t4hgIb/e+gjwKHRp/74cP
	WJLNtiusbnzlaS2UG7jjnhNlvbiu8L+OzLNyBc2vNNV8XXyMJsDEuoRlDMwDHsBy7czOy06bp9L
	HT1ZYYVBTPGIh3Z+cQ5O0jjb9ffCbPfF9g4kv31y5agvTirf3sMPkavfXr5tfPULB+6qieAV2iO
	S0hwv662IkQ5HXD5ZSmRcjGQKS9bm8HPCn6KCSljDk3QFyLAUSor5L+AZzmqSZS/4VqcsmrlGgO
	4du/8zs23/j56wbGitmXZnj4nSRMAzOmWvdjb4lOrxhQDKgcRXniaVG8xLB9j3sLSOMxuamEo3Y
	vaojqZeY0mHDMSk3kog/9y01fDWh6N+OSDnTgJ19D1EeAYd2rTziadLGHkY3PiNLbAqkCQNVg4W
	yA37gkrbo264omD8VNHv7e5AlP8CZc0ZiVitrRj9A6UkV7y9ps/dg4=
X-Received: by 2002:a05:7300:1489:b0:2b8:6ae5:79c3 with SMTP id 5a478bee46e88-2be4e090105mr1571907eec.38.1772845580427;
        Fri, 06 Mar 2026 17:06:20 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f82851esm2246129eec.10.2026.03.06.17.06.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Mar 2026 17:06:19 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH] tests: add test demonstrating TUR checker race condition
Date: Fri,  6 Mar 2026 17:06:14 -0800
Message-ID: <20260307010614.1732-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test that reproduces the race condition in the TUR checker where
the checker thread has finished updating ct->state and ct->msgid (under
lock) but hasn't yet cleared ct->running. In this race window, the
code incorrectly returns PATH_PENDING even though a valid result is
already available.

NOTE: This test currently fails, demonstrating the bug exists.

The test includes two cases:
- test_race_window_result_ready: Simulates the race window where
  ct->running is still set but ct->msgid indicates the check has
  completed. This currently returns PATH_PENDING instead of the
  actual result (PATH_UP).
- test_thread_still_running: Verifies that when ct->msgid is
  MSG_TUR_RUNNING (thread genuinely hasn't finished), PATH_PENDING
  is correctly returned.

== running tur_race-test ==
[==========] Running 2 test(s).
[ RUN      ] test_race_window_result_ready
[  ERROR   ] --- 0x6 != 0x3
[   LINE   ] --- tur_race.c:104: error: Failure!
[  FAILED  ] test_race_window_result_ready
[ RUN      ] test_thread_still_running
[       OK ] test_thread_still_running
[==========] 2 test(s) run.
[  PASSED  ] 1 test(s).
[  FAILED  ] 1 test(s), listed below:
[  FAILED  ] test_race_window_result_ready

 1 FAILED TEST(S)

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 tests/Makefile   |   3 +-
 tests/tur_race.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 tests/tur_race.c

diff --git a/tests/Makefile b/tests/Makefile
index 9f1b950f..3d033d9a 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -9,7 +9,7 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter -Wno-unused-function $(W_MISSING_I
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo
+	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo tur_race
 HELPERS := test-lib.o test-log.o
 
 .PRECIOUS: $(TESTS:%=%-test)
@@ -65,6 +65,7 @@ features-test_LIBDEPS := -ludev -lpthread
 features-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
 cli-test_OBJDEPS := $(daemondir)/cli.o
 mapinfo-test_LIBDEPS = -lpthread -ldevmapper
+tur_race-test_LIBDEPS := -lpthread -lurcu
 
 %.o: %.c
 	@echo building $@ because of $?
diff --git a/tests/tur_race.c b/tests/tur_race.c
new file mode 100644
index 00000000..00ad3cea
--- /dev/null
+++ b/tests/tur_race.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test for TUR checker race condition.
+ *
+ * This test demonstrates a race condition where the checker thread has
+ * finished (set state/msgid under lock) but hasn't yet cleared ct->running.
+ * Currently, libcheck_check() incorrectly returns PATH_PENDING even though
+ * a valid result is available.
+ *
+ * NOTE: test_race_window_result_ready currently FAILS, demonstrating the bug.
+ */
+
+#define _GNU_SOURCE
+#include <stdint.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <time.h>
+#include "cmocka-compat.h"
+
+#include "globals.c"
+#include "../libmultipath/checkers/tur.c"
+
+/* Mock device for testing */
+static dev_t test_devt;
+
+static int setup(void **state)
+{
+	test_devt = makedev(8, 0);
+	return 0;
+}
+
+static int teardown(void **state)
+{
+	return 0;
+}
+
+/*
+ * Test: Simulate the race window where thread has finished but running != 0
+ *
+ * This simulates the state between:
+ *   pthread_mutex_unlock(&ct->lock);  // thread released lock
+ *   uatomic_set(&ct->running, 0);     // thread hasn't cleared running yet
+ *
+ * In this window:
+ *   - ct->state and ct->msgid have the final result
+ *   - ct->running is still 1
+ *
+ * BUG: The code sees running != 0 and returns PATH_PENDING, ignoring
+ * the valid result that is already available.
+ *
+ * This test currently FAILS, demonstrating the race condition.
+ */
+static void test_race_window_result_ready(void **state)
+{
+	struct checker c = {0};
+	struct tur_checker_context *ct;
+	int result;
+
+	/* Initialize the checker context manually to avoid dependencies */
+	ct = calloc(1, sizeof(struct tur_checker_context));
+	assert_non_null(ct);
+
+	pthread_mutex_init(&ct->lock, NULL);
+	pthread_cond_init(&ct->active, NULL);
+	uatomic_set(&ct->holders, 1);
+	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+
+	c.fd = 1;
+	c.timeout = 30;
+	c.context = ct;
+	assert_non_null(ct);
+
+	/*
+	 * Simulate race condition state:
+	 * - Thread has finished and set state/msgid
+	 * - Thread has NOT yet cleared running
+	 * - ct->thread is set (appears to be an active check)
+	 */
+	ct->thread = (pthread_t)1;  /* Non-zero: appears to be running */
+	ct->devt = test_devt;
+
+	pthread_mutex_lock(&ct->lock);
+	ct->state = PATH_UP;
+	ct->msgid = CHECKER_MSGID_UP;
+	pthread_mutex_unlock(&ct->lock);
+
+	uatomic_set(&ct->running, 1);  /* Thread "still running" */
+	ct->time = time(NULL) + 100;   /* Not timed out */
+
+	/* Call libcheck_check - this is where the race manifests */
+	result = libcheck_check(&c);
+
+	/*
+	 * Expected: PATH_UP (the result is ready)
+	 * Actual (BUG): PATH_PENDING (ignores ready result)
+	 *
+	 * This assertion currently FAILS, demonstrating the bug.
+	 */
+	assert_int_equal(result, PATH_UP);
+	assert_int_equal(c.msgid, CHECKER_MSGID_UP);
+
+	/* ct->thread was cleared by libcheck_check when it collected result */
+	ct->thread = 0;
+	uatomic_set(&ct->running, 0);
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	free(ct);
+}
+
+/*
+ * Test: Verify thread still running returns PATH_PENDING
+ *
+ * When the thread genuinely hasn't finished (msgid == MSG_TUR_RUNNING),
+ * we should correctly return PATH_PENDING.
+ */
+static void test_thread_still_running(void **state)
+{
+	struct checker c = {0};
+	struct tur_checker_context *ct;
+	int result;
+
+	/* Initialize the checker context manually to avoid dependencies */
+	ct = calloc(1, sizeof(struct tur_checker_context));
+	assert_non_null(ct);
+
+	pthread_mutex_init(&ct->lock, NULL);
+	pthread_cond_init(&ct->active, NULL);
+	uatomic_set(&ct->holders, 1);
+	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+
+	c.fd = 1;
+	c.timeout = 30;
+	c.context = ct;
+
+	/* Thread is genuinely still running - no result yet */
+	ct->thread = (pthread_t)1;
+	ct->devt = test_devt;
+
+	pthread_mutex_lock(&ct->lock);
+	ct->state = PATH_PENDING;
+	ct->msgid = MSG_TUR_RUNNING;  /* Thread hasn't set result yet */
+	pthread_mutex_unlock(&ct->lock);
+
+	uatomic_set(&ct->running, 1);
+	ct->time = time(NULL) + 100;
+
+	result = libcheck_check(&c);
+
+	/* Should correctly return PATH_PENDING */
+	assert_int_equal(result, PATH_PENDING);
+
+	ct->thread = 0;
+	uatomic_set(&ct->running, 0);
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	free(ct);
+}
+
+int main(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test_setup_teardown(test_race_window_result_ready,
+						setup, teardown),
+		cmocka_unit_test_setup_teardown(test_thread_still_running,
+						setup, teardown),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
-- 
2.52.0

