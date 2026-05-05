Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843FA48AE35
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995840; cv=none; b=Lly751QIutfvNxeP41ng+nIlbsEdLUhkeFTlLtdDSLgw3XNpk+EVD33jB3oontv1nk9GBrmHcm+sZuD42jW05qPOD+MchUZRLPGLp9RdHgezXH0Xq2qZnQHOitDICuVl4ngy4q3oK2OrYz2lo7+LJrAtyJWjKhKM9b7QdfYNfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995840; c=relaxed/simple;
	bh=v8uNva+LdouYexPuU2sjZXoefdjCgIRzTdfbPRFRlNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8gmcGcVmR4fil13OEFLVkwaKgkGwEEqUh0DMu9H++gOVKYCPEjDYKZCCXTt3pTAIIwtN4p9NevwWL29aCHoE5O4ObPsqXAqSNKnSKtI+Aj9la6vbR9HmcJqKQESlYWvMaNZK7SK2mqvKOeUw+AS1mf8UcIKPLPgWKgXt+DrXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UGtp5Yl6; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UGtp5Yl6"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso29693625e9.3
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995837; x=1778600637; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpp55zoPIC2bbOFsUuCWAadxQP1Cb/VUb0GKSZCJrx8=;
        b=UGtp5Yl6G4IRY3VCC2CXhREVQ+eQ43+hiZDMNRLsmqCpgBMBLRKk2zzt20y7B2FN/u
         2AyG1dt8RkchXJt8yo9Xi8XKOn40X0NCAoeAPYuWltrKkcwCPDxTMSA+8CqhXgF1v6LO
         LW6yKZteZnftFjydoHKXII5OnDDNEk8umFh28+GsrA/LJbDL5lGMRB1CmxsSiiuEKeCG
         IWqbb5t+vTqFE9cxQnQWcHiRIXFGjxrzTWAwfuRdz54e4cvEGSCCQDdQdTV1UbATmL/G
         0j47AyYT7ljImok+b28/yiFab3EaLWyGcUkpbH/CYkpEPxGYe52lHkXoEjTg3v2EhNMy
         YorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995837; x=1778600637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lpp55zoPIC2bbOFsUuCWAadxQP1Cb/VUb0GKSZCJrx8=;
        b=rRIpy/pszwdut71cuu3shuPhaQDcz2pLpIAUL7sVnUoCPMe2gVarqujsdCCbi3QA/1
         xTmCIvOhmlRS7gh+rNZQS6c4t19/9Cew7a4JSDyJANVy+VOISmvLoKNPFcOytaTVXb5Z
         zxkBb72N2Sqpu2MMmmhslJFvevIoEsFTft5r1+hsuzU1oidDhU1jiJBunwDLKy09Rz7/
         Bj0UQiQ8QtjhIn/ZhdbynVd6aihiMENwcaI5meiEuK0d1AiF1Y7QxmmLdOXmcH23Lekv
         wnhVKHm87/Mak6YuhW8HyhyMtbWmxoXRwT/uzHIUC1k2WMaeicq7G17qHpsSWtUMgtHr
         fHkw==
X-Forwarded-Encrypted: i=1; AFNElJ+7LdrnkX8MO8/+GxidFMCkH5jqAfarU3xcy6m85ewy6hu+mHYkB02sP+LNo5VZElmQuqCpEkXZ3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJX4bnJKhTZ8cqAIEC4YMURgVGqk9T1b4s/04Vy1TKlNEXOc//
	NroeT1LP+znL7b3BnX2G/g7O4XVNMPJ1H0esTUJIGENlCHdeJYTMsSTfknxhWIUwxiw=
X-Gm-Gg: AeBDietrs5neXjugzFfEIUUR7VVH08m06ADS+dKmR4VwSwPVl5k2tXtIIxOWV57GxYZ
	4sW1UVzVAHsJDKuo2benCDY2ZgTcpgn3WXm6MiCa7pDePdcMEJ+buYwucN6fhkUQp6RCu/CMZd/
	b6XpF2O6X68XyKB4ldo3AmKA1q+j6hBJ0EzZHurmPGgQm9+PYLdwpZ2fQoevOTaNUH9afQK9uij
	D+8IA797dyn2luj6NcfP53xqhhd9yKqQjq344dbuaWMk4buQblSOHHeE4Km+15wM+LPwNiAAcLG
	uufGnZRtUFHE/2PcnnisKtbGXMsvMqJqfKj7+XibO0gYfql/GOBBq3KowM4Fp6ueLxjyak9xXaQ
	sVL7oZ433ErZDuJnGPBkqgQp0kUHObVQ2YxaBU3m+heWQJ28I/jzPZtxJzEg2ODm1nU0xFMsjFv
	uC1QhiIpcrI6AV4WTz7kQipBKVId34MTs93LSGYAYiuLzGBHCRehZShhkKeoYYI9mxtmYG0tpl1
	cmpgWZXLC1gG0Foix0BiVmv
X-Received: by 2002:a05:600c:26d4:b0:48b:339:73cf with SMTP id 5b1f17b1804b1-48b03397507mr125874955e9.1.1777995836584;
        Tue, 05 May 2026 08:43:56 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48d149de41asm34975525e9.2.2026.05.05.08.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/18] libmultipath: add generic async path checker code
Date: Tue,  5 May 2026 17:43:23 +0200
Message-ID: <20260505154332.448054-10-mwilck@suse.com>
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

Add a framework for an asynchronous path checker utilizing the
recently added runner code for thread handling.

This code has been derived from the TUR checker code by removing
all references to the actual sending of TUR ioctls.

Follow-up patches will convert the current TUR checker into an
instance of this async checker class.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile        |   2 +-
 libmultipath/async_checker.c | 216 +++++++++++++++++++++++++++++++++++
 libmultipath/async_checker.h |  35 ++++++
 libmultipath/checkers.c      |   1 +
 libmultipath/checkers.h      |   2 +
 5 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 libmultipath/async_checker.c
 create mode 100644 libmultipath/async_checker.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 85767ab..d71a835 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -22,7 +22,7 @@ OBJS-O := devmapper.o hwtable.o blacklist.o dmparser.o \
 	configure.o structs_vec.o sysfs.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o dm-generic.o generic.o nvme-lib.o \
-	libsg.o valid.o
+	libsg.o valid.o async_checker.o
 
 OBJS := $(OBJS-O) $(OBJS-U)
 
diff --git a/libmultipath/async_checker.c b/libmultipath/async_checker.c
new file mode 100644
index 0000000..06159dd
--- /dev/null
+++ b/libmultipath/async_checker.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2026 SUSE LLC
+
+#include <sys/types.h>
+#include <sys/sysmacros.h>
+#include <sys/stat.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include "async_checker.h"
+#include "checkers.h"
+#include "debug.h"
+#include "runner.h"
+
+#define MAX_NR_TIMEOUTS 1
+
+struct async_checker_context {
+	struct checker_context chkr;
+	int last_runner_state;
+	unsigned int nr_timeouts;
+	struct runner_context *rtx;
+	struct runner_data rdata;
+};
+
+#define rdata_size(acc) (sizeof(acc->rdata))
+
+int async_check_init(struct checker *c)
+{
+	struct async_checker_context *acc;
+	struct stat sb;
+
+	acc = calloc(1, sizeof(*acc));
+	if (!acc)
+		return -1;
+	acc->rdata.state = PATH_UNCHECKED;
+	acc->rdata.fd = -1;
+	if (fstat(c->fd, &sb) == 0)
+		acc->rdata.devt = sb.st_rdev;
+	acc->chkr.cls = c->cls;
+	c->context = acc;
+	return 0;
+}
+
+void async_check_free(struct checker *c)
+{
+	struct async_checker_context *acc = c->context;
+
+	if (!acc)
+		return;
+	c->context = NULL;
+	if (acc->rtx)
+		release_runner(acc->rtx);
+	free(acc);
+}
+
+static void runner_callback(void *arg)
+{
+	struct runner_data *rdata = arg;
+	int state;
+
+	condlog(4, "%d:%d : async checker starting up", major(rdata->devt),
+		minor(rdata->devt));
+
+	async_deep_sleep(rdata);
+	state = rdata->afunc(rdata);
+	rdata->state = state;
+	pthread_testcancel();
+	condlog(4, "%d:%d : async checker finished, state %s", major(rdata->devt),
+		minor(rdata->devt), checker_state_name(state));
+}
+
+static int check_runner_state(struct async_checker_context *acc)
+{
+	struct runner_context *rtx = acc->rtx;
+	int rc;
+
+	rc = check_runner(rtx, &acc->rdata, rdata_size(acc));
+	switch (rc) {
+	case RUNNER_DEAD:
+		acc->rdata.state = PATH_TIMEOUT;
+		acc->rdata.msgid = CHECKER_MSGID_TIMEOUT;
+		/* fallthrough */
+	case RUNNER_DONE:
+		release_runner(acc->rtx);
+		acc->rtx = NULL;
+		acc->last_runner_state = rc;
+		acc->nr_timeouts = 0;
+		condlog(rc == RUNNER_DONE ? 4 : 3,
+			"%d:%d : async checker finished, state %s, runner state %s",
+			major(acc->rdata.devt), minor(acc->rdata.devt),
+			checker_state_name(acc->rdata.state),
+			runner_state_name(rc));
+		break;
+	case RUNNER_CANCELLED:
+		acc->last_runner_state = rc;
+		acc->rdata.state = PATH_TIMEOUT;
+		acc->rdata.msgid = CHECKER_MSGID_TIMEOUT;
+		if (acc->nr_timeouts < MAX_NR_TIMEOUTS) {
+			condlog(3, "%d:%d : async checker timed out, releasing it",
+				major(acc->rdata.devt), minor(acc->rdata.devt));
+			acc->nr_timeouts++;
+			release_runner(acc->rtx);
+			acc->rtx = NULL;
+		} else if (acc->nr_timeouts == MAX_NR_TIMEOUTS) {
+			acc->nr_timeouts++;
+			condlog(3, "%d:%d : async checker timed out, waiting for it",
+				major(acc->rdata.devt), minor(acc->rdata.devt));
+		}
+		break;
+	default:
+		condlog(4, "%d:%d : async checker still running",
+			major(acc->rdata.devt), minor(acc->rdata.devt));
+		acc->rdata.msgid = CHECKER_MSGID_RUNNING;
+		break;
+	}
+	return rc;
+}
+
+bool async_check_need_wait(struct checker *c)
+{
+	struct async_checker_context *acc = c->context;
+
+	return acc && acc->rtx;
+}
+
+int async_check_pending(struct checker *c)
+{
+	struct async_checker_context *acc = c->context;
+	/* The if path checker isn't running, just return the exiting value. */
+	if (!acc || !acc->rtx)
+		return c->path_state;
+
+	/* This may nullify ct->rtx */
+	check_runner_state(acc);
+	c->msgid = acc->rdata.msgid;
+	return acc->rdata.state;
+}
+
+int async_check_check(struct checker *c)
+{
+	struct async_checker_context *acc = c->context;
+
+	if (!acc)
+		return PATH_UNCHECKED;
+
+	if (checker_is_sync(c))
+		return acc->rdata.afunc(&acc->rdata);
+
+	/* Handle the case that the checker just completed */
+	if (acc->rtx) {
+		check_runner_state(acc);
+		c->msgid = acc->rdata.msgid;
+		return acc->rdata.state;
+	}
+
+	/* create new checker thread */
+	acc->rdata.fd = c->fd;
+	acc->rdata.timeout = c->timeout;
+
+	acc->rdata.state = PATH_PENDING;
+	acc->rdata.msgid = CHECKER_MSGID_RUNNING;
+	acc->rdata.afunc = c->cls->async_func;
+	condlog(4, "%d:%d : starting checker", major(acc->rdata.devt),
+		minor(acc->rdata.devt));
+	acc->rtx = get_runner(runner_callback, &acc->rdata, rdata_size(acc),
+			      1000000 * c->timeout);
+
+	if (acc->rtx) {
+		c->msgid = acc->rdata.msgid;
+		return acc->rdata.state;
+	} else {
+		condlog(3, "%d:%d : failed to start async thread, using sync mode",
+			major(acc->rdata.devt), minor(acc->rdata.devt));
+		return acc->rdata.afunc(&acc->rdata);
+	}
+}
+
+/*
+ * Test code for "zombie tur thread" handling.
+ * Compile e.g. with CFLAGS=-DASYNC_TEST_MAJOR=8
+ * Additional parameters can be configure with the macros below.
+ *
+ * Everty nth started thread will hang in non-cancellable state
+ * for given number of seconds, for device given by major/minor.
+ */
+#ifdef ASYNC_TEST_MAJOR
+#ifndef ASYNC_TEST_MINOR
+#define ASYNC_TEST_MINOR 0
+#endif
+#ifndef ASYNC_SLEEP_INTERVAL
+#define ASYNC_SLEEP_INTERVAL 3
+#endif
+#ifndef ASYNC_SLEEP_SECS
+#define ASYNC_SLEEP_SECS 60
+#endif
+
+static void async_deep_sleep(const struct runner_data *rdata)
+{
+	static int sleep_cnt;
+	const struct timespec ts = {.tv_sec = ASYNC_SLEEP_SECS, .tv_nsec = 0};
+	int oldstate;
+
+	if (rdata->devt != makedev(ASYNC_TEST_MAJOR, ASYNC_TEST_MINOR) ||
+	    ++sleep_cnt % ASYNC_SLEEP_INTERVAL == 0)
+		return;
+
+	condlog(3, "async thread going to sleep for %ld seconds", ts.tv_sec);
+	if (pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate) != 0)
+		condlog(0, "pthread_setcancelstate: %m");
+	if (nanosleep(&ts, NULL) != 0)
+		condlog(0, "nanosleep: %m");
+	condlog(3, "async zombie thread woke up");
+	if (pthread_setcancelstate(oldstate, NULL) != 0)
+		condlog(0, "pthread_setcancelstate (2): %m");
+	pthread_testcancel();
+}
+#endif /* ASYNC_TEST_MAJOR */
diff --git a/libmultipath/async_checker.h b/libmultipath/async_checker.h
new file mode 100644
index 0000000..835de2a
--- /dev/null
+++ b/libmultipath/async_checker.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+// Copyright (c) 2026 SUSE LLC
+#ifndef ASYNC_CHECKER_H_INCLUDED
+#define ASYNC_CHECKER_H_INCLUDED
+
+struct runner_data;
+struct checker;
+typedef int (*async_checker_func)(struct runner_data *);
+
+struct runner_data {
+	int fd;
+	dev_t devt;
+	async_checker_func afunc;
+	unsigned int timeout;
+	int state;
+	short msgid;
+	char checker_ctx[];
+};
+
+int async_check_init(struct checker *c);
+void async_check_free(struct checker *c);
+bool async_check_need_wait(struct checker *c);
+int async_check_pending(struct checker *c);
+int async_check_check(struct checker *c);
+
+#define CHECKER_MAX_CONTEXT_SIZE 1024
+
+/* For testing handling of async checker timeouts */
+#ifdef ASYNC_TEST_MAJOR
+static void async_deep_sleep(const struct runner_data *rdata);
+#else
+#define async_deep_sleep(x) do {} while (0)
+#endif
+
+#endif
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index a3b9cc8..3a1663f 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -9,6 +9,7 @@
 
 #include "debug.h"
 #include "checkers.h"
+#include "async_checker.h"
 #include "vector.h"
 #include "util.h"
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 630e987..744be54 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -132,6 +132,7 @@ enum {
 };
 
 struct checker;
+struct runner_data;
 struct checker_class {
 	struct list_head node;
 	void *handle;
@@ -144,6 +145,7 @@ struct checker_class {
 	void (*reset)(void);		  /* to reset the global variables */
 	int (*pending)(struct checker *); /* to recheck pending paths */
 	bool (*need_wait)(struct checker *); /* checker needs waiting for */
+	int (*async_func)(struct runner_data *); /* callback for async_checker */
 	const char **msgtable;
 	short msgtable_size;
 };
-- 
2.54.0

