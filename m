Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77BD28150F
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958444; cv=none; b=AyKVeQYXmrJKJvnG4X+C/QxynZkdGmhO+u6F5fEN/Qg92U3tjqG6SvYkfFVxWBpqn7d4BAsBa0YXuFt+96im0ZlgDCzhObxevLABZ2Y6ncVxjSNCm4hd29luzoNETM7S+H+nq4kS3GmbH9LzlqVYv7PqAPLhaPg9dtgCJD1qqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958444; c=relaxed/simple;
	bh=JPfqDqtEggN2U0ZQPl22HdTLTQPtjhU18YI9w6Yg8eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg9LK3gwfiQmd0jT1gnsmCiEYijOj389rf3DstLwvl21KfIuqEnLkAFimtReEYh9QE6lpnoYHCFvWf2VBcJmOX9gcb5wksJKnW3S6IrwnW6MidQ7ELkc3h87Jn5erMNof5tAqPCe+jC7epQNErWXbjNKdJCRaS2MRwT1ZeYt8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KA+5uWtU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KA+5uWtU"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so8981045e9.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 15:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773958441; x=1774563241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFqgDQRz/as50shAwwPV3S3fJDG7a4xeRnW7GnlsLKU=;
        b=KA+5uWtU23/lo21iCFR3K0Up7E8LeW1PS+Zw6ghW8Yxe/A/OgNi4PEee8mq3I7JTbw
         sEn6Hw8qAhoEuYLFBCx7PFKL9rX6kaZ1xWUkP/b0SIIJ2Omx7XC/KwWtyVICKkuY6ZLO
         uBFSMxHKKIoJQnqd60firXbwkmO2lS6yEsHBgog8AcWK5gedeANVpeVPsiKB+JOin2qG
         osNQNiaMGIRqSiQisAO6jwR9Sw2UJbu0hiewc/OBnYevW8/0T5oLwDMj2WbOl0UvN0eF
         moeX1aIwxaBxMeMMDuvT3uZSmXwpOinxlFh9Vbp1rNQbWMt2Y20jLDlssl2vk9ijN6T2
         r07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773958441; x=1774563241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tFqgDQRz/as50shAwwPV3S3fJDG7a4xeRnW7GnlsLKU=;
        b=YPCkwIGXTCnvMvcStb7jmrUok+K4WXTKLtBeRLSQEwF0GFqz/mitXsSURpqLD8r7hc
         XyKUz1qkObDeZTNRkZz+Ix9z4pIX9fdFwGz0MduOsRIPMLnvbhSmXR0Z3I/5tSnxRm7R
         FwJhxvjZpfC26yxNquY0Cjs0j7+VwMOniYNV8G0L/SkVDT8+UZIJGQqluoZg2lBYRrhs
         67PGhW9dvyK9AAoz2pSo7atCAXUEoCJCu0wUM+rZu/gUVIHErhExiOGNo/Dbv5i8VUet
         7rU6aLAiyHme2z4x48Iq1O5pSxdk4FPWAZWrWXC5DKo/Qv3CZi2W30w7qqvHi8bk1dG2
         O/BQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL3YD3GArpNSdgfJTCc4JiNydCC8nY5NgrggDry9M7qESlTvl4nWKhTOaePcNgGkltqXMTXoGghg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwdGt+84p/Yn8+c08SOHw4TTnnu3XnWqKL3ifXeM/1M7CHzwmNm
	isxYyYbPU1lbHW15ga1gNDqpWO4JckWw19bHr1HTpFhyixJfmn4NboBwM12YBh1wu90=
X-Gm-Gg: ATEYQzwaQAMktHT+0Cm8ypEMc1CbruDO6f1A4mwTtm20Y53ikA3ND6gsvHoKmLrcoeO
	/dPoPg3UznB2v6t0b1v/VJvtbSP3IF7zzNktSBQpTFlFKmTbXfCxDcJD9UdU9KJRe6lygGiyZVc
	E9FaNQ2twoRcDS1jJ9UtOf3UuYkwu89PTSiu9PJe4+EDDdncfrOy8F281L2DDkmrmP/G89oKVHt
	ow+uwnuKT327JCuDEN1XPzOP2O+kDLJERENWCrQuNwK6AJhLXg8aEpHv5j2unXOT0pRcLG1zWOi
	2P2YUONSF95IH0xOeasjH+bgfvYNfkY7KryuGAo62hu+/PCTP4Qc6wx7Y3Uk6cG9pWCUxDdKxt/
	4I4wtxXp0U7R3FHA5xtAK9Uiy3SXhFjsOG1nLqxCA/JqlCXMjlY8Ci8U7FElGIvUGIZB+JLpgTZ
	+1I3yaEGcykoO6huZZfvqg15J78l1ePyFFXTDx1mfDJkhc5Bs5J0MkXjq0uNEI+qNFi9YRJI1bW
	0QJxR9LZhcdYYWbwd8NAUZ8
X-Received: by 2002:a05:600c:4ba6:b0:485:3c09:843 with SMTP id 5b1f17b1804b1-486f8b6ced4mr59416875e9.9.1773958440744;
        Thu, 19 Mar 2026 15:14:00 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43b644bdaf8sm1535235f8f.13.2026.03.19.15.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 15:14:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmpathutil: add generic implementation for checker thread runners
Date: Thu, 19 Mar 2026 23:13:42 +0100
Message-ID: <20260319221344.753790-3-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319221344.753790-1-mwilck@suse.com>
References: <20260319221344.753790-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This code adds a generic, abstract implementation of the kind of threads we
need for checkers: detached threads that may time out. The design is such
that these threads never access any memory of the calling program, strongly
simplifying the management of lifetimes of objects.

See the documentation of the API in "runner.h".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/Makefile             |   2 +-
 libmpathutil/libmpathutil.version |   6 +-
 libmpathutil/runner.c             | 205 ++++++++++++++++++++++++++++++
 libmpathutil/runner.h             |  84 ++++++++++++
 4 files changed, 295 insertions(+), 2 deletions(-)
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
index 22ef994..5a7df82 100644
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
@@ -62,6 +62,8 @@ global:
 	cleanup_vector;
 	cleanup_vector_free;
 	convert_dev;
+	cancel_runner;
+	check_runner;
 	dlog;
 	filepresent;
 	fill_strbuf;
@@ -72,6 +74,7 @@ global:
 	free_strvec;
 	get_linux_version_code;
 	get_monotonic_time;
+	get_runner;
 	get_strbuf_buf__;
 	get_next_string;
 	get_strbuf_len;
@@ -162,6 +165,7 @@ global:
 	pthread_cond_init_mono;
 	recv_packet;
 	reset_strbuf;
+	runner_state_name;
 	safe_write;
 	send_packet;
 	set_max_fds;
diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
new file mode 100644
index 0000000..8a49d92
--- /dev/null
+++ b/libmpathutil/runner.c
@@ -0,0 +1,205 @@
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
+		[RUNNER_CANCELLED] = "cancelled"
+	};
+	// clang-format on
+
+	if (state < RUNNER_IDLE || state > RUNNER_CANCELLED)
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
+	char data[];
+};
+
+static void release_context(struct runner_context *ctx)
+{
+	int n;
+
+	n = uatomic_sub_return(&ctx->refcount, 1);
+	assert(n >= 0);
+
+	if (n == 0)
+		free(ctx);
+}
+
+static void cleanup_context(struct runner_context **ctx)
+{
+	if (*ctx)
+		release_context(*ctx);
+}
+
+static void *runner_thread(void *arg)
+{
+	int st, refcount;
+	/*
+	 * The cleanup function makes sure memory is freed if the thread is
+	 * cancelled (-fexceptions).
+	 */
+	struct runner_context *ctx __attribute__((cleanup(cleanup_context))) = arg;
+
+	refcount = uatomic_add_return(&ctx->refcount, 1);
+	assert(refcount == 2);
+
+	st = uatomic_cmpxchg(&ctx->status, RUNNER_IDLE, RUNNER_RUNNING);
+	/*
+	 * The thread has already been cancelled before it was even started.
+	 * In this case, cancel_runner() doesn't release the context.
+	 * Do it here. See comments for RUNNER_IDLE in cancel_runner().
+	 */
+	if (st != RUNNER_IDLE) {
+		release_context(ctx);
+		return NULL;
+	}
+
+	(*ctx->func)(ctx->data);
+	uatomic_cmpxchg(&ctx->status, RUNNER_RUNNING, RUNNER_DONE);
+	return NULL;
+}
+
+void cancel_runner(struct runner_context *ctx)
+{
+	int st = uatomic_cmpxchg(&ctx->status, RUNNER_RUNNING, RUNNER_CANCELLED);
+	int level = 4, retry = 1;
+
+repeat:
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
+			st = uatomic_cmpxchg(&ctx->status, RUNNER_IDLE,
+					     RUNNER_CANCELLED);
+			goto repeat;
+		}
+		level = 3;
+		break;
+	case RUNNER_RUNNING:
+		pthread_cancel(ctx->thr);
+		/* Caller has no interest in the data any more */
+		release_context(ctx);
+		return;
+	case RUNNER_DONE:
+		/* Caller has no interest in the data any more */
+		release_context(ctx);
+		/* fallthrough */
+	default:
+		level = 3;
+		break;
+	}
+	condlog(level, "%s: runner cancelled in state '%s', ctx=%p", __func__,
+		runner_state_name(st), ctx);
+}
+
+struct runner_context *get_runner(runner_func func, void *data,
+				  unsigned int size, unsigned long timeout_usec)
+{
+	static const struct timespec time_zero = {.tv_sec = 0};
+	struct runner_context *ctx;
+	pthread_attr_t attr;
+	int rc;
+
+	assert(func);
+	assert(data);
+	assert(size > 0);
+
+	ctx = malloc(sizeof(*ctx) + size);
+	if (!ctx)
+		return NULL;
+
+	ctx->func = func;
+	uatomic_set(&ctx->refcount, 1);
+	uatomic_set(&ctx->status, RUNNER_IDLE);
+	memcpy(ctx->data, data, size);
+
+	if (timeout_usec) {
+		get_monotonic_time(&ctx->deadline);
+		ctx->deadline.tv_sec += timeout_usec / MILLION;
+		ctx->deadline.tv_nsec += (timeout_usec % MILLION) * 1000;
+	} else
+		ctx->deadline = time_zero;
+
+	/*
+	 * This pairs with the implicit barrier in uatomic_add_return()
+	 * in runner_thread()
+	 */
+	cmm_smp_wmb();
+
+	setup_thread_attr(&attr, STACK_SIZE, 1);
+	rc = pthread_create(&ctx->thr, &attr, runner_thread, ctx);
+	pthread_attr_destroy(&attr);
+
+	if (rc) {
+		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
+		release_context(ctx);
+		return NULL;
+	}
+	return ctx;
+}
+
+int check_runner(struct runner_context *ctx, void *data, unsigned int size)
+{
+	int st = uatomic_read(&ctx->status);
+
+	switch (st) {
+	case RUNNER_DONE:
+		if (data)
+			/* hand back the data to the caller */
+			memcpy(data, ctx->data, size);
+		/* caller is done with this context */
+		release_context(ctx);
+		/* fallthrough */
+	case RUNNER_CANCELLED:
+		return st;
+	case RUNNER_IDLE:
+	case RUNNER_RUNNING:
+		if (ctx->deadline.tv_sec != 0 || ctx->deadline.tv_nsec != 0) {
+			struct timespec now;
+
+			get_monotonic_time(&now);
+			if (timespeccmp(&ctx->deadline, &now) <= 0) {
+				cancel_runner(ctx);
+				return RUNNER_CANCELLED;
+			}
+		}
+		return RUNNER_RUNNING;
+	default:
+		condlog(1, "%s: runner in impossible state '%s'", __func__,
+			runner_state_name(st));
+		assert(false);
+		return st;
+	}
+}
diff --git a/libmpathutil/runner.h b/libmpathutil/runner.h
new file mode 100644
index 0000000..0c9cf80
--- /dev/null
+++ b/libmpathutil/runner.h
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2026 SUSE LLC
+#ifndef RUNNER_H_INCLUDED
+#define RUNNER_H_INCLUDED
+
+enum runner_status {
+	RUNNER_IDLE,
+	RUNNER_RUNNING,
+	RUNNER_DONE,
+	RUNNER_CANCELLED,
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
+ * @param timeout_sec: timeout (in seconds) after which to cancel the runner.
+ *        If it is 0, the runner will not time out.
+ * @returns: a runner context that must be passed to the functions below.
+ */
+struct runner_context *get_runner(runner_func func, void *data,
+				  unsigned int size, unsigned long timeout_usec);
+
+/**
+ * cancel_runner(): cancel a runner thread.
+ *
+ * This function should be called to terminate runners on program exit,
+ * or to terminate runners that have no timeout set in @get_runner,
+ * and haven't completed.
+ * Upon return of this function, @ctx becomes stale and shouldn't accessed
+ * any more.
+ *
+ * @param ctx: the context of the runner to be cancelled.
+ */
+void cancel_runner(struct runner_context *ctx);
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
+ * If @check_runner returns @RUNNER_CANCELLED or @RUNNER_DONE, the @ctx object
+ * has become stale and must not be used any more.
+ * @RUNNER_CANCELLED is returned if the timeout set in @get_runner has passed
+ * and the worker function hasn't returned yet.
+ *
+ * @param ctx: the context of the runner to be queried
+ * @param data: memory pointer that will receive results of the worker
+ * function. Can be NULL, in which case no data will be copied.
+ * @param size: size of the memory pointed to by data. It must be no bigger
+ *        than the size of the memory passed to @get_runner for this runner.
+ *        It can be smaller, but no more than @size bytes will be copied.
+ * @returns: @RUNNER_RUNNING, @RUNNER_DONE, or @RUNNER_CANCELLED.
+ */
+int check_runner(struct runner_context *ctx, void *data, unsigned int size);
+
+#endif /* RUNNER_H_INCLUDED */
-- 
2.53.0

