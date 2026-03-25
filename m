Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7077396D0C
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451991; cv=none; b=TLL/h8Qnii5sK+wUUFuX3Uzpdeklsg5eL6EVMKGJ7mbzQ+96J02l2PZS4yYXJCq7SKmvTPBnl4Vzayte/3/fl18cBXDtrzhthscqufLKyXWbCvRq54n61t0MxndNqmETppEOxjuweLb12BruWzD8L5EmCIe/1h4IZQmHMsTf63I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451991; c=relaxed/simple;
	bh=jlUjRcwVyz9rfQpDsRs9ONXzPqP4xM9juHkP63RKrus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWJEJjf4A6BPHCGwrc7i7x5u5FeLEZKz88/IgU0es+EmFxDe1Zh+6pw/74pFe2XMFoccLqRlfQDUYHgwm9iq0P6tteUibhin8dUCEppDATfbJZq4WRWG8cuSHWRkbIYV+HAd5wt0d5ZtDEmBcuZtYpUkd6cGZ/bHvq0ntBSkpJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OgVlZQHG; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OgVlZQHG"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1279eced0b9so7106107c88.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 08:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774451987; x=1775056787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxbZNwBdhranWNSV2BiQJs3TJJHOywsCT7h/jDM2ScU=;
        b=OgVlZQHGaRiOxGzTlZYe83xeKkBSQ70R+EIEqS7ijPE+F1+FiehqXdwm9rXfZQun02
         HSKRzgB9uZVnbuOSlGLWvR5lVcNrymCAucrvBn0RfBXAAiDCiv9WEa0/sOvuM8i7nzsx
         Nzv2nTtC23lBr15z/INo1MFadEN0YCUyb8Q6lQyC4y+RgshyPbrkSbC3ykli+ItN9buC
         rqPjK+thDhjqiYRxX79d3fbsGglPzIcG7jevz9vw07zt/xKj4rJrdhb5DT8MTP1bxMHU
         FnKu5Ks0go3TVV2LTOJ9LGC7qVorlCllAeI2C3ueWZaZPELMFGMw9eXi3Bwmw41QhQiy
         LeMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451987; x=1775056787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mxbZNwBdhranWNSV2BiQJs3TJJHOywsCT7h/jDM2ScU=;
        b=evsFXmTWmq9IvbxeKnLEKmu83knODd7Eh3Vil+gXU+MzJblM+4eAC2QMP9I8KET/EV
         H+GOZmNJog2a7+KdAJQQd9z2/I5x5MJy6wQNGyRWRbdyz8dbBzJEA2AuwMHRmwBhV8P5
         Aj3tuS6HNkIZxM3zVRiPSqB2dKY++Soy0Ortt+AtY4KuJL2zYChFN30SomWp2WFd1Kzu
         Gb4XIFhaCYOGeS0fVx1BUeVSV6jOecce6ZoxeLDkS3MSPAkTMmhh6QYoqZnZvL+sm3wj
         LTRtPDabk/9qLCkYW+Y8qwvCoyzPU9JNXd4vVtrWJUUd1cSncsFLl7Z1UQlabcNEs7aX
         HyVg==
X-Gm-Message-State: AOJu0YymZidvfR4F15os6M7u+i6lSXh4aN5D+MpMn9hWD53y519PyX+k
	P4YRfGt5xRHWfeNIBOb36i1XWLJaJerOqQGgVEK85k4EYRwyWPNn9ttfKt9a5gpATYYERW+skSY
	mF0eXwrd5OWGUVRNxViCrOIk0a7pjDIUdzx9gUVq/ih2bQ0YZMnWH7zr25zRdVi6C/muBf2IH/N
	tc8ddwm1/cgVRkHbwf9J5BdL58MZpEgjS+HXjs6SS8vK/B
X-Gm-Gg: ATEYQzyky2oo942IFk37KL1MOTVY0fXXGZGO3ETZCSMlE7qQrFAWmmlmKxH6AWeSYI8
	pf5CLs43yrTsNhCp7uQce4zz3IZXy5luDdK3KjScMC+kp/b0qzUROQojmc//iGu/YA+xD44yTtO
	qp4RO8YgkhvCNY/PB2AN1DnJXrIlwf8J4R8cIHoftEj76EBd7A/9JaIvkDfChoMtYKR28VGlWHk
	XDOwYn98uOuk/+Ioft6Crv6cq4DA1P2yVa/eft46IwOv3j0Mk0DhaxTQvU77tXYvtRo+749bYlJ
	i1HhUxsXnVZFFWAyZ4sq7YeR4uEGLIjUwiLlXAS7xGNXSBhk31Q4iSNLCpL2VFDRjMIhqwgfOHc
	R6QY1IlE/Zdbp0QMHqCX6wtiX49Ve4H6whUxV+1wvxiI6soGQJQ7A1z/eskq37H/sbbAV/RrQjY
	zDnCaPq20C1wbz3XbD3umB8uX39uCReo+8RCvAJhIbxDIDwFd2nZ7UKScLit4cvKpJ0AcsaqRVN
	N0WOiQWmswFpZBZ7545MR2hdFrzTIWSHc7ZHsDv46ElmDhn/ZsZ1ov3/s65irxBAQ==
X-Received: by 2002:a05:7022:6897:b0:12a:6f8b:36a3 with SMTP id a92af1059eb24-12a96e4911dmr1804129c88.6.1774451986193;
        Wed, 25 Mar 2026 08:19:46 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa6513e9bsm167355c88.0.2026.03.25.08.19.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Mar 2026 08:19:45 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mwilck@suse.com,
	bmarzins@redhat.com,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 1/2] checkers: add alua path checker and async checker framework
Date: Wed, 25 Mar 2026 08:19:34 -0700
Message-ID: <20260325151940.18928-2-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325151940.18928-1-brian@purestorage.com>
References: <20260325151940.18928-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an 'alua' path checker that uses RTPG to check path state. The
checker maps ALUA Asymmetric Access States to path states:
  - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
  - AAS_STANDBY -> PATH_GHOST
  - AAS_TRANSITIONING -> PATH_PENDING
  - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN

As part of this change, the common async threading infrastructure is
extracted from the TUR checker into a new async_checker base class.
Both TUR and ALUA checkers now extend this base, eliminating code
duplication and establishing a pattern for future async checkers.

Two fields are added to struct path (alua_state, alua_timestamp) to
cache ALUA state for use by prioritizers.

When detect_checker is enabled, the alua checker is auto-selected for
devices with TPGS support. Explicitly configured checkers in the
hardware table take precedence over auto-detection.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 libmultipath/Makefile                 |   2 +-
 libmultipath/async_checker.c          | 249 +++++++++++++++++++++
 libmultipath/async_checker.h          | 123 +++++++++++
 libmultipath/checkers.c               |   1 +
 libmultipath/checkers.h               |   1 +
 libmultipath/checkers/Makefile        |   3 +-
 libmultipath/checkers/alua.c          | 266 +++++++++++++++++++++++
 libmultipath/checkers/tur.c           | 302 ++++----------------------
 libmultipath/libmultipath.version     |   8 +
 libmultipath/prioritizers/alua.c      |  30 ---
 libmultipath/prioritizers/alua.h      |   8 +
 libmultipath/prioritizers/alua_rtpg.c |  62 +++++-
 libmultipath/prioritizers/alua_rtpg.h |   4 +
 libmultipath/propsel.c                |  16 +-
 libmultipath/structs.c                |   2 +
 libmultipath/structs.h                |   3 +
 multipath/multipath.conf.5.in         |  23 +-
 17 files changed, 795 insertions(+), 308 deletions(-)
 create mode 100644 libmultipath/async_checker.c
 create mode 100644 libmultipath/async_checker.h
 create mode 100644 libmultipath/checkers/alua.c

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 85767ab4..d71a835f 100644
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
index 00000000..25e00ca0
--- /dev/null
+++ b/libmultipath/async_checker.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Async path checker base class
+ *
+ * Provides common infrastructure for async path checkers.
+ * Based on the TUR checker by Christophe Varoqui.
+ *
+ * Copyright (c) 2026 Brian Bunker <brian@purestorage.com>
+ * Copyright (c) 2026 Krishna Kant <krishna.kant@purestorage.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <urcu.h>
+#include <urcu/uatomic.h>
+
+#include "async_checker.h"
+#include "checkers.h"
+#include "debug.h"
+#include "util.h"
+#include "time-util.h"
+
+#define MAX_NR_TIMEOUTS 1
+
+static void cleanup_context(struct async_checker_context *ct)
+{
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	free(ct);
+}
+
+void async_checker_cleanup_func(void *data)
+{
+	struct async_checker_context *ct = data;
+
+	if (!uatomic_sub_return(&ct->holders, 1))
+		cleanup_context(ct);
+}
+
+int async_checker_init(struct checker *c, size_t context_size)
+{
+	struct async_checker_context *ct;
+	struct stat sb;
+
+	ct = calloc(1, context_size);
+	if (!ct)
+		return 1;
+
+	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+	uatomic_set(&ct->holders, 1);
+	pthread_cond_init_mono(&ct->active);
+	pthread_mutex_init(&ct->lock, NULL);
+	if (fstat(c->fd, &sb) == 0)
+		ct->devt = sb.st_rdev;
+	ct->ctx.cls = c->cls;
+	c->context = ct;
+
+	return 0;
+}
+
+void async_checker_free(struct checker *c)
+{
+	struct async_checker_context *ct = c->context;
+
+	if (ct) {
+		if (uatomic_xchg(&ct->running, 0))
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+		if (!uatomic_sub_return(&ct->holders, 1))
+			cleanup_context(ct);
+		c->context = NULL;
+	}
+}
+
+void async_checker_set_timeout(struct checker *c)
+{
+	struct async_checker_context *ct = c->context;
+	struct timespec now;
+
+	get_monotonic_time(&now);
+	ct->time = now.tv_sec + c->timeout;
+}
+
+int async_checker_timeout_expired(struct checker *c)
+{
+	struct async_checker_context *ct = c->context;
+	struct timespec now;
+
+	get_monotonic_time(&now);
+	return (now.tv_sec > ct->time);
+}
+
+static int check_pending(struct checker *c, short running_msgid)
+{
+	struct async_checker_context *ct = c->context;
+	int status = PATH_PENDING;
+
+	pthread_mutex_lock(&ct->lock);
+	if (ct->state != PATH_PENDING || ct->msgid != running_msgid) {
+		status = ct->state;
+		c->msgid = ct->msgid;
+	}
+	pthread_mutex_unlock(&ct->lock);
+
+	if (status == PATH_PENDING && c->msgid == running_msgid) {
+		condlog(4, "%d:%d : async checker still running",
+			major(ct->devt), minor(ct->devt));
+	} else {
+		if (uatomic_xchg(&ct->running, 0))
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+	}
+
+	ct->checked_state = true;
+	return status;
+}
+
+bool async_checker_need_wait(struct checker *c)
+{
+	struct async_checker_context *ct = c->context;
+
+	if (!ct)
+		return false;
+	return (ct->thread && uatomic_read(&ct->running) != 0 &&
+		!ct->checked_state);
+}
+
+int async_checker_pending(struct checker *c, short running_msgid)
+{
+	struct async_checker_context *ct = c->context;
+
+	if (!ct || !ct->thread)
+		return c->path_state;
+
+	return check_pending(c, running_msgid);
+}
+
+int async_checker_check(struct checker *c, async_check_fn check_fn,
+			short running_msgid, short timeout_msgid)
+{
+	struct async_checker_context *ct = c->context;
+	pthread_attr_t attr;
+	int status;
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	/* Synchronous mode */
+	if (checker_is_sync(c)) {
+		ct->fd = c->fd;
+		ct->timeout = c->timeout;
+		return check_fn(c, ct, &c->msgid);
+	}
+
+	/* Async mode - check existing thread status */
+	if (ct->thread) {
+		ct->checked_state = true;
+		if (async_checker_timeout_expired(c)) {
+			if (uatomic_xchg(&ct->running, 0)) {
+				pthread_cancel(ct->thread);
+				condlog(3, "%d:%d : async checker timeout",
+					major(ct->devt), minor(ct->devt));
+				c->msgid = timeout_msgid;
+				status = PATH_TIMEOUT;
+			} else {
+				pthread_mutex_lock(&ct->lock);
+				status = ct->state;
+				c->msgid = ct->msgid;
+				pthread_mutex_unlock(&ct->lock);
+			}
+			ct->thread = 0;
+		} else if (uatomic_read(&ct->running) != 0) {
+			condlog(3, "%d:%d : async checker not finished",
+				major(ct->devt), minor(ct->devt));
+			status = PATH_PENDING;
+			c->msgid = running_msgid;
+		} else {
+			/* Checker done */
+			ct->thread = 0;
+			pthread_mutex_lock(&ct->lock);
+			status = ct->state;
+			c->msgid = ct->msgid;
+			pthread_mutex_unlock(&ct->lock);
+		}
+		return status;
+	}
+
+	/* Handle stalled thread */
+	if (uatomic_read(&ct->holders) > 1) {
+		if (ct->nr_timeouts == MAX_NR_TIMEOUTS) {
+			condlog(2, "%d:%d : waiting for stalled thread",
+				major(ct->devt), minor(ct->devt));
+			ct->nr_timeouts++;
+		}
+		if (ct->nr_timeouts > MAX_NR_TIMEOUTS) {
+			c->msgid = timeout_msgid;
+			return PATH_TIMEOUT;
+		}
+		ct->nr_timeouts++;
+		condlog(3, "%d:%d : async thread not responding",
+			major(ct->devt), minor(ct->devt));
+
+		/* Create new context, abandon stalled one */
+		if (async_checker_init(c, sizeof(*ct)) != 0) {
+			c->msgid = CHECKER_MSGID_DOWN;
+			return PATH_UNCHECKED;
+		}
+		((struct async_checker_context *)c->context)->nr_timeouts =
+			ct->nr_timeouts;
+
+		if (!uatomic_sub_return(&ct->holders, 1)) {
+			cleanup_context(ct);
+			((struct async_checker_context *)c->context)->nr_timeouts = 0;
+		}
+		ct = c->context;
+	} else
+		ct->nr_timeouts = 0;
+
+	/* Start new checker thread */
+	pthread_mutex_lock(&ct->lock);
+	status = ct->state = PATH_PENDING;
+	c->msgid = ct->msgid = running_msgid;
+	pthread_mutex_unlock(&ct->lock);
+	ct->fd = c->fd;
+	ct->timeout = c->timeout;
+	ct->checked_state = false;
+	uatomic_add(&ct->holders, 1);
+	uatomic_set(&ct->running, 1);
+	async_checker_set_timeout(c);
+	setup_thread_attr(&attr, 32 * 1024, 1);
+	if (start_checker_thread(&ct->thread, &attr, &ct->ctx)) {
+		pthread_attr_destroy(&attr);
+		uatomic_sub(&ct->holders, 1);
+		uatomic_set(&ct->running, 0);
+		ct->thread = 0;
+		condlog(3, "%d:%d : failed to start thread, using sync",
+			major(ct->devt), minor(ct->devt));
+		return check_fn(c, ct, &c->msgid);
+	}
+	pthread_attr_destroy(&attr);
+
+	return status;
+}
diff --git a/libmultipath/async_checker.h b/libmultipath/async_checker.h
new file mode 100644
index 00000000..62398405
--- /dev/null
+++ b/libmultipath/async_checker.h
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Async path checker base class
+ *
+ * Provides common infrastructure for async path checkers.
+ * Checkers like TUR and ALUA extend this base.
+ *
+ * Based on the TUR checker by Christophe Varoqui.
+ *
+ * Copyright (c) 2026 Brian Bunker <brian@purestorage.com>
+ * Copyright (c) 2026 Krishna Kant <krishna.kant@purestorage.com>
+ */
+#ifndef ASYNC_CHECKER_H_INCLUDED
+#define ASYNC_CHECKER_H_INCLUDED
+
+#include <pthread.h>
+#include <sys/types.h>
+#include <stdbool.h>
+#include <time.h>
+#include "checkers.h"
+
+/*
+ * Base context structure for async checkers.
+ * Derived checker contexts should embed this as their first member:
+ *
+ *   struct my_checker_context {
+ *       struct async_checker_context base;
+ *       // checker-specific fields...
+ *   };
+ */
+struct async_checker_context {
+	dev_t devt;
+	int state;
+	int running;		/* uatomic access only */
+	int fd;
+	unsigned int timeout;
+	time_t time;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t active;
+	int holders;		/* uatomic access only */
+	int msgid;
+	struct checker_context ctx;
+	unsigned int nr_timeouts;
+	bool checked_state;
+};
+
+/*
+ * Callback for the actual path check.
+ * Called synchronously or from the async thread.
+ *
+ * Parameters:
+ *   c      - checker structure
+ *   ct     - async context (cast to derived type if needed)
+ *   msgid  - output: message ID to set
+ *
+ * Returns: PATH_UP, PATH_DOWN, PATH_GHOST, PATH_PENDING, etc.
+ */
+typedef int (*async_check_fn)(struct checker *c,
+			      struct async_checker_context *ct,
+			      short *msgid);
+
+/*
+ * Initialize the base async checker context.
+ * Allocates context of given size and initializes common fields.
+ *
+ * Returns 0 on success, 1 on failure.
+ */
+int async_checker_init(struct checker *c, size_t context_size);
+
+/*
+ * Free the async checker context.
+ * Cancels any running thread and frees resources.
+ */
+void async_checker_free(struct checker *c);
+
+/*
+ * Main async check entry point.
+ * Handles sync/async modes, thread management, timeouts.
+ *
+ * Parameters:
+ *   c              - checker structure
+ *   check_fn       - callback for actual check
+ *   running_msgid  - message ID for "still running"
+ *   timeout_msgid  - message ID for timeout
+ */
+int async_checker_check(struct checker *c, async_check_fn check_fn,
+			short running_msgid, short timeout_msgid);
+
+/*
+ * Check if async operation is pending.
+ */
+int async_checker_pending(struct checker *c, short running_msgid);
+
+/*
+ * Check if we need to wait for the async thread.
+ */
+bool async_checker_need_wait(struct checker *c);
+
+/*
+ * Thread entry point. Checkers must define libcheck_thread that calls this.
+ */
+void *async_checker_thread(struct checker_context *ctx, async_check_fn check_fn,
+			   struct checker *c);
+
+/*
+ * Helper: set async timeout based on checker timeout.
+ */
+void async_checker_set_timeout(struct checker *c);
+
+/*
+ * Helper: check if async timeout has expired.
+ */
+int async_checker_timeout_expired(struct checker *c);
+
+/*
+ * Cleanup function for pthread_cleanup_push.
+ * Checkers should use this in their libcheck_thread.
+ */
+void async_checker_cleanup_func(void *data);
+
+#endif /* ASYNC_CHECKER_H_INCLUDED */
+
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index bb6ad1ee..21aa52d4 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -461,6 +461,7 @@ int init_checkers(void)
 		EMC_CLARIION,
 		READSECTOR0,
 		CCISS_TUR,
+		ALUA_RTPG,
 	};
 	unsigned int i;
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a969e7d1..2905f3fc 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -98,6 +98,7 @@ enum path_check_state {
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
+#define ALUA         "alua"
 #define NONE         "none"
 #define INVALID      "invalid"
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 6f7cfb95..dfdd13a1 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -17,7 +17,8 @@ LIBS= \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
-	libcheckrdac.so
+	libcheckrdac.so \
+	libcheckalua.so
 
 all: $(LIBS)
 
diff --git a/libmultipath/checkers/alua.c b/libmultipath/checkers/alua.c
new file mode 100644
index 00000000..bff1bed6
--- /dev/null
+++ b/libmultipath/checkers/alua.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ALUA Path Checker - uses RTPG to check path state
+ *
+ * Based on the TUR checker by Christophe Varoqui.
+ *
+ * Copyright (c) 2026 Brian Bunker <brian@purestorage.com>
+ * Copyright (c) 2026 Krishna Kant <krishna.kant@purestorage.com>
+ */
+#include <errno.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/sysmacros.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <urcu/uatomic.h>
+
+#include "async_checker.h"
+#include "checkers.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "time-util.h"
+#include "../prioritizers/alua.h"
+#include "../prioritizers/alua_rtpg.h"
+
+enum {
+	MSG_ALUA_RTPG_NOT_SUPPORTED = CHECKER_FIRST_MSGID,
+	MSG_ALUA_RTPG_TRANSITIONING,
+	MSG_ALUA_RUNNING,
+	MSG_ALUA_TIMEOUT,
+};
+
+#define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[IDX_(ALUA_RTPG_NOT_SUPPORTED)] = " ALUA not supported",
+	[IDX_(ALUA_RTPG_TRANSITIONING)] = " path is transitioning",
+	[IDX_(ALUA_RUNNING)] = " still running",
+	[IDX_(ALUA_TIMEOUT)] = " timed out",
+	NULL,
+};
+
+struct alua_checker_context {
+	struct async_checker_context base;	/* Must be first */
+	/* ALUA-specific cached data for prioritizer */
+	int aas;           /* Asymmetric Access State */
+	int tpg;           /* Target Port Group */
+	time_t timestamp;  /* When this data was collected */
+	/* Data needed for RTPG in thread - copied before thread starts */
+	unsigned int timeout_ms;
+};
+
+int libcheck_init(struct checker *c)
+{
+	int ret = async_checker_init(c, sizeof(struct alua_checker_context));
+	if (ret == 0) {
+		struct alua_checker_context *ct = c->context;
+		ct->aas = -1;
+		ct->tpg = -1;
+	}
+	return ret;
+}
+
+void libcheck_free(struct checker *c)
+{
+	async_checker_free(c);
+}
+
+/*
+ * Map ALUA Asymmetric Access State to path state
+ */
+static int alua_state_to_path_state(int aas, short *msgid)
+{
+	switch (aas & 0x0f) {
+	case AAS_OPTIMIZED:
+	case AAS_NON_OPTIMIZED:
+		*msgid = CHECKER_MSGID_UP;
+		return PATH_UP;
+	case AAS_STANDBY:
+		*msgid = CHECKER_MSGID_GHOST;
+		return PATH_GHOST;
+	case AAS_TRANSITIONING:
+		*msgid = MSG_ALUA_RTPG_TRANSITIONING;
+		return PATH_PENDING;
+	case AAS_UNAVAILABLE:
+	case AAS_OFFLINE:
+	default:
+		*msgid = CHECKER_MSGID_DOWN;
+		return PATH_DOWN;
+	}
+}
+
+/*
+ * Main ALUA check function - uses alua_rtpg.c library.
+ * This is called either in sync mode or from the async thread.
+ */
+static int
+alua_check(struct path *pp, int *aas_out, short *msgid)
+{
+	int aas;
+
+	/* Discover TPG ID if not already set */
+	if (pp->tpg_id == GROUP_ID_UNDEF) {
+		int tpg = get_target_port_group(pp);
+		if (tpg < 0) {
+			*msgid = CHECKER_MSGID_DOWN;
+			return PATH_DOWN;
+		}
+		pp->tpg_id = tpg;
+	}
+
+	aas = get_asymmetric_access_state(pp, pp->tpg_id);
+	if (aas < 0) {
+		if (aas == -RTPG_LUN_DISCONNECTED) {
+			*msgid = CHECKER_MSGID_DISCONNECTED;
+			return PATH_DISCONNECTED;
+		}
+		*msgid = CHECKER_MSGID_DOWN;
+		return PATH_DOWN;
+	}
+
+	*aas_out = aas;
+	return alua_state_to_path_state(aas, msgid);
+}
+
+#define alua_thread_cleanup_push(ct) \
+	pthread_cleanup_push(async_checker_cleanup_func, &(ct)->base)
+#define alua_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
+
+/*
+ * Async thread function.
+ * IMPORTANT: Do not access struct path from here - it may be freed.
+ * Use only data copied to context before thread start: fd, tpg, timeout_ms.
+ */
+void *libcheck_thread(struct checker_context *ctx)
+{
+	struct alua_checker_context *ct =
+		container_of(ctx, struct alua_checker_context, base.ctx);
+	struct timespec ts;
+	int state;
+	short msgid;
+	int aas;
+
+	/* This thread can be canceled, so setup clean up */
+	alua_thread_cleanup_push(ct);
+
+	condlog(4, "%d:%d : alua checker starting up", major(ct->base.devt),
+		minor(ct->base.devt));
+
+	/* Use fd-based check - path pointer is not safe here */
+	aas = get_asymmetric_access_state_fd(ct->base.fd, ct->tpg,
+					     ct->timeout_ms);
+	pthread_testcancel();
+
+	if (aas < 0) {
+		if (aas == -RTPG_LUN_DISCONNECTED) {
+			msgid = CHECKER_MSGID_DISCONNECTED;
+			state = PATH_DISCONNECTED;
+		} else {
+			msgid = CHECKER_MSGID_DOWN;
+			state = PATH_DOWN;
+		}
+		aas = -1;
+	} else {
+		state = alua_state_to_path_state(aas, &msgid);
+	}
+
+	/* Store results in context - will be copied to path by libcheck_check */
+	get_monotonic_time(&ts);
+	pthread_mutex_lock(&ct->base.lock);
+	ct->base.state = state;
+	ct->base.msgid = msgid;
+	ct->aas = aas;
+	ct->timestamp = ts.tv_sec;
+	pthread_cond_signal(&ct->base.active);
+	pthread_mutex_unlock(&ct->base.lock);
+
+	condlog(4, "%d:%d : alua checker finished, state %s", major(ct->base.devt),
+		minor(ct->base.devt), checker_state_name(state));
+
+	if (!uatomic_xchg(&ct->base.running, 0))
+		pause();
+
+	alua_thread_cleanup_pop(ct);
+
+	return ((void *)0);
+}
+
+bool libcheck_need_wait(struct checker *c)
+{
+	return async_checker_need_wait(c);
+}
+
+int libcheck_pending(struct checker *c)
+{
+	return async_checker_pending(c, MSG_ALUA_RUNNING);
+}
+
+/*
+ * Sync mode callback for async_checker_check.
+ * Safe to access path here since we're in the main thread.
+ */
+static int alua_check_callback(struct checker *c,
+			       struct async_checker_context *base_ct
+					__attribute__((unused)),
+			       short *msgid)
+{
+	struct path *pp = container_of(c, struct path, checker);
+	struct timespec ts;
+	int aas = -1;
+	int state;
+
+	state = alua_check(pp, &aas, msgid);
+
+	/* Cache ALUA state for prioritizer */
+	get_monotonic_time(&ts);
+	pp->alua_state = aas;
+	pp->alua_timestamp = ts.tv_sec;
+
+	return state;
+}
+
+int libcheck_check(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	struct path *pp = container_of(c, struct path, checker);
+	int status;
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	/*
+	 * For async mode: set up context data BEFORE thread starts.
+	 * The thread must not access struct path.
+	 */
+	if (!checker_is_sync(c)) {
+		/* Discover TPG ID if not already set */
+		if (pp->tpg_id == GROUP_ID_UNDEF) {
+			int tpg = get_target_port_group(pp);
+			if (tpg < 0) {
+				c->msgid = CHECKER_MSGID_DOWN;
+				return PATH_DOWN;
+			}
+			pp->tpg_id = tpg;
+		}
+		ct->tpg = pp->tpg_id;
+		ct->timeout_ms = get_prio_timeout_ms(pp);
+	}
+
+	status = async_checker_check(c, alua_check_callback,
+				     MSG_ALUA_RUNNING, MSG_ALUA_TIMEOUT);
+
+	/*
+	 * After async thread completes, copy cached state to path.
+	 * In sync mode, the callback already updated the path directly.
+	 */
+	if (!checker_is_sync(c) && status != PATH_PENDING) {
+		pp->alua_state = ct->aas;
+		pp->alua_timestamp = ct->timestamp;
+	}
+
+	return status;
+}
+
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ba4ca683..49a505c3 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -3,31 +3,25 @@
  *
  * Copyright (c) 2004 Christophe Varoqui
  */
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/sysmacros.h>
-#include <errno.h>
-#include <sys/time.h>
-#include <pthread.h>
-#include <urcu.h>
+#include <sys/types.h>
+#include <unistd.h>
 #include <urcu/uatomic.h>
 
+#include "async_checker.h"
 #include "checkers.h"
-
 #include "debug.h"
 #include "sg_include.h"
-#include "util.h"
-#include "time-util.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
-#define MAX_NR_TIMEOUTS 1
 
 enum {
 	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
@@ -46,69 +40,17 @@ const char *libcheck_msgtable[] = {
 };
 
 struct tur_checker_context {
-	dev_t devt;
-	int state;
-	int running; /* uatomic access only */
-	int fd;
-	unsigned int timeout;
-	time_t time;
-	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t active;
-	int holders; /* uatomic access only */
-	int msgid;
-	struct checker_context ctx;
-	unsigned int nr_timeouts;
-	bool checked_state;
+	struct async_checker_context base;	/* Must be first */
 };
 
-int libcheck_init (struct checker * c)
+int libcheck_init(struct checker *c)
 {
-	struct tur_checker_context *ct;
-	struct stat sb;
-
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
-	if (fstat(c->fd, &sb) == 0)
-		ct->devt = sb.st_rdev;
-	ct->ctx.cls = c->cls;
-	c->context = ct;
-
-	return 0;
+	return async_checker_init(c, sizeof(struct tur_checker_context));
 }
 
-static void cleanup_context(struct tur_checker_context *ct)
+void libcheck_free(struct checker *c)
 {
-	pthread_mutex_destroy(&ct->lock);
-	pthread_cond_destroy(&ct->active);
-	free(ct);
-}
-
-void libcheck_free (struct checker * c)
-{
-	if (c->context) {
-		struct tur_checker_context *ct = c->context;
-		int holders;
-		int running;
-
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
+	async_checker_free(c);
 }
 
 static int
@@ -216,19 +158,10 @@ retry:
 	return PATH_UP;
 }
 
-#define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
+#define tur_thread_cleanup_push(ct) \
+	pthread_cleanup_push(async_checker_cleanup_func, &(ct)->base)
 #define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
 
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
@@ -255,7 +188,7 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 	const struct timespec ts = { .tv_sec = TUR_SLEEP_SECS, .tv_nsec = 0 };
 	int oldstate;
 
-	if (ct->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
+	if (ct->base.devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
 	    ++sleep_cnt % TUR_SLEEP_INTERVAL != 0)
 		return;
 
@@ -276,32 +209,31 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 void *libcheck_thread(struct checker_context *ctx)
 {
 	struct tur_checker_context *ct =
-		container_of(ctx, struct tur_checker_context, ctx);
-	int state, running;
+		container_of(ctx, struct tur_checker_context, base.ctx);
+	int state;
 	short msgid;
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
 
-	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
-		minor(ct->devt));
+	condlog(4, "%d:%d : tur checker starting up", major(ct->base.devt),
+		minor(ct->base.devt));
 
 	tur_deep_sleep(ct);
-	state = tur_check(ct->fd, ct->timeout, &msgid);
+	state = tur_check(ct->base.fd, ct->base.timeout, &msgid);
 	pthread_testcancel();
 
 	/* TUR checker done */
-	pthread_mutex_lock(&ct->lock);
-	ct->state = state;
-	ct->msgid = msgid;
-	pthread_cond_signal(&ct->active);
-	pthread_mutex_unlock(&ct->lock);
+	pthread_mutex_lock(&ct->base.lock);
+	ct->base.state = state;
+	ct->base.msgid = msgid;
+	pthread_cond_signal(&ct->base.active);
+	pthread_mutex_unlock(&ct->base.lock);
 
-	condlog(4, "%d:%d : tur checker finished, state %s", major(ct->devt),
-		minor(ct->devt), checker_state_name(state));
+	condlog(4, "%d:%d : tur checker finished, state %s", major(ct->base.devt),
+		minor(ct->base.devt), checker_state_name(state));
 
-	running = uatomic_xchg(&ct->running, 0);
-	if (!running)
+	if (!uatomic_xchg(&ct->base.running, 0))
 		pause();
 
 	tur_thread_cleanup_pop(ct);
@@ -309,184 +241,28 @@ void *libcheck_thread(struct checker_context *ctx)
 	return ((void *)0);
 }
 
-static void tur_set_async_timeout(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	struct timespec now;
-
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
+/*
+ * Callback wrapper for async_checker_check.
+ */
+static int tur_check_callback(struct checker *c __attribute__((unused)),
+			      struct async_checker_context *ct,
+			      short *msgid)
 {
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
-		condlog(4, "%d:%d : tur checker still running",
-			major(ct->devt), minor(ct->devt));
-	} else {
-		int running = uatomic_xchg(&ct->running, 0);
-		if (running)
-			pthread_cancel(ct->thread);
-		ct->thread = 0;
-	}
-
-	ct->checked_state = true;
-	return tur_status;
+	return tur_check(ct->fd, ct->timeout, msgid);
 }
 
 bool libcheck_need_wait(struct checker *c)
 {
-	struct tur_checker_context *ct = c->context;
-	return (ct && ct->thread && uatomic_read(&ct->running) != 0 &&
-		!ct->checked_state);
+	return async_checker_need_wait(c);
 }
 
 int libcheck_pending(struct checker *c)
 {
-	struct tur_checker_context *ct = c->context;
-
-	/* The if path checker isn't running, just return the exiting value. */
-	if (!ct || !ct->thread)
-		return c->path_state;
-
-	return check_pending(c);
+	return async_checker_pending(c, MSG_TUR_RUNNING);
 }
 
-int libcheck_check(struct checker * c)
+int libcheck_check(struct checker *c)
 {
-	struct tur_checker_context *ct = c->context;
-	pthread_attr_t attr;
-	int tur_status, r;
-
-	if (!ct)
-		return PATH_UNCHECKED;
-
-	if (checker_is_sync(c))
-		return tur_check(c->fd, c->timeout, &c->msgid);
-
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
-	}
-
-	return tur_status;
+	return async_checker_check(c, tur_check_callback,
+				   MSG_TUR_RUNNING, MSG_TUR_TIMEOUT);
 }
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 78fa2d43..efcf1c71 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -219,12 +219,20 @@ global:
 	verify_paths;
 
 	/* checkers */
+	async_checker_check;
+	async_checker_cleanup_func;
+	async_checker_free;
+	async_checker_init;
+	async_checker_need_wait;
+	async_checker_pending;
 	checker_is_sync;
 	sg_read;
 	start_checker_thread;
 
 	/* prioritizers */
+	aas_print_string;
 	get_asymmetric_access_state;
+	get_asymmetric_access_state_fd;
 	get_prio_timeout_ms;
 	get_target_port_group;
 	get_target_port_group_support;
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index ec68f370..5b904abb 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -20,36 +20,6 @@
 
 #include "alua.h"
 
-#define ALUA_PRIO_NOT_SUPPORTED			1
-#define ALUA_PRIO_RTPG_FAILED			2
-#define ALUA_PRIO_GETAAS_FAILED			3
-#define ALUA_PRIO_TPGS_FAILED			4
-#define ALUA_PRIO_NO_INFORMATION		5
-
-static const char * aas_string[] = {
-	[AAS_OPTIMIZED]		= "active/optimized",
-	[AAS_NON_OPTIMIZED]	= "active/non-optimized",
-	[AAS_STANDBY]		= "standby",
-	[AAS_UNAVAILABLE]	= "unavailable",
-	[AAS_LBA_DEPENDENT]	= "logical block dependent",
-	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
-	[AAS_OFFLINE]		= "offline",
-	[AAS_TRANSITIONING]	= "transitioning between states",
-};
-
-static const char *aas_print_string(int rc)
-{
-	rc &= 0x7f;
-
-	if (rc & 0x70)
-		return aas_string[AAS_RESERVED];
-	rc &= 0x0f;
-	if (rc > AAS_RESERVED && rc < AAS_OFFLINE)
-		return aas_string[AAS_RESERVED];
-	else
-		return aas_string[rc];
-}
-
 int
 get_alua_info(struct path * pp)
 {
diff --git a/libmultipath/prioritizers/alua.h b/libmultipath/prioritizers/alua.h
index 88fd6af4..979f98bb 100644
--- a/libmultipath/prioritizers/alua.h
+++ b/libmultipath/prioritizers/alua.h
@@ -4,6 +4,14 @@
 #include "alua_rtpg.h"
 
 #define PRIO_ALUA "alua"
+
+/* ALUA prioritizer error codes */
+#define ALUA_PRIO_NOT_SUPPORTED			1
+#define ALUA_PRIO_RTPG_FAILED			2
+#define ALUA_PRIO_GETAAS_FAILED			3
+#define ALUA_PRIO_TPGS_FAILED			4
+#define ALUA_PRIO_NO_INFORMATION		5
+
 int prio_alua(struct path * pp);
 
 #endif
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 053cccb7..8475ec05 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -75,6 +75,7 @@ enum scsi_disposition {
 	SCSI_GOOD = 0,
 	SCSI_ERROR,
 	SCSI_RETRY,
+	SCSI_DISCONNECTED,
 };
 
 static int
@@ -124,6 +125,12 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
 	PRINT_DEBUG("alua: SCSI error for command %02x: status %02x, sense %02x/%02x/%02x",
 		    opcode, hdr->status, sense_key, asc, ascq);
 
+	/* Check for disconnected LUN (unmapped at target) */
+	if (sense_key == 0x5 && asc == 0x25 && ascq == 0x00) {
+		/* ILLEGAL REQUEST / LOGICAL UNIT NOT SUPPORTED */
+		return SCSI_DISCONNECTED;
+	}
+
 	if (sense_key == UNIT_ATTENTION || sense_key == NOT_READY)
 		return SCSI_RETRY;
 	else
@@ -169,7 +176,10 @@ retry:
 	}
 
 	rc = scsi_error(&hdr, OPERATION_CODE_INQUIRY);
-	if (rc == SCSI_ERROR) {
+	if (rc == SCSI_DISCONNECTED) {
+		PRINT_DEBUG("do_inquiry: LUN disconnected!");
+		return -RTPG_LUN_DISCONNECTED;
+	} else if (rc == SCSI_ERROR) {
 		PRINT_DEBUG("do_inquiry: SCSI error!");
 		return -RTPG_INQUIRY_FAILED;
 	} else if (rc == SCSI_RETRY) {
@@ -325,7 +335,10 @@ retry:
 	}
 
 	rc = scsi_error(&hdr, OPERATION_CODE_RTPG);
-	if (rc == SCSI_ERROR) {
+	if (rc == SCSI_DISCONNECTED) {
+		PRINT_DEBUG("do_rtpg: LUN disconnected (unmapped at target)!");
+		return -RTPG_LUN_DISCONNECTED;
+	} else if (rc == SCSI_ERROR) {
 		PRINT_DEBUG("do_rtpg: SCSI error!");
 		return -RTPG_RTPG_FAILED;
 	} else if (rc == SCSI_RETRY) {
@@ -339,8 +352,9 @@ retry:
 	return 0;
 }
 
-int
-get_asymmetric_access_state(const struct path *pp, unsigned int tpg)
+static int
+get_asymmetric_access_state_common(int fd, unsigned int tpg,
+				   unsigned int timeout_ms)
 {
 	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
@@ -348,8 +362,6 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg)
 	int			rc;
 	unsigned int		buflen;
 	uint64_t		scsi_buflen;
-	unsigned int		timeout_ms = get_prio_timeout_ms(pp);
-	int fd = pp->fd;
 
 	buflen = VPD_BUFLEN;
 	buf = (unsigned char *)malloc(buflen);
@@ -402,3 +414,41 @@ out:
 	free(buf);
 	return rc;
 }
+
+int
+get_asymmetric_access_state(const struct path *pp, unsigned int tpg)
+{
+	return get_asymmetric_access_state_common(pp->fd, tpg,
+						  get_prio_timeout_ms(pp));
+}
+
+int
+get_asymmetric_access_state_fd(int fd, unsigned int tpg,
+			       unsigned int timeout_ms)
+{
+	return get_asymmetric_access_state_common(fd, tpg, timeout_ms);
+}
+
+static const char * aas_string[] = {
+	[AAS_OPTIMIZED]		= "active/optimized",
+	[AAS_NON_OPTIMIZED]	= "active/non-optimized",
+	[AAS_STANDBY]		= "standby",
+	[AAS_UNAVAILABLE]	= "unavailable",
+	[AAS_LBA_DEPENDENT]	= "logical block dependent",
+	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
+	[AAS_OFFLINE]		= "offline",
+	[AAS_TRANSITIONING]	= "transitioning between states",
+};
+
+const char *aas_print_string(int rc)
+{
+	rc &= 0x7f;
+
+	if (rc & 0x70)
+		return aas_string[AAS_RESERVED];
+	rc &= 0x0f;
+	if (rc > AAS_RESERVED && rc < AAS_OFFLINE)
+		return aas_string[AAS_RESERVED];
+	else
+		return aas_string[rc];
+}
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index ff6ec0ef..2d086e00 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -21,9 +21,13 @@
 #define RTPG_NO_TPG_IDENTIFIER			2
 #define RTPG_RTPG_FAILED			3
 #define RTPG_TPG_NOT_FOUND			4
+#define RTPG_LUN_DISCONNECTED			5
 
 int get_target_port_group_support(const struct path *pp);
 int get_target_port_group(const struct path *pp);
 int get_asymmetric_access_state(const struct path *pp, unsigned int tpg);
+int get_asymmetric_access_state_fd(int fd, unsigned int tpg,
+				   unsigned int timeout_ms);
+const char *aas_print_string(int rc);
 
 #endif /* ALUA_RTPG_H_INCLUDED */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 56895c4b..020b84d7 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -682,6 +682,17 @@ int select_checker(struct config *conf, struct path *pp)
 
 	if (!pp->checker_timeout)
 		select_checker_timeout(conf, pp);
+	/*
+	 * Check explicit configuration first - don't override device-specific
+	 * checkers (e.g., rdac for NetApp, directio for some software-defined
+	 * storage) with auto-detected alua checker.
+	 */
+	do_set(checker_name, conf->overrides, ckr_name, overrides_origin);
+	do_set_from_hwe(checker_name, pp, ckr_name, hwe_origin);
+	do_set(checker_name, conf, ckr_name, conf_origin);
+	/*
+	 * Auto-detect only if no checker explicitly configured.
+	 */
 	if (pp->detect_checker == DETECT_CHECKER_ON) {
 		origin = autodetect_origin;
 		if (check_rdac(pp)) {
@@ -690,13 +701,10 @@ int select_checker(struct config *conf, struct path *pp)
 		}
 		(void)path_get_tpgs(pp);
 		if (pp->tpgs != TPGS_NONE && pp->tpgs != TPGS_UNDEF) {
-			ckr_name = TUR;
+			ckr_name = ALUA;
 			goto out;
 		}
 	}
-	do_set(checker_name, conf->overrides, ckr_name, overrides_origin);
-	do_set_from_hwe(checker_name, pp, ckr_name, hwe_origin);
-	do_set(checker_name, conf, ckr_name, conf_origin);
 	do_default(ckr_name, DEFAULT_CHECKER);
 out:
 	checker_get(c, ckr_name);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f4413127..6483a568 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -126,6 +126,8 @@ alloc_path (void)
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->tpg_id = GROUP_ID_UNDEF;
+		pp->alua_state = -1;
+		pp->alua_timestamp = 0;
 		pp->priority = PRIO_UNDEF;
 		pp->checkint = CHECKINT_UNDEF;
 		checker_clear(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9adedde2..c4bddee9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -444,6 +444,9 @@ struct path {
 	vector hwe;
 	struct gen_path generic_path;
 	int tpg_id;
+	/* Cached ALUA state from checker for prioritizer use */
+	int alua_state;		/* AAS value, -1 if not cached */
+	time_t alua_timestamp;	/* When alua_state was last updated */
 	enum ioctl_info_states ioctl_info;
 };
 
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 84cd1a0a..c65f85bf 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -353,6 +353,14 @@ EMC VNX families with Failover Mode 1 (Passive Not Ready(PNR)).
 Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
 accepts the optional prio_arg \fIexclusive_pref_bit\fR.
 .TP
+.I alua_cached
+(Hardware-dependent)
+Generate the path priority based on SCSI-3 ALUA settings, using cached state
+from the \fIalua\fR path checker when available. Falls back to sysfs or direct
+RTPG if cached state is unavailable. This prioritizer is auto-selected when
+using the \fIalua\fR checker with \fIdetect_prio\fR enabled.
+Accepts the optional prio_arg \fIexclusive_pref_bit\fR.
+.TP
 .I ontap
 (Hardware-dependent)
 Generate the path priority for NetApp ONTAP FAS/AFF Series and rebranded arrays,
@@ -515,9 +523,9 @@ The default is: \fB0\fR
 .TP
 .B path_checker
 The default method used to determine the path's state. The synchronous
-checkers (all except \fItur\fR and \fIdirectio\fR) will cause multipathd to
+checkers (all except \fItur\fR, \fIalua\fR, and \fIdirectio\fR) will cause multipathd to
 pause most activity, waiting up to \fIchecker_timeout\fR seconds for the path
-to respond. The asynchronous checkers (\fItur\fR and \fIdirectio\fR) will not
+to respond. The asynchronous checkers (\fItur\fR, \fIalua\fR, and \fIdirectio\fR) will not
 pause multipathd. Instead, multipathd will check for a response once per
 second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
 .RS
@@ -530,6 +538,13 @@ deprecated, please use \fItur\fR or \fIdirectio\fR instead.
 (Hardware-dependent)
 Issue a \fITEST UNIT READY\fR command to a SCSI device.
 .TP
+.I alua
+(Hardware-dependent)
+Issue a \fIREPORT TARGET PORT GROUPS\fR command to determine the path state
+from ALUA settings. This checker provides richer state information than
+\fItur\fR, including detection of transitioning and standby states. When used
+with the \fIalua_cached\fR prioritizer, avoids duplicate RTPG commands.
+.TP
 .I emc_clariion
 (Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
@@ -932,7 +947,9 @@ The default is: \fByes\fR
 if set to
 .I yes
 , multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
-device will automatically use the \fItur\fR checker. If set to
+device will automatically use the \fIalua\fR checker, which provides richer
+path state information than \fItur\fR. Explicitly configured checkers in the
+hardware table or overrides take precedence over auto-detection. If set to
 .I no
 , the checker will be selected as usual.
 .RS
-- 
2.50.1 (Apple Git-155)

