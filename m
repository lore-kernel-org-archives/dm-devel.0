Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689FD28150F
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958447; cv=none; b=myqlwRvd/kaLCxOHAintfCnBjkKDm2cO16OLmXJjde4GZ0bOqmLlnYrLU1YkaIrbigoT2Dh26TScLnJugAZNK3F18IiCrvLV78Hy7YhLyumSAUZptxwiJIz09CuHXzuGZ2brY+ZAdQ0wBr6cXBPE18jq0VwF2l1pvlm4mmzDsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958447; c=relaxed/simple;
	bh=wUwH+o9qVIg2Z83ukWYXUJHzW4/AYH1ByLFtgeYPE6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmgye3i5en6QZH3NJNhMA7Wxg15SYSgF53oHaFtXDXPApn+rfMduDO+f0zAWFYIM4YPqtAIFv9ClkF5Lgd0hfDMkFf8NtRPOOfSMzFBOS258KgAywgOBchTaO3RMLPIbLXkCLMXG8P6VGi5SLJhVlyYhue7DHF5IrkqRZ39IuRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GIfyY+MT; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GIfyY+MT"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so2025e9.2
        for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773958444; x=1774563244; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvvKnEWrXGPCiokkTIu971BvCQnhmOr6rnJo5Gyno+A=;
        b=GIfyY+MT0sUvFX5SWn4LK8QkCvZCCZ9RVsHYxnYt0k+qToxye+bDAzCf65U79z3XA2
         gHf+Mj8x7Hndt5fo5dOvBkL2T2j+ROkqYk6mvw6gLlh+q8U/yliNtsfkJicdWTMNRfPj
         p5cZ0s54QUHjy/+9a+4FTEmAFqJ1h08PL6TgVcVgLUyEchMPc9KcAvBa4YfTtCe1I6S9
         q/TqDoUWDbeMFdXqmGADXwwR01f4ehmAlx/Kj3jj4VUL4L2m7MDO6vqwSrssw2LLh2it
         8StwMpQYWVjwHrgY+O7UfQyTNeAkR/6YOe2ZAJz6EkOp8KsvX4rmwkbXOuRozS22hxXi
         xLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773958444; x=1774563244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bvvKnEWrXGPCiokkTIu971BvCQnhmOr6rnJo5Gyno+A=;
        b=eRSq3D/Pe6P8cN0GqzsKoRxa5utacx5+XkJ7ZPuQZfQ6rNtOgpKlc7ZKLOJGK4xhNk
         0obQGRKnoYnn4qw9LiTc1tL35N07UICiJufYUacbz7q9wNlqku3uqhVVEN7zg074r/o2
         g7peieQElftK+vcwQjM4pRC+5dD8+pBpajIv5y/p5zODpTURjvuiV+W2eiYVUe8YYtew
         E3DY4lHTDUPYDqWdqwJjNHXIGM49aM0mgHuX3+y0MBLtQGMK/QsY8BijlUiyfwT3Yf7R
         mclFwQ+lzr33COSpYzKeCO2NGR/RJi8s4uN7lHQtrh8LW1CB7X3KJlNfnOV5tZHoB/DZ
         JMsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFkd+NOVnK+3P1lGxkatua8BLN+p2VSniy9NVK8SYPqp4skLXtiRnwqNJysTcfoK8yBxwmPL/0iA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxfKaWdCUhUTDbiQuWJVT4HRMorhkyv6Gwk+aIPXfGmRxNp4x2D
	w7Gu/z0/MLAXbYnjb9XaHgPCiRQjaKii/qL7h68gSRyDMcki4dpn3mELsmAC9dZHMxM=
X-Gm-Gg: ATEYQzzG2nAjI0MIubVDqzfNv+j58d38dD1hHCSEa+/ojWLcbHHyUvhNC06BrVV1U1C
	iwQ5defErc8MRN4NzLaYuMqENJQ0UvGh1Gde1bm4zHVsLsgr0k8s4O02D5ZhQiChX+LlvAFf61E
	1N+lZ1USfoFHbCtiQRVfOkjwU8uz3o7TUfXgymaNAxLKr1zxiwmbKh7TNILL3qgql1zSaOxA1KO
	iLOUy9PuslOuozKP+V7kBmJelHSJS7fdFXYFlgOJBPfSmq4ffg/SNu/RXzOpM6OcWlqUtExzapT
	Cu/DBZUFV99jZTdANXLQGmxneAQnslH/nR5LEaET44MuqHBmqMl96yzZEq7q118r5t3XTdHGuMN
	OR/z1mEVUav+BQlr4+BxIhgPyh1Xd0S0XIi7mwH4LtXjY1E993KsnB27FnEl415MAT5v0kq/b/z
	Bj85ZdSx3Raw2xZHAGUtryzWXLBWsSa871AfGjmaZ9sp7wP9ViYFdLT91+pL6yd6ngrtZUwePEN
	QRryFGUrG2IaTCy+9SYFgoJ
X-Received: by 2002:a05:600c:4e8e:b0:485:f1d1:8f29 with SMTP id 5b1f17b1804b1-486fedaae27mr10361125e9.2.1773958443525;
        Thu, 19 Mar 2026 15:14:03 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43b644ae619sm2016376f8f.5.2026.03.19.15.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 15:14:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] libmultipath: TUR checker: use runner threads
Date: Thu, 19 Mar 2026 23:13:44 +0100
Message-ID: <20260319221344.753790-5-mwilck@suse.com>
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

Use the generic runners to simplify the TUR checker code.

The logic is the same as before, with one exception: the runner API does
not allow to track a thread after it has been cancelled, like our current
code does. The current code used this to determine when a previously
cancelled thread eventually did complete. The use case for doing this in
the current code was the MAX_NR_RUNNERS logic: the code waited "forever"
for the "last" checker to complete. This is not possible with runners;
once a runner is cancelled, it is off limits. (Waiting for a zombie thread to
write to memory belonging to the main program, as the current code does,
doesn't seem to be the best idea, anyway).

Therefore this patch implements a different logic for MAX_NR_RUNNERS. When
nr_timeouts reaches the limit, the last checker is spawned with an infinite
timeout. Like before, no new checker thread will be spawned until this last
checker eventually completes. One difference to the previous code is that
this last checker thread is never cancelled (after all, it never times
out). But this code is meant for the case where cancellation is not
effective, anyway. Another difference is that the new code will report
PATH_TIMEOUT state as soon as this last thread is started rather than
PATH_PENDING. That seems reasonable given that the checker previously timed
out for this thread.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 341 +++++++++++-------------------------
 1 file changed, 103 insertions(+), 238 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ba4ca68..6f22c45 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -3,7 +3,6 @@
  *
  * Copyright (c) 2004 Christophe Varoqui
  */
-#include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
@@ -17,13 +16,13 @@
 #include <pthread.h>
 #include <urcu.h>
 #include <urcu/uatomic.h>
+#include <assert.h>
 
 #include "checkers.h"
 
 #include "debug.h"
 #include "sg_include.h"
-#include "util.h"
-#include "time-util.h"
+#include "runner.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
@@ -45,21 +44,20 @@ const char *libcheck_msgtable[] = {
 	NULL,
 };
 
-struct tur_checker_context {
-	dev_t devt;
-	int state;
-	int running; /* uatomic access only */
+struct tur_context {
 	int fd;
+	dev_t devt;
 	unsigned int timeout;
-	time_t time;
-	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t active;
-	int holders; /* uatomic access only */
-	int msgid;
+	int state;
+	short msgid;
+};
+
+struct tur_checker_context {
 	struct checker_context ctx;
+	int last_runner_state;
 	unsigned int nr_timeouts;
-	bool checked_state;
+	struct runner_context *rtx;
+	struct tur_context tcx;
 };
 
 int libcheck_init (struct checker * c)
@@ -67,48 +65,26 @@ int libcheck_init (struct checker * c)
 	struct tur_checker_context *ct;
 	struct stat sb;
 
-	ct = malloc(sizeof(struct tur_checker_context));
-	if (!ct)
-		return 1;
-	memset(ct, 0, sizeof(struct tur_checker_context));
-
-	ct->state = PATH_UNCHECKED;
-	ct->fd = -1;
-	uatomic_set(&ct->holders, 1);
-	pthread_cond_init_mono(&ct->active);
-	pthread_mutex_init(&ct->lock, NULL);
+	ct = calloc(1, sizeof(*ct));
+	ct->tcx.state = PATH_UNCHECKED;
+	ct->tcx.fd = -1;
 	if (fstat(c->fd, &sb) == 0)
-		ct->devt = sb.st_rdev;
+		ct->tcx.devt = sb.st_rdev;
 	ct->ctx.cls = c->cls;
 	c->context = ct;
-
 	return 0;
 }
 
-static void cleanup_context(struct tur_checker_context *ct)
-{
-	pthread_mutex_destroy(&ct->lock);
-	pthread_cond_destroy(&ct->active);
-	free(ct);
-}
-
 void libcheck_free (struct checker * c)
 {
-	if (c->context) {
-		struct tur_checker_context *ct = c->context;
-		int holders;
-		int running;
+	struct tur_checker_context *tcc = c->context;
 
-		running = uatomic_xchg(&ct->running, 0);
-		if (running)
-			pthread_cancel(ct->thread);
-		ct->thread = 0;
-		holders = uatomic_sub_return(&ct->holders, 1);
-		if (!holders)
-			cleanup_context(ct);
-		c->context = NULL;
-	}
-	return;
+	if (!tcc)
+		return;
+	c->context = NULL;
+	if (tcc->rtx)
+		cancel_runner(tcc->rtx);
+	free(tcc);
 }
 
 static int
@@ -216,19 +192,6 @@ retry:
 	return PATH_UP;
 }
 
-#define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
-#define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
-
-static void cleanup_func(void *data)
-{
-	int holders;
-	struct tur_checker_context *ct = data;
-
-	holders = uatomic_sub_return(&ct->holders, 1);
-	if (!holders)
-		cleanup_context(ct);
-}
-
 /*
  * Test code for "zombie tur thread" handling.
  * Compile e.g. with CFLAGS=-DTUR_TEST_MAJOR=8
@@ -273,110 +236,82 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 #define tur_deep_sleep(x) do {} while (0)
 #endif /* TUR_TEST_MAJOR */
 
-void *libcheck_thread(struct checker_context *ctx)
+void runner_callback(void *arg)
 {
-	struct tur_checker_context *ct =
-		container_of(ctx, struct tur_checker_context, ctx);
-	int state, running;
-	short msgid;
+	struct tur_context *tcx = arg;
+	int state;
 
-	/* This thread can be canceled, so setup clean up */
-	tur_thread_cleanup_push(ct);
+	condlog(4, "%d:%d : tur checker starting up", major(tcx->devt),
+		minor(tcx->devt));
 
-	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
-		minor(ct->devt));
-
-	tur_deep_sleep(ct);
-	state = tur_check(ct->fd, ct->timeout, &msgid);
+	tur_deep_sleep(tcx);
+	state = tur_check(tcx->fd, tcx->timeout, &tcx->msgid);
+	tcx->state = state;
 	pthread_testcancel();
-
-	/* TUR checker done */
-	pthread_mutex_lock(&ct->lock);
-	ct->state = state;
-	ct->msgid = msgid;
-	pthread_cond_signal(&ct->active);
-	pthread_mutex_unlock(&ct->lock);
-
-	condlog(4, "%d:%d : tur checker finished, state %s", major(ct->devt),
-		minor(ct->devt), checker_state_name(state));
-
-	running = uatomic_xchg(&ct->running, 0);
-	if (!running)
-		pause();
-
-	tur_thread_cleanup_pop(ct);
-
-	return ((void *)0);
+	condlog(4, "%d:%d : tur checker finished, state %s", major(tcx->devt),
+		minor(tcx->devt), checker_state_name(state));
 }
 
-static void tur_set_async_timeout(struct checker *c)
+static int check_runner_state(struct tur_checker_context *tcc)
 {
-	struct tur_checker_context *ct = c->context;
-	struct timespec now;
+	struct runner_context *rtx = tcc->rtx;
+	int rc;
 
-	get_monotonic_time(&now);
-	ct->time = now.tv_sec + c->timeout;
-}
-
-static int tur_check_async_timeout(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	struct timespec now;
-
-	get_monotonic_time(&now);
-	return (now.tv_sec > ct->time);
-}
-
-int check_pending(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	int tur_status = PATH_PENDING;
-
-	pthread_mutex_lock(&ct->lock);
-
-	if (ct->state != PATH_PENDING || ct->msgid != MSG_TUR_RUNNING)
-	{
-		tur_status = ct->state;
-		c->msgid = ct->msgid;
-	}
-	pthread_mutex_unlock(&ct->lock);
-	if (tur_status == PATH_PENDING && c->msgid == MSG_TUR_RUNNING) {
+	rc = check_runner(rtx, &tcc->tcx, sizeof(tcc->tcx));
+	switch (rc) {
+	case RUNNER_DONE:
+		tcc->last_runner_state = rc;
+		tcc->rtx = NULL;
+		tcc->nr_timeouts = 0;
+		condlog(3, "%d:%d : tur checker finished, state %s",
+			major(tcc->tcx.devt), minor(tcc->tcx.devt),
+			checker_state_name(tcc->tcx.state));
+		break;
+	case RUNNER_CANCELLED:
+		tcc->last_runner_state = rc;
+		tcc->rtx = NULL;
+		tcc->tcx.state = PATH_TIMEOUT;
+		tcc->tcx.msgid = MSG_TUR_TIMEOUT;
+		if (tcc->nr_timeouts < MAX_NR_TIMEOUTS)
+			tcc->nr_timeouts++;
+		condlog(3, "%d:%d : tur checker timed out",
+			major(tcc->tcx.devt), minor(tcc->tcx.devt));
+		break;
+	case RUNNER_RUNNING:
 		condlog(4, "%d:%d : tur checker still running",
-			major(ct->devt), minor(ct->devt));
-	} else {
-		int running = uatomic_xchg(&ct->running, 0);
-		if (running)
-			pthread_cancel(ct->thread);
-		ct->thread = 0;
+			major(tcc->tcx.devt), minor(tcc->tcx.devt));
+		tcc->tcx.msgid = MSG_TUR_RUNNING;
+		break;
+	default:
+		assert(false);
+		break;
 	}
-
-	ct->checked_state = true;
-	return tur_status;
+	return rc;
 }
 
 bool libcheck_need_wait(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
-	return (ct && ct->thread && uatomic_read(&ct->running) != 0 &&
-		!ct->checked_state);
+
+	return ct && ct->rtx;
 }
 
 int libcheck_pending(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
-
 	/* The if path checker isn't running, just return the exiting value. */
-	if (!ct || !ct->thread)
+	if (!ct || !ct->rtx)
 		return c->path_state;
 
-	return check_pending(c);
+	/* This may nullify ct->rtx */
+	check_runner_state(ct);
+	c->msgid = ct->tcx.msgid;
+	return ct->tcx.state;
 }
 
 int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
-	pthread_attr_t attr;
-	int tur_status, r;
 
 	if (!ct)
 		return PATH_UNCHECKED;
@@ -384,109 +319,39 @@ int libcheck_check(struct checker * c)
 	if (checker_is_sync(c))
 		return tur_check(c->fd, c->timeout, &c->msgid);
 
-	/*
-	 * Async mode
-	 */
-	if (ct->thread) {
-		ct->checked_state = true;
-		if (tur_check_async_timeout(c)) {
-			int running = uatomic_xchg(&ct->running, 0);
-			if (running) {
-				pthread_cancel(ct->thread);
-				condlog(3, "%d:%d : tur checker timeout",
-					major(ct->devt), minor(ct->devt));
-				c->msgid = MSG_TUR_TIMEOUT;
-				tur_status = PATH_TIMEOUT;
-			} else {
-				pthread_mutex_lock(&ct->lock);
-				tur_status = ct->state;
-				c->msgid = ct->msgid;
-				pthread_mutex_unlock(&ct->lock);
-			}
-			ct->thread = 0;
-		} else if (uatomic_read(&ct->running) != 0) {
+	/* Handle the case that the checker just completed */
+	if (ct->rtx) {
+		if (check_runner_state(ct) == RUNNER_RUNNING)
 			condlog(3, "%d:%d : tur checker not finished",
-				major(ct->devt), minor(ct->devt));
-			tur_status = PATH_PENDING;
-			c->msgid = MSG_TUR_RUNNING;
-		} else {
-			/* TUR checker done */
-			ct->thread = 0;
-			pthread_mutex_lock(&ct->lock);
-			tur_status = ct->state;
-			c->msgid = ct->msgid;
-			pthread_mutex_unlock(&ct->lock);
-		}
-	} else {
-		if (uatomic_read(&ct->holders) > 1) {
-			/* The thread has been cancelled but hasn't quit. */
-			if (ct->nr_timeouts == MAX_NR_TIMEOUTS) {
-				condlog(2, "%d:%d : waiting for stalled tur thread to finish",
-					major(ct->devt), minor(ct->devt));
-				ct->nr_timeouts++;
-			}
-			/*
-			 * Don't start new threads until the last once has
-			 * finished.
-			 */
-			if (ct->nr_timeouts > MAX_NR_TIMEOUTS) {
-				c->msgid = MSG_TUR_TIMEOUT;
-				return PATH_TIMEOUT;
-			}
-			ct->nr_timeouts++;
-			/*
-			 * Start a new thread while the old one is stalled.
-			 * We have to prevent it from interfering with the new
-			 * thread. We create a new context and leave the old
-			 * one with the stale thread, hoping it will clean up
-			 * eventually.
-			 */
-			condlog(3, "%d:%d : tur thread not responding",
-				major(ct->devt), minor(ct->devt));
-
-			/*
-			 * libcheck_init will replace c->context.
-			 * It fails only in OOM situations. In this case, return
-			 * PATH_UNCHECKED to avoid prematurely failing the path.
-			 */
-			if (libcheck_init(c) != 0) {
-				c->msgid = MSG_TUR_FAILED;
-				return PATH_UNCHECKED;
-			}
-			((struct tur_checker_context *)c->context)->nr_timeouts = ct->nr_timeouts;
-
-			if (!uatomic_sub_return(&ct->holders, 1)) {
-				/* It did terminate, eventually */
-				cleanup_context(ct);
-				((struct tur_checker_context *)c->context)->nr_timeouts = 0;
-			}
-
-			ct = c->context;
-		} else
-			ct->nr_timeouts = 0;
-		/* Start new TUR checker */
-		pthread_mutex_lock(&ct->lock);
-		tur_status = ct->state = PATH_PENDING;
-		c->msgid = ct->msgid = MSG_TUR_RUNNING;
-		pthread_mutex_unlock(&ct->lock);
-		ct->fd = c->fd;
-		ct->timeout = c->timeout;
-		ct->checked_state = false;
-		uatomic_add(&ct->holders, 1);
-		uatomic_set(&ct->running, 1);
-		tur_set_async_timeout(c);
-		setup_thread_attr(&attr, 32 * 1024, 1);
-		r = start_checker_thread(&ct->thread, &attr, &ct->ctx);
-		pthread_attr_destroy(&attr);
-		if (r) {
-			uatomic_sub(&ct->holders, 1);
-			uatomic_set(&ct->running, 0);
-			ct->thread = 0;
-			condlog(3, "%d:%d : failed to start tur thread, using"
-				" sync mode", major(ct->devt), minor(ct->devt));
-			return tur_check(c->fd, c->timeout, &c->msgid);
-		}
+				major(ct->tcx.devt), minor(ct->tcx.devt));
+		c->msgid = ct->tcx.msgid;
+		return ct->tcx.state;
 	}
 
-	return tur_status;
+	/* create new checker thread */
+	ct->tcx.fd = c->fd;
+	ct->tcx.timeout = c->timeout;
+
+	if (ct->nr_timeouts < MAX_NR_TIMEOUTS) {
+		condlog(3, "%d:%d : starting checker with timeout",
+			major(ct->tcx.devt), minor(ct->tcx.devt));
+		ct->tcx.state = PATH_PENDING;
+		ct->tcx.msgid = MSG_TUR_RUNNING;
+		ct->rtx = get_runner(runner_callback, &ct->tcx,
+				     sizeof(ct->tcx), 1000000 * c->timeout);
+	} else {
+		condlog(3, "%d:%d : starting checker without timeout",
+			major(ct->tcx.devt), minor(ct->tcx.devt));
+		ct->tcx.state = PATH_TIMEOUT;
+		ct->rtx = get_runner(runner_callback, &ct->tcx, sizeof(ct->tcx), 0);
+	}
+
+	if (ct->rtx) {
+		c->msgid = ct->tcx.msgid;
+		return ct->tcx.state;
+	} else {
+		condlog(3, "%d:%d : failed to start tur thread, using sync mode",
+			major(ct->tcx.devt), minor(ct->tcx.devt));
+		return tur_check(c->fd, c->timeout, &c->msgid);
+	}
 }
-- 
2.53.0

