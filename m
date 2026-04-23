Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855430FC1F
	for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977111; cv=none; b=TMVl3oINTRFKLDlY/Mj884sY97f5EHyoi+qAtjJlywtuOLQ/YImiUTyXyV5UM36XJQ0DUqIpXUnSpIBgj7Y3BdIn8RQwdSeW81TfHkVuP9L5X5pRPIByjvIe0HYRS3e/4JLRfOchRxJARCZ1Py0k2n7wD9ciCN3pMqzr+m+ctCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977111; c=relaxed/simple;
	bh=sywyPJn3QMIU8aUo/T+jSe8wEsT1q2OhUg4UC5/VN8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX7EYQ+tANYgEqYu8AykiboorgyDkmoJJ2tgd1poIxfIoubSIa2bYO0OrjZPQn6UbIzOmoF0XrYnySa1scE9AgSfewxtM1YoO7RDKgbkpKxXfYhSIauMtkZIbFHRUiy5WJ3A1OFulpcZhlmbx6gN6MnidtZmjZAihuiAtcAqe/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A/MhPr6/; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A/MhPr6/"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so116076495e9.2
        for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776977108; x=1777581908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XX/bM6sA4qKmlilUWcw+tCq8Cdw/PaHgjR2EDimI/3U=;
        b=A/MhPr6/8gxw4mSTutOXOXc26n8sHMJrQpuwfxpYofTL9IhVC4Zwy5MBqiVta7ClpK
         YsJCzQHvZOvWxM3c0f/xfi2An3X/5JoaYZ2NsdhtN5p3+HXjj0VBh5O1WnQYUZzBtmkC
         VCnQoPniqfMX1cedAy2+XZnOmzCoYghLEXn80Ek9YHmSo9Ls5Yha+gkbGsFxOGD3DpTE
         Sn5+HpGAk6LuqR6eKt+6QojPNlZK6wk3Txpx+iUqsS0mhNn0+8V1P6OJohtH/a7mIpWN
         1mJTqP76cQzDM0yV/FV1rfqlyk3pHXqIeAquMscRCJva3eBotLWSLrcEQQ5nk83+oJa4
         SpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977108; x=1777581908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XX/bM6sA4qKmlilUWcw+tCq8Cdw/PaHgjR2EDimI/3U=;
        b=GTEukowMTXiV9PuYMApaIHu2rKEO/J0X+GynkFyBkHb4JHlr2Z0DqjXQhMfD1SDyrN
         1ygaNV1bMmBDpPhACmUn/NC+bFh45+CSlQrAgWugKJ03CPvIioa2fF51QYp/yxNGhvrW
         UJ4vAWznolzW76ROL1fI4PvtC+diYgZmRb48sMGC/zLLtsIjYvgTT4BtR6/pDSyXX+YC
         ovSsjVcSbgrwC0tWk8lo8Y+sjwrdjDonjbtXYzCzZhu2I/MAqmHewM6mNPuYVsJgIiyM
         z/qHy3Ohw2q+4id4TsFC6qsoNYGf/jZJQiEcs86YsKtK4Xb1R87V3YQVKmal0OlDb3VP
         EobA==
X-Forwarded-Encrypted: i=1; AFNElJ/8a137sFg+dVI7fMwnu/5T1hKr1zZEG3qDmGzVAsqG3PLcTohOuRZnGTlkdSMXot6yajMomU2BKg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwOwCF5ZbFdUdhio/tNjDVdf7u95c+jB3T88khMiZIzgAObnmk8
	0xzqB4Zk4U4cyPHNHUN8Vs+WQiXiMj1IMb0uEf5H1QP/WawNFXJm3R5cdEm9rbDhQ1o=
X-Gm-Gg: AeBDieuPcVu4BRbEgTRVTky4qwXNCprwt8TD+vX6AAueUCCS3dpH2n3c3XO5GCsuJPx
	CNh52Cd9emvjo0/il1qazLcb3MXjBKQSB5venALDdeE51wVvgInJRdk5px+enlv35rivyiXT4ec
	LQjwr8JAKCokPisqYpPnQ5SEnJ651t/59M5nXrPQ3vOI88VuYXvhFn+T76ouNA9DDTRLnD2bnAO
	QNo8EeJDV7fyjrt0Bz8a/tnMsHbd3SrGo76RNZuh/u08sKbWs5g9iLQuQ/1p941Cg5yhTE2bKAO
	DTtUx9ow/iXgHsCEPr/kjZ6i7jhLhbnZadP/WgjS2/8j+p96v/+PVwVDytUiQ6i6AvA6U0ehtp6
	omIVjM4L+tCzEn+VWswL4/U+zwtzJ2qCx8N/YT8cJKsiQJal0pAgNq8i/4/9HKd+QSeCngf9IIL
	GtRekBIeiuHxWt/A8GJk09VeLSBM4JL3I4vjr96firNoSLyBdM0bhgjHKZKItGqwHbRYoi6tHRW
	3jmRj0cGAM0NzjnUg5nf1Yz
X-Received: by 2002:a05:600c:8488:b0:488:a882:c7 with SMTP id 5b1f17b1804b1-488fb77b575mr389810165e9.25.1776977107792;
        Thu, 23 Apr 2026 13:45:07 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a575d531esm62222025e9.13.2026.04.23.13.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 13:45:07 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/5] libmultipath: TUR checker: use runner threads
Date: Thu, 23 Apr 2026 22:44:45 +0200
Message-ID: <20260423204446.472642-5-mwilck@suse.com>
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

Use the generic runners to simplify the TUR checker code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 363 +++++++++++-------------------------
 1 file changed, 112 insertions(+), 251 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ba4ca68..0a312c7 100644
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
@@ -14,16 +13,11 @@
 #include <sys/sysmacros.h>
 #include <errno.h>
 #include <sys/time.h>
-#include <pthread.h>
-#include <urcu.h>
-#include <urcu/uatomic.h>
 
 #include "checkers.h"
-
 #include "debug.h"
 #include "sg_include.h"
-#include "util.h"
-#include "time-util.h"
+#include "runner.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
@@ -45,70 +39,47 @@ const char *libcheck_msgtable[] = {
 	NULL,
 };
 
-struct tur_checker_context {
-	dev_t devt;
-	int state;
-	int running; /* uatomic access only */
+struct tur_data {
 	int fd;
+	dev_t devt;
 	unsigned int timeout;
-	time_t time;
-	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t active;
-	int holders; /* uatomic access only */
-	int msgid;
-	struct checker_context ctx;
-	unsigned int nr_timeouts;
-	bool checked_state;
+	int state;
+	short msgid;
 };
 
-int libcheck_init (struct checker * c)
+struct tur_checker_context {
+	struct checker_context chkr;
+	int last_runner_state;
+	unsigned int nr_timeouts;
+	struct runner_context *rtx;
+	struct tur_data tdata;
+};
+
+int libcheck_init(struct checker *c)
 {
-	struct tur_checker_context *ct;
+	struct tur_checker_context *tcc;
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
+	tcc = calloc(1, sizeof(*tcc));
+	tcc->tdata.state = PATH_UNCHECKED;
+	tcc->tdata.fd = -1;
 	if (fstat(c->fd, &sb) == 0)
-		ct->devt = sb.st_rdev;
-	ct->ctx.cls = c->cls;
-	c->context = ct;
-
+		tcc->tdata.devt = sb.st_rdev;
+	tcc->chkr.cls = c->cls;
+	c->context = tcc;
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
+		release_runner(tcc->rtx);
+	free(tcc);
 }
 
 static int
@@ -216,19 +187,6 @@ retry:
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
@@ -249,13 +207,13 @@ static void cleanup_func(void *data)
 #define TUR_SLEEP_SECS 60
 #endif
 
-static void tur_deep_sleep(const struct tur_checker_context *ct)
+static void tur_deep_sleep(const struct tur_data *tdata)
 {
 	static int sleep_cnt;
 	const struct timespec ts = { .tv_sec = TUR_SLEEP_SECS, .tv_nsec = 0 };
 	int oldstate;
 
-	if (ct->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
+	if (tdata->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
 	    ++sleep_cnt % TUR_SLEEP_INTERVAL != 0)
 		return;
 
@@ -273,110 +231,92 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 #define tur_deep_sleep(x) do {} while (0)
 #endif /* TUR_TEST_MAJOR */
 
-void *libcheck_thread(struct checker_context *ctx)
+void runner_callback(void *arg)
 {
-	struct tur_checker_context *ct =
-		container_of(ctx, struct tur_checker_context, ctx);
-	int state, running;
-	short msgid;
+	struct tur_data *tdata = arg;
+	int state;
 
-	/* This thread can be canceled, so setup clean up */
-	tur_thread_cleanup_push(ct);
+	condlog(4, "%d:%d : tur checker starting up", major(tdata->devt),
+		minor(tdata->devt));
 
-	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
-		minor(ct->devt));
-
-	tur_deep_sleep(ct);
-	state = tur_check(ct->fd, ct->timeout, &msgid);
+	tur_deep_sleep(tdata);
+	state = tur_check(tdata->fd, tdata->timeout, &tdata->msgid);
+	tdata->state = state;
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
+	condlog(4, "%d:%d : tur checker finished, state %s", major(tdata->devt),
+		minor(tdata->devt), checker_state_name(state));
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
+	rc = check_runner(rtx, &tcc->tdata, sizeof(tcc->tdata));
+	switch (rc) {
+	case RUNNER_DEAD:
+		tcc->tdata.state = PATH_TIMEOUT;
+		tcc->tdata.msgid = MSG_TUR_TIMEOUT;
+		/* fallthrough */
+	case RUNNER_DONE:
+		release_runner(tcc->rtx);
+		tcc->rtx = NULL;
+		tcc->last_runner_state = rc;
+		tcc->nr_timeouts = 0;
+		condlog(rc == RUNNER_DONE ? 4 : 3,
+			"%d:%d : tur checker finished, state %s, runner state %s",
+			major(tcc->tdata.devt), minor(tcc->tdata.devt),
+			checker_state_name(tcc->tdata.state),
+			runner_state_name(rc));
+		break;
+	case RUNNER_CANCELLED:
+		tcc->last_runner_state = rc;
+		tcc->tdata.state = PATH_TIMEOUT;
+		tcc->tdata.msgid = MSG_TUR_TIMEOUT;
+		if (tcc->nr_timeouts < MAX_NR_TIMEOUTS) {
+			condlog(3, "%d:%d : tur checker timed out, releasing it",
+				major(tcc->tdata.devt), minor(tcc->tdata.devt));
+			tcc->nr_timeouts++;
+			release_runner(tcc->rtx);
+			tcc->rtx = NULL;
+		} else if (tcc->nr_timeouts == MAX_NR_TIMEOUTS) {
+			tcc->nr_timeouts++;
+			condlog(3, "%d:%d : tur checker timed out, waiting for it",
+				major(tcc->tdata.devt), minor(tcc->tdata.devt));
+		}
+		break;
+	default:
 		condlog(4, "%d:%d : tur checker still running",
-			major(ct->devt), minor(ct->devt));
-	} else {
-		int running = uatomic_xchg(&ct->running, 0);
-		if (running)
-			pthread_cancel(ct->thread);
-		ct->thread = 0;
+			major(tcc->tdata.devt), minor(tcc->tdata.devt));
+		tcc->tdata.msgid = MSG_TUR_RUNNING;
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
+	c->msgid = ct->tdata.msgid;
+	return ct->tdata.state;
 }
 
 int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
-	pthread_attr_t attr;
-	int tur_status, r;
 
 	if (!ct)
 		return PATH_UNCHECKED;
@@ -384,109 +324,30 @@ int libcheck_check(struct checker * c)
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
-			condlog(3, "%d:%d : tur checker not finished",
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
+	/* Handle the case that the checker just completed */
+	if (ct->rtx) {
+		check_runner_state(ct);
+		c->msgid = ct->tdata.msgid;
+		return ct->tdata.state;
 	}
 
-	return tur_status;
+	/* create new checker thread */
+	ct->tdata.fd = c->fd;
+	ct->tdata.timeout = c->timeout;
+
+	ct->tdata.state = PATH_PENDING;
+	ct->tdata.msgid = MSG_TUR_RUNNING;
+	condlog(3, "%d:%d : starting checker", major(ct->tdata.devt),
+		minor(ct->tdata.devt));
+	ct->rtx = get_runner(runner_callback, &ct->tdata, sizeof(ct->tdata),
+			     1000000 * c->timeout);
+
+	if (ct->rtx) {
+		c->msgid = ct->tdata.msgid;
+		return ct->tdata.state;
+	} else {
+		condlog(3, "%d:%d : failed to start tur thread, using sync mode",
+			major(ct->tdata.devt), minor(ct->tdata.devt));
+		return tur_check(c->fd, c->timeout, &c->msgid);
+	}
 }
-- 
2.53.0

