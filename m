Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83391426EDA
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468299; cv=none; b=YeAU6bmyP/54quy7zrYvj1rh1PeEBKMvY0WZr8ea6asvecfZAUHas/bVpRqPjpaiqMJ/kUhLmO2CVdO441w5XI62p/9uPswo18S+EqU3KUqKpoZdEmn2QZvpdbRY/uicviMYUYzM7LfHct+ecM6PQlV+Mf1/qs9gVIamJ76PVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468299; c=relaxed/simple;
	bh=lh88EDuub6FpQ4+j5Kx/ph+/X6yO8wxLvZSUX/h9Bco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITNNwVskAFTJ+WtHd8lmg47BB6p7/nDfMuzUSK5YeRW0JOXs+f7cWL9S3BoYuFGADpIc/rhEbBZYVzU5JgEMvQQ+UCHK5pmYpOVVkW4YXV+nQiEXGstlcvO+NjWsiSeZPXb45hZBRv0cHD0JHzTFIShKngaDt8M+mj13ie3/HwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ItsZ7ymC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ItsZ7ymC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso66205655e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468296; x=1780073096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jplMPxyOi97jTs3oKZR075rKOK4VqPKOWkEyY7kUAmw=;
        b=ItsZ7ymC6GthsXnN6ppjcSYmmDUb7o77LGJ79QLyeREsvu+ZIqXfRPpdzT63zlUUWD
         EuO6WDPr9grFZLvfJUdXc6Jyvx4OQOJ8+l/shrCaYC9pPfwkWSpve3JoisEp5ziEwrgg
         VzN9eJJbtaoCvcWMQ8gmGWd75etnErlAYYUao8yf8Zn1PqUwJ7L3J4aKNdfqTcSwEQTu
         H0zcOJsXJlz5EA4FRRJ2pDjXzEH7jUqU35P8OFS/oQrHgBzxtQKxX3f9jURAE7KDyP9a
         /CbReSaJPjod8nYWodsAc7NCUZqP29lfEl04IVrQu5iYZ9aBXWvHFsrJifBl1aVfeLMB
         gElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468296; x=1780073096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jplMPxyOi97jTs3oKZR075rKOK4VqPKOWkEyY7kUAmw=;
        b=Fw5APkRoY54EYiHVhZ0DCr1kEOcat1Qe+NJ181msjXGMJc0+/oRcMfCwzxBZE7nHm5
         Ar+bjrElx2KnatuDPey4rzFY7T5t52NkO2m1wPpYLDUn5Xbf8RijPsfNpCbILZplLtD1
         wWUK9wSchW0w1ZGzlYGzGqCwaXWsJK8J1dPM0CxEVuTXf2qjXSNnH22pxq/IVzWiZiU+
         kbm948XGENFaplyEsFdqSyw8TgO2/omj7UduXJT3l/xrasToxKmHvpYgiIaG4wS2iUR6
         TSaUq/dty3AH0o9AgasbJKpPP38XBhLjWXHj1sc1JReeDDr2peeeRSop1OmtzlxEX13H
         2OFg==
X-Forwarded-Encrypted: i=1; AFNElJ9TMP8+CiLRty+YlLEtqi7u5hFxuV84vNXWAkJIJNiiTBQHcACMhsDGImG0SnZ25NgS16wXlnoaTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyBydhO+vgCOgungBMOdsrYPKb+/WJVQmW6kQP+PtXxLQ9vE6tv
	Xh7vyuWPQNny1gwVVEeZh8QFlRfyNHxmi3nMPmtaJNfNJS3PAQSrcO1vMF8DSGVq8mo=
X-Gm-Gg: Acq92OHIi45cLRqx9naQsUJL4+V61FAKLnNWHtPP+Nom7W3fo7El3chNmUNojkUbfTC
	UEmfj9SB4VDApM0NDFyuoFK7FnEVEp7E8XyQowNOz19PW1+4nuF8cERjjpMfvg7vH4nVJa0BbZe
	vh6lm31n27ByuMbLbQoUf21Ij50L5bY48ESTqCqrhZeDCyUDVCWMWlq+enkwJ51drDW1LBwUiq/
	qajsif+qQWMkDsupYNq8ZS9nOg+r6aA/rD7ZpsVUUZJsnoy3Svd/eGD4P++UntHZhj5tWnjm68L
	eBbWX2PyPVF/dbKOrBqw7LlpNijuGU9VuwOrU/VKi7eaFq9SMvL103D3lhgO8m7NmGdP3M38Rwt
	0U9ZgE8W2xZA65u4i3Qx7cPf+Rysd7BZUCD4b2YAxu0BmaG6BpQZQoym6sTO2QF4MOuybDw0396
	z1OYRoTu1LND7sxYHlWKOYFXWCCo71LwZMbmZgRfGrGuFFKlZ+X6HqwBBfaMRlSbzKPwsTvrkTU
	aKWUZYCspqiygipEPKKp7Ns
X-Received: by 2002:a05:600c:8889:10b0:48f:fe2a:1089 with SMTP id 5b1f17b1804b1-490424a12f4mr50269465e9.5.1779468295778;
        Fri, 22 May 2026 09:44:55 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6d5cb9asm5926404f8f.27.2026.05.22.09.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/19] libmultipath: convert TUR checker to an async checker instance
Date: Fri, 22 May 2026 18:44:08 +0200
Message-ID: <20260522164415.846589-13-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TUR checker now just exports the message table and the
"libcheck_async_func" symbol. This converts it into an instance of
the generic async checker model.

With this change, struct checker_context isn't used any more and
can be removed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.h     |   3 -
 libmultipath/checkers/tur.c | 253 +++---------------------------------
 2 files changed, 15 insertions(+), 241 deletions(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 05dbd7c..4846ea9 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -180,9 +180,6 @@ void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable(struct checker *);
-struct checker_context {
-	struct checker_class *cls;
-};
 int checker_get_state(struct checker *c);
 bool checker_need_wait(struct checker *c);
 void checker_check (struct checker *, int);
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 6791172..62460cb 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -3,87 +3,29 @@
  *
  * Copyright (c) 2004 Christophe Varoqui
  */
-#include <stdlib.h>
-#include <string.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <sys/ioctl.h>
-#include <sys/sysmacros.h>
+#include <sys/types.h>
+
 #include <errno.h>
-#include <sys/time.h>
 
 #include "checkers.h"
-#include "debug.h"
+#include "async_checker.h"
 #include "sg_include.h"
-#include "runner.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
-#define MAX_NR_TIMEOUTS 1
 
 enum {
-	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
-	MSG_TUR_TIMEOUT,
-	MSG_TUR_FAILED,
-	MSG_TUR_TRANSITIONING,
+	MSG_TUR_TRANSITIONING = CHECKER_FIRST_MSGID,
 };
 
 #define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[IDX_(TUR_RUNNING)] = " still running",
-	[IDX_(TUR_TIMEOUT)] = " timed out",
-	[IDX_(TUR_FAILED)] = " failed to initialize",
 	[IDX_(TUR_TRANSITIONING)] = " reports path is transitioning",
 	NULL,
 };
 
-struct tur_data {
-	int fd;
-	dev_t devt;
-	unsigned int timeout;
-	int state;
-	short msgid;
-};
-
-struct tur_checker_context {
-	struct checker_context chkr;
-	int last_runner_state;
-	unsigned int nr_timeouts;
-	struct runner_context *rtx;
-	struct tur_data tdata;
-};
-
-int libcheck_init(struct checker *c)
-{
-	struct tur_checker_context *tcc;
-	struct stat sb;
-
-	tcc = calloc(1, sizeof(*tcc));
-	tcc->tdata.state = PATH_UNCHECKED;
-	tcc->tdata.fd = -1;
-	if (fstat(c->fd, &sb) == 0)
-		tcc->tdata.devt = sb.st_rdev;
-	tcc->chkr.cls = c->cls;
-	c->context = tcc;
-	return 0;
-}
-
-void libcheck_free (struct checker * c)
-{
-	struct tur_checker_context *tcc = c->context;
-
-	if (!tcc)
-		return;
-	c->context = NULL;
-	if (tcc->rtx)
-		release_runner(tcc->rtx);
-	free(tcc);
-}
-
-static int
-tur_check(int fd, unsigned int timeout, short *msgid)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
@@ -99,14 +41,14 @@ retry:
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = timeout * 1000;
+	io_hdr.timeout = rdata->timeout * 1000;
 	io_hdr.pack_id = 0;
-	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+	if (ioctl(rdata->fd, SG_IO, &io_hdr) < 0) {
 		if (errno == ENOTTY) {
-			*msgid = CHECKER_MSGID_UNSUPPORTED;
+			rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 			return PATH_WILD;
 		}
-		*msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -114,7 +56,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		*msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -159,14 +101,14 @@ retry:
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * TARGET PORT IN STANDBY STATE
 				 */
-				*msgid = CHECKER_MSGID_GHOST;
+				rdata->msgid = CHECKER_MSGID_GHOST;
 				return PATH_GHOST;
 			} else if (asc == 0x04 && ascq == 0x0a) {
 				/*
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * ASYMMETRIC ACCESS STATE TRANSITION
 				 */
-				*msgid = MSG_TUR_TRANSITIONING;
+				rdata->msgid = MSG_TUR_TRANSITIONING;
 				return PATH_PENDING;
 			}
 		} else if (key == 0x5) {
@@ -176,178 +118,13 @@ retry:
 				 * LUN NOT SUPPORTED: unmapped at target.
 				 * Signals pp->disconnected, becomes PATH_DOWN.
 				 */
-				*msgid = CHECKER_MSGID_DISCONNECTED;
+				rdata->msgid = CHECKER_MSGID_DISCONNECTED;
 				return PATH_DISCONNECTED;
 			}
 		}
-		*msgid = CHECKER_MSGID_DOWN;
+		rdata->msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
 	}
-	*msgid = CHECKER_MSGID_UP;
+	rdata->msgid = CHECKER_MSGID_UP;
 	return PATH_UP;
 }
-
-/*
- * Test code for "zombie tur thread" handling.
- * Compile e.g. with CFLAGS=-DTUR_TEST_MAJOR=8
- * Additional parameters can be configure with the macros below.
- *
- * Everty nth started TUR thread will hang in non-cancellable state
- * for given number of seconds, for device given by major/minor.
- */
-#ifdef TUR_TEST_MAJOR
-
-#ifndef TUR_TEST_MINOR
-#define TUR_TEST_MINOR 0
-#endif
-#ifndef TUR_SLEEP_INTERVAL
-#define TUR_SLEEP_INTERVAL 3
-#endif
-#ifndef TUR_SLEEP_SECS
-#define TUR_SLEEP_SECS 60
-#endif
-
-static void tur_deep_sleep(const struct tur_data *tdata)
-{
-	static int sleep_cnt;
-	const struct timespec ts = { .tv_sec = TUR_SLEEP_SECS, .tv_nsec = 0 };
-	int oldstate;
-
-	if (tdata->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
-	    ++sleep_cnt % TUR_SLEEP_INTERVAL == 0)
-		return;
-
-	condlog(3, "tur thread going to sleep for %ld seconds", ts.tv_sec);
-	if (pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate) != 0)
-		condlog(0, "pthread_setcancelstate: %m");
-	if (nanosleep(&ts, NULL) != 0)
-		condlog(0, "nanosleep: %m");
-	condlog(3, "tur zombie thread woke up");
-	if (pthread_setcancelstate(oldstate, NULL) != 0)
-		condlog(0, "pthread_setcancelstate (2): %m");
-	pthread_testcancel();
-}
-#else
-#define tur_deep_sleep(x) do {} while (0)
-#endif /* TUR_TEST_MAJOR */
-
-void runner_callback(void *arg)
-{
-	struct tur_data *tdata = arg;
-	int state;
-
-	condlog(4, "%d:%d : tur checker starting up", major(tdata->devt),
-		minor(tdata->devt));
-
-	tur_deep_sleep(tdata);
-	state = tur_check(tdata->fd, tdata->timeout, &tdata->msgid);
-	tdata->state = state;
-	pthread_testcancel();
-	condlog(4, "%d:%d : tur checker finished, state %s", major(tdata->devt),
-		minor(tdata->devt), checker_state_name(state));
-}
-
-static int check_runner_state(struct tur_checker_context *tcc)
-{
-	struct runner_context *rtx = tcc->rtx;
-	int rc;
-
-	rc = check_runner(rtx, &tcc->tdata, sizeof(tcc->tdata));
-	switch (rc) {
-	case RUNNER_DEAD:
-		tcc->tdata.state = PATH_TIMEOUT;
-		tcc->tdata.msgid = MSG_TUR_TIMEOUT;
-		/* fallthrough */
-	case RUNNER_DONE:
-		release_runner(tcc->rtx);
-		tcc->rtx = NULL;
-		tcc->last_runner_state = rc;
-		tcc->nr_timeouts = 0;
-		condlog(rc == RUNNER_DONE ? 4 : 3,
-			"%d:%d : tur checker finished, state %s, runner state %s",
-			major(tcc->tdata.devt), minor(tcc->tdata.devt),
-			checker_state_name(tcc->tdata.state),
-			runner_state_name(rc));
-		break;
-	case RUNNER_CANCELLED:
-		tcc->last_runner_state = rc;
-		tcc->tdata.state = PATH_TIMEOUT;
-		tcc->tdata.msgid = MSG_TUR_TIMEOUT;
-		if (tcc->nr_timeouts < MAX_NR_TIMEOUTS) {
-			condlog(3, "%d:%d : tur checker timed out, releasing it",
-				major(tcc->tdata.devt), minor(tcc->tdata.devt));
-			tcc->nr_timeouts++;
-			release_runner(tcc->rtx);
-			tcc->rtx = NULL;
-		} else if (tcc->nr_timeouts == MAX_NR_TIMEOUTS) {
-			tcc->nr_timeouts++;
-			condlog(3, "%d:%d : tur checker timed out, waiting for it",
-				major(tcc->tdata.devt), minor(tcc->tdata.devt));
-		}
-		break;
-	default:
-		condlog(4, "%d:%d : tur checker still running",
-			major(tcc->tdata.devt), minor(tcc->tdata.devt));
-		tcc->tdata.msgid = MSG_TUR_RUNNING;
-		break;
-	}
-	return rc;
-}
-
-bool libcheck_need_wait(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-
-	return ct && ct->rtx;
-}
-
-int libcheck_pending(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	/* The if path checker isn't running, just return the exiting value. */
-	if (!ct || !ct->rtx)
-		return c->path_state;
-
-	/* This may nullify ct->rtx */
-	check_runner_state(ct);
-	c->msgid = ct->tdata.msgid;
-	return ct->tdata.state;
-}
-
-int libcheck_check(struct checker * c)
-{
-	struct tur_checker_context *ct = c->context;
-
-	if (!ct)
-		return PATH_UNCHECKED;
-
-	if (checker_is_sync(c))
-		return tur_check(c->fd, c->timeout, &c->msgid);
-
-	/* Handle the case that the checker just completed */
-	if (ct->rtx) {
-		check_runner_state(ct);
-		c->msgid = ct->tdata.msgid;
-		return ct->tdata.state;
-	}
-
-	/* create new checker thread */
-	ct->tdata.fd = c->fd;
-	ct->tdata.timeout = c->timeout;
-
-	ct->tdata.state = PATH_PENDING;
-	ct->tdata.msgid = MSG_TUR_RUNNING;
-	condlog(3, "%d:%d : starting checker", major(ct->tdata.devt),
-		minor(ct->tdata.devt));
-	ct->rtx = get_runner(runner_callback, &ct->tdata, sizeof(ct->tdata),
-			     1000000 * c->timeout);
-
-	if (ct->rtx) {
-		c->msgid = ct->tdata.msgid;
-		return ct->tdata.state;
-	} else {
-		condlog(3, "%d:%d : failed to start tur thread, using sync mode",
-			major(ct->tdata.devt), minor(ct->tdata.devt));
-		return tur_check(c->fd, c->timeout, &c->msgid);
-	}
-}
-- 
2.54.0

