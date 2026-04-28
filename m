Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D474F3F54B8
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777376999; cv=none; b=LnZMw00jkx9pumM/ynNRZYEEPQ+wt9DVrggy5iQqzBrSemYluQviuWE+6/6jZPXxK52EKhFcgvjI1X6844VsUz4Z5fe5N5tLpi/aK06OEPFS1N1USYFCRQHvRWS3lnAu83/c57u6PaQi9I0DvDGbTIrXM3X0F8wxzKnqiuJDNvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777376999; c=relaxed/simple;
	bh=4Zx8yoMDKGVRbSEAP+wS/FJX23Ijkqs8GsrQwyxrhHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEVomDFSVFEKfuA/+xpfkz2MFkl+BTd3cNS9Wfu7agcLjumFRz7TuVUtxwsBtHS6Prn7viaa+T2toBC1LgPhc/kOXxFJjzYXF2h+DHOvMGXVZpve1jp4XNVcEgHcVpyeuD9GHMEBA0iRJn5O/sB669BJmv8EGZISW+/3PkpteEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dgIdzWS6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dgIdzWS6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso97876355e9.2
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777376996; x=1777981796; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Y1Y9giqO0L9Ccc9T9r4dHg5AuB4aItIgRqrfrb9oU8=;
        b=dgIdzWS6Du13eNM0K2ODBPJEckz+uBKXADgMm32YIKKl7mUhPrY4EY498947wlMFJp
         Zb9+y4RWgNpEfeYVQ+7VDmoqU7FZctYtXlEPxFyn4xIJsm84nKXkyQn+8530CAHHmgCO
         KKyVXy58U9UHGEMhFdGLgJCVkBx6wevhrxwmcPvyGcBU9NnsLe/tLY8ouhDMCi+mKTyh
         lgBLAH7sCR0eYe9GQcur04uV4b9FIwOQIJiA7zBEbveAG7s5fyfaGt+Gl4ytIPL9O2wR
         mR2BVsJxGlbjTO1HTsAtnmL+1BYK1gesRFQfzN1pnw1YX4u4c2cFp1XooWQs/msBSWEB
         +1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376996; x=1777981796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Y1Y9giqO0L9Ccc9T9r4dHg5AuB4aItIgRqrfrb9oU8=;
        b=Sb+Mt6woFFtGRxA1JoMZOqW0Fwfch59zaA9nyA4WYhCG7tJVOWkQgnwDy3BAnR0sEZ
         7MphgS4dRZfujzm8RAYVPhO+jZjUWbq0lzXcAwIS4ze5GkK2lUhoz6c/m6KncKHMmYxC
         sAyCuHwsIWvDPZ/e/LM2XHRYo6mHwzuzO7rgq536mwLKi6KQe3vEhlud8iXQBw95ewcj
         Sg1/Eb1zeLS6n6x7PL+bUt3dOudr4Xmwa4yZUyrHFbqOXQrhbbBMm42YqsrsKcVG6E9M
         1M+LaNvJBysEPOZHr7t4LceO29oatzarmrzOjwfWurzST9lgXMB9xc+XzWmGcxEJT3pP
         3EkQ==
X-Forwarded-Encrypted: i=1; AFNElJ995CQvtmJfU2vGceS9Um2Em7qItJrt/pX1eb9NTLAvGFIj70wL95qXoNgfPlPXMJnO57aS2YmJ5w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmcbgCdj66QwYiZFWx5y91yTfexCR2db5XQnCJJHal9FUR25Ds
	KvmcgiVTLYcPh57LSrDgElifNigF6UafEpakgRhIbwZgWKrkPCD+k4s3ju32rJrRB2w=
X-Gm-Gg: AeBDietU3U7h06rDlHCgkJmw+7ZorKCr2+iCfwmwcHMtme4zxPDbrm8JTQVajOnIUr5
	oAMoHG55ovHNjGYGu3L1uzTmkGvk8Fcu4sb+JIfvZ88DTrB7sOOGlbnoGjHBWJQ+7Xj+8t/F0jP
	48d5eiWU/Dz0dzMIpWZAb8Q9ndpsP6D+o6FSIy2Bb8JT/PtCp+DDJyRZZgWGck+cKfkLTCMSwYc
	5eZkRHqTAyhIhThZfKQA09HhL/D40spMCLnTY0R8JOvPehUAawYVI18Wh8E02+nz6J3pYrhHjBy
	vTcJpiU+j+fpMDzeWg2eQuGxgCHA74veatdgJtqM2qDm/l87l0POkHsY+OdkdghoUgBZsvaVRjO
	Fs3l2iNn17d+lpE3gdR7Gh/XkTLwtf7iMTEooNHnIUXoV5CvlaL+r5PEfxv6IWQjQV4B2kE+NMd
	J35Bo0xkzvBQ9IsHlAfTQhmI/8Dq3e9507Az6tyArSc2ZHDPu8iX2tzVtqgWV4UGSffOr7QgpHx
	2fc9t4RyVuaHPloV59DiU1Ls9oE0lt9Ol4=
X-Received: by 2002:a05:600c:3b13:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-48a77add9cemr41276045e9.1.1777376996101;
        Tue, 28 Apr 2026 04:49:56 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4463fb7e39fsm5412939f8f.29.2026.04.28.04.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:49:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/5] libmpathutil: add generic implementation for checker thread runners
Date: Tue, 28 Apr 2026 13:49:39 +0200
Message-ID: <20260428114942.292307-3-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428114942.292307-1-mwilck@suse.com>
References: <20260428114942.292307-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This code adds a generic, abstract implementation of the kind of threads we
need for checkers: detached threads that may time out. The design is such
that these threads never access any memory of the calling program,
simplifying the management of lifetimes of objects.

See the documentation of the API in "runner.h".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/Makefile             |   2 +-
 libmpathutil/libmpathutil.version |   7 +-
 libmpathutil/runner.c             | 229 ++++++++++++++++++++++++++++++
 libmpathutil/runner.h             | 102 +++++++++++++
 4 files changed, 338 insertions(+), 2 deletions(-)
 create mode 100644 libmpathutil/runner.c
 create mode 100644 libmpathutil/runner.h

diff --git a/libmpathutil/Makefile b/libmpathutil/Makefile
index e1cc2c6..bdd7063 100644
--- a/libmpathutil/Makefile
+++ b/libmpathutil/Makefile
@@ -13,7 +13,7 @@ LIBDEPS += -lpthread -ldl -ludev -L$(mpathcmddir) -lmpathcmd $(SYSTEMD_LIBDEPS)
 
 # other object files
 OBJS := mt-libudev.o parser.o vector.o util.o debug.o time-util.o \
-	uxsock.o log_pthread.o log.o strbuf.o globals.o msort.o
+	uxsock.o log_pthread.o log.o strbuf.o globals.o msort.o runner.o
 
 all:	$(DEVLIB)
 
diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 22ef994..c69120d 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMPATHUTIL_5.0 {
+LIBMPATHUTIL_6.0 {
 global:
 	alloc_bitfield;
 	alloc_strvec;
@@ -62,6 +62,7 @@ global:
 	cleanup_vector;
 	cleanup_vector_free;
 	convert_dev;
+	check_runner;
 	dlog;
 	filepresent;
 	fill_strbuf;
@@ -72,6 +73,8 @@ global:
 	free_strvec;
 	get_linux_version_code;
 	get_monotonic_time;
+	get_persistent_runner;
+	get_runner;
 	get_strbuf_buf__;
 	get_next_string;
 	get_strbuf_len;
@@ -161,7 +164,9 @@ global:
 	process_file;
 	pthread_cond_init_mono;
 	recv_packet;
+	release_runner;
 	reset_strbuf;
+	runner_state_name;
 	safe_write;
 	send_packet;
 	set_max_fds;
diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
new file mode 100644
index 0000000..cda679c
--- /dev/null
+++ b/libmpathutil/runner.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2026 SUSE LLC
+#include <assert.h>
+#include <time.h>
+#include <pthread.h>
+#include <urcu/uatomic.h>
+#include "util.h"
+#include "debug.h"
+#include "time-util.h"
+#include "runner.h"
+
+#define STACK_SIZE (4 * 1024)
+#define MILLION 1000000
+
+const char *runner_state_name(int state)
+{
+	// clang-format off
+	static const char * const state_name_[] = {
+		[RUNNER_IDLE] = "idle",
+		[RUNNER_RUNNING] = "running",
+		[RUNNER_DONE] = "done",
+		[RUNNER_CANCELLED] = "cancelled",
+		[RUNNER_DEAD] = "dead"
+	};
+	// clang-format on
+
+	if (state < RUNNER_IDLE || state > RUNNER_DEAD)
+		return "unknown";
+	return state_name_[state];
+}
+
+struct runner_context {
+	int refcount;
+	int status;
+	struct timespec deadline;
+	pthread_t thr;
+	void (*func)(void *data);
+	/* User data will be copied into this area */
+	char __attribute__((aligned(sizeof(void *)))) data[];
+};
+
+static void release_context(struct runner_context *rctx)
+{
+	int n;
+
+	n = uatomic_sub_return(&rctx->refcount, 1);
+	assert(n >= 0);
+
+	if (n == 0)
+		free(rctx);
+}
+
+static void cleanup_context(struct runner_context **prctx)
+{
+	struct runner_context *rctx = *prctx;
+	int st;
+
+	if (!rctx)
+		return;
+
+	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_DONE);
+	if (st != RUNNER_RUNNING) {
+		uatomic_cmpxchg(&rctx->status, st, RUNNER_DEAD);
+		condlog(st == RUNNER_CANCELLED ? 3 : 2,
+			"%s: runner %p finished in state '%s'",
+			__func__, rctx, runner_state_name(st));
+	}
+	release_context(rctx);
+}
+
+static void *runner_thread(void *arg)
+{
+	int st;
+	/*
+	 * The cleanup function makes sure memory is freed if the thread is
+	 * cancelled (-fexceptions).
+	 */
+	struct runner_context *rctx __attribute__((cleanup(cleanup_context))) = arg;
+
+#ifdef RUNNER_START_DELAY_US
+	/*
+	 * Compile e.g. with RUNNER_START_DELAY_US=1000 to test races between
+	 * thread start and thread cancellation.
+	 */
+	do {
+		struct timespec slp = { .tv_sec = 0, .tv_nsec = 1000 * RUNNER_START_DELAY_US };
+
+		nanosleep(&slp, NULL);
+	} while (0);
+#endif
+
+	st = uatomic_cmpxchg(&rctx->status, RUNNER_IDLE, RUNNER_RUNNING);
+	if (st != RUNNER_IDLE)
+		return NULL;
+
+	(*rctx->func)(rctx->data);
+	return NULL;
+}
+
+static int cancel_runner(struct runner_context *rctx)
+{
+	int st, st_new;
+	int level = 4, retry = 1;
+
+repeat:
+	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_CANCELLED);
+	st_new = st;
+	switch (st) {
+	case RUNNER_IDLE:
+		/*
+		 * Race with thread startup.
+		 *
+		 * If after the following cmpxchg st is still IDLE, the cmpxchg
+		 * in runner_thread() will return CANCELLED, and the context
+		 * will be relased there. Otherwise, the thread has switched
+		 * to RUNNING in the meantime, and we will be able to cancel
+		 * it regularly if we retry.
+		 */
+		if (retry--) {
+			st = uatomic_cmpxchg(&rctx->status, RUNNER_IDLE,
+					     RUNNER_CANCELLED);
+			if (st == RUNNER_IDLE)
+				st_new = RUNNER_CANCELLED;
+			else
+				goto repeat;
+		}
+		break;
+	case RUNNER_RUNNING:
+		pthread_cancel(rctx->thr);
+		st_new = RUNNER_CANCELLED;
+		/* fallthrough */
+	case RUNNER_CANCELLED:
+		break;
+	case RUNNER_DONE:
+		st_new = RUNNER_DEAD;
+		/* fallthrough */
+	case RUNNER_DEAD:
+		level = 3;
+		break;
+	}
+	condlog(level, "%s: runner %p cancelled in state '%s'", __func__, rctx,
+		runner_state_name(st));
+	return st_new;
+}
+
+void release_runner(struct runner_context *rctx)
+{
+	cancel_runner(rctx);
+	release_context(rctx);
+}
+
+int check_runner(struct runner_context *rctx, void *data, unsigned int size)
+{
+	int st = uatomic_read(&rctx->status);
+
+	switch (st) {
+	case RUNNER_DONE:
+		if (data)
+			/* hand back the data to the caller */
+			memcpy(data, rctx->data, size);
+		/* fallthrough */
+	case RUNNER_DEAD:
+	case RUNNER_CANCELLED:
+		return st;
+	case RUNNER_IDLE:
+	case RUNNER_RUNNING:
+		if (rctx->deadline.tv_sec != 0 || rctx->deadline.tv_nsec != 0) {
+			struct timespec now;
+
+			get_monotonic_time(&now);
+			if (timespeccmp(&rctx->deadline, &now) <= 0)
+				return cancel_runner(rctx);
+		}
+		/* don't bother the caller with RUNNER_IDLE */
+		return RUNNER_RUNNING;
+	default:
+		condlog(1, "%s: runner in impossible state '%s'", __func__,
+			runner_state_name(st));
+		assert(false);
+		return st;
+	}
+}
+
+struct runner_context *get_runner(runner_func func, void *data,
+				  unsigned int size, unsigned long timeout_usec)
+{
+	static const struct timespec time_zero = {.tv_sec = 0};
+	struct runner_context *rctx;
+	pthread_attr_t attr;
+	int rc;
+
+	if (!func || !data || size <= 0) {
+		condlog(0, "%s: illegal arguments", __func__);
+		return NULL;
+	}
+
+	rctx = malloc(sizeof(*rctx) + size);
+	if (!rctx)
+		return NULL;
+
+	rctx->func = func;
+	/*
+	 * We have to set the refcount to 2 here. The runner thread may be cancelled
+	 * before it even had the chance to increase the refcount, which could
+	 * result in a use-after-free in cleanup_context().
+	 */
+	uatomic_set(&rctx->refcount, 2);
+	uatomic_set(&rctx->status, RUNNER_IDLE);
+	memcpy(rctx->data, data, size);
+
+	if (timeout_usec) {
+		get_monotonic_time(&rctx->deadline);
+		rctx->deadline.tv_sec += timeout_usec / MILLION;
+		rctx->deadline.tv_nsec += (timeout_usec % MILLION) * 1000;
+	} else
+		rctx->deadline = time_zero;
+
+	setup_thread_attr(&attr, STACK_SIZE, 1);
+	rc = pthread_create(&rctx->thr, &attr, runner_thread, rctx);
+	pthread_attr_destroy(&attr);
+
+	if (rc) {
+		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
+		uatomic_dec(&rctx->refcount);
+		release_context(rctx);
+		return NULL;
+	}
+	return rctx;
+}
diff --git a/libmpathutil/runner.h b/libmpathutil/runner.h
new file mode 100644
index 0000000..cb2ad94
--- /dev/null
+++ b/libmpathutil/runner.h
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2026 SUSE LLC
+#ifndef RUNNER_H_INCLUDED
+#define RUNNER_H_INCLUDED
+
+enum runner_status {
+	/**
+	 * Initial state. Runner thread has not started yet.
+	 */
+	RUNNER_IDLE,
+	/**
+	 * The runner thread is running in @runner_func (see below).
+	 */
+	RUNNER_RUNNING,
+	/**
+	 * @runner_func has terminated. This is the only only state
+	 * in which @check_runner can obtain user data in the @data
+	 * parameter.
+	 */
+	RUNNER_DONE,
+	/**
+	 * The runner thread has been cancelled (usually because of a timeout),
+	 * but @runner_func is still running.
+	 */
+	RUNNER_CANCELLED,
+	/**
+	 * The runner thread has terminated without providing user data
+	 * (usually after a timeout).
+	 */
+	RUNNER_DEAD,
+};
+
+typedef void (*runner_func)(void *data);
+struct runner_context;
+
+/**
+ * runner_state_name(): helper for printing runner states
+ *
+ * @param state: a valid @runner_status value
+ * @returns: a string describing the status
+ */
+const char *runner_state_name(int state);
+
+/**
+ * get_runner(): start a runner thread
+ *
+ * This function starts a runner thread that calls @func(@data).
+ * The thread is created as detached thread.
+ * @data will be copied to thread-private memory, which will be freed when
+ * the runner terminates.
+ * Output values can be retrieved with @check_runner().
+ *
+ * @param func: the worker function to invoke
+ *        This parameter must not be NULL.
+ * @param data: pointer the data to pass to the function (input and output)
+ *        This parameter must not be NULL.
+ * @param size: the size (in bytes) of the data passed to the function
+ *        This parameter must be positive.
+ * @param timeout_usec: timeout (in microseconds) after which to cancel the
+ * runner. If it is 0, the runner will not time out.
+ * @returns: a runner context that must be passed to the functions below.
+ */
+struct runner_context *get_runner(runner_func func, void *data,
+				  unsigned int size, unsigned long timeout_usec);
+
+/**
+ * release_runner(): release a runner context
+ *
+ * This function should be called when the caller has no interest to
+ * operate on the given @runner_context any more.
+ * If necessary, the runner thread will be cancelled.
+ * Upon return of this function, @rctx becomes stale and shouldn't accessed
+ * any more.
+ *
+ * @param rctx: the context of the runner to be released.
+ */
+void release_runner(struct runner_context *rctx);
+
+/**
+ * check_runner(): query the state of a runner thread and obtain results
+ *
+ * Check the state of a runner previously started with @get_runner. If the
+ * thread function has completed, @RUNNER_DONE will be returned, and the
+ * user data will be copied into the @data argument. If @check_runner returns
+ * anything else, @data contains no valid data. The @size argument
+ * will typically be the same as the @size passed to @get_runner (meaning
+ * that @data represents an object of the same type as the @data argument
+ * passed to @get_runner previously).
+ *
+ * Side effect: If the runner has timed out, the thread will be cancelled.
+ *
+ * @param rctx: the context of the runner to be queried
+ * @param data: memory pointer that will receive results of the worker
+ * function. Can be NULL, in which case no data will be copied.
+ * @param size: size of the memory pointed to by data. It must be no bigger
+ *        than the size of the memory passed to @get_runner for this runner.
+ *        It can be smaller, but no more than @size bytes will be copied.
+ * @returns: @RUNNER_RUNNING, @RUNNER_DONE, @RUNNER_CANCELLED, or @RUNNER_DEAD.
+ */
+int check_runner(struct runner_context *rctx, void *data, unsigned int size);
+
+#endif /* RUNNER_H_INCLUDED */
-- 
2.53.0

