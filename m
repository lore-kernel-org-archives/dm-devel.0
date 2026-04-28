Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D793F54BD
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 11:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777377002; cv=none; b=beLTXTad+n24zaZRtMrIWqjRFEINjy2kPKGKxiRtp41FROkbm/aDzsAN9X0r8AwRsFO4TOIa/qAc0PMhvKdVaS2UIJVlfJDanYGELcK187wv15DkrJDe74jPYok4zWYHQrmvJFlhZ5sK3J0DnsOLFonmS6E1x/96fRui4XxtDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777377002; c=relaxed/simple;
	bh=c7VMRTMbjl2dck6OxisSyJR5EcZQgh7jUNssMbR61tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rR+aeYjACbpj9LcKjGdbs+kTzDZGS14eRRmwaQgxUAomY+TTgb+/A3K9sRzBSJ8Ubv/f2kjLtf3S+xSYxWyt3eMWKLDr8Yxt9q0GnPBr604Lc6qibW1G/22NkbG5XOYY/5HUAwh+3G3FQXX1xppMnnO7SPO5g1QbakbldhtbKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hj1Jti0g; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hj1Jti0g"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so137236205e9.0
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777376999; x=1777981799; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VI+0t5izq2DCkIg1cyL98zhRkzu5wy0+zxMRcIE4xUU=;
        b=Hj1Jti0g1uLHA68UKsXDcfy/B2sIPMYPKO3XKgcw5falSmvjebG+UzbV9/SqoxV25G
         VYNP83s+lOzbgKoBGiOuJg8z2kIFVaml5Adw1Q4wyBBg3MCICP4UgneFtuoRjnYEn18z
         v1s3VqqL5n9XVP7IkHbJJ0MDoC0qVg5ozb7OCVBinIcFqN48+4I6nmNi5+VJ3eviOyUG
         rf5QE1goJuPqc7fpP9QK9SERGQaqw3ojcU0j5QXxnQ7gE1FacvHCktHGpAmrhztjXuXe
         o26Gn4Z0O9EioXxemuWqNTrpdV2l9h0NtMGUcqQ/7KNp9dl0AmWhHXRJdpvmTFA58I2b
         Hd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376999; x=1777981799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VI+0t5izq2DCkIg1cyL98zhRkzu5wy0+zxMRcIE4xUU=;
        b=eCKlkE/HfAdpn4G1DFrMJaOVRur6YGDkoPQ6KshEEfNEmpapHuFAk2+0IzJYPeGSqH
         THaZ13XWJ/P3Y0aaVZrBaju/KK4wVs0Gi470lM5+OZMkW0HuC3Tk/pF1Rr4DHwcdczWN
         npV5w2olNJPSZ4UsyhCjnMTBnxbxkFT3cx52ef3ZhkVl7lJXEMZ/Vsl55PEWqxmPpSUn
         eoxoSyfzdsF7mXAjhJdui5dowXPP5AIOxJwhNlTLoRrPc8sHhbhLWTHEP9nMifWOYqH0
         W3Hq7kVa9jmCYlxaMScWxDomGC7s30+QBEpGOzNN4KYc0ZYGlXZ6J9knhYv24owToIVe
         +dvg==
X-Forwarded-Encrypted: i=1; AFNElJ8oZmd0ecnSRI5ftmmdgtNjDuk7duAbLWGm1f9tkfmtHik/GgVdYoLVV7MZdhDdRAJG3PRR2omDKQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YypW9rpQ/DbG2eq4vUu/VyFGcCbdCVcBMGYXr/U2F2uezHlTy16
	Pw9fVbx3bHbyKFGfWCHv/npSgDM4ezNJqdE9GDrR/J0BNqBjaUAii2/etQwr9Lx/O0F/DqnvoZU
	Mar/8i/M=
X-Gm-Gg: AeBDieuiQmFyM6zUvlryW10etfLmvLkpeQo8pBEjAbOSXuMn0QLwW6lezBGHVxiJ4V5
	gLte3I03zrIcXVo6em0biO0GYsccrtUE17aayfD3o73WF0IJMTJzaPsBfh0YLP2i4UzCpvY7VOr
	59W9yjeGtYC29cr99KnLoufHd97dvevvPeqLMytkO0jCZEGAOiupoMWZQ/M81lBdGlCPewr+gNb
	xBtbWjFrvlidhLcrLaYQrp4A43O6R/xzrutEoL2Z4V/KR5SdmTnP5+/2ii3/myBu/8vj/tPZID5
	JKSpV1LumEVO/UoYhw2prd3zhrnmCmdmv80hhjJkAMiveGtuDO8AFQNlvHZIzm3LeX8/b2biws2
	n4gfPd9YyzRfHEL1I0YhGBWURBOj4uDLAdJHLSYrEWWVFrCRzBEriPmCK5fHY95JeDWSGhBHHpq
	JczVSNoM7QMeQDO365ASUMjhYTxqC97GZqDpNG2HtG4PWAaxtRSHkUICoIvGWJ81uq07+iXf8sb
	CXTsmIsYeidFAVOdXvWswKq
X-Received: by 2002:a05:600c:3b15:b0:489:1f3e:5f6f with SMTP id 5b1f17b1804b1-48a77ae5502mr48012065e9.12.1777376998426;
        Tue, 28 Apr 2026 04:49:58 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a773a870asm56926845e9.1.2026.04.28.04.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:49:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/5] libmultipath: TUR checker: use runner threads
Date: Tue, 28 Apr 2026 13:49:41 +0200
Message-ID: <20260428114942.292307-5-mwilck@suse.com>
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

Use the generic runners to simplify the TUR checker code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

