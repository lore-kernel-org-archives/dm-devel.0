Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20F48B368
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995843; cv=none; b=f9z77BErmS9iWgKlhXX8eHj63byss9eSxh/A9QcwtAaqnUuc5oXAmQ6E9+3xDWqpjKOUmU2wfBYF5bXHEoUJZQvm28qssh2lmJgLc4Y4uN7ozlnkwUm1V+kA5xsPNMcEnzbcLLxI4vD+NV0vObffLbcZAIxOVcG2S3FZUGizKUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995843; c=relaxed/simple;
	bh=rydLwDt37b+7u0ctczWZPSyiIFtV1HmdrM9zAfyRJlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1MXg+De1BvlGSTbLBReEc96B34b0tTkRCGPMqRwa9wTqSDymk6dWn21m7NyWxjUyjqvOFsm8YkxUy7U0U19SceZLzGTQWl4EZZdVuXWIP617Td3EGH28GNmG37O+KgqE4oE/V/l7zk9oyifqUqigGv4B8X3Vz4UQQjpaGCPsyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Oa9KVM4b; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Oa9KVM4b"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so52057145e9.2
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995840; x=1778600640; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbFGj/BrrOoHBgeAESsMtYi8Tb0DILtMUqX87XrbV2Q=;
        b=Oa9KVM4bhQf+Ks/XBabSzF0GjOIynG8rOQfctQkRdDdJ+4YRoRugfDe6AmhX67/Gao
         gfZoOTTKBa5AlT7k3It++fmbbHJw2vfmfunvnehoUDSmt6JbMx2316Ny+biW+G2tSb7a
         nklu6161cVVSh7WLw82p88L/c4s48Nmn6yhTf6ogoQbU8odpD99voQ822J47DmrSqS4x
         D09wuABHGlVmaCzxQaCM6J2EEP79xSRGD/bWqBzgZLUCGjqNitpDux2pZ42iDPZNCM5Y
         qApQovfgfzQdLO6GHF8L/jaLHS6vUq7K497MMtayN4kvL3dBj24EEFhVHJtYt49uGKqA
         7MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995840; x=1778600640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xbFGj/BrrOoHBgeAESsMtYi8Tb0DILtMUqX87XrbV2Q=;
        b=NNGLOgZ5/sVYLRN0dq8QifWUHXF5VDnEQ8kph71SOI2zkdJLbruOGBIq8t9YxrdcBG
         RKPENsvXyld8NQ5jZDygrz6UloCG45mHIaeTgLUkrk3KS/keHZqOOqX7UEzH53XM2ZmM
         0GU+itRsnyGxB90vdA1E+NdGULCMtjEd8cpfw+3Pj4pZDtkszQ1DlYAcja7wFXi06UUA
         /1mATWzVchy7hJQ5KPU37thDYgCdTsTsoybRhh4hNtYq1ZUBMoYuIL/dqsErmNELF+SY
         PlfOW6I8RWEOXbAtQKwQIiFVQHibXbgoD0El26KwcXtFhWBE8hIi3ljJs1PhHjQr1Jv3
         i2FA==
X-Forwarded-Encrypted: i=1; AFNElJ+zrqUxDPUMYpWiONaBP7nvCbFQciNMWxzRl4QddfuDBAFrimOURaXYJUGO9Y5QH6f3Zin6G0KE9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwO/ssAACMphAQN91c3oTwfySfHvhaTrv1+c7xTCpfoaWaHoUNw
	ClEtAMLD15MM9giHgDrnZ+NehYZxSu0ibnxESlbgJEXLsopSr16iVqDpO5dd4z30Ya0=
X-Gm-Gg: AeBDieuOrTWGQuKjducVRxCjThp45bMagEFd/WL17AijXZscg2RRzxHxpKMl5Qj1KjC
	+KVx9OZzCNNf/rmwo3HziAR+NWg39O1rBMCjv1n6ShOJynLHfnikWxWfjIEv3Qhgb3ueT+ril7a
	8iQdENgixxaRBy/CkklPF3brsHC3i3lc4n/md+Vpc3utztz+wl3e6e8g+zrtQa1Dw+1dBiivag2
	sC0QzDLd+asY8YuCHJRmKQUoWRiBSu1K0zGbGIYwa/7HrORrPBRrAqvwljjizCZdr2dPBeOlz/u
	fb4o2sLr/bHgeZEKXipRSiqWJvObCySjNX3Vreo8+pFVE+ndzthKXA6inyVUTnNGZjPDK5NCfLE
	BQq5hu0Mum/YUozpiBMfzUFRV3iUsxyeMCHjyK0bGIma/ZIxugT0PeFmkpx0C5jqqrEgnB6VxiN
	U0T1CWii5yb/ypZdwqR2etkReOJSaNix+V2IayX6iG7n/1LiYoehJaJ97tLXFSetnfb2vB0+73T
	7AsjTOEKxPYn6Owd3KwaEwICwN9428XDj8=
X-Received: by 2002:a05:600c:a30a:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48a98871624mr170015705e9.1.1777995839755;
        Tue, 05 May 2026 08:43:59 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48d14c1ef96sm21857655e9.11.2026.05.05.08.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/18] libmultipath: convert TUR checker to an async checker instance
Date: Tue,  5 May 2026 17:43:25 +0200
Message-ID: <20260505154332.448054-12-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 251 +++---------------------------------
 1 file changed, 15 insertions(+), 236 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 6791172..757767a 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -3,87 +3,31 @@
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
+	MSG_TUR_FAILED = CHECKER_FIRST_MSGID,
 	MSG_TUR_TRANSITIONING,
 };
 
 #define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
 const char *libcheck_msgtable[] = {
-	[IDX_(TUR_RUNNING)] = " still running",
-	[IDX_(TUR_TIMEOUT)] = " timed out",
 	[IDX_(TUR_FAILED)] = " failed to initialize",
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
@@ -99,14 +43,14 @@ retry:
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
@@ -114,7 +58,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		*msgid = CHECKER_MSGID_UP;
+		rdata->msgid = CHECKER_MSGID_UP;
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -159,14 +103,14 @@ retry:
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
@@ -176,178 +120,13 @@ retry:
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

