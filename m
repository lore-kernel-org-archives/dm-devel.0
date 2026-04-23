Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979D2C15A0
	for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977110; cv=none; b=est86jVjWM10aZo1xeuL1RTJtNIXaVYF5trWjCSUgguhS+Lm9RIwgNEWBFzUNfa1osSmdH/m7tA/Kjqyb8fuRqe8SeUZMnoNPE8cdMkQKn3Ai1/AeJdaCUbWmr0B5TM7HbY7o5UFq06FnYIEJSMr8zdlaIJVo4khiVc78h63Uvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977110; c=relaxed/simple;
	bh=q2fZXB60/akpbKw2m805pnAHrtLvGQG0U/u2NNf904Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO1TvvPvQb3iOS5q9TK+uy02Ago8SwBrcro0KFV21TnvzGc53EadcpLRloJFoc2G2yAM6OkpCmMgBF76yeReMV3S+ReONrJi44zIftc5p3quC4jnlbGfvTMjQ4UdFKV2ABbm3jaeWE7jYfAHeIN2BceucyDkdA1XqgZViH3W+3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GDMAsVbR; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GDMAsVbR"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso51984855e9.2
        for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 13:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776977107; x=1777581907; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDm96F7IIR1ELuzBwcY9QXZNGoFG3ihjtbsFkJvaMKk=;
        b=GDMAsVbRu/HfVeTMzNOGyWbODQNwjac5eA8oqk7qBGbcNRdDSY41ntZrzSh04HdAi3
         7f8BNECwbTOWDPiUaAnmCnp/0kQdQFhgTLBeZF1wgQEu3jZ8T0EeR4V4O3dk01bAD8dG
         qI7EROecfRQHF71+4zzsrO/2bBj9bugjW3OeijDs9iD3DZ1BGK0HdbBEPipmAoQ/WbDY
         ylgv9+d1istL3q8avlUP/sSWkkVUQkQVoGzYpWCq5Ssigh+HkNoo/bCIC4BLMk2DbCLi
         WnhWCD+Yc8SFqqepRjnl6tp0HkOk0T0H+OWZ5vepMvyElfZR5ioKdlghbUUgOPzm4fMc
         Pyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977107; x=1777581907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rDm96F7IIR1ELuzBwcY9QXZNGoFG3ihjtbsFkJvaMKk=;
        b=S26+4oyizR7Rz0jBMK1hUEY3WUM0dHqPJepieCBY6XDVgcKpxlBFWMivljFkZb4M7G
         DnMhQl1K4umfavLLqXz4s8FaJxejz4TfO6qk8XSyEfhWX4sPaehfVjzqF7oseS7wcJBt
         TjmO66jQfnPSiJFMtDjdsHWKWofzOe15Ukme/ZOGsCnPKVRGepcIonippkPgflMpp2sR
         N0AcJ78q3pNT1uccMVzP/28LfQLQ4PmUgZCgq51HTYuye/Unr1KyifHWg7Fm58y6o4qK
         kf6SRkAF6o/XpHiiGuw9pGv8TzKIlojb3nfT7GuVBgrXNFs041yrFVgsoaztjA6flHOM
         I/yg==
X-Forwarded-Encrypted: i=1; AFNElJ8qKQqKgdOptYxIEbMnpnaH6dwDSzu5C7Jk5vk1xT5ORj5Sno9e2QFoeUTnPtd9UXn2dygRH5AEuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwugEwws4yXYQe9ncwY84JDXahyXuDBa/zFH7BF/L691IsxOHRr
	f43wA7shuG9IK17hBxQUczDynSSW666F1dMzb2QkVsoZip6jRoZEXUTP0vcOfqbtROs=
X-Gm-Gg: AeBDieun+n8Sn0s/NaNXdsSFEthFYuuvnuCUc9TloSq1pU63Cg8FYzE1i5F+kpCwKYc
	klYjkVWDNfO6E2/8NPG/yqXFyuGKrWHClfeECPL+pWHQ4yQUdejiIvv5DewTPBGTkZ1AWpPlA9h
	vER04i+nt/L/fK4iNS9Do8NJI+cVODQJNlUrh06WaxtYxIjdRScBRlE9Zp9czZT7SCtoAZR+p7M
	mYjYlo/XV4SiKSyaZaWvAueDt+nI0BHdat6GLGIWdXVLRDwrhrL1CjGdQO8YgNUETttm5ndPcGa
	aCwdF6IPplaUq386BqctHdFaGUDyQ7c0Omeu0KZMVhR+ytyOs50AaSQtuMdCF3hu44iAGmfQdlX
	gAWbH1WPP2p2b7vZPnhgvJqOR4qds6ZZU2eFRpXLS9vIF3eHlHSr6LeGqreohvszUwPkZwXdA1f
	jquUfPeNgdipY+2Udf6RweLekx+nTSRnGDouUg58w5O93edthFUCKXVHvQKU64X1nk56MJim/vZ
	MBYJtmQ0RAqc2ePJPrYMeVA
X-Received: by 2002:a05:600c:42cc:b0:488:ffb1:494c with SMTP id 5b1f17b1804b1-488ffb14a0cmr202807605e9.12.1776977106467;
        Thu, 23 Apr 2026 13:45:06 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb7ac6aasm171491755e9.25.2026.04.23.13.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 13:45:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/5] multipath-tools tests: add test program for thread runners
Date: Thu, 23 Apr 2026 22:44:44 +0200
Message-ID: <20260423204446.472642-4-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423204446.472642-1-mwilck@suse.com>
References: <20260423204446.472642-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test program for the "runner" thread implementation from the previous
commit. The test program runs simulated "hanging" threads that may time
out, and optionally kills all threads at an arbitrary point in time. See
the comments at the top of the file for details.

Also add a test driver script (runner-test.sh) with a few reasonable
combinations of command line arguments.

The test program has been used to test the "runner" implementation
extensively on different architectures (x86_64, aarch64, ppc64le, s390x),
using both valgrind and the gcc address sanitizer (libasan) for detection
of memory leaks and use-after-free errors.

For valgrind, a suppression file needs to be added, as valgrind doesn't
seem to capture the deallocation of thread local storage for detached
threads in the test case where the test program is killed. The suppression
affects only memory allocated by glibc. This leak has not been seen with
libasan, only with valgrind.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile         |  15 +-
 tests/runner-test.sh   |  55 ++++
 tests/runner-test.supp |  15 ++
 tests/runner.c         | 552 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 633 insertions(+), 4 deletions(-)
 create mode 100755 tests/runner-test.sh
 create mode 100644 tests/runner-test.supp
 create mode 100644 tests/runner.c

diff --git a/tests/Makefile b/tests/Makefile
index 9f1b950..f0e5dd3 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -9,12 +9,12 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter -Wno-unused-function $(W_MISSING_I
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo
+	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo runner
 HELPERS := test-lib.o test-log.o
 
 .PRECIOUS: $(TESTS:%=%-test)
 
-all:	$(TESTS:%=%.out)
+all:	$(TESTS:%=%.out) runner-test.out
 progs:	$(TESTS:%=%-test) lib/libchecktur.so
 valgrind:	$(TESTS:%=%.vgr)
 
@@ -65,6 +65,7 @@ features-test_LIBDEPS := -ludev -lpthread
 features-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
 cli-test_OBJDEPS := $(daemondir)/cli.o
 mapinfo-test_LIBDEPS = -lpthread -ldevmapper
+runner-test_LIBDEPS = -lpthread
 
 %.o: %.c
 	@echo building $@ because of $?
@@ -81,12 +82,18 @@ lib/libchecktur.so:
 %.vgr:  %-test lib/libchecktur.so
 	@echo == running valgrind for $< ==
 	@LD_LIBRARY_PATH=.:$(mpathutildir):$(mpathcmddir) \
-		valgrind --leak-check=full --error-exitcode=128 ./$< >$@ 2>&1
+		valgrind --leak-check=full --error-exitcode=128 --suppressions=./runner-test.supp ./$< >$@ 2>&1
 
 OBJS = $(TESTS:%=%.o) $(HELPERS)
 
+runner-test.out: runner-test
+	$(Q)./runner-test.sh >$@ 2>&1
+
+runner-test.vgr: runner-test
+	$(Q)VALGRIND=1 ./runner-test.sh >$@ 2>&1
+
 test_clean:
-	$(Q)$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so*
+	$(Q)$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so* runner-test.out runner-test.vgr
 
 valgrind_clean:
 	$(Q)$(RM) $(TESTS:%=%.vgr)
diff --git a/tests/runner-test.sh b/tests/runner-test.sh
new file mode 100755
index 0000000..7c88bdd
--- /dev/null
+++ b/tests/runner-test.sh
@@ -0,0 +1,55 @@
+#! /bin/sh
+: "${MPATHTEST_VERBOSITY:=2}"
+
+export LD_LIBRARY_PATH=../libmultipath:../libmpathutil:../libmpathcmd
+export MPATHTEST_VERBOSITY
+
+RUNNER=./runner-test
+if [ "$VALGRIND" ]; then
+    command -v valgrind >/dev/null && \
+	RUNNER="valgrind --leak-check=full --error-exitcode=128 --max-threads=5000 --suppressions=./runner-test.supp ./runner-test"
+fi
+
+# LSAN is not supported on ppc64le
+case $(uname -m) in
+    x86_64|aarch64)
+	export ASAN_OPTIONS="detect_leaks=1:detect_odr_violation=0"
+	export LSAN_OPTIONS="report_objects=1"
+	;;
+esac
+
+LONG=
+while [ $# -gt 0 ]; do
+    case $1 in
+	-l) LONG=1;;
+    esac
+    shift
+done
+
+if [ "$LONG" ]; then
+    TIME1=30000
+    TIME2=23000
+else
+    TIME1=7500
+    TIME2=4700
+fi
+
+# Test scenarios
+# 1.. timeout 0 - test runner creation / cancellation races
+# 2.. "realistic" test, scaled down by a factor 10 in time
+# 3./4. Tests with high likelihood of completion / cancellation race
+set -- \
+    "-N 100 -p 1 -t 0 -n 2 -b 1 -s 1 -i -r 20" \
+    "-N 1000 -p 100 -t 3000 -n 2999 -b 5 -s 1 -i -r 20 -k $TIME1" \
+    "-N 1000 -p 10 -t 3000 -n 1 -b 1 -s 1 -i -r 20 -k $TIME2" \
+    "-N 100 -p 1 -t 3000 -n 0 -s 1 -i -r 5"
+
+errors=0
+for args in "$@"; do
+    echo "=== $RUNNER $args"
+    # shellcheck disable=SC2086
+    $RUNNER $args || errors=$((errors+1))
+done
+
+echo "$0: ERRORS: $errors"
+[ $errors -eq 0 ]
diff --git a/tests/runner-test.supp b/tests/runner-test.supp
new file mode 100644
index 0000000..e099ec9
--- /dev/null
+++ b/tests/runner-test.supp
@@ -0,0 +1,15 @@
+{
+   glibc TLS for detached threads if program is terminated
+   Memcheck:Leak
+   match-leak-kinds: possible
+   fun:calloc
+   ...
+   fun:allocate_dtv
+   fun:_dl_allocate_tls
+   fun:allocate_stack
+   ...
+   fun:get_runner
+   fun:start_runner
+   ...
+   fun:main
+}
diff --git a/tests/runner.c b/tests/runner.c
new file mode 100644
index 0000000..ff26ce0
--- /dev/null
+++ b/tests/runner.c
@@ -0,0 +1,552 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Test reliability of the runner implementation.
+ *
+ * This tests simulates "path checkers" being started through the
+ * runner code. It creates threads that run for a variable amount of time,
+ * optionally ignoring cancellation signals. The runners have a fixed
+ * timeout (TIMEOUT_USEC, "-t" option), after which they are considered
+ * "hanging" and will be cancelled. The actual runtime of the runner is random.
+ * It varies between (TIMEOUT_USEC - NOISE USEC) and
+ * (TIMEOUT_USEC + NOISE_BIAS * NOISE_USEC). These noise parameters are
+ * set with the "-n" and "-b" option, respectively.
+ * This allows simulating frequent races between cancellation and regular
+ * completion of threads. Note that because timers in different threads
+ * aren't started simultaneously, NOISE_USEC = 0 doesn't mean that the
+ * runners will complete exactly at the point in time when there timer
+ * expires.
+ * The runners simulate waiting checkers by simply sleeping. Optionally,
+ * they can ignore cancellation while sleeping (IGNORE_CANCEL, -i) or
+ * divide the sleep time in multiple "steps" (-s), between which they can
+ * be cancelled.
+ * Like multipathd, the main thread "polls" the status of the runners in
+ * regular time intervals that are set with POLL_USEC (-p). Because of
+ * this polling behavior, it can happen that a runner finishes after
+ * its timeout has expired. The runner code (and this test) treats this case
+ * as successful completion.
+ * If a runner completes, the result is checked against the expected value.
+ * The number of threads that have not finished (either successfully or
+ * cancelled, plus the number of wrong results of completed runners is
+ * the error count.
+ * The N_RUNNERS (-N) option determines how many simultaneous threads are
+ * started.
+ * The test runs until all runners have either completed or expired, or
+ * until a maximum wait time is reached, which is calculated from the
+ * test parameters (max_wait in run_test()). The REPEAT (-r) parameter
+ * determines the number of times the entire test is repeated.
+ * The KILL_TIMEOUT (-k) parameter is for simulating a shutdown of the
+ * main program (think multipathd). When this timeout expires, all pending
+ * runners are cancelled and the program terminates.
+ *
+ * A "realistic" simulation of multipathd path checkers would use options
+ * roughly like this:
+ *
+ *   runner-test -N 1000 -p 1000 -t 30000 -n 29990 -b 5 -s 1 -i -r 20 -k 300000
+ *
+ * (note that time options are in ms, whereas the code uses us), but this
+ * takes a very long time to run.
+ *
+ * Scaled down, it becomes:
+ *
+ *   runner-test -N 1000 -p 100 -t 3000 -n 2999 -b 5 -s 1 -i -r 20 -k 30000
+ *
+ * A less realistic run with high likelihood of completionc / cancellation races:
+ *
+ *   runner-test -N 1000 -p 10 -t 3000 -n 1 -b 1 -s 1 -i -r 20
+ *
+ * Here, all runners finish in a +-1ms timer interval around the timeout.
+ * Even with -n 0 (no noise), with a sufficient number of runners, some runners
+ * will time out.
+ */
+
+#include <time.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <signal.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <sched.h>
+#include <errno.h>
+#include <sys/select.h>
+#include <sys/wait.h>
+#include "debug.h"
+#include "time-util.h"
+#include "runner.h"
+#include "runner.h"
+#include "globals.c"
+
+#define MILLION 1000000
+#define BILLION 1000000000
+
+static int N_RUNNERS = 100;
+/* sleep time between runner status polling */
+static long POLL_USEC = 10000;
+/* timeout for runner */
+static long TIMEOUT_USEC = 100000;
+/* random noise to subtract / add to the sleep time */
+static long NOISE_USEC = 10000;
+/*
+ * Factor to increase noise towards longer sleep times (timeouts).
+ * The actual sleep time will be in the interval
+ * [ TIMEOUT_USEC - NOISE_USEC, TIMEOUT_USEC + NOISE_USEC * NOISE_BIAS ]
+ */
+static int NOISE_BIAS = 5;
+/* number of sleep intervals the runner uses */
+static int SLEEP_STEPS = 1;
+/* time after which to kill all runners */
+static long KILL_TIMEOUT = 0;
+/* number of repeated runs */
+static int REPEAT = 10;
+/* whether to ignore cancellation signals */
+static bool IGNORE_CANCEL = false;
+
+/* gap in the paylod to similate larger size */
+#define PAYLOAD_GAP 128
+
+struct payload {
+	long wait_nsec;
+	int steps;
+	bool ignore_cancel;
+	int start;
+	char pad[PAYLOAD_GAP];
+	int end;
+};
+
+static void wait_and_add_1(void *arg)
+{
+	struct payload *t1 = arg;
+	struct timespec wait;
+	int i, cancelstate;
+
+	wait.tv_sec = t1->wait_nsec / BILLION;
+	wait.tv_nsec = t1->wait_nsec % BILLION;
+	normalize_timespec(&wait);
+	for (i = 0; i < t1->steps; i++) {
+		if (t1->ignore_cancel)
+			pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &cancelstate);
+		if (nanosleep(&wait, NULL) != 0 && errno != EINTR)
+			condlog(3, "%s: nanosleep: %s", __func__, strerror(errno));
+		if (t1->ignore_cancel) {
+			pthread_setcancelstate(cancelstate, NULL);
+		}
+		pthread_testcancel();
+	}
+	t1->end = t1->start + 1;
+}
+
+static bool payload_error(const struct payload *p)
+{
+	return p->end != p->start + 1;
+}
+
+static int check_payload(struct runner_context *rctx, bool *error)
+{
+	struct timespec now;
+	struct payload t1;
+	int st = check_runner(rctx, &t1, sizeof(t1));
+
+	if (st == RUNNER_RUNNING || st == RUNNER_IDLE)
+		return st;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	if (st == RUNNER_DONE) {
+		int level = 4;
+
+		if (error) {
+			*error = payload_error(&t1);
+			if (*error)
+				level = 2;
+		}
+		condlog(level,
+			"runner %p finished in state 'done' at %lld.%06lld, start %d end %d",
+			rctx, (long long)now.tv_sec,
+			(long long)now.tv_nsec / 1000, t1.start, t1.end);
+	} else
+		condlog(4, "runner %p finished in state '%s' at %lld.%06lld",
+			rctx, runner_state_name(st), (long long)now.tv_sec,
+			(long long)now.tv_nsec / 1000);
+	return st;
+}
+
+static struct runner_context *
+start_runner(long usecs, int start, long noise_range_usec, long bias,
+	     int steps, bool ignore_cancel)
+{
+
+	struct payload t1;
+	struct runner_context *rctx;
+	long noise;
+
+	if (noise_range_usec > 0)
+		noise = random() % ((bias + 1) * noise_range_usec) -
+			noise_range_usec;
+	else
+		noise = 0;
+	t1.start = start;
+	t1.end = 0;
+	t1.wait_nsec = (usecs + noise) * 1000 / steps;
+	t1.wait_nsec = t1.wait_nsec > 0 ? t1.wait_nsec : 0;
+	t1.steps = steps;
+	t1.ignore_cancel = ignore_cancel;
+
+	rctx = get_runner(wait_and_add_1, &t1, sizeof(t1), usecs);
+
+	if (rctx) {
+		struct timespec tmo, finish;
+
+		clock_gettime(CLOCK_MONOTONIC, &tmo);
+		tmo.tv_sec += usecs / MILLION;
+		tmo.tv_nsec += (usecs % MILLION) * 1000;
+		finish = tmo;
+		normalize_timespec(&tmo);
+		finish.tv_sec += noise / MILLION;
+		finish.tv_nsec += (noise % MILLION) * 1000;
+		normalize_timespec(&finish);
+		condlog(4, "started runner start %d timeout %lld.%06lld, finish %lld.%06lld (noise %ld), steps %d, %signoring cancellation",
+			start, (long long)tmo.tv_sec,
+			(long long)tmo.tv_nsec / 1000, (long long)finish.tv_sec,
+			(long long)finish.tv_nsec / 1000, noise, steps,
+			ignore_cancel ? "" : "not ");
+		return rctx;
+	} else {
+		condlog(0, "failed to start runner for start %d", start);
+		return NULL;
+	}
+}
+
+static struct runner_context **context;
+static volatile bool must_stop = false;
+void int_handler(int signal)
+{
+	must_stop = true;
+}
+
+static void terminate_all(void)
+{
+	int i, count;
+
+	for (count = 0, i = 0; i < N_RUNNERS; i++)
+		if (context[i]) {
+			release_runner(context[i]);
+			context[i] = NULL;
+			count++;
+		}
+	condlog(3, "%s: %d runners released", __func__, count);
+	/* give runners a chance to clean up */
+	sched_yield();
+}
+
+static bool test_sleep(const struct timespec *wait)
+{
+	sigset_t set;
+
+	sigfillset(&set);
+	sigdelset(&set, SIGTERM);
+	sigdelset(&set, SIGINT);
+	sigdelset(&set, SIGQUIT);
+
+	pselect(0, NULL, NULL, NULL, wait, &set);
+
+	if (!must_stop)
+		return false;
+
+	terminate_all();
+	return true;
+}
+
+static int run_test(int n)
+{
+	int i, running, done, errors;
+	const struct timespec wait = {.tv_sec = 0, .tv_nsec = 1000 * POLL_USEC};
+	struct timespec stop, now;
+	long max_wait = TIMEOUT_USEC + NOISE_BIAS * NOISE_USEC + 100000;
+	bool killed = false;
+
+	for (i = 0; i < N_RUNNERS; i++)
+		context[i] = start_runner(TIMEOUT_USEC, i, NOISE_USEC, NOISE_BIAS,
+					  SLEEP_STEPS, IGNORE_CANCEL);
+
+	clock_gettime(CLOCK_MONOTONIC, &stop);
+	stop.tv_sec += max_wait / MILLION;
+	stop.tv_nsec += (max_wait % MILLION) * 1000;
+	normalize_timespec(&stop);
+	running = N_RUNNERS;
+	done = 0;
+	errors = 0;
+	do {
+		bool err = false, last = false;
+
+		killed = test_sleep(&wait);
+		if (killed)
+			condlog(3, "%s: terminating on signal...", __func__);
+
+		clock_gettime(CLOCK_MONOTONIC, &now);
+		if (timespeccmp(&stop, &now) <= 0)
+			last = true;
+
+		for (running = 0, i = 0; i < N_RUNNERS; i++) {
+			int st;
+
+			if (!context[i])
+				continue;
+			st = check_payload(context[i], &err);
+			switch (st) {
+			case RUNNER_DONE:
+				if (err)
+					errors++;
+				done++;
+				/* fallthrough */
+			case RUNNER_DEAD:
+				release_runner(context[i]);
+				context[i] = NULL;
+				break;
+			case RUNNER_CANCELLED:
+				if (last) {
+					condlog(3, "%s: releasing %p",
+						__func__, context[i]);
+					release_runner(context[i]);
+					context[i] = NULL;
+				} else
+					running++;
+				break;
+			default:
+				running++;
+				if (last)
+					condlog(1, "%s: found thread in state %s, rctx=%p",
+						__func__, runner_state_name(st),
+						context[i]);
+				break;
+			}
+		}
+		if (killed || last)
+			break;
+	} while (running);
+
+	condlog(2, "%10d%10d%10d%10d%10d", n, N_RUNNERS, N_RUNNERS - running,
+		done, errors);
+
+	if (killed) {
+		condlog(2, "%s: termination signal received", __func__);
+		exit(0);
+	}
+
+	if (running > 0) {
+		condlog(1, "ERROR: %d runners haven't finished", running);
+		terminate_all();
+	}
+	return running + errors;
+}
+
+static void free_rctxs(struct runner_context ***rctxs)
+{
+	if (*rctxs)
+		free(*rctxs);
+}
+
+static int setup_signal_handler(int sig, void (*handler)(int))
+{
+	sigset_t set;
+	sigfillset(&set);
+	struct sigaction sga = {.sa_handler = NULL};
+
+	sga.sa_handler = handler;
+	sga.sa_mask = set;
+	if (sigaction(sig, &sga, NULL) != 0) {
+		condlog(1, "%s: failed to install signal handler for %d: %s",
+			__func__, sig, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+int run_tests(void)
+{
+	int errors = 0, i;
+	struct runner_context **rctxs __attribute__((cleanup(free_rctxs))) = NULL;
+
+	if (setup_signal_handler(SIGINT, int_handler) != 0)
+		return -1;
+
+	rctxs = calloc(N_RUNNERS, sizeof(*context));
+	if (rctxs == NULL)
+		/* arbitrary number to indicate OOM error */
+		return 7000;
+	context = rctxs;
+	for (i = 0; i < REPEAT; i++) {
+		errors += run_test(i + 1);
+	}
+	return errors ? 1 : 0;
+}
+
+/* We need to register a dummy handler to avoid system call restarting in
+ * pselect() below */
+static void dummy_handler(int sig) {}
+
+static int fork_test(void)
+{
+	sigset_t set;
+	pid_t child;
+	int wstatus;
+	struct timespec wait_to_kill = {.tv_sec = 0};
+
+	/* Block all signals. termination signals will be enabled in test_sleep() */
+	sigfillset(&set);
+	pthread_sigmask(SIG_SETMASK, &set, NULL);
+
+	child = fork();
+
+	if (child < 0) {
+		condlog(0, "error in fork(), %s", strerror(errno));
+		return -1;
+	} else if (child == 0) {
+		/* child */
+		int rc = run_tests();
+		exit(rc ? 1 : 0);
+	}
+
+	setup_signal_handler(SIGCHLD, dummy_handler);
+
+	/* parent */
+	if (KILL_TIMEOUT > 0) {
+		sigset_t set;
+
+		condlog(3, "%s: == Child %d will be killed with SIGINT after %ld us",
+			__func__, child, KILL_TIMEOUT);
+		wait_to_kill.tv_sec = KILL_TIMEOUT / MILLION;
+		wait_to_kill.tv_nsec = (KILL_TIMEOUT % MILLION) * 1000;
+
+		/*
+		 * Unblock SIGCHLD in case thild terminates
+		 * (child will receive SIGINT)
+		 */
+		sigfillset(&set);
+		sigdelset(&set, SIGCHLD);
+		if (pselect(0, NULL, NULL, NULL, &wait_to_kill, &set) != 0) {
+			if (errno == EINTR)
+				condlog(2, "main: child terminated");
+			else
+				condlog(1, "main: error in pselect: %s",
+					strerror(errno));
+		} else
+			kill(child, SIGINT);
+	}
+
+	if (waitpid(child, &wstatus, 0) <= 0) {
+		condlog(1, "%s: failed to wait for child %d", __func__, child);
+		return -1;
+	}
+	if (WIFEXITED(wstatus)) {
+		condlog(3, "%s: child %d return code %d", __func__, child,
+			WEXITSTATUS(wstatus));
+		return WEXITSTATUS(wstatus);
+	} else if (WIFSIGNALED(wstatus)) {
+		condlog(2, "%s: child %d killed by signal code %d", __func__,
+			child, WTERMSIG(wstatus));
+		return -1;
+	} else {
+		condlog(1, "%s: unexpected status of child %d", __func__, child);
+		return -1;
+	}
+}
+
+static long parse_number(const char *arg, long factor, long deflt)
+{
+	char *ep;
+	long v;
+
+	if (*arg) {
+		v = strtol(arg, &ep, 10);
+		if (!*ep && v >= 0)
+			return factor * v;
+	}
+	condlog(1, "invalid argument: %s, using %ld", arg, deflt);
+	return deflt;
+}
+
+static int usage(const char *cmd, int opt)
+{
+#define USAGE_FMT \
+	"Usage: %s [options]\n" \
+		"	-N runners:  number of parallel runners\n" \
+		"	-p msecs:    time to sleep between status polls in main thread\n" \
+		"	-t msecs:    timeout for runners\n" \
+		"	-n msecs:    random noise for runner sleep time\n" \
+		"	-b bias:     noise increase factor towards sleeping longer\n" \
+		"	-s n:        number of steps to divide sleep time into\n" \
+		"	-k msecs:    timeout after which to kill all runners (0: don't kill)\n" \
+		"	-r n:        number of times to repeat test\n" \
+		"	-i:          runners ignore cancellation while sleeping\n" \
+		"	-v n:        set verbosity level (default 2)\n" \
+		"	-h:          print this help"
+	condlog(0, USAGE_FMT, cmd);
+	return opt == 'h' ? 0 : 1;
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+	int total = 0;
+	const char *optstring = "+:N:p:t:n:b:s:k:r:v:ih";
+
+	init_test_verbosity(2);
+
+	while ((opt = getopt(argc, argv, optstring)) != -1) {
+		switch (opt) {
+		case 'N':
+			N_RUNNERS = parse_number(optarg, 1L, N_RUNNERS);
+			break;
+		case 'p':
+			POLL_USEC = parse_number(optarg, 1000L, POLL_USEC);
+			break;
+		case 't':
+			TIMEOUT_USEC = parse_number(optarg, 1000L, TIMEOUT_USEC);
+			break;
+		case 'n':
+			NOISE_USEC = parse_number(optarg, 1000L, NOISE_USEC);
+			break;
+		case 'b':
+			NOISE_BIAS = parse_number(optarg, 1L, NOISE_BIAS);
+			break;
+		case 's':
+			SLEEP_STEPS = parse_number(optarg, 1L, SLEEP_STEPS);
+			break;
+		case 'k':
+			KILL_TIMEOUT = parse_number(optarg, 1000L, KILL_TIMEOUT);
+			break;
+		case 'r':
+			REPEAT = parse_number(optarg, 1L, REPEAT);
+			break;
+		case 'i':
+			IGNORE_CANCEL = true;
+			break;
+		case 'v':
+			libmp_verbosity = parse_number(optarg, 1L, libmp_verbosity);
+			break;
+		case 'h':
+		case ':':
+		case '?':
+			return usage(argv[0], opt);
+			break;
+		}
+	}
+
+	if (optind != argc)
+		return usage(argv[0], '?');
+
+	condlog(2, "Runner: timeout=%ld, noise interval=[-%ld:%ld], steps=%d",
+		TIMEOUT_USEC, TIMEOUT_USEC - NOISE_USEC,
+		TIMEOUT_USEC + NOISE_BIAS * NOISE_USEC, SLEEP_STEPS);
+	condlog(2, "Other : poll interval=%ld, ignore cancellation=%s, runners=%d, repeat=%d, kill timeout=%ld",
+		POLL_USEC, IGNORE_CANCEL ? "YES" : "NO", N_RUNNERS, REPEAT,
+		KILL_TIMEOUT);
+	condlog(2, "%10s%10s%10s%10s%10s", "run", "total", "finished",
+		"completed", "errors");
+
+	total = fork_test();
+	if (total == -1)
+		return 130;
+	condlog(2, "== TOTAL NUMBER OF FAILED RUNS: %d", total);
+	return total ? 1 : 0;
+}
-- 
2.53.0

